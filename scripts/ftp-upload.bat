@echo off
REM ============================================================
REM  FTP Upload Script for Relational Drainage Theory Website
REM  Target: relationaldrainage.org
REM ============================================================
REM
REM  INSTRUCTIONS:
REM  1. Copy ftp-credentials.template.txt to ftp-credentials.txt
REM  2. Edit ftp-credentials.txt and set your FTP password
REM  3. Run this script from command prompt
REM
REM ============================================================

setlocal EnableDelayedExpansion

REM --- Get script directory ---
set SCRIPT_DIR=%~dp0
set CREDS_FILE=%SCRIPT_DIR%ftp-credentials.txt
set TEMPLATE_FILE=%SCRIPT_DIR%ftp-credentials.template.txt

REM --- Check if credentials file exists ---
if not exist "%CREDS_FILE%" (
    echo.
    echo ERROR: Credentials file not found: %CREDS_FILE%
    echo Please copy %TEMPLATE_FILE% to %CREDS_FILE% and fill in your password.
    echo.
    pause
    exit /b 1
)

REM --- Read credentials from file ---
for /f "tokens=1,* delims==" %%a in ('type "%CREDS_FILE%" ^| findstr /v "^#"') do (
    set "%%a=%%b"
)

REM --- Check if password is set ---
if "%password%"=="YOUR_FTP_PASSWORD_HERE" (
    echo.
    echo ERROR: Please edit ftp-credentials.txt and set your FTP password.
    echo.
    pause
    exit /b 1
)

REM --- Set local directory (parent of scripts folder) ---
set LOCAL_DIR=%SCRIPT_DIR%..

REM --- Create FTP command file ---
set FTP_SCRIPT=%TEMP%\ftp_upload_rdt.txt

echo user %username% %password%> "%FTP_SCRIPT%"
echo binary>> "%FTP_SCRIPT%"
echo cd %remote_folder%>> "%FTP_SCRIPT%"

REM Create directories
echo mkdir css>> "%FTP_SCRIPT%"
echo mkdir js>> "%FTP_SCRIPT%"
echo mkdir assets>> "%FTP_SCRIPT%"

REM Upload main HTML files
echo put "%LOCAL_DIR%\index.html" index.html>> "%FTP_SCRIPT%"
echo put "%LOCAL_DIR%\rdt-playground.html" rdt-playground.html>> "%FTP_SCRIPT%"

REM Upload CSS files
echo cd css>> "%FTP_SCRIPT%"
echo put "%LOCAL_DIR%\css\styles.css" styles.css>> "%FTP_SCRIPT%"
echo put "%LOCAL_DIR%\css\print.css" print.css>> "%FTP_SCRIPT%"
echo cd ..>> "%FTP_SCRIPT%"

REM Upload JS files
echo cd js>> "%FTP_SCRIPT%"
echo put "%LOCAL_DIR%\js\main.js" main.js>> "%FTP_SCRIPT%"
echo cd ..>> "%FTP_SCRIPT%"

echo bye>> "%FTP_SCRIPT%"

REM --- Execute FTP upload ---
echo.
echo ============================================================
echo  Uploading RDT website to relationaldrainage.org
echo ============================================================
echo.
echo Connecting to %host%...
echo.

ftp -n -s:"%FTP_SCRIPT%" %host%

REM --- Cleanup ---
del "%FTP_SCRIPT%" 2>nul

echo.
echo ============================================================
echo  Upload complete!
echo  Visit: https://relationaldrainage.org
echo ============================================================
echo.

pause
