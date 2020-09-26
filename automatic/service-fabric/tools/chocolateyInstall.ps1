$ErrorActionPreference = 'Stop'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  softwareName   = $env:ChocolateyPackageTitle
  fileType       = 'exe'
  url            = 'https://download.microsoft.com/download/e/3/c/e3ccf2e1-2c80-48b3-9a8d-ce0dbd67bb77/MicrosoftServiceFabric.7.1.458.9590.exe'
  checksum       = '80c7981cb939b6c7f57f145d5e6442035e3cd365abd811a35be6aab26848b070'
  checksumType   = 'sha256'
  silentArgs     = '/quiet /accepteula'
  validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
