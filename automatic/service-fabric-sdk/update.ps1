Import-Module au

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
    $Latest = @{
        Version = '4.0.464'
        URL32 = 'https://download.microsoft.com/download/8/b/2/8b21dcf8-4909-4aaa-8dcb-64c0a37a2d9c/MicrosoftServiceFabricSDK.4.0.464.msi'
        ChecksumType32 = 'sha256'
    }
    return $Latest
}

update -NoCheckUrl -ChecksumFor 32
