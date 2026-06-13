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

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..\..')).Path
$itemRoot = Join-Path $repoRoot 'automatic'
$items = @(
    Get-ChildItem -Path $itemRoot -Directory |
        Where-Object { Test-Path (Join-Path $_.FullName "$($_.Name).nuspec") } |
        Sort-Object Name |
        ForEach-Object { $_.Name }
)

if ($items.Count -eq 0) {
    throw 'No items were discovered under automatic/.'
}

$itemsJson = '[' + (($items | ForEach-Object { $_ | ConvertTo-Json -Compress }) -join ',') + ']'
Set-ActionOutput -Name 'items' -Value $itemsJson
Write-Host "Discovered items: $($items -join ', ')"

if ($env:EVENT_NAME -ne 'pull_request') {
    Set-ActionOutput -Name 'relevant' -Value 'true'
    Write-Host 'Manual validation run; running all validation.'
    exit 0
}

if ([string]::IsNullOrWhiteSpace($env:REPOSITORY) -or [string]::IsNullOrWhiteSpace($env:PR_NUMBER)) {
    throw 'REPOSITORY and PR_NUMBER must be provided for pull request validation.'
}

$files = @(
    gh api "repos/$($env:REPOSITORY)/pulls/$($env:PR_NUMBER)/files" --paginate --jq '.[].filename'
)

$patterns = @(
    '^automatic/',
    '^setup/au_setup\.ps1$',
    '^update_all\.ps1$',
    '^test_all\.ps1$',
    '^tools/PSModules/',
    '^\.github/workflows/(validate|update|publish)\.ya?ml$',
    '^\.github/scripts/',
    '^\.github/dependabot\.yml$'
)

$relevant = $false
foreach ($file in $files) {
    $normalized = $file -replace '\\', '/'
    if ($patterns | Where-Object { $normalized -match $_ }) {
        $relevant = $true
        break
    }
}

Set-ActionOutput -Name 'relevant' -Value $relevant.ToString().ToLowerInvariant()
if ($relevant) {
    Write-Host 'Relevant changes detected.'
} else {
    Write-Host 'No relevant changes detected; heavy validation will be skipped.'
}
