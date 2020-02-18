write-host 'current directory is ' $PSScriptRoot
$prevFolder = Split-Path -Path $PSScriptRoot -Parent
Write-Host 'Previous directory is ' $prevFolder
. "$prevFolder\AUSLib.ps1"

Get-DotNetFrameworkVersion






#################################################################################



# READ me if you get errors seen below

# if you get New-Item : Cannot find drive. A drive with the name 'IIS' does not exist.


# run the following then run Get-PSDrive then you should see IIS
        # Remove-Module WebAdministration
        # Import-Module WebAdministration
        # Get-PSDrive # after running you should see IIS

#################################################################################

Import-Module WebAdministration
$SiteFolderPath = "C:\Websites\P2P\3.3.3.2"              # Website Folder
$SiteName = "TESTSITE"                        # IIS Site Name
$SiteAppPool = $SiteName                   # Application Pool Name
$SiteHostName = "pe3.localTest"            # Host Header
$portNumber = 80

# Folder Permissions -recurse
# $accountArray = @('BUILTIN\IIS_IUSRS', 'NT AUTHORITY\IUSR','NT AUTHORITY\NETWORK SERVICE')
# $permissions = 'FullControl'
# setFolderPermission $SiteFolderPath $accountArray $permissions

# Creating Main Site
New-Item IIS:\AppPools\$SiteAppPool
New-Item IIS:\Sites\$SiteName -physicalPath $SiteFolderPath -bindings @{protocol="http";bindingInformation=":"+ $portNumber + ":" +$SiteHostName}
Set-ItemProperty IIS:\Sites\$SiteName -name applicationPool -value $SiteAppPool

# ------------------------->>>>>>  Sub Application
$subSiteAppPool = $SiteAppPool
$subSiteName = 'AWS_CIS'
$subSite_Folder_Path = Join-Path $SiteFolderPath $subSiteName

if (Test-Path $subSite_Folder_Path) {    
    New-Item IIS:\Sites\$SiteName\$subSiteName -physicalPath $subSite_Folder_Path -type Application
    Set-ItemProperty IIS:\sites\$SiteName\$subSiteName -name applicationPool -value $subSiteAppPool
}

# ------------------------->>>>>>  Sub Application
$subSiteAppPool = $SiteAppPool
$subSiteName = 'AWS_DIRECTOR'
$subSite_Folder_Path = Join-Path $SiteFolderPath $subSiteName

if (Test-Path $subSite_Folder_Path) {    
    New-Item IIS:\Sites\$SiteName\$subSiteName -physicalPath $subSite_Folder_Path -type Application
    Set-ItemProperty IIS:\sites\$SiteName\$subSiteName -name applicationPool -value $subSiteAppPool
}

# ------------------------->>>>>>  Sub Application
$subSiteAppPool = $SiteAppPool
$subSiteName = 'AWS_PG'
$subSite_Folder_Path = Join-Path $SiteFolderPath $subSiteName

if (Test-Path $subSite_Folder_Path) {    
    New-Item IIS:\Sites\$SiteName\$subSiteName -physicalPath $subSite_Folder_Path -type Application
    Set-ItemProperty IIS:\sites\$SiteName\$subSiteName -name applicationPool -value $subSiteAppPool
}


# ------------------------->>>>>>  Sub Application
$subSiteAppPool = $SiteAppPool
$subSiteName = 'PA_Manager'
$subSite_Folder_Path = Join-Path $SiteFolderPath $subSiteName

if (Test-Path $subSite_Folder_Path) {    
    New-Item IIS:\Sites\$SiteName\$subSiteName -physicalPath $subSite_Folder_Path -type Application
    Set-ItemProperty IIS:\sites\$SiteName\$subSiteName -name applicationPool -value $subSiteAppPool
}


Write-Host 'New website complete'