$ErrorActionPreference = 'Stop'

$logPath = Join-Path $env:TEMP 'chocolatey' | Join-Path -ChildPath $env:ChocolateyPackageName | Join-Path -ChildPath $env:ChocolateyPackageVersion
$logFile = Join-Path $logPath 'install.log'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  softwareName   = $env:ChocolateyPackageTitle
  fileType       = 'msi'
  url            = 'https://download.microsoft.com/download/8/b/2/8b21dcf8-4909-4aaa-8dcb-64c0a37a2d9c/MicrosoftServiceFabricSDK.4.0.464.msi'
  checksum       = '51b49a2cc2ff5c7f0a5394f63ca244899cff34b8becb47501553f05680bfe2bf'
  checksumType   = 'sha256'
  silentArgs     = '/quiet /qn /norestart /l*v "{0}" IACCEPTEULA=yes' -f $logFile
  validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
