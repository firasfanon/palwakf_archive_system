# Unit Scope Matrix — Evidence Archive V1

## المبدأ
قرار الوصول المستقبلي:
```text
ACCESS_DECISION =
SYSTEM_CAPABILITY
+ EFFECTIVE_AUTHORITY
+ AUTHORIZED_ORG_UNIT_SCOPE
+ CURRENT_UNIT_CONTEXT
+ DATA_OWNERSHIP
+ WORKFLOW_STATE
```

`LOCAL-DEMO-UNIT` في المشروع الحالي fixture فقط، ولا يمثل `core.org_units` أو تفويضًا لمنظمة فعلية.

| المورد/العملية | سياق وحدة مطلوب | قراءة cross-unit | كتابة cross-unit | الحوكمة الحالية |
|---|---:|---:|---:|---|
| EvidenceItem | نعم | مرفوض افتراضيًا | مرفوض افتراضيًا | local mock + server-side required |
| ArchiveCollection | نعم | مرفوض افتراضيًا | مرفوض افتراضيًا | local mock + server-side required |
| EvidenceRelation | نعم، للطرفين | مرفوض افتراضيًا | مرفوض افتراضيًا | يرفض اختلاف وحدة المصدر/الهدف |
| ReviewTask | نعم | مرفوض افتراضيًا | مرفوض افتراضيًا | local mock + workflow pending |
| ImportBatch | نعم | مرفوض افتراضيًا | مرفوض افتراضيًا | local mock only |
| File Object | نعم | مرفوض | مرفوض | Platform File Center required |
| GIS Layer/Result | نعم | مرفوض | مرفوض | Platform GIS binding required |

## Super Admin
`super_admin` يمتلك سلطة مباشرة شاملة في PalWakf، لكنه ينفذ العمليات المرتبطة بوحدة ضمن `current_unit_context` واضح ومسجل تدقيقيًا. لا توجد محاكاة محلية لـSuper Admin في هذا المشروع.

## قبول الاختبار
- `cross_unit_read_denial`: متطلب staging.
- `cross_unit_write_denial`: منع محلي تجريبي موجود؛ إثبات الخادم مؤجل للمنصة.
- `cross_unit_file_denial`: BLOCKED إلى File Center binding.
- `cross_unit_map_denial`: BLOCKED إلى GIS binding.
