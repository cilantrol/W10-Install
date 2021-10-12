
Start-Process powershell -Verb runAs

$javaInstall = Start-Process -FilePath "\\vb-fs1\Software\Essentials\Java\jre-6u39-windows-i586.exe" -Wait
$sparkInstall = Start-Process -filepath "\\vb-fs1\Software\Essentials\spark_2_6_3_online.exe" -Wait
$sentinelInstall = Start-Process -FilePath "\\vb-fs1\Software\Essentials\SentinelOne_Installation\SentinelInstaller_windows_64bit_v21_5_7_370.msi" -Wait
$aciInstall = Start-Process -FilePath "\\vb-fs1\Software\Essentials\Visual\VMsetup9\ACI\ACIClientSetup.exe" -Wait
# Open Regedit 
regedit.exe -Verb runAs 
Get-ChildItem -Path "LOCAL_MACHINE\Software\WOW6432\CurrentVersion\Run" 


$v9Install = Start-Process -FilePath "\\vb-fs1\Software\Essentials\Visual\VMsetup9\Unify\Deploy70.exe" -Wait
#  open updates, replace sql file, copy sql file into Info/Runtime7
# when done change path to
#  C:\Infor\Runtime7

# Change Icon of V9
$Shell = New-Object -ComObject ("WScript.Shell")
$Shortcut = $Shell.CreateShortcut($ShortcutPath)
$Shortcut.IconLocation = "$IconLocation, $IconArrayIndex"
$Shortcut.Save()



$javaInstall

# function installApplication{
#   Param($skip, $arguments, $name, $path, $runcommand)
#   if ($skip -eq "no"){
#       if ($arguments){
#           write-host "Installing Application $appname"
#           $app = Start-Process -Wait -FilePath $path$runcommand -ErrorAction....
#           if($app.ExitCode -eq "0"){
#           ....
#           ....
# }