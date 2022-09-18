@echo off

title Auto RetroArch Playlist Maker

set "_folder=%~n1"

if "%_folder%"=="" (
	title ERROR
	echo DRAG AND DROP THE ROMs FOLDER TO THIS .BAT SCRIPT
	pause & exit
)

if not exist "%_folder%\" (
	title ERROR
	echo NOT A VALID FOLDER
	pause&exit
)

set "_home=%~dp0"
SETLOCAL EnableDelayedExpansion
call :show_menu
cls
SETLOCAL DisableDelayedExpansion

if not exist "%_home%\_arcade\arcade.txt" set "_arcade="


(echo {
 echo   "version": "1.0",
 echo   "items": [) >"%_folder%.lpl"

for /f "delims=" %%g in ('dir /s /b /a:-d /o:n "%_folder%\*"') do (
	echo %%~ng
	call :get_path "%%g" "%%~nxg"
	

) 

(echo   ]
 echo }) >>"%_folder%.lpl"



(
echo Option Explicit
echo Dim objFso, objOtF, cd,  content
echo Set objFso = CreateObject^("Scripting.FileSystemObject"^)
echo cd = "%_folder%.lpl"
echo Set objOtF = objFso.OpenTextFile^(cd, 1^)
echo content = objOtF.ReadAll
echo objOtF.Close
echo Set objOtF = objFso.OpenTextFile^(cd, 2^)
echo objOtF.Write Replace^(content, chr^(013^), ""^)
echo objOtF.Close
echo wscript.echo "Complete."
) >"%temp%\temp.vbs"


cscript /nologo "%temp%\temp.vbs"


title FINISHED
pause & exit

:get_path

SETLOCAL EnableDelayedExpansion
set "_path=%~dp1"
set "_path=!_path:%cd%\=!" & set "_path=D:\\roms\\!_path:\=\\!"

set _flag=0
if not "%_arcade%"=="" (
	findstr /b /c:"%~n1|" "%_home%\_arcade\arcade.txt" >nul 2>&1
	if !errorlevel!==0 set _flag=1
	REM if !_flag!==0 exit /b
)


SETLOCAL DisableDelayedExpansion


(echo     {
 echo       "path": "%_path%%~2",) >>"%_folder%.lpl"
 
if %_flag%==1 (
	for /f "tokens=2 delims=|" %%h in ('findstr /b /c:"%~n1|" "%_home%\_arcade\arcade.txt"') do (echo       "label": "%%h",) >>"%_folder%.lpl"
	
) else (
	(echo       "label": "%~n1",) >>"%_folder%.lpl"

) 

(echo       "core_path": "%_core2%",
echo       "core_name": "%_core%",
echo       "crc32": "DETECT",
echo       "db_name": "%_folder%.lpl"
echo     },) >>"%_folder%.lpl"


exit /b


:show_menu

(echo Auto Detect ^(Default^)
echo Arcade ^(FB Alpha 2012 CPS-1^)
echo Arcade ^(FB Alpha 2012 CPS-2^)
echo Arcade ^(FB Alpha 2012 Neo Geo^)
echo Nintendo - Game Boy / Color ^(Gambatte^)
echo Sega - MS/GG/MD/CD ^(Genesis Plus GX Wide^)
echo Sega - MS/GG/MD/CD ^(Genesis Plus GX^)
echo Nintendo - Game Boy Advance ^(GPSP 2022^)
echo Nintendo - Game Boy Advance ^(GPSP^)
echo Atari - Lynx ^(Handy^)
echo NEC - PC Engine / CD ^(Beetle PCE FAST^)
echo NEC - PC Engine SuperGrafx ^(Mednafen SuperGrafx^)
echo Bandai - WonderSwan/Color ^(Beetle Cygne^)
echo Nintendo - Game Boy Advance ^(mGBA^)
echo NEC - PC-FX ^(Beetle PC-FX^)
echo SNK - Neo Geo Pocket / Color ^(Beetle NeoPop^)
echo Nintendo - NES / Famicom ^(Nestopia UE^)
echo Sega - MS/GG ^(SMS Plus GX^)
echo Nintendo - SNES / Famicom ^(Snes9x 2005 Plus^)
echo Nintendo - SNES / Famicom ^(Snes9x 2005^)
echo Nintendo - SNES / Famicom ^(Snes9x 2010^)
echo Nintendo - Game Boy Advance ^(VBA 1.7.2^)
echo Nintendo - Game Boy Advance ^(VBA Next^)) >"%temp%\index.1"

echo --------------------------------------------------
echo * Choose an Option, or 'Enter' to use Default   *
echo --------------------------------------------------
echo.

set /a "_count=0"
for /f "usebackq delims=" %%g in ("%temp%\index.1") do (
	set /a "_count+=1"
	echo !_count!. %%g
)
echo.
set /p "_opt=Enter Option Number: " || set "_opt=1"

if "%_opt%"=="1" (
	set "_core=DETECT"
	set "_core2=DETECT"
	exit /b
)

REM // get user option
set /a "_count=0"
set "_core="
for /f "usebackq delims=" %%g in ("%temp%\index.1") do (
	set /a "_count+=1"
	if "!_count!"=="%_opt%" set "_core=%%g"
)

if "%_core%"=="" (
	echo INVALID OPTION & timeout 2 >nul
	cls
	goto show_menu
)


(echo fba cps1
echo fba cps2
echo fba neogeo
echo gambatte
echo genesis plus gx wide
echo genesis plus gx
echo gpsp 2022
echo gpsp
echo handy
echo mednafen pcefast
echo mednafen supergrafx
echo mednafen swan
echo mgba
echo nec pcfx
echo neo geo pocket
echo nestopia
echo sms Plus Gx
echo snes9x 2005 Plus
echo snes9x 2005
echo snes9x 2010
echo vba 1.7.2
echo vba next) >"%temp%\index.1"



set /a "_count=1"
set "_core2="
for /f "usebackq delims=" %%g in ("%temp%\index.1") do (
	set /a "_count+=1"
	if "!_count!"=="%_opt%" set "_core2=%%g"
)


del "%temp%\index.1"
set "_arcade="
if not "%_core%"=="%_core:Arcade=%" set "_arcade=%_core2%"


set "_core2=D:\\%_core2%.xbe"



if "%_arcade%"=="" exit /b
cls
echo --------------------------------------------------
echo * Choose an Option, or 'Enter' to use Default   *
echo --------------------------------------------------
echo 1. Use long titles names
echo 2. Use short zip names ^(supports screen shots^)
echo.
set /p "_opt=Enter Option Number: " || set "_opt=1"
if %_opt%==2 set "_arcade="


exit /b

