# Apply instructions — Smart Indexing OCR Dedup Updates Only

1. طبّق ZIP التحديثات فوق آخر baseline مقبول:
   `PALWAKF_ARCHIVE_REPORTS_NOTIFICATIONS_BACKUP_EXPORT_20260713_BASELINE`.
2. من جذر المشروع نفّذ:

```powershell
python tools\verify_module_reception_static.py
flutter pub get
dart format lib test
flutter analyze
flutter test
flutter run -d chrome --target lib/main.dart
```

3. لا تعتمد الدفعة إلا إذا رجعت بوابات Flutter بدون أخطاء.
4. لا تفعل أي ربط بعيد؛ الحدود ما زالت محلية فقط.
