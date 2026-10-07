$ErrorActionPreference = 'Stop'

$logPath = Join-Path $env:TEMP 'chocolatey' | Join-Path -ChildPath $env:ChocolateyPackageName | Join-Path -ChildPath $env:ChocolateyPackageVersion
$logFile = Join-Path $logPath 'install.log'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  softwareName   = $env:ChocolateyPackageTitle
  fileType       = 'msi'
  url            = 'https://download.microsoft.com/download/b/8/a/b8a2fb98-0ec1-41e5-be98-9d8b5abf7856/MicrosoftServiceFabricSDK.8.7.157.msi'
  checksum       = '32ecb92ca3c9369a0bea688737f9714e93ec1f8022d1708abf5084e5b1f9efba'
  checksumType   = 'sha256'
  silentArgs     = '/quiet /qn /norestart /l*v "{0}" IACCEPTEULA=yes' -f $logFile
  validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
