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
$purgeLogDateOlderThan = '01/01/2020' #MM/DD/YYYY


# Static Inputs - leave values as is needed for patch
$fileToChange = 'web.config'
        # full folder path where the Error pages are located
        $errorsFolderDir = Join-Path $PSScriptRoot 'ErrorPages'
$removeFilesArray = @("ErrorPage.aspx", "ErrorPage.aspx.cs")
$removeFolderInstall = Join-Path $sourceDir '\Install'
$removeFolderClientAPITests = Join-Path $sourceDir '\js\ClientAPITests'
$removeFolderRadEditorProvider = Join-Path $sourceDir '\DesktopModules\Admin\RadEditorProvider'
$removeFolderTelerik = Join-Path $sourceDir '\Providers\HtmlEditorProviders\Telerik'


# Variables the combine other variables
$NewOutputFile = Join-Path $sourceDir $fileToChange
$targetErrorPages = Join-Path $sourceDir '\ErrorPages'
$logDirectory = Join-Path $sourceDir '\Portals\_default\Logs'
$portalsDefaultDir = Join-Path $sourceDir '\Portals\_default'


$regExPatternArray = @(".*<customErrors mode=.* \/>", ".*<\/handlers>", ".*<\/system.webServer>")
    # get text from file
    $errorsText = Get-Content $PSScriptRoot'\errorPages.txt' -Raw
    $HandlersText = Get-Content $PSScriptRoot'\handlers.txt' -Raw
    $systemWebServerText = Get-Content $PSScriptRoot'\systemWebServer.txt' -Raw
$replaceStringArray = @($errorsText, $HandlersText, $systemWebServerText)

# N.B. since we are using regEx, need to put an excape sequence for '*'  --> '\*'




$regExPatternRemoveLineArray = @('<add value="Default.htm" />','<add value="index.htm" />','<add value="index.html" />','<add value="iisstart.htm" />',
 '<add path="Telerik.Web.UI.DialogHandler.aspx" type="Telerik.Web.UI.DialogHandler" verb="\*" validate="false" />',
 '<add path="Telerik.Web.UI.DialogHandler.ashx" type="Telerik.Web.UI.DialogHandler" verb="\*" validate="false" />',
 '<add name="Telerik_Web_UI_DialogHandler_aspx" path="Telerik.Web.UI.DialogHandler.aspx" type="Telerik.Web.UI.DialogHandler" verb="\*" preCondition="integratedMode" />',
 '<add name="Telerik_Web_UI_DialogHandler_aspx" path="Telerik.Web.UI.DialogHandler.ashx" type="Telerik.Web.UI.DialogHandler" verb="\*" preCondition="integratedMode" />'
)




# ********************************* Main script to run all the functions
function runMainScript {

    # backup Folder
    # N.B. This will also remove empty folders... 
    # if files exists, won't overwrite
    copyFolderNoOverwrite $sourceDir $targetDir

    # backup webConfig file and put timestamp on filename
    backUpFile $sourceDir $fileToChange

    # Delete Specific Files
    deleteFiles $sourceDir $removeFilesArray

    # remove specific Folders (recursive) from root folder
    removeFolder $removeFolderInstall

    # remove specific Folders (recursive) from root folder
    removeFolder $removeFolderClientAPITests

    # remove specific Folders (recursive) from root folder
    removeFolder $removeFolderRadEditorProvider

    # remove specific Folders (recursive) from root folder
    removeFolder $removeFolderTelerik

    # copy Errors folder to root
    copyFolderNoOverwrite $errorsFolderDir $targetErrorPages

    # regex with pattern that has anything and ends wtih .log.resources' in folder \Portals\_default\Logs
    deleteFilesOlderThanDate $logDirectory $purgeLogDateOlderThan '.*\.log\.resources' #MM/DD/YYYY

    # Delete files using regEx...^\d+\.\d+\.\d+\.txt
    # ^ means starts with... | \d+ means a digit that has 1 or more characters | \. excape charcter needed for "." | txt has after the numbers txt
    deleteFilesRegex $portalsDefaultDir '^\d+\.\d+\.\d+\.txt'  # ie. files that look like this 04.06.00.txt

    # update Config File and replaces $regExPattern with $replaceString 
    # N.B $regExPattern and $replaceString can be an array; however they have to have the same amount of elemtns
    # N.B if $NewOutputFile is different than $fileToChange then it will create a new file
    replaceTextSingleFileRegExArrayList $sourceDir $fileToChange $NewOutputFile $regExPatternArray $replaceStringArray

    # update Config File and will remove lines matching $regExPatternRemoveLine arrays 
    # N.B if $NewOutputFile is different than $fileToChange then it will create a new file
    removeLinesInTextRegEx $sourceDir $fileToChange $fileToChange $regExPatternRemoveLineArray 


}





runMainScript 

