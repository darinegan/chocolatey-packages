$ErrorActionPreference = 'Stop'

$installDir  = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName    = 'smimesign'
  url            = 'https://github.com/github/smimesign/releases/download/v0.0.13/smimesign-windows-386-0.0.13.zip'
  url64Bit       = 'https://github.com/github/smimesign/releases/download/v0.0.13/smimesign-windows-amd64-0.0.13.zip'
  checksum       = '74a5fba20c0e0a78f9c49e245060c27e0cbd75ba4ecb71d6613d7a58330c97f5'
  checksum64     = 'a5bb1f6c5519387cb8463784d7d1d9f27516f12c226085caf5f5b4b0f2b718b1'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  unzipLocation  = $installDir
}

Write-Host "Installing to '$installDir'"

Install-ChocolateyZipPackage @packageArgs
