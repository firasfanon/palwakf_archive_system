# ARCHIVE DOCUMENT READING ASSISTANT INTERACTIVE WORKBENCH V1

Batch: `MEGA_BATCH_ARCHIVE_DOCUMENT_READING_ASSISTANT_INTERACTIVE_WORKBENCH_V1`

Accepted parent baseline: `PALWAKF_ARCHIVE_DOCUMENT_READING_ASSISTANT_NAV_VISIBILITY_REPAIR_R3_ANCHORLESS_20260809_BASELINE`

## Scope

Transforms the Ottoman/English document reading assistant from a static foundation page into an interactive local workbench. The workbench supports local draft-only simulation for:

- selecting a document reading profile,
- marking a source image region,
- drafting OCR/HTR/transcription text manually,
- drafting Arabic translation text manually,
- building a local Ottoman/English/Arabic glossary,
- assigning confidence,
- recording reviewer notes and status.

## Boundaries

- `NO_REAL_OCR_ENGINE_IN_WORKBENCH`
- `NO_REAL_HTR_ENGINE_IN_WORKBENCH`
- `NO_REAL_TRANSLATION_ENGINE_IN_WORKBENCH`
- `NO_FILE_UPLOAD_BACKEND_IN_WORKBENCH`
- `DRAFT_ONLY_INTERACTIVE_READING_OUTPUT`
- `HUMAN_APPROVAL_REQUIRED_FOR_WORKBENCH_TEXT`

No database, no staging, no production, no external model, no file backend.
