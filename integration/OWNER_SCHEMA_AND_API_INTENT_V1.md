# Owner Schema and API Intent — Evidence Archive V1

## النية فقط؛ لا تطبيق SQL
يحتاج النظام، بعد مراجعة المنصة، owner schema مقترحًا باسم `evidence_archive` أو الاسم الذي تعيّنه المنصة. لا ينشئ هذا baseline أي schema أو table أو view أو function أو grant.

## وحدات بيانات مقترحة
- `evidence_records`: metadata للدليل وليس الأصل الملفي.
- `archive_collections`: Collection/Fonds/Series/File/Item.
- `evidence_relations`: علاقات مرشحة مع rationale/confidence/workflow.
- `review_tasks`: مهام مراجعة وتدقيق.
- `import_batches`: فهرسة الدفعات ونتائج validation.
- `spatial_artifacts`: metadata لتمثيلات مكانية مشتقة فقط.

## قيود إلزامية
```text
PUBLIC_BASE_TABLES=FORBIDDEN
OWNER_SCHEMA=PLATFORM_APPROVAL_REQUIRED
DIRECT_CLIENT_DB_WRITE=FORBIDDEN
RAW_PLATFORM_RBAC_TABLE_ACCESS=FORBIDDEN
WAQF_ASSET_BINDING=waqf_asset_id_ONLY_WHEN_AUTHORIZED
DERIVED_SPATIAL_RESULT_NOT_LEGAL_BOUNDARY=TRUE
```

## API/RPC intent
القراءة والعمليات الحساسة تمر عبر repositories/services ثم endpoints أو RPCs مع:
- effective authority مركزي؛
- current unit context؛
- ownership/workflow state؛
- audit event؛
- file-object binding عند وجود ملف؛
- عدم كشف base tables عبر `public`.

## ربط `waqf_assets`
لا يصنع هذا المشروع أصلًا وقفيًا جديدًا ولا يقرر الربط. عند التفويض، يستخدم فقط `waqf_asset_id` كمفتاح ربط تشغيلي سيادي، مع بقاء `awqaf_system` مصدر Master Data.
