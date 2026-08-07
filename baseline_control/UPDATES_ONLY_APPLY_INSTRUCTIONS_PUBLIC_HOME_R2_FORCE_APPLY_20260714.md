# Apply Instructions

Extract this updates-only package to any temporary folder, then run:

```powershell
Set-ExecutionPolicy -Scope Process Bypass -Force
.\APPLY_PUBLIC_HOME_R2_FORCE.ps1 -ProjectRoot "C:\Users\DELL\StudioProjects\archive_system"
```

Then run project gates:

```powershell
cd C:\Users\DELL\StudioProjects\archive_system
python tools\verify_module_reception_static.py
flutter pub get
dart format lib test
flutter analyze
flutter test
flutter run -d chrome --target lib/main.dart
```
