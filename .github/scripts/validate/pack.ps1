[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'

if ([string]::IsNullOrWhiteSpace($env:ITEM)) {
    throw 'ITEM must be provided.'
}

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot '..\..\..')
$item = $env:ITEM
$itemDir = Join-Path $repoRoot "automatic\$item"
$outputDir = Join-Path $repoRoot 'automatic\_output'

if (Test-Path $outputDir) {
    Remove-Item $outputDir -Recurse -Force
}
New-Item -ItemType Directory -Path $outputDir | Out-Null

Push-Location $itemDir
try {
    choco pack ".\$item.nuspec" --out "$outputDir"
    if ($LASTEXITCODE -ne 0) {
        throw "choco pack failed for $item with exit code $LASTEXITCODE."
    }
} finally {
    Pop-Location
}

$packages = @(Get-ChildItem -Path $outputDir -Filter "$item.*.nupkg")
if ($packages.Count -ne 1) {
    throw "Expected exactly one package matching '$item.*.nupkg' in $outputDir; found $($packages.Count)."
}
Write-Host "Produced: $($packages[0].FullName)"
