﻿function Get-FabricReleaseNotesFile
{
    [CmdletBinding()]
    Param ()

    $ErrorActionPreference = 'Stop'
    Set-StrictMode -Version 5

    Write-Debug 'Downloading list of Service Fabric release notes files from GitHub'
    $relNotesList = Invoke-RestMethod -Uri 'https://api.github.com/repos/microsoft/service-fabric/contents/release_notes'

    $releaseParser = {
        # Service-Fabric-71CU5-releasenotes.md -> 71.5
        if ($_.name -match '[-_](?<v>\d+)(CU(?<cu>\d+))?')
        {
            $v = $matches['v']
            $cu = [int]$matches['cu']
            [version]"$v.$cu"
        }
        else
        {
            $null
        }
    }
    
    $relNotesInfos = $relNotesList | Select-Object -Property name, download_url, @{ Name = 'release'; Expression = $releaseParser }
    $relNotesInfos | Write-Output
}

function Read-FabricReleaseNotes
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory = $true)] [PSObject] $ReleaseNotesFileInfo
    )

    $ErrorActionPreference = 'Stop'
    Set-StrictMode -Version 5

    if ($ReleaseNotesFileInfo.name -notlike '*.md')
    {
        Write-Error "Unsupported release notes file type: $($ReleaseNotesFileInfo.name)"
        return
    }

    Write-Debug "Downloading release notes file $($ReleaseNotesFileInfo.download_url)"
    $md = Invoke-WebRequest -UseBasicParsing -Uri $ReleaseNotesFileInfo.download_url | Select-Object -ExpandProperty Content
    $mdlines = $md -split "[`r`n]"
    Write-Debug "Release notes file has $(($mdlines | Measure-Object).Count) lines"

    Write-Debug "Parsing release notes"
    # Microsoft Azure Service Fabric 7.1 Fourth Refresh Release Notes
    $patternCaption = '\s*(?<caption>Microsoft\s+Azure\s+Service\s+Fabric\s+(?<releaseName>.+))\s+Release\s+Notes\s*'
    # || Windows Developer Set-up| 7.1.458.9590 | N/A | https://download.microsoft.com/download/e/3/c/e3ccf2e1-2c80-48b3-9a8d-ce0dbd67bb77/MicrosoftServiceFabric.7.1.458.9590.exe |
    $patternWinDevRuntime = '.+Windows\s+Developer\s+Set-up\s*\|\s*(?<winDevVer>[^\s]+)\s*\|.*(?<winDevUrl>https\:[^\s|]+).*'
    # |.NET SDK |Windows .NET SDK |4.1.458 |N/A | https://download.microsoft.com/download/e/3/c/e3ccf2e1-2c80-48b3-9a8d-ce0dbd67bb77/MicrosoftServiceFabricSDK.4.1.458.msi |
    $patternWinSdk = '.+Windows\s+\.NET\s+SDK\s*\|\s*(?<winSdkVer>[^\s]+)\s*\|.*(?<winSdkUrl>https\:[^\s|]+).*'
    $fullPattern = (@($patternCaption, $patternWinDevRuntime, $patternWinSdk) | ForEach-Object { "(^${_}$)" }) -join '|'
    Write-Debug "Full parsing pattern: $fullPattern"
    $matches = $mdlines | Select-String -Pattern $fullPattern | Select-Object -ExpandProperty Matches

    $validator = {
        Param ($obj, $description)
        if (($obj | Measure-Object).Count -ne 1)
        {
            Write-Debug "*** Release notes lines:"
            $mdlines | Write-Debug
            Write-Debug "*** Matches:"
            $matches | Select-Object -ExpandProperty Groups | Format-Table -AutoSize | Out-String -Width 250 | Write-Debug
            Write-Error "Unable to parse SF $description from release notes"
        }
    }

    $caption = $matches `
        | Where-Object { $_.Groups['caption'].Success } `
        | ForEach-Object {
            [pscustomobject]@{
                FullName = $_.Groups['caption'].Value
                ReleaseName = $_.Groups['releaseName'].Value
            }
        }
    & $validator $caption 'release name'

    $winDevRtInfo = $matches `
        | Where-Object { $_.Groups['winDevVer'].Success } `
        | ForEach-Object {
            [pscustomobject]@{
                Component = 'WinDevRuntime'
                Version = [version]$_.Groups['winDevVer'].Value
                Uri = [uri]$_.Groups['winDevUrl'].Value
            }
        }
    & $validator $winDevRtInfo 'Windows Developer Runtime information'

    $winSdkInfo = $matches `
        | Where-Object { $_.Groups['winSdkVer'].Success } `
        | ForEach-Object {
            [pscustomobject]@{
                Component = 'WinSdk'
                Version = [version]$_.Groups['winSdkVer'].Value
                Uri = [uri]$_.Groups['winSdkUrl'].Value
            }
        }
    & $validator $winSdkInfo 'Windows .NET SDK information'

    Write-Debug "Determining SF release three part version number"
    $threePartVersion = [version]$winDevRtInfo.Version.ToString(3)

    $sfInfo = [pscustomobject]@{
        ThreePartVersion = $threePartVersion
        Names = $caption
        WinDevRuntime = $winDevRtInfo
        WinSdk = $winSdkInfo
    }

    $sfInfo | Format-List | Out-String -Width 250 | Write-Debug
    return $sfInfo
}

function Get-FabricUpdateInfo
{
    [CmdletBinding()]
    Param ()

    $ErrorActionPreference = 'Stop'
    Set-StrictMode -Version 5

    $relNotesInfos = Get-FabricReleaseNotesFile
    $latestRelNotesInfo = $relNotesInfos | Sort-Object -Property release -Descending | Select-Object -First 1
    Write-Debug "Latest release notes file: $($latestRelNotesInfo.name) ($($latestRelNotesInfo.release))"
    $sfInfo = Read-FabricReleaseNotes -ReleaseNotesFileInfo $latestRelNotesInfo
    Write-Debug "Latest version: $($sfInfo.ThreePartVersion) ('$($sfInfo.Names.FullName)')"
    return $sfInfo
}