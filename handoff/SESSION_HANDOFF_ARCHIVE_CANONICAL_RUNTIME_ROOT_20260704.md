# Session Handoff — Evidence Archive Canonical Runtime Root Closure

```text
HANDOFF_ID=SESSION_HANDOFF_ARCHIVE_CANONICAL_RUNTIME_ROOT_20260704
DATE=2026-07-04
PROJECT=PalWakf Evidence Archive & Spatial Explorer
BATCH=MEGA_BATCH_EVIDENCE_ARCHIVE_CANONICAL_RUNTIME_ROOT_CLOSURE_V1
TYPE=URGENT_LOCAL_RUNTIME_PACKAGING_CORRECTION
PREVIOUS_RUNTIME_EVIDENCE=ROOT_LIB_MAIN_DART_LAUNCHED_DEFAULT_FLUTTER_COUNTER
CURRENT_CANDIDATE=ARCHIVE_CANONICAL_RUNTIME_ROOT_CORRECTION_CANDIDATE_20260704
SOURCE_STRUCTURE_STATUS=STATICLY_VERIFIED
LOCAL_FLUTTER_STATUS=PENDING_RECHECK
BROWSER_UAT_STATUS=PENDING_RECHECK
STAGING_INTEGRATION_AUTHORIZED=FALSE
PRODUCTION_APPROVAL=NOT_IMPLIED
```

## 1. Executive handoff
The prior module-reception package did not create a Flutter compiler failure. It created a **runtime launch ambiguity**: two Flutter projects were packaged under the same archive root. IDE launch from the root correctly invoked `lib/main.dart`, but that file was still Flutter’s default counter sample. The intended Arabic Evidence Archive application was located in a nested `workspace/` package.

The received Chrome screenshot and launch output are decisive:
- dependency resolution succeeded;
- Chrome debug service launched;
- the rendered app title was `Flutter Demo Home Page`;
- therefore the wrong application root was launched.

This correction package converts the module to one canonical Flutter project rooted at `archive_system/`. The real source is at `lib/`, contract tests at `test/`, and platform reception documents at `integration/`. The nested `workspace/` app has been removed. The previous default launcher artifacts are retained only under `backups/pre_canonical_runtime_root_20260704/` and are not active runtime code.

## 2. Governing references
1. `PALWAKF_MODULE_FACTORY_AND_PLATFORM_RECEPTION_FRAMEWORK_V1` remains the module reception governing framework.
2. PalWakf sovereignty rules remain unchanged:
   - `waqf_assets` is the future central operational entity and must be linked by `waqf_asset_id` when authorized.
   - `awqaf_system` remains Master Data.
   - `mustakshif` remains spatial/historical analysis only.
   - `public` remains views/RPC wrappers only.
   - new code uses `flutter_riverpod`, not `legacy.dart`.
3. `PALWAKF_PLATFORM_COMPREHENSIVE_GUIDE.md` in this package is a project continuity derivative only, not a substitute for the unavailable central master guide.

## 3. Correct runtime layout
```text
archive_system/
  pubspec.yaml                          # canonical package definition
  lib/main.dart                          # canonical entrypoint
  lib/src/app.dart                       # EvidenceArchiveApp
  test/                                  # contract and local-store tests
  integration/                           # intake/manifest/UAT documents
  START_ARCHIVE_SYSTEM.bat               # canonical launch path
  VERIFY_ARCHIVE_SYSTEM.bat              # canonical quality gates
  tools/verify_module_reception_static.py
  tools/canonical_runtime_root_guard.ps1
```

Forbidden active layout:
```text
archive_system/workspace/pubspec.yaml
```

## 4. Source behavior retained
The correction does not alter the functional module-reception design already prepared:
- `flutter_riverpod` is the state-management dependency.
- Local fixture mode uses `LOCAL-DEMO-UNIT`.
- `unitScopeKey` scopes local records.
- Cross-unit local mutation fails closed.
- Capability gate applies to local mutation surfaces.
- File object and GIS requests remain blocked until platform binding.
- Feature flag and health/fallback controls remain local simulations.
- Session-only activity trace remains non-sovereign and non-production.

## 5. Explicit non-changes
```text
NO_PLATFORM_CORE_MUTATION
NO_CORE_SCHEMA_MUTATION
NO_WAQF_SCHEMA_MUTATION
NO_PUBLIC_BASE_TABLE
NO_SUPABASE_CONNECTION
NO_DATABASE_MUTATION
NO_STORAGE_MIGRATION
NO_FILE_CENTER_BINDING
NO_GIS_BINDING
NO_LOCAL_LOGIN
NO_LOCAL_PRODUCTION_RBAC
NO_PLATFORM_ROUTE_ASSIGNMENT
NO_STAGING_AUTHORIZATION
NO_PRODUCTION_APPROVAL
```

## 6. Checks completed during package construction
```text
ZIP_INTEGRITY=PASS
CANONICAL_RUNTIME_ROOT_STATIC_VERIFY=PASS
DEFAULT_TEMPLATE_ENTRYPOINT=ABSENT
NESTED_FLUTTER_PROJECT=ABSENT
ROOT_ENTRYPOINT=EvidenceArchiveApp
FLUTTER_RIVERPOD_DEPENDENCY=DECLARED
STATIC_POLICY_SCAN=PASS
UNIT_SCOPE_CONSTRUCTOR_SCAN=PASS
```

These checks do **not** prove Flutter compilation, tests, Chrome rendering, or platform integration.

## 7. Mandatory local verification — do not skip order
Open a terminal in the corrected `archive_system/` directory.

### Step A — root guard
```powershell
python tools\verify_module_reception_static.py
```

Expected:
```text
MODULE_RECEPTION_STATIC_VERIFY=PASS
CANONICAL_RUNTIME_ROOT=PASS
DEFAULT_TEMPLATE_ENTRYPOINT=ABSENT
NESTED_FLUTTER_PROJECT=ABSENT
```

### Step B — quality gates
```powershell
flutter pub get
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
```

All must finish with exit code 0. Do not substitute a browser screenshot for these checks.

### Step C — runtime identity
```powershell
flutter run -d chrome --target lib/main.dart
```

Required visible acceptance:
- Arabic-first RTL UI.
- PalWakf identity.
- `أرشيف الأدلة والمستكشف المكاني` rather than `Flutter Demo Home Page`.
- no default counter button/page.

### Step D — bounded browser UAT
1. Use navigation to open «الإدماج».
2. Confirm `جاهز محليًا` / local-ready status.
3. click Degraded simulation and confirm application shell remains.
4. click Disabled simulation and confirm fallback panel is shown.
5. Restore the local host.
6. Observe browser Network: no Supabase auth, database, storage, File Center, or GIS traffic must arise from fixture simulation.
7. Keep one screenshot and one short console/log excerpt only.

## 8. Acceptance decision matrix
| Result | Decision |
|---|---|
| All Gates A–D pass | Close ERR-ARCHIVE-20260704-02 as `LOCAL_RUNTIME_ACCEPTED`; record the corrected baseline as locally accepted. |
| Root guard fails | Do not run Flutter; extraction or incorrect directory is likely. |
| `flutter pub get` fails | capture exact error; no code mutation without targeted diagnosis. |
| analyze/test fails | capture first semantic error only; apply a narrow correction, not a broad rewrite. |
| Browser still shows Flutter Demo | stop; user is not opening corrected `archive_system` root or IDE project cache/run configuration still points to stale files. |
| Browser shows archive but UAT fails | classify as app behavior defect; retain root correction and fix only the failing subsystem. |

## 9. Current Error Record
`ERR-ARCHIVE-20260704-02` is open pending local verification. Its root cause, affected files, failed path, correction, and closure condition are documented at:
```text
error_records/ERROR_RECORD.md
```

## 10. Next authorized work
No Platform/Staging integration work is authorized from this candidate until the above local gates pass.

After local acceptance, the next candidate is:
```text
MEGA_BATCH_EVIDENCE_ARCHIVE_PLATFORM_INTAKE_AND_STAGING_BINDING_DESIGN_V1
```

Scope: design/intake only; no direct platform mutation. It requires module registry assignment, route-slot allocation, central authority/unit context contract, owner-schema/API approval, File Center and audit contracts, GIS capability contract, and explicit staging authorization.

## 11. Delivery inventory
- Full corrected candidate baseline ZIP.
- Updates-only ZIP.
- Handoff ZIP.
- SHA-256 checksum text.
- This file plus a concise next-session prompt.
