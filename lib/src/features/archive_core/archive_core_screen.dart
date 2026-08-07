import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/models.dart';
import '../../core/state/local_operational_store.dart';
import '../../platform_integration/contracts.dart';
import '../../shared/widgets.dart';

class ArchiveCoreScreen extends ConsumerWidget {
  const ArchiveCoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nodes = ref.watch(localOperationalProvider).archiveNodes;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('قلب الأرشيف', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        const LocalOnlyBanner(),
        const SizedBox(height: 12),
        const Text(
          'التسلسل المعتمد للإنتاج المحلي: Fonds → Series → File → Item. هذا التسلسل لا ينشئ جداول ولا يرفع ملفات.',
        ),
        const SizedBox(height: 16),
        SectionCard(
          icon: Icons.account_tree_outlined,
          title: 'التسلسل الأرشيفي المحلي',
          children: [
            for (final node in nodes) _ArchiveNodeTile(node: node),
          ],
        ),
        const SizedBox(height: 12),
        const SectionCard(
          icon: Icons.link_outlined,
          title: 'مفاتيح الربط المستقبلية',
          subtitle: 'لا يتم الربط الفعلي الآن. هذه مفاتيح نية معمارية فقط.',
          children: [
            KeyValueLine(label: 'الوقف', value: 'waqf_asset_id'),
            KeyValueLine(label: 'القضايا', value: 'case_id'),
            KeyValueLine(label: 'الجهة/الوحدة', value: localDevelopmentUnitKey),
            KeyValueLine(
                label: 'الملفات', value: 'File Center لاحقًا عبر Staging فقط'),
          ],
        ),
      ],
    );
  }
}

class _ArchiveNodeTile extends StatelessWidget {
  const _ArchiveNodeTile({required this.node});

  final ArchiveRecordNode node;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsetsDirectional.only(
          start: node.type.index * 18.0 + 10,
          end: 10,
          top: 10,
          bottom: 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                StatusPill(label: node.type.label),
                StatusPill(label: node.accessLevel.label),
                StatusPill(label: node.reviewStatus.label),
              ],
            ),
            const SizedBox(height: 8),
            Text(node.title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(node.reference),
            const SizedBox(height: 6),
            Text(node.description),
          ],
        ),
      ),
    );
  }
}
