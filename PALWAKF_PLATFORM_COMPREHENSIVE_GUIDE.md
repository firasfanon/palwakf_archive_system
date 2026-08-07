# PALWAKF Platform Comprehensive Guide — Archive Module Continuity Derivative

```text
DOCUMENT_ID=PALWAKF_PLATFORM_COMPREHENSIVE_GUIDE
SCOPE=EVIDENCE_ARCHIVE_PROJECT_CONTINUITY_DERIVATIVE
GLOBAL_MASTER_STATUS=NOT_INCLUDED_IN_THIS_INPUT
CANONICAL_RECONCILIATION_REQUIRED=TRUE
LAST_UPDATED=2026-07-13
LAST_SUCCESSFUL_SOURCE_BATCH=MEGA_BATCH_ARCHIVE_REQUIREMENTS_MEMORY_AND_PROJECT_DOCUMENTATION_V1
CURRENT_CANDIDATE_UAT_STATUS=PENDING_LOCAL_FLUTTER_ANALYZE_TEST_AND_BROWSER_VERIFICATION
REMOTE_INTEGRATION=NOT_CONNECTED_BY_DESIGN
STAGING_APPROVAL=NOT_APPROVED
PRODUCTION_APPROVAL=NOT_APPROVED
```

## 1. المرجعية المستخدمة
1. `PALWAKF_MODULE_FACTORY_AND_PLATFORM_RECEPTION_FRAMEWORK_V1`، الإصدار `1.0.0`، الحالة `GOVERNING_DRAFT_FOR_PROJECT_PILOT`.
2. تعليمات PalWakf السيادية الثابتة: `waqf_assets` هو الكيان التشغيلي المركزي، و`awqaf_system` هو Master Data، و`public` يقتصر على views/RPC wrappers، ولا يستخدم `legacy.dart` في ملفات جديدة.
3. baseline الأرشيف المصحح بعد إغلاق الجذر التشغيلي القانوني وخطأ `ModuleHealthStatus.label`.
4. دليل التشغيل المحلي المقبول: `CANONICAL_RUNTIME_ROOT_BROWSER_SMOKE_TEST=PASS`, `MODULE_HEALTH_LABEL_COMPILE_GATE=PASS`, `LOCAL_FIXTURE_SCOPE_RENDER=PASS`.

> هذا ملف استمرارية خاص بمشروع الأرشيف، وليس بديلاً عن ملف PalWakf الشامل المركزي. عند إتاحة الدليل المركزي النهائي، يجب إجراء reconciliation قبل أي إدماج منصي.

## 2. هوية الموديول
```text
MODULE_ID=evidence_archive
DISPLAY_NAME_AR=أرشيف الأدلة والمستكشف المكاني
LIFECYCLE_MODE=in_progress_module_development
TECHNOLOGY=Flutter + flutter_riverpod
CANONICAL_LOCAL_HOST=archive_system/
CANONICAL_ENTRYPOINT=lib/main.dart
NESTED_FLUTTER_PROJECT=FORBIDDEN
STANDALONE_PRODUCTION_RUNTIME=FORBIDDEN
```

## 3. المسار الإنتاجي المحلي المعتمد
تم تنفيذ السطح المحلي الكامل دفعة واحدة وفق المسار:

```text
Local Product → Core Archive → Evidence → Review → Spatial/Search → Admin → Staging Readiness → Controlled UAT → Production Readiness
```

الوظائف المضافة محليًا:
- Local Product Foundation.
- Core Archive: `Fonds → Series → File → Item`.
- Evidence Registry.
- Representations.
- Search & Discovery.
- Temporal Explorer.
- Admin Governance Console.
- Staging Readiness.
- Controlled Remote UAT planning.
- Production Readiness blocker screen.

## 4. الحدود السيادية الثابتة
```text
NO_INDEPENDENT_LOGIN
NO_LOCAL_PRODUCTION_RBAC
NO_LOCAL_ORG_UNIT_REGISTRY
NO_HARDCODED_PRODUCTION_ROUTE
NO_PUBLIC_BASE_TABLES
NO_DIRECT_CLIENT_PLATFORM_STORAGE_WRITE
NO_DIRECT_CLIENT_PLATFORM_AUTHORIZATION
NO_SUPABASE_CONNECTION_IN_THIS_BASELINE
NO_DATABASE_MUTATION
NO_STORAGE_MIGRATION
NO_FILE_CENTER_MUTATION
NO_GIS_MUTATION
PALWAKF_REMOTE_INTEGRATION=NOT_CONNECTED_BY_DESIGN
STAGING_APPROVAL=NOT_APPROVED
PRODUCTION_APPROVAL=NOT_APPROVED
```

## 5. ربط الأنظمة لاحقًا
- `waqf_assets` هو الكيان التشغيلي المركزي، والربط اللاحق يكون عبر `waqf_asset_id` فقط بعد Staging readiness.
- `awqaf_system` يبقى Master Data وليس مخزن وثائق الأرشيف.
- `mustakshif` للتحليل المكاني/التاريخي فقط، ولا يحل محل GIS/PostGIS المعتمد.
- `cases` يستقبل روابط أدلة معتمدة لاحقًا، ولا يدير الأرشيف نفسه.
- `assistant` يستقبل معرفة مشتقة فقط بعد اعتماد المصدر والحقوق.
- `public` يبقى للـviews/RPC wrappers فقط؛ لا جداول سيادية فيه.

## 6. حالة الإدماج
```text
PLATFORM_ADAPTER_BOUNDARY=PREPARED
ROUTE_SLOTS=DECLARED_LOGICALLY_ONLY
UNIT_SCOPE=LOCAL_MOCK_ONLY
SERVER_SIDE_ENFORCEMENT=REQUIRED_NOT_PROVEN
CAPABILITY_GATE=LOCAL_FIXTURE_IMPLEMENTED
FEATURE_FLAG_AND_KILL_SWITCH=LOCAL_SIMULATION_IMPLEMENTED
MODULE_HEALTH_AND_FALLBACK=LOCAL_SIMULATION_IMPLEMENTED
FILE_CENTER_BINDING=BLOCKED_PENDING_PLATFORM
GIS_BINDING=BLOCKED_PENDING_PLATFORM
AUDIT_BINDING=BLOCKED_PENDING_PLATFORM
PLATFORM_INTEGRATED=FALSE
STAGING_INTEGRATION_AUTHORIZED=FALSE
PRODUCTION_APPROVAL=NOT_APPROVED
```

## 7. آخر تحقق ساكن
```text
MODULE_RECEPTION_STATIC_VERIFY=PASS
CANONICAL_RUNTIME_ROOT=PASS
DEFAULT_TEMPLATE_ENTRYPOINT=ABSENT
NESTED_FLUTTER_PROJECT=ABSENT
STATIC_POLICY_SCAN=PASS
UNIT_SCOPE_CONSTRUCTOR_SCAN=PASS
MODULE_HEALTH_LABEL_IMPORT=PASS
FULL_PRODUCT_PIPELINE_MARKERS=PASS
LOCAL_PRODUCT_TO_PRODUCTION_READINESS_SURFACE=PASS
PLATFORM_MUTATION=NONE
DATABASE_MUTATION=NONE
PRODUCTION_APPROVAL=NOT_IMPLIED
```

## 8. التحقق المحلي المطلوب قبل قبول الدفعة بصريًا
```powershell
cd <archive_system>
python tools\verify_module_reception_static.py
flutter pub get
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
flutter run -d chrome --target lib/main.dart
```

## 9. قرار الخطوة التالية
لا يتم تفعيل الربط المباشر. أي خطوة لاحقة يجب أن تبدأ بحزمة:

```text
MEGA_BATCH_ARCHIVE_STAGING_INTEGRATION_READINESS_AND_CONTROLLED_REMOTE_UAT_V1
```

وذلك فقط بعد قبول visual/browser UAT للدفعة المحلية الكاملة.

## Archive compile-gate correction — 2026-07-13

The Evidence Archive full product pipeline remains local-only. The correction batch fixes compile-gate drift without changing platform integration boundaries.

Current governing state:

```text
PALWAKF_REMOTE_INTEGRATION=NOT_CONNECTED_BY_DESIGN
STAGING_APPROVAL=NOT_APPROVED
PRODUCTION_APPROVAL=NOT_APPROVED
```

Implementation rules added:

- Screens that use enum label extensions must directly import the model contract defining those extensions.
- Analyzer must not compile historical backup trees.
- Updates-only overlays must include cleanup actions for obsolete source/test paths when prior local trees contain stale files.
- Stale `workbench`/`viewer` sources from older archive batches are not part of the current full product pipeline unless rebuilt under the current model contract.

## Archive System Update — Daily UX First Refocus — 2026-07-13

The Evidence Archive module must prioritize day-to-day archive work for end users. Governance and platform readiness remain mandatory, but they must live under Admin/Governance subpages rather than dominating the primary navigation.

### Required daily user surfaces

- Home/dashboard for archive operations.
- Administrative document classification by department, topic, type, and archival hierarchy.
- Document metadata model and data-entry guidance.
- Upload and storage workflow design for originals and representations.
- User permission model and operational roles.
- Document lifecycle from intake through review, approval, restriction, publication candidate, retention, and archival closure.
- Smart search and discovery design.
- Archiving steps checklist.
- Security and backup requirements.
- Initial technical blueprint.

### Governance placement rule

Governance, Platform Integration Readiness, Staging Readiness, Controlled UAT, and Production Readiness must not be primary daily navigation items. They are subpages under Admin/Governance. Production remains blocked unless explicit approval is granted.

Current boundary markers remain:

```text
PALWAKF_REMOTE_INTEGRATION=NOT_CONNECTED_BY_DESIGN
STAGING_APPROVAL=NOT_APPROVED
PRODUCTION_APPROVAL=NOT_APPROVED
```


## Archive Electronic Archiving Site Requirements — Stored Project Reference — 2026-07-13

The project now includes a dedicated requirements reference file:

```text
DOCUMENT_ID=ARCHIVE_ELECTRONIC_SYSTEM_REQUIREMENTS_V1
PATH=docs/ARCHIVE_ELECTRONIC_SYSTEM_REQUIREMENTS_V1.md
UX_DIRECTION=DAILY_USER_EXPERIENCE_FIRST
GOVERNANCE_PLACEMENT=ADMIN_GOVERNANCE_SUBPAGE_ONLY
```

### Requirements now stored as project guidance

- System description, objectives, beneficiaries, and daily-use surfaces.
- Administrative document classification by department, topic, type, year, secrecy, state, location, and relationship.
- Document metadata model, including required fields and advanced optional fields.
- File upload and storage model: original, preview, OCR, thumbnail, hash, and immutable audit.
- RBAC roles and permissions matrix.
- Document lifecycle and review workflow.
- Smart search, advanced filters, OCR, AI classification, duplicate detection, and approved-document-only AI usage.
- Daily archiving operational steps.
- User services, admin services, and advanced services.
- Security, audit log, backup, restore, UX/UI, dashboard, document-detail page, technical blueprint, database model, integrations, performance, reports, alerts, tests, and acceptance criteria.

### Boundary remains unchanged

```text
PALWAKF_REMOTE_INTEGRATION=NOT_CONNECTED_BY_DESIGN
STAGING_APPROVAL=NOT_APPROVED
PRODUCTION_APPROVAL=NOT_APPROVED
```

No platform, database, File Center, GIS, or production mutation is implied by this documentation patch.

## Archive Analyze/Run Compile Gate Fix — 2026-07-13

This narrow correction must be treated as the active baseline before any larger archive development work.

```text
BATCH=MEGA_BATCH_ARCHIVE_ANALYZE_RUN_COMPILE_GATE_FIX_V1
PURPOSE=FIX_LOCAL_FLUTTER_ANALYZE_AND_RUN_BLOCKERS
SCOPE=NARROW_SOURCE_CLEANUP_ONLY
```

### Rules reinforced

- A screen/widget instantiated from `app.dart` must be directly imported in `app.dart`; do not rely on indirect exports/imports.
- Do not wrap non-const Material button constructors inside const list literals.
- New daily UX files should avoid deprecated Flutter APIs where the user's SDK reports replacements.
- Static verification must guard against compile-gate regressions, but it does not replace `flutter analyze`, `flutter test`, or browser UAT.

### Current boundary remains

```text
PALWAKF_REMOTE_INTEGRATION=NOT_CONNECTED_BY_DESIGN
STAGING_APPROVAL=NOT_APPROVED
PRODUCTION_APPROVAL=NOT_APPROVED
```


### Archive UI Runtime Guard — 20260713

For the Evidence Archive daily UX shell, side-navigation `ListTile` widgets must not be placed under a `DecoratedBox` without their own `Material` ancestor. The accepted pattern is `Material(color: Colors.transparent, child: ListTile(...))` and the verifier marker is `LIST_TILE_MATERIAL_BOUNDARY=PASS`. This is a UI runtime stability rule only and does not alter platform integration state.

## Archive Daily Operations Full UI Implementation — 2026-07-13

The active archive product direction is now `DAILY_OPERATIONS_FULL_UI_IMPLEMENTATION_V1`: daily-use pages must be operational first, not merely governance or requirements documentation pages.

### Accepted implementation principles

- The main surface is for daily users: add/search/classify/review/upload/document metadata.
- Governance, Staging readiness, Controlled UAT, Production readiness, and platform integration health stay under Admin/Governance subpages.
- Local session operations may update in-memory Riverpod state only.
- Local upload means adding a representation draft; it must not create remote File Center objects.
- Classification node creation is local only and remains scoped to `LOCAL-DEMO-UNIT`.
- Metadata editing is local only and must not imply server authority or audit finality.

### New verifier markers

```text
DAILY_OPERATIONS_FULL_UI_IMPLEMENTATION=PASS
DOCUMENT_METADATA_EDITING_SURFACE=PASS
LOCAL_UPLOAD_REPRESENTATION_QUEUE=PASS
CLASSIFICATION_NODE_MANAGEMENT=PASS
```

### Boundary remains unchanged

```text
PALWAKF_REMOTE_INTEGRATION=NOT_CONNECTED_BY_DESIGN
STAGING_APPROVAL=NOT_APPROVED
PRODUCTION_APPROVAL=NOT_APPROVED
```


## Archive Delivery Gate Addendum — 2026-07-13

بعد خطأ بوابة `DAILY_OPERATIONS_FULL_UI_IMPLEMENTATION` يجب عدم تسليم دفعات UI تشغيلية جديدة قبل فحص ساكن إضافي لأمرين:

1. توافق أيقونات Flutter Material مع SDK المحلي؛ يحظر استخدام أيقونات غير مدعومة مثل `Icons.add_tree_outlined` دون تحقق.
2. عدم تمرير قيم nullable إلى callbacks التشغيلية عند وجود شرط UI؛ يجب التقاط القيمة في متغير non-null مثل `selectedItem` قبل تمريرها إلى دوال الحفظ.

المؤشرات المطلوبة قبل التسليم التالي:

```text
MATERIAL_ICON_COMPATIBILITY=PASS
NULLABLE_METADATA_SAVE_GUARD=PASS
```

تبقى الحوكمة:

```text
PALWAKF_REMOTE_INTEGRATION=NOT_CONNECTED_BY_DESIGN
STAGING_APPROVAL=NOT_APPROVED
PRODUCTION_APPROVAL=NOT_APPROVED
```

## Archive Documents and Workflow Operationalization — 2026-07-13

The active Evidence Archive baseline now includes session-local operational workflow for daily document work:

- Documents list is no longer a passive list; it includes metrics, filters, and workflow actions.
- Document detail is an operational record view with metadata, representations, review tasks, relationships, and lifecycle actions.
- Review Queue supports start, return for correction, complete, and internal approval actions within the local session.
- Document Lifecycle shows live records and allows local status transitions.
- Search Discovery includes advanced filters: domain, review status, access level, spatial status, and `waqf_asset_id` linkage.
- Import Catalog supports local status advancement across staged, validated, needs mapping, ready, imported, and rejected states.

### New verifier markers

```text
DOCUMENTS_WORKFLOW_OPERATIONALIZATION=PASS
EVIDENCE_WORKFLOW_ACTION_BAR=PASS
DOCUMENT_DETAIL_OPERATIONAL_TABS=PASS
REVIEW_QUEUE_WORKFLOW_ACTIONS=PASS
DOCUMENT_LIFECYCLE_OPERATIONAL_BOARD=PASS
SMART_SEARCH_ADVANCED_FILTERS=PASS
IMPORT_WORKFLOW_STATUS_ADVANCEMENT=PASS
```

### Boundary

All operations are Riverpod session-memory operations only. They are not database writes, not File Center uploads, not GIS writes, not platform authority decisions, and not production approval.

```text
PALWAKF_REMOTE_INTEGRATION=NOT_CONNECTED_BY_DESIGN
STAGING_APPROVAL=NOT_APPROVED
PRODUCTION_APPROVAL=NOT_APPROVED
```


### Archive Daily Operations — Reports/Notifications/Backup/Export V1

اعتماد دفعة `MEGA_BATCH_ARCHIVE_REPORTS_NOTIFICATIONS_BACKUP_AND_EXPORT_OPERATIONALIZATION_V1` كامتداد يومي تشغيلي محلي: التقارير، التنبيهات، طلبات التصدير، ولقطات النسخ كلها session-local ولا تكتب ملفات فعلية ولا تتصل بـFile Center أو Supabase. الحوكمة باقية داخل الإدارة الفرعية فقط، وحالة الإدماج ثابتة: `PALWAKF_REMOTE_INTEGRATION=NOT_CONNECTED_BY_DESIGN`, `STAGING_APPROVAL=NOT_APPROVED`, `PRODUCTION_APPROVAL=NOT_APPROVED`.

## Archive — Smart Indexing / OCR / Deduplication Local Operation Baseline — 2026-07-13

تم اعتماد دفعة `MEGA_BATCH_ARCHIVE_SMART_INDEXING_OCR_DEDUP_AND_SAVED_SEARCHES_V1` كاستمرار لمنهج Daily UX First. الدفعة تضيف سطحًا يوميًا للفهرسة الذكية يشمل طابور OCR/Index محلي، كشف التكرار، البحوث المحفوظة، واقتراحات التصنيف. كل العمليات Session-local فقط ولا تنفذ OCR فعليًا أو LLM أو كتابة على التخزين أو قاعدة البيانات. تبقى الحوكمة داخل صفحة الإدارة الفرعية، وتبقى الحدود: `PALWAKF_REMOTE_INTEGRATION=NOT_CONNECTED_BY_DESIGN`, `STAGING_APPROVAL=NOT_APPROVED`, `PRODUCTION_APPROVAL=NOT_APPROVED`.

## Archive Access / Publication / Retention / Audit Operationalization — 2026-07-13

تم اعتماد توسعة يومية داخل نظام الأرشفة الإلكترونية لإدارة الإتاحة والنشر الداخلي وسياسات الاحتفاظ وسجل التدقيق كطبقة تشغيل محلية فقط. الصفحة الجديدة `الإتاحة والتدقيق` ليست تفويضًا للنشر العام أو الربط الإنتاجي؛ كل العمليات Session-local وتبقى ضمن `PALWAKF_REMOTE_INTEGRATION=NOT_CONNECTED_BY_DESIGN` و`STAGING_APPROVAL=NOT_APPROVED` و`PRODUCTION_APPROVAL=NOT_APPROVED`.

القواعد المضافة:
- طلب الإتاحة لا ينشئ route عام ولا يكتب في منصة PalWakf.
- اعتماد الإتاحة يغير `AccessLevel` محليًا فقط.
- تقييد الإتاحة يضع الوثيقة في مستوى `restricted` محليًا فقط.
- مراجعة الاحتفاظ لا تنفذ حذفًا أو إتلافًا.
- سجل التدقيق append-only داخل ذاكرة الجلسة ويستخدم كتدريب واجهة لا كسجل سيادي.

## Archive UI/UX Productive Pages and Grouped Sidebar Refocus — 2026-07-13

The archive module must be presented as a daily-use electronic archiving system, not as a governance console. The primary navigation is grouped by usage category: daily workspace, archive organization, review/approval, discovery/search, reports/operations, and administration. Governance and platform integration controls remain isolated under the administration group as a subpage only.

Required guards for this refocus:

```text
SIDEBAR_GROUPED_BY_USAGE=PASS
GOVERNANCE_IS_ADMIN_SUBPAGE_ONLY=PASS
DAILY_UX_PRIMARY_NAVIGATION=PASS
DOCUMENT_PRODUCTIVE_PAGES=PASS
ADD_DOCUMENT_FLOW_VISIBLE=PASS
DOCUMENT_DETAIL_TABS_VISIBLE=PASS
NO_GOVERNANCE_FIRST_EXPERIENCE=PASS
```

The module remains local-only until a future controlled staging package is authorized.

## Evidence Archive — UI/UX foundational error gate repair 2026-07-13

The grouped-sidebar UX must keep daily work first and governance under the administration group only. The sidebar shell uses a decorated surface, therefore every `ListTile` and `ExpansionTile` in that shell must have a `Material` boundary. Required markers:

```text
SIDEBAR_LIST_MATERIAL_BOUNDARY=PASS
NAVIGATION_GROUP_EXPANSION_MATERIAL_BOUNDARY=PASS
GOVERNANCE_IS_ADMIN_SUBPAGE_ONLY=PASS
NO_GOVERNANCE_FIRST_EXPERIENCE=PASS
```

Do not accept future UI/UX batches if Flutter runtime emits `ListTile background color or ink splashes may be invisible`.


## 2026-07-14 — UI/UX Foundational Error Gate Repair R2

- Replaced sidebar `ExpansionTile` with custom Material-backed group header to eliminate Flutter web debug ListTile/DecoratedBox assertions.
- Repaired governance isolation test to use explicit admin/governance markers instead of fragile text-position matching.
- Added verifier gates: `CUSTOM_NAVIGATION_GROUP_TILE`, `NO_EXPANSION_TILE_IN_SIDEBAR`, `ROBUST_GOVERNANCE_ADMIN_TEST`.
- No Supabase, database, File Center, GIS, Staging, or Production connection was introduced.

## Archive Productive Document Detail/Add Flow — 2026-07-14

الدفعة `MEGA_BATCH_ARCHIVE_PRODUCTIVE_DOCUMENT_DETAIL_ADD_FLOW_AND_GOVERNED_WORKFLOW_V1` تعتمد التوجيه الجديد: التطوير بالتوازي بين التشغيل الإنتاجي اليومي، تحسين UI/UX، والحوكمة الداعمة. لا يجوز أن تتحول الدفعات القادمة إلى حوكمة فقط. كل تحسين يجب أن يضيف قيمة يومية مرئية للمستخدمين، مع حواجز تحقق وحوكمة داخل الإدارة.

نقطة البناء: `PALWAKF_ARCHIVE_UI_UX_FOUNDATIONAL_ERROR_GATE_REPAIR_R2_20260714_BASELINE`.

الحدود: `PALWAKF_REMOTE_INTEGRATION=NOT_CONNECTED_BY_DESIGN`, `STAGING_APPROVAL=NOT_APPROVED`, `PRODUCTION_APPROVAL=NOT_APPROVED`.

## Evidence Archive — Public Home and Workspace Gate

Adopted UI rule:

```text
الصفحة الرئيسية = بوابة تعريفية للأرشيف والكتالوجات
تسجيل الدخول = دخول تطويري مؤقت
مساحة العمل = كل أدوات الإدخال والرفع والمراجعة والبحث
النشر = ممنوع قبل اعتماد بشري
```

Implementation batch: `MEGA_BATCH_ARCHIVE_PUBLIC_HOME_CATALOG_LANDING_AND_DEV_LOGIN_WORKSPACE_GATE_V1`.

The first screen is a public landing page with hero/header/footer/catalog cards. The operational workspace shell is mounted only after a local development login button click. This is not a real authentication layer and must not be treated as production auth. No public publication path is exposed from the landing page.

## Evidence Archive — Public Home Approved Visual Alignment

Approved UI direction for the public landing page: white header with top navigation and development-login button, archival hero emphasizing the Palestinian Waqf Archive, catalog cards for Ottoman, British/English, Jordanian, and Palestinian archives, advanced technology section for AI/spatial-temporal/translation/safe preservation/search, and institutional footer. The public home is an archive/catalog gateway, not the operational workspace. Development login remains local and credential-free at this stage. Publication remains blocked until human review and approval.


### Evidence Archive — Public Home Exact Approved Screen Rebuild V1

The approved public landing page pattern is now: public home as archive/catalog gateway; development-login button as a temporary local gate into the workspace; workspace as the location for intake/upload/review/search; publication blocked until human approval. The public home visual contract must include a white header, top navigation, PalWakf Archive brand, heritage hero image treatment, catalog cards for Ottoman/British-Jordanian/Palestinian archive layers, technology/AI capability strip, access CTA, and green footer. Sidebar must not appear on the public home.

## Evidence Archive — Layered Catalogs and Open Draft Intake

The Evidence Archive is now governed conceptually as **الأرشيف** rather than merely **الأرشفة**. The workspace must support source/period archive catalogs and document-type tabs. Current development-phase policy:

```text
أدخل كل شيء للتطوير والفهم وبناء الواجهات.
لا تنشر شيئًا قبل المراجعة والاعتماد البشري.
```

Implementation batch: `MEGA_BATCH_ARCHIVE_LAYERED_CATALOGS_OPEN_DRAFT_INTAKE_AND_PAGE_ALIGNMENT_V1`.

Required archive layers include, at minimum, the Ottoman archive, British/English archive, Jordanian archive, and Palestinian archive. Each catalog must expose document-type tabs, e.g. tapu records, land records, waqf deeds, survey maps, registration certificates, tax receipts, settlement files, official decisions, maps, images, translations, OCR/transcription drafts, and research notes.

Development intake is open and draft-only. Governance must not block data entry in the current development stage; it should label missing metadata, source uncertainty, translation/OCR needs, and publication readiness. Publication or public exposure remains blocked until human review and approval.

Required gates:

```text
LAYERED_ARCHIVE_CATALOGS=PASS
CATALOG_DOCUMENT_TYPE_TABS=PASS
OPEN_DRAFT_INTAKE_MODE=PASS
CATALOG_AWARE_INTAKE=PASS
NO_INTAKE_BLOCKING_GOVERNANCE=PASS
PUBLICATION_REQUIRES_HUMAN_APPROVAL=PASS
DRAFT_REPRESENTATIONS_ALLOWED=PASS
CATALOG_SEARCH_ENTRY_POINTS=PASS
```

## Evidence Archive — Catalog-Aware Metadata Templates and Draft Forms V1

The archive now treats each source/period catalog and document-type tab as a driver for intake fields. The current development policy remains: **أدخل كل شيء للتطوير والفهم وبناء الواجهات. لا تنشر شيئًا قبل المراجعة والاعتماد البشري.**

Implemented local-only concepts:

- `ArchiveCatalog` and `CatalogDocumentTypeTab` remain the source-layer and document-type entry points.
- `CatalogMetadataTemplate` defines draft form fields for each document type.
- `MetadataTemplateField` captures the field key, label, hint, recommendation status, and AI-assist note.
- `EvidenceItem` stores structured metadata, missing metadata warnings, template readiness, and AI assistance plan.
- `createCatalogAwareDraftFromTemplate` accepts incomplete metadata as an open draft and keeps publication blocked until human approval.

Initial templates:

- Ottoman Tapu records.
- Ottoman Waqf deeds.
- British / English land records.
- Jordanian registration certificates.
- Palestinian settlement files.

Boundaries:

```text
PALWAKF_REMOTE_INTEGRATION=NOT_CONNECTED_BY_DESIGN
STAGING_APPROVAL=NOT_APPROVED
PRODUCTION_APPROVAL=NOT_APPROVED
```

No Supabase, File Center, GIS, AI service, production auth, or remote write is introduced by this batch.


## MEGA_BATCH_ARCHIVE_OCR_TRANSLATION_TRANSCRIPTION_DRAFT_LAYER_V1 — 2026-07-14

- Added session-local OCR / transcription / translation draft layers linked to archive catalogs and document type tabs.
- Added `TextDraftLayer` and `TextDraftLayerKind` models and local controller actions for creating and internally reviewing draft layers.
- Added workspace page `OcrTranslationTranscriptionScreen` under `OCR والترجمة والتفريغ`.
- Preserved boundaries: no real OCR engine, no real translation engine, no publication from text drafts, and human review remains required.
- Remote/Staging/Production remain not connected / not approved.


## MEGA_BATCH_ARCHIVE_VISUAL_IDENTITY_AND_CATALOG_EXPERIENCE_REDESIGN_V1

تم تنفيذ إعادة تصميم الهوية البصرية وتجربة الكتالوجات للصفحة العامة ومساحة العمل وصفحات الكتالوج وتفاصيل الوثيقة وطبقات OCR/التفريغ/الترجمة. لا يوجد نشر أو ربط خارجي.


## 2026-07-15 — TRUE_VISUAL_ART_DIRECTION_PREMIUM_REBUILD
- Prepared `MEGA_BATCH_ARCHIVE_TRUE_VISUAL_ART_DIRECTION_AND_PREMIUM_UI_REBUILD_V1`.
- Rebuilt public archive landing as a premium national archive gateway with document/place/time/waqf visual composition.
- Rebuilt internal daily home as an archive operations command center.
- Added static guards for premium visual art direction and operational intelligence dashboard.
- Boundaries unchanged: local/session/fixture only; no remote integration, no staging, no production, no publication.


## Evidence Archive — Premium Visual Runtime Cleanup R2 — 2026-07-15

Current visual premium rebuild requires a runtime cleanup after local UAT found a RenderFlex overflow in `_PremiumCatalogCard` and two analyzer warnings in the public landing screen. R2 fixes the catalog card layout and analyzer cleanup while preserving the premium gateway direction.

Accepted boundaries remain:

```text
PALWAKF_REMOTE_INTEGRATION=NOT_CONNECTED_BY_DESIGN
STAGING_APPROVAL=NOT_APPROVED
PRODUCTION_APPROVAL=NOT_APPROVED
```

## Evidence Archive — Catalog Rooms and Document Investigation Premium UI

The archive system now distinguishes public premium gateway design from internal premium archive rooms. Catalog pages must behave like source-period archive rooms, and document details must behave like investigation rooms with visible source, catalog, document type, representation stack, text draft layers, place/waqf context, and human review decision rail. All surfaces remain draft/local-only until human approval.

## Evidence Archive — Catalog Rooms / Document Investigation Premium UI R2 Compile Runtime Repair — 2026-07-15

The first premium catalog rooms package required an R2 repair after local gates exposed a Flutter test import mismatch, an unused internal card class, and a narrow viewport header overflow. R2 repairs these without changing governance boundaries: no remote integration, no database mutation, no staging/production approval, and no publication before human approval.

## Review Workflow and Human Approval Studio V1 — 2026-07-15

The archive now treats review as a human approval studio rather than a simple task queue. Reviewers can compare source representations and OCR/transcription/translation drafts, mark text layers as reviewed internally, return documents for correction, or approve documents internally. Public availability remains blocked until explicit human approval. This is local/session-only and does not create staging, production, Supabase, or remote platform writes.

## Archive review workflow R2 contract repair — 2026-07-15

The Review Workflow / Human Approval Studio remains local-only. R2 repairs legacy test compatibility and explicit text draft no-publication markers. No database, staging, production, or remote integration is approved.


## MEGA_BATCH_ARCHIVE_REVIEW_WORKFLOW_HUMAN_APPROVAL_STUDIO_R3_APPLY_GUARD_AND_LEGACY_TEST_REPAIR_V1
- REVIEW_STUDIO_R3_APPLY_GUARD_AND_LEGACY_TEST_REPAIR: repaired brittle apply guard and retained legacy review workflow/text draft no-publication contract.
- No platform/database/staging/production mutation.
