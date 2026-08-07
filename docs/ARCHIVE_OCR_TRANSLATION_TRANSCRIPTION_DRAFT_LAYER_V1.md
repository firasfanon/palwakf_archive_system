# MEGA_BATCH_ARCHIVE_OCR_TRANSLATION_TRANSCRIPTION_DRAFT_LAYER_V1

## Purpose
Adds an internal text-derivative layer for OCR, transcription, and translation drafts, tied to catalog-aware archive materials.

## Scope
- New `TextDraftLayer` model and `TextDraftLayerKind` enum.
- New local controller methods:
  - `createOcrTranslationTranscriptionDraftLayer`
  - `markTextDraftLayerReviewed`
- New workspace page: `OCR والترجمة والتفريغ`.
- Evidence detail now displays linked text draft layers.
- Draft layers are linked to representations and catalog/document-type metadata.

## Boundaries
- `NO_REAL_OCR_ENGINE`
- `NO_REAL_TRANSLATION_ENGINE`
- `HUMAN_REVIEW_REQUIRED_FOR_TEXT_DRAFTS`
- `NO_PUBLICATION_FROM_TEXT_DRAFTS`
- `PALWAKF_REMOTE_INTEGRATION=NOT_CONNECTED_BY_DESIGN`
- `STAGING_APPROVAL=NOT_APPROVED`
- `PRODUCTION_APPROVAL=NOT_APPROVED`

## Required local gates
```powershell
python toolserify_module_reception_static.py
flutter pub get
dart format lib test
flutter analyze
flutter test
flutter run -d chrome --target lib/main.dart
```
