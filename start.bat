@echo off
title X6815 bios flasher by trueToastedCode

:: BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
    IF "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
>nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) ELSE (
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params= %*
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params:"=""%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------   

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
echo (2) Use this script at your OWN RISK. It IS NOT OFFICIAL and might damage you system PERMANENTLY. It has been tested ONLY on a Medion X6815 Laptop and should never be used on any other model.
echo.
echo (3) Before using this program, create a backup of your current bios using Universal BIOS Backup ToolKit and SAVE it OUSIDE your device (https://www.majorgeeks.com/files/details/universal_bios_backup_toolkit.html).
echo.

set /p input="Do you accept the conditions (Y/N) -> "
if not %input% == Y if not %input% == y (
	echo If wan't to use this tool, you have to accept the conditions!
	goto :end
)
echo.

:file
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
echo # Select file #
echo (1) AmericanMegatrendsInc.-206 *(Stock)
echo (2) AmericanMegatrendsInc.-207 *(Added Win8, Win10 support)
echo (3) AmericanMegatrendsInc.-207-Unlocked *(Modded version, many hidden options unlocked)
echo (4) Other
echo (5) About

:file2
set /p input="-> "
if %input% == 1 (
	set fname=AmericanMegatrendsInc.-206.rom
	set costum=false
)else if %input% == 2 (
	set fname=AmericanMegatrendsInc.-207.rom
)else if %input% == 3 (
	set fname=AmericanMegatrendsInc.-207-Unlocked.rom
)else if %input% == 4 (
	set /p fname="Enter filename (file must be in this folder) -> "
	if "%fname%." == "." (
		echo Filename is empty!
		goto file2
	)
)else if %input% == 5 (
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
	echo.
	echo The X6815 bios flasher is a reverse engineered and modyfied version of the bios updater for 107. Actually this tool it 99,99% the same, the modyfication is a single jump command to skip the part where the updated bios gets written into a file. By placing another file into the folder effects the flash tool to load this file instead. Also it is worth to remark, that the flash tool is a modyfied version of the Asus WinFlash tool.
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
	pause
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
echo CLOSE EVERY PROGRAM! DISCONNCET ALL USB DEVICES! You don't wan't to risk a bluescreen.
echo Hint: If message bios cannot be updated, try to restart this program
set /p input="Start (Y/N) -> "
if not %input% == Y if not %input% == y (
	echo Abort
	goto :end
)

REM Launch
"%path%X6815_BIOS_FLASHER.EXE" /FORCE
goto :end

:failure
echo Failure

:end
pause
