
#################################################################################



# READ me if you get errors seen below

# if you get New-Item : Cannot find drive. A drive with the name 'IIS' does not exist.


# run the following then run Get-PSDrive then you should see IIS
        # Remove-Module WebAdministration
        # Import-Module WebAdministration
        # Get-PSDrive # after running you should see IIS

        

#################################################################################
Import-Module WebAdministration
$currentSiteName = "aaa1"   # Main IIS Site Name, Mandatory
    $NewSiteName =  'z1'                     # New IIS Site Name
    $NewSiteHostName =    'www.com.prod'         # ie. link.com -- only for Main site

        # seetings only for SubSite
        $currentSubSiteName = ''
        $NewSubSiteName = ''

# seetings for Main or Subsite, note: if subsite is set then this will update subsite
$NewSiteFolderPath =   'c:\test'            # Website Folder
$NewSiteAppPool = 'ronpool2'                  # Application Pool Name
# $NewportNumber = 80   # already defaulted to 80

# N.B. current only use port 80 and only http for bindings, no HTTPS. Change manually if needed

function updateWebsite {

    param(
        [Parameter(Mandatory)]
        [string]$currentSiteName,
        # Optional 
        [Parameter(Mandatory=$false)]
        [string]$currentSubSiteName,
        [Parameter(Mandatory=$false)]
        [string]$NewSiteName,
        [Parameter(Mandatory=$false)]
        [string]$NewSiteFolderPath,
        [Parameter(Mandatory=$false)]
        [string]$NewSiteHostName,
        [Parameter(Mandatory=$false)]
        [string]$NewportNumber=80,
        [Parameter(Mandatory=$false)]
        [string]$NewSiteAppPool,
        [Parameter(Mandatory=$false)]
        [string]$NewSubSiteName
    )
        

    if($NewSubSiteName -and $currentSubSiteName){
        Rename-Item IIS:\Sites\$currentSiteName\$currentSubSiteName $NewSubSiteName 
        $currentSubSiteName = $NewSubSiteName
    }
        
    if($NewSiteName){
        Rename-Item IIS:\Sites\$currentSiteName $NewSiteName 
        $currentSiteName = $NewSiteName
    }

    if($NewSiteFolderPath){
        if (Test-Path $NewSiteFolderPath) {   
            Set-ItemProperty IIS:\Sites\$currentSiteName\$currentSubSiteName -name physicalPath -value $NewSiteFolderPath
        }
    }
    if($NewSiteHostName){Set-ItemProperty IIS:\Sites\$currentSiteName\ -name bindings -value @{protocol="http";bindingInformation=":"+ $NewportNumber + ":" +$NewSiteHostName}}
    if($NewSiteAppPool){
        if(!(Test-Path IIS:\AppPools\$NewSiteAppPool)) {
            New-Item IIS:\AppPools\$NewSiteAppPool
        }
        Set-ItemProperty IIS:\Sites\$currentSiteName\$currentSubSiteName -name applicationPool -value $NewSiteAppPool
    }

}


# Execute
updateWebsite -currentSiteName $currentSiteName -NewSiteFolderPath $NewSiteFolderPath `
                -NewSiteHostName $NewSiteHostName -NewSiteAppPool $NewSiteAppPool `
                -currentSubSiteName $currentSubSiteName -NewSubSiteName $NewSubSiteName `
                -NewSiteName $NewSiteName



Write-Host 'website Update complete'