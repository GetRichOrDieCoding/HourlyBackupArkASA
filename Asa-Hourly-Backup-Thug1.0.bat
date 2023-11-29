@echo off
cls

REM Set the paths for 7-Zip, source, and output directories
set SEVENZIP=C:\7-zip\7z.exe
set SOURCE_DIR=C:\ASA-Island-Test\Server\ShooterGame\Saved
set OUTPUT_DIR=C:\ASA-Island-Test\Backups

REM Set up initial variables
set previousHour=0

:BACKUP
REM Get the current date and time
for /f "delims=" %%a in ('wmic OS Get localdatetime ^| find "."') do set datetime=%%a
set "currentDateTime=%datetime:~0,4%-%datetime:~4,2%-%datetime:~6,2%_%datetime:~8,2%-%datetime:~10,2%"

REM Get the current hour
for /f "tokens=1-2 delims=:" %%a in ("%time%") do (
    set /a "currentHour=%%a"
)

REM Perform a backup every hour on the hour
if %currentHour% neq %previousHour% (
    echo Performing hourly backup...

    REM Create the Zip file with the current date and time as the file name. Change to .7z for higher compression.
    "%SEVENZIP%" a "%OUTPUT_DIR%\%currentDateTime%.zip" "%SOURCE_DIR%\*"

    echo Backup done
    echo Waiting for the next hour...

    set previousHour=%currentHour%
)

REM Wait for 1 minute (adjust as needed)
timeout /t 60 /nobreak > nul
goto BACKUP