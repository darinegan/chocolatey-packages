$ErrorActionPreference = 'Stop'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  softwareName   = $env:ChocolateyPackageTitle
  fileType       = 'exe'
  url            = 'https://download.microsoft.com/download/b/8/a/b8a2fb98-0ec1-41e5-be98-9d8b5abf7856/MicrosoftServiceFabric.8.0.516.9590.exe'
  checksum       = 'a69bb377d908ac89177eb346f97c95b78b3fb485c9577d965a2fd513a587f351'
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
