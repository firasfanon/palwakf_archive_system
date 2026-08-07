param(
  [string]$ProjectRoot = (Get-Location).Path
)
$ErrorActionPreference = "Stop"
$PackageRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$SourceRoot = Join-Path $PackageRoot "archive_system"

function Assert-Exists($Path, $Message) {
  if (-not (Test-Path -LiteralPath $Path)) { throw $Message }
}

Assert-Exists $SourceRoot "SOURCE_ARCHIVE_SYSTEM_NOT_FOUND: expected package folder archive_system next to this script."
Assert-Exists (Join-Path $ProjectRoot "pubspec.yaml") "PROJECT_ROOT_INVALID: run from C:\Users\DELL\StudioProjects\archive_system or pass -ProjectRoot."
Assert-Exists (Join-Path $ProjectRoot "lib\src\features") "PROJECT_ROOT_INVALID: lib\src\features not found."

$stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$backupRoot = Join-Path $ProjectRoot "backups\public_home_compile_upload_queue_retention_r2_force_$stamp"
New-Item -ItemType Directory -Force -Path $backupRoot | Out-Null

$files = @(
  "lib\src\features\public\public_archive_landing_screen.dart",
  "lib\src\features\daily\upload_storage_screen.dart",
  "lib\src\features\representations\representations_screen.dart",
  "lib\src\core\models\models.dart",
  "lib\src\core\state\local_operational_store.dart",
  "test\upload_representation_preview_queue_test.dart",
  "tools\verify_module_reception_static.py",
  "CHANGELOG.md",
  "PALWAKF_PLATFORM_COMPREHENSIVE_GUIDE.md",
  "PROJECT_SESSIONS_INDEX.md"
)

foreach ($rel in $files) {
  $src = Join-Path $SourceRoot $rel
  $dst = Join-Path $ProjectRoot $rel
  Assert-Exists $src "SOURCE_FILE_MISSING: $rel"
  if (Test-Path -LiteralPath $dst) {
    $backup = Join-Path $backupRoot $rel
    New-Item -ItemType Directory -Force -Path (Split-Path -Parent $backup) | Out-Null
    Copy-Item -LiteralPath $dst -Destination $backup -Force
  }
  New-Item -ItemType Directory -Force -Path (Split-Path -Parent $dst) | Out-Null
  Copy-Item -LiteralPath $src -Destination $dst -Force
}

$publicPath = Join-Path $ProjectRoot "lib\src\features\public\public_archive_landing_screen.dart"
$public = Get-Content -LiteralPath $publicPath -Raw -Encoding UTF8
if ($public -match "Container\s*\(\s*minHeight\s*:") {
  throw "PUBLIC_HOME_CONTAINER_MIN_HEIGHT_STILL_INVALID: Container(minHeight:) remains in public_archive_landing_screen.dart"
}
if ($public -notmatch "constraints:\s*const\s*BoxConstraints\s*\(\s*minHeight:\s*300") {
  throw "PUBLIC_HOME_CONTAINER_MIN_HEIGHT_FIX_NOT_FOUND: expected constraints: const BoxConstraints(minHeight: 300)."
}

$upload = Get-Content -LiteralPath (Join-Path $ProjectRoot "lib\src\features\daily\upload_storage_screen.dart") -Raw -Encoding UTF8
$repr = Get-Content -LiteralPath (Join-Path $ProjectRoot "lib\src\features\representations\representations_screen.dart") -Raw -Encoding UTF8
$test = Get-Content -LiteralPath (Join-Path $ProjectRoot "test\upload_representation_preview_queue_test.dart") -Raw -Encoding UTF8
$model = Get-Content -LiteralPath (Join-Path $ProjectRoot "lib\src\core\models\models.dart") -Raw -Encoding UTF8
$state = Get-Content -LiteralPath (Join-Path $ProjectRoot "lib\src\core\state\local_operational_store.dart") -Raw -Encoding UTF8

$required = @(
  @($upload, "UPLOAD_REPRESENTATION_PREVIEW_AND_LOCAL_FILE_QUEUE", "UPLOAD_QUEUE_SCREEN_MARKER_MISSING"),
  @($upload, "معاينة تمثيل محلي", "UPLOAD_PREVIEW_LABEL_MISSING"),
  @($upload, "إضافة إلى طابور الرفع المحلي", "LOCAL_QUEUE_LABEL_MISSING"),
  @($upload, "Hash تجريبي", "HASH_PREVIEW_LABEL_MISSING"),
  @($upload, "استبدال أصل محظور", "ORIGINAL_REPLACEMENT_GUARD_LABEL_MISSING"),
  @($repr, "REPRESENTATION_MANAGER_REFINEMENT", "REPRESENTATION_MANAGER_MARKER_MISSING"),
  @($repr, "وسم كمراجع محليًا", "REPRESENTATION_REVIEW_LABEL_MISSING"),
  @($test, "upload and representation screens expose preview and local queue UX", "UPLOAD_QUEUE_TEST_MISSING"),
  @($model, "uploadStatus", "REPRESENTATION_UPLOAD_STATUS_FIELD_MISSING"),
  @($state, "queueLocalRepresentation", "QUEUE_LOCAL_REPRESENTATION_CONTROLLER_MISSING")
)
foreach ($item in $required) {
  if (-not $item[0].Contains($item[1])) { throw $item[2] }
}

Write-Host "PUBLIC_HOME_CONTAINER_MIN_HEIGHT_COMPILE_FIX=PASS"
Write-Host "UPLOAD_QUEUE_FEATURE_RETENTION=PASS"
Write-Host "PUBLIC_HOME_R2_FORCE_APPLY=PASS"
Write-Host "BACKUP_ROOT=$backupRoot"
