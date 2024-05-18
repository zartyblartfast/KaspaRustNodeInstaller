function InstallUpdateRust {
    Write-Output "****** InstallUpdateRust Function ******"

    $rustInstallDir = Join-Path -Path $env:USERPROFILE -ChildPath ".cargo"
    $cargoBinPath = Join-Path -Path $rustInstallDir -ChildPath "bin"
    $rustcPath = Join-Path -Path $cargoBinPath -ChildPath "rustc.exe"
    $rustupPath = Join-Path -Path $cargoBinPath -ChildPath "rustup.exe"

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
            $installArgs = "--default-toolchain stable --profile minimal --no-modify-path -y"
            Write-Output "Running rustup-init.exe with arguments: $installArgs"
            Start-Process -FilePath $output -ArgumentList $installArgs -Wait -NoNewWindow -PassThru

            Write-Output "rustup-init.exe completed."

        } catch {
            LogMessage "Error installing Rust: $_"
            Write-Output "Error installing Rust: $_"
            return
        }
        Remove-Item -Path $output

        # Verify installation
        if (Test-Path $rustcPath) {
            Write-Output "Rust installed successfully."
            Write-Output "Rust installed successfully."
            LogMessage "Rust installed successfully."
            Add-ToUserPath -pathToAdd $cargoBinPath
        } else {
            Write-Output "Rust installation failed. rustc.exe not found at $rustcPath"
            LogMessage "Rust installation failed. rustc.exe not found at $rustcPath"
        }
    }

    # Directly add Cargo bin path to user PATH
    Add-ToUserPath -pathToAdd $cargoBinPath
}

# Function to add a directory to the user PATH if it is not already present
function Add-ToUserPath {
    param(
        [string]$pathToAdd
    )
    Write-Output "****** Add-ToUserPath Function ******"
    LogMessage "Checking Path environment variable for: $pathToAdd"

    $userPath = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::User)

    if (-not $userPath.Split(';').Contains($pathToAdd)) {
        $newUserPath = "$userPath;$pathToAdd"
        [System.Environment]::SetEnvironmentVariable("Path", $newUserPath, [System.EnvironmentVariableTarget]::User)
        Write-Output "Added '$pathToAdd' to user PATH."
        LogMessage "Added '$pathToAdd' to user PATH."
    } else {
        Write-Output "'$pathToAdd' is already in user PATH."
        LogMessage "'$pathToAdd' is already in user PATH."
    }
}

# Export the functions to be available when the module is imported
Export-ModuleMember -Function InstallUpdateRust, Add-ToUserPath
