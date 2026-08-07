# ARCHIVE UI/UX FOUNDATIONAL ERROR GATE REPAIR V1

## Batch

`MEGA_BATCH_ARCHIVE_UI_UX_FOUNDATIONAL_ERROR_GATE_REPAIR_V1`

## Purpose

تثبيت بوابة أخطاء تأسيسية قبل أي تطوير واجهات إضافي، بحيث لا تستمر أخطاء الـUI/UX نفسها عبر الدفعات اللاحقة.

## Diagnosed issues

1. اختبار `governance remains an administration subpage only` كان هشًا لأنه يقارن أول ظهور نصي لعبارتي `الإدارة` و`الحوكمة والتكامل` بدل التأكد من وجود مدخل `governance` داخل كتلة مجموعة الإدارة.
2. Assertion متكرر في Flutter Runtime:

```text
ListTile background color or ink splashes may be invisible
```

السبب أن `ExpansionTile` يستخدم داخليًا `ListTile`، وكان داخل `DecoratedBox` في السايد بار الواسع. التغليف السابق لصفوف `_NavigationRow` لم يعالج ListTile الداخلي الخاص بـ`ExpansionTile`.

## Implemented repair

- إضافة `SIDEBAR_LIST_MATERIAL_BOUNDARY` حول قائمة السايد بار.
- إضافة `NAVIGATION_GROUP_EXPANSION_MATERIAL_BOUNDARY` حول كل `ExpansionTile` داخل `_NavigationGroupTile`.
- تحديث اختبار `ui_ux_grouped_sidebar_refocus_test.dart` ليتحقق من موضع `governance` داخل كتلة الإدارة بدل اختبار نصي هش.
- تقوية `tools/verify_module_reception_static.py` بفحوص تفشل إذا عاد `ExpansionTile` داخل `DecoratedBox` دون Material boundary.

## Governance

```text
PALWAKF_REMOTE_INTEGRATION=NOT_CONNECTED_BY_DESIGN
STAGING_APPROVAL=NOT_APPROVED
PRODUCTION_APPROVAL=NOT_APPROVED
```

No Supabase, database mutation, File Center, GIS, staging, or production activation is introduced.

## Required local verification

```powershell
cd C:\Users\DELL\StudioProjects\archive_system
python tools\verify_module_reception_static.py
flutter pub get
dart format lib test
flutter analyze
flutter test
flutter run -d chrome --target lib/main.dart
```

Acceptance requires no `ListTile background color or ink splashes may be invisible` assertion and all tests passing.
