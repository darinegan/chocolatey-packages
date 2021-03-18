Import-Module au
Import-Module $PSScriptRoot\..\..\tools\PSModules\ServiceFabricPackageTools\ServiceFabricPackageTools.psm1

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
            "(?i)^(\s*url\s*=\s*)'.*'" = "`${1}'$($Latest.URL32)'"
            "(?i)^(\s*checksum\s*=\s*)'.*'" = "`${1}'$($Latest.Checksum32)'"
            "(?i)^(\s*checksumType\s*=\s*)'.*'" = "`${1}'$($Latest.ChecksumType32)'"
        }
        'service-fabric.nuspec' = @{
            "(releaseNotes>)[^<]*(</releaseNotes)" = "`${1}[$($Latest.ReleaseName) Release Notes]($($Latest.ReleaseNotesUrl))`${2}"
        }
     }
}

function global:au_BeforeUpdate() {
    $Latest.Checksum32 = Get-RemoteChecksumFast -Url $Latest.Url32 -Algorithm $Latest.ChecksumType32
 }

function global:au_GetLatest {
    $sfInfo = Get-FabricUpdateInfo
    $Latest = @{
        Version = $sfInfo.WinDevRuntime.ThreePartVersion
        URL32 = $sfInfo.WinDevRuntime.Uri.AbsoluteUri
        ChecksumType32 = 'sha256'
        ReleaseName = $sfInfo.Names.FullName
        ReleaseNotesUrl = $sfInfo.ReleaseNotesUrl
    }
    return $Latest
}

update -NoCheckUrl -ChecksumFor none
