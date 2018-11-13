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
        Version = '5.6.220.9494'
        URL32 = 'https://download.microsoft.com/download/8/9/A/89AC6EFC-7885-4D3E-A3B3-30C682BC702C/MicrosoftServiceFabric.5.6.220.9494.msi'
        ChecksumType32 = 'sha256'
    }
    return $Latest
}

update -NoCheckUrl -ChecksumFor 32
