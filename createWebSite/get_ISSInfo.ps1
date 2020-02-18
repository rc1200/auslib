write-host 'current directory is ' $PSScriptRoot
$prevFolder = Split-Path -Path $PSScriptRoot -Parent
Write-Host 'Previous directory is ' $prevFolder
. "$prevFolder\AUSLib.ps1"

Get-DotNetFrameworkVersion

$env:computername

Import-Module Webadministration
Get-ChildItem -Path IIS:\Sites | Format-table -AutoSize 
Get-ChildItem -Path IIS:\Sites | Format-table -AutoSize | out-file $PSScriptRoot'\'$env:computername'_bindings.txt' -width 512 

