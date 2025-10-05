@echo off
setlocal enabledelayedexpansion
title OmniFlow V2.0 TOOL

:main_menu
cls
echo ===========================================================
echo             OmniFlow V2.0 TOOL - MAIN MENU
echo ===========================================================
echo [1]  Open URLs in Firefox
echo [11] Open URLs based on SNOTE 
echo [2]  Process Files (.SAR and .TXT)
echo [3]  Rename Folders (Remove Leading Zeros)
echo [4]  Check for 0KB Files
echo [E]  Exit
echo ===========================================================
set /p "opt=Choose an option: "

if /i "%opt%"=="1" goto url_open
if /i "%opt%"=="11" goto sap_note_open
if /i "%opt%"=="2" goto file_processing
if /i "%opt%"=="3" goto rename_folders
if /i "%opt%"=="4" goto zero_kb_check

if /i "%opt%"=="E" exit
goto main_menu

:: ===========================================================
:url_open
cls
echo =================================================================
echo                 URL Processing Mode Activated
echo =================================================================
echo.
echo Paste a single URL and press Enter.
echo Type "exit" to return to the main menu.
echo.

:url_input_loop
set /p "user_input=>> "

if /i "!user_input!"=="e" goto main_menu

if not defined user_input (
    echo No URL entered.
    goto url_input_loop
)

echo Opening link: !user_input!
start "" "firefox" -new-tab "!user_input!"

goto url_input_loop

:: ===========================================================

:sap_note_open
cls
echo ===========================================================
echo             OPEN SAP NOTE IN FIREFOX
echo ===========================================================
echo Enter SAP Note Number to open (or type E to exit):
: open_snote
set /p "note=> "
if /i "%note%"=="E" goto main_menu
if "%note%"=="" goto url_open

REM Adjust Firefox path if installed elsewhere
set "firefox_path=C:\Program Files\Mozilla Firefox\firefox.exe"

if exist "%firefox_path%" (
    "%firefox_path%" "https://me.sap.com/notes/%note%"
) else (
    echo Firefox not found at "%firefox_path%"
    echo Please update the path in the script.
)
echo.
goto open_snote

:: ===========================================================

:file_processing
cls
echo ===========================================================
echo           FILE PROCESSING MODE ACTIVATED
echo ===========================================================

:file_process_loop
set "found=0"

for %%F in (*.SAR) do (
    set "sar_name=%%~nF"
    REM Remove leading zeros and suffix like _00
    set "temp_name=!sar_name:_00=!"
    for /f "tokens=* delims=0" %%x in ("!temp_name!") do set "clean_name=%%x"

    REM Ensure we have a valid number
    if not "!clean_name!"=="" (
        set "found=1"
        if not exist "!clean_name!\" (
            mkdir "!clean_name!"
            echo [+] Created folder: !clean_name!
        )

        echo Moving SAR file: %%F to !clean_name!\
        move "%%F" "!clean_name!\" >nul 2>&1

        REM Move related TXT file(s)
        for %%T in (*!clean_name!*.txt) do (
            echo Moving TXT file: %%T to !clean_name!\
            move "%%T" "!clean_name!\" >nul 2>&1
        )

        echo [+] Completed processing for SNOTE: !clean_name!
        echo Waiting 5 seconds before next file...
        timeout /t 5 /nobreak >nul
    )
)

if "!found!"=="0" (
    echo.
    echo No new .SAR files found.
    echo Type E to exit to menu, or press ENTER to check again.
    set /p "user_in=> "
    if /i "!user_in!"=="E" goto main_menu
)
goto file_process_loop

:: ===========================================================
:rename_folders
cls
echo ===========================================================
echo         RENAMING FOLDERS (REMOVE LEADING ZEROS)
echo ===========================================================
for /d %%D in (*) do (
    set "name=%%~nD"
    for /f "tokens=* delims=0" %%x in ("!name!") do set "newname=%%x"
    if not "!newname!"=="" if /i not "!newname!"=="!name!" (
        echo Renaming "%%D" to "!newname!"
        ren "%%D" "!newname!"
    )
)
echo.
echo Folder renaming completed.
pause
goto main_menu

:: ===========================================================
:zero_kb_check
cls
echo =================================================================
echo                0KB File Check and Log Mode Activated
echo =================================================================
echo.

set "base_dir=%~dp0"
set "log_file=%base_dir%zero_kb_links.log"

set /a sar_count=0
set /a txt_count=0

echo. > "%log_file%"
echo ================================================ >> "%log_file%"
echo            0KB Files Log - %date% %time% >> "%log_file%"
echo ================================================ >> "%log_file%"
echo. >> "%log_file%"

echo Finding 0KB .SAR files...
echo SAR Files: >> "%log_file%"
for %%F in (*.SAR) do (
    if %%~zF equ 0 (
        set "filename=%%~nF"
        set "snote=!filename:~3,-3!"
        echo Found 0KB SAR: %%F
        echo https://me.sap.com/notes/!snote! >> "%log_file%"
        set /a sar_count+=1
    )
)
echo Total 0KB SAR: !sar_count! >> "%log_file%"

echo Finding 0KB .TXT files...
echo TXT Files: >> "%log_file%"
for %%F in (*.txt) do (
    if %%~zF equ 0 (
        set "filename=%%~nF"
        for /f "tokens=1*" %%s in ("!filename!") do (
            set "snote=%%s"
        )
        echo Found 0KB TXT: %%F
        echo https://me.sap.com/notes/!snote! >> "%log_file%"
        set /a txt_count+=1
    )
)
echo Total 0KB TXT: !txt_count! >> "%log_file%"

echo.
echo Log created at: "%log_file%"

:after_zero
echo ------------------------------------------------------------
echo Operation completed.
echo [R] Repeat this operation
echo [M] Return to Main Menu
echo [E] Exit
echo ------------------------------------------------------------
set /p "action=>> "
if /i "!action!"=="R" goto zero_kb_check
if /i "!action!"=="M" goto main_menu
if /i "!action!"=="E" exit /b
goto after_zero
goto main_menu
