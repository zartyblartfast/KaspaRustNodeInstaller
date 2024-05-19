# Install Protocol Buffers Module
function InstallProtocolBuffers {
    param (
        [string]$rootFolder,
        [string]$logFile
    )
    write-output "****** Install-ProtocolBuffers Function ******"

    # Load configuration
    $configFilePath = Join-Path -Path $rootFolder -ChildPath "install_config.json"
    $config = Get-Content -Raw -Path $configFilePath | ConvertFrom-Json

    $url = $config.ProtocolBuffers.url
    $protocExePath = Join-Path -Path $rootFolder -ChildPath "protoc-21.10-win64\\bin\\protoc.exe"
    
    if (Test-Path $protocExePath) {
        Write-Output "Protocol Buffers is already installed."
        LogMessage -message  "Protocol Buffers is already installed." -logFile $logFile
    } else {
        Write-Output "Protocol Buffers is not installed. Installing now..."
        LogMessage -message  "Protocol Buffers is not installed. Installing now..." -logFile $logFile

        $output = Join-Path -Path $rootFolder -ChildPath "protoc-21.10-win64.zip"
        
        LogMessage -message  "Downloading Protocol Buffers now..." -logFile $logFile
        try {
            Invoke-WebRequest -Uri $url -OutFile $output
        } catch {
            LogMessage -message  "Error downloading Protocol Buffers: $_" -logFile $logFile
            Write-Output "Error: Failed to download Protocol Buffers. Check the log for details."
            return
        }
        
        $extractPath = Join-Path -Path $rootFolder -ChildPath "protoc-21.10-win64"
        LogMessage -message  "Extract path: $extractPath" -logFile $logFile

        try {
            New-Item -ItemType Directory -Force -Path $extractPath
        } catch {
            LogMessage -message  "Failed to create directory: $extractPath" -logFile $logFile
            Write-Output "Error: Failed to create directory. Check the log for details."
            return
        }

        LogMessage -message  "Extracting the ZIP file" -logFile $logFile
        try {
            Expand-Archive -Path $output -DestinationPath $extractPath -Force
        } catch {
            LogMessage -message  "Error extracting the ZIP file: $_" -logFile $logFile
            Write-Output "Error: Failed to extract ZIP file. Check the log for details."
            return
        }

        Remove-Item -Path $output
    }

    Add-ToSystemPath -pathToAdd (Join-Path -Path $rootFolder -ChildPath "protoc-21.10-win64\\bin")
}

Export-ModuleMember -Function InstallProtocolBuffers
