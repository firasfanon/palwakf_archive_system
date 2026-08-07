# Updates-only Apply Instructions

Apply `PALWAKF_ARCHIVE_REPORTS_NOTIFICATIONS_BACKUP_EXPORT_UPDATES_ONLY_20260713.zip` over the accepted `archive_system` folder, then run:

```powershell
cd C:\Users\Firas_Fanon\StudioProjects\archive_system
python tools\verify_module_reception_static.py
flutter pub get
dart format lib test
flutter analyze
flutter test
flutter run -d chrome --target lib/main.dart
```

Acceptance requires verify/analyze/test/run PASS and a visual Browser Smoke Test showing the daily page and the new `التقارير والتنبيهات` navigation item.
