@echo off
setlocal enabledelayedexpansion

REM Define the base directory as the directory of the current script
set "base_dir=%~dp0"

REM Change to the base directory
cd /d "%base_dir%" || (echo Failed to change directory to %base_dir% & exit /b)

REM Loop through each folder in the base directory that starts with a digit
for /d %%F in (0*) do (
    set "folder_name=%%~nxF"

    REM Convert folder name to number and back to string (removes leading zeros)
    for /f "tokens=* delims=0" %%A in ("!folder_name!") do set "new_folder_name=%%A"

    REM Ensure new folder name is not empty and different from original
    if defined new_folder_name (
        if not "!folder_name!"=="!new_folder_name!" (
            echo Renaming "%%F" to "!new_folder_name!"
            ren "%%F" "!new_folder_name!" || (echo Failed to rename "%%F")
        )
    ) else (
        echo Skipping "%%F" because it would result in an empty name.
    )
)

echo Folder renaming operation completed.
endlocal
pause
