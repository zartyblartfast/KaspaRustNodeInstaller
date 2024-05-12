@echo off

:: Check for administrator privileges
net session >nul 2>&1
if %errorlevel% == 0 (
    echo Running with administrative privileges
    rem powershell -File "C:\path\to\your\script.ps1"
) else (
    echo Requesting administrative privileges...
    powershell -Command "Start-Process cmd -ArgumentList '/c %~0' -Verb runAs" >nul
    exit
)


set "DIRECTORY=C:\KaspaNode"

if not exist "%DIRECTORY%" (
    mkdir "%DIRECTORY%"
    echo Directory created: %DIRECTORY%
) else (
    echo Directory already exists: %DIRECTORY%
)


setlocal enabledelayedexpansion

REM Define file URLs and their respective names
set "FILE1=https://raw.githubusercontent.com/zartyblartfast/KaspaRustNodeInstaller/main/RustyKaspaInstall.ps1"
set "NAME1=%DIRECTORY%\RustyKaspaInstall.ps1"

set "FILE2=https://raw.githubusercontent.com/zartyblartfast/KaspaRustNodeInstaller/main/ascii_art.txt"
set "NAME2=%DIRECTORY%\ascii_art.txt"

set "FILE3=https://raw.githubusercontent.com/zartyblartfast/KaspaRustNodeInstaller/main/header.txt"
set "NAME3=%DIRECTORY%\header.txt"

set "FILE4=https://github.com/zartyblartfast/KaspaRustNodeInstaller/raw/main/README.md"
set "NAME4=%DIRECTORY%\readme.md"

set "FILE5=https://github.com/zartyblartfast/KaspaRustNodeInstaller/main/RunKaspaNode.bat"
set "NAME5=%DIRECTORY%\RunKaspaNode.bat"

REM Array of file names for easier access in loop (optional, for multiple files)
set "FILES=1 2 3 4 5"

for %%i in (%FILES%) do (
    set "CUR_FILE=!FILE%%i!"
    set "CUR_NAME=!NAME%%i!"
    
    echo Downloading !CUR_NAME! from !CUR_FILE!
    curl -L -o "!CUR_NAME!" "!CUR_FILE!"
    if !ERRORLEVEL! neq 0 (
        echo Failed to download !CUR_NAME!
    ) else (
        echo Successfully downloaded !CUR_NAME!
    )
)

endlocal

powershell -File "%DIRECTORY%\RustyKaspaInstall.ps1"
pause
