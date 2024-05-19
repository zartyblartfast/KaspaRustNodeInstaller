# Install Wasm32 Target Module

function InstallWasm32Target {
    param (
        [string]$rootFolder,
        [string]$logFile
    )
    write-output "****** InstallWasm32Target Function ******"

    $rustupPath = Join-Path -Path $env:USERPROFILE -ChildPath ".cargo\bin\rustup.exe"

    Refresh-Environment

    if (Test-Path $rustupPath) {
        try {
            Write-Output "Adding wasm32-unknown-unknown target..."
            LogMessage -message  "Adding wasm32-unknown-unknown target..." -logFile $logFile
            & $rustupPath target add wasm32-unknown-unknown 2>$null
            Write-Output "wasm32-unknown-unknown target added successfully"
            LogMessage -message  "wasm32-unknown-unknown target added successfully: $rustupPath." -logFile $logFile
        } catch {
            Write-Output "Failed to add wasm32-unknown-unknown target: $_"
            LogMessage -message  "Failed to add wasm32-unknown-unknown target: $_" -logFile $logFile
        }
    } else {
        Write-Output "Rust toolchain is not installed properly or rustup is not available."
        LogMessage -message  "Rust toolchain is not installed properly or rustup is not available." -logFile $logFile
    }
}
Export-ModuleMember -Function InstallWasm32Target
