# Save this as ConvertHtmlToText.ps1
$sourceDirectory = "C:\Path\To\Your\HTML\Files"  # Update this path
$targetDirectory = "C:\Path\To\Your\Text\Files"  # Update this path

# Create target directory if it doesn't exist
if (-not (Test-Path $targetDirectory)) {
    New-Item -ItemType Directory -Path $targetDirectory
}

# Get all HTML files in the source directory
Get-ChildItem "$sourceDirectory\*.html" | ForEach-Object {
    $htmlContent = Get-Content $_.FullName
    $textContent = [System.Text.RegularExpressions.Regex]::Replace($htmlContent, '<[^>]*>', '')  # Remove HTML tags
    $textFileName = [System.IO.Path]::ChangeExtension($_.FullName, ".txt")
    $textFileName = Join-Path $targetDirectory ([System.IO.Path]::GetFileNameWithoutExtension($_.FullName) + ".txt")
    Set-Content -Path $textFileName -Value $textContent
    Write-Host "Converted: $_ to $textFileName"
}
