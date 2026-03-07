@ECHO OFF

SET PGOPTIONS=--enable-version3

REM Store current directory and ensure working directory is the location of current .bat
SET CURRDIR=%CD%
cd %~dp0

REM Initialise error check value
SET ERROR=0

REM Check if executable can be located
IF NOT EXIST "project_generate.exe" (
    ECHO "Error: FFVS Project Generator executable file not found."
    IF EXIST "../.git" (
        ECHO "Please build the executable using the supplied project before continuing."
    )
    GOTO exitOnError
)

REM Check if FFmpeg directory can be located
SET SEARCHPATHS=(./, ../, ./ffmpeg/, ../ffmpeg/, ../../ffmpeg/, ../../../, ../../, ./source/ffmpeg, ../source/ffmpeg, ../../source/ffmpeg/)
SET FFMPEGPATH=
FOR %%I IN %SEARCHPATHS% DO (
    IF EXIST "%%I/ffmpeg.h" (
        SET FFMPEGPATH=%%I
    )
    IF EXIST "%%I/fftools/ffmpeg.h" (
        SET FFMPEGPATH=%%I
    )
)
IF "%FFMPEGPATH%"=="" (
    ECHO Error: Failed finding FFmpeg source directory
    GOTO exitOnError
) ELSE (
    ECHO Located FFmpeg source directory at "%FFMPEGPATH%"
    ECHO.
)

REM Run the executable
ECHO Running project generator...
project_generate.exe %PGOPTIONS%
GOTO exit

:exitOnError
SET ERROR=1

:exit
REM Check if this was launched from an existing terminal or directly from .bat
REM  If launched by executing the .bat then pause on completion
cd %CURRDIR%
ECHO %CMDCMDLINE% | FINDSTR /L %COMSPEC% >NUL 2>&1
IF %ERRORLEVEL% == 0 IF "%~1"=="" PAUSE
EXIT /B %ERROR%