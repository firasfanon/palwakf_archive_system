# Changed Files — Canonical Runtime Root Closure — 2026-07-04

## Added
- `CANONICAL_RUNTIME_ROOT.md`
- `tools/canonical_runtime_root_guard.ps1`
- `baseline_control/CHANGED_FILES_20260704_RUNTIME_ROOT.md`
- `handoff/SESSION_HANDOFF_ARCHIVE_CANONICAL_RUNTIME_ROOT_20260704.md`
- `handoff/NEXT_SESSION_PROMPT_CANONICAL_RUNTIME_ROOT.md`

## Promoted from the prior nested Flutter workspace
- `workspace/lib/**` → `lib/**`
- `workspace/test/**` → `test/**`
- `workspace/integration/**` → `integration/**`
- `workspace/pubspec.yaml` → `pubspec.yaml`
- `workspace/pubspec.lock` → `pubspec.lock`
- `workspace/analysis_options.yaml` → `analysis_options.yaml`

## Replaced
- `lib/main.dart` — default counter template replaced by `EvidenceArchiveApp` bootstrap.
- `START_ARCHIVE_SYSTEM.bat`
- `VERIFY_ARCHIVE_SYSTEM.bat`
- `FIX_AND_START_ARCHIVE_SYSTEM.bat`
- `tools/verify_module_reception_static.py`
- `README.md`
- `README_AR.txt`
- `STATUS.txt`
- `CHANGELOG.md`
- `baseline_control/BASELINE_UPDATE_NOTES.md`
- `error_records/ERROR_RECORD.md`
- `PALWAKF_PLATFORM_COMPREHENSIVE_GUIDE.md`
- `PROJECT_SESSIONS_INDEX.md`
- `uat/UAT_STATUS.md`

## Removed from active runtime layout
- `workspace/` nested Flutter project.
- Root default counter test and root default dependency graph.
- Old workspace-dependent repair script; preserved only as an archival artifact.
