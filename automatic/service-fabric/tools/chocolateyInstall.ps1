$ErrorActionPreference = 'Stop'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  softwareName   = $env:ChocolateyPackageTitle
  fileType       = 'exe'
  url            = 'https://download.microsoft.com/download/8/b/2/8b21dcf8-4909-4aaa-8dcb-64c0a37a2d9c/MicrosoftServiceFabric.7.0.464.9590.exe'
  checksum       = '7a6735398653772e45ab58a94d5e4f316702dab5c60d3b2b50edee42c17b08bf'
  checksumType   = 'sha256'
  silentArgs     = '/quiet /accepteula'
  validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
