# MEGA_BATCH_ARCHIVE_PRODUCTIVE_DOCUMENT_DETAIL_ADD_FLOW_AND_GOVERNED_WORKFLOW_V1

## الهدف
تطوير متوازٍ يجمع بين التشغيل الإنتاجي اليومي، تحسين واجهات المستخدم، والحوكمة الداعمة داخل الإدارة. هذه الدفعة لا تضيف حوكمة مستقلة، بل تجعل مسار **إضافة وثيقة** و**تفاصيل الوثيقة** أكثر عملية ومحكومًا محليًا.

## نطاق التشغيل اليومي
- تحويل صفحة إضافة وثيقة إلى تدفق متعدد الخطوات: بيانات أساسية، تصنيف وإتاحة، تمثيل أولي، مراجعة وحوكمة.
- إنشاء وثيقة محلية عبر عملية واحدة في `LocalOperationalController`.
- إنشاء تمثيل أولي اختياري عند الإدخال.
- إنشاء مهمة مراجعة محلية اختيارية عند الحفظ.
- تسجيل حدث تدقيق محلي عند إنشاء الوثيقة وأثناء إجراءات التفاصيل.
- تحويل صفحة تفاصيل الوثيقة إلى تبويبات إنتاجية: نظرة عامة، البيانات، الملفات، المراجعة، الإتاحة والتدقيق، العلاقات.

## حدود الحوكمة
- `PALWAKF_REMOTE_INTEGRATION=NOT_CONNECTED_BY_DESIGN`
- `STAGING_APPROVAL=NOT_APPROVED`
- `PRODUCTION_APPROVAL=NOT_APPROVED`
- لا Supabase، لا File Center، لا GIS، لا قاعدة بيانات، لا نشر فعلي.

## حواجز القبول المضافة
- `PRODUCTIVE_DOCUMENT_DETAIL_ADD_FLOW_AND_GOVERNED_WORKFLOW=PASS`
- `ADD_DOCUMENT_MULTI_STEP_FLOW=PASS`
- `GOVERNED_DOCUMENT_DRAFT_CREATION=PASS`
- `DOCUMENT_INTAKE_VALIDATION_RULES=PASS`
- `DOCUMENT_DETAIL_GOVERNED_TABS=PASS`
- `WORKFLOW_AUDIT_ON_DOCUMENT_ACTIONS=PASS`

## التحقق المطلوب محليًا
```powershell
cd C:\Users\DELL\StudioProjects\archive_system
python tools\verify_module_reception_static.py
flutter pub get
dart format lib test
flutter analyze
flutter test
flutter run -d chrome --target lib/main.dart
```
