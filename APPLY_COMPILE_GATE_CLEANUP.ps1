# PalWakf Evidence Archive compile-gate cleanup
# Purpose: move stale source/test artifacts left by older updates-only overlays out of the Flutter project root.
# This script does not connect to PalWakf, Supabase, File Center, GIS, or any production endpoint.

$ErrorActionPreference = 'Stop'
$Root = Split-Path -Parent $MyInvocation.MyCommand.Path
$Parent = Split-Path -Parent $Root
$Stamp = Get-Date -Format 'yyyyMMdd_HHmmss'
$Quarantine = Join-Path $Parent "archive_system_orphaned_compile_gate_quarantine_$Stamp"
$Moved = New-Object System.Collections.Generic.List[string]

$Candidates = @(
  'lib\src\features\workbench',
  'lib\src\features\viewer',
  'test\documentary_spatial_viewer_contract_test.dart',
  'test\navigation_layout_contract_test.dart',
  'backups\pre_canonical_runtime_root_20260704'
)

foreach ($Relative in $Candidates) {
  $Path = Join-Path $Root $Relative
  if (Test-Path -LiteralPath $Path) {
    $Destination = Join-Path $Quarantine $Relative
    $DestinationParent = Split-Path -Parent $Destination
    New-Item -ItemType Directory -Force -Path $DestinationParent | Out-Null
    Move-Item -LiteralPath $Path -Destination $Destination -Force
    $Moved.Add($Relative) | Out-Null
  }
}

Write-Host 'PALWAKF_ARCHIVE_COMPILE_GATE_CLEANUP=PASS'
Write-Host "PROJECT_ROOT=$Root"
if ($Moved.Count -eq 0) {
  Write-Host 'STALE_ARTIFACTS_MOVED=0'
} else {
  Write-Host "STALE_ARTIFACTS_MOVED=$($Moved.Count)"
  Write-Host "QUARANTINE_PATH=$Quarantine"
  foreach ($Item in $Moved) {
    Write-Host "MOVED=$Item"
  }
}
Write-Host 'REMOTE_INTEGRATION=NOT_CONNECTED_BY_DESIGN'
Write-Host 'STAGING_APPROVAL=NOT_APPROVED'
Write-Host 'PRODUCTION_APPROVAL=NOT_APPROVED'
