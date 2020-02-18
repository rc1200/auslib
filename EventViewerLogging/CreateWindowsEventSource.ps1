param(
[Parameter(Mandatory = $false)] [string] $logName = "AdvancedUtility",
[Parameter(Mandatory = $false)] [string] $source = "CISInfinity.UnitTest3"
)

Write-Host Parameters:: 
Write-Host "-- logName: " $logName
Write-Host "-- source: " $source
Write-Host "Press any key to continue..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

# Get the ID and security principal of the current user account
$myWindowsID=[System.Security.Principal.WindowsIdentity]::GetCurrent()
$myWindowsPrincipal=new-object System.Security.Principal.WindowsPrincipal($myWindowsID)

# Get the security principal for the Administrator role
$adminRole=[System.Security.Principal.WindowsBuiltInRole]::Administrator

# Check to see if we are currently running "as Administrator"
if ($myWindowsPrincipal.IsInRole($adminRole))
{
   # We are running "as Administrator" - so change the title and background color to indicate this
   $Host.UI.RawUI.WindowTitle = $myInvocation.MyCommand.Definition + "(Elevated)"
   $Host.UI.RawUI.BackgroundColor = "DarkBlue"
   clear-host
}
else
{
   #We are not running "as Administrator" - so relaunch as administrator

   #Create a new process object that starts PowerShell
   $newProcess = new-object System.Diagnostics.ProcessStartInfo "PowerShell";

   #Specify the current script path and name as a parameter
   $x1 = $myInvocation.MyCommand.Definition + " " + $logName + " " + $source

   $newProcess.Arguments = $x1

   #Indicate that the process should be elevated
   $newProcess.Verb = "runas";

   #Start the new process
   [System.Diagnostics.Process]::Start($newProcess);

   # Exit from the current, unelevated, process
   exit
}

##Write-Host Elevated Process started.  Parameters:: logName: $logName source: $source
##$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

$created = $false;
if ([System.Diagnostics.EventLog]::SourceExists($source) -eq $False) 
{
   New-EventLog -LogName $logName -Source $source
   $created = $true;
}

Write-EventLog -LogName $logName -Source $source -Message "Test" -EventId 2

if ($created -eq $true)
{
   Write-Host "Event Source created.  LogName: $logName  Source: $source"
}
Write-Host "Test eventy log entry added."
Write-Host "Press any key to continue..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
