$ErrorActionPreference = 'Stop'

$installDir  = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName    = 'smimesign'
  url            = 'https://github.com/github/smimesign/releases/download/v0.2.0/smimesign-windows-386-v0.2.0.zip'
  url64Bit       = 'https://github.com/github/smimesign/releases/download/v0.2.0/smimesign-windows-amd64-v0.2.0.zip'
  checksum       = '259e6e94fabd294e25ee5f71e8395e8c02b7bcf45a56a769b99943549ae88bd1'
  checksum64     = 'e6ccd16f61b5d3405836168acf782d4e52164bafae35004329bba41a94cd8329'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  unzipLocation  = $installDir
}

Write-Host "Installing to '$installDir'"

Install-ChocolateyZipPackage @packageArgs
