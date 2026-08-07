# Canonical Runtime Root — Evidence Archive

```text
CANONICAL_FLUTTER_PROJECT_ROOT=archive_system/
CANONICAL_ENTRYPOINT=lib/main.dart
CANONICAL_PUBSPEC=pubspec.yaml
CANONICAL_TEST_ROOT=test/
CANONICAL_INTEGRATION_KIT=integration/
NESTED_FLUTTER_WORKSPACE=REMOVED
```

## سبب هذا الملف
تم اكتشاف أن الحزمة السابقة احتوت مشروعَي Flutter داخل نفس المجلد:
- جذر `archive_system/` كان يحمل قالب Flutter الافتراضي.
- التطبيق الحقيقي كان داخل `archive_system/workspace/`.

عند التشغيل من IDE على `lib/main.dart` في الجذر، شُغّل قالب العداد الافتراضي بدل أرشيف الأدلة. هذه ليست مشكلة Chrome أو Flutter أو الاعتمادات، بل **خلل تغليف ومسار تشغيل**.

## القاعدة الآن
شغّل هذا المشروع من الجذر فقط:

```text
cd <archive_system>
flutter pub get
flutter analyze
flutter test
flutter run -d chrome
```

لا توجد الآن حزمة Flutter متداخلة أو `workspace/pubspec.yaml`. ظهور شريط عنوان عربي باسم:
`PalWakf — أرشيف الأدلة والمستكشف المكاني`
هو مؤشر التشغيل الصحيح.

## الحدود السيادية لم تتغير
- لا اتصال Supabase أو منصة PalWakf.
- لا Login أو RBAC محلي.
- لا SQL أو قاعدة بيانات أو تخزين أو GIS فعلي.
- لا موافقة Staging أو Production.

## بوابة التجميع الحالية
بعد إغلاق مشكلة الجذر، يجب أيضًا استعمال الحزمة التي تحتوي تصحيح `ModuleHealthStatusLabel`.
إذا ظهر الخطأ المرتبط بـ`label`، فهذا يعني أنك ما زلت تشغّل حزمة أقدم أو لم تستبدل
`lib/src/app.dart`. تحقق من:

```text
python tools\verify_module_reception_static.py
# Expected: MODULE_HEALTH_LABEL_IMPORT=PASS
```

ثم نفّذ `flutter analyze` و`flutter test` قبل Browser UAT.
