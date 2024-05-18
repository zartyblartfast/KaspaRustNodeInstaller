# Install Visual Studio Build Tools Module
function InstallVisualStudioBuildTools {
    param (
        [string]$rootFolder
    )
    write-output "****** InstallVisualStudioBuildTools Function ******"

    # Load configuration
    $configFilePath = Join-Path -Path $rootFolder -ChildPath "install_config.json"
    $config = Get-Content -Raw -Path $configFilePath | ConvertFrom-Json

    $url = $config.VisualStudioBuildTools.url
    $linkExePathPattern = 'C:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools\VC\Tools\MSVC\*\bin\Hostx64\x64\link.exe'
    
    LogMessage "Check if link.exe exists using the default path..."
    if (!(Test-Path $linkExePathPattern)) {
        Write-Output "MSVC Build Tools or 'link.exe' not found. Proceeding with installation..."
        LogMessage "MSVC Build Tools or 'link.exe' not found. Proceeding with installation..."

        $installerPath = "$env:TEMP\\vs_buildtools.exe"
        
        LogMessage "Downloading Visual Studio Build Tools installer..."
        try {
            Invoke-WebRequest -Uri $url -OutFile $installerPath
            Write-Output "Downloaded Visual Studio Build Tools installer to $installerPath"
            LogMessage "Downloaded Visual Studio Build Tools installer to $installerPath"
        } catch {
            LogMessage "Error downloading Visual Studio Build Tools installer: $_"
            Write-Output "Error downloading Visual Studio Build Tools installer: $_"
            return
        }

        $args = "--quiet --wait --norestart --nocache " +
                "--add Microsoft.VisualStudio.Workload.NativeDesktop " +
                "--add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 " +
                "--add Microsoft.VisualStudio.Component.Windows10SDK.19041"

        LogMessage "Executing the installer"
        try {
            Start-Process -FilePath $installerPath -ArgumentList $args -Wait
            Write-Output "Installation of Visual Studio Build Tools completed."
            LogMessage "Installation of Visual Studio Build Tools completed."
        } catch {
            LogMessage "Error during installation of Visual Studio Build Tools: $_"
            Write-Output "Error during installation of Visual Studio Build Tools: $_"
        }

        Remove-Item -Path $installerPath
    } else {
        Write-Output "MSVC Build Tools are correctly installed. 'link.exe' found."
        LogMessage "MSVC Build Tools are correctly installed. 'link.exe' found."
    }
}

Export-ModuleMember -Function InstallVisualStudioBuildTools
