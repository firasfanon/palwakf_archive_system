import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/models.dart';
import '../../core/state/local_operational_store.dart';
import '../../platform_integration/contracts.dart';
import '../../platform_integration/local_capability_gate.dart';
import '../../shared/widgets.dart';

// DAILY_OPERATIONS_FULL_UI: interactive classification management surface.
class DocumentClassificationScreen extends ConsumerStatefulWidget {
  const DocumentClassificationScreen({super.key});

  @override
  ConsumerState<DocumentClassificationScreen> createState() =>
      _DocumentClassificationScreenState();
}

class _DocumentClassificationScreenState
    extends ConsumerState<DocumentClassificationScreen> {
  final _title = TextEditingController();
  final _reference = TextEditingController(text: 'FONDS/LOCAL/NEW');
  final _description = TextEditingController();
  ArchiveNodeType _type = ArchiveNodeType.file;
  AccessLevel _accessLevel = AccessLevel.internal;
  EvidenceReviewStatus _reviewStatus = EvidenceReviewStatus.discovered;

  @override
  void dispose() {
    _title.dispose();
    _reference.dispose();
    _description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(localOperationalProvider);
    final byType = <ArchiveNodeType, int>{
      for (final type in ArchiveNodeType.values)
        type: state.archiveNodes.where((node) => node.type == type).length,
    };

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'تصنيف الوثائق الإدارية',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        const LocalOnlyBanner(),
        const SizedBox(height: 8),
        const Text(
          'واجهة تشغيلية لإدارة شجرة التصنيف حسب الإدارة والموضوع والنوع والسلسلة. الإضافة هنا محلية داخل الجلسة فقط.',
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final entry in byType.entries)
              MetricTile(
                icon: Icons.account_tree_outlined,
                label: entry.key.label,
                value: entry.value.toString(),
              ),
          ],
        ),
        const SizedBox(height: 16),
        SectionCard(
          icon: Icons.account_tree_outlined,
          title: 'إضافة عقدة تصنيف محلية',
          subtitle:
              'تستخدم لتجربة Fonds / Series / File / Item قبل أي قاعدة بيانات.',
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                final wide = constraints.maxWidth >= 760;
                final fields = [
                  TextField(
                    controller: _title,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'عنوان التصنيف',
                    ),
                  ),
                  TextField(
                    controller: _reference,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'المرجع الأرشيفي',
                    ),
                  ),
                  DropdownButtonFormField<ArchiveNodeType>(
                    initialValue: _type,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'المستوى',
                    ),
                    items: [
                      for (final type in ArchiveNodeType.values)
                        DropdownMenuItem(value: type, child: Text(type.label)),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _type = value);
                      }
                    },
                  ),
                  DropdownButtonFormField<AccessLevel>(
                    initialValue: _accessLevel,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'الإتاحة',
                    ),
                    items: [
                      for (final level in AccessLevel.values)
                        DropdownMenuItem(
                            value: level, child: Text(level.label)),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _accessLevel = value);
                      }
                    },
                  ),
                ];
                if (!wide) {
                  return Column(
                    children: [
                      for (final field in fields) ...[
                        field,
                        const SizedBox(height: 10)
                      ],
                      _descriptionField(),
                      const SizedBox(height: 10),
                      _addButton(context),
                    ],
                  );
                }
                return Column(
                  children: [
                    Row(
                      children: [
                        for (final field in fields) ...[
                          Expanded(child: field),
                          const SizedBox(width: 10),
                        ],
                      ],
                    ),
                    const SizedBox(height: 10),
                    _descriptionField(),
                    const SizedBox(height: 10),
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: _addButton(context),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 12),
        SectionCard(
          icon: Icons.account_tree_outlined,
          title: 'شجرة التصنيف الحالية',
          children: [
            for (final node in state.archiveNodes)
              Card(
                child: ListTile(
                  leading: Icon(_iconFor(node.type)),
                  title: Text(node.title),
                  subtitle: Text('${node.reference}\n${node.description}'),
                  isThreeLine: true,
                  trailing: Wrap(
                    spacing: 6,
                    children: [
                      StatusPill(label: node.type.label),
                      StatusPill(label: node.accessLevel.label),
                      StatusPill(label: node.reviewStatus.label),
                    ],
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        const SectionCard(
          icon: Icons.business_outlined,
          title: 'نموذج تصنيف الوثائق حسب الإدارات والموضوعات',
          children: [
            KeyValueLine(
                label: 'الإدارة القانونية',
                value: 'قضايا، اعتراضات، مراسلات محاكم، مستندات إثبات.'),
            KeyValueLine(
                label: 'إدارة الأملاك الوقفية',
                value: 'قواشين، شهادات تسجيل، مخططات، عقود، ملفات أصول.'),
            KeyValueLine(
                label: 'الإدارة المالية',
                value: 'إيصالات، مطالبات، أوامر دفع، تقارير تحصيل.'),
            KeyValueLine(
                label: 'GIS والمساحة',
                value: 'إحداثيات، طبقات مكانية، صور جوية، تقارير مطابقة.'),
          ],
        ),
      ],
    );
  }

  TextField _descriptionField() {
    return TextField(
      controller: _description,
      maxLines: 2,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'وصف التصنيف وسبب إنشائه',
      ),
    );
  }

  Widget _addButton(BuildContext context) {
    return FilledButton.icon(
      onPressed: () => _addNode(context),
      icon: const Icon(Icons.add),
      label: const Text('إضافة محلية'),
    );
  }

  IconData _iconFor(ArchiveNodeType type) {
    switch (type) {
      case ArchiveNodeType.fonds:
        return Icons.inventory_2_outlined;
      case ArchiveNodeType.series:
        return Icons.view_stream_outlined;
      case ArchiveNodeType.file:
        return Icons.folder_open_outlined;
      case ArchiveNodeType.item:
        return Icons.description_outlined;
    }
  }

  void _addNode(BuildContext context) {
    if (_title.text.trim().isEmpty || _reference.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('العنوان والمرجع مطلوبان.')),
      );
      return;
    }
    if (!requireLocalCapability(
      context,
      ref,
      capability: ArchiveCapability.evidenceCreateLocalDraft,
      actionLabel: 'إضافة تصنيف محلي',
    )) {
      return;
    }
    ref.read(localOperationalProvider.notifier).addArchiveNode(
          ArchiveRecordNode(
            id: 'NODE-LOCAL-${DateTime.now().millisecondsSinceEpoch}',
            title: _title.text.trim(),
            type: _type,
            reference: _reference.text.trim(),
            parentId: null,
            description: _description.text.trim().isEmpty
                ? 'تصنيف محلي مضاف من واجهة الاستخدام اليومية.'
                : _description.text.trim(),
            unitScopeKey: localDevelopmentUnitKey,
            accessLevel: _accessLevel,
            reviewStatus: _reviewStatus,
            dateLabel: 'تاريخ محلي غير ملزم',
          ),
        );
    setState(() {
      _title.clear();
      _description.clear();
      _reviewStatus = EvidenceReviewStatus.discovered;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تمت إضافة التصنيف داخل الجلسة المحلية.')),
    );
  }
}
