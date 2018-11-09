$ErrorActionPreference = 'Stop'

$installDir  = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName    = 'smimesign'
  url            = 'https://github.com/github/smimesign/releases/download/0.0.7/smimesign-windows-386-0.0.7.zip'
  url64Bit       = 'https://github.com/github/smimesign/releases/download/0.0.7/smimesign-windows-amd64-0.0.7.zip'
  checksum       = '6a974a54763c8eef7085cf53b1fb49da90c7e9a2b9c0fd7360aee73042258681'
  checksum64     = 'e8e59a7a13635307e42225c2103b3d48ca004586d9d0382e225ea1e0594c8ff5'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  unzipLocation  = $installDir
}

Write-Host "Installing to '$installDir'"

Install-ChocolateyZipPackage @packageArgs
