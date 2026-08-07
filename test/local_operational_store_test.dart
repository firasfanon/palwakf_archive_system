import 'package:flutter_test/flutter_test.dart';
import 'package:palwakf_evidence_archive_spatial_explorer/src/core/models/models.dart';
import 'package:palwakf_evidence_archive_spatial_explorer/src/core/state/local_operational_store.dart';
import 'package:palwakf_evidence_archive_spatial_explorer/src/platform_integration/contracts.dart';

void main() {
  test('quarantine and restore change only session-local evidence state', () {
    final controller = LocalOperationalController();
    const targetId = 'EV-DEMO-WAQF-0001';

    controller.quarantineEvidence(targetId);
    final quarantined =
        controller.state.evidence.firstWhere((item) => item.id == targetId);
    expect(quarantined.status, EvidenceReviewStatus.quarantined);

    controller.restoreEvidence(targetId);
    final restored =
        controller.state.evidence.firstWhere((item) => item.id == targetId);
    expect(restored.status, EvidenceReviewStatus.inReview);
  });

  test('adding evidence extends local session state', () {
    final controller = LocalOperationalController();
    final originalCount = controller.state.evidence.length;

    controller.addEvidence(
      EvidenceItem(
        id: 'EV-TEST-001',
        title: 'اختبار',
        domain: EvidenceDomain.general,
        sourceAuthority: 'اختبار',
        reference: 'TEST/001',
        status: EvidenceReviewStatus.discovered,
        confidence: 'اختبار',
        unitScopeKey: localDevelopmentUnitKey,
        isOriginalAvailableLocally: false,
        createdAt: DateTime(2026),
      ),
    );

    expect(controller.state.evidence.length, originalCount + 1);
  });
}
