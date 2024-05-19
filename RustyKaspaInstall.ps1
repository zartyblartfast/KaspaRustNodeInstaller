# PowerShell Script to Check and Install Git, Protocol Buffers, LLVM, Rust Toolchain, and wasm-pack

param(
    [string]$rootFolder = "C:\KaspaNode"
)

# Define the log file path
$logFile = Join-Path -Path $rootFolder -ChildPath "installation_log.txt"
$headerTextPath = Join-Path -Path $rootFolder -ChildPath "header.txt"


# Import Utility Module
Import-Module -Name "$rootFolder\Common.psm1"

# Import Install Git Module
Import-Module -Name "$rootFolder\InstallGit.psm1"

# Import Install Protocol Buffers Module
Import-Module -Name "$rootFolder\InstallProtocolBuffers.psm1"

# Import Install LLVM Module
Import-Module -Name "$rootFolder\InstallLLVM.psm1"

# Import the RustInstaller module
Import-Module -Name "$rootFolder\RustInstaller.psm1"

# Import the Install Wasm Pack module
Import-Module -Name "$rootFolder\InstallWasmPack.psm1"

# Import the Install Wasm32 Target module
Import-Module -Name "$rootFolder\InstallWasm32Target.psm1"

# Import the Clone Rusty Kaspa module
Import-Module -Name "$rootFolder\CloneRustyKaspa.psm1"

# Import the Install Visual Studio Build Tools module
Import-Module -Name "$rootFolder\InstallVisualStudioBuildTools.psm1"

# Import the Header module
Import-Module -Name "$rootFolder\Header.psm1"

##
## MAIN
##

ShowAsciiArtHeader

ShowDescriptionHeader

if (Test-Path $logFile) {
    Remove-Item $logFile
}

LogMessage  -message "Starting script execution." -logFile $logFile
LogMessage  -message "Rusty Kaspa Root folder: $rootFolder" -logFile $logFile

InstallVisualStudioBuildTools -rootFolder $rootFolder -logFile $logFile

Install-Git -rootFolder $rootFolder -logFile $logFile

InstallProtocolBuffers -rootFolder $rootFolder -logFile $logFile

InstallLLVM -rootFolder $rootFolder -logFile $logFile

InstallUpdateRust -rootFolder $rootFolder -logFile $logFile

InstallWasmPack -rootFolder $rootFolder -logFile $logFile

InstallWasm32Target -rootFolder $rootFolder -logFile $logFile

NewRustyKaspaClone -rootFolder $rootFolder -logFile $logFile

#Create-BatchFile
