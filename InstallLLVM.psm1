# Function to install LLVM and configure environment variables
function InstallLLVM {
    param (
        [string]$rootFolder,
        [string]$logFile
    )
    write-output "****** Install-LLVM Function ******"

    # Load configuration
    $configFilePath = Join-Path -Path $rootFolder -ChildPath "install_config.json"
    $config = Get-Content -Raw -Path $configFilePath | ConvertFrom-Json

    $url = $config.LLVM.url
    $llvmExePath = "C:\\Program Files\\LLVM\\bin\\clang.exe"
    $llvmArPath = "C:\\Program Files\\LLVM\\bin\\LLVM-AR.exe"
    $arPath = "C:\\Program Files\\LLVM\\bin\\AR.exe"
    
    LogMessage -message  "Check if LLVM is installed by checking for clang.exe. Path: $llvmExePath" -logFile $logFile
    if (Test-Path $llvmExePath) {
        Write-Output "LLVM is already installed."
        LogMessage -message  "LLVM is already installed." -logFile $logFile
    } else {
        Write-Output "LLVM is not installed. Installing now..."
        LogMessage -message  "LLVM is not installed. Installing now..." -logFile $logFile
        
        $output = "$env:TEMP\\LLVM-Installer.exe"
        
        LogMessage -message  "Downloading LLVM Installation file: $url" -logFile $logFile
        try {
            Invoke-WebRequest -Uri $url -OutFile $output
        } catch {
            LogMessage -message  "Download of LLVM Installation file failed: $_" -logFile $logFile
            Write-Output "Error: Failed to download LLVM Installation file. Check the log for details."
            return
        }

        LogMessage -message  "Running the installer..." -logFile $logFile
        try {
            Start-Process -FilePath $output -Args "/S" -Wait -NoNewWindow
        } catch {
            LogMessage -message  "LLVM Installation failed: $_" -logFile $logFile
            Write-Output "Error: Failed to install LLVM. Check the log for details."
            return
        }

        Remove-Item -Path $output
    }

    LogMessage -message  "Check if AR.exe already exists, and remove it if it does: $arPath" -logFile $logFile
    if (Test-Path $arPath) {
        Remove-Item -Path $arPath -Force
        Write-Output "Existing AR.exe removed."
        LogMessage -message  "Existing AR.exe removed." -logFile $logFile
    }

    LogMessage -message  "Check if LLVM-AR.exe exists before renaming: $llvmArPath" -logFile $logFile
    if (Test-Path $llvmArPath) {
        Rename-Item -Path $llvmArPath -NewName "AR.exe" -Force
        Write-Output "LLVM-AR.exe renamed to AR.exe."
        LogMessage -message  "LLVM-AR.exe renamed to AR.exe." -logFile $logFile
    } else {
        Write-Output "LLVM-AR.exe not found, no renaming necessary."
        LogMessage -message  "LLVM-AR.exe not found, no renaming necessary." -logFile $logFile
    }

    $llvmBinPath = "C:\\Program Files\\LLVM\\bin"
    LogMessage -message  "Set LIBCLANG_PATH and add LLVM bin to PATH: $llvmBinPath" -logFile $logFile
    [Environment]::SetEnvironmentVariable("LIBCLANG_PATH", $llvmBinPath, [EnvironmentVariableTarget]::Machine)

    Add-ToSystemPath -pathToAdd $llvmBinPath
}

Export-ModuleMember -Function InstallLLVM
