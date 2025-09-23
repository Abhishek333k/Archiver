@echo off
setlocal enabledelayedexpansion

REM Define the base directory and the log file path
set "base_dir=%~dp0"
set "log_file=%base_dir%move_log.txt"

REM Change to the source directory
cd /d "%base_dir%" || (echo Failed to change directory to %base_dir% & exit /b)

echo Starting SAR and TXT file processing. All actions will be logged to %log_file%...
echo ------------------------------------------------------------------- >> "%log_file%"
echo Operation started at: %date% %time% >> "%log_file%"
echo ------------------------------------------------------------------- >> "%log_file%"

:main_loop
REM Find the first .SAR file to process
for /f "delims=" %%F in ('dir /b *.SAR') do (
    set "sar_file=%%F"
    goto :process_files
)

REM If no more .SAR files are found, the script exits the main loop
echo.
echo All SAR files have been processed.
echo. >> "%log_file%"
echo All SAR files have been processed. >> "%log_file%"
goto :end_script

:process_files
REM Get the current timestamp for the log
for /f "tokens=1-4 delims= /:" %%a in ("%date% %time%") do (
    set "timestamp=%%c-%%a-%%b %%d"
)

REM Extract the folder name from the SAR filename
set "folder_name=!sar_file:~3,-7!"

echo.
echo SNOTE file !sar_file! completed.
echo.

REM Start the 10-second countdown
set /a countdown_time=10

:countdown_loop
    echo Remaining time until next operation: !countdown_time! seconds
    timeout /t 1 /nobreak >nul
    set /a countdown_time-=1
    if !countdown_time! gtr 0 goto :countdown_loop

echo SNOTE folder created.
if not exist "!folder_name!" (
    echo !timestamp! - Creating new folder: !folder_name! >> "%log_file%"
    mkdir "!folder_name!" || (echo Failed to create folder !folder_name! & exit /b)
)

echo SAR file transferred.
echo !timestamp! - Moving file: !sar_file! to folder: !folder_name! >> "%log_file%"
move "!sar_file!" "!folder_name!\" || (echo Failed to move: !sar_file! to !folder_name! & exit /b)

echo Searching for text file.
for %%T in ("!folder_name!*.txt") do (
    echo Text file moved: %%T
    echo !timestamp! - Moving file: %%T to folder: !folder_name! >> "%log_file%"
    move "%%T" "!folder_name!\" || (echo Failed to move: %%T to !folder_name! & exit /b)
)

echo.
echo Operation for SNOTE !folder_name! completed.
echo.

REM Go back to the main loop to find the next .SAR file
goto :main_loop

:end_script
echo.
echo All operations completed.
echo ------------------------------------------------------------------- >> "%log_file%"
echo All operations completed at: %date% %time% >> "%log_file%"
echo ------------------------------------------------------------------- >> "%log_file%"
endlocal
pause