@echo off
setlocal

call .\config.bat

@REM delete all files in out folder
del /f /s /q %_OUT_PATH%\*
cd %_OUT_PATH%
rd /s /q %_OUT_PATH% >nul 2>&1
cd %_ROOT_PATH%
del %_LOCK_PATH%\amf.lock >nul 2>&1
del %_LOCK_PATH%\egl_registry.lock >nul 2>&1
del %_LOCK_PATH%\ffnvcodec.lock >nul 2>&1
del %_LOCK_PATH%\opengl_registry.lock >nul 2>&1
endlocal

call .\pre_build.bat