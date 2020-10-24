$ErrorActionPreference = 'Stop'

$installDir  = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName    = 'smimesign'
  url            = 'https://github.com/github/smimesign/releases/download/v0.1.0/smimesign-windows-386-0.1.0.zip'
  url64Bit       = 'https://github.com/github/smimesign/releases/download/v0.1.0/smimesign-windows-amd64-0.1.0.zip'
  checksum       = 'b3709e4ec50bfaf9af47fe7279aaafeb634011ad88a32b460b5d7d630cc2c596'
  checksum64     = 'bc5fd354ad0df064b7c35769e26598aa7a0e636249a1c0f07d26c02db3816da9'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  unzipLocation  = $installDir
}

Write-Host "Installing to '$installDir'"

Install-ChocolateyZipPackage @packageArgs
