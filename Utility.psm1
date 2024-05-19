# Utility Module

# Function to log messages to a log file
function LogMessage {
    param(
        [string]$message,
        [string]$logfile
    )
    Add-Content -Path $logFile -Value "$(Get-Date -Format "yyyy-MM-dd HH:mm:ss"): $message"
}

Export-ModuleMember -Function LogMessage
