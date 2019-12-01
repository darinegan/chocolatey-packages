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
        Version = '3.3.664'
        URL32 = 'https://download.microsoft.com/download/D/6/6/D664EC73-321A-4F1C-916E-65CE5AD729CF/MicrosoftServiceFabricSDK.3.3.664.msi'
        ChecksumType32 = 'sha256'
    }
    return $Latest
}

update -NoCheckUrl -ChecksumFor 32
