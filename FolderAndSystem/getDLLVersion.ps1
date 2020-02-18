


write-host 'current directory is ' $PSScriptRoot
$prevFolder = Split-Path -Path $PSScriptRoot -Parent
Write-Host 'Previous directory is ' $prevFolder
. "$prevFolder\AUSLib.ps1"

Get-DotNetFrameworkVersion
# dot-source library script
# notice that you need to have a space 
# between the dot and the path of the script



####################################### extract text  #####################################

$dirSourceRecurse = 'C:\inetpub\wwwroot\v3\linkv3x'
$outputFile = $PSScriptRoot + '\extractedText_' + ($dirSourceRecurse |split-path -leaf) + '.txt' # Explictly put ful path
$RegExFilePatternArray = @('.*(?i)eCARe(?-i).*dll')
$FileVersion_Path_Name_sort = 'FileVersion' # valid inputs are => FileVersion or Path or Name
$append_or_new =  'new'

GetDllVersionValue $dirSourceRecurse $RegExFilePatternArray $outputFile $FileVersion_Path_Name_sort $append_or_new


