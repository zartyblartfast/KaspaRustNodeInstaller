# Function to install wasm-pack using Cargo
function InstallWasmPack {
    param (
        [string]$rootFolder,
        [string]$logFile
    )
    Write-Output "****** InstallWasmPack Function ******"

    $wasmPackExecutable = Join-Path -Path $env:USERPROFILE -ChildPath ".cargo\bin\wasm-pack.exe"
    
    Write-Output "wasmPackExecutable: $wasmPackExecutable"
    Ensure-CargoAccess

    if (Test-Path $wasmPackExecutable) {
        try {
            $wasmPackVersion = & $wasmPackExecutable --version
            Write-Output "wasm-pack is already installed: $wasmPackVersion."
            & LogMessage "wasm-pack is already installed: $wasmPackVersion."
        } catch {
            Write-Output "Error checking wasm-pack version: $_"
            & LogMessage "Error checking wasm-pack version: $_"
        }
    } else {
        Write-Output "wasm-pack is not installed. Installing now..."
        & LogMessage "wasm-pack is not installed. Installing now..."
        try {
            $cargoExecutable = Join-Path -Path $env:USERPROFILE -ChildPath ".cargo\bin\cargo.exe"
            $null = & $cargoExecutable install wasm-pack 2>&1
            Write-Output "wasm-pack installation attempted."
            & LogMessage "wasm-pack installation attempted."
        } catch {
            Write-Output "wasm-pack installation failed: $_"
            & LogMessage "wasm-pack installation failed: $_"
        }
    }
}


Export-ModuleMember -Function InstallWasmPack
