# Next session prompt — Archive Access Publication Retention Audit

استأنف من baseline `PALWAKF_ARCHIVE_ACCESS_PUBLICATION_RETENTION_AUDIT_20260713` بعد تشغيل التحقق المحلي. الحالة: Daily UX First، صفحة `الإتاحة والتدقيق` أضيفت للتشغيل المحلي، والحوكمة لا تزال صفحة فرعية داخل الإدارة. قبل أي دفعة جديدة، تأكد من:

```powershell
cd C:\Users\DELL\StudioProjects\archive_system
python tools\verify_module_reception_static.py
flutter pub get
dart format lib test
flutter analyze
flutter test
flutter run -d chrome --target lib/main.dart
```

لا يوجد Remote/Staging/Production. الدفعة التالية المقترحة: `MEGA_BATCH_ARCHIVE_SPATIAL_TEMPORAL_ADVANCED_VIEWER_AND_RELATIONS_OPERATIONALIZATION_V1`.
