import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:palwakf_evidence_archive_spatial_explorer/src/core/models/models.dart';
import 'package:palwakf_evidence_archive_spatial_explorer/src/core/state/local_operational_store.dart';

void main() {
  test('upload and representation screens expose preview and local queue UX',
      () {
    final upload = File('lib/src/features/daily/upload_storage_screen.dart')
        .readAsStringSync();
    final representations =
        File('lib/src/features/representations/representations_screen.dart')
            .readAsStringSync();

    expect(
        upload.contains('UPLOAD_REPRESENTATION_PREVIEW_AND_LOCAL_FILE_QUEUE'),
        isTrue);
    expect(upload.contains('معاينة تمثيل محلي'), isTrue);
    expect(upload.contains('إضافة إلى طابور الرفع المحلي'), isTrue);
    expect(upload.contains('Hash تجريبي'), isTrue);
    expect(upload.contains('استبدال أصل محظور'), isTrue);
    expect(
        representations.contains('REPRESENTATION_MANAGER_REFINEMENT'), isTrue);
    expect(representations.contains('وسم كمراجع محليًا'), isTrue);
  });

  test('controller queues representation with preview metadata and audit', () {
    final controller = LocalOperationalController();
    final originalCount = controller.state.representations.length;
    final auditCount = controller.state.auditTrail.length;

    final id = controller.queueLocalRepresentation(
      evidenceId: 'EV-DEMO-WAQF-0001',
      type: RepresentationType.translation,
      title: 'ترجمة تجريبية محلية',
      format: 'text/markdown',
      rightsStatus: 'مشتق داخلي',
      isAuthoritativeOriginal: false,
      fileSizeLabel: '12 KB',
      previewKind: 'ترجمة',
      previewNote: 'تمثيل مشتق قابل لإعادة البناء',
    );

    expect(controller.state.representations.length, originalCount + 1);
    final queued =
        controller.state.representations.firstWhere((item) => item.id == id);
    expect(queued.uploadStatus, contains('طابور'));
    expect(queued.fileSizeLabel, '12 KB');
    expect(queued.previewNote, contains('قابل لإعادة البناء'));
    expect(controller.state.auditTrail.length, auditCount + 1);

    controller.markRepresentationReviewed(id);
    final reviewed =
        controller.state.representations.firstWhere((item) => item.id == id);
    expect(reviewed.uploadStatus, contains('مراجع'));
  });

  test('original replacement is blocked and recorded as local queue status',
      () {
    final controller = LocalOperationalController();

    final id = controller.queueLocalRepresentation(
      evidenceId: 'EV-DEMO-WAQF-0001',
      type: RepresentationType.original,
      title: 'محاولة استبدال أصل',
      format: 'application/pdf',
      rightsStatus: 'اختبار حظر',
      isAuthoritativeOriginal: true,
    );

    final blocked =
        controller.state.representations.firstWhere((item) => item.id == id);
    expect(blocked.isAuthoritativeOriginal, isFalse);
    expect(blocked.uploadStatus, contains('استبدال أصل محظور'));
    expect(controller.state.blockedOriginalReplacementCount,
        greaterThanOrEqualTo(1));
  });
}
