@echo off
setlocal enabledelayedexpansion

:main_menu
cls
echo =================================================================
echo                      SAP Note Application
echo =================================================================
echo.
echo Please select an option:
echo.
echo    1. Process local SAR and TXT files
echo    2. Process and open URLs in Firefox
echo.
set /p "choice=Enter your choice (1 or 2): "

if /i "%choice%"=="1" goto file_processing
if /i "%choice%"=="2" goto url_processing
goto main_menu

:file_processing
cls
echo =================================================================
echo                File Processing Mode Activated
echo =================================================================

:file_process_loop
REM Check for and process any .SAR and .txt files
dir /b *.SAR >nul 2>&1
if not errorlevel 1 (
    for /f "delims=" %%F in ('dir /b *.SAR') do (
        set "sar_file=%%F"
        goto :process_sar
    )
)

REM Check for and process any .txt files left in the main folder
dir /b *.txt >nul 2>&1
if not errorlevel 1 (
    for /f "delims=" %%T in ('dir /b *.txt') do (
        REM Extract the SNOTE number from the filename up to the first space
        set "filename=%%~nT"
        
        :: Find the position of the first space and extract the SNOTE number
        for /f "tokens=1*" %%s in ("!filename!") do (
            set "snote_number=%%s"
        )
        
        REM Check if the folder exists; if not, create it
        if not exist "!snote_number!\" (
            mkdir "!snote_number!\"
            echo [+] Created folder for TXT file: !snote_number!
        )

        echo.
        echo Moving file: %%T to folder: !snote_number!
        move "%%T" "!snote_number!\" >nul 2>&1
                
        if errorlevel 1 (
                    echo Failed to move: %%T to !snote_number!
        ) else (
                    echo Successfully moved: %%T to !snote_number!
        )
    )
    REM No need to use goto here since the loop handles each file
)

REM This section is only reached when no files are found
echo.
echo All files have been processed. Waiting for new files.
echo Type "exit" or "E" and press Enter to return to the main menu.
echo.
set /p "user_input=>> "
if /i "!user_input!"=="exit" goto main_menu
if /i "!user_input!"=="e" goto main_menu

REM Wait for a moment and then loop back to check for files again
timeout /t 5 /nobreak >nul
goto file_process_loop

:process_sar
    REM Extract the folder name from the SAR filename
    set "folder_name=!sar_file:~3,-7!"

    REM Check if the folder exists, if not, create it
    if not exist "!folder_name!" (
        mkdir "!folder_name!"
        echo [+] Created folder: !folder_name!
    )

    echo.
    echo [+] Processing SNOTE !folder_name!
    
    REM Move the .SAR file to its respective folder
    echo Moving file: !sar_file! to folder: !folder_name!
    move "!sar_file!" "!folder_name!\" || (echo Failed to move: !sar_file! to !folder_name! & exit /b)

    REM Process all corresponding .txt files
    echo Searching for text files...
    for %%T in ("!folder_name!*.txt") do (
        echo Moving text file: %%T to folder: !folder_name!
        move "%%T" "!folder_name!\" || (echo Failed to move: %%T to !folder_name! & exit /b)
    )

    echo.
    echo Operation for SNOTE !folder_name! completed.
    
    :: The 5-second countdown before the next operation
    set /a countdown_time=5
    echo Time until next operation:
    :countdown_loop
        <nul set /p "=!countdown_time!..."
        timeout /t 1 /nobreak >nul
        set /a countdown_time-=1
        if !countdown_time! gtr 0 goto :countdown_loop

    echo.
    goto file_process_loop

:url_processing
cls
echo =================================================================
echo                 URL Processing Mode Activated
echo =================================================================
echo.
echo Paste a single URL and press Enter.
echo Type "exit" or "E" to return to the main menu.
echo.

:url_input_loop
set /p "user_input=>> "

if /i "!user_input!"=="exit" goto main_menu
if /i "!user_input!"=="e" goto main_menu

if not defined user_input (
    echo No URL entered.
    goto url_input_loop
)

echo Opening link: !user_input!
start "" "firefox" -new-tab "!user_input!"

goto url_input_loop

endlocal