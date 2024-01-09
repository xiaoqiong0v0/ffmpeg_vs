@echo off
setlocal
call .\config.bat

call .\common.bat :set_proxy || exit /b 1

git submodule update --init --recursive || echo  "Failed to update submodules" && exit /b 1

call .\common.bat :unset_proxy

echo "Done"
endlocal