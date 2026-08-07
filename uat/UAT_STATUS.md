# UAT Status — Evidence Archive

```text
CURRENT_CANDIDATE=ARCHIVE_MODULE_HEALTH_LABEL_COMPILE_GATE_CORRECTION_CANDIDATE_20260704
PREVIOUS_CANDIDATE=ARCHIVE_CANONICAL_RUNTIME_ROOT_CORRECTION_CANDIDATE_20260704
LOCAL_RUNTIME_STATUS=BLOCKED_PENDING_COMPILE_GATE_RECHECK
STATIC_PACKAGE_STRUCTURE=PASS
STATIC_MODULE_HEALTH_LABEL_IMPORT_GUARD=PASS
CURRENT_ERROR_RECORD=ERR-ARCHIVE-20260704-03
STAGING_UAT=NOT_AUTHORIZED
PRODUCTION_UAT=NOT_AUTHORIZED
```

## Minimum local UAT protocol

### Gate 0 — static package and direct-import guard
```text
python tools\verify_module_reception_static.py
```
Expected:
```text
MODULE_RECEPTION_STATIC_VERIFY=PASS
CANONICAL_RUNTIME_ROOT=PASS
DEFAULT_TEMPLATE_ENTRYPOINT=ABSENT
NESTED_FLUTTER_PROJECT=ABSENT
MODULE_HEALTH_LABEL_IMPORT=PASS
```

### Gate 1 — Flutter compile and quality
```text
flutter pub get
flutter analyze
flutter test
```
Required:
- Exit code `0` for every command.
- No `ModuleHealthStatus` / `label` error in `lib/src/app.dart`.
- Do not accept a browser screenshot before Gate 1 passes.

### Gate 2 — browser identity
```text
flutter run -d chrome --target lib/main.dart
```
Accept only if:
- The app does **not** show `Flutter Demo Home Page`.
- The app does **not** show the default counter.
- Arabic RTL navigation of Evidence Archive appears.
- App title identifies `PalWakf` and `أرشيف الأدلة والمستكشف المكاني`.
- The app bar health tooltip can resolve without compiler failure.

### Gate 3 — local integration simulation
1. Open «الإدماج».
2. Confirm initial local-ready state.
3. Simulate degraded; operational shell remains.
4. Simulate disabled; fallback panel replaces operational page.
5. Restore local mode.
6. Confirm no network auth/database/file request is created.

## Explicit non-acceptance boundaries
```text
PLATFORM_INTEGRATED=FALSE
STAGING_INTEGRATION_AUTHORIZED=FALSE
PRODUCTION_APPROVAL=NOT_IMPLIED
```
