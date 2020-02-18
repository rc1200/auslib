
# PowerShell 3+ $PSScriptRoot is an automatic variable set to the current file's/module's directory

write-host 'current directory is ' $PSScriptRoot
$prevFolder = Split-Path -Path $PSScriptRoot -Parent
Write-Host 'Previous directory is ' $prevFolder
. "$prevFolder\AUSLib.ps1"

Get-DotNetFrameworkVersion
$scriptName =$MyInvocation.MyCommand.Name 



# dot-source library script
# notice that you need to have a space 
# between the dot and the path of the script



####################################### extract text  #####################################

            $sourceDir = 'C:\CIS\test2\WebServices_03.03.03.02'
            $outputFile = $PSScriptRoot + '\extractedText_' + ($sourceDir |split-path -leaf) + '.txt' # Explictly put ful path
            $append_or_new = 'append' # new or append if you are going to append to file

$filesToChangeRegExArray =  @('^web.config$')
    # (?i)http(s)?(?-i) --> (?i) case-insensitive mode ON | (?-i) case-insensitive mode OFF | (s)? character "s" is optional
    # :. find patterns like http:, HTTP:, https:, HTTPs: even hTTpS:
$regExDBConnection = '(^.*Source=|^.*Server=)(.*?)(;.*Catalog=|;.*Database=)(.*?)(;.*ID=|;.*uid=)(.*?)(;Password=|;pwd=)(.*?)(;.*|".*)'
$regExURL = '(.*<add key=.*(?i)url(?-i)".*)|(.*target name="eventlog".*)'
$regExInvoiceCloud = '.*(<add key=")(ICIntegratorGUID|ICBillerGUID|ICWSKey).*'
$regExRest = '.*(<add key=")(RestApiBaseUrl|CisUserName|CisPassword).*'
$regExMachineKey = '.*<machineKey.*'

$regExPatternCopyLineArray = @($regExDBConnection, $regExURL, $regExInvoiceCloud, $regExRest, $regExMachineKey)

extractLinesInTextRegEx $sourceDir $filesToChangeRegExArray $outputFile $regExPatternCopyLineArray $append_or_new


