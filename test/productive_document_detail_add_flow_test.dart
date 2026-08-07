import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:palwakf_evidence_archive_spatial_explorer/src/core/models/models.dart';
import 'package:palwakf_evidence_archive_spatial_explorer/src/core/state/local_operational_store.dart';

void main() {
  test('productive add flow and governed detail markers are present', () {
    final add = File('lib/src/features/daily/add_document_screen.dart')
        .readAsStringSync();
    final detail = File('lib/src/features/evidence/evidence_detail_screen.dart')
        .readAsStringSync();
    final store = File('lib/src/core/state/local_operational_store.dart')
        .readAsStringSync();

    expect(add.contains('ADD_DOCUMENT_MULTI_STEP_FLOW'), isTrue);
    expect(add.contains('GOVERNED_DOCUMENT_DRAFT_CREATION'), isTrue);
    expect(add.contains('DOCUMENT_INTAKE_VALIDATION_RULES'), isTrue);
    expect(add.contains('Stepper('), isTrue);
    expect(add.contains('createGovernedDocumentDraft'), isTrue);
    expect(detail.contains('DOCUMENT_DETAIL_GOVERNED_TABS'), isTrue);
    expect(detail.contains('WORKFLOW_AUDIT_ON_DOCUMENT_ACTIONS'), isTrue);
    expect(
        store.contains(
            'PRODUCTIVE_DOCUMENT_DETAIL_ADD_FLOW_AND_GOVERNED_WORKFLOW'),
        isTrue);
  });

  test(
      'controller creates governed document, representation, review task, and audit event',
      () {
    final controller = LocalOperationalController();
    final beforeEvidence = controller.state.evidence.length;
    final beforeRepresentations = controller.state.representations.length;
    final beforeTasks = controller.state.reviewTasks.length;
    final beforeAudit = controller.state.auditTrail.length;

    final id = controller.createGovernedDocumentDraft(
      title: 'وثيقة اختبار تدفق محكوم',
      sourceAuthority: 'إدارة الاختبار',
      reference: 'LOCAL/TEST/GOV-001',
      domain: EvidenceDomain.general,
      accessLevel: AccessLevel.restricted,
      spatialStatus: SpatialStatus.notMapped,
      dateLabel: '2026',
      rightsStatus: 'حقوق داخلية',
      legalSensitivity: 'حساسية اختبارية',
      departmentLabel: 'إدارة الاختبار',
      subjectLabel: 'اختبار تشغيل',
      documentType: 'نموذج اختبار',
      keywords: const ['اختبار', 'تدفق'],
      hasOriginal: true,
      createInitialRepresentation: true,
      submitForReview: true,
      linkedWaqfAssetId: 'PWF-AST-TEST-001',
    );

    expect(controller.state.evidence.length, beforeEvidence + 1);
    expect(controller.state.representations.length, beforeRepresentations + 1);
    expect(controller.state.reviewTasks.length, beforeTasks + 1);
    expect(controller.state.auditTrail.length, beforeAudit + 1);

    final created =
        controller.state.evidence.firstWhere((item) => item.id == id);
    expect(created.status, EvidenceReviewStatus.inReview);
    expect(created.departmentLabel, 'إدارة الاختبار');
    expect(created.subjectLabel, 'اختبار تشغيل');
    expect(created.documentType, 'نموذج اختبار');
    expect(created.keywords, contains('تدفق'));
    expect(created.linkedWaqfAssetId, 'PWF-AST-TEST-001');

    expect(
      controller.state.reviewTasks.any((task) => task.evidenceId == id),
      isTrue,
    );
    expect(
      controller.state.auditTrail.any((entry) => entry.targetId == id),
      isTrue,
    );
  });
}
