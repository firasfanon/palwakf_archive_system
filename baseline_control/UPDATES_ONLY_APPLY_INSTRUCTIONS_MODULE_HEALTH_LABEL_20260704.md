# Updates-Only Apply Instructions — Module Health Label Compile Gate

```text
PATCH_ID=ARCHIVE_MODULE_HEALTH_LABEL_COMPILE_GATE_CORRECTION_CANDIDATE_20260704
BASELINE_PRECONDITION=PALWAKF_EVIDENCE_ARCHIVE_CANONICAL_RUNTIME_ROOT_CANDIDATE_20260704
RECOMMENDED_PATH=USE_THE_FULL_CANDIDATE_ZIP
```

## Scope
This updates-only archive is a narrow source and documentation overlay for `ERR-ARCHIVE-20260704-03`. It is valid **only** over the prior canonical-runtime-root candidate, where:

```text
archive_system/lib/main.dart exists
archive_system/lib/src/app.dart exists
archive_system/workspace/pubspec.yaml does not exist
```

It must not be applied over the original two-project archive or the initial module-reception package.

## Apply
1. Stop Flutter/Chrome and close the IDE run session.
2. Make a copy of the current `archive_system/` directory.
3. Extract this updates-only ZIP into that `archive_system/` directory, preserving all internal paths and overwriting matching files.
4. From `archive_system/`, run:
   ```powershell
   python tools\verify_module_reception_static.py
   flutter pub get
   flutter analyze
   flutter test
   flutter run -d chrome --target lib/main.dart
   ```
5. Accept only if `MODULE_HEALTH_LABEL_IMPORT=PASS` and the `ModuleHealthStatus.label` error is absent.

## Non-reversibility / safety
No migration, database, storage, or platform mutation is included. Reverting is a filesystem restore from the copy made in step 2.
