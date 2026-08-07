# Updates-only apply instructions

Apply this package over the accepted `PALWAKF_ARCHIVE_SMART_INDEXING_OCR_DEDUP_20260713` baseline or a locally equivalent tree.

```powershell
cd C:\Users\DELL\StudioProjects\archive_system
python tools\verify_module_reception_static.py
flutter pub get
dart format lib test
flutter analyze
flutter test
flutter run -d chrome --target lib/main.dart
```

Expected after applying:

```text
SMART_INDEXING_NULL_GUARD=PASS
ACCESS_PUBLICATION_RETENTION_AUDIT_OPERATIONALIZATION=PASS
ACCESS_POLICY_MATRIX_LOCAL=PASS
PUBLICATION_REVIEW_QUEUE_LOCAL=PASS
RETENTION_SCHEDULE_LOCAL=PASS
AUDIT_TRAIL_LOCAL=PASS
```
