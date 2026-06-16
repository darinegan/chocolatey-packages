[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'

if ([string]::IsNullOrWhiteSpace($env:CHOCOLATEY_API_KEY)) {
    throw 'CHOCOLATEY_API_KEY must be configured as a protected environment secret.'
}
if ([string]::IsNullOrWhiteSpace($env:CHOCOLATEY_PUSH_URL)) {
    throw 'CHOCOLATEY_PUSH_URL must be set to the push endpoint.'
}
if ([string]::IsNullOrWhiteSpace($env:SELECTED_ITEMS)) {
    throw 'SELECTED_ITEMS must be provided.'
}

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot '..\..\..')
$outputDir = Join-Path $repoRoot 'automatic\_output'

if (Test-Path $outputDir) {
    Remove-Item $outputDir -Recurse -Force
}
New-Item -ItemType Directory -Path $outputDir | Out-Null

choco apikey --key $env:CHOCOLATEY_API_KEY --source $env:CHOCOLATEY_PUSH_URL
if ($LASTEXITCODE -ne 0) {
    throw "choco apikey failed with exit code $LASTEXITCODE."
}

$items = @($env:SELECTED_ITEMS -split ',' | Where-Object { $_ })
foreach ($item in $items) {
    $itemDir = Join-Path $repoRoot "automatic\$item"
    $nuspecPath = Join-Path $itemDir "$item.nuspec"
    [xml]$nuspec = Get-Content -Path $nuspecPath
    $id = $nuspec.package.metadata.id
    $version = $nuspec.package.metadata.version

    Push-Location $itemDir
    try {
        choco pack ".\$item.nuspec" --out "$outputDir"
        if ($LASTEXITCODE -ne 0) {
            throw "choco pack failed for $item with exit code $LASTEXITCODE."
        }
    } finally {
        Pop-Location
    }

    $nupkgPath = Join-Path $outputDir "$id.$version.nupkg"
    if (!(Test-Path $nupkgPath)) {
        throw "Expected package was not produced: $nupkgPath"
    }

    $encodedId = [System.Uri]::EscapeDataString($id)
    $encodedVersion = [System.Uri]::EscapeDataString($version)
    $queryUrl = "https://community.chocolatey.org/api/v2/Packages(Id='$encodedId',Version='$encodedVersion')"
    $alreadyPublished = $false
    try {
        Invoke-WebRequest -Uri $queryUrl -UseBasicParsing -Method Get | Out-Null
        $alreadyPublished = $true
    } catch {
        $response = $_.Exception.Response
        if ($null -eq $response -or [int]$response.StatusCode -ne 404) {
            throw
        }
    }

    if ($alreadyPublished) {
        Write-Host "$id $version is already published; skipping push."
        continue
    }

    choco push "$nupkgPath" --source $env:CHOCOLATEY_PUSH_URL
    if ($LASTEXITCODE -ne 0) {
        throw "choco push failed for $nupkgPath with exit code $LASTEXITCODE."
    }
}
