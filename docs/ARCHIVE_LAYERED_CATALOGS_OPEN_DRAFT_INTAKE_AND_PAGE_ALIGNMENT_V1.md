# MEGA_BATCH_ARCHIVE_LAYERED_CATALOGS_OPEN_DRAFT_INTAKE_AND_PAGE_ALIGNMENT_V1

## Purpose

Align the current Evidence Archive product with the corrected concept: this is a layered archive, not a generic archiving form. The system must expose archive catalogs by source/period and document-type tabs inside each catalog, while allowing broad development intake as drafts.

## Governing rule

```text
أدخل كل شيء للتطوير والفهم وبناء الواجهات.
لا تنشر شيئًا قبل المراجعة والاعتماد البشري.
```

## Scope

- Add archive catalog models and document-type tab models.
- Seed Ottoman, British/English, Jordanian, and Palestinian catalogs.
- Add document-type tabs for tapu records, land records, waqf deeds, maps, land records, survey maps, registration certificates, tax receipts, settlement files, waqf files, decisions, and modern maps/images.
- Add a catalog workspace page for selecting catalogs, browsing document-type tabs, and entering open drafts.
- Make Add Document catalog-aware while preserving prior workflow/test contracts.
- Allow incomplete records during development as open drafts.
- Add draft representation support and publication-blocked status.
- Add tests and static verification gates.

## Non-scope

- No publication.
- No real authentication.
- No Supabase.
- No File Center.
- No OCR/AI execution.
- No GIS/PostGIS.
- No Staging.
- No Production.

## Acceptance gates

```text
MODULE_RECEPTION_STATIC_VERIFY=PASS
LAYERED_ARCHIVE_CATALOGS=PASS
CATALOG_DOCUMENT_TYPE_TABS=PASS
OPEN_DRAFT_INTAKE_MODE=PASS
CATALOG_AWARE_INTAKE=PASS
NO_INTAKE_BLOCKING_GOVERNANCE=PASS
PUBLICATION_REQUIRES_HUMAN_APPROVAL=PASS
DRAFT_REPRESENTATIONS_ALLOWED=PASS
CATALOG_SEARCH_ENTRY_POINTS=PASS
flutter analyze=PASS
flutter test=PASS
flutter run=PASS
```
