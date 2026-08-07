# Next Session Prompt — Module Health Label Compile Gate

ابدأ بالقراءة بالترتيب:
1. `PALWAKF_PLATFORM_COMPREHENSIVE_GUIDE.md`
2. `STATUS.txt`
3. `error_records/ERROR_RECORD.md`
4. `handoff/SESSION_HANDOFF_ARCHIVE_MODULE_HEALTH_LABEL_COMPILE_GATE_CORRECTION_20260704.md`
5. `uat/UAT_STATUS.md`

الحالة الحالية:
```text
CURRENT_CANDIDATE=ARCHIVE_MODULE_HEALTH_LABEL_COMPILE_GATE_CORRECTION_CANDIDATE_20260704
CURRENT_ERROR=ERR-ARCHIVE-20260704-03
ROOT_CAUSE=Dart extension not visible via transitive import
SOURCE_FIX=Direct contracts.dart import in lib/src/app.dart
STATIC_GUARD=IMPLEMENTED
LOCAL_FLUTTER_ANALYZE_TEST_BROWSER_UAT=PENDING
PLATFORM_INTEGRATION=FALSE
STAGING_INTEGRATION_AUTHORIZED=FALSE
PRODUCTION_APPROVAL=NOT_IMPLIED
```

المطلوب أولًا هو استلام نتائج هذه الأوامر من الحزمة الكاملة الجديدة:
```powershell
python tools\verify_module_reception_static.py
flutter pub get
flutter analyze
flutter test
flutter run -d chrome --target lib/main.dart
```

لا تبدأ SQL أو Supabase أو File Center أو GIS أو route assignment أو Platform binding قبل إغلاق `ERR-ARCHIVE-20260704-03`.
