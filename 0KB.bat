@echo off
setlocal enabledelayedexpansion

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
