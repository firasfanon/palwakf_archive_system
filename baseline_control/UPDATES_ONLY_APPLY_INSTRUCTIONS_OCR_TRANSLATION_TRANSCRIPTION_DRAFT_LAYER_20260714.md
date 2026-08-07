# Apply instructions

Use the standard successful method:

```powershell
cd C:\Users\DELL\Downloads
Expand-Archive -LiteralPath .\PALWAKF_ARCHIVE_OCR_TRANSLATION_TRANSCRIPTION_DRAFT_LAYER_20260714_UPDATES_ONLY.zip -DestinationPath .\PALWAKF_ARCHIVE_OCR_TRANSLATION_TRANSCRIPTION_DRAFT_LAYER_20260714_UPDATES_ONLY -Force
cd .\PALWAKF_ARCHIVE_OCR_TRANSLATION_TRANSCRIPTION_DRAFT_LAYER_20260714_UPDATES_ONLY
Set-ExecutionPolicy -Scope Process Bypass -Force
.\APPLY_OCR_TRANSLATION_TRANSCRIPTION_DRAFT_LAYER_V1.ps1 -ProjectRoot "C:\Users\DELL\StudioProjects\archive_system"
cd C:\Users\DELL\StudioProjects\archive_system
python tools\verify_module_reception_static.py
flutter pub get
dart format lib test
flutter analyze
flutter test
flutter run -d chrome --target lib/main.dart
```
