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

            $sourceDir = 'C:\Users\rc91124\Documents\Ron\Tickets\51113\Infinity.Mobile V2 Build 2.19.01\FullInstallationPlay'
            $outputFile = $prevFolder + '\' + $scriptName + '_extractedTextOut.txt' # Explictly put ful path
            $append_or_new = 'append' # new or append if you are going to append to file

$filesToChangeRegExArray =  @('^web.config$')
    # (?i)http(s)?(?-i) --> (?i) case-insensitive mode ON | (?-i) case-insensitive mode OFF | (s)? character "s" is optional
    # :. find patterns like http:, HTTP:, https:, HTTPs: even hTTpS:
$regExDBConnection = '(^.*Source=|^.*Server=)(.*?)(;.*Catalog=|;.*Database=)(.*?)(;.*ID=|;.*uid=)(.*?)(;Password=|;pwd=)(.*?)(;.*|".*)'
$regExURL = '(.*<add key=.*(?i)url(?-i)".*)|(.*target name="eventlog".*)'
$regExPatternCopyLineArray = @($regExDBConnection, $regExURL)

# extractLinesInTextRegEx $sourceDir $filesToChangeRegExArray $outputFile $regExPatternCopyLineArray $append_or_new




#############################  update web.config Connection String  ######################

#   ***************************** Infinity Mobile Dispatch  ***************************

    $sourceDirPath = 'C:\Users\rc91124\Documents\Ron\Tickets\51113\Infinity.Mobile V2 Build 2.19.01\FullInstallationPlay\Dispatch'
    $singleFileToChange = 'web.config'
    $replaceFileName = Join-Path $sourceDirPath $singleFileToChange
    # $replaceFileName = 'c:\test\new.config'
    backUpFile $sourceDirPath $singleFileToChange

    #         ---------------  Connection String1   ----------------
    $regExConStringPattern1 = @('(.*SiteSqlServer.*)(Server=|Source=)(.*?)(;.*Catalog=|;.*Database=)(.*?)(;.*ID=|;.*uid=|;.*User ID=)(.*?)(;Password=|;pwd=)(.*?)(;Provider=|".*?providerName=")(.*?)(;.*|".*)')
    $Server1 = 'BPW33Z2'  ;    $DBName1 = 'MobileV2'  ;  $User1 = 'ADVANCED' ; $Pwd1 = 'password' ; $provider1 = 'System.Data.SqlClient'
    $replaceConString =  @("`$1`$2$Server1`$4$DBName1`$6$User1`$8$Pwd1`$10$provider1`$12")
    replaceTextSingleFileRegExArrayList $sourceDirPath $singleFileToChange $replaceFileName $regExConStringPattern1 $replaceConString  

    #         ---------------  Connection String2 (No Provider)   ----------------
    $regExConStringPattern1 = @('(.*key="SiteSqlServer.*)(Server=|Source=)(.*?)(;.*Catalog=|;.*Database=)(.*?)(;.*ID=|;.*uid=|;.*User ID=)(.*?)(;Password=|;pwd=)(.*?)(;.*|".*)')
    $Server1 = 'BPW33Z2'  ;    $DBName1 = 'MobileV2'  ;  $User1 = 'ADVANCED' ; $Pwd1 = 'password' 
    $replaceConString =  @("`$1`$2$Server1`$4$DBName1`$6$User1`$8$Pwd1`$10")
    replaceTextSingleFileRegExArrayList $sourceDirPath $singleFileToChange $replaceFileName $regExConStringPattern1 $replaceConString  





                    #   ***************************** Infinity Mobile Client  ***************************

                    $sourceDirPath = 'C:\Users\rc91124\Documents\Ron\Tickets\51113\Infinity.Mobile V2 Build 2.19.01\FullInstallationPlay\MobileClient'
                    $singleFileToChange = 'web.config'
                    $replaceFileName = Join-Path $sourceDirPath $singleFileToChange
                    # $replaceFileName = 'c:\test\new.config'
                    backUpFile $sourceDirPath $singleFileToChange

                    #         ---------------  Connection String1   ----------------
                    $regExConStringPattern1 = @('(.*SiteSqlServer.*)(Server=|Source=)(.*?)(;.*Catalog=|;.*Database=)(.*?)(;.*ID=|;.*uid=|;.*User ID=)(.*?)(;Password=|;pwd=)(.*?)(;Provider=|".*?providerName=")(.*?)(;.*|".*)')
                    $Server1 = 'BPW33Z2'  ;    $DBName1 = 'MobileV2Client'  ;  $User1 = 'ADVANCED' ; $Pwd1 = 'password' ; $provider1 = 'System.Data.SqlClient'    
                    $replaceConString =  @("`$1`$2$Server1`$4$DBName1`$6$User1`$8$Pwd1`$10$provider1`$12")
                    replaceTextSingleFileRegExArrayList $sourceDirPath $singleFileToChange $replaceFileName $regExConStringPattern1 $replaceConString  

                    #         ---------------  Connection String2 (No Provider)   ----------------
                    $regExConStringPattern1 = @('(.*key="SiteSqlServer.*)(Server=|Source=)(.*?)(;.*Catalog=|;.*Database=)(.*?)(;.*ID=|;.*uid=|;.*User ID=)(.*?)(;Password=|;pwd=)(.*?)(;.*|".*)')
                    $Server1 = 'BPW33Z2'  ;    $DBName1 = 'MobileV2Client'  ;  $User1 = 'ADVANCED' ; $Pwd1 = 'password' 
                    $replaceConString =  @("`$1`$2$Server1`$4$DBName1`$6$User1`$8$Pwd1`$10")
                    replaceTextSingleFileRegExArrayList $sourceDirPath $singleFileToChange $replaceFileName $regExConStringPattern1 $replaceConString  


                    
    #   ***************************** Infinity Mobile InfinityMobile  ***************************

    $sourceDirPath = 'C:\Users\rc91124\Documents\Ron\Tickets\51113\Infinity.Mobile V2 Build 2.19.01\FullInstallationPlay\MobileWebServices\InfinityMobile'
    $singleFileToChange = 'web.config'
    $replaceFileName = Join-Path $sourceDirPath $singleFileToChange
    # $replaceFileName = 'c:\test\new.config'
    backUpFile $sourceDirPath $singleFileToChange

    #         ---------------  Connection String1   ----------------
    $regExConStringPattern1 = @('(.*SqlConnectString.*)(Server=|Source=)(.*?)(;.*Catalog=|;.*Database=)(.*?)(;.*ID=|;.*uid=|;.*User ID=)(.*?)(;Password=|;pwd=)(.*?)(;Provider=|".*?providerName=")(.*?)(;.*|".*)')
    $Server1 = 'BPW33Z2'  ;    $DBName1 = 'ADVANCED_API2'  ;  $User1 = 'ADVANCED' ; $Pwd1 = 'password' ; $provider1 = 'SQLOLEDB.1'    
    $replaceConString =  @("`$1`$2$Server1`$4$DBName1`$6$User1`$8$Pwd1`$10$provider1`$12")
    replaceTextSingleFileRegExArrayList $sourceDirPath $singleFileToChange $replaceFileName $regExConStringPattern1 $replaceConString  

    #         ---------------  Connection String2 (No Provider)   ----------------
    $regExConStringPattern1 = @('(.*key="MobileConnectString.*)(Server=|Source=)(.*?)(;.*Catalog=|;.*Database=)(.*?)(;.*ID=|;.*uid=|;.*User ID=)(.*?)(;Password=|;pwd=)(.*?)(;.*|".*)')
    $Server1 = 'BPW33Z2'  ;    $DBName1 = 'MobileV2'  ;  $User1 = 'ADVANCED' ; $Pwd1 = 'password' 
    $replaceConString =  @("`$1`$2$Server1`$4$DBName1`$6$User1`$8$Pwd1`$10")
    replaceTextSingleFileRegExArrayList $sourceDirPath $singleFileToChange $replaceFileName $regExConStringPattern1 $replaceConString  

    #         ---------------  Connection String3 (No Provider)   ----------------
    $regExConStringPattern1 = @('(.*key="MobileClientConnectString.*)(Server=|Source=)(.*?)(;.*Catalog=|;.*Database=)(.*?)(;.*ID=|;.*uid=|;.*User ID=)(.*?)(;Password=|;pwd=)(.*?)(;.*|".*)')
    $Server1 = 'BPW33Z2'  ;    $DBName1 = 'MobileV2Client'  ;  $User1 = 'ADVANCED' ; $Pwd1 = 'password' 
    $replaceConString =  @("`$1`$2$Server1`$4$DBName1`$6$User1`$8$Pwd1`$10")
    replaceTextSingleFileRegExArrayList $sourceDirPath $singleFileToChange $replaceFileName $regExConStringPattern1 $replaceConString  



    
                    #   ***************************** Infinity Mobile MobileCIS  ***************************

                    $sourceDirPath = 'C:\Users\rc91124\Documents\Ron\Tickets\51113\Infinity.Mobile V2 Build 2.19.01\FullInstallationPlay\MobileWebServices\MobileCIS'
                    $singleFileToChange = 'web.config'
                    $replaceFileName = Join-Path $sourceDirPath $singleFileToChange
                    # $replaceFileName = 'c:\test\new.config'
                    backUpFile $sourceDirPath $singleFileToChange

                    #         ---------------  Connection String1   ----------------
                    $regExConStringPattern1 = @('(.*SqlConnectString.*)(Server=|Source=)(.*?)(;.*Catalog=|;.*Database=)(.*?)(;.*ID=|;.*uid=|;.*User ID=)(.*?)(;Password=|;pwd=)(.*?)(;Provider=|".*?providerName=")(.*?)(;.*|".*)')
                    $Server1 = 'BPW33Z2'  ;    $DBName1 = 'ADVANCED_API2'  ;  $User1 = 'ADVANCED' ; $Pwd1 = 'password' ; $provider1 = 'SQLOLEDB.1'    
                    $replaceConString =  @("`$1`$2$Server1`$4$DBName1`$6$User1`$8$Pwd1`$10$provider1`$12")
                    replaceTextSingleFileRegExArrayList $sourceDirPath $singleFileToChange $replaceFileName $regExConStringPattern1 $replaceConString  


    #   ***************************** Infinity Mobile MobileDirector  ***************************

    $sourceDirPath = 'C:\Users\rc91124\Documents\Ron\Tickets\51113\Infinity.Mobile V2 Build 2.19.01\FullInstallationPlay\MobileWebServices\MobileDirector'
    $singleFileToChange = 'web.config'
    $replaceFileName = Join-Path $sourceDirPath $singleFileToChange
    # $replaceFileName = 'c:\test\new.config'
    backUpFile $sourceDirPath $singleFileToChange

    #         ---------------  Connection String1   ----------------
    $regExConStringPattern1 = @('(.*MobileCISWSUrl.*value=")(.*?)(".*)','(.*InfinityMobileWSUrl.*value=")(.*?)(".*)')
    $MobileCISWSUrl = 'http://abc.com/MobileCISWSUrl'
    $InfinityMobileWSUrl = 'http://abc.com/InfinityMobileWSUrl'
    $replaceConString =  @("`$1$MobileCISWSUrl`$3", "`$1$InfinityMobileWSUrl`$3")
    replaceTextSingleFileRegExArrayList $sourceDirPath $singleFileToChange $replaceFileName $regExConStringPattern1 $replaceConString  


    

                    #   ***************************** Infinity Mobile PA_Manager  ***************************

                    $sourceDirPath = 'C:\Users\rc91124\Documents\Ron\Tickets\51113\Infinity.Mobile V2 Build 2.19.01\FullInstallationPlay\MobileWebServices\PA_Manager'
                    $singleFileToChange = 'web.config'
                    $replaceFileName = Join-Path $sourceDirPath $singleFileToChange
                    # $replaceFileName = 'c:\test\new.config'
                    backUpFile $sourceDirPath $singleFileToChange

                    #         ---------------  Connection String1   ----------------
                    $regExConStringPattern1 = @('(.*SQLSERVER_DB.*)(Server=|Source=)(.*?)(;.*Catalog=|;.*Database=)(.*?)(;.*ID=|;.*uid=|;.*User ID=)(.*?)(;Password=|;pwd=)(.*?)(;Provider=|".*?providerName=")(.*?)(;.*|".*)')
                    $Server1 = 'BPW33Z2'  ;    $DBName1 = 'ADVANCED_API2'  ;  $User1 = 'ADVANCED' ; $Pwd1 = 'password' ; $provider1 = 'System.Data.SqlClient'    
                    $replaceConString =  @("`$1`$2$Server1`$4$DBName1`$6$User1`$8$Pwd1`$10$provider1`$12")
                    replaceTextSingleFileRegExArrayList $sourceDirPath $singleFileToChange $replaceFileName $regExConStringPattern1 $replaceConString  

                    
                    #         ---------------  Connection String2   ----------------
                    $regExConStringPattern1 = @('(.*LocalSqlServer.*)(Server=|Source=)(.*?)(;.*Catalog=|;.*Database=)(.*?)(;.*ID=|;.*uid=|;.*User ID=)(.*?)(;Password=|;pwd=)(.*?)(;Provider=|".*?providerName=")(.*?)(;.*|".*)')
                    $Server1 = 'BPW33Z2'  ;    $DBName1 = 'PAMANAGER_USERS'  ;  $User1 = 'ADVANCED' ; $Pwd1 = 'password' ; $provider1 = 'System.Data.SqlClient'    
                    $replaceConString =  @("`$1`$2$Server1`$4$DBName1`$6$User1`$8$Pwd1`$10$provider1`$12")
                    replaceTextSingleFileRegExArrayList $sourceDirPath $singleFileToChange $replaceFileName $regExConStringPattern1 $replaceConString  

Write-Host 'Config files updates'                    