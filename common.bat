:set_proxy
if "%_PROXY%"=="" (
    exit /b 0
)
set HTTPS_PROXY=%_PROXY%
set HTTP_PROXY=%_PROXY%
set ALL_PROXY=%_PROXY%
git config --global http.proxy %_PROXY% || echo "Failed to config git proxy" && exit /b 1
echo "set git http proxy to %_PROXY%"
git config --global https.proxy %_PROXY% || echo "Failed to config git proxy" && exit /b 1
echo "set git https proxy to %_PROXY%"
exit /b 0

:unset_proxy
set HTTPS_PROXY=
set HTTP_PROXY=
set ALL_PROXY=
git config --global --unset http.proxy
git config --global --unset https.proxy
exit /b 0

:remove_file_lines
set file=%1
set remove_lines=,%~2,
if not exist %file% (
    echo "%file% not exist"
    exit /b 1
)
if not exist %file%.bak (
    copy %file% %file%.bak
)
type nul > %file%
for /f "tokens=* delims=" %%a in ('findstr /n "^" %file%.bak') do (
    set "line=%%a"
    setlocal enabledelayedexpansion
    set "line=!line:*:=!"
    set "line=!line:^!!=!!"
    for /f "tokens=1 delims=:" %%b in ("%%a") do (
        if "!remove_lines:,%%b,=!" == "!remove_lines!" (
            if not "!line!" == "^!" (
                for /f "tokens=*" %%c in ("!line!") do (
                    if not "%%c" == "" (
                        echo "write line: %%b <!line!>"
                        echo !line!>> %file%
                    ) else (
                        echo "write blank line %%b"
                        echo.>> %file%
                    )
                )
            ) else (
                echo "write blank line %%b"
                echo.>> %file%
            )
        ) else (
            echo "delete line %%b <!line!>"
            echo.>> %file%
        )
    )
    endlocal
)
goto :eof