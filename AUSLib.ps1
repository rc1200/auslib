<#

    # dot-source library script
    # notice that you need to have a space 
    # between the dot and the path of the script

    in the worker scripts ensure you put the path on to to include and should be in the same folder
    . "$PSScriptRoot\AUSLib.ps1"

#>


function Get-DotNetFrameworkVersion {

    <#
        Script Name	: Get-NetFrameworkVersion.ps1
        Description	: This script reports the various .NET Framework versions installed on the local or a remote computer.
        Author		: Martin Schvartzman
        Reference   : https://msdn.microsoft.com/en-us/library/hh925568
    #>
    param(
        [string]$ComputerName = $env:COMPUTERNAME
    )

    $dotNetRegistry  = 'SOFTWARE\Microsoft\NET Framework Setup\NDP'
    $dotNet4Registry = 'SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full'
    $dotNet4Builds = @{
        '30319'  = @{ Version = [System.Version]'4.0'                                                     }
        '378389' = @{ Version = [System.Version]'4.5'                                                     }
        '378675' = @{ Version = [System.Version]'4.5.1'   ; Comment = '(8.1/2012R2)'                      }
        '378758' = @{ Version = [System.Version]'4.5.1'   ; Comment = '(8/7 SP1/Vista SP2)'               }
        '379893' = @{ Version = [System.Version]'4.5.2'                                                   }
        '380042' = @{ Version = [System.Version]'4.5'     ; Comment = 'and later with KB3168275 rollup'   }
        '393295' = @{ Version = [System.Version]'4.6'     ; Comment = '(Windows 10)'                      }
        '393297' = @{ Version = [System.Version]'4.6'     ; Comment = '(NON Windows 10)'                  }
        '394254' = @{ Version = [System.Version]'4.6.1'   ; Comment = '(Windows 10)'                      }
        '394271' = @{ Version = [System.Version]'4.6.1'   ; Comment = '(NON Windows 10)'                  }
        '394802' = @{ Version = [System.Version]'4.6.2'   ; Comment = '(Windows 10 Anniversary Update)'   }
        '394806' = @{ Version = [System.Version]'4.6.2'   ; Comment = '(NON Windows 10)'                  }
        '460798' = @{ Version = [System.Version]'4.7'     ; Comment = '(Windows 10 Creators Update)'      }
        '460805' = @{ Version = [System.Version]'4.7'     ; Comment = '(NON Windows 10)'                  }
        '461308' = @{ Version = [System.Version]'4.7.1'   ; Comment = '(Windows 10 Fall Creators Update)' }
        '461310' = @{ Version = [System.Version]'4.7.1'   ; Comment = '(NON Windows 10)'                  }
        '461808' = @{ Version = [System.Version]'4.7.2'   ;                                               }
        '461814' = @{ Version = [System.Version]'4.7.2'   ;                                               }
        '528040' = @{ Version = [System.Version]'4.8'     ;                                               }
    }

    foreach($computer in $ComputerName)
    {
        if($regKey = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey('LocalMachine', $computer))
        {
            if ($netRegKey = $regKey.OpenSubKey("$dotNetRegistry"))
            {
                foreach ($versionKeyName in $netRegKey.GetSubKeyNames())
                {
                    if ($versionKeyName -match '^v[123]') {
                        $versionKey = $netRegKey.OpenSubKey($versionKeyName)
                        $version = [System.Version]($versionKey.GetValue('Version', ''))
                        New-Object -TypeName PSObject -Property ([ordered]@{
                                ComputerName = $computer
                                Build = $version.Build
                                Version = $version
                                Comment = ''
                        })
                    }
                }
            }

            if ($net4RegKey = $regKey.OpenSubKey("$dotNet4Registry"))
            {
                if(-not ($net4Release = $net4RegKey.GetValue('Release')))
                {
                    $net4Release = 30319
                }
                New-Object -TypeName PSObject -Property ([ordered]@{
                        ComputerName = $Computer
                        Build = $net4Release
                        Version = $dotNet4Builds["$net4Release"].Version
                        Comment = $dotNet4Builds["$net4Release"].Comment
                })
            }
        }
    }
}


function copyFolderNoOverwrite ($fsourceDir, $ftargetDir) {

    Write-Output " *******************  copying folders Please Wait ********************" 

    $sourceDir = $fsourceDir
    $targetDir = $ftargetDir


    # create target folder if it doesn't exists
  
    If(!(test-path $ftargetDir))
    {
          Write-Output " Folder doesn't exists.... creating folder " 
          New-Item -ItemType Directory -Force -Path $targetDir
    }
  

    Get-ChildItem $sourceDir -Recurse -Force | % {
       $dest = $targetDir + $_.FullName.SubString($sourceDir.Length)
       If(!(test-path $dest)) { Copy-Item $_.FullName -Destination $dest -Force }
    }

 <#
       If (!($dest.Contains('.')) -and !(Test-Path $dest))
       {
            mkdir $dest
       }

       Copy-Item $_.FullName -Destination $dest -Force
    }#>

    # Remove Empty Folders after copy

    <#

    $TargetFolder = $ftargetDir

    $Deleted = @()
    $Folders = @()
    ForEach ($Folder in (Get-ChildItem -Path $TargetFolder -Recurse | Where { $_.PSisContainer }))
    {	$Folders += New-Object PSObject -Property @{
		    Object = $Folder
		    Depth = ($Folder.FullName.Split("\")).Count
	    }
    }
    $Folders = $Folders | Sort Depth -Descending
    ForEach ($Folder in $Folders)
    {	If ($Folder.Object.GetFileSystemInfos().Count -eq 0)
	    {	$Deleted += New-Object PSObject -Property @{
			    Folder = $Folder.Object.FullName
			    Deleted = (Get-Date -Format "hh:mm:ss tt")
			    Created = $Folder.Object.CreationTime
			    'Last Modified' = $Folder.Object.LastWriteTime
			    Owner = (Get-Acl $Folder.Object.FullName).Owner
		    }
		    Remove-Item -Path $Folder.Object.FullName -Force
	    }
    }
    #>
    Write-Output " *******************  copy folder Done!  ********************" $fsourceDir $ftargetDir 
}


function copyFolderYesOverwriteKeepLaterDateFileOnly {

    <#
        takes existingFolder and FolderToCopy and will only copy the files where FolderToCopy has
        Greater Date then Source.
        If file doens't exists in Source, then will write that file to source
        As well if you define deltaFolder (optional), it will copy the files that are newer so it is
        simple to see all the newer contents
    #>

    param(
        [Parameter(Mandatory)]
        [string]$existingFolder,   
        [Parameter(Mandatory)]
        [string]$FolderToCopy,   
        [Parameter(Mandatory=$false)]
        [string]$deltaFolder
    )


    Write-Output " *******************  copying folders Please Wait ********************" 

    $FolderToCopyObject = Get-ChildItem -Path $FolderToCopy -Recurse | Where-Object { ! $_.PSIsContainer }
    $existingFolderFiles = Get-ChildItem -Path $existingFolder -Recurse | Where-Object { ! $_.PSIsContainer } 

    foreach ($sourceFile in $FolderToCopyObject) {
        
        $subStrFolderToCopyObject = $sourceFile.FullName.SubString($FolderToCopy.Length)
        $baseSource = Split-Path -Path $subStrFolderToCopyObject 

        if ($baseSource -eq '\') {
            $testFileifExists = Join-Path $existingFolder $sourceFile.Name
        } else {
            $testFileifExists = $existingFolder + $baseSource + '\' +$sourceFile.Name
        }

        # to handle if not in destination folder then copy file and match folder structure
        If(!(test-path $testFileifExists)) {
            Write-Host 'file NOT!!!! exists in source' $testFileifExists
            $copyFolder = $existingFolder + $subStrFolderToCopyObject
                If(!(test-path  (Split-Path $copyFolder))) {
                    (new-item -type directory -force (Split-Path $copyFolder))
                }
            Copy-Item $sourceFile.FullName -Destination $copyFolder -Force

            if( $deltaFolder ) {
                $newDeltaFolder = $deltaFolder + $subStrFolderToCopyObject
                If(!(test-path  (Split-Path $newDeltaFolder))) {
                    (new-item -type directory -force (Split-Path $newDeltaFolder))
                }
                Copy-Item $sourceFile.FullName -Destination $newDeltaFolder -Force
            }
        }


        foreach ($existingFile in $existingFolderFiles) {
            $subStrExistingFolder = $existingFile.FullName.SubString($existingFolder.Length)
            
            # check if source file matches the destination (matching on similar folder structure -minus root path)
            # and if the source file has greater date then will overwrite
            if (($subStrExistingFolder -eq $subStrFolderToCopyObject) -and ($existingFile.PSChildName -eq $sourceFile.PSChildName) -and ($sourceFile.LastWriteTime.Ticks -gt $existingFile.LastWriteTime.Ticks )) {
                $copyFolder = $existingFolder + $subStrFolderToCopyObject
                Copy-Item $sourceFile.FullName -Destination $copyFolder -Force
                
                if( $deltaFolder ) {
                    $newDeltaFolder = $deltaFolder + $subStrFolderToCopyObject
                    If(!(test-path  (Split-Path $newDeltaFolder))) {
                        (new-item -type directory -force (Split-Path $newDeltaFolder))
                    }
                    Copy-Item $sourceFile.FullName -Destination $newDeltaFolder -Force
                }
            }
        }

    }
    Write-Output " *******************  copy folder Done!  ********************" $fsourceDir $ftargetDir 
}

function deleteFiles($sourceDir, $removeFilesArray) {

    # will get child items from $sourceDir (ensure it is not a filder) and remove the files defined in the 
    # $removeFilesArray which can be an ARRAY ie. $removeFilesArray = @("ErrorPage.aspx", "ErrorPage.aspx.cs")
    Get-ChildItem $sourceDir | where { ! $_.PSIsContainer } | Where-Object { $_.Name -in $removeFilesArray }  | Remove-Item  #-WhatIf
    Write-Output "********************* deleted file(s)  ***********************" $removeFilesArray
}


function removeFolder ($removeFolder) {

    # remove a folder and its subfolders
    # deletefolder
    # ie. removeFolder 'C:\test' -- Not an Array
    Remove-Item $removeFolder -Recurse -ErrorAction Ignore
    Write-Output "********************* deleted folders ***********************" $removeFolder    
}


function removeEmptyFoldersInDriectory ($FolderToDeleteEmptyFolders) {

    Write-Output "********************* removing empty folders in  ***********************" $FolderToDeleteEmptyFolders 

    $TargetFolder = $FolderToDeleteEmptyFolders

    $Deleted = @()
    $Folders = @()
    ForEach ($Folder in (Get-ChildItem -Path $TargetFolder -Recurse | Where { $_.PSisContainer }))
    {	$Folders += New-Object PSObject -Property @{
		    Object = $Folder
		    Depth = ($Folder.FullName.Split("\")).Count
	    }
    }
    $Folders = $Folders | Sort Depth -Descending
    ForEach ($Folder in $Folders)
    {	If ($Folder.Object.GetFileSystemInfos().Count -eq 0)
	    {	$Deleted += New-Object PSObject -Property @{
			    Folder = $Folder.Object.FullName
			    Deleted = (Get-Date -Format "hh:mm:ss tt")
			    Created = $Folder.Object.CreationTime
			    'Last Modified' = $Folder.Object.LastWriteTime
			    Owner = (Get-Acl $Folder.Object.FullName).Owner
		    }
		    Remove-Item -Path $Folder.Object.FullName -Force
	    }
    }

}

function backUpFile ($sourceDir, $fileToBackUp){

    # creates a copy of the file in the SAME directory and adds a timestamp
    # ie. backUpFile 'C:\test' 'web.config'  --> web.config.bak.2020-01-23
    Set-Location $sourceDir
    $date = Get-Date -format "yyyy-MM-dd"
    $newFileName = -join($fileToBackUp,".bak.",$date)
    $fullFilePath = Join-Path $sourceDir $fileToBackUp
    if(Test-Path -path $fullFilePath) {
        Copy-Item $fileToBackUp $newFileName -Force #-WhatIf
        Write-Output "********************* backed up config file ***********************" $newBackupFile $newFileName  'in folder' $sourceDir    
    }
}


function deleteFilesOlderThanDate ($sourceDir, $deleteDate, $regexPatternArray){

    # example: deleteFilesOlderThanDate 'c:\test' '01/22/2020' '.*\.log\.resources'   #  #MM/DD/YYYY
    # deleteFilesOlderThanDate Path Date_LessThan_toDelete_MM/DD/YYYY RegEXPattern
    $limit = [datetime]$deleteDate
    Write-Output 'limit is'$limit 'delete is '$deleteDate
    foreach($pattern in $regexPatternArray){
        Get-ChildItem -Path $sourceDir -Force | Where-Object { !$_.PSIsContainer -and $_.LastWriteTime -lt $limit -and $_.Name -match $pattern } | Remove-Item -Force #-WhatIf 
    }

    Write-Output "********************* deleteFilesOlderThanDate ***********************" $limit 'in folder' $sourceDir 
}


function deleteFilesRegex($sourceDir, $regexPatternArray) {

    # example: deleteFilesRegex 'c:\test' '^\d+\.\d+\.\d+\.txt'
    # delete multiple files in single folder (no recurse) that matches RegEx Pattern
    foreach($pattern in $regexPatternArray){
        Get-ChildItem $sourceDir -ErrorAction Ignore | where { ! $_.PSIsContainer } | Where-Object { $_.Name -match  $pattern } | Remove-Item #-WhatIf        
    }

    Write-Host "********************* deleted file(s) via RegEX  ***********************" $regexPattern $sourceDir
}


function replaceTextSingleFileRegExArrayList ($sourceDir, $singleFileToChange, $NewOutputFileFullPath, $regExPatternArray, $replaceStringArray) {

    # Creates a new file and loops through all the matching regEx pattern and replace in Single File
    # doesn't recurse Folder
    Write-Host "********************* replace text(s) in File ***********************" $sourceDir $singleFileToChange

    $replacePath = Join-Path $sourceDir $singleFileToChange

    # ensure file exists
    if(Test-Path -path $replacePath){
        $temp = Get-Content -path $replacePath

        $i = 0
        Foreach ($pattern in $regExPatternArray) {
             $temp = $temp  | % { $_ -Replace $pattern, $replaceStringArray[$i] } 
             $i += 1
        }

        $temp |  Out-File -Encoding "UTF8" $NewOutputFileFullPath
    }

}


function removeLinesInTextRegEx ($sourceDir, $singleFileToChange, $NewOutputFileName, $regExPatternRemoveLineArray) {
    $replacePath = Join-Path $sourceDir $singleFileToChange
    $temp = Get-Content -Path $replacePath 
    $NewOutputFileFull = Join-Path $sourceDir $NewOutputFileName
    if (Test-Path $NewOutputFileFull) {Remove-Item $NewOutputFileFull}
    if (!(Test-Path $NewOutputFileFull)) {New-Item $NewOutputFileFull}
 

    Foreach ($rPattern_x in $regExPatternRemoveLineArray){
    $newfile= @()
        Foreach ($line in $temp) {
            if ($line -notmatch $rPattern_x) {
             #$rPattern_x
             $newfile += $line #+  "`r" #| Out-File $NewOutputFileFull -Append
             #$line | Out-File $NewOutputFileFull -Append
             #$temp += $line
            }
        }
        $temp = $newfile    
    }

    $newfile | Out-File $NewOutputFileFull
}


function GetDllVersionValue($dirSourceRecurse, $RegExFilePatternArray, $outputFile, $FileVersion_Path_Name_sort, $append_or_new)
{
    # scan all files in $dirSourceRecurse (-recurse) that match $RegExFilePatternArray and get .DLL version and output to file
    $name = @{Name="Name";Expression= {split-path -leaf $_.FileName}}
    $path = @{Name="Path";Expression= {split-path $_.FileName}}

    $result = dir -recurse -path $dirSourceRecurse | % { 
        foreach($pattern in $RegExFilePatternArray){
            if ($_.Name -match $pattern) {$_.VersionInfo}
        }        
    } | select FileVersion, $name, $path | Sort-Object -Property $FileVersion_Path_Name_sort

    if ($append_or_new -ieq 'new'){ $result | Out-file $outputFile -width 400 }
    ElseIf  ($append_or_new -ieq 'append'){ $result | Out-file $outputFile -Append -width 400 }

#  we should stritp leading zero to make consistent but watch out for 2.3.0.19247 ... legit 0
    
    # $versionsDll = $result.FileVersion
    # $mm = $versionsDll | Measure-Object -Minimum -Maximum
    # Write-host 'Min value is: ' $mm.Minimum  ' Max value is: ' $mm.Maximum 
}


function extractLinesInTextRegEx ($sourceDirRecurse, $filesToChangeRegExArray, $outputFile, $regExPatternCopyLineArray, $append_or_new) {
    <#
        Traverse through the $sourceDirRecurse and searches for specifc text in the files that match  $filesToChangeRegExArray
        In Each file, looks at each line to see if there is a matching $regExPatternCopyLineArray
        if match, store in $newfile then after going through all files, outputs results to $outputFile
    #>

    $newfile= @() # Stores the lines that match which will then be outputed to file
    
    # stores results of all files/folders in $sourceDirRecurse (-recurse) that match $filesToChangeRegExArray to  $fileToChange
    
    write-host 'gathering files... please wait'
    $fileToChange = dir -recurse -path $sourceDirRecurse | % { 
        Foreach ($filePattern in $filesToChangeRegExArray) {
            if ($_.Name -match $filePattern) {$_.FullName}
        }
    }

    write-host 'checking files for match... please wait'
    # Go through all files stored in  $fileToChange and looks for lines that match pattern $regExPatternCopyLineArray and store in $newfile
    foreach($file in $fileToChange){

        $newfile += $file + '  Gathering data for file *****************************************'
        $temp = Get-Content -Path $file 

        Foreach ($rPattern_x in $regExPatternCopyLineArray){
            Foreach ($line in $temp) {
                if ($line -match $rPattern_x) {
                $newfile += $line 
                }
            }
        }
    }

    # output results of matching lines to new file or append

    if ($append_or_new -ieq 'new'){ $newfile | Out-file $outputFile -width 400}
    ElseIf  ($append_or_new -ieq 'append'){ $newfile | Out-file $outputFile -Append -width 400}

}


function Test-SqlConnection {
    param(
        [Parameter(Mandatory)]
        [string]$ServerName,

        [Parameter(Mandatory)]
        [string]$DatabaseName,

        [Parameter(Mandatory)]
        [string]$userName,

        [Parameter(Mandatory)]
        [string]$password,
    
        [Parameter(Mandatory=$false)]
        [string]$outputFile,

        [Parameter(Mandatory=$false)]
        [string]$append_or_new

    )

    $ErrorActionPreference = 'Stop'

    try {
        # $userName = $Credential.UserName
        # $password = $Credential.GetNetworkCredential().Password
        $connectionString = 'Data Source={0};database={1};User ID={2};Password={3}' -f $ServerName,$DatabaseName,$userName,$password
        $sqlConnection = New-Object System.Data.SqlClient.SqlConnection $ConnectionString
        $sqlConnection.Open()
        ## This will run if the Open() method does not throw an exception
        $result = 'Data Source={0};database={1};User ID={2};Password={3}  {4}' -f $ServerName,$DatabaseName,$userName,$password,'  ^^^^^  PASS  ^^^^^'
        write-host $result

    } catch {
        $result = 'Data Source={0};database={1};User ID={2};Password={3}  {4}' -f $ServerName,$DatabaseName,$userName,$password,'!!!!!  FAIL  !!!!!!'
        write-host $result

    } finally {
        ## Close the connection when we're done
        $sqlConnection.Close()
        write-host 'connection closed'

        if ($append_or_new -ieq 'new'){ $result | Out-file $outputFile }
        ElseIf  ($append_or_new -ieq 'append'){ $result | Out-file $outputFile -Append }

    }
}




function testOLEDBConnection ($ServerName, $DatabaseName, $userName, $password, $provider, $SQLquery ) {

    ##############################################################################
    ##
    ## Test_Connection_String.ps1
    ##
    ## This script tries to establish a DB connection as instructed by a given
    ## Connection String, then execute the given SQL query and save the result to
    ## out.csv file
    ##
    ##############################################################################
    ## Please provide Connection String
    # $ConnectionString = "Provider=SQLOLEDB.1;Persist Security Info=False;User ID=ADVANCED;password=PATSINCOMMAND;Data Source=BPW33Z2"
    # $ConnectionString = "Data Source=BPW33Z2;Initial Catalog=UC2018v3;User ID=ADVANCED;Password=PATSINCOMMAND; provider=abc"
    $ConnectionString = "Data Source={0};Initial Catalog={1};User ID={2};Password={3}; provider={4}" -f $ServerName,$DatabaseName,$userName,$password,$provider
    ## Please provide SQL Query
    # $SQLquery = "select * from ADVANCED.BIF000"
    ##############################################################################
    $conn = New-Object System.Data.OleDb.OleDbConnection
    $conn.ConnectionString = $ConnectionString
    $comm = New-Object System.Data.OleDb.OleDbCommand($SQLquery,$conn)
    # $comm = New-Object System.Data.OleDb.OleDbCommand($conn)
    $conn.Open()
    $adapter = New-Object System.Data.OleDb.OleDbDataAdapter $comm
    $dataset = New-Object System.Data.DataSet
    $adapter.Fill($dataSet)
    $conn.Close()
    $table = $dataset.Tables[0]
    # $table | Export-CSV "C:\powershell\out.csv"
    $table | format-table
}    


function getOleDBDrivers {

    foreach ($provider in [System.Data.OleDb.OleDbEnumerator]::GetRootEnumerator())
    {
        $v = New-Object PSObject        
        for ($i = 0; $i -lt $provider.FieldCount; $i++) 
        {
            Add-Member -in $v NoteProperty $provider.GetName($i) $provider.GetValue($i)
        }
        Write-host $v.SOURCES_NAME
    }

}

function Austest () {

    Write-Output "********************* Austest Austest ***********************"
    Write-Output "********************* test done ***********************"

}






function updateStringsInFiles {

    param(
        [Parameter(Mandatory)]
        [string]$sourceDirPath,
        [Parameter(Mandatory)]
        [string]$singleFileToChange,
        [Parameter(Mandatory)]
        [string]$Server,
        [Parameter(Mandatory)]
        [string]$DBName,
        [Parameter(Mandatory)]
        [string]$User,
        [Parameter(Mandatory)]
        [string]$Pwd,
        # Optional 
        [Parameter(Mandatory=$false)]
        [string]$PortalURL,
        [Parameter(Mandatory=$false)]
        [string]$DBNameAdvancedQueue,
        [Parameter(Mandatory=$false)]
        [string]$WebserviceUrl,
        [Parameter(Mandatory=$false)]
        [string]$CISInfinityWSUrl,
        [Parameter(Mandatory=$false)]
        [string]$PaymentGatewayWSUrl,
        [Parameter(Mandatory=$false)]
        [string]$MobileCISWSUrl,
        [Parameter(Mandatory=$false)]
        [string]$InfinityMobileWSUrl,
        [Parameter(Mandatory=$false)]
        [string]$provider

    )

    $regExConStringPattern ='(^.*Source=|^.*Server=)(.*?)(;.*Catalog=|;.*Database=)(.*?)(;.*ID=|;.*uid=)(.*?)(;Password=|;pwd=)(.*?)(;.*|".*)'
    $replaceConString = "`$1$Server`$3$DBName`$5$User`$7$Pwd`$9"
    
    $regExConStringProviderPattern = '(^.*Source=|^.*Server=)(.*?)(;.*Catalog=|;.*Database=)(.*?)(;.*ID=|;.*uid=)(.*?)(;Password=|;pwd=)(.*?)(;Provider=)(.*?)(;.*)'
    $replaceConStringProvider = "`$1$Server`$3$DBName`$5$User`$7$Pwd`$9$provider`$11"

    # N.B. regExConStringPattern catches this.. however we need to overwrie the value with the correct PaymentQueue DB
    $regExConStringPatternAdvancedQueue ='(.*AdvancedQueueConnectString.*Server=)(.*?)(;.*Catalog=|;.*Database=)(.*?)(;.*ID=|;.*uid=)(.*?)(;Password=|;pwd=)(.*?)(;.*|".*)'
    $replaceConAdvancedQueueString = "`$1$Server`$3$DBNameAdvancedQueue`$5$User`$7$Pwd`$9"
   
    $regExPortalURL = '(.*)(portalURL" value=")(.*?)(".*)'
    $replacePortalURL = "`$1`$2$PortalURL`$4"
    
    $regExWebserviceUrl = '(.*)(WebserviceUrl" value=")(.*?)(".*)'
    $replaceWebserviceUrl = "`$1`$2$WebserviceUrl`$4"
    
    $regExCISInfinityWSUrl = '(.*)(CISInfinityWSUrl" value=")(.*?)(".*)'
    $replaceCISInfinityWSUrl = "`$1`$2$CISInfinityWSUrl`$4"
    
    $regExPaymentGatewayWSUrl = '(.*)(PaymentGatewayWSUrl" value=")(.*?)(".*)'
    $replacePaymentGatewayWSUrl = "`$1`$2$PaymentGatewayWSUrl`$4"
    
    $regExMobileCISWSUrl = '(.*)(MobileCISWSUrl" value=")(.*?)(".*)'
    $replaceMobileCISWSUrl = $MobileCISWSUrl

    $regExInfinityMobileWSUrl = '(.*)(InfinityMobileWSUrl" value=")(.*?)(".*)'
    $replaceInfinityMobileWSUrl = $InfinityMobileWSUrl

    # -----------------------------------------
    $regExPatternArray = @($regExPortalURL, $regExWebserviceUrl, $regExConStringPattern, $regExCISInfinityWSUrl, $regExPaymentGatewayWSUrl, $regExMobileCISWSUrl, $regExInfinityMobileWSUrl, $regExConStringProviderPattern, $regExConStringPatternAdvancedQueue)
    $replaceStringArray = @($replacePortalURL, $replaceWebserviceUrl, $replaceConString, $replaceCISInfinityWSUrl, $replacePaymentGatewayWSUrl, $replaceMobileCISWSUrl, $replaceInfinityMobileWSUrl, $replaceConStringProvider, $replaceConAdvancedQueueString)
         
    # this assumes they keep the folder structure for the default package
    $aws_cis = Join-Path $sourceDirPath 'aws_cis'
    $aws_director = Join-Path $sourceDirPath 'aws_director' 
    $aws_pg = Join-Path $sourceDirPath 'aws_pg' 
    $PA_Manager = Join-Path $sourceDirPath 'PA_Manager' 

    $dirtestArray = @($sourceDirPath,  $aws_cis, $aws_director, $aws_pg, $PA_Manager)
    $dirArray = @()

    if (!(Test-Path $sourceDirPath)) {
        write-host '**********   No folder -->' $sourceDirPath 
    }

    foreach($path in $dirtestArray) {
        if (Test-Path $path) {
            Write-Host 'cool in here' $path
            $dirArray+= $path
        }
    }
    
    #$dirArray = @($sourceDirPath,  $aws_cis, $aws_director, $aws_pg, $PA_Manager)

    foreach ($sourceDir in $dirArray) {
        backUpFile $sourceDir $singleFileToChange
        $NewOutputFileFullPath = Join-Path $sourceDir $singleFileToChange
        replaceTextSingleFileRegExArrayList $sourceDir $singleFileToChange $NewOutputFileFullPath $regExPatternArray $replaceStringArray  
    }

}


function updateSingleConnectionStringOrRegExReplace {

    param(
        [Parameter(Mandatory=$false)]
        [string]$sourceDirPath,
        [Parameter(Mandatory=$false)]
        [string]$singleFileToChange,
        [Parameter(Mandatory=$false)]
        [string]$regExConStringPattern,
        [Parameter(Mandatory=$false)]
        [string]$Server,
        [Parameter(Mandatory=$false)]
        [string]$DBName,
        [Parameter(Mandatory=$false)]
        [string]$User,
        [Parameter(Mandatory=$false)]
        [string]$Pwd,
        [Parameter(Mandatory=$false)]
        [AllowEmptyString()]
        [string]$provider,
        [Parameter(Mandatory=$false)]
        [AllowEmptyString()]
        [string]$replaceConString
    )

    # check to see if $provider and $replaceConString has been used or not
    # typical useage:
    #   if $provider only then assumes it is the connection string that doesn't have a driver/provider for the driver
    #   if $provider set then we explictly use the driver/provider
    #   $replaceConString, then don't care about provider and not use any other logic... don't need to pass db strings
    if ($provider -eq '' -and $replaceConString -eq '') {
        $replaceConString = "`$1`$2$Server`$4$DBName`$6$User`$8$Pwd`$10"
    } elseif ($provider -ne '' -and $replaceConString -eq '') {
        $replaceConString = "`$1`$2$Server`$4$DBName`$6$User`$8$Pwd`$10$provider`$12"
    } else {
        # Nothing, assumed that you explictly passed your own replacement string
    }
        
    $regExPatternArray = @($regExConStringPattern)
    $replaceStringArray = @($replaceConString)
       
    $dirtestArray = @($sourceDirPath)
    $dirArray = @()

    if (!(Test-Path $sourceDirPath)) {write-host '**********   No folder -->' $sourceDirPath }

    foreach($path in $dirtestArray) {
        if (Test-Path $path) {
            Write-Host 'cool in here' $path
            $dirArray+= $path
        }
    }
    
    foreach ($sourceDir in $dirArray) {
        $NewOutputFileFullPath = Join-Path $sourceDir $singleFileToChange
        replaceTextSingleFileRegExArrayList $sourceDir $singleFileToChange $NewOutputFileFullPath $regExPatternArray $replaceStringArray  
    }

}


function dropCompileSPFunFromDirectory ($sourceDir ,$filePattern ,$ServerName ,$DatabaseName ,$userName ,$password) {

    <#
        runs all the sp located in a folder based on the $filePattern ie. $filePattern = '.*\.sql$'
        checkes if it is a Function or Stroed procedure and drop its (by looking at the contents)
        if it is ALTER then do not drop
    #>

    # Determine if a function/procedure or alter script so you don't drop
    $functionRegEx = 'CREATE FUNCTION'
    $storedProcedureRegEx = 'CREATE PROCEDURE'
    $isAlterScript = 'alter'

    $files = Get-ChildItem $sourceDir | Where-Object { ! $_.PSIsContainer } | Where-Object { $_.Name -match $filePattern }  

    foreach ($file in $files.FullName) {
        
        $spName = $file.split("\")[-1]
        $spName = $spName.split(".")[0]

        $temp = Get-Content -path $file
        if ($temp -match $storedProcedureRegEx) { 
            $query = 'Drop procedure IF EXISTS ADVANCED.{0};' -f $spName 
        } elseif ($temp -match $functionRegEx) {
            $query = 'Drop FUNCTION IF EXISTS ADVANCED.{0};' -f $spName
        } elseif ($temp -match $isAlterScript) {
            $query = 'DECLARE @doNothing int'
        }

        Write-Host $query
        # Drop stored procedure
        Invoke-Sqlcmd -Query $query -ServerInstance $ServerName -Database $DatabaseName -Username $userName -Password $password
        Start-Sleep -Seconds 1
        # execute file
        Write-Host '-- running script: ' $file.split("\")[-1]
        Invoke-Sqlcmd -InputFile $file -ServerInstance $ServerName -Database $DatabaseName -Username $userName -Password $password

    }

    Write-Host '!!!!!!!!!!!!!     Script Done      !!!!!!!!!!!!!!!'
}


function setFolderPermission ($directory, $accountArray, $permissions) {

    <#
        sets permissions for files/folders - will propagate to subfolders/files 
        example:
            $directory = "c:\test"
            $accountArray = @('BUILTIN\IIS_IUSRS', 'NT AUTHORITY\IUSR','NT AUTHORITY\NETWORK SERVICE')
            $permissions = 'FullControl'
            setFolderPermission $directory $accountArray $permissions
    #>

    foreach ($accountx in $accountArray) {
        $account = [System.Security.Principal.NTAccount]$accountx
        $acl = Get-Acl $directory
        $inherit = [system.security.accesscontrol.InheritanceFlags]"ContainerInherit, ObjectInherit"
        $propagation = [system.security.accesscontrol.PropagationFlags]"None"
        $RuleType=[System.Security.AccessControl.FileSystemRights]::$permissions  #FullControl, Read
        $Rights=[System.Security.AccessControl.AccessControlType]::Allow
        # $account.Translate([System.Security.Principal.SecurityIdentifier])
        $accessrule = New-Object system.security.AccessControl.FileSystemAccessRule($account, $RuleType, $inherit, $propagation, $Rights)
        # $acl.SetOwner([System.Security.Principal.NTAccount]'BUILTIN\Administrators')
        # $acl.SetAccessRuleProtection($false, $false)
        $acl.RemoveAccessRuleAll($accessrule)
        $acl.AddAccessRule($accessrule)
        set-acl -AclObject $acl $directory 
        Write-Host 'Folder Permission set for user: ' $account
    }
}