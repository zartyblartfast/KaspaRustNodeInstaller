# Header module

function ShowAsciiArtHeader {
    param (
        [string]$rootFolder = "C:\KaspaNode"
    )

    $path = "$rootFolder\ascii_art.txt"
    Get-Content $path | Write-Output
}

function ShowDescriptionHeader {
    param (
        [string]$headerTextPath = "C:\KaspaNode\header.txt"
    )

    $headerContent = Get-Content -Path $headerTextPath -ErrorAction SilentlyContinue
    $headerContent | Write-Output
}

Export-ModuleMember -Function ShowAsciiArtHeader, ShowDescriptionHeader