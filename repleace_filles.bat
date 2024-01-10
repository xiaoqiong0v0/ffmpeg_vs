@echo off
setlocal

call .\config.bat

@REM 拷贝 %_ROOT_PATH%\replace 下目录文件到 %_SOURCE_PATH% 下 强制覆盖

xcopy /y /s /e /q %_ROOT_PATH%\replace %_SOURCE_PATH%

echo "repleace files done"