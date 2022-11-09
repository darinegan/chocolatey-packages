$ErrorActionPreference = 'Stop'

$logPath = Join-Path $env:TEMP 'chocolatey' | Join-Path -ChildPath $env:ChocolateyPackageName | Join-Path -ChildPath $env:ChocolateyPackageVersion
$logFile = Join-Path $logPath 'install.log'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  softwareName   = $env:ChocolateyPackageTitle
  fileType       = 'msi'
  url            = 'https://download.microsoft.com/download/b/8/a/b8a2fb98-0ec1-41e5-be98-9d8b5abf7856/MicrosoftServiceFabricSDK.6.1.1390.msi'
  checksum       = '318e1ffcbe7e038c0c831803c7a73d54e668ee269d893ef36c0931b3552c4bc6'
  checksumType   = 'sha256'
  silentArgs     = '/quiet /qn /norestart /l*v "{0}" IACCEPTEULA=yes' -f $logFile
  validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
