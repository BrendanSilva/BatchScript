@echo off
rem Written by Brendan Silva
rem To run this script, you must have the "DEBUG.EXE" executable on your system.
setlocal enabledelayedexpansion
set /a _er=0
set /a _n=0
set _ln=%~4
goto init

:howtouse

	echo.
	echo ECOL.BAT v2.1 - Brendan Silva
	echo Print colored text using "DEBUG.EXE".
	echo.
	echo Syntax:
	echo   ECOL.BAT [COLOR] [X] [Y] "Insert your text here."
	echo   COLOR must be a hexadecimal number ^("color /?"^).
	echo.
	echo E.g.:
	echo   ECOL.BAT F0 20 30 "640K ought to be enough for anybody."
	echo.
	goto :eof

:error
	set /a "_er=_er | (%~1)"
	goto :eof

:gcnvhx
	set _cvhx=
	set /a _cvint=%~1

:cnvhx
	set /a "_gch = _cvint & 0xF"
	set _cvhx=!nsys:~%_gch%,1!%_cvhx%
	set /a "_cvint = _cvint >> 4"
	if !_cvint! neq 0 goto cnvhx
	goto :eof

:init
	if "%~4"=="" goto howtouse
	(
		set /a _cl=0x%1
		call :error !errorlevel!
		set _cl=%1
		call :error "0x!_cl! ^>^> 8"
		set /a _px=%2
		call :error !errorlevel!
		set /a _py=%3
		call :error !errorlevel!
	) 2>nul 1>&2
	if !_er! neq 0 (
		echo.
		echo ERROR: value exception "!_er!" occurred. Check memory out.
		echo.
		goto howtouse
	)
	set nsys=0123456789ABCDEF
	set /a cnb=0
	set /a cnl=0
	set _cvhx=0
	set _cvint=0
	set _cvmhx=0

:parse
	set _ch=!_ln:~%_n%,1!
	if "%_ch%"=="" goto perform
	set /a "cnb += 1"
	if %cnb% gtr 7 (
		set /a cnb=0
		set /a "cnl += 1"
	)
	set bln%cnl%=!bln%cnl%! "!_ch!" %_cl%
	set /a "_n += 1"
	goto parse

:perform
	set /a "in = ((_py * 0xA0) + (_px << 1)) & 0xFFFF"
	call :gcnvhx %in%
	set ntr=!_cvhx!
	set /a jmp=0xe
	set _outstr=echo.h 0 0
	@for /l %%x in (0,1,%cnl%) do (
		set _outstr=!_outstr!^&echo.eb800:!ntr! !bln%%x!
		set /a "in=!jmp! + 0x!ntr!"
		call :gcnvhx !in!
		set ntr=!_cvhx!
		set /a jmp=0x10
	)
	(
	echo %_outstr%
	echo.q
	) |debug >nul 2>&1