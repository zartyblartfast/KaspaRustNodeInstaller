
#  install Git Module
function Install-Git {

    write-output "****** Install-Git Function ******"

    $url = "https://github.com/git-for-windows/git/releases/download/v2.45.0.windows.1/Git-2.45.0-64-bit.exe"
    $output = "$env:TEMP\Git-Installer.exe"

    LogMessage "Downloading Git installer..."
    try {
        Invoke-WebRequest -Uri $url -OutFile $output
    } catch {
        LogMessage "Error downloading Git installer: $_"
        return
    }
    
    LogMessage "Installing Git..."
    try {
        Start-Process -FilePath $output -Args "/VERYSILENT" -Wait -NoNewWindow
    } catch {
        LogMessage "Error installing Git: $_"
        return
    }

    Remove-Item -Path $output
}