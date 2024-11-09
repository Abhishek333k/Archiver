@echo off
setlocal enabledelayedexpansion

:: Create folders for each SNOTE number
md Folder1
md Folder2
md Folder3
md Folder4
md Folder5
md Folder6
md Folder7
md Folder8
md Folder9 :: Continue this as many folders you need 

:: Initialize the command string for Firefox
set "firefox_command=start firefox"

:: Read each line from the urls.txt file and append to the command string
for /f "usebackq delims=" %%u in ("C:\Path\To\Your\urls.txt") do (
    set "url=%%u"
    set "firefox_command=!firefox_command! -new-tab !url!"
)

:: Execute the command to open all URLs in new tabs
!firefox_command!

:: Pause to allow time for user to save files manually
pause

endlocal
