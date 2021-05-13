@echo off
setlocal
rem v1.1
rem Brendan Silva - 2021/13/05
if "%~1"=="joy" goto joystick

	(echo 0) > snake_input.txt 2>nul
	if %errorlevel% neq 0 (
		echo Error: running from protected or non-writable storage.
		pause > nul
		goto :eof
	)

	choice /c:0 < snake_input.txt > nul 2>nul
	if not "%errorlevel%"=="1" (
		echo You need choice.com or choice.exe to run this game.
		if exist snake_input.txt erase /q snake_input.txt 2>&1
		pause > nul
		goto :eof
	)

endlocal
setlocal enabledelayedexpansion
mode con: cols=66 lines=28
cls

echo.
echo ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
echo ±ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±
echo ±³                                               ³±
echo ±³    ####   ##   #    ####    ###  ##  #######  ³±
echo ±³   ### ##  ###  ##  ### ##   ### ##   ###  ##  ³±
echo ±³  ###      ###  ##  ###  ##  #####    ###      ³±
echo ±³   #####   #### ##  ###  ##  ####     ######   ³±
echo ±³       ##  #######  #######  #####    ###      ³±
echo ±³   ##  ##  ### ###  ###  ##  ### ##   ###  ##  ³±
echo ±³   #####   ###  ##  ###  ##  ###  ##  #######  ³±
echo ±³                                               ³±
echo ±³        #####    ####    ### ##   #######      ³±
echo ±³       ###  ##  ### ##   ### ###  ###  ##      ³±
echo ±³       ###      ###  ##  #######  ###          ³±
echo ±³       ### ###  ###  ##  #### ##  ######       ³±
echo ±³       ###  ##  #######  ###  ##  ###          ³±
echo ±³       #######  ###  ##  ###  ##  ###  ##      ³±
echo ±³        #####   ###  ##  ###  ##  #######      ³±
echo ±³                                               ³±
echo ±³                                 Brendan Silva ³±
echo ±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±
echo ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
echo.

set /p "hgrid=Board width: "
set /a hgrid=%hgrid%+0 >nul 2>nul
if %hgrid% lss 12 set hgrid=12
if %hgrid% gtr 24 set hgrid=24

set /p "vgrid=Board height: "
set /a vgrid=%vgrid%+0 >nul 2>nul
if %vgrid% lss 12 set vgrid=12
if %vgrid% gtr 24 set vgrid=24

set /a "hwin=%hgrid% + 5"
set /a "vwin=%vgrid% + 8"

mode con: cols=%hwin% lines=%vwin%
set /a "result = hgrid * vgrid"
set /a "instx = hgrid / 2"
set /a "insty = vgrid / 2"
set /a "timer = 2000 - (hgrid * vgrid)/2"
set /a ppoint=%result%
set /a arraylimit=0
set /a arraybody=0
set /a score=0
set brd2=±±±±
for /l %%a in (1,1,%hgrid%) do (
	set brd1=!brd1!Ä
	set brd2=!brd2!±
)

type nul>snake_input.txt
start cmd /c "%~dpnx0" joy
title Score=0

:ppointer
	set /a "point = hgrid + 2 + (!random! %% (vgrid - 2)) * hgrid + (!random! %% (hgrid - 2))"

:repaint
	for /l %%a in (1,1,%ppoint%) do set "px%%a= "
	set px%point%=

:paused
	(set /p keypressed=<snake_input.txt) >nul 2>nul
	if "%keypressed%"=="p" (
		title PAUSED
		timeout 1 > nul 2>nul
		goto paused
	)
	if "%keypressed%"=="w" set /a "insty -= 1"
	if "%keypressed%"=="s" set /a "insty += 1"
	if "%keypressed%"=="a" set /a "instx -= 1"
	if "%keypressed%"=="d" set /a "instx += 1"
	if "%keypressed%"=="q" goto endgame

	set /a "result = insty * %hgrid% + instx"
	set "px%result%="

	if %insty% lss 0 goto endgame
	if %instx% leq 0 goto endgame
	if %insty% geq %vgrid% goto endgame
	if %instx% gtr %hgrid% goto endgame

	if %arraylimit% gtr 0 (
		for /l %%a in (%arraylimit%,-1,2) do (
			set /a "decpb = (%%a - 1)"
			set value=pbody!decpb!
			set /a "pbody%%a = !!value!!"
			if !result! equ !pbody%%a! goto endgame
		)
		set /a "pbody1=!lastpos!"
	)

	set /a "lastpos = %result%"
	for /l %%a in (1,1,%arraylimit%) do (
		set /a "decpb=!pbody%%a!"
                set px!decpb!=
	)

	if %result% equ %point% (
		set /a "arraylimit += 1"
		set /a "score += 100"
		set /a "timer -= 20"
		goto ppointer
	)
	title Score=%score%

	set _c=2
	set _line0=%brd2%
	set _line1=±Ú%brd1%¿±
	for /l %%a in (1,1,%vgrid%) do (
		set plot=
		for /l %%b in (1,1,%hgrid%) do (
			set /a "result = (%%a - 1) * %hgrid% + %%b"
			for /f %%c in ("px!result!") do set inc=!%%c!
			set plot=!plot!!inc!
		)
		set _line!_c!=±³!plot!³±
		set /a _c+=1
	)

	set _line!_c!=±À%brd1%Ù±
	set /a _c+=1
	set _line!_c!=%brd2%
	color 3f 2>nul
	cls

	(
		for /l %%c in (0,1,!_c!) do echo !_line%%c!
	)

	for /l %%a in (1,1,%timer%) do echo.> nul
	goto repaint

:endgame
	for /l %%i in (1,1,3) do (
		color 4f&for /l %%j in (1,1,250) do echo.>nul
		color 3f&for /l %%j in (1,1,250) do echo.>nul
	)
	echo.
	echo Game over^^!
	echo Score: %score%
	endlocal
	pause > nul
	if exist snake_input.txt erase /q snake_input.txt 2>&1
	goto :eof

:joystick
	@echo off
	title Joystick
	mode con cols=34 lines=18
	color 84 2>nul
	setlocal enabledelayedexpansion
	set _control_=wasdpq
	echo ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	echo ³ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ³
	echo ³ÛÛÛÛÛÛÚÄÄÄ¿ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ³
	echo ³ÛÛÛÛÛÛ³±°°³ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ³
	echo ³ÛÛÛÛÛÛ³±W°³ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ³
	echo ³ÛÛÛÛÛÛ³±±°³ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ³
	echo ³ÛÛÚÄÄÄÙ±±°ÀÄÄÄ¿ÛÛÛÚÄÄÄ¿ÛÚÄÄÄ¿ÛÛ³
	echo ³ÛÛ³°°°°±±±°°°°³ÛÛÛ³±°°³Û³±°°³ÛÛ³
	echo ³ÛÛ³±A±±±±±±±D²³ÛÛÛ³±Q²³Û³±P²³ÛÛ³
	echo ³ÛÛ³²²²²±±±²²²²³ÛÛÛ³²²²³Û³²²²³ÛÛ³
	echo ³ÛÛÀÄÄÄ¿±±²ÚÄÄÄÙÛÛÛÀÄÄÄÙÛÀÄÄÄÙÛÛ³
	echo ³ÛÛÛÛÛÛ³±±²³ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ³
	echo ³ÛÛÛÛÛÛ³±S²³ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ³
	echo ³ÛÛÛÛÛÛ³²²²³ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ³
	echo ³ÛÛÛÛÛÛÀÄÄÄÙÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ³
	echo ³ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ³
	echo ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

:input
	choice /c:%_control_% /n >nul 2>nul
	set /a _input_=%errorlevel%-1
	(
	echo !_control_:~%_input_%,1!
	) > snake_input.txt
	if not "%_input_%"=="5" goto input
