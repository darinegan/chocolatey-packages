[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'

$results = [ordered]@{
    'detect-scope' = $env:DETECT_RESULT
    'verify-au' = $env:VERIFY_RESULT
    'smoke-test' = $env:SMOKE_RESULT
    'pack' = $env:PACK_RESULT
    'workflow-security' = $env:SECURITY_RESULT
}

foreach ($entry in $results.GetEnumerator()) {
    Write-Host "$($entry.Key): $($entry.Value)"
}

$required = @('detect-scope', 'workflow-security')
if ($env:RELEVANT -eq 'true') {
    $required += @('verify-au', 'smoke-test', 'pack')
}

$failed = @(
    foreach ($job in $required) {
        if ($results[$job] -ne 'success') {
            "$job=$($results[$job])"
        }
    }
)

if ($failed.Count -gt 0) {
    throw "Required validation failed: $($failed -join ', ')"
}

if ($env:RELEVANT -ne 'true') {
    Write-Host 'No relevant changes detected; validation gate passed.'
} else {
    Write-Host 'All required validation jobs passed.'
}
