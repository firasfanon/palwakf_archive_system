param(
  [string]$ProjectRoot = "C:\Users\DELL\StudioProjects\archive_system"
)

$ErrorActionPreference = 'Stop'
$PackageRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$SourceRoot = Join-Path $PackageRoot 'archive_system'

if (-not (Test-Path -LiteralPath $ProjectRoot)) {
  throw "PROJECT_ROOT_NOT_FOUND: $ProjectRoot"
}
if (-not (Test-Path -LiteralPath $SourceRoot)) {
  throw "PACKAGE_SOURCE_ROOT_NOT_FOUND: $SourceRoot"
}

$stamp = Get-Date -Format 'yyyyMMdd_HHmmss'
$backupRoot = Join-Path $ProjectRoot "backups\public_home_upload_queue_r3_force_$stamp"
New-Item -ItemType Directory -Force -Path $backupRoot | Out-Null

$relativeFiles = @(
  'lib\src\features\public\public_archive_landing_screen.dart',
  'lib\src\features\daily\upload_storage_screen.dart',
  'lib\src\features\representations\representations_screen.dart',
  'lib\src\core\models\models.dart',
  'lib\src\core\state\local_operational_store.dart',
  'test\upload_representation_preview_queue_test.dart',
  'tools\verify_module_reception_static.py'
)

foreach ($rel in $relativeFiles) {
  $src = Join-Path $SourceRoot $rel
  $dst = Join-Path $ProjectRoot $rel
  if (-not (Test-Path -LiteralPath $src)) { throw "PACKAGE_FILE_MISSING: $rel" }
  if (Test-Path -LiteralPath $dst) {
    $backupDst = Join-Path $backupRoot $rel
    New-Item -ItemType Directory -Force -Path (Split-Path -Parent $backupDst) | Out-Null
    Copy-Item -LiteralPath $dst -Destination $backupDst -Force
  }
  New-Item -ItemType Directory -Force -Path (Split-Path -Parent $dst) | Out-Null
  Copy-Item -LiteralPath $src -Destination $dst -Force
  Write-Host "COPIED=$rel"
}

$publicHome = Get-Content -LiteralPath (Join-Path $ProjectRoot 'lib\src\features\public\public_archive_landing_screen.dart') -Raw -Encoding UTF8
if ($publicHome -match '(?m)^\s*minHeight\s*:\s*300\s*,') { throw 'PUBLIC_HOME_CONTAINER_MIN_HEIGHT_COMPILE_REGRESSION' }
if ($publicHome -notlike '*constraints: const BoxConstraints(minHeight: 300)*') { throw 'PUBLIC_HOME_CONTAINER_MIN_HEIGHT_COMPILE_FIX_MISSING' }

$upload = Get-Content -LiteralPath (Join-Path $ProjectRoot 'lib\src\features\daily\upload_storage_screen.dart') -Raw -Encoding UTF8
$rep = Get-Content -LiteralPath (Join-Path $ProjectRoot 'lib\src\features\representations\representations_screen.dart') -Raw -Encoding UTF8
$store = Get-Content -LiteralPath (Join-Path $ProjectRoot 'lib\src\core\state\local_operational_store.dart') -Raw -Encoding UTF8

$requiredUpload = @('UPLOAD_REPRESENTATION_PREVIEW_AND_LOCAL_FILE_QUEUE','معاينة تمثيل محلي','إضافة إلى طابور الرفع المحلي','Hash تجريبي','استبدال أصل محظور')
foreach ($needle in $requiredUpload) {
  if ($upload -notlike "*$needle*") { throw "UPLOAD_CONTRACT_MISSING: $needle" }
}
$requiredRep = @('REPRESENTATION_MANAGER_REFINEMENT','وسم كمراجع محليًا')
foreach ($needle in $requiredRep) {
  if ($rep -notlike "*$needle*") { throw "REPRESENTATION_CONTRACT_MISSING: $needle" }
}
foreach ($needle in @('queueLocalRepresentation','markRepresentationReviewed')) {
  if ($store -notlike "*$needle*") { throw "CONTROLLER_CONTRACT_MISSING: $needle" }
}

Write-Host 'PUBLIC_HOME_CONTAINER_MIN_HEIGHT_COMPILE_FIX=PASS'
Write-Host 'UPLOAD_QUEUE_TEST_CONTRACT_R3=PASS'
Write-Host 'UPLOAD_QUEUE_FEATURE_RETENTION=PASS'
Write-Host 'FORCE_APPLY_BACKUP_ROOT=' $backupRoot
Write-Host 'NEXT_RUN=python tools\verify_module_reception_static.py; dart format lib test; flutter analyze; flutter test; flutter run -d chrome --target lib/main.dart'
