$ErrorActionPreference = 'Stop'

$logPath = Join-Path $env:TEMP 'chocolatey' | Join-Path -ChildPath $env:ChocolateyPackageName | Join-Path -ChildPath $env:ChocolateyPackageVersion
$logFile = Join-Path $logPath 'install.log'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  softwareName   = $env:ChocolateyPackageTitle
  fileType       = 'msi'
  url            = 'https://download.microsoft.com/download/c/8/c/c8c98ab2-6e7a-4d9a-a0a5-506b18111677/MicrosoftServiceFabricSDK.4.1.409.msi'
  checksum       = '48d232e4860106d2789b830b0eee0c202bcd4a2d6e10016e861931e8224f0619'
  checksumType   = 'sha256'
  silentArgs     = '/quiet /qn /norestart /l*v "{0}" IACCEPTEULA=yes' -f $logFile
  validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
