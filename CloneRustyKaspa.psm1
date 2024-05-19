# Clone Rusty Kaspa Module

function NewRustyKaspaClone {
    param (
        [string]$rootFolder,
        [string]$logFile
    )

    write-output "****** New-RustyKaspaClone Function ******"

    $repoUrl = "https://github.com/kaspanet/rusty-kaspa"
    $destinationPath = Join-Path -Path $rootFolder -ChildPath "rusty-kaspa"

    if (Test-Path $destinationPath) {
        Write-Output "The repository directory already exists: $destinationPath"
        LogMessage -message  "The repository directory already exists: $destinationPath" -logFile $logFile
    } else {
        Write-Output "Cloning the Rusty Kaspa repository..."
        LogMessage -message  "Cloning the Rusty Kaspa repository..." -logFile $logFile

        git clone $repoUrl $destinationPath 2>$null
        Write-Output "Repository cloned successfully to $destinationPath"
        LogMessage -message  "Repository cloned successfully to $destinationPath" -logFile $logFile
    }

    Set-Location -Path $destinationPath
}

Export-ModuleMember -Function NewRustyKaspaClone
