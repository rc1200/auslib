
# PowerShell 3+ $PSScriptRoot is an automatic variable set to the current file's/module's directory

write-host 'current directory is ' $PSScriptRoot
$prevFolder = Split-Path -Path $PSScriptRoot -Parent
Write-Host 'Previous directory is ' $prevFolder
. "$prevFolder\AUSLib.ps1"



#############################  update web.config Connection String  ######################

# Install-Module sqlserver
# After the module has installed, the module commands including the Invoke-sqlcmd should be readily available.
# You can check the same using Get-Command -ModuleName sqlserver.
# If this module is not readily available, you can 
# Import-Module sqlserver 


$sourceDir = 'C:\Users\rc91124\Documents\Ron\Tickets\50132\WebServices_03.03.03.02\WebServices_03.03.03.02\Stored Procedures CISV3\SQL'
$filePattern = '.*\.sql$'
# Needed to connect to correct DB and Table
$ServerName = 'BPW33Z2'
$DatabaseName = 'UC2018v3'
$userName = 'ADVANCED'
$password = 'password'

dropCompileSPFunFromDirectory $sourceDir $filePattern $ServerName $DatabaseName $userName $password