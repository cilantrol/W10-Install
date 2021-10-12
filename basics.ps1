
# before running make sure to run Powershell as administrator set-executionpolicy remotesigned -Scope CurrentUser
# to set execution policy for current session use set-executionpolicy remotesigned -scope process


# first we have to update computer sleep settings to never turn off, hibernate, sleep, harddisk always on

# to make this better, only set never time outs when plugged in to save battery life
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

Rename-Computer -NewName $cpuName -DomainCredential Domain01\Admin01

# add Vander-Bend Domain
Add-Computer -DomainName vander-bend.org -Credential AD\adminuser -restart -force


# IMPORTANT
# when done with scripting run get-executionpolicy -l
# make sure localmachine and if currentuser !== admin, then policy is set to undefined
# ex set-executionpolicy -executionpolicy undefined -scope currentuser



