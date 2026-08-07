# MEGA_BATCH_ARCHIVE_UI_UX_FOUNDATIONAL_ERROR_GATE_REPAIR_R2

## الهدف
إغلاق أخطاء UI/UX grouped sidebar من الجذر قبل أي تطوير إضافي.

## التشخيص
- اختبار `governance remains an administration subpage only` كان هشًا لأنه يعتمد على مواضع نصية قابلة للتغير بعد `dart format`.
- بقاء `ExpansionTile` داخل side shell مزخرف بـ`DecoratedBox` سبب Assertion متكرر في Flutter Web Debug: `ListTile background color or ink splashes may be invisible`.

## التصحيح
- استبدال `ExpansionTile` في `lib/src/app.dart` بمكوّن custom `StatefulWidget` يستخدم `Material + ListTile` مباشرة.
- إضافة markers صريحة: `ADMIN_GROUP_START`, `GOVERNANCE_ADMIN_SUBPAGE_ENTRY`, `CUSTOM_NAVIGATION_GROUP_TILE`.
- إصلاح اختبار `ui_ux_grouped_sidebar_refocus_test.dart` ليعتمد على markers وبنية قابلة للصمود بعد format.
- تقوية `tools/verify_module_reception_static.py` بحواجز: `CUSTOM_NAVIGATION_GROUP_TILE=PASS`, `NO_EXPANSION_TILE_IN_SIDEBAR=PASS`, `ROBUST_GOVERNANCE_ADMIN_TEST=PASS`.

## الحدود
`PALWAKF_REMOTE_INTEGRATION=NOT_CONNECTED_BY_DESIGN`
`STAGING_APPROVAL=NOT_APPROVED`
`PRODUCTION_APPROVAL=NOT_APPROVED`

## أوامر التحقق المحلي
```powershell
cd C:\Users\DELL\StudioProjects\archive_system
python tools\verify_module_reception_static.py
flutter pub get
dart format lib test
flutter analyze
flutter test
flutter run -d chrome --target lib/main.dart
```
