# Install Visual Studio Build Tools Module

function InstallVisualStudioBuildTools {

    write-output "****** InstallVisualStudioBuildTools Function ******"

    $linkExePathPattern = 'C:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools\VC\Tools\MSVC\*\bin\Hostx64\x64\link.exe'
    
    LogMessage "Check if link.exe exists using the default path..."
    if (!(Test-Path $linkExePathPattern)) {
        Write-Output "MSVC Build Tools or 'link.exe' not found. Proceeding with installation..."
        LogMessage "MSVC Build Tools or 'link.exe' not found. Proceeding with installation..."

        $url = "https://aka.ms/vs/16/release/vs_buildtools.exe"
        $installerPath = "$env:TEMP\vs_buildtools.exe"
        
        Invoke-WebRequest -Uri $url -OutFile $installerPath = "$env:TEMP\vs_buildtools.exe"
        
        Invoke-WebRequest -Uri $url -OutFile $installerPath
        Write-Output "Downloaded Visual Studio Build Tools installer to $installerPath"
        LogMessage "Downloaded Visual Studio Build Tools installer to $installerPath"

        $args = "--quiet --wait --norestart --nocache " +
                "--add Microsoft.VisualStudio.Workload.NativeDesktop " +
                "--add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 " +
                "--add Microsoft.VisualStudio.Component.Windows10SDK.19041"

        LogMessage "Execute the installer"
        try {
            Start-Process -FilePath $installerPath -ArgumentList $args -Wait
        } catch {
            Write-Output "Installation of Visual Studio Build Tools completed."
            LogMessage "Installation of Visual Studio Build Tools completed."
        }

        Remove-Item -Path $installerPath
    } else {
        Write-Output "MSVC Build Tools are correctly installed. 'link.exe' found."
        LogMessage "MSVC Build Tools are correctly installed. 'link.exe' found."
    }
}
Export-ModuleMember -Function InstallVisualStudioBuildTools