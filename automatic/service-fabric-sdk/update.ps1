Import-Module au

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
            "(?i)^(\s*url\s*=\s*)'.*'" = "`${1}'$($Latest.URL32)'"
            "(?i)^(\s*checksum\s*=\s*)'.*'" = "`${1}'$($Latest.Checksum32)'"
            "(?i)^(\s*checksumType\s*=\s*)'.*'" = "`${1}'$($Latest.ChecksumType32)'"
        }
        'service-fabric-sdk.nuspec' = @{
            "(dependency\s+id=`"service-fabric`"\s+version=`")([^`"]+)" = "`${1}$($Latest.RuntimeVersion)"
        }
     }
}

function global:au_GetLatest {
    $Latest = @{
        Version = '4.1.456'
        RuntimeVersion = '7.1.456'
        URL32 = 'https://download.microsoft.com/download/9/3/0/930f9307-52ef-4597-9ae9-f534415e77eb/MicrosoftServiceFabricSDK.4.1.456.msi'
        ChecksumType32 = 'sha256'
    }
    return $Latest
}

update -NoCheckUrl -ChecksumFor 32
