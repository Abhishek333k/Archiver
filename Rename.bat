@echo off
setlocal enabledelayedexpansion

:: Set the directory containing your PDF files
set "directory=C:\Path\To\Your\PDFs"  :: Update this path

:: Change to that directory
cd /d "%directory%"

:: Loop through all PDF files in the directory
for %%f in (*_E_20241123.pdf) do (
    :: Get the base name without the suffix
    set "filename=%%~nf"
    set "newname=!filename:_E_20241123=!.pdf"
    
    :: Rename the file
    ren "%%f" "!newname!"
)

echo Renaming complete.
pause
endlocal
