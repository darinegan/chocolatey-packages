Import-Module $PSScriptRoot\..\..\tools\PSModules\ServiceFabricPackageTools\ServiceFabricPackageTools.psm1
Get-FabricUpdateInfo -IgnoreCache | Out-Null
