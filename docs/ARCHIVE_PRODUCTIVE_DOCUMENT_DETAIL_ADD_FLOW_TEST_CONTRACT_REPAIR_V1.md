# MEGA_BATCH_ARCHIVE_PRODUCTIVE_DOCUMENT_DETAIL_ADD_FLOW_TEST_CONTRACT_REPAIR_V1

تصحيح تعاقد اختبار واجهة إضافة الوثيقة بعد دفعة Document Intake & Detail.

## السبب

اختبار `productive document surfaces and add document flow are visible` كان يتطلب ظهور النص التشغيلي `حفظ وثيقة محليًا` داخل `AddDocumentScreen`، بينما كان زر الخطوة الأخيرة يعرض `حفظ الوثيقة`.

## التصحيح

- تحديث زر الحفظ النهائي في `lib/src/features/daily/add_document_screen.dart` إلى `حفظ وثيقة محليًا`.
- تقوية `tools/verify_module_reception_static.py` بحاجز `ADD_DOCUMENT_LOCAL_SAVE_LABEL=PASS`.
- لا تغيير في قاعدة البيانات أو الربط الخارجي أو Staging أو Production.

## الحدود

```text
PALWAKF_REMOTE_INTEGRATION=NOT_CONNECTED_BY_DESIGN
STAGING_APPROVAL=NOT_APPROVED
PRODUCTION_APPROVAL=NOT_APPROVED
```
