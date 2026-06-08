[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'

if ([string]::IsNullOrWhiteSpace($env:ITEM)) {
    throw 'ITEM must be provided.'
}

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot '..\..\..')
$itemDir = Join-Path $repoRoot "automatic\$($env:ITEM)"

Import-Module Chocolatey-AU
$global:au_WhatIf = $true

Push-Location $itemDir
try {
    Write-Host "Running update.ps1 from: $itemDir (WhatIf)"
    & '.\update.ps1'
} catch {
    $message = $_.Exception.Message
    if ($message -match 'Unable to connect|WebException|timeout|NameResolution') {
        Write-Warning "Network error ignored in CI: $message"
    } else {
        throw
    }
} finally {
    Pop-Location
}
