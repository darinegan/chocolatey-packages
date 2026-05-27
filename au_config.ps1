if (Test-Path (Join-Path $PSScriptRoot 'update_vars.ps1')) {
    . (Join-Path $PSScriptRoot 'update_vars.ps1')
}

function New-AuReportParams {
    param([hashtable] $Overrides = @{})

    $params = @{
        Github_UserRepo = $Env:github_user_repo
        NoAppVeyor     = $false
    }

    foreach ($key in $Overrides.Keys) {
        $params[$key] = $Overrides[$key]
    }

    return $params
}

function New-AuGistOptions {
    param(
        [string] $Id,
        $Path,
        [string] $Description
    )

    if ([string]::IsNullOrWhiteSpace($Env:github_api_key)) {
        return $null
    }

    $gist = @{
        Id     = $Id
        ApiKey = $Env:github_api_key
        Path   = $Path
    }

    if ($PSBoundParameters.ContainsKey('Description')) {
        $gist.Description = $Description
    }

    return $gist
}
