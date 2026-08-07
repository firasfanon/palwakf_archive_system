# PUBLIC HOME + UPLOAD QUEUE R3 FORCE APPLY

This package fixes two active issues:

1. Public home compile regression caused by `Container(minHeight: 300)`.
2. Upload & Representations test contract regression in `upload_representation_preview_queue_test.dart`.

Run from the extracted package root:

```powershell
Set-ExecutionPolicy -Scope Process Bypass -Force
.\APPLY_PUBLIC_HOME_UPLOAD_QUEUE_R3_FORCE.ps1 -ProjectRoot "C:\Users\DELL\StudioProjects\archive_system"
```

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
