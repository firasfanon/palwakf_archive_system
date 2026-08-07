import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/models.dart';
import '../../core/state/local_operational_store.dart';
import '../../platform_integration/contracts.dart';
import '../../platform_integration/local_capability_gate.dart';
import '../../shared/widgets.dart';

class ImportCatalogScreen extends ConsumerWidget {
  const ImportCatalogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final batches = ref.watch(localOperationalProvider).importBatches;

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showImportDialog(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('فهرسة دفعة'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'كتالوج الاستيراد المرحلي',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          const LocalOnlyBanner(),
          const SizedBox(height: 12),
          const SectionCard(
            icon: Icons.schema_outlined,
            title: 'خط سير الاستيراد',
            subtitle:
                'IMPORT_WORKFLOW_STATUS_ADVANCEMENT: كل انتقال محلي فقط ولا يرقّي بيانات إلى منصة PalWakf.',
            children: [
              KeyValueLine(
                  label: '1', value: 'TABLE_CATALOG — فهرسة ملف أو جدول.'),
              KeyValueLine(
                  label: '2',
                  value: 'DATA_DICTIONARY — مطابقة الأعمدة والمعاني.'),
              KeyValueLine(
                  label: '3', value: 'STAGING — تجهيز مؤقت بعد اعتماد لاحق.'),
              KeyValueLine(
                  label: '4', value: 'VALIDATION — تحقق ومراجعة أخطاء.'),
              KeyValueLine(
                  label: '5',
                  value: 'RECONCILIATION — مطابقة مع الوثائق والأصول.'),
              KeyValueLine(
                  label: '6',
                  value: 'DOMAIN_REVIEW — مراجعة إدارية/وقفية/قانونية.'),
              KeyValueLine(
                  label: '7', value: 'PROMOTION — ممنوعة محليًا ودون Staging.'),
            ],
          ),
          const SizedBox(height: 16),
          if (batches.isEmpty)
            const EmptyState(message: 'لا توجد دفعات استيراد مفهرسة.')
          else
            for (final batch in batches) ...[
              _ImportBatchCard(batch: batch),
              const SizedBox(height: 10),
            ],
        ],
      ),
    );
  }

  void _showImportDialog(BuildContext context, WidgetRef ref) {
    showDialog<ImportBatch>(
      context: context,
      builder: (context) => const _ImportBatchDialog(),
    ).then((value) {
      if (value != null) {
        if (!requireLocalCapability(
          context,
          ref,
          capability: ArchiveCapability.importCatalogLocalDraft,
          actionLabel: 'فهرسة دفعة محلية',
        )) {
          return;
        }
        ref.read(localOperationalProvider.notifier).addImportBatch(value);
      }
    });
  }
}

class _ImportBatchCard extends ConsumerWidget {
  const _ImportBatchCard({required this.batch});

  final ImportBatch batch;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final content = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(batch.fileName,
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 6),
                Text(
                    '${batch.id} • ${batch.sheetName} • ${batch.rowCount} صفًا'),
                const SizedBox(height: 6),
                Text(batch.validationSummary),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    StatusPill(label: batch.domain.label),
                    StatusPill(label: batch.importStatus.label),
                    StatusPill(label: batch.status),
                  ],
                ),
              ],
            );
            final actions = _ImportStatusActions(batch: batch);
            if (constraints.maxWidth < 650) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [content, const SizedBox(height: 10), actions],
              );
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.table_chart_outlined),
                const SizedBox(width: 12),
                Expanded(child: content),
                actions,
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ImportStatusActions extends ConsumerWidget {
  const _ImportStatusActions({required this.batch});

  final ImportBatch batch;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      alignment: WrapAlignment.end,
      children: [
        OutlinedButton.icon(
          onPressed: () => _set(context, ref, ImportStatus.validated),
          icon: const Icon(Icons.rule_outlined),
          label: const Text('تحقق'),
        ),
        OutlinedButton.icon(
          onPressed: () => _set(context, ref, ImportStatus.readyForImport),
          icon: const Icon(Icons.playlist_add_check_outlined),
          label: const Text('جاهز'),
        ),
        OutlinedButton.icon(
          onPressed: () => _set(context, ref, ImportStatus.rejected),
          icon: const Icon(Icons.block_outlined),
          label: const Text('رفض'),
        ),
        PopupMenuButton<ImportStatus>(
          tooltip: 'تحديث حالة الدفعة',
          onSelected: (value) => _set(context, ref, value),
          itemBuilder: (context) => [
            for (final status in ImportStatus.values)
              PopupMenuItem(value: status, child: Text(status.label)),
          ],
        ),
      ],
    );
  }

  void _set(BuildContext context, WidgetRef ref, ImportStatus status) {
    if (!requireLocalCapability(
      context,
      ref,
      capability: ArchiveCapability.importCatalogLocalDraft,
      actionLabel: 'تحديث حالة دفعة استيراد',
    )) {
      return;
    }
    ref
        .read(localOperationalProvider.notifier)
        .updateImportBatchStatus(batch.id, status);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('تم تحديث حالة الدفعة إلى: ${status.label}')),
    );
  }
}

class _ImportBatchDialog extends StatefulWidget {
  const _ImportBatchDialog();

  @override
  State<_ImportBatchDialog> createState() => _ImportBatchDialogState();
}

class _ImportBatchDialogState extends State<_ImportBatchDialog> {
  final _fileName = TextEditingController();
  final _sheetName = TextEditingController(text: 'Sheet1');
  final _rowCount = TextEditingController(text: '0');
  final _validationSummary = TextEditingController(
    text: 'بانتظار التحقق من الأعمدة والمفاتيح والحقوق.',
  );
  EvidenceDomain _domain = EvidenceDomain.waqf;

  @override
  void dispose() {
    _fileName.dispose();
    _sheetName.dispose();
    _rowCount.dispose();
    _validationSummary.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('فهرسة دفعة استيراد محلية'),
      content: SizedBox(
        width: 500,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _fileName,
                decoration: const InputDecoration(labelText: 'اسم الملف'),
              ),
              TextField(
                controller: _sheetName,
                decoration: const InputDecoration(labelText: 'اسم الورقة'),
              ),
              TextField(
                controller: _rowCount,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'عدد الصفوف'),
              ),
              TextField(
                controller: _validationSummary,
                minLines: 2,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'ملخص التحقق'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<EvidenceDomain>(
                initialValue: _domain,
                decoration: const InputDecoration(labelText: 'المجال'),
                items: [
                  for (final domain in EvidenceDomain.values)
                    DropdownMenuItem(
                      value: domain,
                      child: Text(domain.label),
                    ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _domain = value);
                  }
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('إلغاء'),
        ),
        FilledButton(
          onPressed: () {
            if (_fileName.text.trim().isEmpty) {
              return;
            }
            Navigator.of(context).pop(
              ImportBatch(
                id: 'IMP-LOCAL-${DateTime.now().millisecondsSinceEpoch}',
                fileName: _fileName.text.trim(),
                sheetName: _sheetName.text.trim(),
                domain: _domain,
                rowCount: int.tryParse(_rowCount.text.trim()) ?? 0,
                status: 'مفهرسة محليًا',
                unitScopeKey: localDevelopmentUnitKey,
                importStatus: ImportStatus.staged,
                validationSummary: _validationSummary.text.trim(),
              ),
            );
          },
          child: const Text('إضافة'),
        ),
      ],
    );
  }
}
