import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:palwakf_evidence_archive_spatial_explorer/src/core/models/models.dart';
import 'package:palwakf_evidence_archive_spatial_explorer/src/core/state/local_operational_store.dart';
import 'package:palwakf_evidence_archive_spatial_explorer/src/platform_integration/contracts.dart';

void main() {
  test('daily operations surfaces expose interactive local forms', () {
    final classification =
        File('lib/src/features/daily/document_classification_screen.dart')
            .readAsStringSync();
    final metadata =
        File('lib/src/features/daily/document_metadata_screen.dart')
            .readAsStringSync();
    final upload = File('lib/src/features/daily/upload_storage_screen.dart')
        .readAsStringSync();

    expect(classification.contains('DAILY_OPERATIONS_FULL_UI'), isTrue);
    expect(classification.contains('إضافة عقدة تصنيف محلية'), isTrue);
    expect(metadata.contains('حفظ metadata محليًا'), isTrue);
    expect(upload.contains('إضافة إلى قائمة الرفع المحلية'), isTrue);
  });

  test('local operation controller supports representation queue', () {
    final controller = LocalOperationalController();
    final originalCount = controller.state.representations.length;

    controller.addRepresentation(
      ArchiveRepresentation(
        id: 'REP-TEST-001',
        evidenceId: 'EV-DEMO-WAQF-0001',
        type: RepresentationType.scan,
        title: 'اختبار تمثيل',
        format: 'application/pdf',
        hashPreview: 'sha256:TEST',
        rightsStatus: 'اختبار',
        unitScopeKey: localDevelopmentUnitKey,
        isAuthoritativeOriginal: false,
      ),
    );

    expect(controller.state.representations.length, originalCount + 1);
  });
}
