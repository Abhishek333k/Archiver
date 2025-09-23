@echo off
setlocal enabledelayedexpansion

:: Set the Firefox executable path. YOU MUST UPDATE THIS PATH
:: if your Firefox installation is in a different location.
set "firefox_path=C:\Program Files\Mozilla Firefox\firefox.exe"

:main_loop
:: Clear previous variables for a new set of URLs
set "urls_list="

echo =================================================================
echo URL Processor & Folder Creator
echo =================================================================
echo.
echo Paste a single URL and press Enter.
echo Close this window to exit the script.
echo.

:input_loop
set /p "user_input=>> "

:: Check if the user input is empty
if not defined user_input (
    echo No URL entered.
    goto :input_loop
)

:: Extract the SNOTE number and build the folder path
for %%N in ("!user_input!") do (
    set "snote_number=%%~nN"
    set "snote_number=!snote_number:notes/=!"
    
    :: Check if the folder exists, if not, create it
    if not exist "!snote_number!" (
        mkdir "!snote_number!"
        echo [+] Created folder: !snote_number!
    )
)

echo Opening link in Firefox...
"%firefox_path%" -new-tab "!user_input!"

echo.
goto :input_loop

endlocal
