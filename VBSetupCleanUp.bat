@echo off
setlocal enabledelayedexpansion

set scriptsDir=\\vb-fs1\Software\Essentials\Scripts
set filesDir=\\vb-fs1\Software\Essentials\files
set CMFGDir=\\APPS\apps\CMFG

:user_specific_installs_menu
	echo "=================Menu======================="
	echo "Please choose from the following options:"
	echo "$ Indicates Elevated Permissions Required"
	echo "*$ 'D' to run DNSChange"
	echo "*  'M' to map User Drives"
	echo "*  'V' to setup Visual 9"
	echo "*  'O' to setup Optimum"
	echo "*  'R' for the Reports folder"
	echo "*  'E' to exit"
	echo "=================Menu======================="
	::set choice=
	set /P choice=Enter your selection:
  
  set prompt[0] = echo "Calling DNS change.."
  set prompt[1] = echo "Calling Map User Drivers"
  set prompt[2] = echo "Calling Visual 9 Set Up"
  set prompt[3] = echo "Calling Optimum Set Up"
  set prompt[4] = echo "Calling Opening Reports Folder"
  
  set ip_test[0] = vb-fs1 192.168.2.239
  set ip_test[0] = vb-fs1 192.168.2.4
  set ip_test[0] = vb-fs1 192.168.2.4
  set ip_test[0] = vb-fs1 192.168.2.216
  set ip_test[0] = vb-fs1 192.168.2.234
  
  
	if /I 'X!CHOICE!'=='XD' (
		::Run DNSChange
		echo Calling dnschange...
		call:test_network_connection vb-fs1 192.168.2.239
		set user=
		set /P user=Enter Administrative User Name [Administrator]:
		if 'X!USER!'=='X' set user=Administrator
		runas /user:!USER! "%scriptsDir%\dnschange.bat"
		goto user_specific_installs_menu
	)
	if /I 'X!CHOICE!'=='XM' (
		::MAP U, S, V drives
		echo Calling Map User Drives...
		call:test_network_connection vb-fs1 192.168.2.4
		call "%scriptsDir%\Map Drives.bat"
		goto user_specific_installs_menu
	)
	if /I 'X!CHOICE!'=='XV' (
		::SETUP Visual
		echo Calling Visual 9 Setup...
		call:test_network_connection vb-fs1 192.168.2.4
		call "%scriptsDir%\Visual9Setup.bat"
		goto user_specific_installs_menu
	)
	if /I 'X!CHOICE!'=='XO' (
		::Setup Optimum
		echo Copying Optimum Shortcuts...
		call:test_network_connection timeclock 192.168.2.216
		call:install_shortcuts "\\timeclock\Optimum Solutions\OptimumSuite\OptimumSuite.lnk"
		goto user_specific_installs_menu
	)
	if /I 'X!CHOICE!'=='XR' (
		::Open Reports Folder
		call:test_network_connection apps 192.168.2.234
		explorer "\\apps\Apps\Report"
		goto user_specific_installs_menu
	)
	if /I 'X!CHOICE!'=='XE' (
		goto:eof
	)
	echo Please make a valid selection
goto user_specific_installs_menu

:install_shortcuts
	set source=%~1
	set desktopDir=%USERPROFILE%\Desktop
	set QLDir=%APPDATA%\Microsoft\Internet Explorer\Quick Launch
	set winXPSMD=%USERPROFILE%\Start Menu\Programs
	set win7SMD=%USERPROFILE%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs
	
	echo Installing shortcuts for %SOURCE%
	xcopy /c /r /v /z /y "%SOURCE%" "%desktopDir%"
	xcopy /c /r /v /z /y "%SOURCE%" "%QLDir%"
	
	if exist "%winXPSMD%" (
		xcopy /c /r /v /z /y "%SOURCE%" "%winXPSMD%\"
	)
	if exist "%win7SMD%" (
		xcopy /c /r /v /z /y "%SOURCE%" "%win7SMD%\"
	)
goto:eof

:install_registry
	set source_file=%~1
	echo Installing registry entries in %SOURCE_FILE%..
	regedit /s %SOURCE_FILE%
goto:eof

:test_network_connection
	set can_connect=NO
	set servername=%~1
	set serverip=%~2
	echo Checking for connection to %SERVERNAME% (%SERVERIP%)
	if not exist \\%SERVERNAME%\anchor\anchor.txt (
		if not exist \\%SERVERIP%\anchor\anchor.txt (
			echo         =======Error=======
			echo Cannot connect to %SERVERIP%.
			echo Check that the machines are networked and permissions are set
			echo If a connection is available press 'C' to continue.
			echo Press enter to retry the connection.
			echo         =======Error=======
		) else (
			echo         =======Error=======
			echo Cannot connect to %SERVERNAME%.
			echo If this machine needs DNS setup, press 'D' to setup DNS [RECOMMENDED].
			echo If this machine has no DNS, press 'H' to modify the hosts file.
			echo If a connection is available press 'C' to continue.
			echo Press enter to retry without making changes.
			echo         =======Error=======
		)
		set choice=
		set /P choice=Enter your selection:
		if /I 'X!CHOICE!'=='XD' (
			echo Calling DNS Change Utility
			call "\\192.168.2.4\software\essentials\scripts\dnschange.bat"
		)
		if /I 'X!CHOICE!'=='XH' (
			echo Calling Host Copy Utility
			call "\\192.168.2.4\software\essentials\scripts\hostcopy.bat"
		)
		if /I 'X!CHOICE! NEQ 'XC' (
			echo Retrying...
			call:test_network_connection %SERVERNAME% %SERVERIP%
		)
	)
	echo Connection established
goto:eof