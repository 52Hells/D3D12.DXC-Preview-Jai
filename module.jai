#module_parameters (USE_D3D12_PREVIEW := false);

Shader_Type :: enum {
    Vertex;
    Fragment;
    Compute;
    Hull; // Also called Tessellation Control
    Domain; // Also called Tessellation Eval
    Mesh;
    Amplification;
    Library; // Used for raytracing pipelines
}

Dxc_Shader_Compiler_Args :: struct {
    shader_name: string;
    shader_source: string;
    shader_model_version: string;
    shader_type: Shader_Type;
    entry_point: string;
    defines: [] string;
    extra_args: [] string;
    add_debug_info: bool;
    warnings_as_error: bool;
    skip_optimization: bool;
    compile_as_spirv: bool;
    use_spirv_1_4: bool;
}

DXC_Compile :: (args: Dxc_Shader_Compiler_Args) -> [..]u8 #must {
    target: string;
    if args.shader_type == {
        case .Vertex;            target = tprint("vs_%", args.shader_model_version);
        case .Fragment;          target = tprint("ps_%", args.shader_model_version);
        case .Compute;           target = tprint("cs_%", args.shader_model_version);
        case .Hull;              target = tprint("hs_%", args.shader_model_version);
        case .Domain;            target = tprint("ds_%", args.shader_model_version);
        case .Mesh;              target = tprint("ms_%", args.shader_model_version);
        case .Amplification;     target = tprint("as_%", args.shader_model_version);
        case .Library;           target = tprint("lib_%", args.shader_model_version);
        case; assert(false);
    }

    dxc_utils : *IDxcUtils;
    dxc_compiler : *IDxcCompiler3;
    defer safe_release(dxc_utils);
    defer safe_release(dxc_compiler);

    result := DxcCreateInstance(*CLSID_DxcUtils, *IDxcUtils_UID, xx *dxc_utils);
    assert(result == S_OK);
    result = DxcCreateInstance(*CLSID_DxcCompiler, *IDxcCompiler3_UID, xx *dxc_compiler);
    assert(result == S_OK);

    // shader compiler arguments
    arguments: [..] string;
    arguments.allocator = temp;
    array_add(*arguments, args.shader_name);
    array_add(*arguments, "-E");
    array_add(*arguments, args.entry_point);
    array_add(*arguments, "-T");
    array_add(*arguments, target);
    array_add(*arguments, "-HV 2021");

    if args.compile_as_spirv {
        array_add(*arguments, "-spirv");
        array_add(*arguments, "-fvk-use-dx-layout");
        array_add(*arguments, "-fvk-use-dx-position-w");
        if args.use_spirv_1_4
            array_add(*arguments, "-fspv-target-env=vulkan1.1spirv1.4");
        else
            array_add(*arguments, "-fspv-target-env=vulkan1.3");
    }

    for args.defines {
        array_add(*arguments, "-D");
        array_add(*arguments, it);
    }

    for args.extra_args {
        array_add(*arguments, it);
    }

    if args.skip_optimization {
        array_add(*arguments, "-Od");           // Disable optimizations
    }
    if args.add_debug_info {
        array_add(*arguments, "-Zi");           // Enable debug information
        array_add(*arguments, "-Zss");          // Compute Shader Hash considering source information
        array_add(*arguments, "-Qembed_debug"); // Embed PDB in shader container (must be used with /Zi)
    }
    if args.warnings_as_error {
        array_add(*arguments, "-WX");           // Treat warnings as errors
    }

    // Dxc wants all its string arguments as wide strings
    arguments_wide: [..] *u16;
    arguments_wide.allocator = temp;

    for arguments {
        wide_string, success := utf8_to_wide(it,, temp);
        assert(success);
        array_add(*arguments_wide, wide_string);
    }

    handler : *IDxcIncludeHandler;
    result = IDxcUtils_CreateDefaultIncludeHandler(dxc_utils, *handler);
    assert(result == S_OK);
    defer safe_release(handler);

    shader_source_c_string := temp_c_string(args.shader_source);

    blob_encoding: *IDxcBlobEncoding;
    defer safe_release(blob_encoding);

    result = IDxcUtils_CreateBlobFromPinned(dxc_utils, shader_source_c_string, xx args.shader_source.count, cast(u32)CP_UTF8, *blob_encoding);
    assert(result == S_OK);

    shader_buffer : DxcBuffer;
    shader_buffer.Ptr      = IDxcBlob_GetBufferPointer(blob_encoding);
    shader_buffer.Size     = IDxcBlob_GetBufferSize(blob_encoding);
    shader_buffer.Encoding = 0;
    assert(shader_buffer.Ptr != null);
    assert(shader_buffer.Size > 0);

    dxc_result: *IDxcResult;
    defer safe_release(dxc_result);

    result = IDxcCompiler3_Compile(dxc_compiler, *shader_buffer, cast(**s16)arguments_wide.data, xx arguments_wide.count, handler, *IDxcResult_UID, xx *dxc_result);
    assert(result == S_OK);

    // Check the compiler status and printing out any errors
    IDxcOperationResult_GetStatus(dxc_result, *result);
    if result != S_OK {
        error_blob: *IDxcBlobUtf8;
        defer safe_release(error_blob);

        IDxcResult_GetOutput(dxc_result, .DXC_OUT_ERRORS, *IDxcBlobUtf8_UID, xx *error_blob, null);

        if error_blob && IDxcBlobUtf8_GetStringLength(error_blob) > 0
        {
            error_string := to_string(IDxcBlobUtf8_GetStringPointer(error_blob));
            log_error("Error while compiling shader: %\n", error_string);
        }
         empty :[..]u8;
         return empty;
    }
    binary_blog : *IDxcBlob;
    defer safe_release(binary_blog);

    result = IDxcOperationResult_GetResult(cast(*IDxcOperationResult)dxc_result, *binary_blog);
    assert(result == S_OK);

    binary_result: [..] u8;
    buffer_size := IDxcBlob_GetBufferSize(binary_blog);
    assert(buffer_size > 0);
    array_resize(*binary_result, xx buffer_size, false);
    memcpy(binary_result.data, IDxcBlob_GetBufferPointer(binary_blog), xx buffer_size);

    return binary_result; 
}

DXC_Reflect :: (dxil: []u8) -> *ID3D12ShaderReflection, bool {
    utils: *IDxcUtils;
    DxcCreateInstance(*CLSID_DxcUtils, *IDxcUtils_UID, xx *utils);

    buffer: DxcBuffer;
    buffer.Ptr = dxil.data;
    buffer.Size = xx dxil.count;

    reflection: *ID3D12ShaderReflection;
    desc: D3D12_SHADER_DESC;

    result := IDxcUtils_CreateReflection(utils, *buffer, *uid(ID3D12ShaderReflection_UUID), xx *reflection);
    if FAILED(result) return null, false;
    IUnknown_Release(utils);

    return reflection, true;
}

#scope_file

// Struct initialization lists and forward declared structs are not supported
// by the Jai generator. These values will be removed when support is added
CLSID_DxcUtils :: #run uid("6245D6AF-66E0-48FD-80B4-4D271796748C");
CLSID_DxcCompiler :: #run uid("73E22D93-E6CE-47F3-B5BF-F0664F39C1B0");
IDxcUtils_UID :: #run uid("4605C4CB-2019-492A-ADA4-65F20BB7D67F");
IDxcCompiler3_UID :: #run uid("228B4687-5A6A-4730-900C-9702B2203F54");
IDxcResult_UID :: #run uid("58346CDA-DDE7-4497-9461-6F87AF5E0659");
IDxcBlobUtf8_UID :: #run uid("3DA636C9-BA71-4024-A301-30CBF125305B");

#scope_module

IMalloc :: struct {};
IStream :: struct {};
BSTR :: struct {};

#load "dxcompiler_preview_bindings.jai";
#import "Windows_Utf8";
#import "Windows";
#if USE_D3D12_PREVIEW {
    #import "d3d12-preview";
} else {
    #import "d3d12";
}
