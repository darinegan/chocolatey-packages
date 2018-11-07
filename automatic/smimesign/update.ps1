import-module au

$url = 'https://github.com/github/smimesign/releases/latest'

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
            "(^[$]version\s*=\s*)('.*')" = "`$1'$($Latest.Version)'"
        }
     }
}

function global:au_GetLatest {
    $request = [System.Net.WebRequest]::Create($url)
    $request.AllowAutoRedirect=$true
    $response = $request.GetResponse()
    $responseUri = $response.ResponseUri

    $versionString = $responseUri.AbsolutePath | Split-Path -Leaf
    $Latest = @{ Version = $versionString }
    return $Latest
}

update -NoCheckUrl -ChecksumFor none
