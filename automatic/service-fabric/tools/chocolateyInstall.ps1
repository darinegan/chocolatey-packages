$ErrorActionPreference = 'Stop'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  softwareName   = $env:ChocolateyPackageTitle
  fileType       = 'exe'
  url            = 'https://download.microsoft.com/download/5/e/e/5ee43eba-5c87-4d11-8a7c-bb26fd162b29/MicrosoftServiceFabric.7.0.457.9590.exe'
  checksum       = '18b151a1239de6fe3b5784e41f657f7da7b2a03f21b321e4823c00928f49813c'
  checksumType   = 'sha256'
  silentArgs     = '/quiet /accepteula'
  validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
