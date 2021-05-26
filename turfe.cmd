@echo off
if not "%~1"=="" goto start
echo.
echo 北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
echo 壁哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪勘
echo 背                                                        潮
echo 背  **********  **     **  *******    ********  ********  潮
echo 背 /////**///  /**    /** /**////**  /**/////  /**/////   潮
echo 背     /**     /**    /** /**   /**  /**       /**        潮
echo 背     /**     /**    /** /*******   /*******  /*******   潮
echo 背     /**     /**    /** /**///**   /**////   /**////    潮
echo 背     /**     /**    /** /**  //**  /**       /**        潮
echo 背     /**     //*******  /**   //** /**       /********  潮
echo 背     //       ///////   //     //  //        ////////   潮
echo 背                                                        潮
echo 背                                          Brendan Silva 潮
echo 崩哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦
echo 北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
echo.
echo   Syntax:
echo   %~n0 [number of players] [initials pl1] [initials pl2] ...
echo.
echo   E.g.:
echo   %~n0 3 Me You CPU
goto :eof

:start
	setlocal enabledelayedexpansion
	set /a _players_=0+%~1 >nul 2>nul
	if %_players_% lss 2 set /a _players_=2
	set _h_=0
	set _f_=0
	set _t_=500000

:players
	set /a _h_+=1
	if not "%~2"=="" set "_h%_h_%n_=..%~2"
	if not defined _h%_h_%n_ set _h%_h_%n_=00%_h_%
	set _h%_h_%n_=!_h%_h_%n_:~-3!
	shift
	if %_h_% lss %_players_% goto players

for /l %%a in (1,1,20) do (
	set "_scrn_=!_scrn_!   "
	set _trck_=!_trck_!====
)

set "_b1_=            ~ ~._"
set "_b2_=   _______.~~/___}"
set "_b3_=~~[   \NNN/  /"
set "_b4_=   \__----__/"
set "_l01_=     l\_   \''\"
set "_l02_=     \      \"
set "_l11_=   / l    / \"
set "_l12_=  /   \   \  l"
set "_l21_=  \/ l    _\ \"
set "_l22_=    /        /"

:race
	cls
	set /a "_f_ = (_f_ + 1) %% 3"
	for /l %%h in (1,1,!_players_!) do (
		set /a "_h%%hp_+=(1!random:~-1!!random:~-1!-100)<<1"
		set /a _h%%hr_=1+!_h%%hp_!/100
		for /f %%v in ("!_h%%hr_!") do (
			for /l %%f in (1,1,4) do (
				if %%f equ 3 (
					set _n_=!_b%%f_!
					for /f %%n in ("!_h%%hn_!") do set _n_=!_n_:NNN=%%n!
					echo !_scrn_:~0,%%v!!_n_!
				) else echo !_scrn_:~0,%%v!!_b%%f_!
			)
			for /l %%f in (1,1,2) do echo !_scrn_:~0,%%v!!_l%_f_%%%f_!
		)
		echo %_trck_:~0,-1%
		if !_h%%hp_! geq 6000 if not defined _winner_ set _winner_=!_h%%hn_!
	)
	if defined _winner_ (
		echo.
		echo ----- The winner is: !_winner_! -----
		goto :eof
	)
	for /l %%d in (1,1,%_t_%) do rem
	if %_t_% equ 500000 set /a _t_/=10

goto race