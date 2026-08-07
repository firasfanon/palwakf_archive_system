import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/models.dart';
import '../../core/state/local_operational_store.dart';
import '../../platform_integration/contracts.dart';
import '../../platform_integration/local_capability_gate.dart';
import '../../shared/widgets.dart';

class ReviewQueueScreen extends ConsumerStatefulWidget {
  const ReviewQueueScreen({super.key});

  @override
  ConsumerState<ReviewQueueScreen> createState() => _ReviewQueueScreenState();
}

class _ReviewQueueScreenState extends ConsumerState<ReviewQueueScreen> {
  ReviewTaskState? _stateFilter;
  EvidenceDomain? _domainFilter;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(localOperationalProvider);
    final tasks = state.reviewTasks.where((task) {
      final matchesState = _stateFilter == null || task.state == _stateFilter;
      final matchesDomain =
          _domainFilter == null || task.domain == _domainFilter;
      return matchesState && matchesDomain;
    }).toList(growable: false);

    final textDrafts = state.textDraftLayers;
    final pendingTextDrafts = textDrafts
        .where((layer) =>
            layer.status.contains('غير معتمدة') ||
            layer.status.contains('مراجعة بشرية'))
        .toList(growable: false);

    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        // REVIEW_STUDIO_R3_APPLY_GUARD_AND_LEGACY_TEST_REPAIR + REVIEW_STUDIO_APPLY_GUARD_REPAIR + REVIEW_QUEUE_LEGACY_MARKER_RETENTION + REVIEW_QUEUE_WORKFLOW_ACTIONS: preserved legacy workflow action marker for documents workflow contract.
        // REVIEW_WORKFLOW_HUMAN_APPROVAL_STUDIO: the review page is now a human approval studio, not a plain task list.
        _ReviewStudioHero(
          openTaskCount: state.openReviewCount,
          pendingTextDraftCount: pendingTextDrafts.length,
          blockedPublicationCount:
              state.publicationBlockedUntilHumanApprovalCount,
          internalReadyCount: state.internalReadyEvidenceCount,
        ),
        const SizedBox(height: 14),
        const LocalOnlyBanner(),
        const SizedBox(height: 16),
        _ReviewMetricsStrip(state: state),
        const SizedBox(height: 16),
        _DecisionPipelineRail(state: state),
        const SizedBox(height: 16),
        _ReviewFilters(
          stateFilter: _stateFilter,
          domainFilter: _domainFilter,
          onStateChanged: (value) => setState(() => _stateFilter = value),
          onDomainChanged: (value) => setState(() => _domainFilter = value),
        ),
        const SizedBox(height: 16),
        _TextLayerComparisonStudio(layers: textDrafts),
        const SizedBox(height: 16),
        _HumanApprovalQueue(tasks: tasks),
        const SizedBox(height: 16),
        _ReviewAuditTrailPanel(state: state),
      ],
    );
  }
}

class _ReviewStudioHero extends StatelessWidget {
  const _ReviewStudioHero({
    required this.openTaskCount,
    required this.pendingTextDraftCount,
    required this.blockedPublicationCount,
    required this.internalReadyCount,
  });

  final int openTaskCount;
  final int pendingTextDraftCount;
  final int blockedPublicationCount;
  final int internalReadyCount;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      // HUMAN_APPROVAL_DECISION_STUDIO + APPROVAL_BLOCKS_PUBLICATION_UNTIL_HUMAN_DECISION.
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          colors: [Color(0xFF073F31), Color(0xFF2B2118)],
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 24,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Stack(
        children: [
          PositionedDirectional(
            start: -40,
            top: -50,
            child: Icon(
              Icons.verified_user_outlined,
              size: 220,
              color: Colors.white.withValues(alpha: 0.045),
            ),
          ),
          PositionedDirectional(
            end: 24,
            bottom: 18,
            child: Icon(
              Icons.fact_check_outlined,
              size: 110,
              color: const Color(0xFFC79A35).withValues(alpha: 0.18),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final compact = constraints.maxWidth < 740;
                final titleBlock = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Chip(
                      avatar: const Icon(Icons.shield_outlined, size: 18),
                      label: const Text(
                          'استوديو مراجعة بشرية • لا نشر قبل الاعتماد'),
                      backgroundColor:
                          colorScheme.secondary.withValues(alpha: 0.22),
                      side: BorderSide(
                          color: colorScheme.secondary.withValues(alpha: 0.38)),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'استوديو المراجعة والاعتماد',
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                              ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'مركز قرار إنساني يقارن الوثيقة والتمثيلات وطبقات OCR/التفريغ/الترجمة، ثم يحدد: اعتماد داخلي، إرجاع للتصحيح، أو حجب النشر.',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white.withValues(alpha: 0.86),
                            height: 1.65,
                          ),
                    ),
                  ],
                );
                final metrics = Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _HeroMetric(label: 'مهام مفتوحة', value: '$openTaskCount'),
                    _HeroMetric(
                        label: 'طبقات نصية للتدقيق',
                        value: '$pendingTextDraftCount'),
                    _HeroMetric(
                        label: 'نشر محجوب', value: '$blockedPublicationCount'),
                    _HeroMetric(
                        label: 'جاهز داخليًا', value: '$internalReadyCount'),
                  ],
                );

                if (compact) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [titleBlock, const SizedBox(height: 18), metrics],
                  );
                }
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(child: titleBlock),
                    const SizedBox(width: 18),
                    SizedBox(width: 340, child: metrics),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroMetric extends StatelessWidget {
  const _HeroMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 155,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 4),
          Text(label,
              style: TextStyle(color: Colors.white.withValues(alpha: 0.78))),
        ],
      ),
    );
  }
}

class _ReviewMetricsStrip extends StatelessWidget {
  const _ReviewMetricsStrip({required this.state});

  final LocalOperationalState state;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        MetricTile(
          icon: Icons.inbox_outlined,
          label: 'مهام مفتوحة',
          value: '${state.openReviewCount}',
        ),
        MetricTile(
          icon: Icons.article_outlined,
          label: 'طبقات نصية',
          value: '${state.textDraftLayerCount}',
        ),
        MetricTile(
          icon: Icons.rate_review_outlined,
          label: 'تحتاج مراجعة بشرية',
          value: '${state.humanReviewPendingTextDraftCount}',
        ),
        MetricTile(
          icon: Icons.block_outlined,
          label: 'منع نشر قبل الاعتماد',
          value: '${state.publicationBlockedUntilHumanApprovalCount}',
        ),
      ],
    );
  }
}

class _DecisionPipelineRail extends StatelessWidget {
  const _DecisionPipelineRail({required this.state});

  final LocalOperationalState state;

  @override
  Widget build(BuildContext context) {
    final steps = [
      (
        'مصدر/تمثيل',
        Icons.file_present_outlined,
        '${state.representations.length}'
      ),
      ('OCR', Icons.document_scanner_outlined, '${state.ocrDraftLayerCount}'),
      (
        'تفريغ',
        Icons.edit_note_outlined,
        '${state.transcriptionDraftLayerCount}'
      ),
      (
        'ترجمة',
        Icons.translate_outlined,
        '${state.translationDraftLayerCount}'
      ),
      ('قرار بشري', Icons.verified_user_outlined, '${state.openReviewCount}'),
      (
        'حجب النشر',
        Icons.lock_outline,
        '${state.publicationBlockedUntilHumanApprovalCount}'
      ),
    ];

    return SectionCard(
      icon: Icons.account_tree_outlined,
      title: 'سكة القرار البشري',
      subtitle:
          'HUMAN_REVIEW_DECISION_ACTIONS: لا تنتقل أي طبقة نصية أو وثيقة إلى الإتاحة قبل مراجعة بشرية واعتماد داخلي محكوم.',
      children: [
        // REVIEW_CONFIDENCE_LAYER_STATUS + NO_PUBLICATION_FROM_REVIEW_STUDIO.
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (var i = 0; i < steps.length; i++)
              _DecisionStep(
                index: i + 1,
                label: steps[i].$1,
                icon: steps[i].$2,
                value: steps[i].$3,
              ),
          ],
        ),
      ],
    );
  }
}

class _DecisionStep extends StatelessWidget {
  const _DecisionStep({
    required this.index,
    required this.label,
    required this.icon,
    required this.value,
  });

  final int index;
  final String label;
  final IconData icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: 170,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border:
            Border.all(color: colorScheme.secondary.withValues(alpha: 0.20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: colorScheme.primary.withValues(alpha: 0.12),
                child: Text('$index',
                    style: TextStyle(color: colorScheme.primary)),
              ),
              const SizedBox(width: 8),
              Icon(icon, color: colorScheme.primary),
            ],
          ),
          const SizedBox(height: 10),
          Text(label, style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 4),
          Text(value, style: Theme.of(context).textTheme.headlineSmall),
        ],
      ),
    );
  }
}

class _ReviewFilters extends StatelessWidget {
  const _ReviewFilters({
    required this.stateFilter,
    required this.domainFilter,
    required this.onStateChanged,
    required this.onDomainChanged,
  });

  final ReviewTaskState? stateFilter;
  final EvidenceDomain? domainFilter;
  final ValueChanged<ReviewTaskState?> onStateChanged;
  final ValueChanged<EvidenceDomain?> onDomainChanged;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      icon: Icons.tune_outlined,
      title: 'فلترة استوديو الاعتماد',
      subtitle:
          'REVIEW_WORKFLOW_HUMAN_APPROVAL_STUDIO: الفلترة مخصصة لمهام الاعتماد، لا لقائمة إدارية عامة.',
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            SizedBox(
              width: 260,
              child: DropdownButtonFormField<ReviewTaskState?>(
                initialValue: stateFilter,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'حالة القرار',
                ),
                items: [
                  const DropdownMenuItem<ReviewTaskState?>(
                    value: null,
                    child: Text('كل الحالات'),
                  ),
                  for (final value in ReviewTaskState.values)
                    DropdownMenuItem<ReviewTaskState?>(
                      value: value,
                      child: Text(value.label),
                    ),
                ],
                onChanged: onStateChanged,
              ),
            ),
            SizedBox(
              width: 260,
              child: DropdownButtonFormField<EvidenceDomain?>(
                initialValue: domainFilter,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: 'مجال الوثيقة'),
                items: [
                  const DropdownMenuItem<EvidenceDomain?>(
                    value: null,
                    child: Text('كل المجالات'),
                  ),
                  for (final value in EvidenceDomain.values)
                    DropdownMenuItem<EvidenceDomain?>(
                      value: value,
                      child: Text(value.label),
                    ),
                ],
                onChanged: onDomainChanged,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _TextLayerComparisonStudio extends ConsumerWidget {
  const _TextLayerComparisonStudio({required this.layers});

  final List<TextDraftLayer> layers;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visibleLayers = layers.take(6).toList(growable: false);
    return SectionCard(
      icon: Icons.compare_outlined,
      title: 'مقارنة OCR / التفريغ / الترجمة',
      subtitle:
          'TEXT_LAYER_COMPARISON_FOR_REVIEW + OCR_TRANSCRIPTION_TRANSLATION_REVIEW_COLUMNS: المقارنة داخلية وتحتاج قرارًا بشريًا قبل الاعتماد.',
      children: [
        if (visibleLayers.isEmpty)
          const EmptyState(message: 'لا توجد طبقات نصية مسودة للمقارنة.')
        else
          LayoutBuilder(
            builder: (context, constraints) {
              final cardWidth = constraints.maxWidth < 760
                  ? constraints.maxWidth
                  : (constraints.maxWidth - 24) / 3;
              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  for (final layer in visibleLayers)
                    SizedBox(
                      width: cardWidth.clamp(260, 420).toDouble(),
                      child: _TextLayerReviewCard(layer: layer),
                    ),
                ],
              );
            },
          ),
      ],
    );
  }
}

class _TextLayerReviewCard extends ConsumerWidget {
  const _TextLayerReviewCard({required this.layer});

  final TextDraftLayer layer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(layer.kind == TextDraftLayerKind.translation
                  ? Icons.translate_outlined
                  : layer.kind == TextDraftLayerKind.ocr
                      ? Icons.document_scanner_outlined
                      : Icons.edit_note_outlined),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  layer.kind.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              StatusPill(label: layer.languageLabel),
              StatusPill(label: 'ثقة: مسودة'),
              StatusPill(label: 'غير منشور'),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            layer.textPreview,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          for (final warning in layer.qualityWarnings.take(2))
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_outlined, size: 16),
                  const SizedBox(width: 6),
                  Expanded(
                      child: Text(warning,
                          maxLines: 1, overflow: TextOverflow.ellipsis)),
                ],
              ),
            ),
          const SizedBox(height: 10),
          FilledButton.tonalIcon(
            onPressed: () => _markReviewed(context, ref),
            icon: const Icon(Icons.rate_review_outlined),
            label: const Text('وسم كمراجع داخليًا'),
          ),
        ],
      ),
    );
  }

  void _markReviewed(BuildContext context, WidgetRef ref) {
    if (!requireLocalCapability(
      context,
      ref,
      capability: ArchiveCapability.reviewUpdateLocalDraft,
      actionLabel: 'وسم طبقة نصية كمراجعة داخليًا',
    )) {
      return;
    }
    ref
        .read(localOperationalProvider.notifier)
        .markTextDraftLayerReviewed(layer.id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم وسم الطبقة كمراجعة داخلية دون نشر.')),
    );
  }
}

class _HumanApprovalQueue extends StatelessWidget {
  const _HumanApprovalQueue({required this.tasks});

  final List<ReviewTask> tasks;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      icon: Icons.fact_check_outlined,
      title: 'لوحة قرارات الاعتماد',
      subtitle:
          'REVIEW_TASK_PREMIUM_BOARD + REVIEW_RETURN_CORRECTION_FLOW: قبول داخلي أو إرجاع للتصحيح فقط؛ لا توجد إتاحة عامة من هذه الصفحة.',
      children: [
        if (tasks.isEmpty)
          const EmptyState(message: 'لا توجد مهام مراجعة مطابقة.')
        else
          for (final task in tasks) ...[
            _PremiumReviewTaskCard(task: task),
            const SizedBox(height: 10),
          ],
      ],
    );
  }
}

class _PremiumReviewTaskCard extends ConsumerWidget {
  const _PremiumReviewTaskCard({required this.task});

  final ReviewTask task;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(localOperationalProvider);
    EvidenceItem? evidence;
    for (final item in state.evidence) {
      if (item.id == task.evidenceId) {
        evidence = item;
        break;
      }
    }
    final layers = state.textDraftsForEvidence(task.evidenceId);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final detail = _TaskDecisionDetail(
                task: task, evidence: evidence, layers: layers);
            final actions = _ReviewActionBar(task: task);
            if (constraints.maxWidth < 760) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [detail, const SizedBox(height: 12), actions],
              );
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.verified_user_outlined),
                ),
                const SizedBox(width: 12),
                Expanded(child: detail),
                const SizedBox(width: 12),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 300),
                  child: actions,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _TaskDecisionDetail extends StatelessWidget {
  const _TaskDecisionDetail({
    required this.task,
    required this.evidence,
    required this.layers,
  });

  final ReviewTask task;
  final EvidenceItem? evidence;
  final List<TextDraftLayer> layers;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(task.title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 6),
        Text('${task.id} • الوثيقة: ${task.evidenceId}'),
        if (evidence != null) ...[
          Text('العنوان: ${evidence!.title}'),
          Text(
              'الكتالوج: ${evidence!.catalogTitle} • النوع: ${evidence!.documentTypeTabTitle}'),
        ],
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            StatusPill(label: task.priority),
            StatusPill(label: task.state.label),
            StatusPill(label: task.domain.label),
            if (evidence != null) StatusPill(label: evidence!.status.label),
            StatusPill(label: 'طبقات نصية: ${layers.length}'),
            const StatusPill(label: 'نشر محجوب حتى قرار بشري'),
          ],
        ),
      ],
    );
  }
}

class _ReviewActionBar extends ConsumerWidget {
  const _ReviewActionBar({required this.task});

  final ReviewTask task;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      alignment: WrapAlignment.end,
      children: [
        OutlinedButton.icon(
          onPressed: () => _update(context, ref, ReviewTaskState.inProgress),
          icon: const Icon(Icons.play_arrow_outlined),
          label: const Text('بدء التدقيق'),
        ),
        OutlinedButton.icon(
          onPressed: () => _return(context, ref),
          icon: const Icon(Icons.undo_outlined),
          label: const Text('إرجاع للتصحيح'),
        ),
        FilledButton.tonalIcon(
          onPressed: () => _complete(context, ref),
          icon: const Icon(Icons.verified_outlined),
          label: const Text('اعتماد داخلي'),
        ),
        PopupMenuButton<ReviewTaskState>(
          tooltip: 'تحديث الحالة',
          onSelected: (value) => _update(context, ref, value),
          itemBuilder: (context) => [
            for (final value in ReviewTaskState.values)
              PopupMenuItem(value: value, child: Text(value.label)),
          ],
        ),
      ],
    );
  }

  void _update(BuildContext context, WidgetRef ref, ReviewTaskState state) {
    if (!_authorize(context, ref, 'تحديث مهمة مراجعة محلية')) {
      return;
    }
    ref
        .read(localOperationalProvider.notifier)
        .updateReviewTask(task.id, state);
    _show(context, 'تم تحديث المهمة داخل الجلسة المحلية.');
  }

  void _return(BuildContext context, WidgetRef ref) {
    if (!_authorize(context, ref, 'إرجاع وثيقة للتصحيح')) {
      return;
    }
    ref
        .read(localOperationalProvider.notifier)
        .returnReviewTaskForCorrection(task.id);
    _show(context, 'تم إرجاع الوثيقة للتصحيح داخل الجلسة.');
  }

  void _complete(BuildContext context, WidgetRef ref) {
    if (!_authorize(context, ref, 'إكمال مراجعة واعتماد داخلي')) {
      return;
    }
    ref
        .read(localOperationalProvider.notifier)
        .completeReviewTaskAndApprove(task.id);
    _show(context, 'اكتملت المراجعة واعتمدت الوثيقة داخليًا دون نشر عام.');
  }

  bool _authorize(BuildContext context, WidgetRef ref, String actionLabel) {
    return requireLocalCapability(
      context,
      ref,
      capability: ArchiveCapability.reviewUpdateLocalDraft,
      actionLabel: actionLabel,
    );
  }

  void _show(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}

class _ReviewAuditTrailPanel extends StatelessWidget {
  const _ReviewAuditTrailPanel({required this.state});

  final LocalOperationalState state;

  @override
  Widget build(BuildContext context) {
    final recentAudit = state.auditTrail.take(4).toList(growable: false);
    return SectionCard(
      icon: Icons.manage_history_outlined,
      title: 'سجل قرار المراجعة',
      subtitle:
          'REVIEW_AUDIT_TRAIL_PANEL: كل قرار مراجعة محلي يترك أثرًا في سجل التدقيق ولا يكتب إلى قاعدة أو منصة خارجية.',
      children: [
        if (recentAudit.isEmpty)
          const EmptyState(message: 'لا توجد أحداث مراجعة بعد.')
        else
          for (final item in recentAudit)
            ListTile(
              leading: const Icon(Icons.history_outlined),
              title: Text(item.action),
              subtitle: Text('${item.targetId} • ${item.outcome}'),
              trailing: Text(item.actorLabel),
            ),
      ],
    );
  }
}
