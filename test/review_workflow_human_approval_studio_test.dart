import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:palwakf_evidence_archive_spatial_explorer/src/core/models/models.dart';
import 'package:palwakf_evidence_archive_spatial_explorer/src/core/state/local_operational_store.dart';

void main() {
  test('review workflow and human approval studio markers are present', () {
    final review = File('lib/src/features/review/review_queue_screen.dart')
        .readAsStringSync();
    final app = File('lib/src/app.dart').readAsStringSync();
    final verify =
        File('tools/verify_module_reception_static.py').readAsStringSync();

    for (final marker in [
      'REVIEW_WORKFLOW_HUMAN_APPROVAL_STUDIO',
      'HUMAN_APPROVAL_DECISION_STUDIO',
      'REVIEW_TASK_PREMIUM_BOARD',
      'TEXT_LAYER_COMPARISON_FOR_REVIEW',
      'OCR_TRANSCRIPTION_TRANSLATION_REVIEW_COLUMNS',
      'HUMAN_REVIEW_DECISION_ACTIONS',
      'REVIEW_RETURN_CORRECTION_FLOW',
      'APPROVAL_BLOCKS_PUBLICATION_UNTIL_HUMAN_DECISION',
      'REVIEW_AUDIT_TRAIL_PANEL',
      'REVIEW_CONFIDENCE_LAYER_STATUS',
      'NO_PUBLICATION_FROM_REVIEW_STUDIO',
      'REVIEW_QUEUE_WORKFLOW_ACTIONS',
      'REVIEW_STUDIO_R3_APPLY_GUARD_AND_LEGACY_TEST_REPAIR',
    ]) {
      expect(
          review.contains(marker) ||
              app.contains(marker) ||
              verify.contains(marker),
          isTrue);
    }
  });

  test(
      'review decisions remain local and block publication until human approval',
      () {
    final controller = LocalOperationalController();
    final task = controller.state.reviewTasks.firstWhere(
      (item) =>
          item.state != ReviewTaskState.completed &&
          item.state != ReviewTaskState.cancelled,
    );
    final evidenceBefore = controller.state.evidence
        .firstWhere((item) => item.id == task.evidenceId);

    controller.completeReviewTaskAndApprove(task.id);

    final completedTask =
        controller.state.reviewTasks.firstWhere((item) => item.id == task.id);
    final evidenceAfter = controller.state.evidence
        .firstWhere((item) => item.id == evidenceBefore.id);

    expect(completedTask.state, ReviewTaskState.completed);
    expect(evidenceAfter.status, EvidenceReviewStatus.internalReady);
    expect(evidenceAfter.publicationStatus, contains('اعتمادًا بشريًا'));
  });

  test('text draft layer review marks layer internally without publishing', () {
    final controller = LocalOperationalController();
    final layer = controller.state.textDraftLayers.first;

    controller.markTextDraftLayerReviewed(layer.id);

    final reviewed = controller.state.textDraftLayers
        .firstWhere((item) => item.id == layer.id);
    expect(reviewed.status, contains('مراجعة داخليًا'));
    expect(reviewed.humanReviewPolicy,
        contains('NO_PUBLICATION_FROM_TEXT_DRAFTS'));
  });
}
