# Function to install or update Rust programming language toolchain
function InstallUpdateRust {
    param (
        [string]$rootFolder,
        [string]$logFile
    )
    <#
    .SYNOPSIS
    Installs or updates the Rust programming language toolchain.

    .DESCRIPTION
    This function installs or updates the Rust programming language toolchain. It checks if Rust is already installed,
    and if so, updates it to the latest version. If Rust is not installed, it installs it using the `rustup-init` installer.
    
    Rust is installed to the user-specific directory (C:\Users\<username>\.cargo) instead of the system-wide directory.
    This is because the `rustup-init` installer does not support installing to a custom system-wide directory directly,
    and managing user-specific installations is simpler and avoids potential permission issues on multi-user systems.

    The function also ensures that the Cargo bin path is added to the user PATH environment variable if it is not already present.

    .NOTES
    Ensure the script is run with appropriate permissions to modify the user PATH environment variable.

    .EXAMPLE
    InstallUpdateRust

    This will install or update Rust in the user-specific directory and update the user PATH environment variable.
    #>
    Write-Output "****** InstallUpdateRust Function ******"

    # Load configuration
    $configFilePath = Join-Path -Path $rootFolder -ChildPath "install_config.json"
    $config = Get-Content -Raw -Path $configFilePath | ConvertFrom-Json

    $url = $config.Rust.url
    $rustInstallDir = Join-Path -Path $env:USERPROFILE -ChildPath ".cargo"
    $cargoBinPath = Join-Path -Path $rustInstallDir -ChildPath "bin"
    $rustcPath = Join-Path -Path $cargoBinPath -ChildPath "rustc.exe"
    $rustupPath = Join-Path -Path $cargoBinPath -ChildPath "rustup.exe"

    LogMessage -message  "Check rustc Path: $rustcPath" -logFile $logFile
    LogMessage -message  "Check rustup Path: $rustupPath" -logFile $logFile

    if (Test-Path $rustcPath) {
        try {
            $rustcVersion = & $rustcPath --version
            Write-Output "Rust is already installed: $rustcVersion. Updating now..."
            LogMessage -message  "Rust is already installed: $rustcVersion. Updating now..." -logFile $logFile
            & $rustupPath update 2>$null
        } catch {
            Write-Output "An error occurred while trying to update Rust: $_"
            LogMessage -message  "An error occurred while trying to update Rust: $_" -logFile $logFile
        }
    } else {
        Write-Output "Rust is not installed. Installing now..."
        LogMessage -message  "Rust is not installed. Installing now..." -logFile $logFile
        
        $output = "$env:TEMP\\rustup-init.exe"
        try {
            Invoke-WebRequest -Uri $url -OutFile $output
            $installArgs = "--default-toolchain stable --profile minimal --no-modify-path -y"
            Write-Output "Running rustup-init.exe with arguments: $installArgs"
            Start-Process -FilePath $output -ArgumentList $installArgs -Wait -NoNewWindow -PassThru

            Write-Output "rustup-init.exe completed."

        } catch {
            LogMessage -message  "Error installing Rust: $_" -logFile $logFile
            Write-Output "Error installing Rust: $_"
            return
        }
        Remove-Item -Path $output

        # Verify installation
        if (Test-Path $rustcPath) {
            Write-Output "Rust installed successfully."
            LogMessage -message  "Rust installed successfully." -logFile $logFile
            Add-ToUserPath -pathToAdd $cargoBinPath
        } else {
            Write-Output "Rust installation failed. rustc.exe not found at $rustcPath"
            LogMessage -message  "Rust installation failed. rustc.exe not found at $rustcPath" -logFile $logFile
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
    LogMessage -message  "Checking Path environment variable for: $pathToAdd" -logFile $logFile

    $userPath = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::User)

    if (-not $userPath.Split(';').Contains($pathToAdd)) {
        $newUserPath = "$userPath;$pathToAdd"
        [System.Environment]::SetEnvironmentVariable("Path", $newUserPath, [System.EnvironmentVariableTarget]::User)
        Write-Output "Added '$pathToAdd' to user PATH."
        LogMessage -message  "Added '$pathToAdd' to user PATH." -logFile $logFile
    } else {
        Write-Output "'$pathToAdd' is already in user PATH."
        LogMessage -message  "'$pathToAdd' is already in user PATH." -logFile $logFile
    }
}

# Export the functions to be available when the module is imported
Export-ModuleMember -Function InstallUpdateRust, Add-ToUserPath
