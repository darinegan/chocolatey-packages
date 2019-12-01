$ErrorActionPreference = 'Stop'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  softwareName   = $env:ChocolateyPackageTitle
  fileType       = 'exe'
  url            = 'https://download.microsoft.com/download/D/6/6/D664EC73-321A-4F1C-916E-65CE5AD729CF/MicrosoftServiceFabric.6.4.664.9590.exe'
  checksum       = '1dc68861bf863f716f8d815ed0d6dea51044ac5046529ced63b3eca6c3a221e0'
  checksumType   = 'sha256'
  silentArgs     = '/quiet /accepteula'
  validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
