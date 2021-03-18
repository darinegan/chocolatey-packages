Set-StrictMode -Version 5

. $PSScriptRoot\Functions\Get-CallerPreference.ps1

function Get-FabricReleaseNotesFile
{
    [CmdletBinding()]
    Param ()

    Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
    $ErrorActionPreference = 'Stop'

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
    
    $relNotesInfos = $relNotesList | Select-Object -Property name, download_url, html_url, @{ Name = 'release'; Expression = $releaseParser }
    $relNotesInfos | Write-Output
}

function Read-FabricReleaseNotes
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory = $true)] [PSObject] $ReleaseNotesFileInfo
    )

    Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
    $ErrorActionPreference = 'Stop'

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
    # # Microsoft Azure Service Fabric 7.1 Fourth Refresh Release Notes
    $patternCaption = '\s*#\s*(?<caption>Microsoft\s+Azure\s+Service\s+Fabric\s+(?<releaseName>.+))\s+Release\s+Notes\s*'
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
            $version = [version]$_.Groups['winDevVer'].Value
            [pscustomobject]@{
                Component = 'WinDevRuntime'
                Version = $version
                ThreePartVersion = [version]($version.ToString(3))
                Uri = [uri]$_.Groups['winDevUrl'].Value
            }
        }
    & $validator $winDevRtInfo 'Windows Developer Runtime information'

    $winSdkInfo = $matches `
        | Where-Object { $_.Groups['winSdkVer'].Success } `
        | ForEach-Object {
            $version = [version]$_.Groups['winSdkVer'].Value
            [pscustomobject]@{
                Component = 'WinSdk'
                Version = $version
                ThreePartVersion = [version]($version.ToString(3))
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
        ReleaseNotesUrl = $ReleaseNotesFileInfo.html_url
    }

    $sfInfo | Format-List | Out-String -Width 250 | Write-Debug
    return $sfInfo
}

function Write-FabricCachedUpdateInfo
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory = $true)] [PSObject] $FabricUpdateInfo
    )

    Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
    $ErrorActionPreference = 'Stop'

    $timestamp = Get-Date
    $payload = [pscustomobject]@{
        Timestamp = $timestamp
        FabricUpdateInfo = $FabricUpdateInfo
    }

    $cachePath = $script:FabricCachedUpdateInfoPath
    Write-Debug ('Writing SF update info with timestamp {0:o} to cache file {1}' -f $timestamp, $cachePath)
    $payload | Export-Clixml -Path $cachePath
}

function Read-FabricCachedUpdateInfo
{
    [CmdletBinding()]
    Param ()

    Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
    $ErrorActionPreference = 'Stop'

    $cachePath = $script:FabricCachedUpdateInfoPath
    if (Test-Path -Path $script:FabricCachedUpdateInfoPath)
    {
        Write-Debug "Reading SF update info cache file $cachePath"
        $cachedInfo = Import-Clixml -Path $script:FabricCachedUpdateInfoPath
        $timestamp = $cachedInfo.Timestamp
        Write-Debug ('SF cached update info timestamp is {0:o}' -f $timestamp)
        $age = (Get-Date) - $timestamp
        $maxAge = $script:FabricCacheMaxAge
        if ($age -lt $maxAge)
        {
            Write-Debug "Returning cached SF update info (age: $age, max age: $maxAge)"
            return $cachedInfo.FabricUpdateInfo
        }
        else
        {
            Write-Debug "Cached SF update info is outdated, ignoring (age: $age, max age: $maxAge)"
        }
    }
    else
    {
        Write-Debug "SF update info cache file does not exist: $cachePath"
    }
}

function Get-FabricUpdateInfo
{
    [CmdletBinding()]
    Param
    (
        [switch] $IgnoreCache
    )

    Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
    $ErrorActionPreference = 'Stop'

    if ($IgnoreCache)
    {
        Write-Debug 'Ignoring cached info, as requested'
        $sfInfo = $null
    }
    else
    {
        $sfInfo = Read-FabricCachedUpdateInfo
    }

    if ($null -eq $sfInfo)
    {
        $relNotesInfos = Get-FabricReleaseNotesFile
        $latestRelNotesInfo = $relNotesInfos | Sort-Object -Property release -Descending | Select-Object -First 1
        Write-Debug "Latest release notes file: $($latestRelNotesInfo.name) ($($latestRelNotesInfo.release))"
        $sfInfo = Read-FabricReleaseNotes -ReleaseNotesFileInfo $latestRelNotesInfo
        Write-FabricCachedUpdateInfo -FabricUpdateInfo $sfInfo
    }

    Write-Debug "Latest version: $($sfInfo.ThreePartVersion) ('$($sfInfo.Names.FullName)')"
    return $sfInfo
}

function Get-RemoteChecksumFast([string] $Url, $Algorithm='sha256', $Headers)
{
    $ProgressPreference = 'SilentlyContinue'
    & (Get-Command -Name Get-RemoteChecksum).ScriptBlock.GetNewClosure() @PSBoundParameters
}

$script:FabricCachedUpdateInfoPath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath("$PSScriptRoot\..\..\..\sfinfo.clixml")
$script:FabricCacheMaxAge = [timespan]::FromHours(1)
