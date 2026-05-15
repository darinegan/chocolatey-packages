Import-Module chocolatey-au

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
    $request = [System.Net.WebRequest]::Create('https://github.com/github/smimesign/releases/latest')
    $request.AllowAutoRedirect = $true
    $response = $request.GetResponse()
    $responseUri = $response.ResponseUri

    $tag = $responseUri.AbsolutePath | Split-Path -Leaf
    $version = $tag -replace '^v?'

    $Latest = @{
        Version        = $version
        URL32          = 'https://github.com/github/smimesign/releases/download/{0}/smimesign-windows-386-{0}.zip' -f $tag
        URL64          = 'https://github.com/github/smimesign/releases/download/{0}/smimesign-windows-amd64-{0}.zip' -f $tag
        ChecksumType32 = 'sha256'
        ChecksumType64 = 'sha256'
    }
    return $Latest
}

update -NoCheckUrl -ChecksumFor all -NoCheckChocoVersion
