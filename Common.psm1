# Common Module

# Function to log messages to a log file
function LogMessage {
    param(
        [string]$message,
        [string]$logfile
    )
    Add-Content -Path $logFile -Value "$(Get-Date -Format "yyyy-MM-dd HH:mm:ss"): $message"
}

Export-ModuleMember -Function LogMessage


# Unified function to add a directory to the system PATH if it is not already present
function Add-ToSystemPath {
    param(
        [string]$pathToAdd
    )

    write-output "****** Add-ToSystemPath Function ******"

    LogMessage -message "Checking Path environment variable for: $pathToAdd" -logFile $logFile

    $systemPath = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::Machine)
    if (-not $systemPath.Split(';').Contains($pathToAdd)) {
        $newSystemPath = "$systemPath;$pathToAdd"
        [System.Environment]::SetEnvironmentVariable("Path", $newSystemPath, [System.EnvironmentVariableTarget]::Machine)
        Write-Output "Added '$pathToAdd' to system PATH."
        LogMessage  -message "Added '$pathToAdd' to system PATH." -logFile $logFile
    } else {
        Write-Output "'$pathToAdd' is already in system PATH."
        LogMessage  -message  "'$pathToAdd' is already in system PATH." -logFile $logFile
    }
}

Export-ModuleMember -Function Add-ToSystemPath


function Ensure-CargoAccess {

    write-output "****** Ensure-CargoAccess Function ******"

    $cargoBinPath = "$env:USERPROFILE\.cargo\bin"
    LogMessage -message "Checking Cargo path..." -logFile $logFile

    Add-ToSystemPath -pathToAdd $cargoBinPath
}

Export-ModuleMember -Function Ensure-CargoAccess 


function Refresh-Environment {

    write-output "****** Refresh-Environment Function ******"

    $userPath = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::User)
    $systemPath = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::Machine)
    $env:Path = "$userPath;$systemPath"
    
    Write-Output "Environment refreshed. Current PATH: $env:Path"
}

Export-ModuleMember -Function Refresh-Environment 
