import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/models.dart';
import '../../core/state/local_operational_store.dart';
import '../../shared/widgets.dart';

class LocalProductFoundationScreen extends ConsumerWidget {
  const LocalProductFoundationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(localOperationalProvider);
    final stages = ReadinessStage.values;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Local Product → Production Readiness',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        const LocalOnlyBanner(),
        const SizedBox(height: 12),
        const Text(
          'هذه الشاشة تجمع مسار التطوير الكامل في منتج محلي واحد: المنتج المحلي، قلب الأرشيف، الأدلة، المراجعة، المكان/البحث، الإدارة، جاهزية Staging، UAT مضبوط، وجاهزية Production دون اعتماد إنتاجي.',
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            MetricTile(
              icon: Icons.description_outlined,
              label: 'مواد الأدلة',
              value: state.evidence.length.toString(),
            ),
            MetricTile(
              icon: Icons.account_tree_outlined,
              label: 'عُقد أرشيفية',
              value: state.archiveNodes.length.toString(),
            ),
            MetricTile(
              icon: Icons.verified_outlined,
              label: 'سجلات دليل',
              value: state.registry.length.toString(),
            ),
            MetricTile(
              icon: Icons.rule_folder_outlined,
              label: 'نقاط جاهزية محجوبة',
              value: state.blockedReadinessCount.toString(),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SectionCard(
          icon: Icons.route_outlined,
          title: 'خارطة المسار الإنتاجي المحلي',
          subtitle:
              'كل محطة لها checkpoint محلي. لا توجد كتابة بعيدة أو اتصال إنتاجي.',
          children: [
            for (final stage in stages)
              _StageLine(
                stage: stage,
                checkpoints: state.readiness
                    .where((item) => item.stage == stage)
                    .toList(growable: false),
              ),
          ],
        ),
        const SizedBox(height: 12),
        const GovernanceWarningCard(),
      ],
    );
  }
}

class _StageLine extends StatelessWidget {
  const _StageLine({
    required this.stage,
    required this.checkpoints,
  });

  final ReadinessStage stage;
  final List<ReadinessCheckpoint> checkpoints;

  @override
  Widget build(BuildContext context) {
    final labels = checkpoints.map((item) => item.state.label).join(' / ');
    return Card(
      child: ListTile(
        leading: const Icon(Icons.checklist_rtl_outlined),
        title: Text(stage.label),
        subtitle:
            Text(checkpoints.isEmpty ? 'لا توجد نقطة جاهزية بعد' : labels),
        trailing: StatusPill(
          label: checkpoints.any((item) => item.state == ReadinessState.blocked)
              ? 'محجوب'
              : checkpoints.any((item) => item.state == ReadinessState.warning)
                  ? 'تحذير'
                  : 'جاهز محليًا',
        ),
      ),
    );
  }
}
