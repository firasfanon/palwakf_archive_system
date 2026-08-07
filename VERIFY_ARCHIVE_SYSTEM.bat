@echo off
setlocal EnableExtensions
title PalWakf Evidence Archive - Canonical Verification

set "ROOT=%~dp0"
set "LOGDIR=%ROOT%logs"
set "LOGFILE=%LOGDIR%\archive_system_verify.log"

if not exist "%LOGDIR%" mkdir "%LOGDIR%" >nul 2>&1

where flutter >nul 2>&1
if errorlevel 1 goto :flutter_missing

if not exist "%ROOT%pubspec.yaml" goto :missing_root
if not exist "%ROOT%lib\main.dart" goto :missing_root
if not exist "%ROOT%lib\src\app.dart" goto :missing_root

pushd "%ROOT%"
python tools\verify_module_reception_static.py > "%LOGFILE%" 2>&1
if errorlevel 1 goto :fail

flutter pub get >> "%LOGFILE%" 2>&1
if errorlevel 1 goto :fail

dart format --output=none --set-exit-if-changed lib test >> "%LOGFILE%" 2>&1
if errorlevel 1 goto :fail

flutter analyze >> "%LOGFILE%" 2>&1
if errorlevel 1 goto :fail

flutter test >> "%LOGFILE%" 2>&1
if errorlevel 1 goto :fail

popd
echo.
echo VERIFY_ARCHIVE_SYSTEM=PASS
echo CANONICAL_RUNTIME_ROOT=PASS
echo SOURCE_ANALYSIS=PASS
echo UNIT_TESTS=PASS
echo PLATFORM_MUTATION=NONE
echo DATABASE_MUTATION=NONE
pause
exit /b 0

:flutter_missing
echo [ERROR] Flutter غير موجود في PATH.
pause
exit /b 1

:missing_root
echo [ERROR] الجذر غير معتمد أو الحزمة غير مكتملة.
pause
exit /b 1

:fail
popd
echo.
echo [ERROR] التحقق فشل. لن يتم اعتماد الحزمة.
echo راجع: %LOGFILE%
pause
exit /b 1
