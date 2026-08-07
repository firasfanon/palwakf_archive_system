import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/models.dart';
import '../../core/state/local_operational_store.dart';
import '../../shared/widgets.dart';

class ReportsNotificationsScreen extends ConsumerWidget {
  const ReportsNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(localOperationalProvider);
    final controller = ref.read(localOperationalProvider.notifier);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('التقارير والتنبيهات والتصدير',
            style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        const LocalOnlyBanner(),
        const SizedBox(height: 12),
        const Text(
          'REPORTS_NOTIFICATIONS_BACKUP_OPERATIONALIZATION: صفحة تشغيل يومية للتقارير والتنبيهات وطلبات التصدير ولقطات النسخ المحلية، دون إنشاء ملفات فعلية أو اتصال تخزين.',
        ),
        const SizedBox(height: 16),
        _ReportsSection(reports: state.reports),
        const SizedBox(height: 12),
        _NotificationsSection(
          notifications: state.notifications,
          onAcknowledge: controller.acknowledgeNotification,
        ),
        const SizedBox(height: 12),
        _ExportSection(
          requests: state.exportRequests,
          onRequestExport: controller.requestLocalExport,
        ),
        const SizedBox(height: 12),
        _BackupSection(
          snapshots: state.backupSnapshots,
          onCreateSnapshot: controller.createLocalBackupSnapshot,
          onRestoreDrill: controller.markBackupRestoreDrill,
        ),
      ],
    );
  }
}

class _ReportsSection extends StatelessWidget {
  const _ReportsSection({required this.reports});

  final List<ArchiveReport> reports;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      icon: Icons.assessment_outlined,
      title: 'لوحة تقارير محلية',
      subtitle:
          'LOCAL_REPORTING_DASHBOARD: مؤشرات تشغيلية يومية قابلة للتحول لاحقًا إلى تقارير BI.',
      children: [
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final report in reports)
              SizedBox(
                width: 320,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.insert_chart_outlined),
                            const SizedBox(width: 8),
                            Expanded(
                                child: Text(report.title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        KeyValueLine(label: 'النطاق', value: report.scope),
                        KeyValueLine(label: 'المؤشر', value: report.metric),
                        KeyValueLine(label: 'الحالة', value: report.state),
                        Text(report.summary,
                            style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _NotificationsSection extends StatelessWidget {
  const _NotificationsSection({
    required this.notifications,
    required this.onAcknowledge,
  });

  final List<ArchiveNotification> notifications;
  final ValueChanged<String> onAcknowledge;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      icon: Icons.notifications_active_outlined,
      title: 'تنبيهات العمل اليومي',
      subtitle:
          'NOTIFICATION_ACKNOWLEDGEMENT_ACTION: يمكن تأكيد قراءة التنبيهات داخل ذاكرة الجلسة فقط.',
      children: [
        if (notifications.isEmpty)
          const EmptyState(message: 'لا توجد تنبيهات محلية.')
        else
          for (final item in notifications)
            Card(
              child: ListTile(
                leading: Icon(item.acknowledged
                    ? Icons.notifications_none_outlined
                    : Icons.notification_important_outlined),
                title: Text(item.title),
                subtitle: Text(
                    '${item.message}\n${item.severity} — ${_formatDate(item.createdAt)}'),
                isThreeLine: true,
                trailing: item.acknowledged
                    ? const StatusPill(label: 'مقروء')
                    : FilledButton.tonalIcon(
                        onPressed: () => onAcknowledge(item.id),
                        icon: const Icon(Icons.done_all_outlined),
                        label: const Text('تأكيد'),
                      ),
              ),
            ),
      ],
    );
  }
}

class _ExportSection extends StatefulWidget {
  const _ExportSection({
    required this.requests,
    required this.onRequestExport,
  });

  final List<ExportRequest> requests;
  final void Function(String title, String format) onRequestExport;

  @override
  State<_ExportSection> createState() => _ExportSectionState();
}

class _ExportSectionState extends State<_ExportSection> {
  final _title = TextEditingController(text: 'تصدير تقرير تشغيل يومي');
  String _format = 'CSV';

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      icon: Icons.file_download_outlined,
      title: 'طلبات التصدير المحلية',
      subtitle:
          'EXPORT_REQUEST_QUEUE_LOCAL: لا تُنشأ ملفات فعلية؛ يتم تسجيل الطلب فقط داخل session state.',
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 12,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SizedBox(
              width: 320,
              child: TextField(
                controller: _title,
                decoration: const InputDecoration(
                  labelText: 'عنوان طلب التصدير',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(
              width: 180,
              child: DropdownButtonFormField<String>(
                initialValue: _format,
                decoration: const InputDecoration(labelText: 'الصيغة'),
                items: const [
                  DropdownMenuItem(value: 'CSV', child: Text('CSV')),
                  DropdownMenuItem(value: 'PDF', child: Text('PDF')),
                  DropdownMenuItem(value: 'JSON', child: Text('JSON')),
                ],
                onChanged: (value) => setState(() => _format = value ?? 'CSV'),
              ),
            ),
            FilledButton.icon(
              onPressed: () => widget.onRequestExport(_title.text, _format),
              icon: const Icon(Icons.add_to_drive_outlined),
              label: const Text('تسجيل طلب تصدير'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        for (final request in widget.requests)
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: Text(request.title),
            subtitle: Text(
                '${request.format} — ${request.scope} — ${_formatDate(request.requestedAt)}'),
            trailing: StatusPill(label: request.status),
          ),
      ],
    );
  }
}

class _BackupSection extends StatefulWidget {
  const _BackupSection({
    required this.snapshots,
    required this.onCreateSnapshot,
    required this.onRestoreDrill,
  });

  final List<BackupSnapshot> snapshots;
  final ValueChanged<String> onCreateSnapshot;
  final ValueChanged<String> onRestoreDrill;

  @override
  State<_BackupSection> createState() => _BackupSectionState();
}

class _BackupSectionState extends State<_BackupSection> {
  final _title = TextEditingController(text: 'لقطة نسخ محلية يدوية');

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      icon: Icons.backup_outlined,
      title: 'لقطات النسخ واختبار الاسترجاع',
      subtitle:
          'BACKUP_RESTORE_DRILL_LOCAL: محاكاة تشغيلية فقط؛ لا كتابة على File Center أو قاعدة البيانات.',
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 12,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SizedBox(
              width: 320,
              child: TextField(
                controller: _title,
                decoration: const InputDecoration(
                  labelText: 'عنوان لقطة النسخ',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            FilledButton.icon(
              onPressed: () => widget.onCreateSnapshot(_title.text),
              icon: const Icon(Icons.backup_table_outlined),
              label: const Text('إنشاء لقطة محلية'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        for (final snapshot in widget.snapshots)
          Card(
            child: ListTile(
              leading: const Icon(Icons.storage_outlined),
              title: Text(snapshot.title),
              subtitle: Text(
                  '${snapshot.coverage}\n${snapshot.hashPreview}\n${snapshot.restoreDrillStatus}'),
              isThreeLine: true,
              trailing: FilledButton.tonalIcon(
                onPressed: () => widget.onRestoreDrill(snapshot.id),
                icon: const Icon(Icons.restore_page_outlined),
                label: const Text('اختبار استرجاع'),
              ),
            ),
          ),
      ],
    );
  }
}

String _formatDate(DateTime value) {
  return '${value.year}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')} '
      '${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}';
}
