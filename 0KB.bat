@echo off
setlocal enabledelayedexpansion

REM Define the base directory and the log file path
set "base_dir=%~dp0"
set "log_file=%base_dir%zero_kb_links.log"

REM Initialize counters
set /a sar_count=0
set /a txt_count=0

REM Clear the log file and add a header
echo. > "%log_file%"
echo ================================================ >> "%log_file%"
echo           0KB Files Log - %date% %time% >> "%log_file%"
echo ================================================ >> "%log_file%"
echo. >> "%log_file%"

echo Starting search for 0KB files...

REM --- Process all .SAR files ---
echo Finding 0KB .SAR files...
echo SAR Files: >> "%log_file%"
echo ---------- >> "%log_file%"

for %%F in (*.SAR) do (
    if %%~zF equ 0 (
        REM Extract SNOTE number for .SAR file
        set "filename=%%~nF"
        set "snote=!filename:~3,-3!"
        
        echo Found 0KB file: %%F
        echo https://me.sap.com/notes/!snote! >> "%log_file%"
        set /a sar_count+=1
    )
)

echo Total 0KB SAR files found: !sar_count!
echo Total 0KB SAR files found: !sar_count! >> "%log_file%"
echo. >> "%log_file%"

REM --- Process all .TXT files ---
echo Finding 0KB .TXT files...
echo TXT Files: >> "%log_file%"
echo ---------- >> "%log_file%"

for %%F in (*.txt) do (
    if %%~zF equ 0 (
        REM Extract SNOTE number for .TXT file
        set "filename=%%~nF"
        for /f "tokens=1*" %%s in ("!filename!") do (
            set "snote=%%s"
        )
        
        echo Found 0KB file: %%F
        echo https://me.sap.com/notes/!snote! >> "%log_file%"
        set /a txt_count+=1
    )
)

echo Total 0KB TXT files found: !txt_count!
echo Total 0KB TXT files found: !txt_count! >> "%log_file%"
echo.

echo All operations completed.
echo A log file has been created at: "%log_file%"
pause

endlocal