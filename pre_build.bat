@echo off
@REM ! install VsNasm and VsYasm need administrator privileges
setlocal

call .\config.bat

call .\common.bat :set_proxy || exit /b 1

if not exist "%_OUT_PATH%" (
    mkdir %_OUT_PATH%
)
if not exist "%_LOCK_PATH%" (
    mkdir %_LOCK_PATH%
)
if not exist "%_LOCK_PATH%\VSNASM.lock" (
    cd %_SOURCE_PATH%
    echo "check VsNasm ..."
    if not exist "VSNASM" (
        echo "clone VsNasm ..."
        git clone https://github.com/ShiftMediaProject/VSNASM.git || echo "download VsNasm failed" && goto end
        call :remove_file_lines %_SOURCE_PATH%\VSNASM\install_script.bat "317,318,319,320,321,322" || echo "edit_scripts failed" && goto end
    )

    cd %_SOURCE_PATH%\VSNASM
    if "%PROCESSOR_ARCHITECTURE%"=="AMD64" (
        echo "Detected 64 bit system..."
        set SYSARCH=64
    ) else if "%PROCESSOR_ARCHITECTURE%"=="x86" (
        if "%PROCESSOR_ARCHITEW6432%"=="AMD64" (
            echo "Detected 64 bit system running 32 bit shell..."
            set SYSARCH=64
        ) else (
            echo "Detected 32 bit system..."
            set SYSARCH=32
        )
    ) else (
        echo "Can't detect system architecture..."
    )
    call .\install_script.bat %_VS_VERSION% "%_VS_PATH%" || echo "install VsNasm failed" && goto end
    cd %_ROOT_PATH%
    type nul> "%_LOCK_PATH%\VSNASM.lock"
    echo "check VsNasm is ok"
) else (
    echo "check VsNasm is already ok"
)

if not exist "%_LOCK_PATH%\VSYASM.lock" (
    cd %_SOURCE_PATH%
    echo "check VsYasm ..."
    if not exist "VSYASM" (
        echo "clone VsYasm ..."
        git clone "https://github.com/ShiftMediaProject/VSYASM.git" "VSYASM" || echo "download VsYasm failed" && goto end
    )
    cd %_SOURCE_PATH%\VSYASM
    if "%PROCESSOR_ARCHITECTURE%"=="AMD64" (
        echo "Detected 64 bit system..."
        set SYSARCH=64
    ) else if "%PROCESSOR_ARCHITECTURE%"=="x86" (
        if "%PROCESSOR_ARCHITEW6432%"=="AMD64" (
            echo "Detected 64 bit system running 32 bit shell..."
            set SYSARCH=64
        ) else (
            echo "Detected 32 bit system..."
            set SYSARCH=32
        )
    ) else (
        echo "Can't detect system architecture..."
    )
    call .\install_script.bat %_VS_VERSION% "%_VS_PATH%" || echo "install VsYasm failed" && goto end
    cd %_ROOT_PATH%
    type nul> "%_LOCK_PATH%\VSYASM.lock"
    echo "check VsYasm is ok"
) else (
    echo "check VsYasm is already ok"
)

if not exist "%_LOCK_PATH%\opengl_registry.lock" (
    cd %_SOURCE_PATH%
    echo "check opengl registry ..."
    if not exist "OpenGL-Registry" (
        echo "clone opengl registry ..."
        git clone "https://github.com/KhronosGroup/OpenGL-Registry.git" "OpenGL-Registry" || echo "download opengl registry failed" && goto end
    )
    if not exist "%_OUT_PATH%\include\gl" (
        mkdir "%_OUT_PATH%\include\gl"
    )
    copy "OpenGL-Registry\api\GL\glext.h" "%_OUT_PATH%\include\gl\" || echo "copy glext.h failed" && goto end
    copy "OpenGL-Registry\api\GL\wglext.h" "%_OUT_PATH%\include\gl\" || echo "copy wglext.h failed" && goto end
    cd %_ROOT_PATH%
    type nul> "%_LOCK_PATH%\opengl_registry.lock"
    echo "check opengl registry is ok"
) else (
    echo "check opengl registry is already ok"
)

if not exist "%_LOCK_PATH%\egl_registry.lock" (
    cd %_SOURCE_PATH%
    echo "check egl registry ..."
    if not exist "EGL-Registry" (
        echo "clone egl registry ..."
        git clone "https://github.com/KhronosGroup/EGL-Registry.git" "EGL-Registry" || echo "download egl registry failed" && goto end
    )
    if not exist "%_OUT_PATH%\include\KHR" (
        mkdir "%_OUT_PATH%\include\KHR"
    )
    copy "EGL-Registry\api\KHR\khrplatform.h" "%_OUT_PATH%\include\KHR\" || echo "copy egl registry failed" && goto end
    cd %_ROOT_PATH%
    type nul> "%_LOCK_PATH%\egl_registry.lock"
    echo "check egl registry is ok"
) else (
    echo "check egl registry is already ok"
)

if not exist "%_LOCK_PATH%\ffnvcodec.lock" (
    cd %_SOURCE_PATH%
    echo "check ffnvcodec ..."
    if not exist "FFmpeg-NVENC" (
        echo "clone ffnvcodec ..."
        git clone "https://github.com/FFmpeg/nv-codec-headers.git" "FFmpeg-NVENC" || echo "download ffnvcodec failed" && goto end
    )
    xcopy "FFmpeg-NVENC\include\*" "%_OUT_PATH%\include\" /E /I /Y || echo "copy ffnvcodec failed" && goto end
    cd %_ROOT_PATH%
    type nul> "%_LOCK_PATH%\ffnvcodec.lock"
    echo "check ffnvcodec is ok"
) else (
    echo "check ffnvcodec is already ok"
)

if not exist "%_LOCK_PATH%\amf.lock" (
    cd %_SOURCE_PATH%
    echo "check amf ..."
    if not exist "AMF" (
        echo "clone amf ..."
        git clone "https://github.com/GPUOpen-LibrariesAndSDKs/AMF.git" "AMF" || echo "download amf failed" && goto end
    )
    if not exist "%_OUT_PATH%\include\AMF" (
        mkdir "%_OUT_PATH%\include\AMF"
    )
    xcopy "AMF\amf\public\include\*" "%_OUT_PATH%\include\AMF\" /E /I /Y || echo "copy amf failed" && goto end
    cd %_ROOT_PATH%
    type nul> "%_LOCK_PATH%\amf.lock"
    echo "check amf is ok"
) else (
    echo "check amf is already ok"
)

echo "all done"
:end
cd %_ROOT_PATH%
call .\common.bat :unset_proxy
echo "Done"
endlocal