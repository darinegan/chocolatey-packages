#Name can be 'random N' to randomly force the Nth group of packages.

param( [string[]] $Name, [string] $Root = "$PSScriptRoot\automatic", [switch]$ThrowOnErrors )

. (Join-Path $PSScriptRoot 'au_config.ps1')
$global:au_root = Resolve-Path $Root

if (($Name.Length -gt 0) -and ($Name[0] -match '^random (.+)')) {
    [array] $lsau = lsau

    $group = [int]$Matches[1]
    $n = (Get-Random -Maximum $group)
    Write-Host "TESTING GROUP $($n+1) of $group"

    $group_size = [int]($lsau.Count / $group) + 1
    $Name = $lsau | select -First $group_size -Skip ($group_size*$n) | % { $_.Name }

    Write-Host ($Name -join ' ')
    Write-Host ('-'*80)
}

$options = [ordered]@{
    Force = $true
    Push = $false

    Report = @{
        Type = 'markdown'                                   #Report type: markdown or text
        Path = "$PSScriptRoot\Update-Force-Test-${n}.md"      #Path where to save the report
        Params= New-AuReportParams -Overrides @{            #Report parameters:
            Title       = "Update Force Test - Group ${n}"
            UserMessage = "[Update report](https://gist.github.com/$Env:gist_id) | **USING AU NEXT VERSION**"       #  Markdown, Text: Custom user message to show
        }
    }
}

$gistOptions = New-AuGistOptions -Id $Env:gist_id_test -Path "$PSScriptRoot\Update-Force-Test-${n}.md" -Description "Update Force Test Report #powershell #chocolatey"
if ($gistOptions) {
    $options.Gist = $gistOptions
}

$global:info = updateall -Name $Name -Options $Options
