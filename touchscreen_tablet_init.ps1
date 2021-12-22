
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

powercfg.exe -x -monitor-timeout-ac 0
powercfg.exe -x -monitor-timeout-dc 0
powercfg.exe -x -disk-timeout-ac 0
powercfg.exe -x -disk-timeout-dc 0
powercfg.exe -x -standby-timeout-ac 0
powercfg.exe -x -standby-timeout-dc 0
powercfg.exe -x -hibernate-timeout-ac 0
powercfg.exe -x -hibernate-timeout-dc 0

# next we change computer name
$cpuName = Read-Host "Please Enter Computer Name"
Write-Output $cpuName
Write-Output "Renaming Computer Name"
$Domain = 'vander-bend.org' ## put domain name here
$Credential = Get-Credential

Rename-Computer $cpuName
Add-Computer -Domain $Domain -NewName $cpuName -Credential $Credential -Restart -Force

# IMPORTANT
# when done with scripting run get-executionpolicy -l
# make sure localmachine and if currentuser !== admin, then policy is set to undefined
# ex set-executionpolicy -executionpolicy undefined -scope currentuser



