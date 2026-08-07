import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/models.dart';
import '../../core/state/local_operational_store.dart';
import '../../platform_integration/contracts.dart';
import '../../platform_integration/local_capability_gate.dart';
import '../../shared/widgets.dart';
import 'evidence_detail_screen.dart';
import 'evidence_editor_dialog.dart';

class EvidenceExplorerScreen extends ConsumerStatefulWidget {
  const EvidenceExplorerScreen({super.key});

  @override
  ConsumerState<EvidenceExplorerScreen> createState() =>
      _EvidenceExplorerScreenState();
}

class _EvidenceExplorerScreenState
    extends ConsumerState<EvidenceExplorerScreen> {
  String _query = '';
  EvidenceDomain? _domain;
  EvidenceReviewStatus? _status;
  AccessLevel? _accessLevel;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(localOperationalProvider);
    final filtered = state.evidence.where((item) {
      final normalized = _query.trim().toLowerCase();
      final matchesQuery = normalized.isEmpty ||
          item.title.toLowerCase().contains(normalized) ||
          item.id.toLowerCase().contains(normalized) ||
          item.reference.toLowerCase().contains(normalized) ||
          item.sourceAuthority.toLowerCase().contains(normalized) ||
          (item.linkedWaqfAssetId ?? '').toLowerCase().contains(normalized);
      final matchesDomain = _domain == null || item.domain == _domain;
      final matchesStatus = _status == null || item.status == _status;
      final matchesAccess =
          _accessLevel == null || item.accessLevel == _accessLevel;
      return matchesQuery && matchesDomain && matchesStatus && matchesAccess;
    }).toList(growable: false);

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createEvidence,
        icon: const Icon(Icons.add),
        label: const Text('إضافة وثيقة'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'الوثائق اليومية',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          const LocalOnlyBanner(),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              MetricTile(
                icon: Icons.folder_copy_outlined,
                label: 'إجمالي الوثائق',
                value: '${state.evidence.length}',
              ),
              MetricTile(
                icon: Icons.fact_check_outlined,
                label: 'قيد المراجعة',
                value: '${state.openReviewCount}',
              ),
              MetricTile(
                icon: Icons.verified_outlined,
                label: 'معتمدة داخليًا',
                value: '${state.internalReadyEvidenceCount}',
              ),
              MetricTile(
                icon: Icons.lock_outline,
                label: 'مقيدة الوصول',
                value: '${state.restrictedEvidenceCount}',
              ),
            ],
          ),
          const SizedBox(height: 16),
          SectionCard(
            icon: Icons.tune_outlined,
            title: 'فلاتر الوثائق التشغيلية',
            subtitle:
                'DOCUMENTS_WORKFLOW_OPERATIONALIZATION: فلترة يومية حسب المجال والحالة والإتاحة مع إجراءات محلية.',
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  final search = TextField(
                    onChanged: (value) => setState(() => _query = value),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                      labelText:
                          'بحث بالعنوان أو المعرف أو المرجع أو الأصل الوقفي',
                    ),
                  );
                  final domain = _domainFilter();
                  final status = _statusFilter();
                  final access = _accessFilter();
                  if (constraints.maxWidth < 760) {
                    return Column(
                      children: [
                        search,
                        const SizedBox(height: 12),
                        domain,
                        const SizedBox(height: 12),
                        status,
                        const SizedBox(height: 12),
                        access,
                      ],
                    );
                  }
                  return Column(
                    children: [
                      search,
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(child: domain),
                          const SizedBox(width: 12),
                          Expanded(child: status),
                          const SizedBox(width: 12),
                          Expanded(child: access),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text('النتائج: ${filtered.length} من ${state.evidence.length}'),
          const SizedBox(height: 12),
          if (filtered.isEmpty)
            const EmptyState(message: 'لا توجد وثائق مطابقة.')
          else
            for (final item in filtered) ...[
              _EvidenceCard(item: item),
              const SizedBox(height: 10),
            ],
        ],
      ),
    );
  }

  Widget _domainFilter() {
    return DropdownButtonFormField<EvidenceDomain?>(
      initialValue: _domain,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'الإدارة/المجال',
      ),
      items: [
        const DropdownMenuItem<EvidenceDomain?>(
          value: null,
          child: Text('كل الإدارات/المجالات'),
        ),
        for (final domain in EvidenceDomain.values)
          DropdownMenuItem<EvidenceDomain?>(
            value: domain,
            child: Text(domain.label),
          ),
      ],
      onChanged: (value) => setState(() => _domain = value),
    );
  }

  Widget _statusFilter() {
    return DropdownButtonFormField<EvidenceReviewStatus?>(
      initialValue: _status,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'حالة دورة العمل',
      ),
      items: [
        const DropdownMenuItem<EvidenceReviewStatus?>(
          value: null,
          child: Text('كل الحالات'),
        ),
        for (final status in EvidenceReviewStatus.values)
          DropdownMenuItem<EvidenceReviewStatus?>(
            value: status,
            child: Text(status.label),
          ),
      ],
      onChanged: (value) => setState(() => _status = value),
    );
  }

  Widget _accessFilter() {
    return DropdownButtonFormField<AccessLevel?>(
      initialValue: _accessLevel,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'مستوى الإتاحة',
      ),
      items: [
        const DropdownMenuItem<AccessLevel?>(
          value: null,
          child: Text('كل مستويات الإتاحة'),
        ),
        for (final access in AccessLevel.values)
          DropdownMenuItem<AccessLevel?>(
            value: access,
            child: Text(access.label),
          ),
      ],
      onChanged: (value) => setState(() => _accessLevel = value),
    );
  }

  void _createEvidence() {
    showDialog<void>(
      context: context,
      builder: (context) => EvidenceEditorDialog(
        onSubmit: (item) {
          if (!requireLocalCapability(
            context,
            ref,
            capability: ArchiveCapability.evidenceCreateLocalDraft,
            actionLabel: 'إضافة وثيقة محلية',
          )) {
            return;
          }
          ref.read(localOperationalProvider.notifier).addEvidence(item);
        },
      ),
    );
  }
}

class _EvidenceCard extends ConsumerWidget {
  const _EvidenceCard({required this.item});

  final EvidenceItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final representations = ref
        .watch(localOperationalProvider)
        .representations
        .where((representation) => representation.evidenceId == item.id)
        .length;
    final isQuarantined = item.status == EvidenceReviewStatus.quarantined;

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _openDetail(context),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final content = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      StatusPill(label: item.status.label),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text('${item.id} • ${item.reference}'),
                  const SizedBox(height: 4),
                  Text('المصدر: ${item.sourceAuthority}'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      StatusPill(label: item.domain.label),
                      StatusPill(label: item.accessLevel.label),
                      StatusPill(label: item.spatialStatus.label),
                      StatusPill(label: '$representations تمثيل'),
                      if (item.linkedWaqfAssetId != null)
                        StatusPill(label: item.linkedWaqfAssetId!),
                    ],
                  ),
                ],
              );

              final actions = _EvidenceWorkflowActions(
                item: item,
                isQuarantined: isQuarantined,
                onOpen: () => _openDetail(context),
              );

              if (constraints.maxWidth < 640) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    content,
                    const SizedBox(height: 10),
                    actions,
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: content),
                  const SizedBox(width: 12),
                  actions,
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _openDetail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => EvidenceDetailScreen(itemId: item.id),
      ),
    );
  }
}

class _EvidenceWorkflowActions extends ConsumerWidget {
  const _EvidenceWorkflowActions({
    required this.item,
    required this.isQuarantined,
    required this.onOpen,
  });

  final EvidenceItem item;
  final bool isQuarantined;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // EVIDENCE_WORKFLOW_ACTION_BAR: daily operations actions are session-local.
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      alignment: WrapAlignment.end,
      children: [
        OutlinedButton.icon(
          onPressed: onOpen,
          icon: const Icon(Icons.open_in_new_outlined),
          label: const Text('فتح'),
        ),
        OutlinedButton.icon(
          onPressed: () => _submitForReview(context, ref),
          icon: const Icon(Icons.send_outlined),
          label: const Text('للمراجعة'),
        ),
        FilledButton.tonalIcon(
          onPressed: () => _approve(context, ref),
          icon: const Icon(Icons.verified_outlined),
          label: const Text('اعتماد'),
        ),
        IconButton.outlined(
          tooltip: isQuarantined ? 'استعادة' : 'حجر الوثيقة محليًا',
          icon: Icon(isQuarantined ? Icons.restore : Icons.gpp_maybe_outlined),
          onPressed: () => _toggleQuarantine(context, ref),
        ),
      ],
    );
  }

  void _submitForReview(BuildContext context, WidgetRef ref) {
    if (!requireLocalCapability(
      context,
      ref,
      capability: ArchiveCapability.reviewUpdateLocalDraft,
      actionLabel: 'إرسال وثيقة للمراجعة محليًا',
    )) {
      return;
    }
    ref
        .read(localOperationalProvider.notifier)
        .submitEvidenceForReview(item.id);
    _show(context, 'تم إرسال الوثيقة للمراجعة داخل الجلسة.');
  }

  void _approve(BuildContext context, WidgetRef ref) {
    if (!requireLocalCapability(
      context,
      ref,
      capability: ArchiveCapability.reviewUpdateLocalDraft,
      actionLabel: 'اعتماد وثيقة داخليًا',
    )) {
      return;
    }
    ref
        .read(localOperationalProvider.notifier)
        .approveEvidenceInternally(item.id);
    _show(context, 'تم اعتماد الوثيقة داخليًا داخل الجلسة.');
  }

  void _toggleQuarantine(BuildContext context, WidgetRef ref) {
    final capability = isQuarantined
        ? ArchiveCapability.evidenceUpdateLocalDraft
        : ArchiveCapability.evidenceQuarantineLocalDraft;
    if (!requireLocalCapability(
      context,
      ref,
      capability: capability,
      actionLabel: isQuarantined ? 'استعادة وثيقة محلية' : 'حجر وثيقة محلية',
    )) {
      return;
    }
    final controller = ref.read(localOperationalProvider.notifier);
    if (isQuarantined) {
      controller.restoreEvidence(item.id);
      _show(context, 'تمت استعادة الوثيقة داخل الجلسة.');
    } else {
      controller.quarantineEvidence(item.id);
      _show(context, 'تم حجر الوثيقة داخل الجلسة.');
    }
  }

  void _show(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
