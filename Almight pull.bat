@echo off
setlocal enabledelayedexpansion

REM This loop iterates through all the subdirectories in the current location.
REM The /D switch ensures that it only processes directories.
FOR /D %%i IN (*) DO (
    REM The `move` command moves all files (*) from the current subdirectory (%%i)
    REM to the parent directory (.).
    echo Moving files from "%%i" to main folder...
    move "%%i\*" "."
    
    REM After moving the files, this command attempts to remove the now empty directory.
    REM It will only succeed if the folder is empty.
    echo Deleting empty folder "%%i"...
    rd "%%i"
)

echo.
echo All files have been moved and empty folders have been removed.
pause
