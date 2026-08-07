# Next Session Prompt — Archive Daily Operations Full UI

ابدأ من baseline:

```text
PALWAKF_ARCHIVE_DAILY_OPERATIONS_FULL_UI_IMPLEMENTATION_BASELINE_20260713
```

أولًا اطلب نتائج:

```powershell
python tools\verify_module_reception_static.py
flutter pub get
dart format lib test
flutter analyze
flutter test
flutter run -d chrome --target lib/main.dart
```

إذا نجحت، نفّذ UAT بصري على صفحات التصنيف، بيانات الوثيقة، الرفع والحفظ، الوثائق، البحث، والمراجعة. لا تنتقل إلى Staging أو Supabase. الحوكمة تبقى صفحة فرعية.
