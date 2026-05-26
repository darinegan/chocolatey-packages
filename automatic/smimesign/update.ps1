Import-Module au

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
            "(?i)^(\s*url\s*=\s*)'.*'"            = "`${1}'$($Latest.URL32)'"
            "(?i)^(\s*url64Bit\s*=\s*)'.*'"       = "`${1}'$($Latest.URL64)'"
            "(?i)^(\s*checksum\s*=\s*)'.*'"       = "`${1}'$($Latest.Checksum32)'"
            "(?i)^(\s*checksum64\s*=\s*)'.*'"     = "`${1}'$($Latest.Checksum64)'"
            "(?i)^(\s*checksumType\s*=\s*)'.*'"   = "`${1}'$($Latest.ChecksumType32)'"
            "(?i)^(\s*checksumType64\s*=\s*)'.*'" = "`${1}'$($Latest.ChecksumType64)'"
        }
    }
}

function global:au_GetLatest {
    $releases = Invoke-RestMethod -Uri 'https://api.github.com/repos/github/smimesign/releases' -Headers @{ 'User-Agent' = 'Chocolatey-AU' }
    $latestRelease = $releases |
        Where-Object { !$_.draft -and $_.tag_name -match '^v?\d+(\.\d+){1,3}$' } |
        Sort-Object { [version]($_.tag_name -replace '^v') } -Descending |
        Select-Object -First 1

    if (!$latestRelease) { throw 'Could not find a stable smimesign release.' }

    $tag = $latestRelease.tag_name
    $version = $tag -replace '^v?'
    $asset32 = $latestRelease.assets | Where-Object { $_.name -eq "smimesign-windows-386-$tag.zip" } | Select-Object -First 1
    $asset64 = $latestRelease.assets | Where-Object { $_.name -eq "smimesign-windows-amd64-$tag.zip" } | Select-Object -First 1

    if (!$asset32 -or !$asset64) { throw "Could not find smimesign Windows assets for $tag." }

    $Latest = @{
        Version        = $version
        URL32          = $asset32.browser_download_url
        URL64          = $asset64.browser_download_url
        ChecksumType32 = 'sha256'
        ChecksumType64 = 'sha256'
    }
    return $Latest
}

update -NoCheckUrl -ChecksumFor all -NoCheckChocoVersion
