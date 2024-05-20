# Function to install wasm-pack using Cargo
function InstallWasmPack {
    param (
        [string]$rootFolder,
        [string]$logFile
    )
    Write-Output "****** InstallWasmPack Function ******"

    $wasmPackExecutable = Join-Path -Path $env:USERPROFILE -ChildPath ".cargo\bin\wasm-pack.exe"
    
    Write-Output "wasmPackExecutable: $wasmPackExecutable"
    Ensure-CargoAccess -logFile $logFile

    if (Test-Path $wasmPackExecutable) {
        try {
            $wasmPackVersion = & $wasmPackExecutable --version
            Write-Output "wasm-pack is already installed: $wasmPackVersion."
            LogMessage -message  "wasm-pack is already installed: $wasmPackVersion." -logFile $logFile
        } catch {
            Write-Output "Error checking wasm-pack version: $_"
            LogMessage -message  "Error checking wasm-pack version: $_" -logFile $logFile
        }
    } else {
        Write-Output "wasm-pack is not installed. Installing now..."
        LogMessage -message  "wasm-pack is not installed. Installing now..." -logFile $logFile
        try {
            $cargoExecutable = Join-Path -Path $env:USERPROFILE -ChildPath ".cargo\bin\cargo.exe"
            $null = & $cargoExecutable install wasm-pack 2>&1
            Write-Output "wasm-pack installation attempted."
            LogMessage -message  "wasm-pack installation attempted." -logFile $logFile
        } catch {
            Write-Output "wasm-pack installation failed: $_"
            LogMessage -message  "wasm-pack installation failed: $_" -logFile $logFile
        }
    }
}


Export-ModuleMember -Function InstallWasmPack
