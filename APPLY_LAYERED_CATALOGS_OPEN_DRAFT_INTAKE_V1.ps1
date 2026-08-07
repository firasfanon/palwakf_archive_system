param(
  [string]$ProjectRoot = "C:\Users\DELL\StudioProjects\archive_system"
)

$ErrorActionPreference = "Stop"
$packageRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$sourceRoot = Join-Path $packageRoot "archive_system"
if (-not (Test-Path -LiteralPath $sourceRoot)) {
  if (Test-Path -LiteralPath (Join-Path $packageRoot "lib")) {
    $sourceRoot = $packageRoot
  } else {
    throw "Could not locate archive_system source inside package."
  }
}
if (-not (Test-Path -LiteralPath $ProjectRoot)) {
  throw "ProjectRoot not found: $ProjectRoot"
}

$stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$backupRoot = Join-Path $ProjectRoot "backups\layered_catalogs_open_draft_intake_$stamp"
New-Item -ItemType Directory -Force -Path $backupRoot | Out-Null

$relativeFiles = @(
  "lib\src\app.dart",
  "lib\src\core\models\models.dart",
  "lib\src\core\state\local_operational_store.dart",
  "lib\src\features\catalogs\archive_catalogs_screen.dart",
  "lib\src\features\daily\add_document_screen.dart",
  "tools\verify_module_reception_static.py",
  "test\layered_catalogs_open_draft_intake_test.dart",
  "CHANGELOG.md",
  "PALWAKF_PLATFORM_COMPREHENSIVE_GUIDE.md",
  "docs\ARCHIVE_LAYERED_CATALOGS_OPEN_DRAFT_INTAKE_AND_PAGE_ALIGNMENT_V1.md",
  "baseline_control\CHANGED_FILES_LAYERED_CATALOGS_OPEN_DRAFT_INTAKE_20260714.md",
  "baseline_control\STATIC_VERIFICATION_LAYERED_CATALOGS_OPEN_DRAFT_INTAKE_20260714.log",
  "baseline_control\UPDATES_ONLY_APPLY_INSTRUCTIONS_LAYERED_CATALOGS_OPEN_DRAFT_INTAKE_20260714.md",
  "handoff\SESSION_HANDOFF_ARCHIVE_LAYERED_CATALOGS_OPEN_DRAFT_INTAKE_20260714.md",
  "handoff\NEXT_SESSION_PROMPT_ARCHIVE_LAYERED_CATALOGS_OPEN_DRAFT_INTAKE_20260714.md",
  "error_records\ERROR_RECORD_ARCHIVE_LAYERED_CATALOGS_OPEN_DRAFT_INTAKE_20260714.md"
)

foreach ($rel in $relativeFiles) {
  $src = Join-Path $sourceRoot $rel
  $dst = Join-Path $ProjectRoot $rel
  if (-not (Test-Path -LiteralPath $src)) {
    throw "Missing package file: $rel"
  }
  if (Test-Path -LiteralPath $dst) {
    $backupDst = Join-Path $backupRoot $rel
    New-Item -ItemType Directory -Force -Path (Split-Path -Parent $backupDst) | Out-Null
    Copy-Item -LiteralPath $dst -Destination $backupDst -Force
  }
  New-Item -ItemType Directory -Force -Path (Split-Path -Parent $dst) | Out-Null
  Copy-Item -LiteralPath $src -Destination $dst -Force
}

$app = Get-Content -LiteralPath (Join-Path $ProjectRoot "lib\src\app.dart") -Raw -Encoding UTF8
$catalogs = Get-Content -LiteralPath (Join-Path $ProjectRoot "lib\src\features\catalogs\archive_catalogs_screen.dart") -Raw -Encoding UTF8
$store = Get-Content -LiteralPath (Join-Path $ProjectRoot "lib\src\core\state\local_operational_store.dart") -Raw -Encoding UTF8
$models = Get-Content -LiteralPath (Join-Path $ProjectRoot "lib\src\core\models\models.dart") -Raw -Encoding UTF8
if ($app -notmatch "كتالوجات الأرشيف") { throw "CATALOG_NAV_MARKER_MISSING" }
if ($catalogs -notmatch "LAYERED_ARCHIVE_CATALOGS") { throw "LAYERED_ARCHIVE_CATALOGS_MARKER_MISSING" }
if ($catalogs -notmatch "NO_INTAKE_BLOCKING_GOVERNANCE") { throw "NO_INTAKE_BLOCKING_GOVERNANCE_MARKER_MISSING" }
if ($store -notmatch "String createOpenDraftArchiveMaterial") { throw "OPEN_DRAFT_CONTROLLER_MISSING" }
if ($models -notmatch "class ArchiveCatalog") { throw "ARCHIVE_CATALOG_MODEL_MISSING" }
if ($models -notmatch "class CatalogDocumentTypeTab") { throw "CATALOG_TAB_MODEL_MISSING" }

Write-Host "APPLY_LAYERED_CATALOGS_OPEN_DRAFT_INTAKE_V1=PASS"
Write-Host "BACKUP_ROOT=$backupRoot"
