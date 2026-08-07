import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:palwakf_evidence_archive_spatial_explorer/src/core/state/local_operational_store.dart';

void main() {
  test(
      'access publication retention and audit screen exposes operational markers',
      () {
    final app = File('lib/src/app.dart').readAsStringSync();
    final screen = File(
            'lib/src/features/access/access_publication_retention_audit_screen.dart')
        .readAsStringSync();
    final store = File('lib/src/core/state/local_operational_store.dart')
        .readAsStringSync();
    final models = File('lib/src/core/models/models.dart').readAsStringSync();

    expect(app.contains('AccessPublicationRetentionAuditScreen'), isTrue);
    expect(
        screen
            .contains('ACCESS_PUBLICATION_RETENTION_AUDIT_OPERATIONALIZATION'),
        isTrue);
    expect(screen.contains('ACCESS_POLICY_MATRIX_LOCAL'), isTrue);
    expect(screen.contains('PUBLICATION_REVIEW_QUEUE_LOCAL'), isTrue);
    expect(screen.contains('RETENTION_SCHEDULE_LOCAL'), isTrue);
    expect(screen.contains('AUDIT_TRAIL_LOCAL'), isTrue);
    expect(models.contains('class AccessPolicyRule'), isTrue);
    expect(models.contains('class PublicationRequest'), isTrue);
    expect(models.contains('class RetentionRule'), isTrue);
    expect(models.contains('class AuditTrailEntry'), isTrue);
    expect(store.contains('void requestPublicationReview('), isTrue);
    expect(store.contains('void approvePublicationRequest('), isTrue);
    expect(store.contains('void markRetentionReview('), isTrue);
    expect(store.contains('void recordAccessAudit('), isTrue);
  });

  test('local controller runs publication retention and audit workflow', () {
    final controller = LocalOperationalController();
    final pubBefore = controller.state.publicationRequests.length;
    final auditBefore = controller.state.auditTrail.length;

    controller.requestPublicationReview('EV-DEMO-WAQF-0001');
    expect(controller.state.publicationRequests.length, pubBefore + 1);
    expect(controller.state.publicationRequests.first.status,
        'بانتظار مراجعة الإتاحة');

    final requestId = controller.state.publicationRequests.first.id;
    controller.approvePublicationRequest(requestId);
    expect(controller.state.publicationRequests.first.status, 'معتمد محليًا');

    controller.markRetentionReview('RET-LOCAL-001');
    expect(controller.state.retentionRules.first.status,
        'تمت مراجعة الاحتفاظ محليًا');

    controller.recordAccessAudit('EV-DEMO-WAQF-0001', 'قراءة اختبارية');
    expect(controller.state.auditTrail.length, greaterThan(auditBefore));
  });
}
