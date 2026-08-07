import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/models.dart';
import '../../core/state/local_operational_store.dart';
import '../../platform_integration/contracts.dart';
import '../../platform_integration/local_capability_gate.dart';
import '../../shared/widgets.dart';
import 'evidence_editor_dialog.dart';

class EvidenceDetailScreen extends ConsumerWidget {
  const EvidenceDetailScreen({
    required this.itemId,
    super.key,
  });

  final String itemId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(localOperationalProvider);
    final item = _findItem(state, itemId);

    if (item == null) {
      return const Scaffold(
        body: EmptyState(message: 'الدليل غير موجود في الجلسة الحالية.'),
      );
    }

    final representations = state.representations
        .where((representation) => representation.evidenceId == itemId)
        .toList(growable: false);
    final textDraftLayers = state.textDraftsForEvidence(itemId);
    final tasks = state.reviewTasks
        .where((task) => task.evidenceId == itemId)
        .toList(growable: false);
    final related = state.relations
        .where(
          (relation) =>
              relation.fromEvidenceId == itemId ||
              relation.toEvidenceId == itemId,
        )
        .toList(growable: false);
    final publications = state.publicationRequests
        .where((request) => request.evidenceId == itemId)
        .toList(growable: false);
    final retentionRules = state.retentionRules
        .where((rule) => rule.evidenceId == itemId)
        .toList(growable: false);
    final auditEntries = state.auditTrail
        .where((entry) => entry.targetId == itemId)
        .toList(growable: false);

    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('تفاصيل الوثيقة'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'نظرة عامة'),
              Tab(text: 'البيانات'),
              Tab(text: 'الملفات'),
              Tab(text: 'المراجعة'),
              Tab(text: 'الإتاحة والتدقيق'),
              Tab(text: 'العلاقات'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _DetailOverviewTab(item: item, representations: representations),
            _MetadataTab(item: item),
            _RepresentationsTab(
              item: item,
              representations: representations,
              textDraftLayers: textDraftLayers,
            ),
            _ReviewTab(item: item, tasks: tasks),
            _AccessAuditTab(
              item: item,
              publications: publications,
              retentionRules: retentionRules,
              auditEntries: auditEntries,
            ),
            _RelationsTab(related: related),
          ],
        ),
      ),
    );
  }

  EvidenceItem? _findItem(LocalOperationalState state, String id) {
    for (final candidate in state.evidence) {
      if (candidate.id == id) return candidate;
    }
    return null;
  }
}

class _DetailOverviewTab extends ConsumerWidget {
  const _DetailOverviewTab({
    required this.item,
    required this.representations,
  });

  final EvidenceItem item;
  final List<ArchiveRepresentation> representations;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // DOCUMENT_DETAIL_OPERATIONAL_TABS
    // DOCUMENT_DETAIL_GOVERNED_TABS: overview + metadata + files + review + access/audit + relations.
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _DocumentInvestigationHero(
            item: item, representationCount: representations.length),
        const SizedBox(height: 12),
        _PremiumInvestigationCommandCenter(
          item: item,
          representationCount: representations.length,
        ),
        const SizedBox(height: 12),
        _EvidenceTimelinePlaceWaqfPanel(item: item),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            StatusPill(label: item.domain.label),
            StatusPill(label: item.status.label),
            StatusPill(label: item.accessLevel.label),
            StatusPill(label: item.spatialStatus.label),
            StatusPill(label: '${representations.length} تمثيل'),
            if (item.linkedWaqfAssetId != null)
              StatusPill(label: item.linkedWaqfAssetId!),
          ],
        ),
        const SizedBox(height: 12),
        _DetailWorkflowActions(item: item),
        const SizedBox(height: 12),
        SectionCard(
          icon: Icons.summarize_outlined,
          title: 'ملخص تشغيلي',
          subtitle:
              'PRODUCTIVE_DOCUMENT_DETAIL_ADD_FLOW_AND_GOVERNED_WORKFLOW: تفاصيل الوثيقة اليومية مرتبطة بإجراءات محكومة وتدقيق محلي.',
          children: [
            KeyValueLine(label: 'المعرف', value: item.id),
            KeyValueLine(label: 'المرجع', value: item.reference),
            KeyValueLine(label: 'الإدارة', value: item.departmentLabel),
            KeyValueLine(label: 'الموضوع', value: item.subjectLabel),
            KeyValueLine(label: 'نوع الوثيقة', value: item.documentType),
            KeyValueLine(label: 'ملاحظة العمل', value: item.workflowNote),
          ],
        ),
      ],
    );
  }
}

class _DocumentInvestigationHero extends StatelessWidget {
  const _DocumentInvestigationHero(
      {required this.item, required this.representationCount});

  final EvidenceItem item;
  final int representationCount;

  @override
  Widget build(BuildContext context) {
    // DOCUMENT_INVESTIGATION_ROOM: document details start with an investigation
    // header that answers catalog, document type, source, trust, and publication state.
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xFF073F31), Color(0xFF2B2118)],
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Chip(label: Text('غرفة تحقيق وثيقة')),
              Chip(label: Text('قراءة غير منشورة')),
              Chip(label: Text('اعتماد بشري إلزامي')),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            item.title,
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(color: Colors.white, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Chip(label: Text(item.catalogTitle)),
              Chip(label: Text(item.documentTypeTabTitle)),
              Chip(label: Text(item.sourceAuthority)),
              Chip(label: Text('${representationCount} تمثيل')),
              Chip(label: Text(item.publicationStatus)),
            ],
          ),
        ],
      ),
    );
  }
}

class _PremiumInvestigationCommandCenter extends StatelessWidget {
  const _PremiumInvestigationCommandCenter(
      {required this.item, required this.representationCount});

  final EvidenceItem item;
  final int representationCount;

  @override
  Widget build(BuildContext context) {
    // DOCUMENT_INVESTIGATION_PREMIUM_UI: the detail page becomes an investigation room, not a record summary.
    // DOCUMENT_INVESTIGATION_COMMAND_CENTER: catalog, source, trust, text layers, place, waqf, and publication posture are visible together.
    final tiles = <({IconData icon, String label, String value})>[
      (
        icon: Icons.menu_book_outlined,
        label: 'الكتالوج',
        value: item.catalogTitle
      ),
      (
        icon: Icons.article_outlined,
        label: 'نوع الوثيقة',
        value: item.documentTypeTabTitle
      ),
      (
        icon: Icons.source_outlined,
        label: 'المصدر',
        value: item.sourceAuthority
      ),
      (
        icon: Icons.verified_user_outlined,
        label: 'الثقة',
        value: item.confidence
      ),
      (
        icon: Icons.file_copy_outlined,
        label: 'التمثيلات',
        value: '$representationCount'
      ),
      (
        icon: Icons.public_off_outlined,
        label: 'النشر',
        value: item.publicationStatus
      ),
    ];
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        for (final tile in tiles)
          SizedBox(
            width: 230,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFE7DCC3)),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: const Color(0xFFF4E9CF),
                    child: Icon(tile.icon, color: const Color(0xFF073F31)),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(tile.label,
                            style: Theme.of(context).textTheme.labelMedium),
                        Text(
                          tile.value,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w900),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _EvidenceTimelinePlaceWaqfPanel extends StatelessWidget {
  const _EvidenceTimelinePlaceWaqfPanel({required this.item});

  final EvidenceItem item;

  @override
  Widget build(BuildContext context) {
    // EVIDENCE_TIMELINE_PLACE_WAQF_PANEL: the investigation room answers time, place, waqf asset, and legal/case context.
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xFFFFFAEF), Color(0xFFF2E4C7)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2CEA0)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final narrow = constraints.maxWidth < 760;
          final timeline = _MiniTimeline(item: item);
          final links = _PlaceWaqfRelationPanel(item: item);
          if (narrow) {
            return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [timeline, const SizedBox(height: 14), links]);
          }
          return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(child: timeline),
            const SizedBox(width: 16),
            Expanded(child: links)
          ]);
        },
      ),
    );
  }
}

class _MiniTimeline extends StatelessWidget {
  const _MiniTimeline({required this.item});

  final EvidenceItem item;

  @override
  Widget build(BuildContext context) {
    final nodes = [
      ('الحقبة', item.dateLabel),
      ('الإدخال', item.intakeMode),
      ('المرحلة', item.draftStage),
      ('النشر', item.publicationStatus),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('خط زمن التحقيق',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w900)),
        const SizedBox(height: 10),
        for (final node in nodes)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                const Icon(Icons.circle, size: 10, color: Color(0xFFC79A35)),
                const SizedBox(width: 8),
                Expanded(
                    child: Text('${node.$1}: ${node.$2}',
                        maxLines: 2, overflow: TextOverflow.ellipsis)),
              ],
            ),
          ),
      ],
    );
  }
}

class _PlaceWaqfRelationPanel extends StatelessWidget {
  const _PlaceWaqfRelationPanel({required this.item});

  final EvidenceItem item;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('المكان والوقف والعلاقات',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w900)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            Chip(
                avatar: const Icon(Icons.map_outlined, size: 18),
                label: Text(item.spatialStatus.label)),
            Chip(
                avatar: const Icon(Icons.account_balance_outlined, size: 18),
                label: Text(item.linkedWaqfAssetId ?? 'وقف غير مربوط')),
            Chip(
                avatar: const Icon(Icons.gavel_outlined, size: 18),
                label: Text(item.linkedCaseId ?? 'قضية غير مربوطة')),
            Chip(
                avatar: const Icon(Icons.lock_outline, size: 18),
                label: Text(item.accessLevel.label)),
          ],
        ),
      ],
    );
  }
}

class _MetadataTab extends ConsumerWidget {
  const _MetadataTab({required this.item});

  final EvidenceItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SectionCard(
          icon: Icons.badge_outlined,
          title: 'بيانات الوثيقة',
          subtitle:
              'DOCUMENT_DETAIL_TABS_VISIBLE: metadata عملية للموظف، لا صفحة حوكمة فقط.',
          children: [
            KeyValueLine(label: 'جهة المصدر', value: item.sourceAuthority),
            KeyValueLine(label: 'الثقة', value: item.confidence),
            KeyValueLine(label: 'التاريخ', value: item.dateLabel),
            KeyValueLine(label: 'الحقوق', value: item.rightsStatus),
            KeyValueLine(label: 'الحساسية', value: item.legalSensitivity),
            KeyValueLine(
              label: 'الكلمات المفتاحية',
              value: item.keywords.isEmpty
                  ? 'غير محددة'
                  : item.keywords.join('، '),
            ),
            KeyValueLine(
              label: 'waqf_asset_id',
              value: item.linkedWaqfAssetId ?? 'غير مربوط',
            ),
            KeyValueLine(
              label: 'case_id',
              value: item.linkedCaseId ?? 'غير مربوط',
            ),
            KeyValueLine(
                label: 'قالب metadata', value: item.metadataTemplateId),
            KeyValueLine(
                label: 'جاهزية القالب', value: item.templateReadinessLabel),
            KeyValueLine(
              label: 'مساعدة الذكاء الصناعي',
              value: item.aiAssistancePlan,
            ),
            const SizedBox(height: 8),
            // CATALOG_TEMPLATE_METADATA_DETAIL: show structured metadata captured by the catalog-aware draft form.
            if (item.structuredMetadata.isNotEmpty) ...[
              Text(
                'حقول القالب المعبأة',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 6),
              for (final entry in item.structuredMetadata.entries)
                KeyValueLine(
                  label: entry.key,
                  value:
                      entry.value.isEmpty ? 'فارغ — مسموح كمسودة' : entry.value,
                ),
            ],
            if (item.missingMetadataWarnings.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'تنبيهات metadata المسودة',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 6),
              for (final warning in item.missingMetadataWarnings)
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: Text(warning),
                  subtitle: const Text(
                      'لا يمنع الإدخال؛ يمنع النشر قبل الاعتماد البشري.'),
                ),
            ],
            const SizedBox(height: 8),
            FilledButton.tonalIcon(
              onPressed: () => _edit(context, ref),
              icon: const Icon(Icons.edit_outlined),
              label: const Text('تعديل metadata محليًا'),
            ),
          ],
        ),
      ],
    );
  }

  void _edit(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (context) => EvidenceEditorDialog(
        existing: item,
        onSubmit: (updated) {
          if (!requireLocalCapability(
            context,
            ref,
            capability: ArchiveCapability.evidenceUpdateLocalDraft,
            actionLabel: 'تعديل بيانات وثيقة محلية',
          )) {
            return;
          }
          ref.read(localOperationalProvider.notifier).updateEvidence(updated);
          ref
              .read(localOperationalProvider.notifier)
              .recordAccessAudit(updated.id, 'تعديل metadata محلي');
        },
      ),
    );
  }
}

class _RepresentationsTab extends StatelessWidget {
  const _RepresentationsTab({
    required this.item,
    required this.representations,
    required this.textDraftLayers,
  });

  final EvidenceItem item;
  final List<ArchiveRepresentation> representations;
  final List<TextDraftLayer> textDraftLayers;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _DocumentViewerRepresentationStack(
          item: item,
          representations: representations,
          textDraftLayers: textDraftLayers,
        ),
        const SizedBox(height: 12),
        SectionCard(
          icon: Icons.file_copy_outlined,
          title: 'الملفات والتمثيلات',
          subtitle:
              'الأصل، OCR، الترجمة، المصغرات، والنسخ المشتقة منفصلة عن metadata.',
          children: [
            if (representations.isEmpty)
              const EmptyState(message: 'لا توجد تمثيلات مرتبطة بهذه الوثيقة.')
            else
              for (final representation in representations)
                Card.filled(
                  child: ListTile(
                    leading: Icon(_iconForRepresentation(representation.type)),
                    title: Text(representation.title),
                    subtitle: Text(
                      '${representation.type.label} • ${representation.format}\n${representation.hashPreview}',
                    ),
                    isThreeLine: true,
                    trailing: StatusPill(label: representation.rightsStatus),
                  ),
                ),
          ],
        ),
        const SizedBox(height: 12),
        SectionCard(
          icon: Icons.article_outlined,
          title: 'طبقات النص المسودة',
          subtitle:
              'CATALOG_TEXT_DRAFTS_ON_DETAIL: OCR والتفريغ والترجمة مسودات مرتبطة بالوثيقة ولا تنشر قبل الاعتماد البشري.',
          children: [
            if (textDraftLayers.isEmpty)
              const EmptyState(
                  message: 'لا توجد طبقات OCR/تفريغ/ترجمة لهذه الوثيقة.')
            else
              for (final layer in textDraftLayers)
                ListTile(
                  leading: Icon(_iconForTextLayer(layer.kind)),
                  title: Text(layer.kind.label),
                  subtitle: Text(
                      '${layer.languageLabel}\n${layer.textPreview}\n${layer.humanReviewPolicy}'),
                  isThreeLine: true,
                  trailing: StatusPill(label: layer.status),
                ),
          ],
        ),
      ],
    );
  }
}

class _DocumentViewerRepresentationStack extends StatelessWidget {
  const _DocumentViewerRepresentationStack(
      {required this.item,
      required this.representations,
      required this.textDraftLayers});

  final EvidenceItem item;
  final List<ArchiveRepresentation> representations;
  final List<TextDraftLayer> textDraftLayers;

  @override
  Widget build(BuildContext context) {
    // DOCUMENT_VIEWER_REPRESENTATION_STACK: document viewer shows original/scan/OCR/transcription/translation as one premium stack.
    // TEXT_LAYER_INVESTIGATION_STACK: text layers are evidence workbenches that remain drafts until reviewed.
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF102F27),
        borderRadius: BorderRadius.circular(22),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final narrow = constraints.maxWidth < 820;
          final viewer = _DocumentViewerMock(item: item);
          final layers = _RepresentationLayerRail(
              representations: representations,
              textDraftLayers: textDraftLayers);
          if (narrow) {
            return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [viewer, const SizedBox(height: 14), layers]);
          }
          return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(child: viewer),
            const SizedBox(width: 16),
            SizedBox(width: 320, child: layers)
          ]);
        },
      ),
    );
  }
}

class _DocumentViewerMock extends StatelessWidget {
  const _DocumentViewerMock({required this.item});

  final EvidenceItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 310,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            colors: [Color(0xFFF8E7B9), Color(0xFFFFFAEF)]),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Text('عارض الوثيقة',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF3A2819))),
          ),
          const Positioned.fill(
            top: 70,
            child: _ManuscriptLines(),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Chip(label: Text(item.publicationStatus)),
          ),
        ],
      ),
    );
  }
}

class _ManuscriptLines extends StatelessWidget {
  const _ManuscriptLines();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var index = 0; index < 7; index++)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Container(
              height: 8,
              width: index.isEven ? double.infinity : 260,
              decoration: BoxDecoration(
                color: const Color(0xFF5B4A30).withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
      ],
    );
  }
}

class _RepresentationLayerRail extends StatelessWidget {
  const _RepresentationLayerRail(
      {required this.representations, required this.textDraftLayers});

  final List<ArchiveRepresentation> representations;
  final List<TextDraftLayer> textDraftLayers;

  @override
  Widget build(BuildContext context) {
    final rows = [
      ('Original / Scan', '${representations.length} تمثيل'),
      (
        'OCR Draft',
        '${textDraftLayers.where((layer) => layer.kind == TextDraftLayerKind.ocr).length}'
      ),
      (
        'Transcription Draft',
        '${textDraftLayers.where((layer) => layer.kind == TextDraftLayerKind.transcription).length}'
      ),
      (
        'Translation Draft',
        '${textDraftLayers.where((layer) => layer.kind == TextDraftLayerKind.translation).length}'
      ),
      ('Reviewed Text', 'ينتظر البشر'),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('سكة الطبقات',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 18)),
        const SizedBox(height: 12),
        for (final row in rows)
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
            ),
            child: Row(
              children: [
                const Icon(Icons.layers_outlined,
                    color: Color(0xFFC79A35), size: 20),
                const SizedBox(width: 8),
                Expanded(
                    child: Text(row.$1,
                        style: const TextStyle(color: Colors.white))),
                Text(row.$2,
                    style: const TextStyle(
                        color: Colors.white70, fontWeight: FontWeight.w800)),
              ],
            ),
          ),
      ],
    );
  }
}

class _ReviewTab extends StatelessWidget {
  const _ReviewTab({
    required this.item,
    required this.tasks,
  });

  final EvidenceItem item;
  final List<ReviewTask> tasks;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _HumanReviewDecisionRail(item: item, taskCount: tasks.length),
        const SizedBox(height: 12),
        _DetailWorkflowActions(item: item),
        const SizedBox(height: 12),
        SectionCard(
          icon: Icons.fact_check_outlined,
          title: 'المراجعات المرتبطة',
          subtitle: 'كل قرار هنا محلي داخل الجلسة ولا يمثل اعتمادًا مركزيًا.',
          children: [
            if (tasks.isEmpty)
              const Text('لا توجد مهام مراجعة لهذه الوثيقة.')
            else
              for (final task in tasks) _ReviewTaskLine(task: task),
          ],
        ),
      ],
    );
  }
}

class _HumanReviewDecisionRail extends StatelessWidget {
  const _HumanReviewDecisionRail({required this.item, required this.taskCount});

  final EvidenceItem item;
  final int taskCount;

  @override
  Widget build(BuildContext context) {
    // HUMAN_REVIEW_DECISION_RAIL: review state is shown as a premium decision rail before actions.
    final steps = [
      ('مسودة', item.draftStage),
      ('Metadata', item.templateReadinessLabel),
      ('مهام مراجعة', '$taskCount'),
      ('قرار نشر', item.publicationStatus),
    ];
    return SectionCard(
      icon: Icons.fact_check_outlined,
      title: 'سكة قرار المراجعة البشرية',
      subtitle:
          'لا تتحول المسودة إلى مادة منشورة عبر OCR أو ترجمة أو اعتماد آلي. القرار البشري هو الحاجز النهائي.',
      children: [
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final step in steps)
              Chip(label: Text('${step.$1}: ${step.$2}')),
          ],
        ),
      ],
    );
  }
}

class _AccessAuditTab extends ConsumerWidget {
  const _AccessAuditTab({
    required this.item,
    required this.publications,
    required this.retentionRules,
    required this.auditEntries,
  });

  final EvidenceItem item;
  final List<PublicationRequest> publications;
  final List<RetentionRule> retentionRules;
  final List<AuditTrailEntry> auditEntries;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SectionCard(
          icon: Icons.policy_outlined,
          title: 'الإتاحة والتدقيق',
          subtitle:
              'WORKFLOW_AUDIT_ON_DOCUMENT_ACTIONS: كل إجراء حساس يسجل أثرًا محليًا دون نشر أو اتصال خارجي.',
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                OutlinedButton.icon(
                  onPressed: () => _requestPublication(context, ref),
                  icon: const Icon(Icons.publish_outlined),
                  label: const Text('طلب إتاحة داخلية'),
                ),
                OutlinedButton.icon(
                  onPressed: () => _recordRead(context, ref),
                  icon: const Icon(Icons.visibility_outlined),
                  label: const Text('تسجيل مشاهدة'),
                ),
                OutlinedButton.icon(
                  onPressed: () => _restrict(context, ref),
                  icon: const Icon(Icons.lock_outline),
                  label: const Text('تقييد الوصول'),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        SectionCard(
          icon: Icons.publish_outlined,
          title: 'طلبات الإتاحة',
          children: [
            if (publications.isEmpty)
              const Text('لا توجد طلبات إتاحة لهذه الوثيقة.')
            else
              for (final request in publications)
                ListTile(
                  leading: const Icon(Icons.publish_outlined),
                  title: Text(request.title),
                  subtitle: Text(request.reason),
                  trailing: StatusPill(label: request.status),
                ),
          ],
        ),
        const SizedBox(height: 12),
        SectionCard(
          icon: Icons.inventory_2_outlined,
          title: 'سياسات الاحتفاظ',
          children: [
            if (retentionRules.isEmpty)
              const Text('لا توجد سياسة احتفاظ مرتبطة بهذه الوثيقة.')
            else
              for (final rule in retentionRules)
                ListTile(
                  leading: const Icon(Icons.inventory_2_outlined),
                  title: Text(rule.title),
                  subtitle:
                      Text('${rule.retentionLabel} • ${rule.reviewDateLabel}'),
                  trailing: StatusPill(label: rule.status),
                ),
          ],
        ),
        const SizedBox(height: 12),
        SectionCard(
          icon: Icons.manage_history_outlined,
          title: 'سجل التدقيق المحلي',
          children: [
            if (auditEntries.isEmpty)
              const Text('لا توجد أحداث تدقيق لهذه الوثيقة بعد.')
            else
              for (final entry in auditEntries)
                ListTile(
                  leading: const Icon(Icons.manage_history_outlined),
                  title: Text(entry.action),
                  subtitle: Text('${entry.actorLabel} • ${entry.outcome}'),
                ),
          ],
        ),
      ],
    );
  }

  void _requestPublication(BuildContext context, WidgetRef ref) {
    if (!requireLocalCapability(
      context,
      ref,
      capability: ArchiveCapability.reviewUpdateLocalDraft,
      actionLabel: 'طلب إتاحة وثيقة',
    )) {
      return;
    }
    ref
        .read(localOperationalProvider.notifier)
        .requestPublicationReview(item.id);
    _show(context, 'تم إنشاء طلب إتاحة محلي.');
  }

  void _recordRead(BuildContext context, WidgetRef ref) {
    ref.read(localOperationalProvider.notifier).recordAccessAudit(
          item.id,
          'مشاهدة تفاصيل وثيقة',
        );
    _show(context, 'تم تسجيل مشاهدة الوثيقة محليًا.');
  }

  void _restrict(BuildContext context, WidgetRef ref) {
    if (!requireLocalCapability(
      context,
      ref,
      capability: ArchiveCapability.evidenceQuarantineLocalDraft,
      actionLabel: 'تقييد وصول وثيقة',
    )) {
      return;
    }
    ref
        .read(localOperationalProvider.notifier)
        .updateEvidenceStatus(item.id, EvidenceReviewStatus.quarantined);
    ref.read(localOperationalProvider.notifier).recordAccessAudit(
          item.id,
          'تقييد وصول وثيقة',
        );
    _show(context, 'تم تقييد الوثيقة محليًا.');
  }

  void _show(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}

class _RelationsTab extends StatelessWidget {
  const _RelationsTab({required this.related});

  final List<EvidenceRelation> related;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _RelationshipContextGraph(related: related),
        const SizedBox(height: 12),
        SectionCard(
          icon: Icons.hub_outlined,
          title: 'العلاقات المرشحة',
          children: [
            if (related.isEmpty)
              const Text('لا توجد علاقات مرشحة لهذه الوثيقة.')
            else
              for (final relation in related)
                ListTile(
                  leading: const Icon(Icons.hub_outlined),
                  title: Text(relation.type.label),
                  subtitle: Text(
                    '${relation.fromEvidenceId} → ${relation.toEvidenceId}\n${relation.rationale}',
                  ),
                  isThreeLine: true,
                  trailing: StatusPill(label: relation.confidence),
                ),
          ],
        ),
      ],
    );
  }
}

class _RelationshipContextGraph extends StatelessWidget {
  const _RelationshipContextGraph({required this.related});

  final List<EvidenceRelation> related;

  @override
  Widget build(BuildContext context) {
    // RELATIONSHIP_CONTEXT_GRAPH: relationships are presented as a context graph for place, waqf, case, and source derivation.
    final count = related.length;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE7DCC3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('خريطة سياق العلاقات',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w900)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Chip(
                  avatar: const Icon(Icons.hub_outlined, size: 18),
                  label: Text('$count علاقة مرشحة')),
              const Chip(
                  avatar: Icon(Icons.map_outlined, size: 18),
                  label: Text('مكان')),
              const Chip(
                  avatar: Icon(Icons.account_balance_outlined, size: 18),
                  label: Text('وقف')),
              const Chip(
                  avatar: Icon(Icons.gavel_outlined, size: 18),
                  label: Text('قضية')),
              const Chip(
                  avatar: Icon(Icons.source_outlined, size: 18),
                  label: Text('مصدر')),
            ],
          ),
        ],
      ),
    );
  }
}

class _DetailWorkflowActions extends ConsumerWidget {
  const _DetailWorkflowActions({required this.item});

  final EvidenceItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SectionCard(
      icon: Icons.route_outlined,
      title: 'إجراءات دورة العمل',
      subtitle:
          'إرسال، اعتماد، حجر، إرجاع — كلها عمليات session-local مع أثر تدقيق.',
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            OutlinedButton.icon(
              onPressed: () => _submit(context, ref),
              icon: const Icon(Icons.send_outlined),
              label: const Text('إرسال للمراجعة'),
            ),
            FilledButton.tonalIcon(
              onPressed: () => _approve(context, ref),
              icon: const Icon(Icons.verified_outlined),
              label: const Text('اعتماد داخلي'),
            ),
            OutlinedButton.icon(
              onPressed: () => _returnForCorrection(context, ref),
              icon: const Icon(Icons.undo_outlined),
              label: const Text('إرجاع للتصحيح'),
            ),
            OutlinedButton.icon(
              onPressed: () => _quarantine(context, ref),
              icon: const Icon(Icons.gpp_maybe_outlined),
              label: const Text('حجر'),
            ),
          ],
        ),
      ],
    );
  }

  void _submit(BuildContext context, WidgetRef ref) {
    if (!requireLocalCapability(
      context,
      ref,
      capability: ArchiveCapability.reviewUpdateLocalDraft,
      actionLabel: 'إرسال وثيقة للمراجعة',
    )) {
      return;
    }
    final controller = ref.read(localOperationalProvider.notifier);
    controller.submitEvidenceForReview(item.id);
    controller.recordAccessAudit(item.id, 'إرسال للمراجعة');
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
    final controller = ref.read(localOperationalProvider.notifier);
    controller.approveEvidenceInternally(item.id);
    controller.recordAccessAudit(item.id, 'اعتماد داخلي');
    _show(context, 'تم اعتماد الوثيقة داخليًا.');
  }

  void _returnForCorrection(BuildContext context, WidgetRef ref) {
    if (!requireLocalCapability(
      context,
      ref,
      capability: ArchiveCapability.evidenceUpdateLocalDraft,
      actionLabel: 'إرجاع وثيقة للتصحيح',
    )) {
      return;
    }
    final controller = ref.read(localOperationalProvider.notifier);
    controller.updateEvidenceStatus(item.id, EvidenceReviewStatus.discovered);
    controller.recordAccessAudit(item.id, 'إرجاع للتصحيح');
    _show(context, 'تمت إعادة الوثيقة إلى حالة التصحيح/المسودة.');
  }

  void _quarantine(BuildContext context, WidgetRef ref) {
    if (!requireLocalCapability(
      context,
      ref,
      capability: ArchiveCapability.evidenceQuarantineLocalDraft,
      actionLabel: 'حجر وثيقة',
    )) {
      return;
    }
    final controller = ref.read(localOperationalProvider.notifier);
    controller.quarantineEvidence(item.id);
    controller.recordAccessAudit(item.id, 'حجر وثيقة');
    _show(context, 'تم حجر الوثيقة داخل الجلسة المحلية.');
  }

  void _show(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}

class _ReviewTaskLine extends ConsumerWidget {
  const _ReviewTaskLine({required this.task});

  final ReviewTask task;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: const Icon(Icons.fact_check_outlined),
      title: Text(task.title),
      subtitle: Text('${task.assignedRole} • ${task.priority}'),
      trailing: Wrap(
        spacing: 6,
        children: [
          StatusPill(label: task.state.label),
          PopupMenuButton<ReviewTaskState>(
            tooltip: 'تغيير حالة المهمة',
            onSelected: (state) {
              if (!requireLocalCapability(
                context,
                ref,
                capability: ArchiveCapability.reviewUpdateLocalDraft,
                actionLabel: 'تحديث مهمة مراجعة',
              )) {
                return;
              }
              ref.read(localOperationalProvider.notifier).updateReviewTask(
                    task.id,
                    state,
                  );
            },
            itemBuilder: (context) => [
              for (final state in ReviewTaskState.values)
                PopupMenuItem(value: state, child: Text(state.label)),
            ],
          ),
        ],
      ),
    );
  }
}

IconData _iconForTextLayer(TextDraftLayerKind kind) {
  switch (kind) {
    case TextDraftLayerKind.ocr:
      return Icons.document_scanner_outlined;
    case TextDraftLayerKind.transcription:
      return Icons.edit_note_outlined;
    case TextDraftLayerKind.translation:
      return Icons.translate_outlined;
  }
}

IconData _iconForRepresentation(RepresentationType type) {
  switch (type) {
    case RepresentationType.original:
      return Icons.source_outlined;
    case RepresentationType.scan:
      return Icons.scanner_outlined;
    case RepresentationType.ocr:
      return Icons.text_snippet_outlined;
    case RepresentationType.transcription:
      return Icons.notes_outlined;
    case RepresentationType.translation:
      return Icons.translate_outlined;
    case RepresentationType.summary:
      return Icons.summarize_outlined;
    case RepresentationType.thumbnail:
      return Icons.image_outlined;
    case RepresentationType.georeferencedImage:
      return Icons.map_outlined;
    case RepresentationType.vectorLayer:
      return Icons.layers_outlined;
  }
}
