# Install Git Module
function Install-Git {
    param (
        [string]$rootFolder,
        [string]$logFile
    )
    write-output "****** Install-Git Function ******"

    # Load configuration
    $configFilePath = Join-Path -Path $rootFolder -ChildPath "install_config.json"
    $config = Get-Content -Raw -Path $configFilePath | ConvertFrom-Json

    $url = $config.Git.url
    $output = "$env:TEMP\\Git-Installer.exe"

    # Check if Git is already installed
    try {
        $gitVersion = git --version
        Write-Output "Git is already installed: $gitVersion"
        LogMessage "Git is already installed: $gitVersion"
        return
    } catch {
        Write-Output "Git is not installed. Proceeding with installation..."
        LogMessage "Git is not installed. Proceeding with installation..."
    }

    LogMessage "Downloading Git installer..."
    try {
        Invoke-WebRequest -Uri $url -OutFile $output
    } catch {
        LogMessage "Error downloading Git installer: $_"
        Write-Output "Error: Failed to download Git installer. Check the log for details."
        return
    }
    
    LogMessage "Installing Git..."
    try {
        Start-Process -FilePath $output -Args "/VERYSILENT" -Wait -NoNewWindow
    } catch {
        LogMessage "Error installing Git: $_"
        Write-Output "Error: Failed to install Git. Check the log for details."
        return
    }

    LogMessage "Git installation completed successfully."
    Remove-Item -Path $output
}

Export-ModuleMember -Function Install-Git
