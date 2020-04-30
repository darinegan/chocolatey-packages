$ErrorActionPreference = 'Stop'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  softwareName   = $env:ChocolateyPackageTitle
  fileType       = 'exe'
  url            = 'https://download.microsoft.com/download/c/8/c/c8c98ab2-6e7a-4d9a-a0a5-506b18111677/MicrosoftServiceFabric.7.1.409.9590.exe'
  checksum       = '84cd3a318440290da49738c8c4451a4ceb002e022245b1a3d604788de8b4cfae'
  checksumType   = 'sha256'
  silentArgs     = '/quiet /accepteula'
  validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
