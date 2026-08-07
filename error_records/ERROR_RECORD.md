# Error Record — Evidence Archive

## ERR-ARCHIVE-20260704-03
```text
CATEGORY=DART_EXTENSION_VISIBILITY_COMPILE_GATE
SEVERITY=HIGH
STATUS=CORRECTION_CANDIDATE_STATICLY_VERIFIED_PENDING_LOCAL_FLUTTER_RECHECK
FIRST_SEEN=2026-07-04
EVIDENCE=lib/src/app.dart:148:50 getter label isn't defined for ModuleHealthStatus
LAST_SOURCE_BASELINE=ARCHIVE_CANONICAL_RUNTIME_ROOT_CORRECTION_CANDIDATE_20260704
CURRENT_CORRECTION_CANDIDATE=ARCHIVE_MODULE_HEALTH_LABEL_COMPILE_GATE_CORRECTION_CANDIDATE_20260704
```

### السبب
`ModuleHealthStatusLabel` هو extension معرف في `lib/src/platform_integration/contracts.dart`. الواجهة `lib/src/app.dart` كانت تستورد `archive_platform_integration.dart` فقط ثم تستعمل:

```dart
integration.health.status.label
```

استيراد `contracts.dart` داخل adapter ليس export إلى `app.dart`. لذلك لم ير Dart الامتداد عند تحليل مكتبة الواجهة.

### الملفات المتأثرة
- `lib/src/app.dart`
- `lib/src/platform_integration/contracts.dart` (تعريف صحيح لم يتغير)
- `tools/verify_module_reception_static.py`

### ما فشل
- `flutter run -d chrome --target lib/main.dart` توقف في مرحلة التجميع.
- لم تصل الواجهة إلى UAT من التطبيق الحقيقي بسبب هذا الحاجز.

### الحل المنفذ
- إضافة import مباشر: `import 'platform_integration/contracts.dart';` في `app.dart`.
- إضافة static guard يرفض غياب import المباشر عندما يكون استدعاء `.status.label` موجودًا.

### ما لم يكن السبب
- ليس خللًا في Chrome أو Flutter SDK أو dependency resolution.
- ليس فقدانًا لـ`ModuleHealthStatusLabel` من `contracts.dart`.
- ليس خللًا في Riverpod أو health state أو Feature Flag أو RBAC.
- ليس اتصال Supabase أو قاعدة بيانات أو تخزين أو File Center أو GIS.

### شرط الإغلاق
```text
python tools\verify_module_reception_static.py = PASS
flutter analyze = PASS
flutter test = PASS
flutter run -d chrome --target lib/main.dart = starts without this error
Browser identity/UAT = Evidence Archive Arabic shell visible
```

---

## ERR-ARCHIVE-20260704-02
```text
CATEGORY=RUNTIME_PACKAGING_AND_ENTRYPOINT_AMBIGUITY
SEVERITY=HIGH
STATUS=SOURCE_CORRECTION_RETAINED_RUNTIME_RECHECK_DEFERRED_UNTIL_ERR_03_CLOSED
FIRST_SEEN=2026-07-04
EVIDENCE=Chrome showed Flutter Demo Home Page while IDE ran root lib\main.dart
LAST_SOURCE_BASELINE=ARCHIVE_MODULE_RECEPTION_PREPARED_BASELINE_20260704
CURRENT_CORRECTION_CANDIDATE=ARCHIVE_MODULE_HEALTH_LABEL_COMPILE_GATE_CORRECTION_CANDIDATE_20260704
```

### السبب
الحزمة السابقة تضمنت مشروعَي Flutter:
- الجذر `archive_system/` يحتفظ بالقالب الافتراضي الذي يحتوي `Flutter Demo Home Page`.
- التطبيق المقصود موجود تحت `archive_system/workspace/`.

تشغيل IDE الافتراضي لـ`lib\main.dart` من الجذر يطلق قالب العداد وليس تطبيق أرشيف الأدلة.

### الملفات المتأثرة
- `lib/main.dart` في الجذر السابق.
- `pubspec.yaml` و`pubspec.lock` و`test/widget_test.dart` في الجذر السابق.
- مسار التشغيل في IDE.
- ملفات التشغيل والتحقق التي كانت تفترض `workspace/`.

### ما ثبت
- Flutter وChrome والـdebug service اشتغلت بنجاح.
- لا توجد رسالة compile error أو dependency resolution failure.
- ظهور واجهة العداد الافتراضية يثبت أن الخطأ في entrypoint/package root، لا في شكل أو بيانات التطبيق.

### ما لم يحدث
- لا اتصال Supabase أو PalWakf.
- لا SQL أو قاعدة بيانات أو تخزين أو ملف أو GIS.
- لا تعديل على `waqf_assets` أو `core` أو `waqf` أو `public`.
- لا دليل UAT صالح لتطبيق الأرشيف نفسه من هذا التشغيل.

### الحل المنفذ في مرشح التصحيح
- دمج مصدر التطبيق الحقيقي في جذر package واحد.
- حذف nested Flutter workspace.
- استبدال entrypoint الجذري بتشغيل `EvidenceArchiveApp`.
- إضافة Guard يمنع قالب Flutter الافتراضي أو `workspace/pubspec.yaml`.
- تحديث scripts وdocs إلى الجذر المعتمد.

### المطلوب لإغلاق السجل
من الحزمة المصححة:
```text
python tools\verify_module_reception_static.py
flutter pub get
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
flutter run -d chrome --target lib/main.dart
```

ثم إرفاق لقطة واحدة تظهر واجهة عربية للأرشيف وسجل PASS مختصر. بعد ذلك فقط تغلق الحالة إلى `LOCAL_RUNTIME_ACCEPTED`.

---

## ERR-ARCHIVE-20260704-01
```text
CATEGORY=ENVIRONMENT_VERIFICATION_LIMIT
SEVERITY=MEDIUM
STATUS=SUPERSEDED_BY_LOCAL_EXECUTION_EVIDENCE
FIRST_SEEN=2026-07-04
```

بيئة إنشاء الحزمة لم تشغّل Flutter/Dart. هذا لا يثبت فشل المصدر، لكنه لم يعد السبب الرئيسي؛ السبب الحاسم الذي ظهر لاحقًا هو تغليف جذر التشغيل المزدوج في ERR-ARCHIVE-20260704-02.

---

## ERR-ARCHIVE-20260713-01 — Full product surface without remote activation

```text
BATCH=MEGA_BATCH_ARCHIVE_FULL_PRODUCT_PIPELINE_LOCAL_TO_PRODUCTION_READINESS_V1
TYPE=GOVERNANCE_GUARD
STATUS=DOCUMENTED
```

### Context
The operator requested implementing the full path in one batch:
`Local Product → Core Archive → Evidence → Review → Spatial/Search → Admin → Staging Readiness → Controlled UAT → Production Readiness`.

### Risk
A literal interpretation could accidentally imply direct remote integration, Staging activation, database writes, File Center mutation, GIS mutation, or Production readiness approval.

### Resolution
The batch implemented the complete local product and readiness surfaces while preserving:
```text
PALWAKF_REMOTE_INTEGRATION=NOT_CONNECTED_BY_DESIGN
STAGING_APPROVAL=NOT_APPROVED
PRODUCTION_APPROVAL=NOT_APPROVED
```

### Files affected
- `lib/src/app.dart`
- `lib/src/core/models/models.dart`
- `lib/src/core/state/local_operational_store.dart`
- `lib/src/features/product/local_product_foundation_screen.dart`
- `lib/src/features/archive_core/archive_core_screen.dart`
- `lib/src/features/registry/evidence_registry_screen.dart`
- `lib/src/features/representations/representations_screen.dart`
- `lib/src/features/search/search_discovery_screen.dart`
- `lib/src/features/temporal/temporal_explorer_screen.dart`
- `lib/src/features/admin/admin_governance_console_screen.dart`
- `lib/src/features/readiness/staging_readiness_screen.dart`
- `tools/verify_module_reception_static.py`

### Stable baseline before this record
`PALWAKF_EVIDENCE_ARCHIVE_MODULE_HEALTH_LABEL_COMPILE_GATE_CORRECTION`

### New candidate baseline
`MEGA_BATCH_ARCHIVE_FULL_PRODUCT_PIPELINE_LOCAL_TO_PRODUCTION_READINESS_V1`

## ERR-ARCHIVE-20260713-01 — Full Product Pipeline compile-gate drift

**Batch:** `MEGA_BATCH_ARCHIVE_FULL_PRODUCT_PIPELINE_COMPILE_GATE_CLEANUP_V1`

**Observed failure:**

- Static verifier passed, but `flutter analyze`, `flutter test`, and `flutter run` failed locally.
- Analyzer also scanned historical backup material under `backups/pre_canonical_runtime_root_20260704`.
- Current compile errors included missing `.label` extension visibility for `EvidenceType`, `EvidenceReviewStatus`, and `RepresentationType`.
- Local tree also contained stale `workbench`/`viewer` source and obsolete tests from older overlay states, which are not part of the clean full product pipeline candidate.

**Root cause:**

1. Dart extensions are not available through indirect imports; screens using enum `.label` must directly import the file defining the extension.
2. Historical backup Dart files were still visible to analyzer because `analysis_options.yaml` did not exclude `backups/**`.
3. Updates-only overlays cannot remove old source files unless an explicit cleanup step moves or deletes stale paths.

**Files corrected:**

- `analysis_options.yaml`
- `lib/src/features/registry/evidence_registry_screen.dart`
- `lib/src/features/representations/representations_screen.dart`
- `tools/verify_module_reception_static.py`
- `APPLY_COMPILE_GATE_CLEANUP.ps1`

**Resolution:**

- Add direct `models.dart` imports where enum label extensions are used.
- Exclude backup trees from analyzer scope.
- Add static guards for stale source/test paths.
- Provide cleanup script to move stale overlay artifacts outside the project root.

**Last stable baseline before correction:**

- `PALWAKF_ARCHIVE_FULL_PRODUCT_PIPELINE_20260713`

**Status:**

- Static verification of the corrected package: PASS.
- Local Flutter gates remain to be executed on the user's Windows/Flutter environment.

## ERR-ARCHIVE-20260713-04 — Governance-first UI did not represent daily user workflows

- **Batch:** MEGA_BATCH_ARCHIVE_DAILY_USER_EXPERIENCE_AND_GOVERNANCE_SUBPAGE_REFOCUS_V1
- **Symptom:** The project state and navigation emphasized governance/readiness pages and did not sufficiently expose day-to-day user interfaces for document classification, metadata, upload, lifecycle, smart search, permissions, security/backup, and technical system planning.
- **Root cause:** The previous full pipeline batch compressed product readiness and governance checkpoints into top-level navigation. It proved boundaries but did not privilege daily user journeys.
- **Affected files:** `lib/src/app.dart`, `lib/src/features/dashboard/operations_dashboard_screen.dart`, `lib/src/features/evidence/evidence_explorer_screen.dart`, `lib/src/features/admin/admin_governance_console_screen.dart`, new files under `lib/src/features/daily/`, `tools/verify_module_reception_static.py`, and `test/daily_user_experience_contract_test.dart`.
- **Fix:** Added dedicated daily user pages; changed app shell to daily UX first; moved governance, platform integration, Staging, Controlled UAT, and Production Readiness to Admin subpages; extended static verifier and tests.
- **Boundary:** No remote integration, no DB/storage/GIS mutation, no platform core patch, no Production approval.
- **Last stable baseline before fix:** PALWAKF_ARCHIVE_FULL_PRODUCT_PIPELINE_COMPILE_GATE_CLEANUP_BASELINE_20260713.


## ERR-ARCHIVE-20260713-REQDOC

```text
TYPE=NO_RUNTIME_ERROR_DOCUMENTATION_PATCH
BATCH=MEGA_BATCH_ARCHIVE_REQUIREMENTS_MEMORY_AND_PROJECT_DOCUMENTATION_V1
STATUS=NO_ERROR
ROOT_CAUSE=USER_REQUESTED_REQUIREMENTS_PERSISTENCE
RESOLUTION=REQUIREMENTS_STORED_IN_MEMORY_AND_PROJECT_FILES
LAST_STABLE_BASELINE=PALWAKF_ARCHIVE_DAILY_USER_EXPERIENCE_REFOCUS_20260713
```

No source/runtime error was introduced. This record exists only to preserve the documentation patch context.

## ERR-ARCHIVE-20260713-05 — Daily UX compile/analyze cleanup after requirements documentation

```text
BATCH=MEGA_BATCH_ARCHIVE_ANALYZE_RUN_COMPILE_GATE_FIX_V1
TYPE=NARROW_FLUTTER_ANALYZE_AND_RUN_COMPILE_GATE_FIX
STATUS=STATIC_VERIFIED_PENDING_LOCAL_FLUTTER_ANALYZE_RUN_CONFIRMATION
```

### Observed failure

The user's local Windows Flutter gates after the requirements documentation update showed:

- `MODULE_RECEPTION_STATIC_VERIFY=PASS`.
- `flutter test=PASS` with 14 passing tests.
- `flutter analyze=FAIL` due to:
  - `ModuleFallbackScreen` not visible as a class in `lib/src/app.dart`.
  - Non-const `FilledButton.icon` / `OutlinedButton.icon` constructors inside a const list literal in `upload_storage_screen.dart`.
  - Deprecated `withOpacity(...)` calls in `daily_archive_home_screen.dart`.
  - Unused dashboard import.
- `flutter run` failed on the same fallback and const-button compile blockers.

### Root cause

1. `ModuleFallbackScreen` was defined in the governance readiness screen but was not directly imported by `app.dart` after daily-navigation refocus.
2. Material button `.icon` constructors are not const in this SDK context, but the surrounding list was marked `const`.
3. The current Flutter SDK reports `withOpacity` as deprecated in favor of `withValues(alpha: ...)`.
4. A prior import remained after dashboard refactoring.

### Corrected files

- `lib/src/app.dart`
- `lib/src/features/daily/upload_storage_screen.dart`
- `lib/src/features/daily/daily_archive_home_screen.dart`
- `lib/src/features/dashboard/operations_dashboard_screen.dart`
- `tools/verify_module_reception_static.py`
- `CHANGELOG.md`
- `PALWAKF_PLATFORM_COMPREHENSIVE_GUIDE.md`
- `PROJECT_SESSIONS_INDEX.md`
- `handoff/NEXT_SESSION_PROMPT.md`

### Resolution

- Added direct fallback-screen import.
- Removed the const list literal around disabled upload-action buttons.
- Replaced deprecated opacity calls.
- Removed unused dashboard import.
- Added regression guards in the static verifier.

### Last stable baseline before this correction

`PALWAKF_ARCHIVE_REQUIREMENTS_MEMORY_AND_PROJECT_DOCUMENTATION_BASELINE_20260713`

### Boundary

No remote integration, no Supabase/database mutation, no File Center mutation, no GIS mutation, no platform core patch, no Staging approval, no Production approval.


## ERR-ARCHIVE-20260713-04 — ListTile Material boundary runtime assertion

**Status:** FIXED_STATIC_VERIFIED_PENDING_LOCAL_FLUTTER_RUN_RECHECK

**Observed local evidence:** `flutter run -d chrome --target lib/main.dart` started successfully and rendered the daily-user archive UI, then repeatedly emitted Flutter framework assertions: `ListTile background color or ink splashes may be invisible`.

**Root cause:** The wide side navigation wrapped `ListView`/`ListTile` items in a `DecoratedBox` with a background color and border. In Flutter debug mode, `ListTile` paints selected background and ink effects on the nearest `Material` ancestor, and a decorated intermediate box can hide those effects.

**Files:**
- `lib/src/app.dart`
- `tools/verify_module_reception_static.py`

**Fix:** Add a direct `Material(color: Colors.transparent, child: ListTile(...))` boundary for every side-navigation `ListTile`; add static verifier marker `LIST_TILE_MATERIAL_BOUNDARY=PASS`.

**Stable baseline before this fix:** `PALWAKF_ARCHIVE_ANALYZE_RUN_COMPILE_GATE_FIX_V1` with `flutter analyze=PASS` and `flutter test=PASS`, but runtime assertion pending.

**Governance unchanged:** `PALWAKF_REMOTE_INTEGRATION=NOT_CONNECTED_BY_DESIGN`, `STAGING_APPROVAL=NOT_APPROVED`, `PRODUCTION_APPROVAL=NOT_APPROVED`.

## ERR-ARCHIVE-20260713-06 — Daily pages were informational rather than operational

### Symptom
The archive UI showed daily navigation labels and requirements content, but key pages still behaved mainly as static explanatory surfaces.

### Cause
The previous refocus batch prioritized surface placement and navigation but did not fully implement local interactive forms for classification, metadata editing, and upload/representation drafting.

### Files changed
- `lib/src/features/daily/document_classification_screen.dart`
- `lib/src/features/daily/document_metadata_screen.dart`
- `lib/src/features/daily/upload_storage_screen.dart`
- `lib/src/core/state/local_operational_store.dart`
- `tools/verify_module_reception_static.py`
- `test/daily_operations_full_ui_contract_test.dart`

### Resolution
Added session-only operational UI and controller operations while preserving the no-remote-integration boundary.

### Last stable baseline before patch
`PALWAKF_ARCHIVE_LIST_TILE_MATERIAL_BOUNDARY_FIX_20260713_BASELINE`


## ERR-ARCHIVE-20260713-DAILY-OPS-ANALYZE-RUN-01

**Batch:** `MEGA_BATCH_ARCHIVE_DAILY_OPERATIONS_PRE_DELIVERY_ANALYZE_RUN_FIX_V1`

**الأثر:** فشل `flutter analyze` و`flutter run` بعد نجاح static verifier و`flutter test` في دفعة Daily Operations.

**الأخطاء:**

```text
undefined_getter: Icons.add_tree_outlined
argument_type_not_assignable: EvidenceItem? -> EvidenceItem
```

**السبب:**

- الاعتماد على أيقونة Material غير موجودة في SDK المحلي.
- شرط `onPressed: selected == null ? null : ...` لا يمنح Dart ترقية نوع آمنة عند التقاط متغير nullable في closure.

**الحل:**

- استبدال الأيقونة بـ `Icons.account_tree_outlined`.
- إنشاء `final selectedItem = selected;` وتمرير `selectedItem` فقط بعد فحصه.
- إضافة حواجز static verifier تمنع عودة الخطأين.

**آخر baseline مستقر قبل الخطأ:** `PALWAKF_ARCHIVE_LIST_TILE_MATERIAL_BOUNDARY_FIX_20260713_BASELINE`.

**baseline بعد التصحيح:** `PALWAKF_ARCHIVE_DAILY_OPERATIONS_PRE_DELIVERY_ANALYZE_RUN_FIX_BASELINE_20260713`.

**حدود الحوكمة:** لا Remote / لا Staging / لا Production.

## ERR-ARCHIVE-20260713-DOC-WORKFLOW-PREDELIVERY-01

**Batch:** `MEGA_BATCH_ARCHIVE_DOCUMENTS_AND_WORKFLOW_OPERATIONALIZATION_V1`

**Type:** Preventive record, not a runtime failure.

**Risk addressed:** The prior Daily Operations batch exposed the need to audit UI operational patches for compile-sensitive Flutter APIs and nullable captures before delivery.

**Preventive controls added:**

- Static verifier markers for document workflow surfaces.
- Local controller workflow methods covered by tests.
- Import workflow status advancement covered by tests.
- Unit-scope denial test for workflow review task creation.

**Files watched:**

- `lib/src/features/evidence/evidence_explorer_screen.dart`
- `lib/src/features/evidence/evidence_detail_screen.dart`
- `lib/src/features/review/review_queue_screen.dart`
- `lib/src/features/daily/document_lifecycle_screen.dart`
- `lib/src/features/search/search_discovery_screen.dart`
- `lib/src/features/imports/import_catalog_screen.dart`
- `lib/src/core/state/local_operational_store.dart`
- `tools/verify_module_reception_static.py`

**Last stable baseline before patch:** `PALWAKF_ARCHIVE_DAILY_OPERATIONS_PRE_DELIVERY_ANALYZE_RUN_FIX_BASELINE_20260713`.

**Governance boundary:** No remote integration, no Staging approval, no Production approval.


## ERR-ARCHIVE-20260713-REPORTS-01

- النوع: Pre-delivery prevention.
- السبب: توسيع واجهات التشغيل اليومي قد يضيف مؤشرات غير ممسوكة في static verifier.
- الحل: أضيفت مؤشرات تحقق صريحة للتقارير والتنبيهات والنسخ والتصدير قبل تسليم الدفعة.
- آخر baseline مستقر: PALWAKF_ARCHIVE_DAILY_OPERATIONS_PRE_DELIVERY_ANALYZE_RUN_FIX_BASELINE_20260713.

## ERR-ARCHIVE-20260713-09 — Smart Indexing pre-delivery boundary note

- **السياق:** استمرار الدفعات الكبيرة بعد قبول بوابات Daily UX والوثائق والـWorkflow.
- **المخاطر:** قد يلتبس على المستخدم أن الفهرسة الذكية تعني OCR/AI فعلي أو تخزين نتائج.
- **القرار:** تم وسم الشاشة والعمليات صراحة بأنها `SMART_INDEXING_OPERATIONALIZATION` محلية فقط، مع `OCR_INDEX_QUEUE_LOCAL`, `DUPLICATE_DETECTION_LOCAL`, `SAVED_SEARCH_LOCAL`, `TAXONOMY_SUGGESTION_REVIEW`.
- **الحدود:** لا LLM، لا OCR فعلي، لا vector DB، لا Supabase، لا File Center، لا GIS، لا Staging/Production.
- **آخر baseline مستقر سابق:** `PALWAKF_ARCHIVE_REPORTS_NOTIFICATIONS_BACKUP_EXPORT_20260713_BASELINE`.

### ERR-ARCHIVE-20260713-06 — Smart Indexing nullable guard warning

- **السبب:** `smart_indexing_screen.dart` احتوى فحصًا زائدًا `if (selectedId != null)` بعد فرع يضمن أن القيمة ليست null، فظهر تحذير `unnecessary_null_comparison` في `flutter analyze`.
- **ما فشل:** `flutter analyze` أعاد issue واحدًا رغم نجاح الاختبارات والتشغيل.
- **الحل:** تبسيط onPressed إلى استدعاء مباشر بعد فحص `selected == null`، وإضافة Guard ساكن `SMART_INDEXING_NULL_GUARD=PASS`.
- **آخر baseline مستقر:** `PALWAKF_ARCHIVE_ACCESS_PUBLICATION_RETENTION_AUDIT_20260713` بعد التحقق المحلي المطلوب.

## ERR-ARCHIVE-20260713-UIUX-GOVERNANCE-FIRST-RISK

- Batch: `MEGA_BATCH_ARCHIVE_UI_UX_PRODUCTIVE_PAGES_AND_GROUPED_SIDEBAR_REFOCUS_V1`.
- Risk: previous navigation could become long and governance-heavy, reducing daily usability.
- Cause: accumulated feature pages without information architecture grouped by real user tasks.
- Fix: grouped side navigation by use category and isolated governance under administration.
- Guard: `NO_GOVERNANCE_FIRST_EXPERIENCE=PASS`, `GOVERNANCE_IS_ADMIN_SUBPAGE_ONLY=PASS`.
- Stable parent: `PALWAKF_ARCHIVE_ACCESS_PUBLICATION_RETENTION_AUDIT_20260713_BASELINE`.

## ERR-ARCHIVE-20260713-UIUX-GROUPED-SIDEBAR-RUNTIME-ASSERTION-02

**Batch:** `MEGA_BATCH_ARCHIVE_UI_UX_FOUNDATIONAL_ERROR_GATE_REPAIR_V1`

**What failed:**

- `flutter test` failed in `ui_ux_grouped_sidebar_refocus_test.dart` at `governance remains an administration subpage only`.
- `flutter run` produced repeated Flutter framework assertions: `ListTile background color or ink splashes may be invisible`.

**Root cause:**

- Test logic used a fragile `indexOf` comparison instead of verifying the `governance` entry inside the administration navigation group.
- `ExpansionTile` internally paints a `ListTile`; the previous repair wrapped only child navigation rows, not the `ExpansionTile` header itself. Because the wide sidebar is inside a `DecoratedBox`, the ExpansionTile's internal ListTile needed its own Material boundary.

**Files repaired:**

- `lib/src/app.dart`
- `test/ui_ux_grouped_sidebar_refocus_test.dart`
- `tools/verify_module_reception_static.py`

**Solution:**

- Added `SIDEBAR_LIST_MATERIAL_BOUNDARY` and `NAVIGATION_GROUP_EXPANSION_MATERIAL_BOUNDARY`.
- Wrapped the grouped sidebar list and each `ExpansionTile` in transparent `Material` inside the decorated shell.
- Rewrote the governance-is-admin-subpage test to inspect the navigation structure rather than first textual occurrence.
- Extended static verifier to catch missing sidebar Material boundaries and governance-entry placement.

**Last stable baseline before repair:** `PALWAKF_ARCHIVE_UI_UX_PRODUCTIVE_PAGES_GROUPED_SIDEBAR_REFOCUS_20260713_BASELINE`.

**Governance boundary:** Remote integration not connected by design; Staging not approved; Production not approved.


## ERR-ARCHIVE-20260714-UIUX-GROUPED-SIDEBAR-R2

**سبب الخطأ:** بقيت `ExpansionTile` داخل shell مزخرف بـ`DecoratedBox`، و`ExpansionTile` يبني `ListTile` داخليًا ضمن DecoratedBox، فتكرر assertion في Flutter Web Debug. كما كان اختبار عزل الحوكمة هشًا ويعتمد على موضع نصي.

**الملفات:** `lib/src/app.dart`, `test/ui_ux_grouped_sidebar_refocus_test.dart`, `tools/verify_module_reception_static.py`.

**الحل:** استبدال `ExpansionTile` بمكوّن custom stateful group header يستخدم `Material + ListTile` مباشرة، وإضافة markers صريحة لاختبار الإدارة/الحوكمة.

**الحالة الحاكمة:** PALWAKF_REMOTE_INTEGRATION=NOT_CONNECTED_BY_DESIGN; STAGING_APPROVAL=NOT_APPROVED; PRODUCTION_APPROVAL=NOT_APPROVED.

## ERR-ARCHIVE-20260714-UIUX-PREVENT-DRIFT

- السبب: بعد قبول R2 تم تثبيت قاعدة عدم العودة إلى تطوير حوكمة فقط. الخطر المتكرر هو إضافة صفحات حوكمة أو مؤشرات جاهزية دون قيمة يومية للمستخدم.
- الملفات: app shell, add document, evidence detail, local operational store, static verifier.
- الحل: كل دفعة قادمة يجب أن تحتوي مسار تشغيل إنتاجي ملموس، UI/UX واضح، وحواجز حوكمة داعمة.
- آخر baseline مستقر: `PALWAKF_ARCHIVE_UI_UX_FOUNDATIONAL_ERROR_GATE_REPAIR_R2_20260714_BASELINE`.


## MEGA_BATCH_ARCHIVE_PRODUCTIVE_DOCUMENT_DETAIL_ADD_FLOW_TEST_CONTRACT_REPAIR_V1

### Error

`flutter test` failed in `test/ui_ux_grouped_sidebar_refocus_test.dart` at `productive document surfaces and add document flow are visible` because `AddDocumentScreen` did not contain the exact expected user-facing label `حفظ وثيقة محليًا`.

### Root Cause

The implementation used a semantically similar label `حفظ الوثيقة`, while the UI/UX guard was written against the clearer operational label required by the product contract.

### Fix

Changed the final Stepper action label to `حفظ وثيقة محليًا` and added static verifier coverage.

### Boundaries

No database, remote, staging, production, or platform mutation.

## 2026-07-14 — Public Home / Workspace Gate

- Batch: `MEGA_BATCH_ARCHIVE_PUBLIC_HOME_CATALOG_LANDING_AND_DEV_LOGIN_WORKSPACE_GATE_V1`
- Error addressed: product root opened directly into internal workspace; user requirement changed to public archive landing page first.
- Decision: first screen is public home with hero/catalog cards/header/footer; workspace is entered by temporary development login button.
- Auth boundary: no username, no password, no Supabase Auth, no real auth backend.
- Publication boundary: public home exposes no publication path; publication remains blocked before human review and approval.
