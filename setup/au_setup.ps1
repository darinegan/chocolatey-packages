# WMF 3/4 only
if ($PSVersionTable.PSVersion -lt $(New-Object System.Version("5.0.0.0"))) {
  choco install dotnet4.5.1 -y
  choco upgrade powershell-packagemanagement --ignore-dependencies -y
}

$refreshenv = Get-Command refreshenv -ea SilentlyContinue
if ($refreshenv -ne $null -and $refreshenv.CommandType -ne 'Application') {
  refreshenv # You need the Chocolatey profile installed for this to work properly (Choco v0.9.10.0+).
} else {
  Write-Warning "We detected that you do not have the Chocolatey PowerShell profile installed, which is necessary for 'refreshenv' to work in PowerShell."
}

# Chocolatey-AU is the maintained successor to majkinetor/au.
# https://github.com/chocolatey-community/au
# https://community.chocolatey.org/packages/chocolatey-au
choco install chocolatey-au -y

Get-Module Chocolatey-AU -ListAvailable | Select-Object Name, Version
