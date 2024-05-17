
# Install Protocol Buffers Module
function InstallProtocolBuffers {

    write-output "****** Install-ProtocolBuffers Function ******"

    $protocExePath = Join-Path -Path $rootFolder -ChildPath "protoc-21.10-win64\bin\protoc.exe"
    
    if (Test-Path $protocExePath) {
        Write-Output "Protocol Buffers is already installed."
        LogMessage "Protocol Buffers is already installed."
    } else {
        Write-Output "Protocol Buffers is not installed. Installing now..."
        LogMessage "Protocol Buffers is not installed. Installing now..."

        $url = "https://github.com/protocolbuffers/protobuf/releases/download/v21.10/protoc-21.10-win64.zip"
        $output = Join-Path -Path $rootFolder -ChildPath "protoc-21.10-win64.zip"
        
        LogMessage "Downloading Protocol Buffers now..."
        try {
            Invoke-WebRequest -Uri $url -OutFile $output
        } catch {
            LogMessage "Error downloading Protocol Buffers: $_"
            return
        }
        
        $extractPath = Join-Path -Path $rootFolder -ChildPath "protoc-21.10-win64"
        LogMessage "Extract path: $extractPath"

        try {
            New-Item -ItemType Directory -Force -Path $extractPath
        } catch {
            LogMessage "Failed to create directory: $extractPath"
            return
        }

        LogMessage "Extracting the ZIP file"
        try {
            Expand-Archive -Path $output -DestinationPath $extractPath -Force
        } catch {
            LogMessage "Error extracting the ZIP file: $_"
            return
        }

        Remove-Item -Path $output
    }

    Add-ToSystemPath -pathToAdd (Join-Path -Path $rootFolder -ChildPath "protoc-21.10-win64\bin")
}

Export-ModuleMember -Function InstallProtocolBuffers