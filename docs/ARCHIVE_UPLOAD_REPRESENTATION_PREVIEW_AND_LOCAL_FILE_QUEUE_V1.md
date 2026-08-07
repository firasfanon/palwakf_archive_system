# MEGA_BATCH_ARCHIVE_UPLOAD_REPRESENTATION_PREVIEW_AND_LOCAL_FILE_QUEUE_V1

## الغرض

تطوير مرحلة **Upload & Representations** من خارطة طريق الأرشيف عبر تحويل صفحة الرفع والحفظ والتمثيلات إلى مساحة تشغيل إنتاجية محلية، مع تحسين UI/UX وإضافة حوكمة داعمة تمنع استبدال الأصل دون مسار تدقيق.

## Parent Baseline

```text
PALWAKF_ARCHIVE_PRODUCTIVE_DOCUMENT_DETAIL_ADD_FLOW_TEST_CONTRACT_REPAIR_20260714_BASELINE
```

## النطاق

- تشغيل يومي: إضافة تمثيل إلى طابور رفع محلي مرتبط بوثيقة موجودة.
- UI/UX: معاينة تمثيل محلي، مؤشرات طابور، بطاقات تمثيلات، وتجميع حسب الوثيقة.
- حوكمة: منع استبدال الأصل الموجود، إضافة Audit محلي، وعدم إظهار مسارات ملفات أو File Center.
- لا Supabase، لا File Center، لا storage bucket، لا virus scan فعلي، لا Staging، لا Production.

## الملفات المعدلة

```text
lib/src/core/models/models.dart
lib/src/core/state/local_operational_store.dart
lib/src/features/daily/upload_storage_screen.dart
lib/src/features/representations/representations_screen.dart
test/upload_representation_preview_queue_test.dart
tools/verify_module_reception_static.py
```

## المخرجات التشغيلية

- `queueLocalRepresentation(...)` لإنشاء تمثيل داخل طابور محلي مع hash preview وحقوق وحجم وصفي وملاحظة معاينة.
- `markRepresentationReviewed(...)` لوسم التمثيل كمراجع محليًا.
- حقول جديدة على `ArchiveRepresentation`: `uploadStatus`, `fileSizeLabel`, `previewKind`, `previewNote`.
- مؤشرات: كل التمثيلات، في الطابور، الأصول، حظر استبدال الأصل.
- شاشة التمثيلات تعرض التمثيلات مجمعة حسب الوثيقة وتدعم وسم المراجعة.

## حواجز التحقق

```text
UPLOAD_REPRESENTATION_PREVIEW_AND_LOCAL_FILE_QUEUE=PASS
REPRESENTATION_PREVIEW_PANEL=PASS
LOCAL_FILE_QUEUE=PASS
REPRESENTATION_MANAGER_REFINEMENT=PASS
ORIGINAL_REPLACEMENT_GUARD_LOCAL=PASS
REPRESENTATION_REVIEW_ACTION=PASS
PLATFORM_MUTATION=NONE
DATABASE_MUTATION=NONE
PRODUCTION_APPROVAL=NOT_IMPLIED
```

## أوامر التحقق المحلي المطلوبة

```powershell
cd C:\Users\DELL\StudioProjects\archive_system
python tools\verify_module_reception_static.py
flutter pub get
dart format lib test
flutter analyze
flutter test
flutter run -d chrome --target lib/main.dart
```

## الحدود الحاكمة

```text
PALWAKF_REMOTE_INTEGRATION=NOT_CONNECTED_BY_DESIGN
STAGING_APPROVAL=NOT_APPROVED
PRODUCTION_APPROVAL=NOT_APPROVED
```
