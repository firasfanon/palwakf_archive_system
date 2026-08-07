import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/models.dart';
import '../../core/state/local_operational_store.dart';
import '../../shared/widgets.dart';

class SmartIndexingScreen extends ConsumerWidget {
  const SmartIndexingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(localOperationalProvider);
    final controller = ref.read(localOperationalProvider.notifier);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('الفهرسة الذكية وOCR وكشف التكرار',
            style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        const LocalOnlyBanner(),
        const SizedBox(height: 12),
        const Text(
          'SMART_INDEXING_OPERATIONALIZATION: تشغيل محلي فقط لواجهات OCR والفهرسة الذكية والاقتراحات وكشف التكرار. لا يوجد LLM، لا OCR فعلي، ولا حفظ خارج ذاكرة الجلسة.',
        ),
        const SizedBox(height: 16),
        _IndexJobsSection(
          evidence: state.evidence,
          jobs: state.smartIndexJobs,
          onCreateJob: controller.createSmartIndexJob,
          onCompleteJob: controller.completeSmartIndexJob,
        ),
        const SizedBox(height: 12),
        _DuplicateCandidatesSection(
          candidates: state.duplicateCandidates,
          evidence: state.evidence,
          onConfirm: controller.confirmDuplicateCandidate,
          onDismiss: controller.dismissDuplicateCandidate,
        ),
        const SizedBox(height: 12),
        _SavedSearchesSection(
          searches: state.savedSearches,
          onSave: controller.saveSmartSearch,
        ),
        const SizedBox(height: 12),
        _TaxonomySuggestionsSection(
          suggestions: state.taxonomySuggestions,
          evidence: state.evidence,
          onAccept: controller.acceptTaxonomySuggestion,
        ),
      ],
    );
  }
}

class _IndexJobsSection extends StatefulWidget {
  const _IndexJobsSection({
    required this.evidence,
    required this.jobs,
    required this.onCreateJob,
    required this.onCompleteJob,
  });

  final List<EvidenceItem> evidence;
  final List<SmartIndexJob> jobs;
  final void Function(String evidenceId, String jobType) onCreateJob;
  final ValueChanged<String> onCompleteJob;

  @override
  State<_IndexJobsSection> createState() => _IndexJobsSectionState();
}

class _IndexJobsSectionState extends State<_IndexJobsSection> {
  String? _evidenceId;
  String _jobType = 'OCR + فهرسة كلمات مفتاحية';

  @override
  void didUpdateWidget(covariant _IndexJobsSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_evidenceId != null &&
        !widget.evidence.any((item) => item.id == _evidenceId)) {
      _evidenceId = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final selected = _evidenceId ??
        (widget.evidence.isEmpty ? null : widget.evidence.first.id);
    return SectionCard(
      icon: Icons.auto_awesome_outlined,
      title: 'طابور الفهرسة الذكية المحلي',
      subtitle:
          'OCR_INDEX_QUEUE_LOCAL: إنشاء مهام OCR/فهرسة وهمية داخل الجلسة ثم إكمالها كدليل واجهة فقط.',
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 12,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SizedBox(
              width: 360,
              child: DropdownButtonFormField<String>(
                initialValue: selected,
                decoration: const InputDecoration(labelText: 'الوثيقة'),
                items: [
                  for (final item in widget.evidence)
                    DropdownMenuItem(value: item.id, child: Text(item.title)),
                ],
                onChanged: (value) => setState(() => _evidenceId = value),
              ),
            ),
            SizedBox(
              width: 260,
              child: DropdownButtonFormField<String>(
                initialValue: _jobType,
                decoration: const InputDecoration(labelText: 'نوع الفهرسة'),
                items: const [
                  DropdownMenuItem(
                      value: 'OCR + فهرسة كلمات مفتاحية',
                      child: Text('OCR + كلمات مفتاحية')),
                  DropdownMenuItem(
                      value: 'استخراج جهات وتواريخ',
                      child: Text('استخراج جهات وتواريخ')),
                  DropdownMenuItem(
                      value: 'اقتراح تصنيف أرشيفي',
                      child: Text('اقتراح تصنيف')),
                ],
                onChanged: (value) =>
                    setState(() => _jobType = value ?? _jobType),
              ),
            ),
            FilledButton.icon(
              onPressed: selected == null
                  ? null
                  : () => widget.onCreateJob(selected, _jobType),
              icon: const Icon(Icons.playlist_add_outlined),
              label: const Text('إضافة مهمة فهرسة'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (widget.jobs.isEmpty)
          const EmptyState(message: 'لا توجد مهام فهرسة محلية.')
        else
          for (final job in widget.jobs)
            Card(
              child: ListTile(
                leading: const Icon(Icons.document_scanner_outlined),
                title: Text(job.jobType),
                subtitle: Text(
                    '${job.evidenceId}\n${job.extractedTextPreview}\nالكلمات: ${job.suggestedKeywords.join('، ')}'),
                isThreeLine: true,
                trailing: Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    StatusPill(label: job.status),
                    FilledButton.tonalIcon(
                      onPressed: job.status == 'مكتمل محليًا'
                          ? null
                          : () => widget.onCompleteJob(job.id),
                      icon: const Icon(Icons.task_alt_outlined),
                      label: const Text('إكمال'),
                    ),
                  ],
                ),
              ),
            ),
      ],
    );
  }
}

class _DuplicateCandidatesSection extends StatelessWidget {
  const _DuplicateCandidatesSection({
    required this.candidates,
    required this.evidence,
    required this.onConfirm,
    required this.onDismiss,
  });

  final List<DuplicateCandidate> candidates;
  final List<EvidenceItem> evidence;
  final ValueChanged<String> onConfirm;
  final ValueChanged<String> onDismiss;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      icon: Icons.content_copy_outlined,
      title: 'كشف التكرار والتشابه',
      subtitle:
          'DUPLICATE_DETECTION_LOCAL: لا دمج تلقائي ولا حذف؛ القرار علامة محلية فقط.',
      children: [
        if (candidates.isEmpty)
          const EmptyState(message: 'لا توجد مرشحات تكرار.')
        else
          for (final item in candidates)
            Card(
              child: ListTile(
                leading: const Icon(Icons.compare_arrows_outlined),
                title: Text(
                    '${_titleFor(item.primaryEvidenceId)} ↔ ${_titleFor(item.candidateEvidenceId)}'),
                subtitle: Text('${item.similarityLabel}\n${item.rationale}'),
                isThreeLine: true,
                trailing: Wrap(
                  spacing: 6,
                  children: [
                    StatusPill(label: item.status),
                    OutlinedButton.icon(
                      onPressed: () => onConfirm(item.id),
                      icon: const Icon(Icons.done_outline),
                      label: const Text('تأكيد'),
                    ),
                    OutlinedButton.icon(
                      onPressed: () => onDismiss(item.id),
                      icon: const Icon(Icons.close_outlined),
                      label: const Text('رفض'),
                    ),
                  ],
                ),
              ),
            ),
      ],
    );
  }

  String _titleFor(String id) {
    return evidence
        .firstWhere((item) => item.id == id,
            orElse: () => EvidenceItem(
                  id: id,
                  title: id,
                  domain: EvidenceDomain.general,
                  sourceAuthority: 'غير معروف',
                  reference: id,
                  status: EvidenceReviewStatus.discovered,
                  confidence: 'غير معروف',
                  unitScopeKey: 'LOCAL-DEMO-UNIT',
                  isOriginalAvailableLocally: false,
                  createdAt: DateTime(2026),
                ))
        .title;
  }
}

class _SavedSearchesSection extends StatefulWidget {
  const _SavedSearchesSection({required this.searches, required this.onSave});

  final List<SavedSearch> searches;
  final void Function(String title, String query, String filtersSummary) onSave;

  @override
  State<_SavedSearchesSection> createState() => _SavedSearchesSectionState();
}

class _SavedSearchesSectionState extends State<_SavedSearchesSection> {
  final _title = TextEditingController(text: 'بحث وقف برك سليمان');
  final _query = TextEditingController(text: 'برك سليمان');
  final _filters =
      TextEditingController(text: 'حالة: قيد المراجعة / إتاحة: داخلي');

  @override
  void dispose() {
    _title.dispose();
    _query.dispose();
    _filters.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      icon: Icons.saved_search_outlined,
      title: 'البحوث المحفوظة',
      subtitle:
          'SAVED_SEARCH_LOCAL: حفظ عنوان البحث والفلاتر فقط دون فهرس خارجي أو كتابة بعيدة.',
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            SizedBox(
                width: 260,
                child: TextField(
                    controller: _title,
                    decoration: const InputDecoration(
                        labelText: 'اسم البحث', border: OutlineInputBorder()))),
            SizedBox(
                width: 260,
                child: TextField(
                    controller: _query,
                    decoration: const InputDecoration(
                        labelText: 'عبارة البحث',
                        border: OutlineInputBorder()))),
            SizedBox(
                width: 320,
                child: TextField(
                    controller: _filters,
                    decoration: const InputDecoration(
                        labelText: 'ملخص الفلاتر',
                        border: OutlineInputBorder()))),
            FilledButton.icon(
              onPressed: () =>
                  widget.onSave(_title.text, _query.text, _filters.text),
              icon: const Icon(Icons.bookmark_add_outlined),
              label: const Text('حفظ البحث'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        for (final search in widget.searches)
          ListTile(
            leading: const Icon(Icons.manage_search_outlined),
            title: Text(search.title),
            subtitle: Text('${search.query} — ${search.filtersSummary}'),
            trailing: const StatusPill(label: 'محلي'),
          ),
      ],
    );
  }
}

class _TaxonomySuggestionsSection extends StatelessWidget {
  const _TaxonomySuggestionsSection({
    required this.suggestions,
    required this.evidence,
    required this.onAccept,
  });

  final List<TaxonomySuggestion> suggestions;
  final List<EvidenceItem> evidence;
  final ValueChanged<String> onAccept;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      icon: Icons.account_tree_outlined,
      title: 'اقتراحات التصنيف',
      subtitle:
          'TAXONOMY_SUGGESTION_REVIEW: قبول الاقتراح لا يكتب تلقائيًا في شجرة التصنيف؛ هو قرار محلي قابل للمراجعة.',
      children: [
        for (final suggestion in suggestions)
          Card(
            child: ListTile(
              leading: const Icon(Icons.tips_and_updates_outlined),
              title: Text(suggestion.title),
              subtitle: Text(
                  '${suggestion.suggestedNodeType.label} — ${suggestion.confidence}\nالمصدر: ${_titleFor(suggestion.sourceEvidenceId)}'),
              isThreeLine: true,
              trailing: Wrap(
                spacing: 6,
                children: [
                  StatusPill(label: suggestion.status),
                  FilledButton.tonalIcon(
                    onPressed: suggestion.status == 'مقبول محليًا'
                        ? null
                        : () => onAccept(suggestion.id),
                    icon: const Icon(Icons.check_circle_outline),
                    label: const Text('قبول'),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  String _titleFor(String id) {
    return evidence
        .firstWhere((item) => item.id == id,
            orElse: () => EvidenceItem(
                  id: id,
                  title: id,
                  domain: EvidenceDomain.general,
                  sourceAuthority: 'غير معروف',
                  reference: id,
                  status: EvidenceReviewStatus.discovered,
                  confidence: 'غير معروف',
                  unitScopeKey: 'LOCAL-DEMO-UNIT',
                  isOriginalAvailableLocally: false,
                  createdAt: DateTime(2026),
                ))
        .title;
  }
}
