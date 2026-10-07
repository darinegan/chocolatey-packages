$ErrorActionPreference = 'Stop'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  softwareName   = $env:ChocolateyPackageTitle
  fileType       = 'exe'
  url            = 'https://download.microsoft.com/download/b/8/a/b8a2fb98-0ec1-41e5-be98-9d8b5abf7856/MicrosoftServiceFabric.11.7.157.1.exe'
  checksum       = 'bbd4531d80ed5fa8d2704c9267f701684fc58306987184be9caf35153f358c7b'
  checksumType   = 'sha256'
  silentArgs     = '/quiet /accepteula'
  validExitCodes = @(0)
}

# Running ServiceFabricLocalClusterManager prevents the update of FabricCommon.dll, causing the upgrade to fail.
$sflcm = Get-Process -Name ServiceFabricLocalClusterManager -ErrorAction SilentlyContinue
if (($sflcm | Measure-Object).Count -gt 0)
{
    $pids = $sflcm | Select-Object -ExpandProperty Id | Sort-Object
    Write-Verbose "Stopping Service Fabric Local Cluster Manager (process(es): $pids) to avoid problems during upgrade"
    $sflcm | Stop-Process -Force
}

Install-ChocolateyPackage @packageArgs
