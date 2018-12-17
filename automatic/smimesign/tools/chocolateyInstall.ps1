$ErrorActionPreference = 'Stop'

$installDir  = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName    = 'smimesign'
  url            = 'https://github.com/github/smimesign/releases/download/0.0.10/smimesign-windows-386-0.0.10.zip'
  url64Bit       = 'https://github.com/github/smimesign/releases/download/0.0.10/smimesign-windows-amd64-0.0.10.zip'
  checksum       = 'bec931ed85e78637b1ccb8c21838516ff95b0f7bc50fdd76c03227b98526ebdf'
  checksum64     = '9f773fdfed78b4f03e5d6c7132319db1aa38790514396ae286fcd65753167789'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  unzipLocation  = $installDir
}

Write-Host "Installing to '$installDir'"

Install-ChocolateyZipPackage @packageArgs
