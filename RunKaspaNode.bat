@echo off

REM Set the directory path
set "KASPA_DIR=C:\KaspaNode\rusty-kaspa"

echo Starting Kaspa node...

REM Check if the directory exists
if not exist "%KASPA_DIR%\*" (
    echo Error: Kaspa node directory does not exist.
    echo Please check the directory path and try again.
    pause
    exit
)

REM Change to the Kaspa node directory
cd /d "%KASPA_DIR%"

REM Run the Kaspa node
cargo run --release --bin kaspad

echo Kaspa node has been started.
pause

