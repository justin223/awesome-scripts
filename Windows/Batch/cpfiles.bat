SET CurrentDir="%CD%"
ECHO %CurrentDir%

SET CHANNELS=CH411*.wav CH412*.wav CH413*.wav CH414*.wav CH415*.wav CH416*.wav CH417*.wav CH418*.wav CH419*.wav CH420*.wav CH181*.wav CH182*.wav CH185*.wav CH186*.wav

REM specify date range
SET LOWERDATE=2017-02-19
SET HIGHERDATE=11/01/2017

SET yyyy=

TYPE NUL > "%USERPROFILE%\cpfiles.txt"

ECHO Generating files to copy...
CALL "%CurrentDir%\yesterday.bat" "%HIGHERDATE%"

:LOOPUNTIL
REM jump into mapped network drive - the source files we need to filter & copy from
Z:
ECHO %yesterday%
CD %yesterday%
DIR /S /B %CHANNELS% >> "%USERPROFILE%\cpfiles.txt"
CD \
FOR /F "usebackq tokens=1-3 delims=-" %%u IN ('%yesterday%') do (
	SET yy=%%u
	SET mm=%%v
	SET dd=%%w
)
IF "%yyyy%"=="" SET yyyy=%yy%
SET yesterday=%mm%/%dd%/%yyyy%
CALL "%CurrentDir%\yesterday.bat" "%yesterday%"
IF NOT %yesterday% == %LOWERDATE% GOTO LOOPUNTIL

ECHO Copying files...
SETLOCAL EnableDelayedExpansion
FOR /F "usebackq delims=" %%A IN ("%USERPROFILE%\cpfiles.txt") DO (
	ECHO %%A
	SET filep=%%~dpA
	SET filep=!filep:~0,-1!
	ECHO !filep!
	
	FOR /F "usebackq tokens=2 delims=:" %%B IN ('!filep!') do (
		ECHO %%B
		IF NOT EXIST D:\WavRecords\%%B MKDIR D:\WavRecords\%%B
		XCOPY %%A D:\WavRecords\%%B /K /Y /C
	)
)
ENDLOCAL

PAUSE
