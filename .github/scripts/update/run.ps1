[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'

$blockedNames = @(
    'api_key',
    'github_api_key',
    'gist_id',
    'mail_user',
    'mail_server',
    'mail_pass',
    'mail_port',
    'mail_enablessl',
    'CHOCOLATEY_API_KEY',
    'CHOCOLATEY_PUSH_URL'
)

foreach ($name in $blockedNames) {
    if (![string]::IsNullOrWhiteSpace([Environment]::GetEnvironmentVariable($name))) {
        throw "Secret-like environment variable '$name' must not be set during update."
    }
}

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot '..\..\..')
Push-Location $repoRoot
try {
    & '.\update_all.ps1'
} finally {
    Pop-Location
}
