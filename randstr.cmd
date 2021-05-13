@echo off
rem v1.1
rem Brendan Silva - 2021/13/05
setlocal enabledelayedexpansion

set /a _l_=%~1+0
if %_l_% lss 1 (
	echo Tries to generates, as soon as possible, a random alphanumeric string.
	echo.
	echo   Syntax:
	echo   %~n0 [length ^(max=8163^)] [array ^|^| *] [prefix] [sufix]
	echo.
	echo   E.g.:
	echo   for /f "delims=" ^%%c in ^('randstr 8 * "set pwd="'^) do ^%%c
	exit /b 1 > nul
)

set /a _l_=!_l_!/26
set _[=abcdefghijklmnopqrstuvwxyz
if not "%~2"=="*" set _#=%~2
if not defined _# (
	set _#=!_[!ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789[]@#$+/?.\-=_*
	set _@=62
	rem set _@=76 > nul
) else for /l %%a in (0,1,255) do (
	if "!_#:~%%a,1!"=="" (
		set _@=%%a
		goto rand
	)
)

:rand
for /l %%@ in (0,1,%_l_%) do (
	for /l %%# in (0,1,25) do set /a "_!_[:~%%#,1!=!random! %% %_@%"
	set /a "_$=%%@>>7"
	for %%$ in (!_$!) do for /f "tokens=1-26" %%a in ("!_a! !_b! !_c! !_d! !_e! !_f! !_g! !_h! !_i! !_j! !_k! !_l! !_m! !_n! !_o! !_p! !_q! !_r! !_s! !_t! !_u! !_v! !_w! !_x! !_y! !_z!") do set _*%%$=!_*%%$!!_#:~%%a,1!!_#:~%%b,1!!_#:~%%c,1!!_#:~%%d,1!!_#:~%%e,1!!_#:~%%f,1!!_#:~%%g,1!!_#:~%%h,1!!_#:~%%i,1!!_#:~%%j,1!!_#:~%%k,1!!_#:~%%l,1!!_#:~%%m,1!!_#:~%%n,1!!_#:~%%o,1!!_#:~%%p,1!!_#:~%%q,1!!_#:~%%r,1!!_#:~%%s,1!!_#:~%%t,1!!_#:~%%u,1!!_#:~%%v,1!!_#:~%%w,1!!_#:~%%x,1!!_#:~%%y,1!!_#:~%%z,1!
)

for /l %%$ in (0,1,%_$%) do set _*=!_*!!_*%%$!
echo.%~3!_*:~-%~1!%~4
