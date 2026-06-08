[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'

Import-Module Chocolatey-AU

$commands = Get-Command -Module Chocolatey-AU -CommandType Function, Alias |
    Select-Object -ExpandProperty Name
Write-Host "Exported commands: $($commands -join ', ')"

$required = @('Update-AUPackages', 'updateall', 'update', 'Get-AUPackages')
foreach ($command in $required) {
    if ($command -notin $commands) {
        throw "Required command '$command' not found in Chocolatey-AU module."
    }
}
