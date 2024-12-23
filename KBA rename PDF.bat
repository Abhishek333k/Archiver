@echo off
setlocal enabledelayedexpansion

:: Define the base directory as the directory of the current script
set "base_dir=%~dp0"

:: Change to the base directory
cd /d "%base_dir%" || (echo Failed to change directory to %base_dir% & exit /b)

:: Loop through each PDF file in the base directory
for %%F in (*.pdf) do (
    set "file_name=%%~nxF"
    
    :: Remove the specified substring from the filename
    set "new_file_name=!file_name:_E_20241223=!"

    :: Check if the new filename is different from the original and not empty
    if not "!file_name!"=="!new_file_name!" (
        :: Check if the new filename already exists
        if exist "!new_file_name!" (
            echo Deleting existing file "!new_file_name!"...
            del "!new_file_name!" || (echo Failed to delete "!new_file_name!" & exit /b)
        )
        
        echo Renaming "%%F" to "!new_file_name!"
        ren "%%F" "!new_file_name!" || (echo Failed to rename "%%F" & exit /b)
    )
)

echo File renaming operation completed.
endlocal
pause
