
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

        $sourceDirPath = 'C:\CIS\test2\WebServices_03.03.03.02'
        $singleFileToChange = 'web.config'

# variables for DB Connection String
        $Server = 'BPW33Z2'
        $DBName = 'LinkV3'
        $User = 'ADVANCED'
        $Pwd = 'password'
        # Optional
        $DBNameAdvancedQueue = 'PaymentQueue'
        $provider = 'SQLOLEDB.1' # default SQLOLEDB.1
        $paymentEngineUrl = 'http://pe3.local' # put WebService/Payment engine URL
                $AWS_CIS_Alias = 'AWS_CIS'
                $CISInfinityWSUrl = $paymentEngineUrl + '/' + $AWS_CIS_Alias + '/CISInfinity.asmx'
                $AWS_PG_Alias = 'AWS_PG'
                $PaymentGatewayWSUrl = $paymentEngineUrl + '/' + $AWS_PG_Alias + '/AdvancedPaymentGateway.asmx'

                
<#                  
updateStringsInFiles $sourceDirPath $singleFileToChange $Server $DBName $User $Pwd `
                        -DBNameAdvancedQueue $DBNameAdvancedQueue `
                        -provider $provider `
                        -CISInfinityWSUrl $CISInfinityWSUrl `
                        -PaymentGatewayWSUrl $PaymentGatewayWSUrl `

#>



#############################  update web.config Connection String for AdvancedQueueConnectString if different ######################

$sourceDirPath = 'C:\CIS\test2\WebServices_03.03.03.02\AWS_PG'
$singleFileToChange = 'web.config'
$replaceFileName = Join-Path $sourceDirPath $singleFileToChange
backUpFile $sourceDirPath $singleFileToChange

#         ---------------  Connection String1   ----------------
$regExConStringPattern1 = @('(.*AdvancedQueueConnectString.*)(Server=|Source=)(.*?)(;.*Catalog=|;.*Database=)(.*?)(;.*ID=|;.*uid=|;.*User ID=)(.*?)(;Password=|;pwd=)(.*?)(;Provider=|".*?providerName=")(.*?)(;.*|".*)')
$Server1 = 'XYZSrv'  ;    $DBName1 = 'AdvanceQUEUE'  ;  $User1 = 'User1' ; $Pwd1 = 'password1' ; $provider1 = $provider 
$replaceConString =  @("`$1`$2$Server1`$4$DBName1`$6$User1`$8$Pwd1`$10$provider1`$12")
# replaceTextSingleFileRegExArrayList $sourceDirPath $singleFileToChange $replaceFileName $regExConStringPattern1 $replaceConString  
