# CHANGELOG — Evidence Archive

## 2026-07-13 — MEGA_BATCH_ARCHIVE_FULL_PRODUCT_PIPELINE_LOCAL_TO_PRODUCTION_READINESS_V1

### Nature of action
**Single full local-product development batch** covering the operator-requested path:

```text
Local Product → Core Archive → Evidence → Review → Spatial/Search → Admin → Staging Readiness → Controlled UAT → Production Readiness
```

### Changed
- Added Local Product Foundation screen as a unified operational landing page.
- Added Core Archive screen for `Fonds → Series → File → Item` hierarchy.
- Added Evidence Registry screen with evidence type, confidence, source chain, rights status, legal sensitivity, and future `waqf_asset_id`/`case_id` linkage fields.
- Added Representations screen for original, OCR, transcription, translation, summary, thumbnail, georeferenced image, and vector-layer concepts.
- Added Search & Discovery screen with local query and filters.
- Added Temporal Explorer screen.
- Added Admin Governance Console with policy cards, local health/fallback controls, feature flag posture, and local audit trace.
- Added Staging Readiness, Controlled UAT, and Production Readiness screens.
- Expanded local fixture models and seed data for archive nodes, registry entries, representations, spatial links, temporal events, administrative policies, and readiness checkpoints.
- Expanded route slot contract declarations for the full product surface.
- Added full-product static verification markers and tests.
- Updated guide, handoff, baseline notes, and error record.

### Explicitly not changed
- No PalWakf platform mutation.
- No Supabase client or credentials.
- No database schema/data write.
- No File Center mutation.
- No GIS/PostGIS mutation.
- No Staging approval.
- No Production approval.
- No direct remote integration.

### Verification status
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
FLUTTER_ANALYZE=REQUIRED_LOCALLY
FLUTTER_TEST=REQUIRED_LOCALLY
BROWSER_UAT=REQUIRED_LOCALLY
```

## 2026-07-04 — MEGA_BATCH_EVIDENCE_ARCHIVE_MODULE_HEALTH_LABEL_COMPILE_GATE_CORRECTION_V1

### Nature of action
**Urgent narrow Dart compile-gate correction.** This action restores extension visibility only; it is not a functional feature, UI redesign, or platform integration change.

### Triggering evidence
Local Flutter compilation stopped at:
```text
lib/src/app.dart:148:50: Error: The getter 'label' isn't defined for the type 'ModuleHealthStatus'.
```

### Root cause
`app.dart` called `integration.health.status.label`. The `label` getter is an extension declared in `platform_integration/contracts.dart`; Dart imports are library-scoped and do not become available through `archive_platform_integration.dart`'s private dependency import.

### Changed
- Added an explicit direct import of `platform_integration/contracts.dart` to `lib/src/app.dart`.
- Added a static verifier guard requiring that direct import whenever the app calls `integration.health.status.label`, and requiring the extension declaration to remain present in `contracts.dart`.
- Updated baseline, handoff, guide, UAT, and error documentation.

### Explicitly not changed
- No health status values, fallback semantics, capability logic, fixture scope, UI behavior, data, storage, authentication, RBAC, Supabase, File Center, GIS, Staging, or Production setting changed.

### Acceptance status
```text
STATIC_COMPILE_GATE_GUARD=PASS
FLUTTER_ANALYZE=REQUIRED_LOCALLY
FLUTTER_TEST=REQUIRED_LOCALLY
BROWSER_UAT=REQUIRED_LOCALLY
STAGING_INTEGRATION_AUTHORIZED=FALSE
PRODUCTION_APPROVAL=NOT_IMPLIED
```

## 2026-07-04 — MEGA_BATCH_EVIDENCE_ARCHIVE_CANONICAL_RUNTIME_ROOT_CLOSURE_V1

### Nature of action
**Urgent local runtime packaging correction**. This is not a new product feature and does not modify PalWakf, authentication, data, storage, File Center, GIS, or Supabase.

### Root cause confirmed by local launch evidence
The delivered archive contained two Flutter projects:
1. `archive_system/` with a default Flutter counter template.
2. `archive_system/workspace/` with the actual Evidence Archive module.

The IDE command launched `archive_system/lib/main.dart`; therefore Chrome displayed **Flutter Demo Home Page**. The Flutter launch itself succeeded, but it did not launch the intended module. Previous browser UAT is invalid for the module until this correction is executed locally.

### Changed
- Promoted the actual module source from `workspace/lib/` to canonical `lib/`.
- Promoted contract tests from `workspace/test/` to canonical `test/`.
- Promoted the integration kit from `workspace/integration/` to canonical `integration/`.
- Replaced the root `pubspec.yaml`, lockfile, and analyzer configuration with the module package configuration containing `flutter_riverpod`.
- Removed the nested `workspace/` Flutter project to prevent IDE ambiguity.
- Replaced all start/verify scripts to operate only from the package root and explicitly target `lib\main.dart`.
- Added canonical-root guards that reject a nested Flutter project or default-template entrypoint.
- Archived the old root default launcher/package artifacts under `backups/pre_canonical_runtime_root_20260704/`.
- Replaced old workspace-dependent repair launcher with a non-mutating canonical-root guard.

### Explicitly not changed
- No PalWakf platform core mutation.
- No `core`, `waqf`, `awqaf_system`, `billing_system`, `cases`, `tasks`, `assistant`, or `public` database mutation.
- No Supabase URL, key, storage object, file link, GIS binding, authentication, RBAC, or production route.
- No Staging or Production authorization.

### Acceptance status
```text
PACKAGE_STRUCTURE_STATIC_VERIFY=PASS
FLUTTER_PUB_GET=NOT_RUN_AFTER_CORRECTION_IN_PACKAGING_ENVIRONMENT
FLUTTER_ANALYZE=NOT_RUN_AFTER_CORRECTION_IN_PACKAGING_ENVIRONMENT
FLUTTER_TEST=NOT_RUN_AFTER_CORRECTION_IN_PACKAGING_ENVIRONMENT
BROWSER_UAT=NOT_RUN_AFTER_CORRECTION
STAGING_INTEGRATION_AUTHORIZED=FALSE
PRODUCTION_APPROVAL=NOT_IMPLIED
```

## 2026-07-04 — MEGA_BATCH_EVIDENCE_ARCHIVE_MODULE_RECEPTION_PREPARATION_V1

Prepared a local platform-integration boundary, capability gate, local fixture unit scope, local feature flags/health/fallback simulation, and the module reception integration kit. This prior batch is retained as source work, but its prior root-level launch posture is superseded by the canonical-runtime-root correction above.

## 2026-07-13 — MEGA_BATCH_ARCHIVE_FULL_PRODUCT_PIPELINE_COMPILE_GATE_CLEANUP_V1

- Fixed compile blockers caused by enum label extensions not being directly imported in Registry and Representations screens.
- Hardened analyzer configuration to exclude historical `backups/**` material from the active Flutter analysis scope.
- Added a cleanup script to move stale `workbench`/`viewer` source and obsolete tests from earlier updates-only overlay states into a sibling quarantine folder.
- Expanded static verifier to catch stale source/test artifacts and enum-label direct-import omissions.
- Governance unchanged: `PALWAKF_REMOTE_INTEGRATION=NOT_CONNECTED_BY_DESIGN`, `STAGING_APPROVAL=NOT_APPROVED`, `PRODUCTION_APPROVAL=NOT_APPROVED`.

## 2026-07-13 — MEGA_BATCH_ARCHIVE_DAILY_USER_EXPERIENCE_AND_GOVERNANCE_SUBPAGE_REFOCUS_V1

- Refocused the archive module from a governance-first surface into a daily user workspace.
- Added first-class user pages for: system home, administrative document classification, document metadata, upload/storage design, document lifecycle, smart search, archiving steps, permission model, security/backup requirements, and technical blueprint.
- Moved Staging, Controlled UAT, Production Readiness, platform integration readiness, and governance detail into the Admin/Governance tabbed subpage rather than exposing them as primary navigation.
- Updated the app shell navigation and mobile bottom bar to prioritize daily actions: Home, Documents, Upload, Search, Review.
- Updated Operations Dashboard language and quick actions to reflect document operations instead of governance status.
- Extended static verifier with `DAILY_USER_EXPERIENCE_SURFACE=PASS` and `GOVERNANCE_SUBPAGE_ONLY=PASS` guards.
- Added a daily user experience contract test.
- No Supabase connection, database mutation, File Center mutation, GIS mutation, platform core patch, Staging approval, or Production approval was introduced.


## MEGA_BATCH_ARCHIVE_REQUIREMENTS_MEMORY_AND_PROJECT_DOCUMENTATION_V1 — 2026-07-13

### Added
- Stored the comprehensive electronic archiving website requirements in `docs/ARCHIVE_ELECTRONIC_SYSTEM_REQUIREMENTS_V1.md`.
- Added `docs/ARCHIVE_REQUIREMENTS_INDEX_V1.md` as a quick index for requirement references.
- Updated `PALWAKF_PLATFORM_COMPREHENSIVE_GUIDE.md` with the new requirements reference and unchanged governance boundaries.
- Added handoff and baseline-control records for requirements documentation.

### Governance
- Daily UX First remains the product direction.
- Governance remains a subpage under Admin/Governance.
- `PALWAKF_REMOTE_INTEGRATION=NOT_CONNECTED_BY_DESIGN`.
- `STAGING_APPROVAL=NOT_APPROVED`.
- `PRODUCTION_APPROVAL=NOT_APPROVED`.

### Mutation Scope
- Documentation-only project file patch.
- No Flutter source behavior change.
- No database, storage, GIS, File Center, or platform mutation.

## 2026-07-13 — MEGA_BATCH_ARCHIVE_ANALYZE_RUN_COMPILE_GATE_FIX_V1

### Fixed
- Fixed `ModuleFallbackScreen` compile failure by directly importing `features/governance/platform_integration_readiness_screen.dart` in `lib/src/app.dart` where the fallback widget is instantiated.
- Fixed `upload_storage_screen.dart` const-list compile errors by removing the const list wrapper around non-const Material button constructors.
- Replaced deprecated `withOpacity(...)` usages in the daily home hero with `withValues(alpha: ...)`.
- Removed an unused dashboard import reported by analyzer.
- Extended the static verifier with guards for fallback-screen direct import, upload-storage const-button lists, and deprecated opacity usage.

### Local evidence from user before correction
- `python tools/verify_module_reception_static.py` = PASS.
- `flutter test` = PASS, 14 tests.
- `flutter analyze` = FAIL with 10 issues.
- `flutter run -d chrome --target lib/main.dart` = FAIL due to `ModuleFallbackScreen` and const button constructor errors.

### Governance
- `PALWAKF_REMOTE_INTEGRATION=NOT_CONNECTED_BY_DESIGN`.
- `STAGING_APPROVAL=NOT_APPROVED`.
- `PRODUCTION_APPROVAL=NOT_APPROVED`.
- No platform, database, storage, File Center, GIS, or production mutation.


## PALWAKF_ARCHIVE_LIST_TILE_MATERIAL_BOUNDARY_RUNTIME_ASSERTION_FIX_V1 — 20260713

- أصلح تحذير/استثناء Flutter debug runtime: `ListTile background color or ink splashes may be invisible` في القائمة الجانبية العريضة.
- السبب: `ListTile` كان داخل `DecoratedBox` ذي خلفية/حدود، ما يجعل تأثيرات ink/selected ترسم على Material أبعد وقد تختفي.
- الحل: تغليف كل `ListTile` في القائمة الجانبية بـ `Material(color: Colors.transparent, child: ListTile(...))` مع marker `LIST_TILE_MATERIAL_BOUNDARY`.
- تم تقوية `tools/verify_module_reception_static.py` لإظهار `LIST_TILE_MATERIAL_BOUNDARY=PASS`.
- لا يوجد ربط Supabase، لا Database Mutation، لا File Center/GIS Mutation، ولا Production Approval.

## 2026-07-13 — MEGA_BATCH_ARCHIVE_DAILY_OPERATIONS_FULL_UI_IMPLEMENTATION_V1

### Added
- Converted daily-use pages from informational requirement surfaces into interactive local operation surfaces.
- Added local classification node management in `DocumentClassificationScreen` with create form for Fonds/Series/File/Item records.
- Added editable document metadata workspace in `DocumentMetadataScreen`, including source, reference, date label, rights, legal sensitivity, access level, spatial status, and future `waqf_asset_id` entry.
- Added a local upload/representation queue in `UploadStorageScreen` that can append `ArchiveRepresentation` records to session state without any remote storage mutation.
- Extended `LocalOperationalController` with session-only operations for status updates, representation addition, and import status updates.
- Added `daily_operations_full_ui_contract_test.dart` for the operational UI markers and representation queue contract.
- Extended static verifier with `DAILY_OPERATIONS_FULL_UI_IMPLEMENTATION=PASS`, `DOCUMENT_METADATA_EDITING_SURFACE=PASS`, `LOCAL_UPLOAD_REPRESENTATION_QUEUE=PASS`, and `CLASSIFICATION_NODE_MANAGEMENT=PASS`.

### Governance
- Governance remains a subpage under Admin/Governance only.
- `PALWAKF_REMOTE_INTEGRATION=NOT_CONNECTED_BY_DESIGN`.
- `STAGING_APPROVAL=NOT_APPROVED`.
- `PRODUCTION_APPROVAL=NOT_APPROVED`.
- No Supabase connection, database mutation, File Center mutation, GIS mutation, platform core patch, Staging approval, or Production approval was introduced.

### Verification in packaging environment
- `python tools/verify_module_reception_static.py` = PASS.
- Flutter analyze/test/run must be executed locally because Flutter is not available in the packaging environment.


## 2026-07-13 — MEGA_BATCH_ARCHIVE_DAILY_OPERATIONS_PRE_DELIVERY_ANALYZE_RUN_FIX_V1

- إصلاح بوابة analyze/run قبل تسليم التطوير الكبير اليومي.
- استبدال `Icons.add_tree_outlined` غير المدعوم في Flutter الحالي بـ `Icons.account_tree_outlined` داخل شاشة تصنيف الوثائق.
- تثبيت تمرير الوثيقة المحددة في شاشة metadata عبر `selectedItem` غير قابل للالتباس بدل تمرير `EvidenceItem?` إلى `_save`.
- تقوية `tools/verify_module_reception_static.py` بمؤشري `MATERIAL_ICON_COMPATIBILITY=PASS` و`NULLABLE_METADATA_SAVE_GUARD=PASS` حتى لا تفلت هذه الأخطاء في التسليمات اللاحقة.
- لا يوجد ربط Supabase أو قاعدة بيانات أو File Center أو GIS أو Staging أو Production.

## 2026-07-13 — MEGA_BATCH_ARCHIVE_DOCUMENTS_AND_WORKFLOW_OPERATIONALIZATION_V1

### Added
- Operationalized the daily documents list with metrics, domain/status/access filters, and a workflow action bar for open, send to review, internal approval, quarantine, and restore actions.
- Expanded document detail into an operational record view: metadata, access, spatial status, representations, review tasks, relationships, and local workflow controls.
- Converted Review Queue into a workflow board with state/domain filters and start/return/complete-and-approve actions.
- Converted Document Lifecycle into a live session-local workflow board over current documents.
- Expanded Search Discovery with advanced filters for domain, review status, access level, spatial status, and waqf asset linkage.
- Expanded Import Catalog with local staged-validation-ready-rejected status advancement controls.
- Extended `LocalOperationalController` with `submitEvidenceForReview`, `addReviewTask`, `completeReviewTaskAndApprove`, and `returnReviewTaskForCorrection`.
- Added `documents_workflow_operationalization_test.dart` covering UI markers, local workflow transitions, import status advancement, and unit-scope denial.
- Extended static verifier with workflow operationalization markers.

### Governance
- All workflow mutations remain session-local/in-memory only.
- No Supabase connection, no database mutation, no File Center mutation, no GIS mutation, no platform core patch, no Staging approval, and no Production approval.
- Governance remains a subpage under Admin/Governance.

### Verification in packaging environment
- `python tools/verify_module_reception_static.py` = PASS.
- Flutter analyze/test/run must be executed locally before accepting the batch.


## 2026-07-13 — MEGA_BATCH_ARCHIVE_REPORTS_NOTIFICATIONS_BACKUP_AND_EXPORT_OPERATIONALIZATION_V1

- تحويل التقارير والتنبيهات والنسخ والتصدير إلى واجهات تشغيل يومية محلية.
- إضافة صفحة `ReportsNotificationsScreen` إلى التنقل اليومي.
- إضافة نماذج `ArchiveReport`, `ArchiveNotification`, `BackupSnapshot`, `ExportRequest`.
- إضافة عمليات محلية في `LocalOperationalController`: تأكيد التنبيهات، إنشاء لقطة نسخ، اختبار استرجاع، وتسجيل طلب تصدير.
- تقوية static verifier بمؤشرات `REPORTS_NOTIFICATIONS_BACKUP_OPERATIONALIZATION`, `LOCAL_REPORTING_DASHBOARD`, `NOTIFICATION_ACKNOWLEDGEMENT_ACTION`, `BACKUP_RESTORE_DRILL_LOCAL`, `EXPORT_REQUEST_QUEUE_LOCAL`.
- لا يوجد اتصال Supabase أو قاعدة بيانات أو File Center أو GIS أو Staging أو Production.

## 2026-07-13 — MEGA_BATCH_ARCHIVE_SMART_INDEXING_OCR_DEDUP_AND_SAVED_SEARCHES_V1

- أضيفت صفحة تشغيل يومية جديدة: `الفهرسة الذكية` ضمن التنقل الرئيسي، مع إبقاء الحوكمة داخل الإدارة فقط.
- أضيفت نماذج جلسة محلية: `SmartIndexJob`, `DuplicateCandidate`, `SavedSearch`, `TaxonomySuggestion`.
- أضيفت عمليات محلية في `LocalOperationalController`: إنشاء/إكمال مهمة فهرسة، حفظ بحث، تأكيد/رفض تكرار، قبول اقتراح تصنيف.
- أضيفت واجهات OCR/Index Queue، كشف التكرار، البحوث المحفوظة، واقتراحات التصنيف دون OCR فعلي أو LLM أو كتابة خارج ذاكرة الجلسة.
- أضيف اختبار `smart_indexing_operationalization_test.dart`.
- تم تقوية `tools/verify_module_reception_static.py` بمؤشرات: `SMART_INDEXING_OPERATIONALIZATION`, `OCR_INDEX_QUEUE_LOCAL`, `DUPLICATE_DETECTION_LOCAL`, `SAVED_SEARCH_LOCAL`, `TAXONOMY_SUGGESTION_REVIEW`.
- لا يوجد ربط Supabase أو File Center أو GIS أو Staging أو Production.

## 2026-07-13 — MEGA_BATCH_ARCHIVE_ACCESS_PUBLICATION_RETENTION_AND_AUDIT_OPERATIONALIZATION_V1

- أضيفت صفحة تشغيل يومية جديدة: `الإتاحة والتدقيق`.
- أضيفت نماذج محلية: `AccessPolicyRule`, `PublicationRequest`, `RetentionRule`, `AuditTrailEntry`.
- أضيفت عمليات محلية في `LocalOperationalController`: `requestPublicationReview`, `approvePublicationRequest`, `restrictPublicationRequest`, `markRetentionReview`, `recordAccessAudit`.
- أضيفت مصفوفة إتاحة وصلاحيات محلية، طابور طلبات نشر/إتاحة، سياسات احتفاظ، وسجل تدقيق داخل ذاكرة الجلسة.
- صُحح تحذير `unnecessary_null_comparison` في صفحة الفهرسة الذكية قبل بناء الدفعة الجديدة.
- لا يوجد اتصال Supabase أو File Center أو GIS أو Production أو Staging.

## 2026-07-13 — MEGA_BATCH_ARCHIVE_UI_UX_PRODUCTIVE_PAGES_AND_GROUPED_SIDEBAR_REFOCUS_V1

- Reworked the primary app shell into a grouped usage-based sidebar.
- Added daily productive groups: daily workspace, archive organization, review/approval, discovery/search, reports/operations, and administration.
- Added `AddDocumentScreen` as a visible local add-document flow.
- Kept governance isolated inside administration as `الحوكمة والتكامل`.
- Added a top quick-search affordance that routes users to search instead of governance.
- Added static verification markers for grouped sidebar and governance isolation.
- Added `ui_ux_grouped_sidebar_refocus_test.dart`.
- No Supabase, database, File Center, GIS, Staging, or Production activation.

## 2026-07-13 — MEGA_BATCH_ARCHIVE_UI_UX_FOUNDATIONAL_ERROR_GATE_REPAIR_V1

- عالجت الدفعة خطأين تأسيسيين ظهرَا بعد تنفيذ `MEGA_BATCH_ARCHIVE_UI_UX_PRODUCTIVE_PAGES_AND_GROUPED_SIDEBAR_REFOCUS_V1`.
- السبب الأول: اختبار عزل الحوكمة كان يعتمد على `indexOf` نصي هش بين `الإدارة` و`الحوكمة والتكامل`، فأصبح الاختبار يتحقق من وجود مدخل `governance` داخل كتلة مجموعة الإدارة نفسها.
- السبب الثاني: `ExpansionTile` يستخدم داخليًا `ListTile`، وكان داخل shell مزخرف بـ`DecoratedBox`; لذلك لم يكفِ تغليف صفوف `_NavigationRow` فقط. تم إضافة `SIDEBAR_LIST_MATERIAL_BOUNDARY` و`NAVIGATION_GROUP_EXPANSION_MATERIAL_BOUNDARY` لتغليف قائمة التنقل والمجموعات بسطح `Material` شفاف.
- تم تقوية `tools/verify_module_reception_static.py` لمنع عودة خطأ `ListTile background color or ink splashes may be invisible` في السايد بار المبوب.
- لا يوجد اتصال Supabase أو File Center أو GIS أو Staging أو Production.


## 2026-07-14 — UI/UX Foundational Error Gate Repair R2

- Replaced sidebar `ExpansionTile` with custom Material-backed group header to eliminate Flutter web debug ListTile/DecoratedBox assertions.
- Repaired governance isolation test to use explicit admin/governance markers instead of fragile text-position matching.
- Added verifier gates: `CUSTOM_NAVIGATION_GROUP_TILE`, `NO_EXPANSION_TILE_IN_SIDEBAR`, `ROBUST_GOVERNANCE_ADMIN_TEST`.
- No Supabase, database, File Center, GIS, Staging, or Production connection was introduced.

## 2026-07-14 — MEGA_BATCH_ARCHIVE_PRODUCTIVE_DOCUMENT_DETAIL_ADD_FLOW_AND_GOVERNED_WORKFLOW_V1

- Added a productive multi-step Add Document flow with validation, classification/access fields, optional local representation creation, optional review task creation, and local audit logging.
- Added `LocalOperationalController.createGovernedDocumentDraft` to perform the session-local governed intake transaction.
- Expanded `EvidenceItem` with daily UX metadata: department label, subject label, document type, keywords, and workflow note.
- Rebuilt Document Detail as tabbed operational UI: overview, metadata, files/representations, review, access/audit, and relations.
- Strengthened static verification with productive add/detail/governed workflow markers.
- No remote integration, no database write, no File Center, no GIS, no Staging, no Production.


## 2026-07-14 — MEGA_BATCH_ARCHIVE_PRODUCTIVE_DOCUMENT_DETAIL_ADD_FLOW_TEST_CONTRACT_REPAIR_V1

- Fixed the productive add-document UI test contract by making the final save action explicitly render `حفظ وثيقة محليًا`.
- Added static verifier guard `ADD_DOCUMENT_LOCAL_SAVE_LABEL=PASS`.
- Scope: local UI/test-contract repair only. No platform/database/remote/staging/production mutation.

## 2026-07-14 — MEGA_BATCH_ARCHIVE_PUBLIC_HOME_CATALOG_LANDING_AND_DEV_LOGIN_WORKSPACE_GATE_V1

- Added a public archive landing page before the internal workspace shell.
- Added header, top navigation labels, hero section, catalog cards, technology/AI capability cards, access CTA, and footer.
- Introduced `PublicArchiveLandingScreen` and `_ArchiveEntryGate`.
- Development login now opens the workspace without username, password, Supabase Auth, or any external auth backend.
- Kept the operational sidebar out of the public home page; it appears only after development login.
- Kept publication blocked before human review and approval.
- Added `public_home_workspace_gate_test.dart` and static verifier gates for public landing, catalog cards, dev login, no auth backend, and no publication from public home.
- No remote integration, no database write, no File Center, no GIS, no Staging, no Production.

## 2026-07-14 — MEGA_BATCH_ARCHIVE_PUBLIC_HOME_CATALOG_LANDING_AND_DEV_LOGIN_WORKSPACE_GATE_V1 — Approved Visual Alignment V1.0.1

- Aligned the public archive landing page with the approved visual direction: white header, RTL top navigation, development login button, archival hero, four catalog cards, advanced technology strip, access CTA, and green footer.
- Preserved the development login gate: no username, no password, no real Auth backend.
- Preserved the workspace boundary: the operational sidebar remains hidden on public home and appears only after development login.
- Added static/test markers `PUBLIC_HOME_APPROVED_VISUAL_DESIGN` and `APPROVED_CATALOG_CARD_GRID`.
- No remote integration, no database write, no File Center, no GIS, no Staging, no Production.


## 2026-07-14 — PUBLIC HOME EXACT APPROVED SCREEN REBUILD V1

- Rebuilt the public archive landing page to match the approved visual reference: white header, RTL navigation, development login CTA, heritage hero treatment, catalog cards, technology strip, access CTA, and green footer.
- Preserved development-login behavior: no username, no password, no Auth backend.
- Preserved the product boundary: public home is catalog preview only; workspace contains operational tools; publication remains blocked until human approval.
- Added static/test markers: `PUBLIC_HOME_APPROVED_REFERENCE_SCREEN`, `APPROVED_HERITAGE_HERO_IMAGE_TREATMENT`, `PUBLIC_HOME_EXACT_CATALOG_CARD_GRID`, `PUBLIC_HOME_TECHNOLOGY_STRIP`.

## 2026-07-14 — MEGA_BATCH_ARCHIVE_LAYERED_CATALOGS_OPEN_DRAFT_INTAKE_AND_PAGE_ALIGNMENT_V1

- Reframed the product from generic archiving screens into a layered archive: source/period catalogs, document-type tabs, catalog-aware draft intake, and publication blocked until human approval.
- Added `ArchiveCatalog` and `CatalogDocumentTypeTab` models, plus catalog/draft metadata fields on `EvidenceItem`.
- Added seeded catalogs for the Ottoman, British/English, Jordanian, and Palestinian archive layers with document-type tabs such as tapu records, land records, waqf deeds, survey maps, registration certificates, tax receipts, settlement files, and waqf files.
- Added `ArchiveCatalogsScreen` as a workspace page for catalog cards, document-type tabs, and open draft intake.
- Added `LocalOperationalController.createOpenDraftArchiveMaterial` to accept incomplete catalog material as development drafts while blocking publication by status.
- Updated the Add Document flow to become catalog-aware while preserving the existing productive document-detail workflow contract.
- Added `layered_catalogs_open_draft_intake_test.dart` and static verifier gates for layered catalogs, document-type tabs, open draft intake, no intake-blocking governance, draft representations, catalog search entry points, and human publication approval.
- No remote integration, no database write, no File Center, no GIS, no Staging, no Production.

## 2026-07-14 — MEGA_BATCH_ARCHIVE_CATALOG_AWARE_METADATA_TEMPLATES_AND_DRAFT_FORMS_V1

- Added catalog-aware metadata template models: `CatalogMetadataTemplate` and `MetadataTemplateField`.
- Extended `EvidenceItem` with structured draft metadata, template readiness labels, missing metadata warnings, and AI assistance planning fields.
- Added seed templates for Ottoman Tapu, Ottoman Waqf Deeds, British Land Records, Jordanian Registration Certificates, and Palestinian Settlement Files.
- Updated catalog and add-document flows so document intake changes by catalog/document-type template while staying in Open Draft Intake mode.
- Added `createCatalogAwareDraftFromTemplate` and kept publication blocked until human approval.
- Updated document detail to display structured template metadata and draft warnings.
- Added test `catalog_aware_metadata_templates_test.dart` and static verifier markers.
- No remote, staging, database, storage, auth, or production mutation.


## MEGA_BATCH_ARCHIVE_OCR_TRANSLATION_TRANSCRIPTION_DRAFT_LAYER_V1 — 2026-07-14

- Added session-local OCR / transcription / translation draft layers linked to archive catalogs and document type tabs.
- Added `TextDraftLayer` and `TextDraftLayerKind` models and local controller actions for creating and internally reviewing draft layers.
- Added workspace page `OcrTranslationTranscriptionScreen` under `OCR والترجمة والتفريغ`.
- Preserved boundaries: no real OCR engine, no real translation engine, no publication from text drafts, and human review remains required.
- Remote/Staging/Production remain not connected / not approved.

## 2026-07-15 — MEGA_BATCH_ARCHIVE_VISUAL_IDENTITY_AND_CATALOG_EXPERIENCE_REDESIGN_V1

- Rebuilt public home, catalog rooms, workspace shell, document investigation header, and text-layer studio with archival visual identity.
- Added visual identity static guards.
- No remote integration, no database mutation, no publication approval.


## 2026-07-15 — TRUE_VISUAL_ART_DIRECTION_PREMIUM_REBUILD
- Prepared `MEGA_BATCH_ARCHIVE_TRUE_VISUAL_ART_DIRECTION_AND_PREMIUM_UI_REBUILD_V1`.
- Rebuilt public archive landing as a premium national archive gateway with document/place/time/waqf visual composition.
- Rebuilt internal daily home as an archive operations command center.
- Added static guards for premium visual art direction and operational intelligence dashboard.
- Boundaries unchanged: local/session/fixture only; no remote integration, no staging, no production, no publication.


## 2026-07-15 — TRUE_VISUAL_ART_DIRECTION_PREMIUM_UI_REBUILD_R2_OVERFLOW_CLEANUP

- Fixed public premium catalog card RenderFlex overflow at desktop widths by increasing card height and bounding catalog era/title/description text.
- Eliminated analyzer warnings for unused archival palette constants by using `_oldGold` and `_warmPaper` in the public visual identity layer.
- Added static gates: `PREMIUM_CATALOG_CARD_OVERFLOW_REPAIR` and `PREMIUM_VISUAL_ANALYZE_CLEANUP`.
- No platform mutation, no database mutation, no remote integration, no staging, no production.

## 2026-07-15 — Catalog Rooms and Document Investigation Premium UI

- Added premium catalog room atmosphere panel.
- Added archive room layer map for document → representation → OCR/transcription/translation → metadata → place/waqf → human review.
- Added premium document type gallery and evidence studio.
- Added document investigation command center.
- Added document viewer/representation/text-layer stack.
- Added human review decision rail and relationship context graph.
- No database, remote integration, staging, or production mutation.

## 2026-07-15 — Catalog Rooms / Document Investigation Premium UI R2 Compile Runtime Repair

- Fixed static premium catalog rooms test import to use Flutter test.
- Removed unused `_DocumentTypeCard` declaration.
- Added responsive premium public header for narrow DevTools split viewports.
- Added verification markers for test import, header overflow, and unused-class cleanup.

## MEGA_BATCH_ARCHIVE_REVIEW_WORKFLOW_AND_HUMAN_APPROVAL_STUDIO_V1 — 2026-07-15

- Rebuilt review queue as a premium human approval studio.
- Added human decision metrics, decision rail, text-layer comparison cards, and local audit panel.
- Added static test and verifier markers for review workflow and publication-blocking gates.
- No database, staging, production, or remote platform mutation.

## 2026-07-15 — Review Workflow Human Approval Studio R2 Contract Repair

- Repaired apply guard.
- Restored `REVIEW_QUEUE_WORKFLOW_ACTIONS` compatibility marker.
- Ensured seed text draft layers expose `NO_PUBLICATION_FROM_TEXT_DRAFTS`.
- Added R2 verifier markers.


## MEGA_BATCH_ARCHIVE_REVIEW_WORKFLOW_HUMAN_APPROVAL_STUDIO_R3_APPLY_GUARD_AND_LEGACY_TEST_REPAIR_V1
- REVIEW_STUDIO_R3_APPLY_GUARD_AND_LEGACY_TEST_REPAIR: repaired brittle apply guard and retained legacy review workflow/text draft no-publication contract.
- No platform/database/staging/production mutation.


## 2026-08-08 — MEGA_BATCH_ARCHIVE_OTTOMAN_ENGLISH_DOCUMENT_READING_AND_TRANSLATION_ASSISTANT_FOUNDATION_V1

- Added internal Ottoman/English document reading and translation assistant foundation.
- Added draft-only reading profiles for Ottoman, English, and mixed documents.
- Added OCR/HTR/transcription/translation conceptual layers, terminology glossary, confidence/status panel, and human review gate.
- No real OCR, HTR, external model, translation engine, database, staging, or production integration.
