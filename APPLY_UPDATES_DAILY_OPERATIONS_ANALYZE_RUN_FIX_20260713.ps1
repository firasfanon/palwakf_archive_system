param(
  [string]$ProjectRoot = (Get-Location).Path
)
$ErrorActionPreference = "Stop"
Write-Host "PALWAKF_ARCHIVE_DAILY_OPERATIONS_ANALYZE_RUN_FIX=START"
Write-Host "PROJECT_ROOT=$ProjectRoot"
python tools\verify_module_reception_static.py
Write-Host "NEXT_COMMANDS=flutter pub get; dart format lib test; flutter analyze; flutter test; flutter run -d chrome --target lib/main.dart"
Write-Host "PALWAKF_REMOTE_INTEGRATION=NOT_CONNECTED_BY_DESIGN"
Write-Host "STAGING_APPROVAL=NOT_APPROVED"
Write-Host "PRODUCTION_APPROVAL=NOT_APPROVED"
