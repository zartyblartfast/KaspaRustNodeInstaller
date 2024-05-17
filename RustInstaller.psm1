# RustInstaller.psm1
function InstallUpdateRust {
    write-output "****** InstallUpdateRust Function ******"

    $rustcPath = Join-Path -Path $env:USERPROFILE -ChildPath ".cargo\bin\rustc.exe"
    $rustupPath = Join-Path -Path $env:USERPROFILE -ChildPath ".cargo\bin\rustup.exe"

    LogMessage "Check rustc Path: $rustcPath"
    LogMessage "Check rustup Path: $rustupPath"

    if (Test-Path $rustcPath) {
        try {
            $rustcVersion = & $rustcPath --version
            Write-Output "Rust is already installed: $rustcVersion. Updating now..."
            LogMessage "Rust is already installed: $rustcVersion. Updating now..."
            & $rustupPath update 2>$null
        } catch {
            Write-Output "An error occurred while trying to update Rust: $_"
            LogMessage "An error occurred while trying to update Rust: $_"
        }
    } else {
        Write-Output "Rust is not installed. Installing now..."
        LogMessage "Rust is not installed. Installing now..."
        $url = "https://win.rustup.rs"
        $output = "$env:TEMP\rustup-init.exe"
        try {
            Invoke-WebRequest -Uri $url -OutFile $output
            Start-Process -FilePath $output -Args "-y" -Wait -NoNewWindow
        } catch {
            LogMessage "Error installing Rust: $_"
            return
        }
        Remove-Item -Path $output

        Add-ToSystemPath -pathToAdd "$env:USERPROFILE\.cargo\bin"
    }

    Ensure-CargoAccess
}

Export-ModuleMember -Function InstallUpdateRust