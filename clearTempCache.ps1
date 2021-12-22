Set-ExecutionPolicy Bypass -Force
Set-Location C:\

$tempPath = Test-Path C:\Users\*\AppData\Local\Temp
$chromePath = Test-Path C:\Users\*\AppData\Local\Google\Chrome\UserData\Default\Cache
$firefoxPath = Test-Path C:\Users\*\AppData\Local\Mozilla
$crashDumpPath = Test-Path C:\Users\*\AppData\Local\CrashDumps
$terminalServerPath = Test-Path C:\Users\*\AppData\Local\Microsoft\Terminal Server Client\Cache
  #$outlookPath = Test-Path C:\Users\*\AppData\Local\Microsoft\Outlook\RoamCache

  #$pathArray = @($chromePath, $tempPath, $firefoxPath, $outlookPath)
$pathArray = @($chromePath, $tempPath, $firefoxPath, $crashDumpPath, $terminalServerPath)

$tempRemoveItem = Remove-Item -Recurse -Force "C:\Users\*\AppData\Local\Temp\*"
$tempRemoveChrome = Remove-Item -Recurse -Force "C:\Users\*\AppData\Local\Google\Chrome\User Data\Default\Cache\*"
$tempRemoveFireFox = Remove-Item -Recurse -Force "C:\Users\*\AppData\Local\Mozilla\*"
$tempRemoveCrashDump = Remove-Item -Recurse -Force "C:\Users\*\AppData\Local\CrashDumps\*"
$tempRemoveTerminal = Remove-Item -Recurse -Force "C:\Users\*\AppData\Local\Microsoft\Terminal Server Client\Cache\*"
  #$tempRemoveOutlook = Remove-Item -recurse -Force "C:\Users\$*}\AppData\Local\Microsoft\Outlook\RoamCache\*"

$tempRemoveArray = @($tempRemoveChrome, $tempRemoveItem, $tempRemoveFireFox, $tempRemoveCrashDump, $tempRemoveTerminal)

for ( ($i = 0); $i -lt $pathArray.length; $i++) 
{
  Write-Output "Current Path is: {$pathArray[$i]}"
  
  gwmi Win32_LogicalDisk -Filter "DeviceID='C:'" | select Name, FileSystem,FreeSpace,BlockSize,Size | % {$_.BlockSize=(($_.FreeSpace)/($_.Size))*100;$_.FreeSpace=($_.FreeSpace/1GB);$_.Size=($_.Size/1GB);$_}| Format-Table Name, @{n='FS';e={$_.FileSystem}},@{n='Free, Gb';e={'{0:N2}'-f
  $_.FreeSpace}}, @{n='Free,%';e={'{0:N2}'-f $_.BlockSize}} -AutoSize
  
	if ($pathArray[$i])
	{
		$tempRemoveArray[$i]
	}
  else
  {
    Write-Output "Path doesn't exist, Current Path is: $pathArray[$i]"  
  }
}

