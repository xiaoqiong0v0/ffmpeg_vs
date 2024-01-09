@echo off
setlocal
call .\config.bat

SET UPSTREAMURL=https://github.com/ShiftMediaProject
SET DEPENDENCIES=( ^
FFmpeg, ^
bzip2, ^
fontconfig, ^
freetype2, ^
fribidi, ^
game-music-emu, ^
gnutls, ^
harfbuzz, ^
lame, ^
libass, ^
libbluray, ^
libcdio, ^
libcdio-paranoia, ^
libiconv, ^
libgcrypt, ^
libilbc, ^
liblzma, ^
libssh, ^
libxml2, ^
libvpx, ^
mfx_dispatch, ^
modplug, ^
opus, ^
sdl, ^
soxr, ^
speex, ^
theora, ^
vorbis, ^
x264, ^
x265, ^
xvid, ^
zlib ^
)

call .\common.bat :set_proxy || exit /b 1

if not exist .gitmodules (
    echo. > .gitmodules
)

if not exist tmp (
    mkdir tmp
)
setlocal enabledelayedexpansion
set _error_modulenames=
for %%i in %DEPENDENCIES% do (
    git submodule add %UPSTREAMURL%/%%i.git %_SOURCE_PATH%/%%i > tmp\git_submodule_add 2>&1
    if errorlevel 1 (
        for /f "tokens=*" %%j in (tmp\git_submodule_add) do (
            for /f "tokens=*" %%k in ('echo %%j ^| findstr /i /c:"already exists in the index"') do (
                if "%%k"=="" (
                    echo %%j
                    set _error_modulenames=!_error_modulenames!,%%i
                ) else (
                    echo %%i already exists!
                )
            )
        )
    )
)
setlocal disabledelayedexpansion

if not "%_error_modulenames%"=="" (
    echo "Failed to add submodules: %_error_modulenames%"
) else (
    echo "All submodules added successfully"
)

call .\common.bat :unset_proxy

endlocal