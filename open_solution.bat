@echo off
setlocal

call .\config.bat

set exe_path=%_VS_PATH%\Common7\IDE\devenv.exe
set sln_path=%_SOURCE_PATH%\FFmpeg\SMP\ffmpeg_deps.sln

if not exist "%exe_path%" (
    echo "devenv.exe not exist"
) else (
    if not exist "%sln_path%" (
        echo "ffmpeg_deps.sln not exist"
    ) else (
        call "%exe_path%" "%sln_path%"
    )
)