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

set "FILE2=https://raw.githubusercontent.com/zartyblartfast/KaspaRustNodeInstaller/main/CloneRustyKaspa.psm1"
set "NAME2=%DIRECTORY%\CloneRustyKaspa.psm1"

set "FILE3=https://raw.githubusercontent.com/zartyblartfast/KaspaRustNodeInstaller/main/header.psm1"
set "NAME3=%DIRECTORY%\header.psm1"

set "FILE4=https://raw.githubusercontent.com/zartyblartfast/KaspaRustNodeInstaller/main/installGit.psm1"
set "NAME4=%DIRECTORY%\installGit.psm1"

set "FILE5=https://raw.githubusercontent.com/zartyblartfast/KaspaRustNodeInstaller/main/InstallLLVM.psm1"
set "NAME5=%DIRECTORY%\InstallLLVM.psm1"

set "FILE6=https://raw.githubusercontent.com/zartyblartfast/KaspaRustNodeInstaller/main/InstallProtocolBuffers.psm1"
set "NAME6=%DIRECTORY%\InstallProtocolBuffers.psm1"

set "FILE7=https://raw.githubusercontent.com/zartyblartfast/KaspaRustNodeInstaller/main/InstallVisualStudioBuildTools.psm1"
set "NAME7=%DIRECTORY%\InstallVisualStudioBuildTools.psm1"

set "FILE8=https://raw.githubusercontent.com/zartyblartfast/KaspaRustNodeInstaller/main/InstallWasm32Target.psm1"
set "NAME8=%DIRECTORY%\InstallWasm32Target.psm1"

set "FILE9=https://raw.githubusercontent.com/zartyblartfast/KaspaRustNodeInstaller/main/InstallWasmPack.psm1"
set "NAME9=%DIRECTORY%\InstallWasmPack.psm1"

set "FILE10=https://raw.githubusercontent.com/zartyblartfast/KaspaRustNodeInstaller/main/RustInstaller.psm1"
set "NAME10=%DIRECTORY%\RustInstaller.psm1"

set "FILE11=https://raw.githubusercontent.com/zartyblartfast/KaspaRustNodeInstaller/main/Utility.psm1"
set "NAME11=%DIRECTORY%\Utility.psm1"

set "FILE12=https://raw.githubusercontent.com/zartyblartfast/KaspaRustNodeInstaller/main/ascii_art.txt"
set "NAME12=%DIRECTORY%\ascii_art.txt"

set "FILE13=https://raw.githubusercontent.com/zartyblartfast/KaspaRustNodeInstaller/main/header.txt"
set "NAME13=%DIRECTORY%\header.txt"

set "FILE14=https://github.com/zartyblartfast/KaspaRustNodeInstaller/raw/main/README.md"
set "NAME14=%DIRECTORY%\readme.md"

set "FILE15=https://raw.githubusercontent.com/zartyblartfast/KaspaRustNodeInstaller/main/RunKaspaNode.bat"
set "NAME15=%DIRECTORY%\RunKaspaNode.bat"

set "FILE16=https://raw.githubusercontent.com/zartyblartfast/KaspaRustNodeInstaller/main/install_config.json"
set "NAME16=%DIRECTORY%\install_config.json"

REM Array of file names for easier access in loop (optional, for multiple files)
set "FILES=1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16"

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

rem powershell -File "%DIRECTORY%\RustyKaspaInstall.ps1"

pause
