$ErrorActionPreference = 'Stop'

$installDir  = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName    = 'smimesign'
  url            = 'https://github.com/github/smimesign/releases/download/0.0.8/smimesign-windows-386-0.0.8.zip'
  url64Bit       = 'https://github.com/github/smimesign/releases/download/0.0.8/smimesign-windows-amd64-0.0.8.zip'
  checksum       = '28c712fdc7b91c0d408d0775f7fdb6def8ae3df4287b1b164d9e580d2adc3263'
  checksum64     = 'faba01366947d04330572f7494839cf6fa7f7594b81e9f62c1a4718dc208f17d'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  unzipLocation  = $installDir
}

Write-Host "Installing to '$installDir'"

Install-ChocolateyZipPackage @packageArgs
