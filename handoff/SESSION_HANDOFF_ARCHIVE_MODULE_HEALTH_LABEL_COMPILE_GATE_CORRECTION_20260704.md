# ملف توريث شامل — تصحيح بوابة تجميع وسم الحالة

```text
HANDOFF_ID=SESSION_HANDOFF_ARCHIVE_MODULE_HEALTH_LABEL_COMPILE_GATE_CORRECTION_20260704
DATE=2026-07-04
PROJECT=PalWakf Evidence Archive & Spatial Explorer
BATCH=MEGA_BATCH_EVIDENCE_ARCHIVE_MODULE_HEALTH_LABEL_COMPILE_GATE_CORRECTION_V1
TYPE=URGENT_NARROW_DART_COMPILE_GATE_CORRECTION
CURRENT_CANDIDATE=ARCHIVE_MODULE_HEALTH_LABEL_COMPILE_GATE_CORRECTION_CANDIDATE_20260704
PREVIOUS_CANDIDATE=ARCHIVE_CANONICAL_RUNTIME_ROOT_CORRECTION_CANDIDATE_20260704
CURRENT_ERROR=ERR-ARCHIVE-20260704-03
LOCAL_COMPILE_STATUS=PENDING_USER_RECHECK
LOCAL_TEST_STATUS=PENDING_USER_RECHECK
BROWSER_UAT_STATUS=PENDING_USER_RECHECK
STAGING_INTEGRATION_AUTHORIZED=FALSE
PRODUCTION_APPROVAL=NOT_IMPLIED
```

## 1. الملخص التنفيذي
بعد تصحيح مشكلة تشغيل قالب Flutter الافتراضي، شغّل المستخدم المشروع المعتمد ووصل Flutter إلى تطبيق الأرشيف الحقيقي. توقف التجميع قبل العرض بسبب خطأ واحد محدد في `lib/src/app.dart`:

```text
The getter 'label' isn't defined for the type 'ModuleHealthStatus'.
```

هذه ليست مشكلة في قيمة الحالة أو في منطق Health/Fallback أو في Riverpod أو في Chrome. العقد يعرّف extension صحيحًا باسم `ModuleHealthStatusLabel` داخل `lib/src/platform_integration/contracts.dart`، لكن Dart لا يجعل extensions القادمة من import متعدٍ متاحة تلقائيًا في مكتبة أخرى.

## 2. السبب الجذري المثبت
المسار السابق في `app.dart`:

```dart
import 'platform_integration/archive_platform_integration.dart';
// ...
integration.health.status.label
```

`archive_platform_integration.dart` يستورد `contracts.dart` داخليًا. هذا يكفي لاستخدام `ModuleHealthStatus` داخل ملف adapter، لكنه لا يصدّر extension `ModuleHealthStatusLabel` إلى `app.dart`.

**القاعدة في Dart:** يجب أن تستورد المكتبة التي تستخدم extension المكتبة التي تعرّفه، أو أن تستورد extension صراحة عبر export موثوق. لا يوجد export مقصود هنا لأن العقود تظل boundary صريحًا.

## 3. التصحيح المنفذ
تعديل وحيد في المصدر التشغيلي:

```dart
import 'platform_integration/contracts.dart';
```

أضيف بعد import الخاص بـ`archive_platform_integration.dart` داخل `lib/src/app.dart`.

أضيف أيضًا Guard إلى `tools/verify_module_reception_static.py` يتحقق من الآتي:
1. إذا استعملت الواجهة `integration.health.status.label`، فلابد من وجود import مباشر لـ`platform_integration/contracts.dart`.
2. لا بد أن يبقى تعريف `extension ModuleHealthStatusLabel on ModuleHealthStatus` موجودًا في ملف العقود.
3. يطبع النجاح `MODULE_HEALTH_LABEL_IMPORT=PASS`.

## 4. نطاق التغيير وحدوده
```text
CHANGED_SOURCE_FILES=2
SOURCE_LOGIC_CHANGE=IMPORT_VISIBILITY_ONLY
HEALTH_STATE_SEMANTICS=UNCHANGED
CAPABILITY_GATE=UNCHANGED
FEATURE_FLAGS=UNCHANGED
FIXTURE_UNIT_SCOPE=UNCHANGED
UI_LAYOUT=UNCHANGED
DATA_MODEL=UNCHANGED
DATABASE_MUTATION=NONE
SUPABASE_CONNECTION=NONE
FILE_CENTER_BINDING=NONE
GIS_BINDING=NONE
AUTH_RBAC_CHANGE=NONE
STAGING_AUTHORIZATION=FALSE
PRODUCTION_APPROVAL=NOT_IMPLIED
```

## 5. الحالة الحاكمة الحالية
- جذر التشغيل المعتمد لا يزال `archive_system/`.
- نقطة الدخول الوحيدة لا تزال `lib/main.dart`.
- لا يوجد `workspace/pubspec.yaml` نشط.
- خطأ Flutter Demo السابق يبقى موثقًا في `ERR-ARCHIVE-20260704-02` كمشكلة تغليف سابقة.
- الخطأ الجديد `ERR-ARCHIVE-20260704-03` هو بوابة التجميع الحالية ويجب إغلاقه أولًا.
- لا تبدأ أي عمل Supabase أو Staging أو File Center أو GIS أو Route Assignment قبل اجتياز Gates أدناه.

## 6. ما تم التحقق منه داخل بيئة إنشاء الحزمة
```text
DIRECT_IMPORT_PRESENT=PASS
EXTENSION_DECLARATION_PRESENT=PASS
STATIC_GUARD_PRESENT=PASS
MODULE_RECEPTION_STATIC_VERIFY=PASS
CANONICAL_RUNTIME_ROOT=PASS
DEFAULT_TEMPLATE_ENTRYPOINT=ABSENT
NESTED_FLUTTER_PROJECT=ABSENT
FLUTTER_ANALYZE=NOT_AVAILABLE_IN_THIS_PACKAGING_ENVIRONMENT
FLUTTER_TEST=NOT_AVAILABLE_IN_THIS_PACKAGING_ENVIRONMENT
BROWSER_UAT=NOT_RUN_AFTER_CORRECTION
```

لا يُعاد وصف هذا بأنه “نجاح Flutter” أو “UAT مقبول”. التحقق الديناميكي بقي على جهاز المستخدم فقط.

## 7. تنفيذ محلي مطلوب — بالترتيب
من جذر `archive_system` في الحزمة الكاملة الجديدة فقط:

```powershell
python tools\verify_module_reception_static.py
flutter pub get
flutter analyze
flutter test
flutter run -d chrome --target lib/main.dart
```

النتيجة المقبولة في Gate 0 تشمل:

```text
MODULE_RECEPTION_STATIC_VERIFY=PASS
MODULE_HEALTH_LABEL_IMPORT=PASS
```

النتيجة المقبولة في Gate 1:
- لا تظهر رسالة `ModuleHealthStatus` أو `label`.
- ينتهي `flutter analyze` و`flutter test` بـexit code 0.

النتيجة المقبولة في Gate 2:
- تظهر واجهة **PalWakf — أرشيف الأدلة والمستكشف المكاني** بالعربية وRTL.
- لا تظهر صفحة `Flutter Demo Home Page` ولا العداد.

## 8. UAT محلي محدود بعد إغلاق التجميع
بعد ظهور الواجهة:
1. افتح صفحة «الإدماج».
2. تحقق من الحالة المحلية الجاهزة.
3. جرّب Degraded ثم Disabled ثم Restore.
4. راقب Network؛ لا يجب أن تظهر طلبات Supabase أو Auth أو Database أو Storage أو File Center أو GIS من هذا fixture local mode.
5. احتفظ بدليلين فقط: لقطة الشاشة وملخص Console/Terminal قصير يثبت Gates PASS.

## 9. سجل الأخطاء
### ERR-ARCHIVE-20260704-02
- الحالة: يبقى مرجعًا لخلل تغليف الجذر السابق.
- الإغلاق: لم يعد فتح Flutter Demo من الحزمة الكاملة الجديدة.

### ERR-ARCHIVE-20260704-03
- الحالة: مفتوح حتى الإغلاق المحلي.
- السبب: extension visibility عبر import متعدٍ.
- الحل: import مباشر في `app.dart` + static guard.
- الإغلاق: `flutter analyze`, `flutter test`, وChrome pass من الحزمة الجديدة.

## 10. الملفات المرجعية بالترتيب عند أي جلسة لاحقة
1. `PALWAKF_PLATFORM_COMPREHENSIVE_GUIDE.md`
2. `STATUS.txt`
3. `error_records/ERROR_RECORD.md`
4. هذا الملف
5. `uat/UAT_STATUS.md`
6. `baseline_control/BASELINE_UPDATE_NOTES.md`
7. `CHANGELOG.md`

## 11. الجلسة التالية المسموح بها
العمل التالي ليس تطويرًا جديدًا. يجب أولًا استلام أدلة Gates 0–2 وإغلاق/تحديث السجلات. بعد إغلاقها فقط يمكن تقييم خطوة **Platform Intake and Staging Binding Design**، وهي تصميم واستقبال وحوكمة فقط، لا تطبيق مباشر على المنصة.
