[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot '..\..\..')
$repository = $env:REPOSITORY
$baseBranch = if ([string]::IsNullOrWhiteSpace($env:BASE_BRANCH)) { 'master' } else { $env:BASE_BRANCH }
$updateBranch = if ([string]::IsNullOrWhiteSpace($env:UPDATE_BRANCH)) { 'automation/updates' } else { $env:UPDATE_BRANCH }

if ([string]::IsNullOrWhiteSpace($env:GH_TOKEN)) {
    throw 'UPDATE_PR_TOKEN is required so the update PR triggers normal pull_request validation.'
}
if ([string]::IsNullOrWhiteSpace($repository)) {
    throw 'REPOSITORY must be provided.'
}

Push-Location $repoRoot
try {
    $changes = @(git status --short -- automatic)
    if ($changes.Count -eq 0) {
        Write-Host 'No source changes detected.'
        exit 0
    }

    Write-Host 'Source changes detected:'
    $changes | ForEach-Object { Write-Host $_ }

    git config user.name 'github-actions[bot]'
    git config user.email '41898282+github-actions[bot]@users.noreply.github.com'
    git checkout -B $updateBranch
    git add -- automatic

    $staged = @(git diff --cached --name-only)
    if ($staged.Count -eq 0) {
        Write-Host 'No staged source changes after filtering.'
        exit 0
    }

    git commit -m 'Update sources'
    gh auth setup-git --hostname github.com
    git push --force origin "HEAD:$updateBranch"

    $prNumber = gh pr list --repo $repository --head $updateBranch --base $baseBranch --state open --json number --jq '.[0].number'
    $title = 'Update sources'
    $body = @(
        'This automated PR updates sources using `.\update_all.ps1`.'
        ''
        'Publishing is handled separately after these changes are reviewed, validated, and merged to `master`.'
    ) -join [Environment]::NewLine

    if ([string]::IsNullOrWhiteSpace($prNumber)) {
        gh pr create --repo $repository --base $baseBranch --head $updateBranch --title $title --body $body
    } else {
        gh pr edit $prNumber --repo $repository --title $title --body $body
    }
} finally {
    Pop-Location
}
