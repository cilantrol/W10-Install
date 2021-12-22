
# before running make sure to run Powershell as administrator set-executionpolicy remotesigned -Scope CurrentUser
# to set execution policy for current session use set-executionpolicy remotesigned -scope process


# first we have to update computer sleep settings to never turn off, hibernate, sleep, harddisk always on

# to make this better, only set never time outs when plugged in to save battery life

# workflow New-ComputerSetup {
#   param (
#   )
# 
# }
# $user = "admin"
# $pw = ConvertTo-SecureString -String "uranium.l23" -AsPlainText -Force
# $cred = New-Object System.Management.Automation.PSCredential($user, $pw)
# $AtStartup = New-JobTrigger -AtStartup
# Register-ScheduledJob -Name NewServerSetupResume `
#                       -Credential $cred `
#                       -Trigger $AtStartup `
#                       -ScriptBlock {Import-Module PSWorkflow; `
#                           Get-Job -Name NewSrvSetup -State Suspended `
#                           | Resume-Job}
set-executionpolicy remotesigned -scope process
Pause

Write-Output "Modifying Power Settings"
Write-Output "MONITOR NEVER TIMEOUT / DISK NEVER TIMEOUT / NEVER SLEEP / NEVER HIBERNATE USE FOR DESKTOP ONLY"
$powerSetting = Read-Host -Prompt "Press 1 to configure Desktop Power Setting, 2 for Laptop, 3 for Tablet and ect."

# AC settings are used when the system is on AC power. DC settings on battery power.
Switch ($powerSetting)
{
  1
  {
    Write-Output "Configuring Desktop Power Settings"
    Write-Output "Never Sleep, Disk Never Timeout, Never Hibernate"
    powercfg.exe -x -monitor-timeout-ac 0
    powercfg.exe -x -monitor-timeout-dc 0
    powercfg.exe -x -disk-timeout-ac 0
    powercfg.exe -x -disk-timeout-dc 0
    powercfg.exe -x -standby-timeout-ac 0
    powercfg.exe -x -standby-timeout-dc 0
    powercfg.exe -x -hibernate-timeout-ac 0
    powercfg.exe -x -hibernate-timeout-dc 0
  }
  2
  {
    Write-Output "Configuring Laptop Power Settings"
    Write-Output "Monitor never timeout while plugged in, Monitor time out within 5 mins on battery"
    Write-Output "Never Standby or Hibernate while plugged in"
    Write-Output "Hard disk Settings On Default"
    powercfg.exe -x -monitor-timeout-ac 0
    powercfg.exe -x -monitor-timeout-dc 5
    powercfg.exe -x -standby-timeout-dc 0
    powercfg.exe -x -hibernate-timeout-dc 0 
  }
  3 
  {
    Write-Output "Configuring Tablet Power Settings"
    Write-Output "Never Sleep, Disk Never Timeout, Never Hibernate"
    powercfg.exe -x -monitor-timeout-ac 0
    powercfg.exe -x -monitor-timeout-dc 0
    powercfg.exe -x -disk-timeout-ac 0
    powercfg.exe -x -disk-timeout-dc 0
    powercfg.exe -x -standby-timeout-ac 0
    powercfg.exe -x -standby-timeout-dc 0
    powercfg.exe -x -hibernate-timeout-ac 0
    powercfg.exe -x -hibernate-timeout-dc 0
  }
}



# Disable IPv6
Write-Output "Disabling IPv6 Please check if Ethernet 0 is the correct port for IPv6"
Get-NetAdapterBinding
$ethernetPort = Read-Host -Prompt "Press 1 to continue or any other key to skip IPv6"

switch ($ethernetPort) {
  0 {  }
  1 {  }
  2 {  }
  3 {  }
  4 {  }
  5 {  }
  6 {  }
  Default {}
}
if ($v6 == 1) {
  Write-Output "Disabling IPv6 on ethernet port 0"
  Disable-NetAdapterBinding -InterfaceAlias “Ethernet0” -ComponentID ms_tcpip6
}

# Setting Best Performance For PC
$path = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects'
try {
    $s = (Get-ItemProperty -ErrorAction stop -Name visualfxsetting -Path $path).visualfxsetting 
    if ($s -ne 2) {
        Set-ItemProperty -Path $path -Name 'VisualFXSetting' -Value 2  
        }
    }
catch {
    New-ItemProperty -Path $path -Name 'VisualFXSetting' -Value 2 -PropertyType 'DWORD'
    }

# enable local Administrator account and set password
Get-LocalUser -Name "Administrator" | Enable-LocalUser
# next we change computer name
$cpuName = Read-Host "Please Enter Computer Name"
Write-Output $cpuName
Write-Output "Renaming Computer Name"
$Domain = 'vander-bend.org' ## put domain name here
$Credential = Get-Credential

Rename-Computer -NewName $hostname
Add-Computer -Domain $Domain -NewName $cpuName -Credential $Credential -Restart -Force

# IMPORTANT
# when done with scripting run get-executionpolicy -l
# make sure localmachine and if currentuser !== admin, then policy is set to undefined
# ex set-executionpolicy -executionpolicy undefined -scope currentuser



