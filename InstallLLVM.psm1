
# Function to install LLVM and configure environment variables
function InstallLLVM {

    write-output "****** Install-LLVM Function ******"

    $llvmExePath = "C:\Program Files\LLVM\bin\clang.exe"
    $llvmArPath = "C:\Program Files\LLVM\bin\LLVM-AR.exe"
    $arPath = "C:\Program Files\LLVM\bin\AR.exe"
    
    LogMessage "Check if LLVM is installed by checking for clang.exe. Path: $llvmExePath"
    if (Test-Path $llvmExePath) {
        Write-Output "LLVM is already installed."
        LogMessage "LLVM is already installed."
    } else {
        Write-Output "LLVM is not installed. Installing now..."
        LogMessage "LLVM is not installed. Installing now..."

        $url = "https://github.com/llvm/llvm-project/releases/download/llvmorg-15.0.6/LLVM-15.0.6-win64.exe"
        $output = "$env:TEMP\LLVM-Installer.exe"
        
        LogMessage "Downloading LLVM Installation file: $url"
        try {
            Invoke-WebRequest -Uri $url -OutFile $output
        } catch {
            LogMessage "Download of LLVM Installation file failed: $_"
            return
        }

        LogMessage "Running the installer..."
        try {
            Start-Process -FilePath $output -Args "/S" -Wait -NoNewWindow
        } catch {
            LogMessage "LLVM Installation failed: $_"
            return
        }

        Remove-Item -Path $output
    }

    LogMessage "Check if AR.exe already exists, and remove it if it does: $arPath"
    if (Test-Path $arPath) {
        Remove-Item -Path $arPath -Force
        Write-Output "Existing AR.exe removed."
        LogMessage "Existing AR.exe removed."
    }

    LogMessage "Check if LLVM-AR.exe exists before renaming: $llvmArPath"
    if (Test-Path $llvmArPath) {
        Rename-Item -Path $llvmArPath -NewName "AR.exe" -Force
        Write-Output "LLVM-AR.exe renamed to AR.exe."
        LogMessage "LLVM-AR.exe renamed to AR.exe."
    } else {
        Write-Output "LLVM-AR.exe not found, no renaming necessary."
        LogMessage "LLVM-AR.exe not found, no renaming necessary."
    }

    $llvmBinPath = "C:\Program Files\LLVM\bin"
    LogMessage "Set LIBCLANG_PATH and add LLVM bin to PATH: $llvmBinPath"
    [Environment]::SetEnvironmentVariable("LIBCLANG_PATH", $llvmBinPath, [EnvironmentVariableTarget]::Machine)

    Add-ToSystemPath -pathToAdd $llvmBinPath
}

Export-ModuleMember -Function InstallLLVM 