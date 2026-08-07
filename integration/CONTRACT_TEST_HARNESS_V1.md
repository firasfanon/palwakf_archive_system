# Contract Test Harness — Evidence Archive V1

## الاختبارات المضافة
`test/platform_integration_contract_test.dart` يختبر محليًا:
1. تعريف `evidence_archive` وسياق local development host.
2. Route slots منطقية ولا تحتوي URL إنتاجي.
3. السماح لمجموعة capabilities محلية آمنة داخل `LOCAL-DEMO-UNIT` فقط.
4. رفض cross-unit access.
5. رفض file-object وGIS capabilities لحين binding منصي.
6. تبديل disabled mode إلى fallback state ثم استعادته.
7. منع `LocalOperationalController` من إضافة دليل خارج نطاق fixture المحلي.

## كيفية التشغيل في البيئة التي تحوي Flutter
```text
cd archive_system
flutter pub get
dart format lib test
flutter analyze
flutter test
```

## حدود الدليل
غياب Flutter/Dart في بيئة إنشاء الحزمة الحالية يعني أن الاختبارات لم تُنفذ هنا. لا تستبدل نتيجة static review بنتيجة Flutter analyze أو browser UAT.
