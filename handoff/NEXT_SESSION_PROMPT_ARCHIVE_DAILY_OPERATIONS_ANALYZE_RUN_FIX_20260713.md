# Next Session Prompt — Archive Daily Operations Analyze/Run Fix

ابدأ من baseline:

`PALWAKF_ARCHIVE_DAILY_OPERATIONS_PRE_DELIVERY_ANALYZE_RUN_FIX_BASELINE_20260713`

أول إجراء مطلوب: اطلب نتائج:

```powershell
python tools\verify_module_reception_static.py
flutter pub get
dart format lib test
flutter analyze
flutter test
flutter run -d chrome --target lib/main.dart
```

لا تبدأ التطوير الكبير التالي قبل `flutter analyze/test/run = PASS`.

الحوكمة ثابتة: لا Remote، لا Staging، لا Production.
