$ErrorActionPreference = 'Stop'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  softwareName   = $env:ChocolateyPackageTitle
  fileType       = 'exe'
  url            = 'https://download.microsoft.com/download/9/3/0/930f9307-52ef-4597-9ae9-f534415e77eb/MicrosoftServiceFabric.7.1.456.9590.exe'
  checksum       = '2014aff9c0561843e0311197040b415372f2ad37f682dd57c8c982986cc4735b'
  checksumType   = 'sha256'
  silentArgs     = '/quiet /accepteula'
  validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
