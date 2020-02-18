
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

            $sourceDir = 'C:\Users\rc91124\Documents\Ron\Tickets\50132\Infinity.Link V3 Build 02.19\Infinity.Link V3 Build 02.19\Site'
            $outputFile = $prevFolder + '\' + $scriptName + '_extractedTextOut.txt' # Explictly put ful path
            $append_or_new = 'append' # new or append if you are going to append to file

$filesToChangeRegExArray =  @('^web.config$')
    # (?i)http(s)?(?-i) --> (?i) case-insensitive mode ON | (?-i) case-insensitive mode OFF | (s)? character "s" is optional
    # :. find patterns like http:, HTTP:, https:, HTTPs: even hTTpS:
$regExDBConnection = '(^.*Source=|^.*Server=)(.*?)(;.*Catalog=|;.*Database=)(.*?)(;.*ID=|;.*uid=)(.*?)(;Password=|;pwd=)(.*?)(;.*|".*)'
$regExURL = '(.*<add key=.*(?i)url(?-i)".*)|(.*target name="eventlog".*)'
$regExPatternCopyLineArray = @($regExDBConnection, $regExURL)

# extractLinesInTextRegEx $sourceDir $filesToChangeRegExArray $outputFile $regExPatternCopyLineArray $append_or_new




#############################  update web.config Files(s) ######################
# updates sourceDirPath, and if exists... update the Director, CIS and PG web config as well

        $sourceDirPath = 'C:\Users\rc91124\Documents\Ron\Tickets\50132\Infinity.Link V3 Build 02.19\Infinity.Link V3 Build 02.19\Site'
        $singleFileToChange = 'web.config'

# variables for DB Connection String
        $Server = 'BPW33Z2'
        $DBName = 'LinkV3'
        $User = 'ADVANCED'
        $Pwd = 'password'
        # Optional
        $provider = 'SQLNCLI10'  # -- Double check the drivers default is SQLOLEDB.1
        $PortalURL = 'http://linkv3.local/' # URL for Link
        $paymentEngineUrl = 'http://pe3.local' # put WebService/Payment engine URL
        $AWS_DIRECTOR_Alias = 'AWS_DIRECTOR'
                    $WebserviceUrl =  $paymentEngineUrl + '/' + $AWS_DIRECTOR_Alias + '/Director.asmx'   

    

<#
updateStringsInFiles $sourceDirPath $singleFileToChange $Server $DBName $User $Pwd `
                        -provider $provider `
                        -PortalURL $PortalURL `
                        -WebserviceUrl $WebserviceUrl

#>










