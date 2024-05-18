# PowerShell Script to Check and Install Git, Protocol Buffers, LLVM, Rust Toolchain, and wasm-pack

param(
    [string]$rootFolder = "C:\KaspaNode"
)

# Define the log file path
$logFile = Join-Path -Path $rootFolder -ChildPath "installation_log.txt"
$headerTextPath = Join-Path -Path $rootFolder -ChildPath "header.txt"


#move-Item -Path $output


# Unified function to add a directory to the system PATH if it is not already present
function Add-ToSystemPath {
    param(
        [string]$pathToAdd
    )

    write-output "****** Add-ToSystemPath Function ******"

    LogMessage "Checking Path environment variable for: $pathToAdd"

    $systemPath = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::Machine)
    if (-not $systemPath.Split(';').Contains($pathToAdd)) {
        $newSystemPath = "$systemPath;$pathToAdd"
        [System.Environment]::SetEnvironmentVariable("Path", $newSystemPath, [System.EnvironmentVariableTarget]::Machine)
        Write-Output "Added '$pathToAdd' to system PATH."
        LogMessage "Added '$pathToAdd' to system PATH."
    } else {
        Write-Output "'$pathToAdd' is already in system PATH."
        LogMessage "'$pathToAdd' is already in system PATH."
    }
}

function Ensure-CargoAccess {

    write-output "****** Ensure-CargoAccess Function ******"

    $cargoBinPath = "$env:USERPROFILE\.cargo\bin"
    LogMessage "Checking Cargo path..."

    Add-ToSystemPath -pathToAdd $cargoBinPath
}


function Refresh-Environment {

    write-output "****** Refresh-Environment Function ******"

    $userPath = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::User)
    $systemPath = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::Machine)
    $env:Path = "$userPath;$systemPath"
    
    Write-Output "Environment refreshed. Current PATH: $env:Path"
}

# Import Utility Module
Import-Module -Name "$rootFolder\Utility.psm1"
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

LogMessage "Starting script execution."
LogMessage "Rusty Kaspa Root folder: $rootFolder"

InstallVisualStudioBuildTools -rootFolder $rootFolder

LogMessage "Checking if Git is already installed..."
try {
    $gitVersion = git --version
    Write-Output "Git is already installed: $gitVersion"
    LogMessage "Git is already installed: $gitVersion"
} catch {
    Write-Output "Git is not installed. Installing now..."
    LogMessage "Git is not installed. Installing now..."
    Install-Git -rootFolder $rootFolder
}

InstallProtocolBuffers -rootFolder $rootFolder

InstallLLVM -rootFolder $rootFolder

InstallUpdateRust -rootFolder $rootFolder

InstallWasmPack -rootFolder $rootFolder

InstallWasm32Target -rootFolder $rootFolder

NewRustyKaspaClone -rootFolder $rootFolder

#Create-BatchFile
