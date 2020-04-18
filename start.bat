@echo off
title X6815 bios flasher by trueToastedCode

REM Permission
echo # Checking permission #
net session >nul 2>&1
	if not %errorLevel% == 0 (
		echo Failure: This program requires administrator rights.
		goto :end
	)
	echo Ok
echo.

REM Conditions
echo # Conditions #
echo.
echo   .--.
echo  ,.-. '-----------.
echo  ^|  ^|              ,
echo  ''-' .--"--""-"-,'
echo   '--'
echo.

echo.
echo (1) I assume no liability for damages of any kind!
echo.
echo (2) Use this script at your OWN RISK. It NOT OFFICIAL and might damage you system PERMANENTLY. It has been tested ONLY on a Medion X6815 Laptop and should never be used on any other model.
echo.
echo (3) Before using this program, create a backup of your current bios using Universal BIOS Backup ToolKit and SAVE it OUSIDE your device (https://www.majorgeeks.com/files/details/universal_bios_backup_toolkit.html).
echo.

echo (Waiting 10s)
ping 127.0.0.1 -n 11 > nul

set /p input="Do you accept the conditions (Y/N) -> "
if not %input% == Y if not %input% == y (
	echo If wan't to use this tool, you have to accept the conditions!
	goto :end
)
echo.

REM art
cls
echo.
echo	        ____________________________
echo	       /                           /\
echo	      /   X6815 BIOS FLASHER   _/ /\
echo	     /    by trueToastedCode     / \/
echo	    /            V1             /\
echo	   /___________________________/ /
echo	   \___________________________\/
echo	    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \
echo.
echo.

REM Select file
:file
echo # Select file #
echo (1) AmericanMegatrendsInc.-206
echo (2) AmericanMegatrendsInc.-207
echo (3) Other
echo (4) About

set /p input="-> "
if %input% == 1 (
	set fname=AmericanMegatrendsInc.-206.rom
	set costum=false
)else if %input% == 2 (
	set fname=AmericanMegatrendsInc.-207.rom
)else if %input% == 3 (
	set /p fname="Enter filename (file must be in this folder) -> "
)else if %input% == 4 (
	cls
	echo.
	echo   /$$$$$$            /$$$$$$         
	echo  ^|_  $$_/           /$$__  $$        
	echo    ^| $$   /$$$$$$$ ^| $$  \__//$$$$$$ 
	echo    ^| $$  ^| $$__  $$^| $$$$   /$$__  $$
	echo    ^| $$  ^| $$  \ $$^| $$_/  ^| $$  \ $$
	echo    ^| $$  ^| $$  ^| $$^| $$    ^| $$  ^| $$
	echo   /$$$$$$^| $$  ^| $$^| $$    ^|  $$$$$$/
	echo  ^|______/^|__/  ^|__/^|__/     \______/
	echo.
	echo The X6815 bios flasher is a reverse engineered and modyfied version of the bios updater for 107. Actually this tool it 99,99% the same, the modyfication is a single jump command to skip the part where the updated bios gets written into a file. By placing another file into the folder effect the flash tool to load this file instead. Also it is worth to remark, that the flash tool is a modyfied version of Asus WinFlash.
	echo.
	pause
	cls
	goto :file
)else (
	echo Option %input% does not exist!
	echo.
	goto :file
)

set path=%~p0
set ori=%path%%fname%

if not exist %ori% (
	echo %ori% does not exist!
	echo.
	goto :file
)
echo.

set des=C:\Users\%USERNAME%\AppData\Local\Temp\

REM Delete existing BIOS.bin
if exist %des%BIOS.bin (
	echo Delete already existing %des%BIOS.bin.
	del %des%BIOS.bin
	if exist %des%BIOS.bin (
		goto :failure
	)
	echo Ok
)

REM Copy file
echo ^Copy %ori% -^> %des%
copy %ori% %des%
if not exist %des%%fname% (
	goto :failure
)
echo Ok

REM Rename file
echo Rename %fname% -^> BIOS.bin
ren %des%%fname% BIOS.bin
if not exist %des%BIOS.bin (
	goto :failure
)
echo Ok
echo.

REM Prepare for flash
echo # Flash #
echo.
echo The bios flash process will now start. CLOSE EVERY PROGRAM! You don't wan't to risk a bluescreen..
set /p input="Start (Y/N) -> "
if not %input% == Y if not %input% == y (
	echo Abort
	goto :end
)


REM Launch
for /L %%A in (5,-1,0) do (
	echo %%A
	ping 127.0.0.1 -n 2 > nul
)

echo launching..
"%path%X6815_BIOS_FLASHER.EXE" /NODATE
goto :end

:failure
echo Failure

:end
pause