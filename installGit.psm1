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
        LogMessage -message  "Git is already installed: $gitVersion" -logFile $logFile
        return
    } catch {
        Write-Output "Git is not installed. Proceeding with installation..."
        LogMessage -message  "Git is not installed. Proceeding with installation..." -logFile $logFile
    }

    LogMessage -message  "Downloading Git installer..." -logFile $logFile
    try {
        Invoke-WebRequest -Uri $url -OutFile $output
    } catch {
        LogMessage -message  "Error downloading Git installer: $_" -logFile $logFile
        Write-Output "Error: Failed to download Git installer. Check the log for details."
        return
    }
    
    LogMessage -message  "Installing Git..." -logFile $logFile
    try {
        Start-Process -FilePath $output -Args "/VERYSILENT" -Wait -NoNewWindow
    } catch {
        LogMessage -message  "Error installing Git: $_" -logFile $logFile
        Write-Output "Error: Failed to install Git. Check the log for details."
        return
    }

    LogMessage -message  "Git installation completed successfully." -logFile $logFile
    Remove-Item -Path $output
}

Export-ModuleMember -Function Install-Git
