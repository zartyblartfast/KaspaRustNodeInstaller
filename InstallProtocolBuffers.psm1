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
        LogMessage "Protocol Buffers is already installed."
    } else {
        Write-Output "Protocol Buffers is not installed. Installing now..."
        LogMessage "Protocol Buffers is not installed. Installing now..."

        $output = Join-Path -Path $rootFolder -ChildPath "protoc-21.10-win64.zip"
        
        LogMessage "Downloading Protocol Buffers now..."
        try {
            Invoke-WebRequest -Uri $url -OutFile $output
        } catch {
            LogMessage "Error downloading Protocol Buffers: $_"
            Write-Output "Error: Failed to download Protocol Buffers. Check the log for details."
            return
        }
        
        $extractPath = Join-Path -Path $rootFolder -ChildPath "protoc-21.10-win64"
        LogMessage "Extract path: $extractPath"

        try {
            New-Item -ItemType Directory -Force -Path $extractPath
        } catch {
            LogMessage "Failed to create directory: $extractPath"
            Write-Output "Error: Failed to create directory. Check the log for details."
            return
        }

        LogMessage "Extracting the ZIP file"
        try {
            Expand-Archive -Path $output -DestinationPath $extractPath -Force
        } catch {
            LogMessage "Error extracting the ZIP file: $_"
            Write-Output "Error: Failed to extract ZIP file. Check the log for details."
            return
        }

        Remove-Item -Path $output
    }

    Add-ToSystemPath -pathToAdd (Join-Path -Path $rootFolder -ChildPath "protoc-21.10-win64\\bin")
}

Export-ModuleMember -Function InstallProtocolBuffers
