@echo off
IF EXIST back.bat (del back.bat)
set verno=ALPHA BUILD 5/25/12 10:48 PM EST
title                                          HTC Thunderbolt Tool %verno%
color 0b
::
:: This program is free software. It comes without any warranty, to
:: the extent permitted by applicable law. You can redistribute it
:: and/or modify it under the terms of the Do What The Fuck You Want
:: To Public License, Version 2, as published by Sam Hocevar. See
:: http://sam.zoy.org/wtfpl/COPYING for more details.
:: 
::*********************************SKIPPING UPDATES, REMOVE THIS PRIOR TO RELEASE******************************
GOTO PROGRAM
:: * Script update engine  *
echo Checking for updates...
::In case of freshly updated script...
IF EXIST support_files\Script-MD5.txt (del support_files\Script-MD5.txt)
IF EXIST OTA.bat (MOVE OTA.bat support_files\OTA.bat) >NUL
IF EXIST support_files\Script-server-MD5.txt (del support_files\Script-server-MD5.txt)
::Building MD5 of current script
support_files\md5sums ThunderboltTool.bat >support_files\Script-MD5.txt
:: Downloading latest MD5 Definitions
support_files\wget --quiet -O support_files\Script-server-MD5.txt http://dl.dropbox.com/u/61129367/Script-server-MD5.txt
::Checking to see if there's a new version...
fc /b support_files\Script-MD5.txt support_files\Script-server-MD5.txt >NUL
if errorlevel 1 (Goto OTA) ELSE (GOTO PROGRAM)
:OTA
MOVE support_files\OTA.bat OTA.bat >NUL
OTA.bat
exit
:PROGRAM
cls
IF NOT EXIST support_files\download (mkdir support_files\download)
echo You are running the current version, %verno%.
IF EXIST support_files\Script-MD5.txt (del support_files\Script-MD5.txt)
IF EXIST support_files\Script-server-MD5.txt (del support_files\Script-server-MD5.txt)
echo.
::Pre updates for mini-progs
echo Checking for other updates...
echo.
::
:firstupdateroot
IF EXIST support_files\download\DowngradeBypass.zip (
IF EXIST support_files\download\downgradebypass.zip.md5 (del support_files\download\downgradebypass.zip.md5)
support_files\wget --quiet -O support_files\download\downgradebypass.zip.md5 http://dl.dropbox.com/u/61129367/DowngradeBypass.zip.md5
support_files\md5sums support_files\download\downgradebypass.zip>support_files\root.md5
fc /b support_files\download\downgradebypass.zip.md5 support_files\root.md5 >NUL
IF errorlevel 1 (
echo.
echo Updating rooter...
echo.
IF EXIST support_files\root\ (RMDIR "support_files\root" /S /Q)
support_files\wget --quiet -O support_files\download\DowngradeBypass.zip http://dl.dropbox.com/u/61129367/DowngradeBypass.zip
support_files\md5sums support_files\download\DowngradeBypass.zip>support_files\root.md5
fc /b support_files\download\downgradebypass.zip.md5 support_files\root.md5 >NUL
IF errorlevel 1 (GOTO firstupdateroot)
)
IF NOT EXIST support_files\root (support_files\unzip support_files\download\DowngradeBypass.zip -d support_files\root >NUL)
IF EXIST support_files\download\downgradebypass.zip.md5 (del support_files\download\downgradebypass.zip.md5)
IF EXIST support_files\root.md5 (del support_files\root.md5)
)
:firstupdatetwrp
IF EXIST support_files\download\TWRP.img (
support_files\wget --quiet -O support_files\download\TWRP.img.md5 http://dl.dropbox.com/u/61129367/TWRP.img.md5
support_files\md5sums support_files\download\TWRP.img>support_files\download\TWRP-here.md5
fc /b support_files\download\TWRP-here.md5 support_files\download\TWRP.img.md5 >NUL
IF errorlevel 1 (
echo Updating TWRP...
echo.
support_files\wget --quiet -O support_files\download\TWRP.img http://dl.dropbox.com/u/61129367/TWRP.img
GOTO firstupdatetwrp
)
)
:skiptwrp
::
:DONE
echo Done.
PING 1.1.1.1 -n 1 -w 3000 >NUL
echo.

del support_files\adbroot
del support_files\bl
del support_files\romver
del support_files\here
cls
support_files\adb kill-server
support_files\adb start-server
:MAIN
cls
IF EXIST support_files\adbroot (del support_files\adbroot)
IF EXIST support_files\bl (del support_files\bl)
IF EXIST support_files\romver (del support_files\romver)
IF EXIST support_files\here (del support_files\here)
support_files\adb shell echo a>support_files\here
set here=NULL
set /p here=<support_files\here
if "%here%" == "a" (goto MAIN2)
set romver=Unknown
set bootloader=Unknown
set adbrt=Unknown
set warn=nc
GOTO skip
:MAIN2
set warn=
echo Getting phone info...
support_files\adb shell getprop ro.product.version>support_files\romver
set /p romver=<support_files\romver
support_files\adb shell getprop ro.bootloader>support_files\bl
set /p bl=<support_files\bl
IF %bl%==6.04.1002 (set bootloader=Revolutionary S-OFF)
IF %bl%==1.04.2000 (set bootloader=ENG S-OFF)
IF %bl%==1.04.0000 (set bootloader=Stock S-ON)
IF %bl%==1.05.0000 (set bootloader=Stock S-ON)
support_files\adb shell getprop ro.debuggable>support_files\adbroot
set /p adbroot=<support_files\adbroot
IF %adbroot%==1 (set adbrt=Yes) ELSE (set adbrt=No)
:skip
title                                          HTC Thunderbolt Tool %verno%
set m=NULL
cls
echo                Welcome to the HTC Thunderbolt tool, by trter10.
echo.
echo Phone information: 
echo.
IF "%warn%"=="nc" (echo                          * WARNING: DEVICE NOT CONNECTED *)
echo   ROM Version: %romver%
echo    Bootloader: %bootloader%
echo    ADB rooted: %adbrt%
echo.
echo MAIN MENU
echo --------------------------------------------------------
echo      1 - S-OFF and root
echo      2 - Unroot
echo      3 - Recovery menu 
echo      4 - Unbrick menu
echo      5 - Boot menu
echo      6 - Extras
echo      7 - Reload info
echo      8 - HELP
echo --------------------------------------------------------
set /p m=Choose what you want to do or hit ENTER to exit. 
IF %M%==1 (GOTO ROOT)
IF %M%==2 (GOTO UNROOT)
IF %M%==3 (GOTO RECOVERY)
IF %M%==4 (GOTO UNBRICK)
IF %M%==5 (GOTO BOOT)
IF %M%==6 (GOTO EXTRAS)
IF %M%==7 (GOTO MAIN)
IF %M%==8 (GOTO HELP)
GOTO EXIT
::
:: -----------------------------------------------------------------------
::
:ROOT
cls
echo Working...
IF NOT EXIST support_files\download\downgradebypass.zip (GOTO getDB)
IF EXIST support_files\download\downgradebypass.zip.md5 (del support_files\download\downgradebypass.zip.md5)
support_files\wget --quiet -O support_files\download\downgradebypass.zip.md5 http://dl.dropbox.com/u/61129367/DowngradeBypass.zip.md5
support_files\md5sums support_files\download\downgradebypass.zip>support_files\root.md5
fc /b support_files\download\downgradebypass.zip.md5 support_files\root.md5 >NUL
IF "%errorlevel%" == "1" (
:GetDB
echo.
echo It seems you don't yet have the root files.
echo Downloading now...
echo.
IF EXIST support_files\root\ (RMDIR "support_files\root" /S /Q)
support_files\wget -O support_files\download\DowngradeBypass.zip http://dl.dropbox.com/u/61129367/DowngradeBypass.zip
support_files\md5sums support_files\download\DowngradeBypass.zip>support_files\root.md5
fc /b support_files\download\downgradebypass.zip.md5 support_files\root.md5 >NUL
IF errorlevel 1 (GOTO ROOT)
)
title                                          HTC Thunderbolt Tool %verno%
IF NOT EXIST support_files\root (support_files\unzip support_files\download\DowngradeBypass.zip -d support_files\root >NUL)
IF EXIST support_files\download\downgradebypass.zip.md5 (del support_files\download\downgradebypass.zip.md5)
IF EXIST support_files\root.md5 (del support_files\root.md5)
del support_files\adbroot
del support_files\bl
del support_files\romver
del support_files\here
cls
cd support_files\root\
RUN-ME.bat
exit
::
:: -----------------------------------------------------------------------
::

:UNROOT
cls
echo Working...
IF NOT EXIST support_files\unroot (
cls
echo.
echo It seems you don't yet have the unroot files.
echo Downloading now... This will take awhile...
echo.
:getunroot
support_files\wget -O support_files\download\unroot.zip http://dl.dropbox.com/u/61129367/Unroot.zip
support_files\md5sums support_files\download\unroot.zip>support_files\unroot.zip.md5
set /p unrootmd5=<support_files\unroot.zip.md5
IF "%unrootmd5%" NEQ "9EC2474DEE4F96F5BDBA5C1462F5D77E  support_files\download\unroot.zip" (
cls
title                                          HTC Thunderbolt Tool %verno%
echo Error downloading!
RMDIR "support_files\unroot" /S /Q
echo Downloading again...
goto getunroot

)
support_files\unzip support_files\download\unroot.zip -d support_files\unroot >NUL
)
del support_files\unroot.md5
del support_files\adbroot
del support_files\bl
del support_files\romver
del support_files\here
cls
cd support_files\unroot
cls
Unroot-NEW.bat
exit
::
:: -----------------------------------------------------------------------
::

:RECOVERY
set m=NULL
cls
echo.
echo.
echo RECOVERY MENU
echo --------------------------------------------------------
echo      1 - Flash TWRP
echo      2 - Flash TWRP and apply my ICS Theme
echo      3 - Flash Regular CWM
echo      4 - Flash CWM Touch
echo      5 - Flash 4ext
echo      6 - Flash RA_GNM 
echo      7 - Flash RZRecovery
echo      8 - Main Menu
echo --------------------------------------------------------
set /p m=Choose what you want to do or hit ENTER to exit. 
IF %M%==1 (GOTO TWRP)
IF %M%==2 (GOTO TWRP-ICS)
IF %M%==3 (GOTO CWM-REG)
IF %M%==4 (GOTO CWM-TOUCH)
IF %M%==5 (GOTO 4EXT)
IF %M%==6 (GOTO RA_GNM)
IF %M%==7 (GOTO RZRecovery)
IF %M%==8 (GOTO MAIN)
GOTO EXIT

:TWRP
cls
support_files\wget --quiet -O support_files\download\TWRP.img.md5 http://dl.dropbox.com/u/61129367/TWRP.img.md5
support_files\md5sums support_files\download\TWRP.img>support_files\download\TWRP-here.md5
set /p twrpdl=<support_files\download\TWRP.img.md5
set /p twrphere=<support_files\download\TWRP-here.md5
cls
IF "%twrpdl%" == "%twrphere%" (GOTO flashtwrp)
echo TWRP not found, or there is an update.
echo Downloading TWRP...
echo.
support_files\wget --quiet -O support_files\download\TWRP.img http://dl.dropbox.com/u/61129367/TWRP.img
GOTO TWRP
:flashtwrp
echo Flashing TWRP... Please wait...
echo.
del support_files\download\TWRP.img.md5
del support_files\download\TWRP-here.md5
support_files\adb reboot-bootloader
support_files\fastboot flash recovery support_files\download\TWRP.img
support_files\fastboot reboot
support_files\adb wait-for-device
support_files\adb reboot recovery
echo.
cls
echo Phone is on its way to TWRP recovery.
PING 1.1.1.1 -n 1 -w 4000 >NUL
GOTO RECOVERY

:CWM-REG
cls
support_files\wget --quiet -O support_files\download\cwmreg.img.md5 http://dl.dropbox.com/u/61129367/cwmreg.img.md5
support_files\md5sums support_files\download\cwmreg.img>support_files\download\cwm-here.md5
set /p cwmdl=<support_files\download\cwmreg.img.md5
set /p cwmhere=<support_files\download\cwm-here.md5
cls
IF "%cwmdl%" == "%cwmhere%" (GOTO flashcwm)
echo CWM not found, or there is an update.
echo Downloading CWM...
echo.
support_files\wget --quiet -O support_files\download\cwmreg.img http://dl.dropbox.com/u/61129367/cwmreg.img
GOTO CWM-REG
:flashcwm
echo Flashing CWM... Please wait...
echo.
del support_files\download\cwmreg.img.md5
del support_files\download\cwm-here.md5
support_files\adb reboot-bootloader
support_files\fastboot flash recovery support_files\download\cwmreg.img
support_files\fastboot reboot
support_files\adb wait-for-device
support_files\adb reboot recovery
echo.
cls
echo Phone is on its way to ClockWorkMod recovery.
PING 1.1.1.1 -n 1 -w 4000 >NUL
GOTO RECOVERY

::
:: -----------------------------------------------------------------------
::

:UNBRICK
GOTO MAIN
::
:: -----------------------------------------------------------------------
::

:BOOT
set m=NULL
cls
echo.
echo.
echo BOOT MENU
echo --------------------------------------------------------
echo      1 - Reboot
echo      2 - Hot Reboot (May not work)
echo      3 - Reboot Recovery
echo      4 - Reboot to fastboot
echo      5 - Reboot to hboot
echo      6 - Power off
echo      7 - Main Menu
echo --------------------------------------------------------
set /p m=Choose what you want to do or hit ENTER to exit. 
IF %M%==1 (
cls
echo Please wait...
support_files\adb reboot
GOTO boot
)
IF %M%==2 (
cls
echo Please wait...
support_files\adb shell killall system_server
GOTO boot
)
IF %M%==3 (
cls
echo Please wait...
support_files\adb reboot recovery
goto boot
)
IF %M%==4 (

echo Please wait...
support_files\adb reboot-bootloader
goto boot
)
IF %M%==5 (
cls
echo Please wait...
support_files\adb reboot-bootloader
support_files\fastboot oem gotohboot
goto boot
)
IF %M%==6 (
cls
echo Please wait...
support_files\adb reboot-bootloader
support_files\fastboot oem powerdown
goto boot
)
IF %M%==7 (GOTO main)
GOTO EXIT
::
:: -----------------------------------------------------------------------
::

:EXTRAS
set m=NULL
cls
echo.
echo.
echo EXTRAS MENU
echo --------------------------------------------------------
echo      1 - Block OTA Updates
echo      2 - Re-enable OTA Updates
echo      3 - Update Superuser
echo      4 - Run ADB/Fastboot cmd (Enter back to return)
echo      5 - Install Busybox
echo      6 - Main Menu
echo --------------------------------------------------------
set /p m=Choose what you want to do or hit ENTER to exit. 
IF %M%==1 (GOTO OTABlock)
IF %M%==2 (GOTO OTAEnable)
IF %M%==3 (GOTO SUUpdates)
IF %M%==4 (
cls
echo @echo off>back.bat
echo del adb.exe>>back.bat
echo del fastboot.exe>>back.bat
echo del adbwinapi.dll>>back.bat
echo del adbwinusbapi.dll>>back.bat
echo ThunderboltTool.bat>>back.bat
COPY support_files\adb.exe adb.exe
COPY support_files\fastboot.exe fastboot.exe
COPY support_files\adbwinapi.dll adbwinapi.dll
COPY support_files\adbwinusbapi.dll adbwinusbapi.dll
cls
cmd
)
FI %M%==5 (GOTO bbox)
IF %M%==6 (GOTO MAIN)
GOTO EXIT
:: ------------

:OTABlock
cls
echo ------------------------------
echo      OTA Update disabler
echo ------------------------------
IF "%adbroot%"=="1" (GOTO blockrooted)
echo Rebooting to recovery...
support_files\adb reboot recovery
echo Press enter when in recovery.
pause >NUL
echo.
echo Working...
support_files\adb shell mount /system
support_files\adb shell rm /system/app/DmClient.apk
support_files\adb reboot
echo Done! Phone is rebooting.
PING 1.1.1.1 -n 1 -w 4000 >NUL
GOTO EXTRAS
:blockrooted
echo Waiting for device...
support_files\adb wait-for-device
echo Found!
echo.
echo Working...
support_files\adb remount >NUL
support_files\adb shell rm /system/app/DmClient.apk
support_files\adb reboot
echo.
echo Done! Phone is rebooting.
PING 1.1.1.1 -n 1 -w 4000 >NUL
GOTO EXTRAS
:: ------------

:OTAEnable
cls
echo ------------------------------
echo     OTA Update re-enabler
echo ------------------------------
IF "%adbroot%"=="1" (GOTO enablerooted)
IF NOT EXIST support_files\download\DmClient.apk (
echo Downloading necessary file...
support_files\wget --quiet -O support_files\download\DmClient.apk http://dl.dropbox.com/u/61129367/DmClient.apk
support_files\md5sums support_files\download\DmClient.apk>support_files\download\DmClient.apk.md5
set /p otamd5=<support_files\download\DmClient.apk.md5
IF "%otamd5%" NEQ "CB8B423E04EDEE0C0E3F601E88C9E046  support_files\download\DmClient.apk" (
del support_files\download\DmClient.apk
del support_files\download\DmClient.apk.md5
cls
GOTO OTAEnable
)
echo.
IF EXIST support_files\download\DmClient.apk.md5 (del support_files\download\DmClient.apk.md5)
)
echo Rebooting to recovery...
support_files\adb reboot recovery
echo Press enter when in recovery.
pause >NUL
echo.
echo Working...
support_files\adb shell mount /system
support_files\adb shell rm /system/app/DmClient.apk
support_files\adb reboot
echo.
echo Done! Phone is rebooting.
PING 1.1.1.1 -n 1 -w 4000 >NUL
GOTO EXTRAS
:enablerooted
cls
IF NOT EXIST support_files\download\DmClient.apk (
echo Downloading necessary file...
support_files\wget --quiet -O support_files\download\DmClient.apk http://dl.dropbox.com/u/61129367/DmClient.apk
support_files\md5sums support_files\download\DmClient.apk>support_files\download\DmClient.apk.md5
set /p otamd5=<support_files\download\DmClient.apk.md5
IF "%otamd5%" NEQ "CB8B423E04EDEE0C0E3F601E88C9E046  support_files\download\DmClient.apk" (
del support_files\download\DmClient.apk
del support_files\download\DmClient.apk.md5
cls
GOTO enablerooted
)
IF EXIST support_files\download\DmClient.apk.md5 (del support_files\download\DmClient.apk.md5)
echo.
)
echo Working...
support_files\adb remount >NUL
support_files\adb push support_files\download\DmClient.apk /system/app/DmClient.apk >NUL
support_files\adb shell chmod 644 /system/app/DmClient.apk
support_files\adb reboot
echo.
echo Done! Phone is rebooting.
PING 1.1.1.1 -n 1 -w 4000 >NUL
GOTO EXTRAS

:SUUpdates
cls
IF EXIST support_files\download\su.zip (del support_files\download\su.zip)
echo.
echo Downloading latest SU files...
support_files\wget --quiet -O support_files\download\su.zip http://downloads.androidsu.com/superuser/Superuser-3.0.7-efghi-signed.zip
echo.
echo Prepping phone...
support_files\wget --quiet -O support_files\download\extendedcommand http://dl.dropbox.com/u/61129367/extendedcommand
support_files\adb push support_files\download\extendedcommand /cache/recovery/
support_files\adb push support_files\download\su.zip /sdcard/su.zip
support_files\adb shell "echo install /sdcard/su.zip>/cache/recovery/openrecoveryscript"
del support_files\download\su.zip
del support_files\download\extendedcommand
echo.
echo Rebooting to recovery...
support_files\adb reboot recovery
echo.
echo File will flash and phone will reboot.
PING 1.1.1.1 -n 1 -w 4000 >NUL
GOTO EXTRAS

:bbox
GOTO MAIN

::
:: -----------------------------------------------------------------------
::

:HELP
cls
echo.
echo.
echo HELP
echo --------------------------------------------------------
echo   --Not recognizing the phone?
echo      -Make sure USB Debugging and Stay Awake are
echo       enabled in Settings - Apps - Development.
echo      -Make sure HTC Sync, DoubleTwist, EasyTether,
echo       Droid Explorer, etc. are uninstalled.
echo      -Run Driver.exe, packaged with this.
echo.
echo   --Not downloading anything?
echo      -Make sure to disable PeerBlock.
echo      -You may have a content filter or firewall
echo       that is blocking access.
echo.
echo   --Want to contact or thank me?
echo      -Tweet me, @trter10.
echo      -Email/GTalk me, lukeafrazier@gmail.com
echo      -Buy me a Monster at http://tinyw.in/f340
echo --------------------------------------------------------
echo Press enter to return to the main menu...
pause>NUL
GOTO main
::
:: -----------------------------------------------------------------------
::

:EXIT
IF EXIST support_files\adbroot (del support_files\adbroot)
IF EXIST support_files\bl (del support_files\bl)
IF EXIST support_files\romver (del support_files\romver)
IF EXIST support_files\here (del support_files\here)
IF EXIST support_files\Script-new-MD5.txt (del support_files\Script-new-MD5.txt)
support_files\adb kill-server
exit