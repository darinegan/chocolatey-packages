[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot '..\..\..')
$violations = New-Object System.Collections.Generic.List[string]

$workflowRoot = Join-Path $repoRoot '.github\workflows'
$workflowFiles = @(
    Get-ChildItem -Path $workflowRoot -Filter '*.yml' -File
    Get-ChildItem -Path $workflowRoot -Filter '*.yaml' -File
) | Sort-Object FullName
foreach ($file in $workflowFiles) {
    $lines = Get-Content -Path $file.FullName
    $content = $lines -join "`n"

    if ($content -match '(?m)^\s*pull_request_target\s*:') {
        $violations.Add("$($file.Name): pull_request_target is not allowed.")
    }

    if ($content -notmatch '(?m)^permissions:\s*\{\}\s*$') {
        $violations.Add("$($file.Name): top-level permissions must be {}.")
    }

    for ($i = 0; $i -lt $lines.Count; $i++) {
        if ($lines[$i] -match '^\s*uses:\s*([^@\s#]+)@([^\s#]+)') {
            $action = $Matches[1]
            $ref = $Matches[2]
            if ($action -notmatch '^\.\/' -and $ref -notmatch '^[0-9a-f]{40}$') {
                $violations.Add("$($file.Name): line $($i + 1) uses $action@$ref instead of a full 40-character SHA.")
            }
        }
    }
}

$scriptFiles = Get-ChildItem -Path (Join-Path $repoRoot '.github\scripts') -Filter '*.ps1' -Recurse -File
foreach ($file in $scriptFiles) {
    $tokens = $null
    $parseErrors = $null
    [System.Management.Automation.Language.Parser]::ParseFile($file.FullName, [ref]$tokens, [ref]$parseErrors) | Out-Null
    foreach ($parseError in $parseErrors) {
        $violations.Add("$($file.FullName): $($parseError.Message)")
    }
}

if ($violations.Count -gt 0) {
    $violations | ForEach-Object { Write-Error $_ }
    throw 'Workflow security checks failed.'
}

Write-Host 'Workflow security checks passed.'
