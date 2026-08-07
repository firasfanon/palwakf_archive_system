import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:palwakf_evidence_archive_spatial_explorer/src/core/state/local_operational_store.dart';

void main() {
  test('reports notifications backup surfaces expose operational markers', () {
    final screen =
        File('lib/src/features/reports/reports_notifications_screen.dart')
            .readAsStringSync();
    final security = File('lib/src/features/daily/security_backup_screen.dart')
        .readAsStringSync();

    expect(screen.contains('REPORTS_NOTIFICATIONS_BACKUP_OPERATIONALIZATION'),
        isTrue);
    expect(screen.contains('LOCAL_REPORTING_DASHBOARD'), isTrue);
    expect(screen.contains('NOTIFICATION_ACKNOWLEDGEMENT_ACTION'), isTrue);
    expect(screen.contains('EXPORT_REQUEST_QUEUE_LOCAL'), isTrue);
    expect(screen.contains('BACKUP_RESTORE_DRILL_LOCAL'), isTrue);
    expect(security.contains('SECURITY_BACKUP_OPERATIONALIZATION'), isTrue);
  });

  test(
      'local controller supports notifications, backup snapshots and export requests',
      () {
    final controller = LocalOperationalController();
    final firstNotification = controller.state.notifications.first;
    final backupCount = controller.state.backupSnapshots.length;
    final exportCount = controller.state.exportRequests.length;

    controller.acknowledgeNotification(firstNotification.id);
    expect(
      controller.state.notifications
          .firstWhere((item) => item.id == firstNotification.id)
          .acknowledged,
      isTrue,
    );

    controller.createLocalBackupSnapshot('اختبار نسخ محلي');
    expect(controller.state.backupSnapshots.length, backupCount + 1);

    final newestBackup = controller.state.backupSnapshots.first;
    controller.markBackupRestoreDrill(newestBackup.id);
    expect(
      controller.state.backupSnapshots.first.restoreDrillStatus,
      'تم اختبار الاسترجاع محليًا',
    );

    controller.requestLocalExport('تصدير اختبار', 'CSV');
    expect(controller.state.exportRequests.length, exportCount + 1);
  });
}
