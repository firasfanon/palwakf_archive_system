@echo off
setlocal EnableExtensions
title PalWakf Evidence Archive - Canonical Root Guard

set "ROOT=%~dp0"
powershell -NoProfile -ExecutionPolicy Bypass -File "%ROOT%tools\canonical_runtime_root_guard.ps1"
if errorlevel 1 (
  echo.
  echo [ERROR] فشل حارس الجذر التشغيلي. لن يتم تشغيل Chrome.
  pause
  exit /b 1
)

call "%ROOT%START_ARCHIVE_SYSTEM.bat"
exit /b %ERRORLEVEL%
