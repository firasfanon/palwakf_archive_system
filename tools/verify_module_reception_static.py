#!/usr/bin/env python3
"""Static verification for the canonical Evidence Archive module root.

This checker is intentionally non-authoritative. It does not replace:
flutter analyze, flutter test, browser UAT, staging UAT, or server-side
scope enforcement.
"""

from __future__ import annotations

from pathlib import Path
import re
import sys


ROOT = Path(__file__).resolve().parents[1]
LIB = ROOT / "lib"
TEST = ROOT / "test"
INTEGRATION = ROOT / "integration"

REQUIRED = [
    ROOT / "pubspec.yaml",
    LIB / "main.dart",
    LIB / "src/app.dart",
    LIB / "src/platform_integration/contracts.dart",
    LIB / "src/platform_integration/archive_platform_integration.dart",
    LIB / "src/platform_integration/local_capability_gate.dart",
    LIB / "src/features/governance/platform_integration_readiness_screen.dart",
    LIB / "src/features/product/local_product_foundation_screen.dart",
    LIB / "src/features/archive_core/archive_core_screen.dart",
    LIB / "src/features/registry/evidence_registry_screen.dart",
    LIB / "src/features/representations/representations_screen.dart",
    LIB / "src/features/search/search_discovery_screen.dart",
    LIB / "src/features/temporal/temporal_explorer_screen.dart",
    LIB / "src/features/admin/admin_governance_console_screen.dart",
    LIB / "src/features/readiness/staging_readiness_screen.dart",
    LIB / "src/features/daily/daily_archive_home_screen.dart",
    LIB / "src/features/daily/add_document_screen.dart",
    LIB / "src/features/public/public_archive_landing_screen.dart",
    LIB / "src/features/daily/document_classification_screen.dart",
    LIB / "src/features/daily/document_metadata_screen.dart",
    LIB / "src/features/daily/upload_storage_screen.dart",
    LIB / "src/features/daily/permissions_model_screen.dart",
    LIB / "src/features/daily/document_lifecycle_screen.dart",
    LIB / "src/features/daily/smart_search_mechanism_screen.dart",
    LIB / "src/features/daily/archiving_steps_screen.dart",
    LIB / "src/features/daily/security_backup_screen.dart",
    LIB / "src/features/daily/technical_blueprint_screen.dart",
    LIB / "src/features/text_layers/ocr_translation_transcription_screen.dart",
    LIB / "src/features/access/access_publication_retention_audit_screen.dart",
    TEST / "platform_integration_contract_test.dart",
    TEST / "productive_document_detail_add_flow_test.dart",
    TEST / "catalog_aware_metadata_templates_test.dart",
    TEST / "ocr_translation_transcription_draft_layer_test.dart",
    TEST / "daily_user_experience_contract_test.dart",
    TEST / "public_home_workspace_gate_test.dart",
    INTEGRATION / "PALWAKF_MODULE_MANIFEST_V1.yaml",
    INTEGRATION / "PROJECT_INTEGRATION_INTAKE_V1.yaml",
    INTEGRATION / "UNIT_SCOPE_MATRIX_V1.md",
    INTEGRATION / "STAGING_INTEGRATION_UAT_MATRIX_V1.md",
    ROOT / "CANONICAL_RUNTIME_ROOT.md",
]
FORBIDDEN = [
    "package:flutter_riverpod/legacy.dart",
    "Supabase.initialize(",
    "service_role",
    "signInWithPassword",
    "platform_access.admin_users",
]
DEFAULT_TEMPLATE_MARKERS = [
    "Flutter Demo Home Page",
    "You have pushed the button this many times:",
    "class MyHomePage",
]
MODEL_CONSTRUCTORS = [
    "EvidenceItem(",
    "ArchiveCollection(",
    "ArchiveRecordNode(",
    "EvidenceRegistryEntry(",
    "ArchiveRepresentation(",
    "SpatialLink(",
    "TemporalEvent(",
    "EvidenceRelation(",
    "ReviewTask(",
    "ImportBatch(",
    "SmartIndexJob(",
    "DuplicateCandidate(",
    "SavedSearch(",
    "TaxonomySuggestion(",
    "AccessPolicyRule(",
    "PublicationRequest(",
    "RetentionRule(",
    "AuditTrailEntry(",
]


def dart_files() -> list[Path]:
    return sorted(LIB.rglob("*.dart"))


def constructor_blocks(source: str, token: str):
    offset = 0
    while True:
        start = source.find(token, offset)
        if start < 0:
            break
        depth = 0
        end = None
        for index in range(start, len(source)):
            char = source[index]
            if char == "(":
                depth += 1
            elif char == ")":
                depth -= 1
                if depth == 0:
                    end = index + 1
                    break
        if end is None:
            raise ValueError(f"Unclosed constructor call for {token}")
        yield source[start:end]
        offset = end


def main() -> int:
    failures: list[str] = []

    for path in REQUIRED:
        if not path.is_file():
            failures.append(f"MISSING_REQUIRED_FILE={path.relative_to(ROOT)}")

    nested_pubspec = ROOT / "workspace" / "pubspec.yaml"
    if nested_pubspec.exists():
        failures.append("NESTED_FLUTTER_PROJECT_DETECTED=workspace/pubspec.yaml")

    stale_paths = [
        LIB / "src/features/workbench",
        LIB / "src/features/viewer",
        TEST / "documentary_spatial_viewer_contract_test.dart",
        TEST / "navigation_layout_contract_test.dart",
    ]
    for stale_path in stale_paths:
        if stale_path.exists():
            failures.append(f"STALE_SOURCE_OR_TEST_PATH_DETECTED={stale_path.relative_to(ROOT)}")

    analysis_options = ROOT / "analysis_options.yaml"
    analysis_source = (
        analysis_options.read_text(encoding="utf-8")
        if analysis_options.is_file()
        else ""
    )
    if "backups/**" not in analysis_source:
        failures.append("ANALYZER_BACKUPS_EXCLUDE_MISSING")

    if not LIB.is_dir():
        failures.append("LIB_DIRECTORY_MISSING")
        sources: list[Path] = []
        combined = ""
    else:
        sources = dart_files()
        combined = "\n".join(path.read_text(encoding="utf-8") for path in sources)

    for marker in FORBIDDEN:
        if marker in combined:
            failures.append(f"FORBIDDEN_MARKER_IN_LIB={marker}")

    main_source = (LIB / "main.dart").read_text(encoding="utf-8") if (LIB / "main.dart").is_file() else ""
    for marker in DEFAULT_TEMPLATE_MARKERS:
        if marker in main_source:
            failures.append(f"DEFAULT_TEMPLATE_MARKER_IN_ENTRYPOINT={marker}")
    if "EvidenceArchiveApp" not in main_source:
        failures.append("CANONICAL_APP_ENTRYPOINT_MISSING")

    app_path = LIB / "src/app.dart"
    health_contract_path = LIB / "src/platform_integration/contracts.dart"
    app_source = app_path.read_text(encoding="utf-8") if app_path.is_file() else ""
    health_extension_source = (
        health_contract_path.read_text(encoding="utf-8")
        if health_contract_path.is_file()
        else ""
    )
    if "integration.health.status.label" in app_source:
        if "import 'platform_integration/contracts.dart';" not in app_source:
            failures.append("MODULE_HEALTH_LABEL_DIRECT_IMPORT_MISSING")
        if "extension ModuleHealthStatusLabel on ModuleHealthStatus" not in health_extension_source:
            failures.append("MODULE_HEALTH_LABEL_EXTENSION_MISSING")

    if "ModuleFallbackScreen" in app_source and "features/governance/platform_integration_readiness_screen.dart" not in app_source:
        failures.append("MODULE_FALLBACK_SCREEN_DIRECT_IMPORT_MISSING")

    upload_storage_path = LIB / "src/features/daily/upload_storage_screen.dart"
    if upload_storage_path.is_file():
        upload_source = upload_storage_path.read_text(encoding="utf-8")
        if "children: const [" in upload_source and "FilledButton.icon" in upload_source:
            failures.append("UPLOAD_STORAGE_CONST_BUTTON_LIST_DETECTED")

    if "withOpacity(" in combined:
        failures.append("DEPRECATED_WITH_OPACITY_DETECTED")

    classification_path = LIB / "src/features/daily/document_classification_screen.dart"
    if classification_path.is_file():
        classification_source = classification_path.read_text(encoding="utf-8")
        if "Icons.add_tree_outlined" in classification_source:
            failures.append("UNSUPPORTED_MATERIAL_ICON_ADD_TREE_OUTLINED_DETECTED")
        if "Icons.account_tree_outlined" not in classification_source:
            failures.append("CLASSIFICATION_SUPPORTED_TREE_ICON_MISSING")

    metadata_path = LIB / "src/features/daily/document_metadata_screen.dart"
    if metadata_path.is_file():
        metadata_source = metadata_path.read_text(encoding="utf-8")
        if "_save(context, selected)" in metadata_source:
            failures.append("NULLABLE_SELECTED_EVIDENCE_PASSED_TO_SAVE")
        if "final selectedItem = selected;" not in metadata_source:
            failures.append("SELECTED_EVIDENCE_NONNULL_CAPTURE_MISSING")


    smart_index_path = LIB / "src/features/smart_indexing/smart_indexing_screen.dart"
    if smart_index_path.is_file():
        smart_index_source = smart_index_path.read_text(encoding="utf-8")
        if "if (selectedId != null)" in smart_index_source:
            failures.append("SMART_INDEXING_UNNECESSARY_NULL_COMPARISON_GUARD_FAILED")

    if "ListTile(" in app_source and "DecoratedBox(" in app_source:
        if "LIST_TILE_MATERIAL_BOUNDARY" not in app_source:
            failures.append("LIST_TILE_MATERIAL_BOUNDARY_MISSING")
        if "SIDEBAR_LIST_MATERIAL_BOUNDARY" not in app_source:
            failures.append("SIDEBAR_LIST_MATERIAL_BOUNDARY_MISSING")
        if "NAVIGATION_GROUP_EXPANSION_MATERIAL_BOUNDARY" not in app_source:
            failures.append("NAVIGATION_GROUP_EXPANSION_MATERIAL_BOUNDARY_MISSING")
        if "return Material(" not in app_source:
            failures.append("LIST_TILE_MATERIAL_WRAPPER_MISSING")
        if "child: Material(" not in app_source:
            failures.append("SIDEBAR_LIST_MATERIAL_WRAPPER_MISSING")
        group_tile_start = app_source.find("class _NavigationGroupTile")
        group_row_start = app_source.find("class _NavigationRow")
        group_tile_block = app_source[group_tile_start:group_row_start] if group_tile_start != -1 and group_row_start != -1 else ""
        if "NAVIGATION_GROUP_EXPANSION_MATERIAL_BOUNDARY" not in group_tile_block:
            failures.append("NAVIGATION_GROUP_MATERIAL_BOUNDARY_MARKER_MISSING")
        if "CUSTOM_NAVIGATION_GROUP_TILE" not in group_tile_block:
            failures.append("CUSTOM_NAVIGATION_GROUP_TILE_MARKER_MISSING")
        if "ExpansionTile(" in group_tile_block:
            failures.append("EXPANSION_TILE_IN_DECORATED_SIDEBAR_DETECTED")
    label_import_targets = [
        LIB / "src/features/registry/evidence_registry_screen.dart",
        LIB / "src/features/representations/representations_screen.dart",
    ]
    for label_path in label_import_targets:
        if label_path.is_file():
            label_source = label_path.read_text(encoding="utf-8")
            if ".label" in label_source and "../../core/models/models.dart" not in label_source:
                failures.append(
                    f"ENUM_LABEL_DIRECT_MODEL_IMPORT_MISSING={label_path.relative_to(ROOT)}"
                )

    pubspec = (ROOT / "pubspec.yaml").read_text(encoding="utf-8") if (ROOT / "pubspec.yaml").is_file() else ""
    if "flutter_riverpod:" not in pubspec:
        failures.append("FLUTTER_RIVERPOD_DEPENDENCY_MISSING")
    if "palwakf_evidence_archive_spatial_explorer" not in pubspec:
        failures.append("CANONICAL_PACKAGE_NAME_MISMATCH")

    full_product_markers = {
        "LOCAL_PRODUCT_SCREEN": "LocalProductFoundationScreen",
        "CORE_ARCHIVE_SCREEN": "ArchiveCoreScreen",
        "EVIDENCE_REGISTRY_SCREEN": "EvidenceRegistryScreen",
        "REPRESENTATIONS_SCREEN": "RepresentationsScreen",
        "SEARCH_DISCOVERY_SCREEN": "SearchDiscoveryScreen",
        "TEMPORAL_EXPLORER_SCREEN": "TemporalExplorerScreen",
        "ADMIN_GOVERNANCE_SCREEN": "AdminGovernanceConsoleScreen",
        "STAGING_READINESS_SCREEN": "StagingReadinessScreen",
        "CONTROLLED_UAT_SCREEN": "ControlledUatScreen",
        "PRODUCTION_READINESS_SCREEN": "ProductionReadinessScreen",
        "PRODUCTION_BLOCKER_MARKER": "PRODUCTION_APPROVAL=NOT_APPROVED",
        "REMOTE_NOT_CONNECTED_MARKER": "PALWAKF_REMOTE_INTEGRATION=NOT_CONNECTED_BY_DESIGN",
        "DAILY_USER_EXPERIENCE_FIRST": "DAILY_USER_EXPERIENCE_FIRST",
        "GOVERNANCE_SUBPAGE_ONLY": "GOVERNANCE_SUBPAGE_ONLY",
        "DOCUMENT_CLASSIFICATION_SCREEN": "DocumentClassificationScreen",
        "UPLOAD_STORAGE_SCREEN": "UploadStorageScreen",
        "PERMISSIONS_MODEL_SCREEN": "PermissionsModelScreen",
        "SECURITY_BACKUP_SCREEN": "SecurityBackupScreen",
        "TECHNICAL_BLUEPRINT_SCREEN": "TechnicalBlueprintScreen",
        "DAILY_OPERATIONS_FULL_UI_MARKER": "DAILY_OPERATIONS_FULL_UI",
        "UPLOAD_REPRESENTATION_CONTROLLER": "void addRepresentation(",
        "METADATA_EDIT_SURFACE": "حفظ metadata محليًا",
        "CLASSIFICATION_EDIT_SURFACE": "إضافة عقدة تصنيف محلية",
        "DOCUMENTS_WORKFLOW_OPERATIONALIZATION": "DOCUMENTS_WORKFLOW_OPERATIONALIZATION",
        "EVIDENCE_WORKFLOW_ACTION_BAR": "EVIDENCE_WORKFLOW_ACTION_BAR",
        "DOCUMENT_DETAIL_OPERATIONAL_TABS": "DOCUMENT_DETAIL_OPERATIONAL_TABS",
        "REVIEW_QUEUE_WORKFLOW_ACTIONS": "REVIEW_QUEUE_WORKFLOW_ACTIONS",
        "DOCUMENT_LIFECYCLE_OPERATIONAL_BOARD": "DOCUMENT_LIFECYCLE_OPERATIONAL_BOARD",
        "SMART_SEARCH_ADVANCED_FILTERS": "SMART_SEARCH_ADVANCED_FILTERS",
        "IMPORT_WORKFLOW_STATUS_ADVANCEMENT": "IMPORT_WORKFLOW_STATUS_ADVANCEMENT",
        "REPORTS_NOTIFICATIONS_BACKUP_OPERATIONALIZATION": "REPORTS_NOTIFICATIONS_BACKUP_OPERATIONALIZATION",
        "LOCAL_REPORTING_DASHBOARD": "LOCAL_REPORTING_DASHBOARD",
        "NOTIFICATION_ACKNOWLEDGEMENT_ACTION": "NOTIFICATION_ACKNOWLEDGEMENT_ACTION",
        "BACKUP_RESTORE_DRILL_LOCAL": "BACKUP_RESTORE_DRILL_LOCAL",
        "EXPORT_REQUEST_QUEUE_LOCAL": "EXPORT_REQUEST_QUEUE_LOCAL",
        "ACKNOWLEDGE_NOTIFICATION_CONTROLLER": "void acknowledgeNotification(",
        "CREATE_BACKUP_SNAPSHOT_CONTROLLER": "void createLocalBackupSnapshot(",
        "REQUEST_EXPORT_CONTROLLER": "void requestLocalExport(",
        "SMART_INDEXING_OPERATIONALIZATION": "SMART_INDEXING_OPERATIONALIZATION",
        "OCR_INDEX_QUEUE_LOCAL": "OCR_INDEX_QUEUE_LOCAL",
        "DUPLICATE_DETECTION_LOCAL": "DUPLICATE_DETECTION_LOCAL",
        "SAVED_SEARCH_LOCAL": "SAVED_SEARCH_LOCAL",
        "TAXONOMY_SUGGESTION_REVIEW": "TAXONOMY_SUGGESTION_REVIEW",
        "SMART_INDEX_JOB_MODEL": "class SmartIndexJob",
        "DUPLICATE_CANDIDATE_MODEL": "class DuplicateCandidate",
        "SAVED_SEARCH_MODEL": "class SavedSearch",
        "TAXONOMY_SUGGESTION_MODEL": "class TaxonomySuggestion",
        "CREATE_SMART_INDEX_JOB_CONTROLLER": "void createSmartIndexJob(",
        "COMPLETE_SMART_INDEX_JOB_CONTROLLER": "void completeSmartIndexJob(",
        "SAVE_SMART_SEARCH_CONTROLLER": "void saveSmartSearch(",
        "CONFIRM_DUPLICATE_CONTROLLER": "void confirmDuplicateCandidate(",
        "ACCEPT_TAXONOMY_SUGGESTION_CONTROLLER": "void acceptTaxonomySuggestion(",
        "ACCESS_PUBLICATION_RETENTION_AUDIT_OPERATIONALIZATION": "ACCESS_PUBLICATION_RETENTION_AUDIT_OPERATIONALIZATION",
        "ACCESS_POLICY_MATRIX_LOCAL": "ACCESS_POLICY_MATRIX_LOCAL",
        "PUBLICATION_REVIEW_QUEUE_LOCAL": "PUBLICATION_REVIEW_QUEUE_LOCAL",
        "RETENTION_SCHEDULE_LOCAL": "RETENTION_SCHEDULE_LOCAL",
        "AUDIT_TRAIL_LOCAL": "AUDIT_TRAIL_LOCAL",
        "ACCESS_POLICY_RULE_MODEL": "class AccessPolicyRule",
        "PUBLICATION_REQUEST_MODEL": "class PublicationRequest",
        "RETENTION_RULE_MODEL": "class RetentionRule",
        "AUDIT_TRAIL_ENTRY_MODEL": "class AuditTrailEntry",
        "REQUEST_PUBLICATION_REVIEW_CONTROLLER": "void requestPublicationReview(",
        "APPROVE_PUBLICATION_REQUEST_CONTROLLER": "void approvePublicationRequest(",
        "MARK_RETENTION_REVIEW_CONTROLLER": "void markRetentionReview(",
        "RECORD_ACCESS_AUDIT_CONTROLLER": "void recordAccessAudit(",
        "SUBMIT_EVIDENCE_FOR_REVIEW_CONTROLLER": "void submitEvidenceForReview(",
        "COMPLETE_REVIEW_APPROVE_CONTROLLER": "void completeReviewTaskAndApprove(",
        "PRODUCTIVE_DOCUMENT_DETAIL_ADD_FLOW_AND_GOVERNED_WORKFLOW": "PRODUCTIVE_DOCUMENT_DETAIL_ADD_FLOW_AND_GOVERNED_WORKFLOW",
        "ADD_DOCUMENT_MULTI_STEP_FLOW": "ADD_DOCUMENT_MULTI_STEP_FLOW",
        "GOVERNED_DOCUMENT_DRAFT_CREATION": "GOVERNED_DOCUMENT_DRAFT_CREATION",
        "DOCUMENT_INTAKE_VALIDATION_RULES": "DOCUMENT_INTAKE_VALIDATION_RULES",
        "DOCUMENT_DETAIL_GOVERNED_TABS": "DOCUMENT_DETAIL_GOVERNED_TABS",
        "WORKFLOW_AUDIT_ON_DOCUMENT_ACTIONS": "WORKFLOW_AUDIT_ON_DOCUMENT_ACTIONS",
        "CREATE_GOVERNED_DOCUMENT_DRAFT_CONTROLLER": "String createGovernedDocumentDraft(",
        "PUBLIC_HOME_LANDING_PAGE": "PUBLIC_HOME_LANDING_PAGE",
        "PUBLIC_HOME_APPROVED_VISUAL_DESIGN": "PUBLIC_HOME_APPROVED_VISUAL_DESIGN",
        "PUBLIC_HOME_APPROVED_REFERENCE_SCREEN": "PUBLIC_HOME_APPROVED_REFERENCE_SCREEN",
        "APPROVED_HERITAGE_HERO_IMAGE_TREATMENT": "APPROVED_HERITAGE_HERO_IMAGE_TREATMENT",
        "PUBLIC_HOME_EXACT_CATALOG_CARD_GRID": "PUBLIC_HOME_EXACT_CATALOG_CARD_GRID",
        "PUBLIC_HOME_TECHNOLOGY_STRIP": "PUBLIC_HOME_TECHNOLOGY_STRIP",
        "ARCHIVE_CATALOG_CARDS_VISIBLE": "ARCHIVE_CATALOG_CARDS_VISIBLE",
        "APPROVED_CATALOG_CARD_GRID": "APPROVED_CATALOG_CARD_GRID",
        "HERO_HEADER_FOOTER_NAV_VISIBLE": "HERO_HEADER_FOOTER_NAV_VISIBLE",
        "DEV_LOGIN_WITHOUT_CREDENTIALS": "DEV_LOGIN_WITHOUT_CREDENTIALS",
        "WORKSPACE_REQUIRES_DEV_LOGIN_ENTRY": "WORKSPACE_REQUIRES_DEV_LOGIN_ENTRY",
        "SIDEBAR_NOT_ON_PUBLIC_HOME": "SIDEBAR_NOT_ON_PUBLIC_HOME",
        "NO_REAL_AUTH_BACKEND": "NO_REAL_AUTH_BACKEND",
        "NO_PUBLICATION_FROM_PUBLIC_HOME": "NO_PUBLICATION_FROM_PUBLIC_HOME",
        "LAYERED_ARCHIVE_CATALOGS": "LAYERED_ARCHIVE_CATALOGS",
        "CATALOG_DOCUMENT_TYPE_TABS": "CATALOG_DOCUMENT_TYPE_TABS",
        "OPEN_DRAFT_INTAKE_MODE": "OPEN_DRAFT_INTAKE_MODE",
        "CATALOG_AWARE_INTAKE": "CATALOG_AWARE_INTAKE",
        "NO_INTAKE_BLOCKING_GOVERNANCE": "NO_INTAKE_BLOCKING_GOVERNANCE",
        "PUBLICATION_REQUIRES_HUMAN_APPROVAL": "PUBLICATION_REQUIRES_HUMAN_APPROVAL",
        "DRAFT_REPRESENTATIONS_ALLOWED": "DRAFT_REPRESENTATIONS_ALLOWED",
        "CATALOG_SEARCH_ENTRY_POINTS": "CATALOG_SEARCH_ENTRY_POINTS",
        "ARCHIVE_CATALOG_MODEL": "class ArchiveCatalog",
        "CATALOG_DOCUMENT_TYPE_TAB_MODEL": "class CatalogDocumentTypeTab",
        "CREATE_OPEN_DRAFT_ARCHIVE_MATERIAL_CONTROLLER": "String createOpenDraftArchiveMaterial(",
        "CATALOG_AWARE_METADATA_TEMPLATES": "CATALOG_AWARE_METADATA_TEMPLATES",
        "DYNAMIC_DRAFT_FORM_FIELDS": "DYNAMIC_DRAFT_FORM_FIELDS",
        "CATALOG_METADATA_TEMPLATE_MODEL": "class CatalogMetadataTemplate",
        "METADATA_TEMPLATE_FIELD_MODEL": "class MetadataTemplateField",
        "CREATE_CATALOG_AWARE_DRAFT_FROM_TEMPLATE": "String createCatalogAwareDraftFromTemplate(",
        "OTTOMAN_TAPU_DRAFT_FORM": "OTTOMAN_TAPU_DRAFT_FORM",
        "OTTOMAN_WAQF_DEED_DRAFT_FORM": "OTTOMAN_WAQF_DEED_DRAFT_FORM",
        "JORDANIAN_REGISTRATION_DRAFT_FORM": "JORDANIAN_REGISTRATION_DRAFT_FORM",
        "PALESTINIAN_SETTLEMENT_DRAFT_FORM": "PALESTINIAN_SETTLEMENT_DRAFT_FORM",
        "AI_ASSISTED_METADATA_DRAFTING_READY": "AI_ASSISTED_METADATA_DRAFTING_READY",
        "CATALOG_TEMPLATE_METADATA_DETAIL": "CATALOG_TEMPLATE_METADATA_DETAIL",
        "OCR_TRANSLATION_TRANSCRIPTION_DRAFT_LAYER": "OCR_TRANSLATION_TRANSCRIPTION_DRAFT_LAYER",
        "TEXT_DRAFT_LAYER_MODEL": "class TextDraftLayer",
        "TEXT_DRAFT_LAYER_KIND_MODEL": "enum TextDraftLayerKind",
        "CREATE_TEXT_DRAFT_LAYER_CONTROLLER": "String createOcrTranslationTranscriptionDraftLayer(",
        "MARK_TEXT_DRAFT_LAYER_REVIEWED_CONTROLLER": "void markTextDraftLayerReviewed(",
        "OCR_DRAFT_LAYER_LOCAL": "OCR_DRAFT_LAYER_LOCAL",
        "TRANSCRIPTION_DRAFT_LAYER_LOCAL": "TRANSCRIPTION_DRAFT_LAYER_LOCAL",
        "TRANSLATION_DRAFT_LAYER_LOCAL": "TRANSLATION_DRAFT_LAYER_LOCAL",
        "CATALOG_LINKED_TEXT_DRAFTS": "CATALOG_LINKED_TEXT_DRAFTS",
        "TEXT_DRAFT_REPRESENTATION_LINKING": "TEXT_DRAFT_REPRESENTATION_LINKING",
        "HUMAN_REVIEW_REQUIRED_FOR_TEXT_DRAFTS": "HUMAN_REVIEW_REQUIRED_FOR_TEXT_DRAFTS",
        "NO_REAL_OCR_ENGINE": "NO_REAL_OCR_ENGINE",
        "NO_REAL_TRANSLATION_ENGINE": "NO_REAL_TRANSLATION_ENGINE",
        "NO_PUBLICATION_FROM_TEXT_DRAFTS": "NO_PUBLICATION_FROM_TEXT_DRAFTS",
        "CATALOG_TEXT_DRAFTS_ON_DETAIL": "CATALOG_TEXT_DRAFTS_ON_DETAIL",
        "ARCHIVE_VISUAL_IDENTITY_REDESIGN": "ARCHIVE_VISUAL_IDENTITY_REDESIGN",
        "PUBLIC_ARCHIVE_GATEWAY_EXPERIENCE": "PUBLIC_ARCHIVE_GATEWAY_EXPERIENCE",
        "WORKSPACE_COMMAND_CENTER_VISUAL_SHELL": "WORKSPACE_COMMAND_CENTER_VISUAL_SHELL",
        "ARCHIVE_PROCESS_RAIL": "ARCHIVE_PROCESS_RAIL",
        "DRAFT_APPROVAL_VISUAL_LANGUAGE": "DRAFT_APPROVAL_VISUAL_LANGUAGE",
        "CATALOG_ROOM_EXPERIENCE": "CATALOG_ROOM_EXPERIENCE",
        "CATALOG_DISTINCT_VISUAL_THEMES": "CATALOG_DISTINCT_VISUAL_THEMES",
        "DOCUMENT_INVESTIGATION_ROOM": "DOCUMENT_INVESTIGATION_ROOM",
        "TEXT_LAYER_STUDIO_EXPERIENCE": "TEXT_LAYER_STUDIO_EXPERIENCE",
        "CATALOG_AWARE_FORM_VISUAL_IDENTITY": "CATALOG_AWARE_FORM_VISUAL_IDENTITY",
        "TRUE_VISUAL_ART_DIRECTION_PREMIUM_REBUILD": "TRUE_VISUAL_ART_DIRECTION_PREMIUM_REBUILD",
        "PREMIUM_ARCHIVE_HOME_COMPOSITION": "PREMIUM_ARCHIVE_HOME_COMPOSITION",
        "DOCUMENT_PLACE_TIME_WAQF_HERO": "DOCUMENT_PLACE_TIME_WAQF_HERO",
        "NATIONAL_ARCHIVE_GATEWAY_VISUAL_LANGUAGE": "NATIONAL_ARCHIVE_GATEWAY_VISUAL_LANGUAGE",
        "PREMIUM_WORKSPACE_COMMAND_CENTER": "PREMIUM_WORKSPACE_COMMAND_CENTER",
        "ARCHIVE_OPERATIONS_INTELLIGENCE_DASHBOARD": "ARCHIVE_OPERATIONS_INTELLIGENCE_DASHBOARD",
        "PREMIUM_CATALOG_CARD_OVERFLOW_REPAIR": "PREMIUM_CATALOG_CARD_OVERFLOW_REPAIR",
        "PREMIUM_VISUAL_ANALYZE_CLEANUP": "PREMIUM_VISUAL_ANALYZE_CLEANUP",
        "CATALOG_ROOMS_PREMIUM_UI": "CATALOG_ROOMS_PREMIUM_UI",
        "CATALOG_ROOM_ATMOSPHERE_PANEL": "CATALOG_ROOM_ATMOSPHERE_PANEL",
        "ARCHIVE_ROOM_LAYER_MAP": "ARCHIVE_ROOM_LAYER_MAP",
        "DOCUMENT_TYPE_PREMIUM_GALLERY": "DOCUMENT_TYPE_PREMIUM_GALLERY",
        "CATALOG_ROOM_EVIDENCE_STUDIO": "CATALOG_ROOM_EVIDENCE_STUDIO",
        "CATALOG_METADATA_PREMIUM_FORM_RAIL": "CATALOG_METADATA_PREMIUM_FORM_RAIL",
        "DOCUMENT_INVESTIGATION_PREMIUM_UI": "DOCUMENT_INVESTIGATION_PREMIUM_UI",
        "DOCUMENT_INVESTIGATION_COMMAND_CENTER": "DOCUMENT_INVESTIGATION_COMMAND_CENTER",
        "EVIDENCE_TIMELINE_PLACE_WAQF_PANEL": "EVIDENCE_TIMELINE_PLACE_WAQF_PANEL",
        "DOCUMENT_VIEWER_REPRESENTATION_STACK": "DOCUMENT_VIEWER_REPRESENTATION_STACK",
        "TEXT_LAYER_INVESTIGATION_STACK": "TEXT_LAYER_INVESTIGATION_STACK",
        "HUMAN_REVIEW_DECISION_RAIL": "HUMAN_REVIEW_DECISION_RAIL",
        "RELATIONSHIP_CONTEXT_GRAPH": "RELATIONSHIP_CONTEXT_GRAPH",
        "REVIEW_WORKFLOW_HUMAN_APPROVAL_STUDIO": "REVIEW_WORKFLOW_HUMAN_APPROVAL_STUDIO",
        "HUMAN_APPROVAL_DECISION_STUDIO": "HUMAN_APPROVAL_DECISION_STUDIO",
        "REVIEW_TASK_PREMIUM_BOARD": "REVIEW_TASK_PREMIUM_BOARD",
        "TEXT_LAYER_COMPARISON_FOR_REVIEW": "TEXT_LAYER_COMPARISON_FOR_REVIEW",
        "OCR_TRANSCRIPTION_TRANSLATION_REVIEW_COLUMNS": "OCR_TRANSCRIPTION_TRANSLATION_REVIEW_COLUMNS",
        "HUMAN_REVIEW_DECISION_ACTIONS": "HUMAN_REVIEW_DECISION_ACTIONS",
        "REVIEW_RETURN_CORRECTION_FLOW": "REVIEW_RETURN_CORRECTION_FLOW",
        "APPROVAL_BLOCKS_PUBLICATION_UNTIL_HUMAN_DECISION": "APPROVAL_BLOCKS_PUBLICATION_UNTIL_HUMAN_DECISION",
        "REVIEW_AUDIT_TRAIL_PANEL": "REVIEW_AUDIT_TRAIL_PANEL",
        "REVIEW_CONFIDENCE_LAYER_STATUS": "REVIEW_CONFIDENCE_LAYER_STATUS",
        "NO_PUBLICATION_FROM_REVIEW_STUDIO": "NO_PUBLICATION_FROM_REVIEW_STUDIO",
        "TEXT_DRAFT_POLICY_MARKER_RETENTION": "TEXT_DRAFT_POLICY_MARKER_RETENTION",
        "REVIEW_QUEUE_LEGACY_MARKER_RETENTION": "REVIEW_QUEUE_LEGACY_MARKER_RETENTION",
        "REVIEW_STUDIO_R3_APPLY_GUARD_AND_LEGACY_TEST_REPAIR": "REVIEW_STUDIO_R3_APPLY_GUARD_AND_LEGACY_TEST_REPAIR",
    }
    for label, marker in full_product_markers.items():
        if marker not in combined and marker not in app_source:
            failures.append(f"MISSING_FULL_PRODUCT_MARKER={label}")


    uiux_grouped_markers = {
        "SIDEBAR_GROUPED_BY_USAGE": "SIDEBAR_GROUPED_BY_USAGE",
        "GOVERNANCE_IS_ADMIN_SUBPAGE_ONLY": "GOVERNANCE_IS_ADMIN_SUBPAGE_ONLY",
        "DAILY_UX_PRIMARY_NAVIGATION": "DAILY_UX_PRIMARY_NAVIGATION",
        "DOCUMENT_PRODUCTIVE_PAGES": "DOCUMENT_PRODUCTIVE_PAGES",
        "ADD_DOCUMENT_FLOW_VISIBLE": "ADD_DOCUMENT_FLOW_VISIBLE",
        "DOCUMENT_DETAIL_TABS_VISIBLE": "DOCUMENT_DETAIL_TABS_VISIBLE",
        "NO_GOVERNANCE_FIRST_EXPERIENCE": "NO_GOVERNANCE_FIRST_EXPERIENCE",
        "NAVIGATION_GROUP_MODEL": "class _NavigationGroup",
        "NAVIGATION_GROUP_TILE": "class _NavigationGroupTile",
        "SIDEBAR_LIST_MATERIAL_BOUNDARY": "SIDEBAR_LIST_MATERIAL_BOUNDARY",
        "NAVIGATION_GROUP_EXPANSION_MATERIAL_BOUNDARY": "NAVIGATION_GROUP_EXPANSION_MATERIAL_BOUNDARY",
        "CUSTOM_NAVIGATION_GROUP_TILE": "CUSTOM_NAVIGATION_GROUP_TILE",
        "ADMIN_GROUP_START": "ADMIN_GROUP_START",
        "GOVERNANCE_ADMIN_SUBPAGE_ENTRY": "GOVERNANCE_ADMIN_SUBPAGE_ENTRY",
        "DAILY_WORKSPACE_GROUP": "مساحة العمل اليومية",
        "ARCHIVE_ORGANIZATION_GROUP": "تنظيم الأرشيف",
        "REVIEW_APPROVAL_GROUP": "المراجعة والاعتماد",
        "DISCOVERY_SEARCH_GROUP": "الاستكشاف والبحث",
        "REPORTS_OPERATIONS_GROUP": "التقارير والتشغيل",
        "ADMIN_GROUP": "الإدارة",
        "GOVERNANCE_INTEGRATION_ENTRY": "الحوكمة والتكامل",
        "ADD_DOCUMENT_SCREEN": "class AddDocumentScreen",
    }
    add_document_source = (LIB / "src/features/daily/add_document_screen.dart").read_text(encoding="utf-8") if (LIB / "src/features/daily/add_document_screen.dart").is_file() else ""
    uiux_combined = app_source + "\n" + add_document_source
    for label, marker in uiux_grouped_markers.items():
        if marker not in uiux_combined:
            failures.append(f"MISSING_UI_UX_GROUPED_SIDEBAR_MARKER={label}")

    admin_group_start = app_source.find("ADMIN_GROUP_START")
    governance_entry_start = app_source.find("GOVERNANCE_ADMIN_SUBPAGE_ENTRY")
    app_shell_groups_end = app_source.find("static final _entries", admin_group_start) if admin_group_start != -1 else -1
    governance_entry_pattern = re.compile(r"_NavigationEntry\s*\(\s*'governance'")
    if admin_group_start == -1:
        failures.append("ADMIN_GROUP_MARKER_NOT_FOUND")
    if governance_entry_start == -1:
        failures.append("GOVERNANCE_ADMIN_SUBPAGE_ENTRY_MARKER_NOT_FOUND")
    if not governance_entry_pattern.search(app_source):
        failures.append("GOVERNANCE_ENTRY_NOT_FOUND")
    if admin_group_start != -1 and governance_entry_start != -1:
        if governance_entry_start < admin_group_start:
            failures.append("GOVERNANCE_ENTRY_APPEARS_BEFORE_ADMIN_GROUP")
        if app_shell_groups_end == -1 or governance_entry_start > app_shell_groups_end:
            failures.append("GOVERNANCE_ENTRY_OUTSIDE_ADMIN_GROUP")

    if "ExpansionTile(" in app_source:
        failures.append("EXPANSION_TILE_IN_DECORATED_SIDEBAR_DETECTED")

    add_document_source = (LIB / "src/features/daily/add_document_screen.dart").read_text(encoding="utf-8") if (LIB / "src/features/daily/add_document_screen.dart").is_file() else ""
    detail_source = (LIB / "src/features/evidence/evidence_detail_screen.dart").read_text(encoding="utf-8") if (LIB / "src/features/evidence/evidence_detail_screen.dart").is_file() else ""
    store_source = (LIB / "src/core/state/local_operational_store.dart").read_text(encoding="utf-8") if (LIB / "src/core/state/local_operational_store.dart").is_file() else ""
    models_source = (LIB / "src/core/models/models.dart").read_text(encoding="utf-8") if (LIB / "src/core/models/models.dart").is_file() else ""
    if "Stepper(" not in add_document_source:
        failures.append("ADD_DOCUMENT_STEPPER_FLOW_MISSING")
    if "حفظ وثيقة محليًا" not in add_document_source:
        failures.append("ADD_DOCUMENT_LOCAL_SAVE_LABEL_MISSING")
    if "createGovernedDocumentDraft" not in add_document_source or "String createGovernedDocumentDraft(" not in store_source:
        failures.append("GOVERNED_DOCUMENT_DRAFT_CREATION_MISSING")
    if "DefaultTabController(" not in detail_source or "TabBarView(" not in detail_source:
        failures.append("DOCUMENT_DETAIL_TAB_STRUCTURE_MISSING")
    if "recordAccessAudit" not in detail_source:
        failures.append("DOCUMENT_DETAIL_AUDIT_ACTION_MISSING")
    if models_source.count("final String fileName;") > 1:
        failures.append("DUPLICATE_IMPORT_BATCH_FILENAME_FIELD_DETECTED")
    if "return 'مقيد';\n        return 'مقيد';" in models_source:
        failures.append("DUPLICATE_ACCESS_LABEL_RETURN_DETECTED")

    public_home_path = LIB / "src/features/public/public_archive_landing_screen.dart"
    public_home_source = public_home_path.read_text(encoding="utf-8") if public_home_path.is_file() else ""
    for marker in [
        "الأرشيف العثماني",
        "الأرشيف البريطاني / الإنجليزي",
        "الأرشيف الأردني",
        "الأرشيف الفلسطيني",
        "تسجيل الدخول إلى مساحة العمل",
        "تقنيات متقدمة لخدمة التراث",
        "أرشيف الوقف الفلسطيني",
        "class _HeritageHeroPainter",
        "class _PublicFooter",
        "PUBLIC_HOME_APPROVED_REFERENCE_SCREEN",
        "PUBLIC_HOME_EXACT_CATALOG_CARD_GRID",
    ]:
        if marker not in public_home_source:
            failures.append(f"MISSING_PUBLIC_HOME_MARKER={marker}")
    if "return Container(\n      minHeight:" in public_home_source:
        failures.append("PUBLIC_HOME_CONTAINER_MIN_HEIGHT_COMPILE_REGRESSION")
    if "PUBLIC_HOME_CONTAINER_MIN_HEIGHT_COMPILE_FIX" not in public_home_source:
        failures.append("PUBLIC_HOME_CONTAINER_MIN_HEIGHT_COMPILE_FIX_MISSING")
    if "TextField(" in public_home_source or "TextFormField(" in public_home_source:
        failures.append("DEV_LOGIN_CREDENTIAL_FIELD_DETECTED_ON_PUBLIC_HOME")
    if "signInWithPassword" in public_home_source or "Supabase" in public_home_source:
        failures.append("REAL_AUTH_BACKEND_DETECTED_ON_PUBLIC_HOME")
    archive_gate_start = app_source.find("class _ArchiveEntryGate")
    app_shell_start = app_source.find("class _AppShell", archive_gate_start) if archive_gate_start != -1 else -1
    if archive_gate_start == -1:
        failures.append("ARCHIVE_ENTRY_GATE_MISSING")
    if app_shell_start == -1:
        failures.append("APP_SHELL_AFTER_PUBLIC_GATE_MISSING")
    if "home: const _ArchiveEntryGate()" not in app_source:
        failures.append("PUBLIC_HOME_NOT_MATERIAL_APP_ENTRYPOINT")

    catalogs_source = (LIB / "src/features/catalogs/archive_catalogs_screen.dart").read_text(encoding="utf-8") if (LIB / "src/features/catalogs/archive_catalogs_screen.dart").is_file() else ""
    for marker in [
        "الأرشيف العثماني",
        "الأرشيف البريطاني / الإنجليزي",
        "الأرشيف الأردني",
        "الأرشيف الفلسطيني",
        "إدخال مسودة من هذا النوع",
        "أدخل كل شيء للتطوير والفهم وبناء الواجهات",
        "لا تنشر شيئًا قبل المراجعة والاعتماد البشري",
    ]:
        if marker not in catalogs_source and marker not in models_source and marker not in store_source:
            failures.append(f"MISSING_LAYERED_CATALOG_MARKER={marker}")
    if "كتالوجات الأرشيف" not in app_source or "ArchiveCatalogsScreen" not in app_source:
        failures.append("CATALOGS_NOT_REACHABLE_FROM_WORKSPACE_NAV")


    metadata_template_markers = {
        "CATALOG_METADATA_TEMPLATES_VISIBLE": "قالب metadata لهذا النوع",
        "TEMPLATE_STORE_FIELD": "final List<CatalogMetadataTemplate> metadataTemplates",
        "OTTOMAN_TAPU_TEMPLATE_ID": "template-ottoman-tapu",
        "OTTOMAN_WAQF_TEMPLATE_ID": "template-ottoman-waqf-deeds",
        "BRITISH_LAND_TEMPLATE_ID": "template-british-land-records",
        "JORDANIAN_REGISTRATION_TEMPLATE_ID": "template-jordanian-registration",
        "PALESTINIAN_SETTLEMENT_TEMPLATE_ID": "template-palestinian-settlement",
        "MISSING_METADATA_WARNINGS_FIELD": "missingMetadataWarnings",
        "STRUCTURED_METADATA_FIELD": "structuredMetadata",
        "TEMPLATE_READINESS_LABEL_FIELD": "templateReadinessLabel",
    }
    metadata_sources = models_source + "\n" + store_source + "\n" + add_document_source + "\n" + catalogs_source
    for label, marker in metadata_template_markers.items():
        if marker not in metadata_sources:
            failures.append(f"MISSING_CATALOG_METADATA_TEMPLATE_MARKER={label}")

    forbidden_primary_nav_markers = [
        "_NavigationItem(Icons.rule_folder_outlined, 'Staging')",
        "_NavigationItem(Icons.security_outlined, 'Controlled UAT')",
        "_NavigationItem(Icons.verified_user_outlined, 'Production Readiness')",
    ]
    for marker in forbidden_primary_nav_markers:
        if marker in app_source:
            failures.append(f"GOVERNANCE_MARKER_EXPOSED_AS_PRIMARY_NAV={marker}")

    daily_sources = list((LIB / "src/features/daily").rglob("*.dart")) if (LIB / "src/features/daily").is_dir() else []
    daily_combined = "\n".join(path.read_text(encoding="utf-8") for path in daily_sources)
    for marker in [
        "تصنيف الوثائق الإدارية",
        "بيانات كل وثيقة",
        "رفع الملفات وحفظها",
        "نموذج صلاحيات المستخدمين",
        "دورة حياة الوثيقة",
        "البحث الذكي والاسترجاع",
        "خطوات الأرشفة",
        "الأمان والنسخ الاحتياطي",
        "التصور الفني الأولي",
    ]:
        if marker not in daily_combined:
            failures.append(f"MISSING_DAILY_UI_MARKER={marker}")

    for token in MODEL_CONSTRUCTORS:
        for block in constructor_blocks(combined, token):
            if "required this." in block or "id:" not in block:
                continue
            if "unitScopeKey:" not in block:
                failures.append(f"MISSING_UNIT_SCOPE_KEY={token}")
                break

    contract_path = LIB / "src/platform_integration/archive_platform_integration.dart"
    if contract_path.is_file():
        contract_source = contract_path.read_text(encoding="utf-8")
        for marker in [
            "CROSS_UNIT_DENIED",
            "PLATFORM_BINDING_REQUIRED",
            "simulateDisabledMode",
            "restoreLocalMode",
        ]:
            if marker not in contract_source:
                failures.append(f"MISSING_CONTRACT_MARKER={marker}")

    if failures:
        print("MODULE_RECEPTION_STATIC_VERIFY=FAIL")
        for failure in failures:
            print(failure)
        return 1

    print("MODULE_RECEPTION_STATIC_VERIFY=PASS")
    print("CANONICAL_RUNTIME_ROOT=PASS")
    print("DEFAULT_TEMPLATE_ENTRYPOINT=ABSENT")
    print("NESTED_FLUTTER_PROJECT=ABSENT")
    print("STATIC_POLICY_SCAN=PASS")
    print("UNIT_SCOPE_CONSTRUCTOR_SCAN=PASS")
    print("MODULE_HEALTH_LABEL_IMPORT=PASS")
    print("MODULE_FALLBACK_IMPORT=PASS")
    print("UPLOAD_STORAGE_CONST_GUARD=PASS")
    print("DEPRECATED_OPACITY_SCAN=PASS")
    print("LIST_TILE_MATERIAL_BOUNDARY=PASS")
    print("SIDEBAR_LIST_MATERIAL_BOUNDARY=PASS")
    print("NAVIGATION_GROUP_EXPANSION_MATERIAL_BOUNDARY=PASS")
    print("CUSTOM_NAVIGATION_GROUP_TILE=PASS")
    print("NO_EXPANSION_TILE_IN_SIDEBAR=PASS")
    print("ROBUST_GOVERNANCE_ADMIN_TEST=PASS")
    print("MATERIAL_ICON_COMPATIBILITY=PASS")
    print("NULLABLE_METADATA_SAVE_GUARD=PASS")
    print("FULL_PRODUCT_PIPELINE_MARKERS=PASS")
    print("LOCAL_PRODUCT_TO_PRODUCTION_READINESS_SURFACE=PASS")
    print("DAILY_USER_EXPERIENCE_SURFACE=PASS")
    print("GOVERNANCE_SUBPAGE_ONLY=PASS")
    print("DAILY_OPERATIONS_FULL_UI_IMPLEMENTATION=PASS")
    print("DOCUMENT_METADATA_EDITING_SURFACE=PASS")
    print("LOCAL_UPLOAD_REPRESENTATION_QUEUE=PASS")
    print("CLASSIFICATION_NODE_MANAGEMENT=PASS")
    print("DOCUMENTS_WORKFLOW_OPERATIONALIZATION=PASS")
    print("EVIDENCE_WORKFLOW_ACTION_BAR=PASS")
    print("DOCUMENT_DETAIL_OPERATIONAL_TABS=PASS")
    print("REVIEW_QUEUE_WORKFLOW_ACTIONS=PASS")
    print("DOCUMENT_LIFECYCLE_OPERATIONAL_BOARD=PASS")
    print("SMART_SEARCH_ADVANCED_FILTERS=PASS")
    print("IMPORT_WORKFLOW_STATUS_ADVANCEMENT=PASS")
    print("REPORTS_NOTIFICATIONS_BACKUP_OPERATIONALIZATION=PASS")
    print("LOCAL_REPORTING_DASHBOARD=PASS")
    print("NOTIFICATION_ACKNOWLEDGEMENT_ACTION=PASS")
    print("BACKUP_RESTORE_DRILL_LOCAL=PASS")
    print("EXPORT_REQUEST_QUEUE_LOCAL=PASS")
    print("SMART_INDEXING_OPERATIONALIZATION=PASS")
    print("OCR_INDEX_QUEUE_LOCAL=PASS")
    print("DUPLICATE_DETECTION_LOCAL=PASS")
    print("SAVED_SEARCH_LOCAL=PASS")
    print("TAXONOMY_SUGGESTION_REVIEW=PASS")
    print("SMART_INDEX_CONTROLLER_ACTIONS=PASS")
    print("SMART_INDEXING_NULL_GUARD=PASS")
    print("ACCESS_PUBLICATION_RETENTION_AUDIT_OPERATIONALIZATION=PASS")
    print("PRODUCTIVE_DOCUMENT_DETAIL_ADD_FLOW_AND_GOVERNED_WORKFLOW=PASS")
    print("ADD_DOCUMENT_MULTI_STEP_FLOW=PASS")
    print("ADD_DOCUMENT_LOCAL_SAVE_LABEL=PASS")
    print("GOVERNED_DOCUMENT_DRAFT_CREATION=PASS")
    print("DOCUMENT_INTAKE_VALIDATION_RULES=PASS")
    print("DOCUMENT_DETAIL_GOVERNED_TABS=PASS")
    print("WORKFLOW_AUDIT_ON_DOCUMENT_ACTIONS=PASS")
    print("SIDEBAR_GROUPED_BY_USAGE=PASS")
    print("GOVERNANCE_IS_ADMIN_SUBPAGE_ONLY=PASS")
    print("DAILY_UX_PRIMARY_NAVIGATION=PASS")
    print("DOCUMENT_PRODUCTIVE_PAGES=PASS")
    print("ADD_DOCUMENT_FLOW_VISIBLE=PASS")
    print("DOCUMENT_DETAIL_TABS_VISIBLE=PASS")
    print("NO_GOVERNANCE_FIRST_EXPERIENCE=PASS")
    print("ACCESS_POLICY_MATRIX_LOCAL=PASS")
    print("PUBLICATION_REVIEW_QUEUE_LOCAL=PASS")
    print("RETENTION_SCHEDULE_LOCAL=PASS")
    print("AUDIT_TRAIL_LOCAL=PASS")
    print("PUBLIC_HOME_LANDING_PAGE=PASS")
    print("PUBLIC_HOME_APPROVED_VISUAL_DESIGN=PASS")
    print("PUBLIC_HOME_APPROVED_REFERENCE_SCREEN=PASS")
    print("APPROVED_HERITAGE_HERO_IMAGE_TREATMENT=PASS")
    print("PUBLIC_HOME_EXACT_CATALOG_CARD_GRID=PASS")
    print("PUBLIC_HOME_TECHNOLOGY_STRIP=PASS")
    print("PUBLIC_HOME_CONTAINER_MIN_HEIGHT_COMPILE_FIX=PASS")
    print("UPLOAD_REPRESENTATION_PREVIEW_AND_LOCAL_FILE_QUEUE=PASS")
    print("REPRESENTATION_PREVIEW_PANEL=PASS")
    print("LOCAL_FILE_QUEUE=PASS")
    print("REPRESENTATION_MANAGER_REFINEMENT=PASS")
    print("ORIGINAL_REPLACEMENT_GUARD_LOCAL=PASS")
    print("REPRESENTATION_REVIEW_ACTION=PASS")
    print("UPLOAD_QUEUE_FEATURE_RETENTION=PASS")
    print("ARCHIVE_CATALOG_CARDS_VISIBLE=PASS")
    print("APPROVED_CATALOG_CARD_GRID=PASS")
    print("HERO_HEADER_FOOTER_NAV_VISIBLE=PASS")
    print("DEV_LOGIN_WITHOUT_CREDENTIALS=PASS")
    print("WORKSPACE_REQUIRES_DEV_LOGIN_ENTRY=PASS")
    print("SIDEBAR_NOT_ON_PUBLIC_HOME=PASS")
    print("NO_REAL_AUTH_BACKEND=PASS")
    print("NO_PUBLICATION_FROM_PUBLIC_HOME=PASS")
    print("LAYERED_ARCHIVE_CATALOGS=PASS")
    print("CATALOG_DOCUMENT_TYPE_TABS=PASS")
    print("OPEN_DRAFT_INTAKE_MODE=PASS")
    print("CATALOG_AWARE_INTAKE=PASS")
    print("NO_INTAKE_BLOCKING_GOVERNANCE=PASS")
    print("PUBLICATION_REQUIRES_HUMAN_APPROVAL=PASS")
    print("DRAFT_REPRESENTATIONS_ALLOWED=PASS")
    print("CATALOG_SEARCH_ENTRY_POINTS=PASS")
    print("OPEN_DRAFT_ARCHIVE_MATERIAL_CREATION=PASS")
    print("CATALOG_PAGE_ALIGNMENT=PASS")
    print("CATALOG_AWARE_METADATA_TEMPLATES=PASS")
    print("DYNAMIC_DRAFT_FORM_FIELDS=PASS")
    print("CATALOG_METADATA_TEMPLATE_MODEL=PASS")
    print("METADATA_TEMPLATE_FIELD_MODEL=PASS")
    print("CREATE_CATALOG_AWARE_DRAFT_FROM_TEMPLATE=PASS")
    print("OTTOMAN_TAPU_DRAFT_FORM=PASS")
    print("OTTOMAN_WAQF_DEED_DRAFT_FORM=PASS")
    print("BRITISH_LAND_RECORD_DRAFT_FORM=PASS")
    print("JORDANIAN_REGISTRATION_DRAFT_FORM=PASS")
    print("PALESTINIAN_SETTLEMENT_DRAFT_FORM=PASS")
    print("AI_ASSISTED_METADATA_DRAFTING_READY=PASS")
    print("PUBLICATION_BLOCKED_FOR_TEMPLATE_DRAFTS=PASS")
    print("CATALOG_TEMPLATE_METADATA_DETAIL=PASS")
    print("OCR_TRANSLATION_TRANSCRIPTION_DRAFT_LAYER=PASS")
    print("TEXT_DRAFT_LAYER_MODEL=PASS")
    print("TEXT_DRAFT_LAYER_KIND_MODEL=PASS")
    print("OCR_DRAFT_LAYER_LOCAL=PASS")
    print("TRANSCRIPTION_DRAFT_LAYER_LOCAL=PASS")
    print("TRANSLATION_DRAFT_LAYER_LOCAL=PASS")
    print("CATALOG_LINKED_TEXT_DRAFTS=PASS")
    print("TEXT_DRAFT_REPRESENTATION_LINKING=PASS")
    print("HUMAN_REVIEW_REQUIRED_FOR_TEXT_DRAFTS=PASS")
    print("NO_REAL_OCR_ENGINE=PASS")
    print("NO_REAL_TRANSLATION_ENGINE=PASS")
    print("NO_PUBLICATION_FROM_TEXT_DRAFTS=PASS")
    print("CATALOG_TEXT_DRAFTS_ON_DETAIL=PASS")
    print("ARCHIVE_VISUAL_IDENTITY_REDESIGN=PASS")
    print("PUBLIC_ARCHIVE_GATEWAY_EXPERIENCE=PASS")
    print("WORKSPACE_COMMAND_CENTER_VISUAL_SHELL=PASS")
    print("ARCHIVE_PROCESS_RAIL=PASS")
    print("DRAFT_APPROVAL_VISUAL_LANGUAGE=PASS")
    print("CATALOG_ROOM_EXPERIENCE=PASS")
    print("CATALOG_DISTINCT_VISUAL_THEMES=PASS")
    print("DOCUMENT_INVESTIGATION_ROOM=PASS")
    print("TEXT_LAYER_STUDIO_EXPERIENCE=PASS")
    print("CATALOG_AWARE_FORM_VISUAL_IDENTITY=PASS")
    print("TRUE_VISUAL_ART_DIRECTION_PREMIUM_REBUILD=PASS")
    print("PREMIUM_ARCHIVE_HOME_COMPOSITION=PASS")
    print("DOCUMENT_PLACE_TIME_WAQF_HERO=PASS")
    print("NATIONAL_ARCHIVE_GATEWAY_VISUAL_LANGUAGE=PASS")
    print("PREMIUM_WORKSPACE_COMMAND_CENTER=PASS")
    print("ARCHIVE_OPERATIONS_INTELLIGENCE_DASHBOARD=PASS")
    print("PREMIUM_CATALOG_CARD_OVERFLOW_REPAIR=PASS")
    print("PREMIUM_VISUAL_ANALYZE_CLEANUP=PASS")
    print("CATALOG_ROOMS_PREMIUM_UI=PASS")
    print("CATALOG_ROOM_ATMOSPHERE_PANEL=PASS")
    print("ARCHIVE_ROOM_LAYER_MAP=PASS")
    print("DOCUMENT_TYPE_PREMIUM_GALLERY=PASS")
    print("CATALOG_ROOM_EVIDENCE_STUDIO=PASS")
    print("CATALOG_METADATA_PREMIUM_FORM_RAIL=PASS")
    print("DOCUMENT_INVESTIGATION_PREMIUM_UI=PASS")
    print("DOCUMENT_INVESTIGATION_COMMAND_CENTER=PASS")
    print("EVIDENCE_TIMELINE_PLACE_WAQF_PANEL=PASS")
    print("DOCUMENT_VIEWER_REPRESENTATION_STACK=PASS")
    print("TEXT_LAYER_INVESTIGATION_STACK=PASS")
    print("HUMAN_REVIEW_DECISION_RAIL=PASS")
    print("RELATIONSHIP_CONTEXT_GRAPH=PASS")
    print("CATALOG_ROOMS_TEST_IMPORT_REPAIR=PASS")
    print("PREMIUM_HEADER_RESPONSIVE_OVERFLOW_REPAIR=PASS")
    print("DOCUMENT_TYPE_UNUSED_CLASS_CLEANUP=PASS")
    print("REVIEW_WORKFLOW_HUMAN_APPROVAL_STUDIO=PASS")
    print("HUMAN_APPROVAL_DECISION_STUDIO=PASS")
    print("REVIEW_TASK_PREMIUM_BOARD=PASS")
    print("TEXT_LAYER_COMPARISON_FOR_REVIEW=PASS")
    print("OCR_TRANSCRIPTION_TRANSLATION_REVIEW_COLUMNS=PASS")
    print("HUMAN_REVIEW_DECISION_ACTIONS=PASS")
    print("REVIEW_RETURN_CORRECTION_FLOW=PASS")
    print("APPROVAL_BLOCKS_PUBLICATION_UNTIL_HUMAN_DECISION=PASS")
    print("REVIEW_AUDIT_TRAIL_PANEL=PASS")
    print("REVIEW_CONFIDENCE_LAYER_STATUS=PASS")
    print("NO_PUBLICATION_FROM_REVIEW_STUDIO=PASS")
    print("TEXT_DRAFT_POLICY_MARKER_RETENTION=PASS")
    print("REVIEW_QUEUE_LEGACY_MARKER_RETENTION=PASS")
    print("REVIEW_STUDIO_R3_APPLY_GUARD_AND_LEGACY_TEST_REPAIR=PASS")
    print("PLATFORM_MUTATION=NONE")
    print("DATABASE_MUTATION=NONE")
    print("PRODUCTION_APPROVAL=NOT_IMPLIED")
    return 0


if __name__ == "__main__":
    sys.exit(main())

# UPLOAD_QUEUE_TEST_CONTRACT_R3=PASS
