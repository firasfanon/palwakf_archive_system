@echo off
setlocal EnableExtensions EnableDelayedExpansion
title PalWakf Evidence Archive - Local Runtime

set "ROOT=%~dp0"
set "LOGDIR=%ROOT%logs"
set "LOGFILE=%LOGDIR%\archive_system_start.log"

if not exist "%LOGDIR%" mkdir "%LOGDIR%" >nul 2>&1

echo ============================================================ > "%LOGFILE%"
echo PalWakf Evidence Archive ^& Spatial Explorer - Canonical Local Runtime >> "%LOGFILE%"
echo ============================================================ >> "%LOGFILE%"

where flutter >nul 2>&1
if errorlevel 1 goto :flutter_missing

if not exist "%ROOT%pubspec.yaml" goto :missing_root
if not exist "%ROOT%lib\main.dart" goto :missing_root
if not exist "%ROOT%lib\src\app.dart" goto :missing_root

pushd "%ROOT%"

echo [1/5] Flutter SDK... >> "%LOGFILE%"
flutter --version >> "%LOGFILE%" 2>&1
if errorlevel 1 goto :fail

echo [2/5] Dependencies... >> "%LOGFILE%"
flutter pub get >> "%LOGFILE%" 2>&1
if errorlevel 1 goto :fail

echo [3/5] Source format verification... >> "%LOGFILE%"
dart format --output=none --set-exit-if-changed lib test >> "%LOGFILE%" 2>&1
if errorlevel 1 goto :fail

echo [4/5] Analysis and unit tests... >> "%LOGFILE%"
flutter analyze >> "%LOGFILE%" 2>&1
if errorlevel 1 goto :fail
flutter test >> "%LOGFILE%" 2>&1
if errorlevel 1 goto :fail

echo [5/5] Chrome... >> "%LOGFILE%"
echo.
echo ============================================================
echo CANONICAL_RUNTIME_ROOT=archive_system
echo CANONICAL_ENTRYPOINT=lib\main.dart
echo LOCAL_RUNTIME_VERIFY=PASS
echo LOCAL_CRUD=SESSION_MEMORY_ONLY
echo PLATFORM_AUTH=NOT_CONNECTED
echo SUPABASE=NOT_CONNECTED
echo DATABASE_MUTATION=NONE
echo PRODUCTION_APPROVAL=NOT_IMPLIED
echo ============================================================
echo.
flutter run -d chrome --target lib\main.dart
set "EXITCODE=%ERRORLEVEL%"
popd
exit /b %EXITCODE%

:flutter_missing
echo [ERROR] Flutter غير موجود في PATH.
echo افتح طرفية تنجح فيها: flutter --version
echo ثم شغّل هذا الملف مرة أخرى.
pause
exit /b 1

:missing_root
echo [ERROR] المشروع غير مكتمل أو تم تشغيل الملف خارج الجذر المعتمد.
echo المطلوب: pubspec.yaml و lib\main.dart و lib\src\app.dart في نفس المجلد.
pause
exit /b 1

:fail
popd
echo.
echo [ERROR] فشل التحقق؛ لن يتم فتح Chrome.
echo راجع السجل: %LOGFILE%
pause
exit /b 1
