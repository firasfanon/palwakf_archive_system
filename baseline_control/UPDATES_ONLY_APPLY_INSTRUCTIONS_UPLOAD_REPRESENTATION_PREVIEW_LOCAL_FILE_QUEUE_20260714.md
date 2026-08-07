# Updates-only apply instructions — Upload Representation Preview & Local File Queue

## Target

`C:\Users\DELL\StudioProjects\archive_system`

## Steps

1. Extract `PALWAKF_ARCHIVE_UPLOAD_REPRESENTATION_PREVIEW_LOCAL_FILE_QUEUE_20260714_UPDATES_ONLY.zip`.
2. Copy the contained `archive_system` folder contents over the local project root, preserving paths.
3. Run:

```powershell
cd C:\Users\DELL\StudioProjects\archive_system
python tools\verify_module_reception_static.py
flutter pub get
dart format lib test
flutter analyze
flutter test
flutter run -d chrome --target lib/main.dart
```

## Acceptance

Do not accept the baseline unless static verifier, analyze, test, and browser run all pass.
