# Install Visual Studio Build Tools Module
function InstallVisualStudioBuildTools {
    param (
        [string]$rootFolder,
        [string]$logFile
    )
    write-output "****** InstallVisualStudioBuildTools Function ******"

    # Load configuration
    $configFilePath = Join-Path -Path $rootFolder -ChildPath "install_config.json"
    $config = Get-Content -Raw -Path $configFilePath | ConvertFrom-Json

    $url = $config.VisualStudioBuildTools.url
    $linkExePathPattern = 'C:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools\VC\Tools\MSVC\*\bin\Hostx64\x64\link.exe'
    
    LogMessage -message "Check if link.exe exists using the default path..."c
    if (!(Test-Path $linkExePathPattern)) {
        Write-Output "MSVC Build Tools or 'link.exe' not found. Proceeding with installation..."
        LogMessage -message  "MSVC Build Tools or 'link.exe' not found. Proceeding with installation..." -logFile $logFile

        $installerPath = "$env:TEMP\\vs_buildtools.exe"
        
        LogMessage -message  "Downloading Visual Studio Build Tools installer..." -logFile $logFile
        try {
            Invoke-WebRequest -Uri $url -OutFile $installerPath
            Write-Output "Downloaded Visual Studio Build Tools installer to $installerPath"
            LogMessage -message  "Downloaded Visual Studio Build Tools installer to $installerPath" -logFile $logFile
        } catch {
            LogMessage -message  "Error downloading Visual Studio Build Tools installer: $_" -logFile $logFile
            Write-Output "Error downloading Visual Studio Build Tools installer: $_"
            return
        }

        $args = "--quiet --wait --norestart --nocache " +
                "--add Microsoft.VisualStudio.Workload.NativeDesktop " +
                "--add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 " +
                "--add Microsoft.VisualStudio.Component.Windows10SDK.19041"

        LogMessage -message  "Executing the installer" -logFile $logFile
        try {
            Start-Process -FilePath $installerPath -ArgumentList $args -Wait
            Write-Output "Installation of Visual Studio Build Tools completed."
            LogMessage -message  "Installation of Visual Studio Build Tools completed." -logFile $logFile
        } catch {
            LogMessage -message  "Error during installation of Visual Studio Build Tools: $_" -logFile $logFile
            Write-Output "Error during installation of Visual Studio Build Tools: $_"
        }

        Remove-Item -Path $installerPath
    } else {
        Write-Output "MSVC Build Tools are correctly installed. 'link.exe' found."
        LogMessage -message  "MSVC Build Tools are correctly installed. 'link.exe' found." -logFile $logFile
    }
}

Export-ModuleMember -Function InstallVisualStudioBuildTools
