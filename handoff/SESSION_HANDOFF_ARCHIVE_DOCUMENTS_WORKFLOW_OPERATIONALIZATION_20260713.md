# Session Handoff — Archive Documents and Workflow Operationalization — 2026-07-13

## Batch

`MEGA_BATCH_ARCHIVE_DOCUMENTS_AND_WORKFLOW_OPERATIONALIZATION_V1`

## Parent accepted baseline

`PALWAKF_ARCHIVE_DAILY_OPERATIONS_PRE_DELIVERY_ANALYZE_RUN_FIX_BASELINE_20260713`

## Purpose

تحويل صفحات الوثائق وسير العمل من واجهات تشغيل أولية إلى سطح يومي أكثر واقعية:

- قائمة وثائق بفلترة ومؤشرات وإجراءات.
- تفاصيل وثيقة ببيانات وتمثيلات ومهام مراجعة وعلاقات.
- لوحة مراجعة قابلة لتغيير الحالة والاعتماد الداخلي.
- دورة حياة حية تعرض الوثائق الحالية وتدعم الانتقالات المحلية.
- بحث متقدم بفلاتر المجال والحالة والإتاحة والمكان وربط `waqf_asset_id`.
- كتالوج استيراد يدعم انتقالات الحالة محليًا.

## Local-only controller additions

- `submitEvidenceForReview(String id)`
- `addReviewTask(ReviewTask task)`
- `completeReviewTaskAndApprove(String taskId)`
- `returnReviewTaskForCorrection(String taskId)`

All methods enforce `LOCAL-DEMO-UNIT` scope and mutate Riverpod session memory only.

## Static verification

```text
MODULE_RECEPTION_STATIC_VERIFY=PASS
DOCUMENTS_WORKFLOW_OPERATIONALIZATION=PASS
EVIDENCE_WORKFLOW_ACTION_BAR=PASS
DOCUMENT_DETAIL_OPERATIONAL_TABS=PASS
REVIEW_QUEUE_WORKFLOW_ACTIONS=PASS
DOCUMENT_LIFECYCLE_OPERATIONAL_BOARD=PASS
SMART_SEARCH_ADVANCED_FILTERS=PASS
IMPORT_WORKFLOW_STATUS_ADVANCEMENT=PASS
PLATFORM_MUTATION=NONE
DATABASE_MUTATION=NONE
PRODUCTION_APPROVAL=NOT_IMPLIED
```

## Required local verification after apply

```powershell
cd C:\Users\Firas_Fanon\StudioProjects\archive_system
python tools\verify_module_reception_static.py
flutter pub get
dart format lib test
flutter analyze
flutter test
flutter run -d chrome --target lib/main.dart
```

## Browser UAT checklist

- افتح صفحة الوثائق وتأكد من ظهور الفلاتر وإجراءات: فتح، مراجعة، اعتماد، حجر/استعادة.
- افتح تفاصيل وثيقة وتأكد من ظهور metadata والتمثيلات والمراجعات والعلاقات.
- جرّب إرسال وثيقة للمراجعة ثم افتح صفحة المراجعة.
- جرّب إكمال واعتماد مهمة مراجعة وتأكد من تغير حالة الوثيقة إلى `جاهز داخليًا`.
- افتح دورة حياة الوثيقة وجرب الانتقالات المحلية.
- افتح الفهرس والبحث وجرب فلاتر الإتاحة والمكان وربط الأصل الوقفي.
- افتح الاستيراد وجرب تحديث حالة دفعة إلى `متحقق` أو `جاهز` أو `مرفوض`.

## Boundaries

```text
PALWAKF_REMOTE_INTEGRATION=NOT_CONNECTED_BY_DESIGN
STAGING_APPROVAL=NOT_APPROVED
PRODUCTION_APPROVAL=NOT_APPROVED
NO_SUPABASE_CONNECTION
NO_DATABASE_MUTATION
NO_FILE_CENTER_MUTATION
NO_GIS_MUTATION
NO_PLATFORM_CORE_PATCH
```

## Next recommended batch after acceptance

`MEGA_BATCH_ARCHIVE_DOCUMENT_DETAIL_AND_FILE_PREVIEW_PRODUCTIZATION_V1`

Suggested scope: richer detail screen layout, preview placeholder, notes, attachments, metadata validation hints, and better responsive presentation.
