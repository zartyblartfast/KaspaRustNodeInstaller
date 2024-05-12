# PowerShell Script to Check and Install Git, Protocol Buffers, LLVM, Rust Toolchain, and wasm-pack

param(
    [string]$rootFolder = "C:\KaspaNode"
)

# Define the log file path
$logFile = Join-Path -Path $rootFolder -ChildPath "installation_log.txt"
$headerTextPath = Join-Path -Path $rootFolder -ChildPath "header.txt"


# Function to log messages to a log file
function Log-Message {
    param([string]$message)
    Add-Content -Path $logFile -Value "$(Get-Date -Format "yyyy-MM-dd HH:mm:ss"): $message"
}


# Function to download and install Git
function Install-Git {
    $url = "https://github.com/git-for-windows/git/releases/download/v2.45.0.windows.1/Git-2.45.0-64-bit.exe"
    $output = "$env:TEMP\Git-Installer.exe"

    Log-Message "Downloading Git installer..."
    try {
        # Downloading the Git installer
        Invoke-WebRequest -Uri $url -OutFile $output
    } catch {
        Log-Message "Error downloading Git installer: $_"
    }
    
    # Running the installer silently
    Log-Message "Installing Git..."
    try {
        Start-Process -FilePath $output -Args "/VERYSILENT" -Wait -NoNewWindow
    } catch {
        Log-Message "Error installing Git: $_"
    }
    # Clean up installer file
    Remove-Item -Path $output
}

# Function to check and install Protocol Buffers
function Install-ProtocolBuffers {
    $protocExePath = Join-Path -Path $rootFolder -ChildPath "protoc-21.10-win64\bin\protoc.exe"
    
    # Check if protoc.exe exists
    if (Test-Path $protocExePath) {
        Write-Output "Protocol Buffers is already installed."
        Log-Message "Protocol Buffers is already installed."

    } else {
        Write-Output "Protocol Buffers is not installed. Installing now..."
        Log-Message "Protocol Buffers is not installed. Installing now..."

        $url = "https://github.com/protocolbuffers/protobuf/releases/download/v21.10/protoc-21.10-win64.zip"
        $output = Join-Path -Path $rootFolder -ChildPath "protoc-21.10-win64.zip"
        
        # Downloading the Protobuf installer
        Log-Message "Downloading Protocol Buffers now..."
        try {
            Invoke-WebRequest -Uri $url -OutFile $output
        } catch {
            Log-Message "Error downloading Protocol Buffers: $_"
        }
        
        # Setting the correct extract path
        $extractPath = Join-Path -Path $rootFolder -ChildPath "protoc-21.10-win64"
        Log-Message "Extract path: $extractPath"

        # Ensure the directory is created
        Log-Message "Create directory"
        try {
            New-Item -ItemType Directory -Force -Path $extractPath
        } catch {
            Log-Message "Create directory faild. Path: $extractPath"
        }

        # Extracting the ZIP file
        Log-Message "Extracting the ZIP file"
        try {
            Expand-Archive -Path $output -DestinationPath $extractPath -Force
        } catch {
            Log-Message "Error extracting the ZIP file: $_"
        }

        # Clean up ZIP file
        Remove-Item -Path $output
    }
    # Checking and adding to system PATH, regardless of installation
    CheckAndUpdatePath
}

# Function to check and update PATH environment variable
function CheckAndUpdatePath {
    $binPath = Join-Path -Path $rootFolder -ChildPath "protoc-21.10-win64\bin"
    Log-Message "Checking Path environmetal variable for: $binPath"
    $path = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::Machine)
    if (-not $path.Split(';').Contains($binPath)) {
        $newPath = "$path;$binPath"
        [System.Environment]::SetEnvironmentVariable("Path", $newPath, [System.EnvironmentVariableTarget]::Machine)
        Write-Output "Added '$binPath' to system PATH."
        Log-Message "Added '$binPath' to system PATH."
    } else {
        Write-Output "'$binPath' is already in system PATH."
        Log-Message  "'$binPath' is already in system PATH."
    }
}

# Function to install LLVM and configure environment variables
function Install-LLVM {
    $llvmExePath = "C:\Program Files\LLVM\bin\clang.exe"
    $llvmArPath = "C:\Program Files\LLVM\bin\LLVM-AR.exe"
    $arPath = "C:\Program Files\LLVM\bin\AR.exe"
    
    # Check if LLVM is installed by checking for clang.exe
    Log-Message  "Check if LLVM is installed by checking for clang.exe. Path: $llvmExePath"
    if (Test-Path $llvmExePath) {
        Write-Output "LLVM is already installed."
        Log-Message  "LLVM is already installed."
    } else {
        Write-Output "LLVM is not installed. Installing now..."
        Log-Message "LLVM is not installed. Installing now..."

        $url = "https://github.com/llvm/llvm-project/releases/download/llvmorg-15.0.6/LLVM-15.0.6-win64.exe"
        $output = "$env:TEMP\LLVM-Installer.exe"
        
        # Downloading the LLVM installer
        Log-Message "Downloading LLVM Installation file: $url"
        try {
            Invoke-WebRequest -Uri $url -OutFile $output
        } catch {
            Log-Message "Download of LLVM Installation file failed: $_"
        }

        # Running the installer silently
        Log-Message "Running the installer..."
        try {
            Start-Process -FilePath $output -Args "/S" -Wait -NoNewWindow
        } catch {
            Log-Message "LLVM Installation failed: $_"
        }

        # Clean up installer file
        Remove-Item -Path $output
    }

    # Check if AR.exe already exists, and remove it if it does
    Log-Message "Check if AR.exe already exists, and remove it if it does: $arPath"
    if (Test-Path $arPath) {
        Remove-Item -Path $arPath -Force
        Write-Output "Existing AR.exe removed."
        Log-Message "Existing AR.exe removed."
    }

    # Check if LLVM-AR.exe exists before renaming
    Log-Message "Check if LLVM-AR.exe exists before renaming: $llvmArPathh"
    if (Test-Path $llvmArPath) {
        Rename-Item -Path $llvmArPath -NewName "AR.exe" -Force
        Write-Output "LLVM-AR.exe renamed to AR.exe."
        Log-Message "LLVM-AR.exe renamed to AR.exe."
    } else {
        Write-Output "LLVM-AR.exe not found, no renaming necessary."
        Log-Message "LLVM-AR.exe not found, no renaming necessary."
    }

    # Set LIBCLANG_PATH and add LLVM bin to PATH
    $llvmBinPath = "C:\Program Files\LLVM\bin"
    Log-Message "Set LIBCLANG_PATH and add LLVM bin to PATH: $llvmBinPath"
    [Environment]::SetEnvironmentVariable("LIBCLANG_PATH", $llvmBinPath, [EnvironmentVariableTarget]::Machine)

    # Add to PATH if not already present
    $systemPath = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::Machine)
    if (-not $systemPath.Split(';').Contains($llvmBinPath)) {
        $newSystemPath = "$systemPath;$llvmBinPath"
        [System.Environment]::SetEnvironmentVariable("Path", $newSystemPath, [System.EnvironmentVariableTarget]::Machine)
        Write-Output "Added LLVM bin to system PATH."
        Log-Message "Added LLVM bin to system PATH"
    } else {
        Write-Output "LLVM bin is already in system PATH."
        Log-Message "LLVM bin is already in system PATH."
    }
}

function Install-Update-Rust {
    $rustcPath = Join-Path -Path $env:USERPROFILE -ChildPath ".cargo\bin\rustc.exe"
    $rustupPath = Join-Path -Path $env:USERPROFILE -ChildPath ".cargo\bin\rustup.exe"

    Log-Message "Refresh the Rust environment..."
    Log-Message "Refresh rustc Path: $rustcPath"
    Log-Message "Refresh rustup Path  Path: $rustupPath"

    # Refresh the environment to ensure the latest paths are included
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::User) + ";" +
                [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::Machine)

    Log-Message "Check if paths are included..."
    if (Test-Path $rustcPath) {
        try {
            Write-Output "Rust is already installed: $rustcVersion. Updating now..."
            Log-Message  "Rust is already installed: $rustcVersion. Updating now..."
            $rustcVersion = & $rustcPath --version
            & $rustupPath update 2>$null  # Ignoring stderr
        } catch {
            Write-Output "An error occurred while trying to update Rust: $_"
            Log-Message "An error occurred while trying to update Rust: $_"
        }
    } else {
        Write-Output "Rust is not installed. Installing now..."
        Log-Message "Rust is not installed. Installing now..."
        $url = "https://win.rustup.rs"
        $output = "$env:TEMP\rustup-init.exe"
        Invoke-WebRequest -Uri $url -OutFile $output
        Start-Process -FilePath $output -Args "-y" -Wait -NoNewWindow
        Remove-Item -Path $output

        # Add Rust's bin to the current session's PATH to immediately use Rust after installation
        Log-Message "Add Rust bin folder to the current session's PATH to immediately use Rust after installation"
        $env:Path += ";$env:USERPROFILE\.cargo\bin"
    }
}


function Ensure-CargoAccess {
    $cargoBinPath = "$env:USERPROFILE\.cargo\bin"
    Log-Message "Check cargo path..."
    if (-not $env:Path.Contains($cargoBinPath)) {
        $env:Path += ";$cargoBinPath"
        Log-Message "Cargo path added: $cargoBinPath"
    } else {
        Log-Message "Cargo path already present: $cargoBinPath"
    }
}



# Function to install wasm-pack using Cargo
function Install-WasmPack {
    $cargoExecutable = Join-Path -Path $env:USERPROFILE -ChildPath ".cargo\bin\cargo.exe"
    
    # Ensure Cargo path is updated in session, especially when running in elevated mode
    Ensure-CargoAccess

    # Check if the cargo executable exists before attempting to run it
    if (Test-Path $cargoExecutable) {
        try {
            $wasmPackVersion = wasm-pack --version
            Write-Output "wasm-pack is already installed: $wasmPackVersion."
            Log-Message "wasm-pack is already installed: $wasmPackVersion."
        } catch {
            Write-Output "wasm-pack is not installed. Installing now..."
            Log-Message "wasm-pack is not installed. Installing now..."
            # Attempt to install wasm-pack using the full path to cargo
            try {
                $null = & $cargoExecutable install wasm-pack 2>&1
                #Write-Output "wasm-pack installation attempted."
            } catch {
                Log-Message "wasm-pack installation failed: $_"
            }
        }
    } else {
        Write-Output "Cargo executable not found at path: $cargoExecutable"
        Log-Message "Cargo executable not found at path: $cargoExecutable"
        Write-Output "Please ensure Rust is installed correctly and the path is accessible."
        Log-Message "Please ensure Rust is installed correctly and the path is accessible."
    }
}

function Refresh-Environment {
    # Re-import the user and system PATH variables into the current session
    $userPath = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::User)
    $systemPath = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::Machine)
    $env:Path = "$userPath;$systemPath"
    
    Write-Output "Environment refreshed. Current PATH: $env:Path"
}


function Install-Wasm32Target {
    $rustupPath = Join-Path -Path $env:USERPROFILE -ChildPath ".cargo\bin\rustup.exe"

    # Refresh environment to ensure the latest path settings are used
    Refresh-Environment

    # Check if rustup is available before attempting to add the target
    if (Test-Path $rustupPath) {
        try {
            Write-Output "Adding wasm32-unknown-unknown target..."
            Log-Message "Adding wasm32-unknown-unknown target..."
            & $rustupPath target add wasm32-unknown-unknown 2>$null  # Ignoring stderr entirely
            Write-Output "wasm32-unknown-unknown target added successfully"
            Log-Message  "wasm32-unknown-unknown target added successfully: $rustupPath."
        } catch {
            Write-Output "Failed to add wasm32-unknown-unknown target: $_"
            Log-Message "Failed to add wasm32-unknown-unknown target: $_"
        }
    } else {
        Write-Output "Rust toolchain is not installed properly or rustup is not available."
        Log-Message "Rust toolchain is not installed properly or rustup is not available."
    }
}

function Clone-RustyKaspa {
    $repoUrl = "https://github.com/kaspanet/rusty-kaspa"
    $destinationPath = Join-Path -Path $rootFolder -ChildPath "rusty-kaspa"

    if (Test-Path $destinationPath) {
        Write-Output "The repository directory already exists: $destinationPath"
        Log-Message "The repository directory already exists: $destinationPath"
    } else {
        Write-Output "Cloning the Rusty Kaspa repository..."
        Log-Message "Cloning the Rusty Kaspa repository..."

        git clone $repoUrl $destinationPath 2>$null
        Write-Output "Repository cloned successfully to $destinationPath"
        Log-Message "Repository cloned successfully to $destinationPath"
    }

    Set-Location -Path $destinationPath
    #Write-Output "Changed directory to: $(Get-Location)"
}

function Install-VisualStudioBuildTools {
    $linkExePathPattern = 'C:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools\VC\Tools\MSVC\*\bin\Hostx64\x64\link.exe'
    
    # Check if link.exe exists using the default path
    Log-Message "Check if link.exe exists using the default path..."
    if (!(Test-Path $linkExePathPattern)) {
        Write-Output "MSVC Build Tools or 'link.exe' not found. Proceeding with installation..."
        Log-Message "MSVC Build Tools or 'link.exe' not found. Proceeding with installation..."

        # Define the URL for the Visual Studio Build Tools installer
        $url = "https://aka.ms/vs/16/release/vs_buildtools.exe"
        $installerPath = "$env:TEMP\vs_buildtools.exe"
        
        # Download the installer
        Invoke-WebRequest -Uri $url -OutFile $installerPath
        Write-Output "Downloaded Visual Studio Build Tools installer to $installerPath"
        Log-Message "Downloaded Visual Studio Build Tools installer to $installerPath"

        # Define installation arguments without a custom installation path
        $args = "--quiet --wait --norestart --nocache " +
                "--add Microsoft.VisualStudio.Workload.NativeDesktop " +
                "--add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 " +
                "--add Microsoft.VisualStudio.Component.Windows10SDK.19041"

        # Execute the installer
        Log-Message "Execute the installer"
        try {
            Start-Process -FilePath $installerPath -ArgumentList $args -Wait
        } catch {
            Write-Output "Installation of Visual Studio Build Tools completed."
            Log-Message "Installation of Visual Studio Build Tools completed."
        }

        # Remove the installer file to clean up
        Remove-Item -Path $installerPath

    } else {
        Write-Output "MSVC Build Tools are correctly installed. 'link.exe' found."
        Log-Message "MSVC Build Tools are correctly installed. 'link.exe' found."
    }
}



function Output-ascii-art-Header {
    # Specify the path to the ASCII art text file
    $path = "$rootfolder\ascii_art.txt"

    # Read and display the file content
    Get-Content $path | Write-Output
}

function Ouput-desciption-Header {
    # Load header content from header file
    $headerContent = Get-Content -Path $headerTextPath -ErrorAction SilentlyContinue
    $headerContent | Write-Output
}

function Create-BatchFile {
    $batFilePath = Join-Path -Path $rootFolder -ChildPath "rustyKaspa.bat"
    $rustyKaspaPath = Join-Path -Path $rootFolder -ChildPath "rusty-kaspa"
    
    Log-Message "Creating batch file at $batFilePath..."
    
    $batchCommands = @"
@echo off
cd "$rustyKaspaPath"
echo Running Kaspa node...
cargo run --release --bin kaspad
pause
"@

    # Write the batch file content
    $batchCommands | Out-File -FilePath $batFilePath -Encoding ASCII
    Log-Message "Batch file created successfully."
}


Output-ascii-art-Header 

Ouput-desciption-Header

# Clear log file at the start of the script run
if (Test-Path $logFile) {
    Remove-Item $logFile
}

Log-Message "Starting script execution."
Log-Message "Rusty Kaspa Root folder: $rootFolder"

# Install Visual Studio C++ tools and setup Path if necessary
Install-VisualStudioBuildTools

# Checking if Git is already installed
Log-Message "Checking if Git is already installed..."
try {
    $gitVersion = git --version
    Write-Output "Git is already installed: $gitVersion"
    Log-Message "Git is already installed: $gitVersion"
} catch {
    Write-Output "Git is not installed. Installing now..."
    Log-Message "Git is not installed. Installing now..."
    Install-Git
}

# Attempting to verify and manage Protocol Buffers installation and PATH
Install-ProtocolBuffers

# Attempting to install LLVM and configure environment settings
Install-LLVM

# Attempting to install or update Rust toolchain
Install-Update-Rust

# Attempting to install wasm-pack
Install-WasmPack

# Attempting to add wasm32 target for Rust
Install-Wasm32Target

Clone-RustyKaspa

Create-BatchFile
