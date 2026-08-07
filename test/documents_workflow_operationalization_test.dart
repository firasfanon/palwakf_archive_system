import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:palwakf_evidence_archive_spatial_explorer/src/core/models/models.dart';
import 'package:palwakf_evidence_archive_spatial_explorer/src/core/state/local_operational_store.dart';
import 'package:palwakf_evidence_archive_spatial_explorer/src/platform_integration/contracts.dart';

void main() {
  test('documents and workflow screens expose operational markers', () {
    final documents =
        File('lib/src/features/evidence/evidence_explorer_screen.dart')
            .readAsStringSync();
    final detail = File('lib/src/features/evidence/evidence_detail_screen.dart')
        .readAsStringSync();
    final review = File('lib/src/features/review/review_queue_screen.dart')
        .readAsStringSync();
    final lifecycle =
        File('lib/src/features/daily/document_lifecycle_screen.dart')
            .readAsStringSync();
    final search = File('lib/src/features/search/search_discovery_screen.dart')
        .readAsStringSync();
    final imports = File('lib/src/features/imports/import_catalog_screen.dart')
        .readAsStringSync();

    expect(documents.contains('DOCUMENTS_WORKFLOW_OPERATIONALIZATION'), isTrue);
    expect(documents.contains('EVIDENCE_WORKFLOW_ACTION_BAR'), isTrue);
    expect(detail.contains('DOCUMENT_DETAIL_OPERATIONAL_TABS'), isTrue);
    expect(review.contains('REVIEW_QUEUE_WORKFLOW_ACTIONS'), isTrue);
    expect(lifecycle.contains('DOCUMENT_LIFECYCLE_OPERATIONAL_BOARD'), isTrue);
    expect(search.contains('SMART_SEARCH_ADVANCED_FILTERS'), isTrue);
    expect(imports.contains('IMPORT_WORKFLOW_STATUS_ADVANCEMENT'), isTrue);
  });

  test('local controller runs document workflow transitions', () {
    final controller = LocalOperationalController();
    final beforeTasks = controller.state.reviewTasks.length;

    controller.submitEvidenceForReview('EV-DEMO-WAQF-0001');
    expect(
      controller.state.evidence
          .firstWhere((item) => item.id == 'EV-DEMO-WAQF-0001')
          .status,
      EvidenceReviewStatus.inReview,
    );
    expect(
        controller.state.reviewTasks.length, greaterThanOrEqualTo(beforeTasks));

    final task = controller.state.reviewTasks.firstWhere(
      (item) => item.evidenceId == 'EV-DEMO-WAQF-0001',
    );
    controller.completeReviewTaskAndApprove(task.id);
    expect(
      controller.state.evidence
          .firstWhere((item) => item.id == 'EV-DEMO-WAQF-0001')
          .status,
      EvidenceReviewStatus.internalReady,
    );
  });

  test('import workflow status can advance locally', () {
    final controller = LocalOperationalController();
    controller.updateImportBatchStatus('IMP-DEMO-001', ImportStatus.validated);
    expect(
      controller.state.importBatches
          .firstWhere((batch) => batch.id == 'IMP-DEMO-001')
          .importStatus,
      ImportStatus.validated,
    );
  });

  test('workflow mutation remains scoped to local unit', () {
    final controller = LocalOperationalController();
    expect(
      () => controller.addReviewTask(
        const ReviewTask(
          id: 'REV-CROSS-UNIT',
          title: 'مهمة خاطئة النطاق',
          evidenceId: 'EV-DEMO-WAQF-0001',
          domain: EvidenceDomain.waqf,
          priority: 'عادية',
          assignedRole: 'مراجع',
          state: ReviewTaskState.open,
          unitScopeKey: 'OTHER-UNIT',
        ),
      ),
      throwsStateError,
    );
    expect(localDevelopmentUnitKey, 'LOCAL-DEMO-UNIT');
  });
}
