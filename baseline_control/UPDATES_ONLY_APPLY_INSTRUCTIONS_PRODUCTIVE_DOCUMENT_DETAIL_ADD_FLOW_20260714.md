# Updates Only Apply Instructions

Apply over the accepted baseline:
`PALWAKF_ARCHIVE_UI_UX_FOUNDATIONAL_ERROR_GATE_REPAIR_R2_20260714_BASELINE`

Target local path:
`C:\Users\DELL\StudioProjects\archive_system`

Then run:
```powershell
cd C:\Users\DELL\StudioProjects\archive_system
python tools\verify_module_reception_static.py
flutter pub get
dart format lib test
flutter analyze
flutter test
flutter run -d chrome --target lib/main.dart
```
