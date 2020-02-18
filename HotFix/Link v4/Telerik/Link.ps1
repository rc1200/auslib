write-host 'current directory is ' $PSScriptRoot

$intNumFoldersDeepFromLibFile = 3
$prevFolder = $PSScriptRoot
for ($i = 0; $i -lt $intNumFoldersDeepFromLibFile; $i++) { $prevFolder = Split-Path -Path $prevFolder -Parent }

. "$prevFolder\AUSLib.ps1"
Write-Host 'AUSLib.ps1 directory is ' $prevFolder



<#

    script to copy/delete files/folders to fix the Telerik vulnerability

#>




# Inputs required


Get-Host | Select-Object Version

$date = Get-Date -format "yyyy-MM-dd"
$sourceDir = 'C:\inetpub\wwwroot\v3\LinkV3Play'
# Target directory backup folder N.B. won't overrite if file exists
$targetDir = 'C:\CIS\test2\LinkV3Play' + "_"+ $date


# Static Inputs - leave values as is needed for patch
$fileToChange = 'web.config'
        # full folder path where the Error pages are located
        $errorsFolderDir = Join-Path $PSScriptRoot 'ErrorPages'


# Variables the combine other variables
$NewOutputFile = Join-Path $sourceDir $fileToChange
$targetErrorPages = Join-Path $sourceDir '\ErrorPages'


$regExPatternArray = @(".*<customErrors mode=.* \/>", ".*<\/handlers>", ".*<\/system.webServer>")
    # get text from file
    $errorsText = Get-Content $PSScriptRoot'\errorPages.txt' -Raw
    $HandlersText = Get-Content $PSScriptRoot'\handlers.txt' -Raw
    $systemWebServerText = Get-Content $PSScriptRoot'\systemWebServer.txt' -Raw
$replaceStringArray = @($errorsText, $HandlersText, $systemWebServerText)



# ********************************* Main script to run all the functions
function runMainScript {

    # backup Folder
    # N.B. This will also remove empty folders... 
    # if files exists, won't overwrite
    copyFolderNoOverwrite $sourceDir $targetDir

    # backup webConfig file and put timestamp on filename
    backUpFile $sourceDir $fileToChange

    # copy Errors folder to root
    copyFolderNoOverwrite $errorsFolderDir $targetErrorPages

    # update Config File and replaces $regExPattern with $replaceString 
    # N.B $regExPattern and $replaceString can be an array; however they have to have the same amount of elemtns
    # N.B if $NewOutputFile is different than $fileToChange then it will create a new file
    replaceTextSingleFileRegExArrayList $sourceDir $fileToChange $NewOutputFile $regExPatternArray $replaceStringArray

}





runMainScript 

