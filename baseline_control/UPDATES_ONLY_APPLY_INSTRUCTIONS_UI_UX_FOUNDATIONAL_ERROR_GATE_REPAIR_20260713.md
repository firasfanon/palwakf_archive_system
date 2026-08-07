# Apply instructions — UI/UX Foundational Error Gate Repair

Apply the updates-only package over:

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

Acceptance requires:

```text
flutter analyze=PASS
flutter test=PASS
flutter run=PASS
NO_LIST_TILE_ASSERTION=PASS
```
