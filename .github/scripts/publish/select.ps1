[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'

function Set-ActionOutput {
    param(
        [Parameter(Mandatory = $true)]
        [string] $Name,

        [Parameter(Mandatory = $true)]
        [string] $Value
    )

    if ([string]::IsNullOrWhiteSpace($env:GITHUB_OUTPUT)) {
        Write-Host "$Name=$Value"
        return
    }

    "$Name=$Value" | Out-File -FilePath $env:GITHUB_OUTPUT -Append
}

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot '..\..\..')
$root = Join-Path $repoRoot 'automatic'
$allItems = @(
    Get-ChildItem -Path $root -Directory |
        Where-Object { Test-Path (Join-Path $_.FullName "$($_.Name).nuspec") } |
        Select-Object -ExpandProperty Name
)

if ($allItems.Count -eq 0) {
    throw 'No items were found.'
}

$selected = @()
if (![string]::IsNullOrWhiteSpace($env:DISPATCH_ITEMS)) {
    $requested = @($env:DISPATCH_ITEMS -split '[,\s]+' | Where-Object { $_ })
    foreach ($item in $requested) {
        if ($item -notin $allItems) {
            throw "Unknown item '$item'. Allowed items: $($allItems -join ', ')"
        }
    }
    $selected = $requested
} elseif ($env:EVENT_NAME -eq 'push') {
    if ([string]::IsNullOrWhiteSpace($env:BEFORE_SHA) -or $env:BEFORE_SHA -match '^0+$') {
        Write-Warning 'No reliable base SHA is available; selecting all items.'
        $selected = $allItems
    } else {
        $files = @(git -C $repoRoot diff --name-only "$($env:BEFORE_SHA)..$($env:AFTER_SHA)")
        $selected = @(
            foreach ($file in $files) {
                $normalized = $file -replace '\\', '/'
                if ($normalized -match '^automatic/([^/]+)/') {
                    $Matches[1]
                }
            }
        ) | Sort-Object -Unique
    }
} else {
    $selected = $allItems
}

$selected = @($selected | Where-Object { $_ -in $allItems } | Sort-Object -Unique)
if ($selected.Count -eq 0) {
    Set-ActionOutput -Name 'items' -Value ''
    Write-Host 'No items selected.'
    exit 0
}

Set-ActionOutput -Name 'items' -Value ($selected -join ',')
Write-Host "Selected: $($selected -join ', ')"
