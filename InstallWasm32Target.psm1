# Install Wasm32 Target Module

function InstallWasm32Target {
    param (
        [string]$rootFolder
    )
    write-output "****** InstallWasm32Target Function ******"

    $rustupPath = Join-Path -Path $env:USERPROFILE -ChildPath ".cargo\bin\rustup.exe"

    Refresh-Environment

    if (Test-Path $rustupPath) {
        try {
            Write-Output "Adding wasm32-unknown-unknown target..."
            LogMessage "Adding wasm32-unknown-unknown target..."
            & $rustupPath target add wasm32-unknown-unknown 2>$null
            Write-Output "wasm32-unknown-unknown target added successfully"
            LogMessage "wasm32-unknown-unknown target added successfully: $rustupPath."
        } catch {
            Write-Output "Failed to add wasm32-unknown-unknown target: $_"
            LogMessage "Failed to add wasm32-unknown-unknown target: $_"
        }
    } else {
        Write-Output "Rust toolchain is not installed properly or rustup is not available."
        LogMessage "Rust toolchain is not installed properly or rustup is not available."
    }
}
Export-ModuleMember -Function InstallWasm32Target
