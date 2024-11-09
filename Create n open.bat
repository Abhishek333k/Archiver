@echo off

:: Create folders for each SNOTE number
md 2176431
md 2176355
md 2176024
md 2175810
md 2175097
md 2174761
md 2174514
md 2173349
md 2173279

:: Open web pages in Firefox
start firefox "https://me.sap.com/notes/0002176431"
start firefox "https://me.sap.com/notes/0002176355"
start firefox "https://me.sap.com/notes/0002176024"
start firefox "https://me.sap.com/notes/0002175810"
start firefox "https://me.sap.com/notes/0002175097"
start firefox "https://me.sap.com/notes/0002174761"
start firefox "https://me.sap.com/notes/0002174514"
start firefox "https://me.sap.com/notes/0002173349"
start firefox "https://me.sap.com/notes/0002173279"

:: Pause to allow time for user to save files manually
pause
