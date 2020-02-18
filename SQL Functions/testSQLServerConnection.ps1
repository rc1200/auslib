write-host 'current directory is ' $PSScriptRoot
$prevFolder = Split-Path -Path $PSScriptRoot -Parent
Write-Host 'Previous directory is ' $prevFolder
. "$prevFolder\AUSLib.ps1"


Get-Host | Select-Object Version

# Install-Module sqlserver
# After the module has installed, the module commands including the Invoke-sqlcmd should be readily available.
# You can check the same using Get-Command -ModuleName sqlserver.
# If this module is not readily available, you can 
# Import-Module sqlserver 

############## Test SQL Connection ##############

$ServerName = 'BPW33Z2'
$DatabaseName = 'UC2018v3'
$userName = 'ADVANCED'
$password = 'password'
# Optional
$outputFile = 'C:\powershell\extractedTextOut.txt' # Explictly put ful path
$append_or_new = 'append' # new or append if you are going to append to file

# Test-SqlConnection $ServerName $DatabaseName $userName $password # $outputFile $append_or_new


############## Test OLEDB Connection ##############

$ServerName = 'BPW33Z2'
$DatabaseName = 'UC2018v3'
$userName = 'ADVANCED'
$password = 'password'
# $provider = 'MSODBCSQL11'
$SQLquery = "select * from ADVANCED.BIF000"
$provider = 'SQLNCLI11'
$SQLquery = "DECLARE @doNothing int"

# getOleDBDrivers

# if there is no errors then driver should be ok
# testOLEDBConnection $ServerName $DatabaseName $userName $password $provider $SQLquery 
