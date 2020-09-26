Import-Module au

. $PSScriptRoot\..\..\tools\sftools.ps1

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
            "(?i)^(\s*url\s*=\s*)'.*'" = "`${1}'$($Latest.URL32)'"
            "(?i)^(\s*checksum\s*=\s*)'.*'" = "`${1}'$($Latest.Checksum32)'"
            "(?i)^(\s*checksumType\s*=\s*)'.*'" = "`${1}'$($Latest.ChecksumType32)'"
        }
     }
}

function global:au_GetLatest {
    $sfInfo = Get-FabricUpdateInfo
    $Latest = @{
        Version = [version]$sfInfo.WinDevRuntime.Version.ToString(3)
        URL32 = $sfInfo.WinDevRuntime.Uri.AbsoluteUri
        ChecksumType32 = 'sha256'
    }
    return $Latest
}

update -NoCheckUrl -ChecksumFor 32
