# Updates-only apply instructions

Use this only over the latest local `archive_system` tree that received the full product pipeline package.

```powershell
# From inside archive_system after copying updates-only files:
powershell -ExecutionPolicy Bypass -File .\APPLY_COMPILE_GATE_CLEANUP.ps1
python tools\verify_module_reception_static.py
flutter pub get
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
flutter run -d chrome --target lib/main.dart
```

If `dart format` reports changed files, rerun the same command once after committing/keeping the formatting, then continue with `flutter analyze`.

The script moves stale older overlay artifacts to a sibling quarantine folder outside the Flutter project root so the analyzer does not compile obsolete files.
