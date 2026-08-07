// UPLOAD_QUEUE_TEST_CONTRACT_R3
// REPRESENTATION_MANAGER_REFINEMENT
// وسم كمراجع محليًا
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/models.dart';
import '../../core/state/local_operational_store.dart';
import '../../shared/widgets.dart';

// REPRESENTATION_MANAGER_REFINEMENT: overview of local queue, preview state,
// rights, hash, and original-protection rules without File Center integration.
class RepresentationsScreen extends ConsumerWidget {
  const RepresentationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(localOperationalProvider);
    final titles = {for (final item in state.evidence) item.id: item.title};
    final grouped = <String, List<ArchiveRepresentation>>{};
    for (final representation in state.representations) {
      grouped
          .putIfAbsent(representation.evidenceId, () => [])
          .add(representation);
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('التمثيلات والملفات',
            style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        const LocalOnlyBanner(),
        const SizedBox(height: 12),
        const Text(
          'إدارة إنتاجية للتمثيلات المحلية: أصل، scan، OCR، ترجمة، ملخص، مصغر، وصورة مسندة. هذه الشاشة لا تعرض مسارات ملفات ولا ترفع إلى File Center.',
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _SummaryCard(
                label: 'كل التمثيلات',
                value: '${state.representations.length}'),
            _SummaryCard(
                label: 'الأصول', value: '${state.originalRepresentationCount}'),
            _SummaryCard(
                label: 'في طابور الرفع',
                value: '${state.queuedRepresentationCount}'),
            _SummaryCard(
                label: 'مراجع محليًا',
                value: '${state.reviewedRepresentationCount}'),
          ],
        ),
        const SizedBox(height: 16),
        for (final entry in grouped.entries) ...[
          SectionCard(
            icon: Icons.folder_copy_outlined,
            title: titles[entry.key] ?? entry.key,
            subtitle: '${entry.value.length} تمثيل مرتبط بهذه الوثيقة',
            children: [
              for (final representation in entry.value)
                _RepresentationCard(representation: representation),
            ],
          ),
          const SizedBox(height: 12),
        ],
        const SectionCard(
          icon: Icons.lock_outline,
          title: 'قاعدة الحفظ والتمثيلات',
          children: [
            Text('الأصل لا يستبدل دون version event وAudit مركزي عند الإدماج.'),
            SizedBox(height: 6),
            Text(
                'OCR والترجمة والملخص مخرجات مشتقة قابلة لإعادة البناء، وليست بديلًا عن الأصل.'),
            SizedBox(height: 6),
            Text(
                'Hash المعاينة محلي فقط ولا يمثل إثبات حفظ في storage bucket.'),
          ],
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 170,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: Theme.of(context).textTheme.labelMedium),
              const SizedBox(height: 6),
              Text(
                value,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RepresentationCard extends ConsumerWidget {
  const _RepresentationCard({required this.representation});

  final ArchiveRepresentation representation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  representation.isAuthoritativeOriginal
                      ? Icons.verified_outlined
                      : Icons.file_copy_outlined,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    representation.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                StatusPill(label: representation.type.label),
              ],
            ),
            const SizedBox(height: 10),
            KeyValueLine(label: 'الصيغة', value: representation.format),
            KeyValueLine(label: 'الحجم', value: representation.fileSizeLabel),
            KeyValueLine(label: 'Hash', value: representation.hashPreview),
            KeyValueLine(label: 'الحقوق', value: representation.rightsStatus),
            KeyValueLine(label: 'الحالة', value: representation.uploadStatus),
            KeyValueLine(label: 'المعاينة', value: representation.previewNote),
            const SizedBox(height: 8),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: OutlinedButton.icon(
                onPressed: representation.uploadStatus.contains('مراجع')
                    ? null
                    : () => ref
                        .read(localOperationalProvider.notifier)
                        .markRepresentationReviewed(representation.id),
                icon: const Icon(Icons.fact_check_outlined),
                label: const Text('وسم كمراجع محليًا'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
