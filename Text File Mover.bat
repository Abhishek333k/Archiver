@echo off
setlocal enabledelayedexpansion

:: Set the source directory where text files and SNOTE folders are located
set "source_dir=C:\Folder A"  :: Update this path to your actual source directory

:: Change to the source directory
cd /d "!source_dir!" || exit /b

:: Loop through all text files in the source directory
for %%f in (*.txt) do (
    :: Extract the SNOTE number from the filename up to the first space
    set "filename=%%~nf"
    
    :: Find the position of the first space
    for /f "tokens=1*" %%s in ("!filename!") do (
        set "snote=%%s"
        echo Moving file: %%f to folder: !snote!
        
        :: Check if the target folder exists before moving
        if exist "!source_dir!\!snote!\" (
            move "%%f" "!source_dir!\!snote!\" >nul 2>&1
            
            :: Check if the move was successful
            if errorlevel 1 (
                echo Failed to move: %%f to !snote!
            ) else (
                echo Successfully moved: %%f to !snote!
            )
        ) else (
            echo Folder does not exist: !snote!
        )
    )
)

echo Move operation completed.
pause
endlocal
