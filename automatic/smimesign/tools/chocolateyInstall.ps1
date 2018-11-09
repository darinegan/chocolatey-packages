$ErrorActionPreference = 'Stop'

$installDir  = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName    = 'smimesign'
  url            = 'https://github.com/github/smimesign/releases/download/0.0.6/smimesign-windows-386-0.0.6.zip'
  url64Bit       = 'https://github.com/github/smimesign/releases/download/0.0.6/smimesign-windows-amd64-0.0.6.zip'
  checksum       = '9A13D00AA02C0A5D277C030297D09F10A467F31E6740F1520A08E09A23046323'
  checksum64     = '2A2F946E31F2D74EADCDCD97B7BFC69298CEE2F11CF7CB03C604D28FA1B34CD3'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  unzipLocation  = $installDir
}

Write-Host "Installing to '$installDir'"

Install-ChocolateyZipPackage @packageArgs
