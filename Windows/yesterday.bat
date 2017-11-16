@ECHO OFF

REM get yesterday's date of parameter #1: %1
REM REMoveq qoutes from parameter by saying ~
SET lastday=%~1

SET yyyy=
SET tok=1-3
FOR /F "usebackq tokens=1 delims=.:/-, " %%u IN ('%lastday%') DO SET d1=%%u
IF "%d1:~0,1%" GTR "9" SET tok=2-4

FOR /F "usebackq tokens=%tok% delims=.:/-, " %%u IN ('%lastday%') DO (
	FOR /F "skip=1 tokens=2-4 delims=/-,()." %%x IN ('echo.^|date') DO (
		SET %%x=%%u
		SET %%y=%%v
		SET %%z=%%w
		SET d1=
		SET tok=
	)
)

IF "%yyyy%"=="" SET yyyy=%yy%
IF /I %yyyy% LSS 100 SET /A yyyy=2000 + 1%yyyy% - 100

REM IF %dd% LSS 10 SET dd=0%dd%
REM IF %mm% LSS 10 SET mm=0%mm%

SET /A dd=1%dd% - 100 - 1
SET /A mm=1%mm% - 100

:CHKDAY
IF /I %dd% GTR 0 GOTO DONE

SET /A mm=%mm% - 1
IF /I %mm% GTR 0 GOTO ADJUSTDAY
SET /A mm=12
SET /A yyyy=%yyyy% - 1

:ADJUSTDAY
IF %mm%==1 GOTO SET31
IF %mm%==2 GOTO LEAPCHK
IF %mm%==3 GOTO SET31
IF %mm%==4 GOTO SET30
IF %mm%==5 GOTO SET31
IF %mm%==6 GOTO SET30
IF %mm%==7 GOTO SET31
IF %mm%==8 GOTO SET31
IF %mm%==9 GOTO SET30
IF %mm%==10 GOTO SET31
IF %mm%==11 GOTO SET30
REM ** Month 12 falls through

:SET31
SET /A dd=31 + %dd%
GOTO CHKDAY

:SET30
SET /A dd=30 + %dd%
GOTO CHKDAY

:LEAPCHK
SET /A tt=%yyyy% %% 4
IF NOT %tt%==0 GOTO SET28
SET /A tt=%yyyy% %% 100
IF NOT %tt%==0 GOTO SET29
SET /A tt=%yyyy% %% 400
IF %tt%==0 GOTO SET29

:SET28
SET /A dd=28 + %dd%
GOTO CHKDAY

:SET29
SET /A dd=29 + %dd%
GOTO CHKDAY

:DONE
IF /I %mm% LSS 10 SET mm=0%mm%
IF /I %dd% LSS 10 SET dd=0%dd%
SET yesterday=%yyyy%-%mm%-%dd%
