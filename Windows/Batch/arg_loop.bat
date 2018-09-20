@echo on

rem for %%i in (27 28 29) do call :COPYLOOP %%i
for %%i in (27,1,29) do call :COPYLOOP %%i
goto :EOF

:COPYLOOP
if exist Z: goto Delete_Z

:Map_Z
net use Z: \\2.2.2.%1\share pwd /user:HOST%1\user /persistent:yes
goto End_Map_Z

:Delete_Z
net use Z: /delete /yes
net use \\2.2.2.%1\ipc$ /delete /yes
goto Map_Z

:End_Map_Z
xcopy d:\share z: /s /k /d /y /c
