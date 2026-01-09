@echo off
REM Build script for The Computer Fair Heist
REM Compiles to Z3 format for TRS-80 Model 4 with M4ZVM

echo Building The Computer Fair Heist...
echo Target: Z-code version 3 (optimized for TRS-80)
echo.

REM Set version manually (update this when BUILD_NUMBER changes in .inf file)
set VERSION=28

set OUTPUT=heist%VERSION%.z3

echo Version: %VERSION%
echo Output file: %OUTPUT%
echo.

REM Call inform6 with PunyInform library path
inform6 +"C:\Program Files (x86)\PunyInform-6_3_1\lib" -v3 computer-fair-heist.inf %OUTPUT%

if %ERRORLEVEL% EQU 0 (
    echo.
    echo Build successful!
    echo Output file: %OUTPUT%
    for %%F in (%OUTPUT%) do echo Size: %%~zF bytes
    echo.
    echo To test: frotz %OUTPUT%
    echo To deploy: copy %OUTPUT% ..\gotek-disks\
) else (
    echo.
    echo Build failed!
    exit /b 1
)
