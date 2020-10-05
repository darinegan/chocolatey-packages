Import-Module au
Import-Module $PSScriptRoot\..\..\tools\PSModules\ServiceFabricPackageTools\ServiceFabricPackageTools.psm1

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

function global:au_BeforeUpdate() {
    $Latest.Checksum32 = Get-RemoteChecksumFast -Url $Latest.Url32 -Algorithm $Latest.ChecksumType32
 }

function global:au_GetLatest {
    $sfInfo = Get-FabricUpdateInfo
    $Latest = @{
        Version = $sfInfo.WinSdk.ThreePartVersion
        RuntimeVersion = $sfInfo.WinDevRuntime.ThreePartVersion
        URL32 = $sfInfo.WinSdk.Uri.AbsoluteUri
        ChecksumType32 = 'sha256'
    }
    return $Latest
}

update -NoCheckUrl -ChecksumFor none
