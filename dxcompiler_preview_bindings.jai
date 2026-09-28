//
// This file was auto-generated using the following command:
//
// jai modules/dxcompiler-preview/generate.jai
//



DXC_CP_UTF8 :: 65001;
DXC_CP_UTF16 :: 1200;
DXC_CP_UTF32 :: 12000;

DXC_CP_ACP :: 0;

DXC_CP_WIDE :: DXC_CP_UTF16;

DXC_HASHFLAG_INCLUDES_SOURCE :: 1;

/// \brief Typedef for DxcCreateInstance function pointer.
///
/// This can be used with GetProcAddress to get the DxcCreateInstance function.
DxcCreateInstanceProc :: #type (rclsid: *IID, riid: *IID, ppv: **void) -> HRESULT #c_call;

/// \brief Typedef for DxcCreateInstance2 function pointer.
///
/// This can be used with GetProcAddress to get the DxcCreateInstance2 function.
DxcCreateInstance2Proc :: #type (pMalloc: *IMalloc, rclsid: *IID, riid: *IID, ppv: **void) -> HRESULT #c_call;

/// \brief Creates a single uninitialized object of the class associated with a
/// specified CLSID.
///
/// \param rclsid The CLSID associated with the data and code that will be used
/// to create the object.
///
/// \param riid A reference to the identifier of the interface to be used to
/// communicate with the object.
///
/// \param ppv Address of pointer variable that receives the interface pointer
/// requested in riid.  Upon successful return, *ppv contains the requested
/// interface pointer. Upon failure, *ppv contains NULL.
///
/// While this function is similar to CoCreateInstance, there is no COM
/// involvement.
DxcCreateInstance :: (rclsid: *IID, riid: *IID, ppv: **void) -> HRESULT #foreign dxcompiler;
DxcCreateInstance :: (rclsid: IID, riid: IID, ppv: **void) -> HRESULT #no_context {
    return DxcCreateInstance(*rclsid, *riid, ppv);
}

/// \brief Version of DxcCreateInstance that takes an IMalloc interface.
///
/// This can be used to create an instance of the compiler with a custom memory
/// allocator.
DxcCreateInstance2 :: (pMalloc: *IMalloc, rclsid: *IID, riid: *IID, ppv: **void) -> HRESULT #foreign dxcompiler;
DxcCreateInstance2 :: (pMalloc: *IMalloc, rclsid: IID, riid: IID, ppv: **void) -> HRESULT #no_context {
    return DxcCreateInstance2(pMalloc, *rclsid, *riid, ppv);
}

/// Hash digest type for ShaderHash.
DxcShaderHash :: struct {
    Flags:      u32; ///< DXC_HASHFLAG_*
    HashDigest: [16] u8; ///< The hash digest
}

/// \brief A sized buffer that can be passed in and out of DXC APIs.
///
/// This is an alias of ID3D10Blob and ID3DBlob.
IDxcBlob :: struct {
    #as using iunknown: IUnknown;
    #place iunknown; idxcblob_vtable: *IDxcBlob_VTable;
}
IDxcBlob_VTable :: struct #type_info_none {
    using iunknown: IUnknown_VTable;
    GetBufferPointer: (this: *IDxcBlob) -> *void #cpp_method;
    GetBufferSize: (this: *IDxcBlob) -> SIZE_T #cpp_method;
}
IDxcBlob_GetBufferPointer :: inline (this: *IDxcBlob) -> *void { return this.idxcblob_vtable.GetBufferPointer(this); }
IDxcBlob_GetBufferSize :: inline (this: *IDxcBlob) -> SIZE_T { return this.idxcblob_vtable.GetBufferSize(this); }

vtable :: (obj: *IDxcBlob) -> *IDxcBlob_VTable { return obj.idxcblob_vtable; }


/// \brief A blob that might have a known encoding.
IDxcBlobEncoding :: struct {
    #as using idxcblob: IDxcBlob;
    #place idxcblob; idxcblobencoding_vtable: *IDxcBlobEncoding_VTable;
}
IDxcBlobEncoding_VTable :: struct #type_info_none {
    using idxcblob: IDxcBlob_VTable;
    GetEncoding: (this: *IDxcBlobEncoding, pKnown: *BOOL, pCodePage: *u32) -> HRESULT #cpp_method;
}
IDxcBlobEncoding_GetEncoding :: inline (this: *IDxcBlobEncoding, pKnown: *BOOL, pCodePage: *u32) -> HRESULT { return this.idxcblobencoding_vtable.GetEncoding(this, pKnown, pCodePage); }

vtable :: (obj: *IDxcBlobEncoding) -> *IDxcBlobEncoding_VTable { return obj.idxcblobencoding_vtable; }


/// \brief A blob containing a null-terminated wide string.
///
/// This uses the native wide character encoding (utf16 on Windows, utf32 on
/// Linux).
///
/// The value returned by GetBufferSize() is the size of the buffer, in bytes,
/// including the null-terminator.
///
/// This interface is used to return output name strings DXC.  Other string
/// output blobs, such as errors/warnings, preprocessed HLSL, or other text are
/// returned using encodings based on the -encoding option passed to the
/// compiler.
IDxcBlobWide :: struct {
    #as using idxcblobencoding: IDxcBlobEncoding;
    #place idxcblobencoding; idxcblobwide_vtable: *IDxcBlobWide_VTable;
}
IDxcBlobWide_VTable :: struct #type_info_none {
    using idxcblobencoding: IDxcBlobEncoding_VTable;
    GetStringPointer: (this: *IDxcBlobWide) -> *s16 #cpp_method;
    GetStringLength: (this: *IDxcBlobWide) -> SIZE_T #cpp_method;
}
IDxcBlobWide_GetStringPointer :: inline (this: *IDxcBlobWide) -> *s16 { return this.idxcblobwide_vtable.GetStringPointer(this); }
IDxcBlobWide_GetStringLength :: inline (this: *IDxcBlobWide) -> SIZE_T { return this.idxcblobwide_vtable.GetStringLength(this); }

vtable :: (obj: *IDxcBlobWide) -> *IDxcBlobWide_VTable { return obj.idxcblobwide_vtable; }


/// \brief A blob containing a UTF-8 encoded string.
///
/// The value returned by GetBufferSize() is the size of the buffer, in bytes,
/// including the null-terminator.
///
/// Depending on the -encoding option passed to the compiler, this interface is
/// used to return string output blobs, such as errors/warnings, preprocessed
/// HLSL, or other text. Output name strings always use IDxcBlobWide.
IDxcBlobUtf8 :: struct {
    #as using idxcblobencoding: IDxcBlobEncoding;
    #place idxcblobencoding; idxcblobutf8_vtable: *IDxcBlobUtf8_VTable;
}
IDxcBlobUtf8_VTable :: struct #type_info_none {
    using idxcblobencoding: IDxcBlobEncoding_VTable;
    GetStringPointer: (this: *IDxcBlobUtf8) -> *u8 #cpp_method;
    GetStringLength: (this: *IDxcBlobUtf8) -> SIZE_T #cpp_method;
}
IDxcBlobUtf8_GetStringPointer :: inline (this: *IDxcBlobUtf8) -> *u8 { return this.idxcblobutf8_vtable.GetStringPointer(this); }
IDxcBlobUtf8_GetStringLength :: inline (this: *IDxcBlobUtf8) -> SIZE_T { return this.idxcblobutf8_vtable.GetStringLength(this); }

vtable :: (obj: *IDxcBlobUtf8) -> *IDxcBlobUtf8_VTable { return obj.idxcblobutf8_vtable; }


/// IDxcBlobUtf16 is a legacy alias for IDxcBlobWide on Win32.
IDxcBlobUtf16 :: IDxcBlobWide;

/// \brief Interface for handling include directives.
///
/// This interface can be implemented to customize handling of include
/// directives.
///
/// Use IDxcUtils::CreateDefaultIncludeHandler to create a default
/// implementation that reads include files from the filesystem.
///
IDxcIncludeHandler :: struct {
    #as using iunknown: IUnknown;
    #place iunknown; idxcincludehandler_vtable: *IDxcIncludeHandler_VTable;
}
IDxcIncludeHandler_VTable :: struct #type_info_none {
    using iunknown: IUnknown_VTable;
    LoadSource: (this: *IDxcIncludeHandler, pFilename: *s16, ppIncludeSource: **IDxcBlob) -> HRESULT #cpp_method;
}
IDxcIncludeHandler_LoadSource :: inline (this: *IDxcIncludeHandler, pFilename: *s16, ppIncludeSource: **IDxcBlob) -> HRESULT { return this.idxcincludehandler_vtable.LoadSource(this, pFilename, ppIncludeSource); }

vtable :: (obj: *IDxcIncludeHandler) -> *IDxcIncludeHandler_VTable { return obj.idxcincludehandler_vtable; }


/// \brief Structure for supplying bytes or text input to Dxc APIs.
DxcBuffer :: struct {
    /// \brief Pointer to the start of the buffer.
    Ptr:      *void;

    /// \brief Size of the buffer in bytes.
    Size:     SIZE_T;

    /// \brief Encoding of the buffer.
    ///
    /// Use Encoding = 0 for non-text bytes, ANSI text, or unknown with BOM.
    Encoding: u32;
}

/// \brief Structure for supplying bytes or text input to Dxc APIs.
DxcText :: DxcBuffer;

/// \brief Structure for supplying defines to Dxc APIs.
DxcDefine :: struct {
    Name:  *s16; ///< The define name.
    Value: *s16; ///< Optional value for the define.
}

/// \brief Interface for managing arguments passed to DXC.
///
/// Use IDxcUtils::BuildArguments to create an instance of this interface.
IDxcCompilerArgs :: struct {
    #as using iunknown: IUnknown;
    #place iunknown; idxccompilerargs_vtable: *IDxcCompilerArgs_VTable;
}
IDxcCompilerArgs_VTable :: struct #type_info_none {
    using iunknown: IUnknown_VTable;
    GetArguments: (this: *IDxcCompilerArgs) -> **s16 #cpp_method;
    GetCount: (this: *IDxcCompilerArgs) -> u32 #cpp_method;
    AddArguments: (this: *IDxcCompilerArgs, pArguments: **s16, argCount: u32) -> HRESULT #cpp_method;
    AddArgumentsUTF8: (this: *IDxcCompilerArgs, pArguments: **u8, argCount: u32) -> HRESULT #cpp_method;
    AddDefines: (this: *IDxcCompilerArgs, pDefines: *DxcDefine, defineCount: u32) -> HRESULT #cpp_method;
}
IDxcCompilerArgs_GetArguments :: inline (this: *IDxcCompilerArgs) -> **s16 { return this.idxccompilerargs_vtable.GetArguments(this); }
IDxcCompilerArgs_GetCount :: inline (this: *IDxcCompilerArgs) -> u32 { return this.idxccompilerargs_vtable.GetCount(this); }
IDxcCompilerArgs_AddArguments :: inline (this: *IDxcCompilerArgs, pArguments: **s16, argCount: u32) -> HRESULT { return this.idxccompilerargs_vtable.AddArguments(this, pArguments, argCount); }
IDxcCompilerArgs_AddArgumentsUTF8 :: inline (this: *IDxcCompilerArgs, pArguments: **u8, argCount: u32) -> HRESULT { return this.idxccompilerargs_vtable.AddArgumentsUTF8(this, pArguments, argCount); }
IDxcCompilerArgs_AddDefines :: inline (this: *IDxcCompilerArgs, pDefines: *DxcDefine, defineCount: u32) -> HRESULT { return this.idxccompilerargs_vtable.AddDefines(this, pDefines, defineCount); }

vtable :: (obj: *IDxcCompilerArgs) -> *IDxcCompilerArgs_VTable { return obj.idxccompilerargs_vtable; }


//////////////////////////
// Legacy Interfaces
/////////////////////////
IDxcLibrary :: struct {
    #as using iunknown: IUnknown;
    #place iunknown; idxclibrary_vtable: *IDxcLibrary_VTable;
}
IDxcLibrary_VTable :: struct #type_info_none {
    using iunknown: IUnknown_VTable;
    SetMalloc: (this: *IDxcLibrary, pMalloc: *IMalloc) -> HRESULT #cpp_method;
    CreateBlobFromBlob: (this: *IDxcLibrary, pBlob: *IDxcBlob, offset: u32, length: u32, ppResult: **IDxcBlob) -> HRESULT #cpp_method;
    CreateBlobFromFile: (this: *IDxcLibrary, pFileName: *s16, codePage: *u32, pBlobEncoding: **IDxcBlobEncoding) -> HRESULT #cpp_method;
    CreateBlobWithEncodingFromPinned: (this: *IDxcLibrary, pText: *void, size: u32, codePage: u32, pBlobEncoding: **IDxcBlobEncoding) -> HRESULT #cpp_method;
    CreateBlobWithEncodingOnHeapCopy: (this: *IDxcLibrary, pText: *void, size: u32, codePage: u32, pBlobEncoding: **IDxcBlobEncoding) -> HRESULT #cpp_method;
    CreateBlobWithEncodingOnMalloc: (this: *IDxcLibrary, pText: *void, pIMalloc: *IMalloc, size: u32, codePage: u32, pBlobEncoding: **IDxcBlobEncoding) -> HRESULT #cpp_method;
    CreateIncludeHandler: (this: *IDxcLibrary, ppResult: **IDxcIncludeHandler) -> HRESULT #cpp_method;
    CreateStreamFromBlobReadOnly: (this: *IDxcLibrary, pBlob: *IDxcBlob, ppStream: **IStream) -> HRESULT #cpp_method;
    GetBlobAsUtf8: (this: *IDxcLibrary, pBlob: *IDxcBlob, pBlobEncoding: **IDxcBlobEncoding) -> HRESULT #cpp_method;
    GetBlobAsWide: (this: *IDxcLibrary, pBlob: *IDxcBlob, pBlobEncoding: **IDxcBlobEncoding) -> HRESULT #cpp_method;
}
IDxcLibrary_SetMalloc :: inline (this: *IDxcLibrary, pMalloc: *IMalloc) -> HRESULT { return this.idxclibrary_vtable.SetMalloc(this, pMalloc); }
IDxcLibrary_CreateBlobFromBlob :: inline (this: *IDxcLibrary, pBlob: *IDxcBlob, offset: u32, length: u32, ppResult: **IDxcBlob) -> HRESULT { return this.idxclibrary_vtable.CreateBlobFromBlob(this, pBlob, offset, length, ppResult); }
IDxcLibrary_CreateBlobFromFile :: inline (this: *IDxcLibrary, pFileName: *s16, codePage: *u32, pBlobEncoding: **IDxcBlobEncoding) -> HRESULT { return this.idxclibrary_vtable.CreateBlobFromFile(this, pFileName, codePage, pBlobEncoding); }
IDxcLibrary_CreateBlobWithEncodingFromPinned :: inline (this: *IDxcLibrary, pText: *void, size: u32, codePage: u32, pBlobEncoding: **IDxcBlobEncoding) -> HRESULT { return this.idxclibrary_vtable.CreateBlobWithEncodingFromPinned(this, pText, size, codePage, pBlobEncoding); }
IDxcLibrary_CreateBlobWithEncodingOnHeapCopy :: inline (this: *IDxcLibrary, pText: *void, size: u32, codePage: u32, pBlobEncoding: **IDxcBlobEncoding) -> HRESULT { return this.idxclibrary_vtable.CreateBlobWithEncodingOnHeapCopy(this, pText, size, codePage, pBlobEncoding); }
IDxcLibrary_CreateBlobWithEncodingOnMalloc :: inline (this: *IDxcLibrary, pText: *void, pIMalloc: *IMalloc, size: u32, codePage: u32, pBlobEncoding: **IDxcBlobEncoding) -> HRESULT { return this.idxclibrary_vtable.CreateBlobWithEncodingOnMalloc(this, pText, pIMalloc, size, codePage, pBlobEncoding); }
IDxcLibrary_CreateIncludeHandler :: inline (this: *IDxcLibrary, ppResult: **IDxcIncludeHandler) -> HRESULT { return this.idxclibrary_vtable.CreateIncludeHandler(this, ppResult); }
IDxcLibrary_CreateStreamFromBlobReadOnly :: inline (this: *IDxcLibrary, pBlob: *IDxcBlob, ppStream: **IStream) -> HRESULT { return this.idxclibrary_vtable.CreateStreamFromBlobReadOnly(this, pBlob, ppStream); }
IDxcLibrary_GetBlobAsUtf8 :: inline (this: *IDxcLibrary, pBlob: *IDxcBlob, pBlobEncoding: **IDxcBlobEncoding) -> HRESULT { return this.idxclibrary_vtable.GetBlobAsUtf8(this, pBlob, pBlobEncoding); }
IDxcLibrary_GetBlobAsWide :: inline (this: *IDxcLibrary, pBlob: *IDxcBlob, pBlobEncoding: **IDxcBlobEncoding) -> HRESULT { return this.idxclibrary_vtable.GetBlobAsWide(this, pBlob, pBlobEncoding); }

vtable :: (obj: *IDxcLibrary) -> *IDxcLibrary_VTable { return obj.idxclibrary_vtable; }


/// \brief The results of a DXC operation.
///
/// Note: IDxcResult replaces IDxcOperationResult and should be used wherever
/// possible.
IDxcOperationResult :: struct {
    #as using iunknown: IUnknown;
    #place iunknown; idxcoperationresult_vtable: *IDxcOperationResult_VTable;
}
IDxcOperationResult_VTable :: struct #type_info_none {
    using iunknown: IUnknown_VTable;
    GetStatus: (this: *IDxcOperationResult, pStatus: *HRESULT) -> HRESULT #cpp_method;
    GetResult: (this: *IDxcOperationResult, ppResult: **IDxcBlob) -> HRESULT #cpp_method;
    GetErrorBuffer: (this: *IDxcOperationResult, ppErrors: **IDxcBlobEncoding) -> HRESULT #cpp_method;
}
IDxcOperationResult_GetStatus :: inline (this: *IDxcOperationResult, pStatus: *HRESULT) -> HRESULT { return this.idxcoperationresult_vtable.GetStatus(this, pStatus); }
IDxcOperationResult_GetResult :: inline (this: *IDxcOperationResult, ppResult: **IDxcBlob) -> HRESULT { return this.idxcoperationresult_vtable.GetResult(this, ppResult); }
IDxcOperationResult_GetErrorBuffer :: inline (this: *IDxcOperationResult, ppErrors: **IDxcBlobEncoding) -> HRESULT { return this.idxcoperationresult_vtable.GetErrorBuffer(this, ppErrors); }

vtable :: (obj: *IDxcOperationResult) -> *IDxcOperationResult_VTable { return obj.idxcoperationresult_vtable; }


/// \deprecated Please use IDxcCompiler3 instead.
IDxcCompiler :: struct {
    #as using iunknown: IUnknown;
    #place iunknown; idxccompiler_vtable: *IDxcCompiler_VTable;
}
IDxcCompiler_VTable :: struct #type_info_none {
    using iunknown: IUnknown_VTable;
    Compile: (this: *IDxcCompiler, pSource: *IDxcBlob, pSourceName: *s16, pEntryPoint: *s16, pTargetProfile: *s16, pArguments: **s16, argCount: u32, pDefines: *DxcDefine, defineCount: u32, pIncludeHandler: *IDxcIncludeHandler, ppResult: **IDxcOperationResult) -> HRESULT #cpp_method;
    Preprocess: (this: *IDxcCompiler, pSource: *IDxcBlob, pSourceName: *s16, pArguments: **s16, argCount: u32, pDefines: *DxcDefine, defineCount: u32, pIncludeHandler: *IDxcIncludeHandler, ppResult: **IDxcOperationResult) -> HRESULT #cpp_method;
    Disassemble: (this: *IDxcCompiler, pSource: *IDxcBlob, ppDisassembly: **IDxcBlobEncoding) -> HRESULT #cpp_method;
}
IDxcCompiler_Compile :: inline (this: *IDxcCompiler, pSource: *IDxcBlob, pSourceName: *s16, pEntryPoint: *s16, pTargetProfile: *s16, pArguments: **s16, argCount: u32, pDefines: *DxcDefine, defineCount: u32, pIncludeHandler: *IDxcIncludeHandler, ppResult: **IDxcOperationResult) -> HRESULT { return this.idxccompiler_vtable.Compile(this, pSource, pSourceName, pEntryPoint, pTargetProfile, pArguments, argCount, pDefines, defineCount, pIncludeHandler, ppResult); }
IDxcCompiler_Preprocess :: inline (this: *IDxcCompiler, pSource: *IDxcBlob, pSourceName: *s16, pArguments: **s16, argCount: u32, pDefines: *DxcDefine, defineCount: u32, pIncludeHandler: *IDxcIncludeHandler, ppResult: **IDxcOperationResult) -> HRESULT { return this.idxccompiler_vtable.Preprocess(this, pSource, pSourceName, pArguments, argCount, pDefines, defineCount, pIncludeHandler, ppResult); }
IDxcCompiler_Disassemble :: inline (this: *IDxcCompiler, pSource: *IDxcBlob, ppDisassembly: **IDxcBlobEncoding) -> HRESULT { return this.idxccompiler_vtable.Disassemble(this, pSource, ppDisassembly); }

vtable :: (obj: *IDxcCompiler) -> *IDxcCompiler_VTable { return obj.idxccompiler_vtable; }


/// \deprecated Please use IDxcCompiler3 instead.
IDxcCompiler2 :: struct {
    #as using idxccompiler: IDxcCompiler;
    #place idxccompiler; idxccompiler2_vtable: *IDxcCompiler2_VTable;
}
IDxcCompiler2_VTable :: struct #type_info_none {
    using idxccompiler: IDxcCompiler_VTable;
    CompileWithDebug: (this: *IDxcCompiler2, pSource: *IDxcBlob, pSourceName: *s16, pEntryPoint: *s16, pTargetProfile: *s16, pArguments: **s16, argCount: u32, pDefines: *DxcDefine, defineCount: u32, pIncludeHandler: *IDxcIncludeHandler, ppResult: **IDxcOperationResult, ppDebugBlobName: **s16, ppDebugBlob: **IDxcBlob) -> HRESULT #cpp_method;
}
IDxcCompiler2_CompileWithDebug :: inline (this: *IDxcCompiler2, pSource: *IDxcBlob, pSourceName: *s16, pEntryPoint: *s16, pTargetProfile: *s16, pArguments: **s16, argCount: u32, pDefines: *DxcDefine, defineCount: u32, pIncludeHandler: *IDxcIncludeHandler, ppResult: **IDxcOperationResult, ppDebugBlobName: **s16, ppDebugBlob: **IDxcBlob) -> HRESULT { return this.idxccompiler2_vtable.CompileWithDebug(this, pSource, pSourceName, pEntryPoint, pTargetProfile, pArguments, argCount, pDefines, defineCount, pIncludeHandler, ppResult, ppDebugBlobName, ppDebugBlob); }

vtable :: (obj: *IDxcCompiler2) -> *IDxcCompiler2_VTable { return obj.idxccompiler2_vtable; }


/// \brief DXC linker interface.
///
/// Use DxcCreateInstance with CLSID_DxcLinker to obtain an instance of this
/// interface.
IDxcLinker :: struct {
    #as using iunknown: IUnknown;
    #place iunknown; idxclinker_vtable: *IDxcLinker_VTable;
}
IDxcLinker_VTable :: struct #type_info_none {
    using iunknown: IUnknown_VTable;
    RegisterLibrary: (this: *IDxcLinker, pLibName: *s16, pLib: *IDxcBlob) -> HRESULT #cpp_method;
    Link: (this: *IDxcLinker, pEntryName: *s16, pTargetProfile: *s16, pLibNames: **s16, libCount: u32, pArguments: **s16, argCount: u32, ppResult: **IDxcOperationResult) -> HRESULT #cpp_method;
}
IDxcLinker_RegisterLibrary :: inline (this: *IDxcLinker, pLibName: *s16, pLib: *IDxcBlob) -> HRESULT { return this.idxclinker_vtable.RegisterLibrary(this, pLibName, pLib); }
IDxcLinker_Link :: inline (this: *IDxcLinker, pEntryName: *s16, pTargetProfile: *s16, pLibNames: **s16, libCount: u32, pArguments: **s16, argCount: u32, ppResult: **IDxcOperationResult) -> HRESULT { return this.idxclinker_vtable.Link(this, pEntryName, pTargetProfile, pLibNames, libCount, pArguments, argCount, ppResult); }

vtable :: (obj: *IDxcLinker) -> *IDxcLinker_VTable { return obj.idxclinker_vtable; }


/////////////////////////
// Latest interfaces. Please use these.
////////////////////////
IDxcUtils :: struct {
    #as using iunknown: IUnknown;
    #place iunknown; idxcutils_vtable: *IDxcUtils_VTable;
}
IDxcUtils_VTable :: struct #type_info_none {
    using iunknown: IUnknown_VTable;
    CreateBlobFromBlob: (this: *IDxcUtils, pBlob: *IDxcBlob, offset: u32, length: u32, ppResult: **IDxcBlob) -> HRESULT #cpp_method;
    CreateBlobFromPinned: (this: *IDxcUtils, pData: *void, size: u32, codePage: u32, ppBlobEncoding: **IDxcBlobEncoding) -> HRESULT #cpp_method;
    MoveToBlob: (this: *IDxcUtils, pData: *void, pIMalloc: *IMalloc, size: u32, codePage: u32, ppBlobEncoding: **IDxcBlobEncoding) -> HRESULT #cpp_method;
    CreateBlob: (this: *IDxcUtils, pData: *void, size: u32, codePage: u32, ppBlobEncoding: **IDxcBlobEncoding) -> HRESULT #cpp_method;
    LoadFile: (this: *IDxcUtils, pFileName: *s16, pCodePage: *u32, ppBlobEncoding: **IDxcBlobEncoding) -> HRESULT #cpp_method;
    CreateReadOnlyStreamFromBlob: (this: *IDxcUtils, pBlob: *IDxcBlob, ppStream: **IStream) -> HRESULT #cpp_method;
    CreateDefaultIncludeHandler: (this: *IDxcUtils, ppResult: **IDxcIncludeHandler) -> HRESULT #cpp_method;
    GetBlobAsUtf8: (this: *IDxcUtils, pBlob: *IDxcBlob, ppBlobEncoding: **IDxcBlobUtf8) -> HRESULT #cpp_method;
    GetBlobAsWide: (this: *IDxcUtils, pBlob: *IDxcBlob, ppBlobEncoding: **IDxcBlobWide) -> HRESULT #cpp_method;
    GetDxilContainerPart: (this: *IDxcUtils, pShader: *DxcBuffer, DxcPart: u32, ppPartData: **void, pPartSizeInBytes: *u32) -> HRESULT #cpp_method;
    CreateReflection: (this: *IDxcUtils, pData: *DxcBuffer, iid: *IID, ppvReflection: **void) -> HRESULT #cpp_method;
    BuildArguments: (this: *IDxcUtils, pSourceName: *s16, pEntryPoint: *s16, pTargetProfile: *s16, pArguments: **s16, argCount: u32, pDefines: *DxcDefine, defineCount: u32, ppArgs: **IDxcCompilerArgs) -> HRESULT #cpp_method;
    GetPDBContents: (this: *IDxcUtils, pPDBBlob: *IDxcBlob, ppHash: **IDxcBlob, ppContainer: **IDxcBlob) -> HRESULT #cpp_method;
}
IDxcUtils_CreateBlobFromBlob :: inline (this: *IDxcUtils, pBlob: *IDxcBlob, offset: u32, length: u32, ppResult: **IDxcBlob) -> HRESULT { return this.idxcutils_vtable.CreateBlobFromBlob(this, pBlob, offset, length, ppResult); }
IDxcUtils_CreateBlobFromPinned :: inline (this: *IDxcUtils, pData: *void, size: u32, codePage: u32, ppBlobEncoding: **IDxcBlobEncoding) -> HRESULT { return this.idxcutils_vtable.CreateBlobFromPinned(this, pData, size, codePage, ppBlobEncoding); }
IDxcUtils_MoveToBlob :: inline (this: *IDxcUtils, pData: *void, pIMalloc: *IMalloc, size: u32, codePage: u32, ppBlobEncoding: **IDxcBlobEncoding) -> HRESULT { return this.idxcutils_vtable.MoveToBlob(this, pData, pIMalloc, size, codePage, ppBlobEncoding); }
IDxcUtils_CreateBlob :: inline (this: *IDxcUtils, pData: *void, size: u32, codePage: u32, ppBlobEncoding: **IDxcBlobEncoding) -> HRESULT { return this.idxcutils_vtable.CreateBlob(this, pData, size, codePage, ppBlobEncoding); }
IDxcUtils_LoadFile :: inline (this: *IDxcUtils, pFileName: *s16, pCodePage: *u32, ppBlobEncoding: **IDxcBlobEncoding) -> HRESULT { return this.idxcutils_vtable.LoadFile(this, pFileName, pCodePage, ppBlobEncoding); }
IDxcUtils_CreateReadOnlyStreamFromBlob :: inline (this: *IDxcUtils, pBlob: *IDxcBlob, ppStream: **IStream) -> HRESULT { return this.idxcutils_vtable.CreateReadOnlyStreamFromBlob(this, pBlob, ppStream); }
IDxcUtils_CreateDefaultIncludeHandler :: inline (this: *IDxcUtils, ppResult: **IDxcIncludeHandler) -> HRESULT { return this.idxcutils_vtable.CreateDefaultIncludeHandler(this, ppResult); }
IDxcUtils_GetBlobAsUtf8 :: inline (this: *IDxcUtils, pBlob: *IDxcBlob, ppBlobEncoding: **IDxcBlobUtf8) -> HRESULT { return this.idxcutils_vtable.GetBlobAsUtf8(this, pBlob, ppBlobEncoding); }
IDxcUtils_GetBlobAsWide :: inline (this: *IDxcUtils, pBlob: *IDxcBlob, ppBlobEncoding: **IDxcBlobWide) -> HRESULT { return this.idxcutils_vtable.GetBlobAsWide(this, pBlob, ppBlobEncoding); }
IDxcUtils_GetDxilContainerPart :: inline (this: *IDxcUtils, pShader: *DxcBuffer, DxcPart: u32, ppPartData: **void, pPartSizeInBytes: *u32) -> HRESULT { return this.idxcutils_vtable.GetDxilContainerPart(this, pShader, DxcPart, ppPartData, pPartSizeInBytes); }
IDxcUtils_CreateReflection :: inline (this: *IDxcUtils, pData: *DxcBuffer, iid: *IID, ppvReflection: **void) -> HRESULT { return this.idxcutils_vtable.CreateReflection(this, pData, iid, ppvReflection); }
IDxcUtils_BuildArguments :: inline (this: *IDxcUtils, pSourceName: *s16, pEntryPoint: *s16, pTargetProfile: *s16, pArguments: **s16, argCount: u32, pDefines: *DxcDefine, defineCount: u32, ppArgs: **IDxcCompilerArgs) -> HRESULT { return this.idxcutils_vtable.BuildArguments(this, pSourceName, pEntryPoint, pTargetProfile, pArguments, argCount, pDefines, defineCount, ppArgs); }
IDxcUtils_GetPDBContents :: inline (this: *IDxcUtils, pPDBBlob: *IDxcBlob, ppHash: **IDxcBlob, ppContainer: **IDxcBlob) -> HRESULT { return this.idxcutils_vtable.GetPDBContents(this, pPDBBlob, ppHash, ppContainer); }

vtable :: (obj: *IDxcUtils) -> *IDxcUtils_VTable { return obj.idxcutils_vtable; }


/// \brief Specifies the kind of output to retrieve from a IDxcResult.
///
/// Note: text outputs returned from version 2 APIs are UTF-8 or UTF-16 based on
/// the -encoding option passed to the compiler.
DXC_OUT_KIND :: enum s32 {
    NONE           :: 0;
    OBJECT         :: 1;
    ERRORS         :: 2;
    PDB            :: 3;
    SHADER_HASH    :: 4;

    DISASSEMBLY    :: 5;
    HLSL           :: 6;

    TEXT           :: 7;

    REFLECTION     :: 8;
    ROOT_SIGNATURE :: 9;
    EXTRA_OUTPUTS  :: 10;
    REMARKS        :: 11;

    TIME_REPORT    :: 12;

    TIME_TRACE     :: 13;

    LAST           :: 13;

    NUM_ENUMS      :: 14;
    FORCE_DWORD    :: -1;

    DXC_OUT_NONE           :: NONE;
    DXC_OUT_OBJECT         :: OBJECT;
    DXC_OUT_ERRORS         :: ERRORS;
    DXC_OUT_PDB            :: PDB;
    DXC_OUT_SHADER_HASH    :: SHADER_HASH;

    DXC_OUT_DISASSEMBLY    :: DISASSEMBLY;
    DXC_OUT_HLSL           :: HLSL;

    DXC_OUT_TEXT           :: TEXT;

    DXC_OUT_REFLECTION     :: REFLECTION;
    DXC_OUT_ROOT_SIGNATURE :: ROOT_SIGNATURE;
    DXC_OUT_EXTRA_OUTPUTS  :: EXTRA_OUTPUTS;
    DXC_OUT_REMARKS        :: REMARKS;

    DXC_OUT_TIME_REPORT    :: TIME_REPORT;

    DXC_OUT_TIME_TRACE     :: TIME_TRACE;

    DXC_OUT_LAST           :: LAST;

    DXC_OUT_NUM_ENUMS      :: NUM_ENUMS;
    DXC_OUT_FORCE_DWORD    :: FORCE_DWORD;
}

/// \brief Result of a DXC operation.
///
/// DXC operations may have multiple outputs, such as a shader object and
/// errors. This interface provides access to the outputs.
IDxcResult :: struct {
    #as using idxcoperationresult: IDxcOperationResult;
    #place idxcoperationresult; idxcresult_vtable: *IDxcResult_VTable;
}
IDxcResult_VTable :: struct #type_info_none {
    using idxcoperationresult: IDxcOperationResult_VTable;
    HasOutput: (this: *IDxcResult, dxcOutKind: DXC_OUT_KIND) -> BOOL #cpp_method;
    GetOutput: (this: *IDxcResult, dxcOutKind: DXC_OUT_KIND, iid: *IID, ppvObject: **void, ppOutputName: **IDxcBlobWide) -> HRESULT #cpp_method;
    GetNumOutputs: (this: *IDxcResult) -> u32 #cpp_method;
    GetOutputByIndex: (this: *IDxcResult, Index: u32) -> DXC_OUT_KIND #cpp_method;
    PrimaryOutput: (this: *IDxcResult) -> DXC_OUT_KIND #cpp_method;
}
IDxcResult_HasOutput :: inline (this: *IDxcResult, dxcOutKind: DXC_OUT_KIND) -> BOOL { return this.idxcresult_vtable.HasOutput(this, dxcOutKind); }
IDxcResult_GetOutput :: inline (this: *IDxcResult, dxcOutKind: DXC_OUT_KIND, iid: *IID, ppvObject: **void, ppOutputName: **IDxcBlobWide) -> HRESULT { return this.idxcresult_vtable.GetOutput(this, dxcOutKind, iid, ppvObject, ppOutputName); }
IDxcResult_GetNumOutputs :: inline (this: *IDxcResult) -> u32 { return this.idxcresult_vtable.GetNumOutputs(this); }
IDxcResult_GetOutputByIndex :: inline (this: *IDxcResult, Index: u32) -> DXC_OUT_KIND { return this.idxcresult_vtable.GetOutputByIndex(this, Index); }
IDxcResult_PrimaryOutput :: inline (this: *IDxcResult) -> DXC_OUT_KIND { return this.idxcresult_vtable.PrimaryOutput(this); }

vtable :: (obj: *IDxcResult) -> *IDxcResult_VTable { return obj.idxcresult_vtable; }


/// \brief Additional outputs from a DXC operation.
///
/// This can be used to obtain outputs that don't have an explicit DXC_OUT_KIND.
/// Use DXC_OUT_EXTRA_OUTPUTS to obtain instances of this.
IDxcExtraOutputs :: struct {
    #as using iunknown: IUnknown;
    #place iunknown; idxcextraoutputs_vtable: *IDxcExtraOutputs_VTable;
}
IDxcExtraOutputs_VTable :: struct #type_info_none {
    using iunknown: IUnknown_VTable;
    GetOutputCount: (this: *IDxcExtraOutputs) -> u32 #cpp_method;
    GetOutput: (this: *IDxcExtraOutputs, uIndex: u32, iid: *IID, ppvObject: **void, ppOutputType: **IDxcBlobWide, ppOutputName: **IDxcBlobWide) -> HRESULT #cpp_method;
}
IDxcExtraOutputs_GetOutputCount :: inline (this: *IDxcExtraOutputs) -> u32 { return this.idxcextraoutputs_vtable.GetOutputCount(this); }
IDxcExtraOutputs_GetOutput :: inline (this: *IDxcExtraOutputs, uIndex: u32, iid: *IID, ppvObject: **void, ppOutputType: **IDxcBlobWide, ppOutputName: **IDxcBlobWide) -> HRESULT { return this.idxcextraoutputs_vtable.GetOutput(this, uIndex, iid, ppvObject, ppOutputType, ppOutputName); }

vtable :: (obj: *IDxcExtraOutputs) -> *IDxcExtraOutputs_VTable { return obj.idxcextraoutputs_vtable; }


/// \brief Interface to the DirectX Shader Compiler.
///
/// Use DxcCreateInstance with CLSID_DxcCompiler to obtain an instance of this
/// interface.
IDxcCompiler3 :: struct {
    #as using iunknown: IUnknown;
    #place iunknown; idxccompiler3_vtable: *IDxcCompiler3_VTable;
}
IDxcCompiler3_VTable :: struct #type_info_none {
    using iunknown: IUnknown_VTable;
    Compile: (this: *IDxcCompiler3, pSource: *DxcBuffer, pArguments: **s16, argCount: u32, pIncludeHandler: *IDxcIncludeHandler, riid: *IID, ppResult: **void) -> HRESULT #cpp_method;
    Disassemble: (this: *IDxcCompiler3, pObject: *DxcBuffer, riid: *IID, ppResult: **void) -> HRESULT #cpp_method;
}
IDxcCompiler3_Compile :: inline (this: *IDxcCompiler3, pSource: *DxcBuffer, pArguments: **s16, argCount: u32, pIncludeHandler: *IDxcIncludeHandler, riid: *IID, ppResult: **void) -> HRESULT { return this.idxccompiler3_vtable.Compile(this, pSource, pArguments, argCount, pIncludeHandler, riid, ppResult); }
IDxcCompiler3_Disassemble :: inline (this: *IDxcCompiler3, pObject: *DxcBuffer, riid: *IID, ppResult: **void) -> HRESULT { return this.idxccompiler3_vtable.Disassemble(this, pObject, riid, ppResult); }

vtable :: (obj: *IDxcCompiler3) -> *IDxcCompiler3_VTable { return obj.idxccompiler3_vtable; }


DxcValidatorFlags_Default: u32 : 0;
DxcValidatorFlags_InPlaceEdit: u32 : 1;

DxcValidatorFlags_RootSignatureOnly: u32 : 2;
DxcValidatorFlags_ModuleOnly: u32 : 4;
DxcValidatorFlags_ValidMask: u32 : 7;

/// \brief Interface to DXC shader validator.
///
/// Use DxcCreateInstance with CLSID_DxcValidator to obtain an instance of this.
IDxcValidator :: struct {
    #as using iunknown: IUnknown;
    #place iunknown; idxcvalidator_vtable: *IDxcValidator_VTable;
}
IDxcValidator_VTable :: struct #type_info_none {
    using iunknown: IUnknown_VTable;
    Validate: (this: *IDxcValidator, pShader: *IDxcBlob, Flags: u32, ppResult: **IDxcOperationResult) -> HRESULT #cpp_method;
}
IDxcValidator_Validate :: inline (this: *IDxcValidator, pShader: *IDxcBlob, Flags: u32, ppResult: **IDxcOperationResult) -> HRESULT { return this.idxcvalidator_vtable.Validate(this, pShader, Flags, ppResult); }

vtable :: (obj: *IDxcValidator) -> *IDxcValidator_VTable { return obj.idxcvalidator_vtable; }


/// \brief Interface to DXC shader validator.
///
/// Use DxcCreateInstance with CLSID_DxcValidator to obtain an instance of this.
IDxcValidator2 :: struct {
    #as using idxcvalidator: IDxcValidator;
    #place idxcvalidator; idxcvalidator2_vtable: *IDxcValidator2_VTable;
}
IDxcValidator2_VTable :: struct #type_info_none {
    using idxcvalidator: IDxcValidator_VTable;
    ValidateWithDebug: (this: *IDxcValidator2, pShader: *IDxcBlob, Flags: u32, pOptDebugBitcode: *DxcBuffer, ppResult: **IDxcOperationResult) -> HRESULT #cpp_method;
}
IDxcValidator2_ValidateWithDebug :: inline (this: *IDxcValidator2, pShader: *IDxcBlob, Flags: u32, pOptDebugBitcode: *DxcBuffer, ppResult: **IDxcOperationResult) -> HRESULT { return this.idxcvalidator2_vtable.ValidateWithDebug(this, pShader, Flags, pOptDebugBitcode, ppResult); }

vtable :: (obj: *IDxcValidator2) -> *IDxcValidator2_VTable { return obj.idxcvalidator2_vtable; }


/// \brief Interface to DXC container builder.
///
/// Use DxcCreateInstance with CLSID_DxcContainerBuilder to obtain an instance
/// of this.
IDxcContainerBuilder :: struct {
    #as using iunknown: IUnknown;
    #place iunknown; idxccontainerbuilder_vtable: *IDxcContainerBuilder_VTable;
}
IDxcContainerBuilder_VTable :: struct #type_info_none {
    using iunknown: IUnknown_VTable;
    Load: (this: *IDxcContainerBuilder, pDxilContainerHeader: *IDxcBlob) -> HRESULT #cpp_method;
    AddPart: (this: *IDxcContainerBuilder, fourCC: u32, pSource: *IDxcBlob) -> HRESULT #cpp_method;
    RemovePart: (this: *IDxcContainerBuilder, fourCC: u32) -> HRESULT #cpp_method;
    SerializeContainer: (this: *IDxcContainerBuilder, ppResult: **IDxcOperationResult) -> HRESULT #cpp_method;
}
IDxcContainerBuilder_Load :: inline (this: *IDxcContainerBuilder, pDxilContainerHeader: *IDxcBlob) -> HRESULT { return this.idxccontainerbuilder_vtable.Load(this, pDxilContainerHeader); }
IDxcContainerBuilder_AddPart :: inline (this: *IDxcContainerBuilder, fourCC: u32, pSource: *IDxcBlob) -> HRESULT { return this.idxccontainerbuilder_vtable.AddPart(this, fourCC, pSource); }
IDxcContainerBuilder_RemovePart :: inline (this: *IDxcContainerBuilder, fourCC: u32) -> HRESULT { return this.idxccontainerbuilder_vtable.RemovePart(this, fourCC); }
IDxcContainerBuilder_SerializeContainer :: inline (this: *IDxcContainerBuilder, ppResult: **IDxcOperationResult) -> HRESULT { return this.idxccontainerbuilder_vtable.SerializeContainer(this, ppResult); }

vtable :: (obj: *IDxcContainerBuilder) -> *IDxcContainerBuilder_VTable { return obj.idxccontainerbuilder_vtable; }


/// \brief Interface to DxcAssembler.
///
/// Use DxcCreateInstance with CLSID_DxcAssembler to obtain an instance of this.
IDxcAssembler :: struct {
    #as using iunknown: IUnknown;
    #place iunknown; idxcassembler_vtable: *IDxcAssembler_VTable;
}
IDxcAssembler_VTable :: struct #type_info_none {
    using iunknown: IUnknown_VTable;
    AssembleToContainer: (this: *IDxcAssembler, pShader: *IDxcBlob, ppResult: **IDxcOperationResult) -> HRESULT #cpp_method;
}
IDxcAssembler_AssembleToContainer :: inline (this: *IDxcAssembler, pShader: *IDxcBlob, ppResult: **IDxcOperationResult) -> HRESULT { return this.idxcassembler_vtable.AssembleToContainer(this, pShader, ppResult); }

vtable :: (obj: *IDxcAssembler) -> *IDxcAssembler_VTable { return obj.idxcassembler_vtable; }


/// \brief Interface to DxcContainerReflection.
///
/// Use DxcCreateInstance with CLSID_DxcContainerReflection to obtain an
/// instance of this.
IDxcContainerReflection :: struct {
    #as using iunknown: IUnknown;
    #place iunknown; idxccontainerreflection_vtable: *IDxcContainerReflection_VTable;
}
IDxcContainerReflection_VTable :: struct #type_info_none {
    using iunknown: IUnknown_VTable;
    Load: (this: *IDxcContainerReflection, pContainer: *IDxcBlob) -> HRESULT #cpp_method;
    GetPartCount: (this: *IDxcContainerReflection, pResult: *u32) -> HRESULT #cpp_method;
    GetPartKind: (this: *IDxcContainerReflection, idx: u32, pResult: *u32) -> HRESULT #cpp_method;
    GetPartContent: (this: *IDxcContainerReflection, idx: u32, ppResult: **IDxcBlob) -> HRESULT #cpp_method;
    FindFirstPartKind: (this: *IDxcContainerReflection, kind: u32, pResult: *u32) -> HRESULT #cpp_method;
    GetPartReflection: (this: *IDxcContainerReflection, idx: u32, iid: *IID, ppvObject: **void) -> HRESULT #cpp_method;
}
IDxcContainerReflection_Load :: inline (this: *IDxcContainerReflection, pContainer: *IDxcBlob) -> HRESULT { return this.idxccontainerreflection_vtable.Load(this, pContainer); }
IDxcContainerReflection_GetPartCount :: inline (this: *IDxcContainerReflection, pResult: *u32) -> HRESULT { return this.idxccontainerreflection_vtable.GetPartCount(this, pResult); }
IDxcContainerReflection_GetPartKind :: inline (this: *IDxcContainerReflection, idx: u32, pResult: *u32) -> HRESULT { return this.idxccontainerreflection_vtable.GetPartKind(this, idx, pResult); }
IDxcContainerReflection_GetPartContent :: inline (this: *IDxcContainerReflection, idx: u32, ppResult: **IDxcBlob) -> HRESULT { return this.idxccontainerreflection_vtable.GetPartContent(this, idx, ppResult); }
IDxcContainerReflection_FindFirstPartKind :: inline (this: *IDxcContainerReflection, kind: u32, pResult: *u32) -> HRESULT { return this.idxccontainerreflection_vtable.FindFirstPartKind(this, kind, pResult); }
IDxcContainerReflection_GetPartReflection :: inline (this: *IDxcContainerReflection, idx: u32, iid: *IID, ppvObject: **void) -> HRESULT { return this.idxccontainerreflection_vtable.GetPartReflection(this, idx, iid, ppvObject); }

vtable :: (obj: *IDxcContainerReflection) -> *IDxcContainerReflection_VTable { return obj.idxccontainerreflection_vtable; }


/// \brief An optimizer pass.
///
/// Instances of this can be obtained via IDxcOptimizer::GetAvailablePass.
IDxcOptimizerPass :: struct {
    #as using iunknown: IUnknown;
    #place iunknown; idxcoptimizerpass_vtable: *IDxcOptimizerPass_VTable;
}
IDxcOptimizerPass_VTable :: struct #type_info_none {
    using iunknown: IUnknown_VTable;
    GetOptionName: (this: *IDxcOptimizerPass, ppResult: **s16) -> HRESULT #cpp_method;
    GetDescription: (this: *IDxcOptimizerPass, ppResult: **s16) -> HRESULT #cpp_method;
    GetOptionArgCount: (this: *IDxcOptimizerPass, pCount: *u32) -> HRESULT #cpp_method;
    GetOptionArgName: (this: *IDxcOptimizerPass, argIndex: u32, ppResult: **s16) -> HRESULT #cpp_method;
    GetOptionArgDescription: (this: *IDxcOptimizerPass, argIndex: u32, ppResult: **s16) -> HRESULT #cpp_method;
}
IDxcOptimizerPass_GetOptionName :: inline (this: *IDxcOptimizerPass, ppResult: **s16) -> HRESULT { return this.idxcoptimizerpass_vtable.GetOptionName(this, ppResult); }
IDxcOptimizerPass_GetDescription :: inline (this: *IDxcOptimizerPass, ppResult: **s16) -> HRESULT { return this.idxcoptimizerpass_vtable.GetDescription(this, ppResult); }
IDxcOptimizerPass_GetOptionArgCount :: inline (this: *IDxcOptimizerPass, pCount: *u32) -> HRESULT { return this.idxcoptimizerpass_vtable.GetOptionArgCount(this, pCount); }
IDxcOptimizerPass_GetOptionArgName :: inline (this: *IDxcOptimizerPass, argIndex: u32, ppResult: **s16) -> HRESULT { return this.idxcoptimizerpass_vtable.GetOptionArgName(this, argIndex, ppResult); }
IDxcOptimizerPass_GetOptionArgDescription :: inline (this: *IDxcOptimizerPass, argIndex: u32, ppResult: **s16) -> HRESULT { return this.idxcoptimizerpass_vtable.GetOptionArgDescription(this, argIndex, ppResult); }

vtable :: (obj: *IDxcOptimizerPass) -> *IDxcOptimizerPass_VTable { return obj.idxcoptimizerpass_vtable; }


/// \brief Interface to DxcOptimizer.
///
/// Use DxcCreateInstance with CLSID_DxcOptimizer to obtain an instance of this.
IDxcOptimizer :: struct {
    #as using iunknown: IUnknown;
    #place iunknown; idxcoptimizer_vtable: *IDxcOptimizer_VTable;
}
IDxcOptimizer_VTable :: struct #type_info_none {
    using iunknown: IUnknown_VTable;
    GetAvailablePassCount: (this: *IDxcOptimizer, pCount: *u32) -> HRESULT #cpp_method;
    GetAvailablePass: (this: *IDxcOptimizer, index: u32, ppResult: **IDxcOptimizerPass) -> HRESULT #cpp_method;
    RunOptimizer: (this: *IDxcOptimizer, pBlob: *IDxcBlob, ppOptions: **s16, optionCount: u32, pOutputModule: **IDxcBlob, ppOutputText: **IDxcBlobEncoding) -> HRESULT #cpp_method;
}
IDxcOptimizer_GetAvailablePassCount :: inline (this: *IDxcOptimizer, pCount: *u32) -> HRESULT { return this.idxcoptimizer_vtable.GetAvailablePassCount(this, pCount); }
IDxcOptimizer_GetAvailablePass :: inline (this: *IDxcOptimizer, index: u32, ppResult: **IDxcOptimizerPass) -> HRESULT { return this.idxcoptimizer_vtable.GetAvailablePass(this, index, ppResult); }
IDxcOptimizer_RunOptimizer :: inline (this: *IDxcOptimizer, pBlob: *IDxcBlob, ppOptions: **s16, optionCount: u32, pOutputModule: **IDxcBlob, ppOutputText: **IDxcBlobEncoding) -> HRESULT { return this.idxcoptimizer_vtable.RunOptimizer(this, pBlob, ppOptions, optionCount, pOutputModule, ppOutputText); }

vtable :: (obj: *IDxcOptimizer) -> *IDxcOptimizer_VTable { return obj.idxcoptimizer_vtable; }


DxcVersionInfoFlags_None: u32 : 0;
DxcVersionInfoFlags_Debug: u32 : 1; // Matches VS_FF_DEBUG
DxcVersionInfoFlags_Internal: u32 : 2;

/// \brief Version information.
///
/// This interface provides version information for the object that implements
/// it and can be obtained using QueryInterface.
IDxcVersionInfo :: struct {
    #as using iunknown: IUnknown;
    #place iunknown; idxcversioninfo_vtable: *IDxcVersionInfo_VTable;
}
IDxcVersionInfo_VTable :: struct #type_info_none {
    using iunknown: IUnknown_VTable;
    GetVersion: (this: *IDxcVersionInfo, pMajor: *u32, pMinor: *u32) -> HRESULT #cpp_method;
    GetFlags: (this: *IDxcVersionInfo, pFlags: *u32) -> HRESULT #cpp_method;
}
IDxcVersionInfo_GetVersion :: inline (this: *IDxcVersionInfo, pMajor: *u32, pMinor: *u32) -> HRESULT { return this.idxcversioninfo_vtable.GetVersion(this, pMajor, pMinor); }
IDxcVersionInfo_GetFlags :: inline (this: *IDxcVersionInfo, pFlags: *u32) -> HRESULT { return this.idxcversioninfo_vtable.GetFlags(this, pFlags); }

vtable :: (obj: *IDxcVersionInfo) -> *IDxcVersionInfo_VTable { return obj.idxcversioninfo_vtable; }


/// \brief Version Information.
///
/// This interface provides version information for the object that implements
/// it and can be obtained using QueryInterface.
IDxcVersionInfo2 :: struct {
    #as using idxcversioninfo: IDxcVersionInfo;
    #place idxcversioninfo; idxcversioninfo2_vtable: *IDxcVersionInfo2_VTable;
}
IDxcVersionInfo2_VTable :: struct #type_info_none {
    using idxcversioninfo: IDxcVersionInfo_VTable;
    GetCommitInfo: (this: *IDxcVersionInfo2, pCommitCount: *u32, pCommitHash: **u8) -> HRESULT #cpp_method;
}
IDxcVersionInfo2_GetCommitInfo :: inline (this: *IDxcVersionInfo2, pCommitCount: *u32, pCommitHash: **u8) -> HRESULT { return this.idxcversioninfo2_vtable.GetCommitInfo(this, pCommitCount, pCommitHash); }

vtable :: (obj: *IDxcVersionInfo2) -> *IDxcVersionInfo2_VTable { return obj.idxcversioninfo2_vtable; }


/// \brief Version Information.
///
/// This interface provides version information for the object that implements
/// it and can be obtained using QueryInterface.
IDxcVersionInfo3 :: struct {
    #as using iunknown: IUnknown;
    #place iunknown; idxcversioninfo3_vtable: *IDxcVersionInfo3_VTable;
}
IDxcVersionInfo3_VTable :: struct #type_info_none {
    using iunknown: IUnknown_VTable;
    GetCustomVersionString: (this: *IDxcVersionInfo3, pVersionString: **u8) -> HRESULT #cpp_method;
}
IDxcVersionInfo3_GetCustomVersionString :: inline (this: *IDxcVersionInfo3, pVersionString: **u8) -> HRESULT { return this.idxcversioninfo3_vtable.GetCustomVersionString(this, pVersionString); }

vtable :: (obj: *IDxcVersionInfo3) -> *IDxcVersionInfo3_VTable { return obj.idxcversioninfo3_vtable; }


DxcArgPair :: struct {
    pName:  *s16;
    pValue: *s16;
}

/// \deprecated Please use IDxcPdbUtils2 instead.
IDxcPdbUtils :: struct {
    #as using iunknown: IUnknown;
    #place iunknown; idxcpdbutils_vtable: *IDxcPdbUtils_VTable;
}
IDxcPdbUtils_VTable :: struct #type_info_none {
    using iunknown: IUnknown_VTable;
    Load: (this: *IDxcPdbUtils, pPdbOrDxil: *IDxcBlob) -> HRESULT #cpp_method;
    GetSourceCount: (this: *IDxcPdbUtils, pCount: *u32) -> HRESULT #cpp_method;
    GetSource: (this: *IDxcPdbUtils, uIndex: u32, ppResult: **IDxcBlobEncoding) -> HRESULT #cpp_method;
    GetSourceName: (this: *IDxcPdbUtils, uIndex: u32, pResult: *BSTR) -> HRESULT #cpp_method;
    GetFlagCount: (this: *IDxcPdbUtils, pCount: *u32) -> HRESULT #cpp_method;
    GetFlag: (this: *IDxcPdbUtils, uIndex: u32, pResult: *BSTR) -> HRESULT #cpp_method;
    GetArgCount: (this: *IDxcPdbUtils, pCount: *u32) -> HRESULT #cpp_method;
    GetArg: (this: *IDxcPdbUtils, uIndex: u32, pResult: *BSTR) -> HRESULT #cpp_method;
    GetArgPairCount: (this: *IDxcPdbUtils, pCount: *u32) -> HRESULT #cpp_method;
    GetArgPair: (this: *IDxcPdbUtils, uIndex: u32, pName: *BSTR, pValue: *BSTR) -> HRESULT #cpp_method;
    GetDefineCount: (this: *IDxcPdbUtils, pCount: *u32) -> HRESULT #cpp_method;
    GetDefine: (this: *IDxcPdbUtils, uIndex: u32, pResult: *BSTR) -> HRESULT #cpp_method;
    GetTargetProfile: (this: *IDxcPdbUtils, pResult: *BSTR) -> HRESULT #cpp_method;
    GetEntryPoint: (this: *IDxcPdbUtils, pResult: *BSTR) -> HRESULT #cpp_method;
    GetMainFileName: (this: *IDxcPdbUtils, pResult: *BSTR) -> HRESULT #cpp_method;
    GetHash: (this: *IDxcPdbUtils, ppResult: **IDxcBlob) -> HRESULT #cpp_method;
    GetName: (this: *IDxcPdbUtils, pResult: *BSTR) -> HRESULT #cpp_method;
    IsFullPDB: (this: *IDxcPdbUtils) -> BOOL #cpp_method;
    GetFullPDB: (this: *IDxcPdbUtils, ppFullPDB: **IDxcBlob) -> HRESULT #cpp_method;
    GetVersionInfo: (this: *IDxcPdbUtils, ppVersionInfo: **IDxcVersionInfo) -> HRESULT #cpp_method;
    SetCompiler: (this: *IDxcPdbUtils, pCompiler: *IDxcCompiler3) -> HRESULT #cpp_method;
    CompileForFullPDB: (this: *IDxcPdbUtils, ppResult: **IDxcResult) -> HRESULT #cpp_method;
    OverrideArgs: (this: *IDxcPdbUtils, pArgPairs: *DxcArgPair, uNumArgPairs: u32) -> HRESULT #cpp_method;
    OverrideRootSignature: (this: *IDxcPdbUtils, pRootSignature: *s16) -> HRESULT #cpp_method;
}
IDxcPdbUtils_Load :: inline (this: *IDxcPdbUtils, pPdbOrDxil: *IDxcBlob) -> HRESULT { return this.idxcpdbutils_vtable.Load(this, pPdbOrDxil); }
IDxcPdbUtils_GetSourceCount :: inline (this: *IDxcPdbUtils, pCount: *u32) -> HRESULT { return this.idxcpdbutils_vtable.GetSourceCount(this, pCount); }
IDxcPdbUtils_GetSource :: inline (this: *IDxcPdbUtils, uIndex: u32, ppResult: **IDxcBlobEncoding) -> HRESULT { return this.idxcpdbutils_vtable.GetSource(this, uIndex, ppResult); }
IDxcPdbUtils_GetSourceName :: inline (this: *IDxcPdbUtils, uIndex: u32, pResult: *BSTR) -> HRESULT { return this.idxcpdbutils_vtable.GetSourceName(this, uIndex, pResult); }
IDxcPdbUtils_GetFlagCount :: inline (this: *IDxcPdbUtils, pCount: *u32) -> HRESULT { return this.idxcpdbutils_vtable.GetFlagCount(this, pCount); }
IDxcPdbUtils_GetFlag :: inline (this: *IDxcPdbUtils, uIndex: u32, pResult: *BSTR) -> HRESULT { return this.idxcpdbutils_vtable.GetFlag(this, uIndex, pResult); }
IDxcPdbUtils_GetArgCount :: inline (this: *IDxcPdbUtils, pCount: *u32) -> HRESULT { return this.idxcpdbutils_vtable.GetArgCount(this, pCount); }
IDxcPdbUtils_GetArg :: inline (this: *IDxcPdbUtils, uIndex: u32, pResult: *BSTR) -> HRESULT { return this.idxcpdbutils_vtable.GetArg(this, uIndex, pResult); }
IDxcPdbUtils_GetArgPairCount :: inline (this: *IDxcPdbUtils, pCount: *u32) -> HRESULT { return this.idxcpdbutils_vtable.GetArgPairCount(this, pCount); }
IDxcPdbUtils_GetArgPair :: inline (this: *IDxcPdbUtils, uIndex: u32, pName: *BSTR, pValue: *BSTR) -> HRESULT { return this.idxcpdbutils_vtable.GetArgPair(this, uIndex, pName, pValue); }
IDxcPdbUtils_GetDefineCount :: inline (this: *IDxcPdbUtils, pCount: *u32) -> HRESULT { return this.idxcpdbutils_vtable.GetDefineCount(this, pCount); }
IDxcPdbUtils_GetDefine :: inline (this: *IDxcPdbUtils, uIndex: u32, pResult: *BSTR) -> HRESULT { return this.idxcpdbutils_vtable.GetDefine(this, uIndex, pResult); }
IDxcPdbUtils_GetTargetProfile :: inline (this: *IDxcPdbUtils, pResult: *BSTR) -> HRESULT { return this.idxcpdbutils_vtable.GetTargetProfile(this, pResult); }
IDxcPdbUtils_GetEntryPoint :: inline (this: *IDxcPdbUtils, pResult: *BSTR) -> HRESULT { return this.idxcpdbutils_vtable.GetEntryPoint(this, pResult); }
IDxcPdbUtils_GetMainFileName :: inline (this: *IDxcPdbUtils, pResult: *BSTR) -> HRESULT { return this.idxcpdbutils_vtable.GetMainFileName(this, pResult); }
IDxcPdbUtils_GetHash :: inline (this: *IDxcPdbUtils, ppResult: **IDxcBlob) -> HRESULT { return this.idxcpdbutils_vtable.GetHash(this, ppResult); }
IDxcPdbUtils_GetName :: inline (this: *IDxcPdbUtils, pResult: *BSTR) -> HRESULT { return this.idxcpdbutils_vtable.GetName(this, pResult); }
IDxcPdbUtils_IsFullPDB :: inline (this: *IDxcPdbUtils) -> BOOL { return this.idxcpdbutils_vtable.IsFullPDB(this); }
IDxcPdbUtils_GetFullPDB :: inline (this: *IDxcPdbUtils, ppFullPDB: **IDxcBlob) -> HRESULT { return this.idxcpdbutils_vtable.GetFullPDB(this, ppFullPDB); }
IDxcPdbUtils_GetVersionInfo :: inline (this: *IDxcPdbUtils, ppVersionInfo: **IDxcVersionInfo) -> HRESULT { return this.idxcpdbutils_vtable.GetVersionInfo(this, ppVersionInfo); }
IDxcPdbUtils_SetCompiler :: inline (this: *IDxcPdbUtils, pCompiler: *IDxcCompiler3) -> HRESULT { return this.idxcpdbutils_vtable.SetCompiler(this, pCompiler); }
IDxcPdbUtils_CompileForFullPDB :: inline (this: *IDxcPdbUtils, ppResult: **IDxcResult) -> HRESULT { return this.idxcpdbutils_vtable.CompileForFullPDB(this, ppResult); }
IDxcPdbUtils_OverrideArgs :: inline (this: *IDxcPdbUtils, pArgPairs: *DxcArgPair, uNumArgPairs: u32) -> HRESULT { return this.idxcpdbutils_vtable.OverrideArgs(this, pArgPairs, uNumArgPairs); }
IDxcPdbUtils_OverrideRootSignature :: inline (this: *IDxcPdbUtils, pRootSignature: *s16) -> HRESULT { return this.idxcpdbutils_vtable.OverrideRootSignature(this, pRootSignature); }

vtable :: (obj: *IDxcPdbUtils) -> *IDxcPdbUtils_VTable { return obj.idxcpdbutils_vtable; }


/// \brief DxcPdbUtils interface.
///
/// Use DxcCreateInstance with CLSID_DxcPdbUtils to create an instance of this.
IDxcPdbUtils2 :: struct {
    #as using iunknown: IUnknown;
    #place iunknown; idxcpdbutils2_vtable: *IDxcPdbUtils2_VTable;
}
IDxcPdbUtils2_VTable :: struct #type_info_none {
    using iunknown: IUnknown_VTable;
    Load: (this: *IDxcPdbUtils2, pPdbOrDxil: *IDxcBlob) -> HRESULT #cpp_method;
    GetSourceCount: (this: *IDxcPdbUtils2, pCount: *u32) -> HRESULT #cpp_method;
    GetSource: (this: *IDxcPdbUtils2, uIndex: u32, ppResult: **IDxcBlobEncoding) -> HRESULT #cpp_method;
    GetSourceName: (this: *IDxcPdbUtils2, uIndex: u32, ppResult: **IDxcBlobWide) -> HRESULT #cpp_method;
    GetLibraryPDBCount: (this: *IDxcPdbUtils2, pCount: *u32) -> HRESULT #cpp_method;
    GetLibraryPDB: (this: *IDxcPdbUtils2, uIndex: u32, ppOutPdbUtils: **IDxcPdbUtils2, ppLibraryName: **IDxcBlobWide) -> HRESULT #cpp_method;
    GetFlagCount: (this: *IDxcPdbUtils2, pCount: *u32) -> HRESULT #cpp_method;
    GetFlag: (this: *IDxcPdbUtils2, uIndex: u32, ppResult: **IDxcBlobWide) -> HRESULT #cpp_method;
    GetArgCount: (this: *IDxcPdbUtils2, pCount: *u32) -> HRESULT #cpp_method;
    GetArg: (this: *IDxcPdbUtils2, uIndex: u32, ppResult: **IDxcBlobWide) -> HRESULT #cpp_method;
    GetArgPairCount: (this: *IDxcPdbUtils2, pCount: *u32) -> HRESULT #cpp_method;
    GetArgPair: (this: *IDxcPdbUtils2, uIndex: u32, ppName: **IDxcBlobWide, ppValue: **IDxcBlobWide) -> HRESULT #cpp_method;
    GetDefineCount: (this: *IDxcPdbUtils2, pCount: *u32) -> HRESULT #cpp_method;
    GetDefine: (this: *IDxcPdbUtils2, uIndex: u32, ppResult: **IDxcBlobWide) -> HRESULT #cpp_method;
    GetTargetProfile: (this: *IDxcPdbUtils2, ppResult: **IDxcBlobWide) -> HRESULT #cpp_method;
    GetEntryPoint: (this: *IDxcPdbUtils2, ppResult: **IDxcBlobWide) -> HRESULT #cpp_method;
    GetMainFileName: (this: *IDxcPdbUtils2, ppResult: **IDxcBlobWide) -> HRESULT #cpp_method;
    GetHash: (this: *IDxcPdbUtils2, ppResult: **IDxcBlob) -> HRESULT #cpp_method;
    GetName: (this: *IDxcPdbUtils2, ppResult: **IDxcBlobWide) -> HRESULT #cpp_method;
    GetVersionInfo: (this: *IDxcPdbUtils2, ppVersionInfo: **IDxcVersionInfo) -> HRESULT #cpp_method;
    GetCustomToolchainID: (this: *IDxcPdbUtils2, pID: *u32) -> HRESULT #cpp_method;
    GetCustomToolchainData: (this: *IDxcPdbUtils2, ppBlob: **IDxcBlob) -> HRESULT #cpp_method;
    GetWholeDxil: (this: *IDxcPdbUtils2, ppResult: **IDxcBlob) -> HRESULT #cpp_method;
    IsFullPDB: (this: *IDxcPdbUtils2) -> BOOL #cpp_method;
    IsPDBRef: (this: *IDxcPdbUtils2) -> BOOL #cpp_method;
}
IDxcPdbUtils2_Load :: inline (this: *IDxcPdbUtils2, pPdbOrDxil: *IDxcBlob) -> HRESULT { return this.idxcpdbutils2_vtable.Load(this, pPdbOrDxil); }
IDxcPdbUtils2_GetSourceCount :: inline (this: *IDxcPdbUtils2, pCount: *u32) -> HRESULT { return this.idxcpdbutils2_vtable.GetSourceCount(this, pCount); }
IDxcPdbUtils2_GetSource :: inline (this: *IDxcPdbUtils2, uIndex: u32, ppResult: **IDxcBlobEncoding) -> HRESULT { return this.idxcpdbutils2_vtable.GetSource(this, uIndex, ppResult); }
IDxcPdbUtils2_GetSourceName :: inline (this: *IDxcPdbUtils2, uIndex: u32, ppResult: **IDxcBlobWide) -> HRESULT { return this.idxcpdbutils2_vtable.GetSourceName(this, uIndex, ppResult); }
IDxcPdbUtils2_GetLibraryPDBCount :: inline (this: *IDxcPdbUtils2, pCount: *u32) -> HRESULT { return this.idxcpdbutils2_vtable.GetLibraryPDBCount(this, pCount); }
IDxcPdbUtils2_GetLibraryPDB :: inline (this: *IDxcPdbUtils2, uIndex: u32, ppOutPdbUtils: **IDxcPdbUtils2, ppLibraryName: **IDxcBlobWide) -> HRESULT { return this.idxcpdbutils2_vtable.GetLibraryPDB(this, uIndex, ppOutPdbUtils, ppLibraryName); }
IDxcPdbUtils2_GetFlagCount :: inline (this: *IDxcPdbUtils2, pCount: *u32) -> HRESULT { return this.idxcpdbutils2_vtable.GetFlagCount(this, pCount); }
IDxcPdbUtils2_GetFlag :: inline (this: *IDxcPdbUtils2, uIndex: u32, ppResult: **IDxcBlobWide) -> HRESULT { return this.idxcpdbutils2_vtable.GetFlag(this, uIndex, ppResult); }
IDxcPdbUtils2_GetArgCount :: inline (this: *IDxcPdbUtils2, pCount: *u32) -> HRESULT { return this.idxcpdbutils2_vtable.GetArgCount(this, pCount); }
IDxcPdbUtils2_GetArg :: inline (this: *IDxcPdbUtils2, uIndex: u32, ppResult: **IDxcBlobWide) -> HRESULT { return this.idxcpdbutils2_vtable.GetArg(this, uIndex, ppResult); }
IDxcPdbUtils2_GetArgPairCount :: inline (this: *IDxcPdbUtils2, pCount: *u32) -> HRESULT { return this.idxcpdbutils2_vtable.GetArgPairCount(this, pCount); }
IDxcPdbUtils2_GetArgPair :: inline (this: *IDxcPdbUtils2, uIndex: u32, ppName: **IDxcBlobWide, ppValue: **IDxcBlobWide) -> HRESULT { return this.idxcpdbutils2_vtable.GetArgPair(this, uIndex, ppName, ppValue); }
IDxcPdbUtils2_GetDefineCount :: inline (this: *IDxcPdbUtils2, pCount: *u32) -> HRESULT { return this.idxcpdbutils2_vtable.GetDefineCount(this, pCount); }
IDxcPdbUtils2_GetDefine :: inline (this: *IDxcPdbUtils2, uIndex: u32, ppResult: **IDxcBlobWide) -> HRESULT { return this.idxcpdbutils2_vtable.GetDefine(this, uIndex, ppResult); }
IDxcPdbUtils2_GetTargetProfile :: inline (this: *IDxcPdbUtils2, ppResult: **IDxcBlobWide) -> HRESULT { return this.idxcpdbutils2_vtable.GetTargetProfile(this, ppResult); }
IDxcPdbUtils2_GetEntryPoint :: inline (this: *IDxcPdbUtils2, ppResult: **IDxcBlobWide) -> HRESULT { return this.idxcpdbutils2_vtable.GetEntryPoint(this, ppResult); }
IDxcPdbUtils2_GetMainFileName :: inline (this: *IDxcPdbUtils2, ppResult: **IDxcBlobWide) -> HRESULT { return this.idxcpdbutils2_vtable.GetMainFileName(this, ppResult); }
IDxcPdbUtils2_GetHash :: inline (this: *IDxcPdbUtils2, ppResult: **IDxcBlob) -> HRESULT { return this.idxcpdbutils2_vtable.GetHash(this, ppResult); }
IDxcPdbUtils2_GetName :: inline (this: *IDxcPdbUtils2, ppResult: **IDxcBlobWide) -> HRESULT { return this.idxcpdbutils2_vtable.GetName(this, ppResult); }
IDxcPdbUtils2_GetVersionInfo :: inline (this: *IDxcPdbUtils2, ppVersionInfo: **IDxcVersionInfo) -> HRESULT { return this.idxcpdbutils2_vtable.GetVersionInfo(this, ppVersionInfo); }
IDxcPdbUtils2_GetCustomToolchainID :: inline (this: *IDxcPdbUtils2, pID: *u32) -> HRESULT { return this.idxcpdbutils2_vtable.GetCustomToolchainID(this, pID); }
IDxcPdbUtils2_GetCustomToolchainData :: inline (this: *IDxcPdbUtils2, ppBlob: **IDxcBlob) -> HRESULT { return this.idxcpdbutils2_vtable.GetCustomToolchainData(this, ppBlob); }
IDxcPdbUtils2_GetWholeDxil :: inline (this: *IDxcPdbUtils2, ppResult: **IDxcBlob) -> HRESULT { return this.idxcpdbutils2_vtable.GetWholeDxil(this, ppResult); }
IDxcPdbUtils2_IsFullPDB :: inline (this: *IDxcPdbUtils2) -> BOOL { return this.idxcpdbutils2_vtable.IsFullPDB(this); }
IDxcPdbUtils2_IsPDBRef :: inline (this: *IDxcPdbUtils2) -> BOOL { return this.idxcpdbutils2_vtable.IsPDBRef(this); }

vtable :: (obj: *IDxcPdbUtils2) -> *IDxcPdbUtils2_VTable { return obj.idxcpdbutils2_vtable; }


#scope_file

#import "Basic"; // For assert

dxcompiler :: #library "lib/dxcompiler";

#run {
    {
        instance: DxcShaderHash;
        assert(((cast(*void)(*instance.Flags)) - cast(*void)(*instance)) == 0, "DxcShaderHash.Flags has unexpected offset % instead of 0", ((cast(*void)(*instance.Flags)) - cast(*void)(*instance)));
        assert(size_of(type_of(DxcShaderHash.Flags)) == 4, "DxcShaderHash.Flags has unexpected size % instead of 4", size_of(type_of(DxcShaderHash.Flags)));
        assert(((cast(*void)(*instance.HashDigest)) - cast(*void)(*instance)) == 4, "DxcShaderHash.HashDigest has unexpected offset % instead of 4", ((cast(*void)(*instance.HashDigest)) - cast(*void)(*instance)));
        assert(size_of(type_of(DxcShaderHash.HashDigest)) == 16, "DxcShaderHash.HashDigest has unexpected size % instead of 16", size_of(type_of(DxcShaderHash.HashDigest)));
        assert(size_of(DxcShaderHash) == 20, "DxcShaderHash has size % instead of 20", size_of(DxcShaderHash));
    }

    assert(size_of(IDxcBlob) == 8, "IDxcBlob has size % instead of 8", size_of(IDxcBlob));

    assert(size_of(IDxcBlobEncoding) == 8, "IDxcBlobEncoding has size % instead of 8", size_of(IDxcBlobEncoding));

    assert(size_of(IDxcBlobWide) == 8, "IDxcBlobWide has size % instead of 8", size_of(IDxcBlobWide));

    assert(size_of(IDxcBlobUtf8) == 8, "IDxcBlobUtf8 has size % instead of 8", size_of(IDxcBlobUtf8));

    assert(size_of(IDxcIncludeHandler) == 8, "IDxcIncludeHandler has size % instead of 8", size_of(IDxcIncludeHandler));

    {
        instance: DxcBuffer;
        assert(((cast(*void)(*instance.Ptr)) - cast(*void)(*instance)) == 0, "DxcBuffer.Ptr has unexpected offset % instead of 0", ((cast(*void)(*instance.Ptr)) - cast(*void)(*instance)));
        assert(size_of(type_of(DxcBuffer.Ptr)) == 8, "DxcBuffer.Ptr has unexpected size % instead of 8", size_of(type_of(DxcBuffer.Ptr)));
        assert(((cast(*void)(*instance.Size)) - cast(*void)(*instance)) == 8, "DxcBuffer.Size has unexpected offset % instead of 8", ((cast(*void)(*instance.Size)) - cast(*void)(*instance)));
        assert(size_of(type_of(DxcBuffer.Size)) == 8, "DxcBuffer.Size has unexpected size % instead of 8", size_of(type_of(DxcBuffer.Size)));
        assert(((cast(*void)(*instance.Encoding)) - cast(*void)(*instance)) == 16, "DxcBuffer.Encoding has unexpected offset % instead of 16", ((cast(*void)(*instance.Encoding)) - cast(*void)(*instance)));
        assert(size_of(type_of(DxcBuffer.Encoding)) == 4, "DxcBuffer.Encoding has unexpected size % instead of 4", size_of(type_of(DxcBuffer.Encoding)));
        assert(size_of(DxcBuffer) == 24, "DxcBuffer has size % instead of 24", size_of(DxcBuffer));
    }

    {
        instance: DxcDefine;
        assert(((cast(*void)(*instance.Name)) - cast(*void)(*instance)) == 0, "DxcDefine.Name has unexpected offset % instead of 0", ((cast(*void)(*instance.Name)) - cast(*void)(*instance)));
        assert(size_of(type_of(DxcDefine.Name)) == 8, "DxcDefine.Name has unexpected size % instead of 8", size_of(type_of(DxcDefine.Name)));
        assert(((cast(*void)(*instance.Value)) - cast(*void)(*instance)) == 8, "DxcDefine.Value has unexpected offset % instead of 8", ((cast(*void)(*instance.Value)) - cast(*void)(*instance)));
        assert(size_of(type_of(DxcDefine.Value)) == 8, "DxcDefine.Value has unexpected size % instead of 8", size_of(type_of(DxcDefine.Value)));
        assert(size_of(DxcDefine) == 16, "DxcDefine has size % instead of 16", size_of(DxcDefine));
    }

    assert(size_of(IDxcCompilerArgs) == 8, "IDxcCompilerArgs has size % instead of 8", size_of(IDxcCompilerArgs));

    assert(size_of(IDxcLibrary) == 8, "IDxcLibrary has size % instead of 8", size_of(IDxcLibrary));

    assert(size_of(IDxcOperationResult) == 8, "IDxcOperationResult has size % instead of 8", size_of(IDxcOperationResult));

    assert(size_of(IDxcCompiler) == 8, "IDxcCompiler has size % instead of 8", size_of(IDxcCompiler));

    assert(size_of(IDxcCompiler2) == 8, "IDxcCompiler2 has size % instead of 8", size_of(IDxcCompiler2));

    assert(size_of(IDxcLinker) == 8, "IDxcLinker has size % instead of 8", size_of(IDxcLinker));

    assert(size_of(IDxcUtils) == 8, "IDxcUtils has size % instead of 8", size_of(IDxcUtils));

    assert(size_of(IDxcResult) == 8, "IDxcResult has size % instead of 8", size_of(IDxcResult));

    assert(size_of(IDxcExtraOutputs) == 8, "IDxcExtraOutputs has size % instead of 8", size_of(IDxcExtraOutputs));

    assert(size_of(IDxcCompiler3) == 8, "IDxcCompiler3 has size % instead of 8", size_of(IDxcCompiler3));

    assert(size_of(IDxcValidator) == 8, "IDxcValidator has size % instead of 8", size_of(IDxcValidator));

    assert(size_of(IDxcValidator2) == 8, "IDxcValidator2 has size % instead of 8", size_of(IDxcValidator2));

    assert(size_of(IDxcContainerBuilder) == 8, "IDxcContainerBuilder has size % instead of 8", size_of(IDxcContainerBuilder));

    assert(size_of(IDxcAssembler) == 8, "IDxcAssembler has size % instead of 8", size_of(IDxcAssembler));

    assert(size_of(IDxcContainerReflection) == 8, "IDxcContainerReflection has size % instead of 8", size_of(IDxcContainerReflection));

    assert(size_of(IDxcOptimizerPass) == 8, "IDxcOptimizerPass has size % instead of 8", size_of(IDxcOptimizerPass));

    assert(size_of(IDxcOptimizer) == 8, "IDxcOptimizer has size % instead of 8", size_of(IDxcOptimizer));

    assert(size_of(IDxcVersionInfo) == 8, "IDxcVersionInfo has size % instead of 8", size_of(IDxcVersionInfo));

    assert(size_of(IDxcVersionInfo2) == 8, "IDxcVersionInfo2 has size % instead of 8", size_of(IDxcVersionInfo2));

    assert(size_of(IDxcVersionInfo3) == 8, "IDxcVersionInfo3 has size % instead of 8", size_of(IDxcVersionInfo3));

    {
        instance: DxcArgPair;
        assert(((cast(*void)(*instance.pName)) - cast(*void)(*instance)) == 0, "DxcArgPair.pName has unexpected offset % instead of 0", ((cast(*void)(*instance.pName)) - cast(*void)(*instance)));
        assert(size_of(type_of(DxcArgPair.pName)) == 8, "DxcArgPair.pName has unexpected size % instead of 8", size_of(type_of(DxcArgPair.pName)));
        assert(((cast(*void)(*instance.pValue)) - cast(*void)(*instance)) == 8, "DxcArgPair.pValue has unexpected offset % instead of 8", ((cast(*void)(*instance.pValue)) - cast(*void)(*instance)));
        assert(size_of(type_of(DxcArgPair.pValue)) == 8, "DxcArgPair.pValue has unexpected size % instead of 8", size_of(type_of(DxcArgPair.pValue)));
        assert(size_of(DxcArgPair) == 16, "DxcArgPair has size % instead of 16", size_of(DxcArgPair));
    }

    assert(size_of(IDxcPdbUtils) == 8, "IDxcPdbUtils has size % instead of 8", size_of(IDxcPdbUtils));

    assert(size_of(IDxcPdbUtils2) == 8, "IDxcPdbUtils2 has size % instead of 8", size_of(IDxcPdbUtils2));
}

