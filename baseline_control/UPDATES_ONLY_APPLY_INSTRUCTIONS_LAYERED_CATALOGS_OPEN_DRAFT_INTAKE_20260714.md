# Apply instructions

Extract the updates-only package and copy its `archive_system/` contents over:

```powershell
Set-ExecutionPolicy -Scope Process Bypass -Force
.\APPLY_LAYERED_CATALOGS_OPEN_DRAFT_INTAKE_V1.ps1 -ProjectRoot "C:\Users\DELL\StudioProjects\archive_system"

cd C:\Users\DELL\StudioProjects\archive_system
python tools\verify_module_reception_static.py
flutter pub get
dart format lib test
flutter analyze
flutter test
flutter run -d chrome --target lib/main.dart
```
