@echo off
setlocal enabledelayedexpansion

:main_menu
cls
echo =================================================================
echo                      SAP Note Application
echo =================================================================
echo.
echo Please select an option to manage your files and links:
echo.
echo    1. URL Opener (Omega)
echo       - Opens a list of SAP Note links in Firefox.
echo.
echo    2. File Organizer (Alpha)
echo       - Automatically moves .SAR, .TXT, and .PDF files to SNOTE folders.
echo.
echo    3. File/Folder Renamer (Beta)
echo       - Standardizes the names of TXT files and folders.
echo.
echo    4. 0KB File Link Finder (Delta)
echo       - Finds all 0KB files and creates a log with their corresponding links.
echo.
set /p "choice=Enter your choice (1, 2, 3, or 4): "

if /i "%choice%"=="1" goto url_opener
if /i "%choice%"=="2" goto file_organizer
if /i "%choice%"=="3" goto file_renamer
if /i "%choice%"=="4" goto zero_kb_finder
goto main_menu

:file_organizer
cls
echo =================================================================
echo                File Organizer Mode Activated
echo =================================================================
echo.

:organizer_loop
REM --- Process all .SAR files in the current directory ---
dir /b *.SAR >nul 2>&1
if not errorlevel 1 (
    for /f "delims=" %%F in ('dir /b *.SAR') do (
        set "sar_file=%%F"
        
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
        :countdown_loop_sar
            <nul set /p "=!countdown_time!..."
            timeout /t 1 /nobreak >nul
            set /a countdown_time-=1
            if !countdown_time! gtr 0 goto :countdown_loop_sar
        echo.
    )
)

REM --- Process all .txt files left in the main folder ---
dir /b *.txt >nul 2>&1
if not errorlevel 1 (
    for /f "delims=" %%T in ('dir /b *.txt') do (
        set "txt_file=%%T"
        
        REM Extract the SNOTE number from the filename
        set "filename=%%~nT"
        
        for /f "tokens=1*" %%s in ("!filename!") do (
            set "snote_number=%%s"
        )

        REM Check if the folder exists; if not, create it
        if not exist "!snote_number!\" (
            mkdir "!snote_number!\"
            echo [+] Created folder for TXT file: !snote_number!
        )

        echo.
        echo Moving file: !txt_file! to folder: !snote_number!
        move "!txt_file!" "!snote_number!\" >nul 2>&1
        if errorlevel 1 (
            echo Failed to move: !txt_file! to !snote_number!
        ) else (
            echo Successfully moved: !txt_file! to !snote_number!
        )
    )
)

REM --- Process all .pdf files left in the main folder ---
dir /b *.pdf >nul 2>&1
if not errorlevel 1 (
    for /f "delims=" %%P in ('dir /b *.pdf') do (
        set "pdf_file=%%P"
        
        set "file_name=%%~nP"
        for /f "tokens=1 delims=-" %%A in ("!file_name!") do (
            set "folder_name=%%A"
        )
        set "folder_name=!folder_name: =!"

        if not exist "!folder_name!\" (
            mkdir "!folder_name!\" || (echo Failed to create folder !folder_name! & exit /b)
            echo [+] Created folder: !folder_name!
        ) else (
            echo Folder already exists: !folder_name!
        )

        echo Moving file: !pdf_file! to folder: !folder_name!
        move "!pdf_file!" "!folder_name!\" || (echo Failed to move: !pdf_file! to !folder_name! & exit /b)
    )
)

echo.
echo All files have been processed. Waiting for new files.
echo Type "exit" or "E" and press Enter to return to the main menu.
echo.
set /p "user_input=>> "
if /i "!user_input!"=="exit" goto main_menu
if /i "!user_input!"=="e" goto main_menu

timeout /t 5 /nobreak >nul
goto organizer_loop

:url_opener
cls
echo =================================================================
echo                 URL Opener Mode Activated
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

:file_renamer
cls
echo =================================================================
echo               File/Folder Renamer Mode Activated
echo =================================================================

REM Clean up TXT files by removing " - SAP for Me"
echo Renaming TXT files...
for %%F in (*.txt) do (
    set "file_name=%%~nxF"
    set "new_file_name=!file_name:- SAP for Me=!"
    if not "!file_name!"=="!new_file_name!" (
        echo Renaming "%%F" to "!new_file_name!"
        ren "%%F" "!new_file_name!" || (echo Failed to rename "%%F" & exit /b)
    )
)

REM Remove leading zeros from folder names
echo.
echo Renaming folders by removing leading zeros...
for /d %%F in (0*) do (
    set "folder_name=%%~nxF"
    for /f "tokens=* delims=0" %%A in ("!folder_name!") do set "new_folder_name=%%A"
    if defined new_folder_name (
        if not "!folder_name!"=="!new_folder_name!" (
            echo Renaming "%%F" to "!new_folder_name!"
            ren "%%F" "!new_folder_name!" || (echo Failed to rename "%%F")
        )
    )
)
echo.
echo Renaming operation completed.
pause
goto main_menu

:zero_kb_finder
cls
echo =================================================================
echo               0KB File Link Finder Mode Activated
echo =================================================================
echo.
set "log_file=%~dp0zero_kb_links.log"
set /a sar_count=0
set /a txt_count=0
echo. > "%log_file%"
echo ================================================ >> "%log_file%"
echo           0KB Files Log - %date% %time% >> "%log_file%"
echo ================================================ >> "%log_file%"
echo. >> "%log_file%"
echo Starting search for 0KB files in all subfolders...

echo Finding 0KB .SAR files...
echo SAR Files: >> "%log_file%"
echo ---------- >> "%log_file%"
for /R %%F in (*.SAR) do (
    if %%~zF equ 0 (
        set "filename=%%~nxF"
        set "snote=!filename:~3,-3!"
        echo Found 0KB file: %%F
        echo https://me.sap.com/notes/!snote! >> "%log_file%"
        set /a sar_count+=1
    )
)
echo Total 0KB SAR files found: !sar_count! >> "%log_file%"
echo. >> "%log_file%"

echo Finding 0KB .TXT files...
echo TXT Files: >> "%log_file%"
echo ---------- >> "%log_file%"
for /R %%F in (*.txt) do (
    if %%~zF equ 0 (
        set "filename=%%~nxF"
        for /f "tokens=1*" %%s in ("!filename!") do (
            set "snote=%%s"
        )
        echo Found 0KB file: %%F
        echo https://me.sap.com/notes/!snote! >> "%log_file%"
        set /a txt_count+=1
    )
)
echo Total 0KB TXT files found: !txt_count! >> "%log_file%"
echo.
echo All operations completed. A log file has been created.
pause
goto main_menu
