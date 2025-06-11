$ErrorActionPreference = 'Stop'

$logPath = Join-Path $env:TEMP 'chocolatey' | Join-Path -ChildPath $env:ChocolateyPackageName | Join-Path -ChildPath $env:ChocolateyPackageVersion
$logFile = Join-Path $logPath 'install.log'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  softwareName   = $env:ChocolateyPackageTitle
  fileType       = 'msi'
  url            = 'https://download.microsoft.com/download/b/8/a/b8a2fb98-0ec1-41e5-be98-9d8b5abf7856/MicrosoftServiceFabricSDK.8.0.2707.msi'
  checksum       = 'd9b99a3d3d814335f4bf4a9a71f1fac53848939affb24180e3c5522bd5394631'
  checksumType   = 'sha256'
  silentArgs     = '/quiet /qn /norestart /l*v "{0}" IACCEPTEULA=yes' -f $logFile
  validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
