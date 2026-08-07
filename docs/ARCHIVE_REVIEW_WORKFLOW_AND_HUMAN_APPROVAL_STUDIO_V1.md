# MEGA_BATCH_ARCHIVE_REVIEW_WORKFLOW_AND_HUMAN_APPROVAL_STUDIO_V1

## Purpose

Build a premium human review and approval studio for the PalWakf Evidence Archive. The review page now operates as a decision workspace for documents, representations, OCR, transcription, translation, audit, and publication blocking.

## Scope

- Rebuild `ReviewQueueScreen` from a basic queue into a human approval studio.
- Add decision metrics for open tasks, text layers pending review, internally ready documents, and publication-blocked draft materials.
- Add a decision rail: source/representation → OCR → transcription → translation → human decision → publication block.
- Add OCR/transcription/translation comparison cards.
- Add internal review actions: start review, return for correction, approve internally, mark text layer reviewed.
- Keep all actions local/session-only.
- Keep publication blocked until human approval.

## Governance

```text
PALWAKF_REMOTE_INTEGRATION=NOT_CONNECTED_BY_DESIGN
STAGING_APPROVAL=NOT_APPROVED
PRODUCTION_APPROVAL=NOT_APPROVED
DATABASE_MUTATION=NONE
PLATFORM_MUTATION=NONE
```

## Static markers

```text
REVIEW_WORKFLOW_HUMAN_APPROVAL_STUDIO
HUMAN_APPROVAL_DECISION_STUDIO
REVIEW_TASK_PREMIUM_BOARD
TEXT_LAYER_COMPARISON_FOR_REVIEW
OCR_TRANSCRIPTION_TRANSLATION_REVIEW_COLUMNS
HUMAN_REVIEW_DECISION_ACTIONS
REVIEW_RETURN_CORRECTION_FLOW
APPROVAL_BLOCKS_PUBLICATION_UNTIL_HUMAN_DECISION
REVIEW_AUDIT_TRAIL_PANEL
REVIEW_CONFIDENCE_LAYER_STATUS
NO_PUBLICATION_FROM_REVIEW_STUDIO
```

## Local verification required

```powershell
python tools\verify_module_reception_static.py
flutter pub get
dart format lib test
flutter analyze
flutter test
flutter run -d chrome --target lib/main.dart
```
