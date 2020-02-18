




#  This must be run with the shell with admin rights





# function setFolderPermission ($directory, $accountArray, $permissions) {

#     <#
#         sets permissions for files/folders - will propagate to subfolders/files 
#         example:
#             $directory = "c:\test"
#             $accountArray = @('BUILTIN\IIS_IUSRS', 'NT AUTHORITY\IUSR','NT AUTHORITY\NETWORK SERVICE')
#             $permissions = 'FullControl'
#             setFolderPermission $directory $accountArray $permissions
#     #>

#     foreach ($accountx in $accountArray) {
#         $account = [System.Security.Principal.NTAccount]$accountx
#         $acl = Get-Acl $directory
#         $inherit = [system.security.accesscontrol.InheritanceFlags]"ContainerInherit, ObjectInherit"
#         $propagation = [system.security.accesscontrol.PropagationFlags]"None"
#         $RuleType=[System.Security.AccessControl.FileSystemRights]::$permissions  #FullControl, Read
#         $Rights=[System.Security.AccessControl.AccessControlType]::Allow
#         # $account.Translate([System.Security.Principal.SecurityIdentifier])
#         $accessrule = New-Object system.security.AccessControl.FileSystemAccessRule($account, $RuleType, $inherit, $propagation, $Rights)
#         # $acl.SetOwner([System.Security.Principal.NTAccount]'BUILTIN\Administrators')
#         # $acl.SetAccessRuleProtection($false, $false)
#         $acl.RemoveAccessRuleAll($accessrule)
#         $acl.AddAccessRule($accessrule)
#         set-acl -AclObject $acl $directory 
#         Write-Host 'Folder Permission set for user: ' $account
#     }
# }


write-host 'current directory is ' $PSScriptRoot
$prevFolder = Split-Path -Path $PSScriptRoot -Parent
Write-Host 'Previous directory is ' $prevFolder
. "$prevFolder\AUSLib.ps1"


# N.B.  you must run this on with elavated permissions
# set-acl : The trust relationship between this workstation and the primary domain failed.

$directory = "c:\test"
$accountArray = @('BUILTIN\IIS_IUSRS', 'NT AUTHORITY\IUSR','NT AUTHORITY\NETWORK SERVICE')
$permissions =  'Read'  #'FullControl'
setFolderPermission $directory $accountArray $permissions

