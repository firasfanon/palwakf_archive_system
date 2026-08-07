import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/models.dart';
import '../../core/state/local_operational_store.dart';
import '../../shared/widgets.dart';

class StagingReadinessScreen extends ConsumerWidget {
  const StagingReadinessScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checkpoints = ref
        .watch(localOperationalProvider)
        .readiness
        .where((item) => item.stage == ReadinessStage.stagingReadiness)
        .toList(growable: false);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Staging Integration Readiness',
            style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        const LocalOnlyBanner(),
        const SizedBox(height: 12),
        const Text(
          'هذه ليست حزمة اتصال بعيد. الهدف تجهيز عقود الجاهزية والاختبارات السلبية وخطة rollback قبل أي Staging UAT.',
        ),
        const SizedBox(height: 16),
        for (final checkpoint in checkpoints)
          ReadinessCheckpointCard(checkpoint: checkpoint),
        const SizedBox(height: 12),
        const SectionCard(
          icon: Icons.fact_check_outlined,
          title: 'بوابات Staging المطلوبة',
          children: [
            KeyValueLine(
                label: 'Authority Probe',
                value: 'قراءة صلاحية actor فقط، لا منح صلاحيات.'),
            KeyValueLine(
                label: 'Unit Scope Probe',
                value: 'منع cross-unit قبل أي قراءة بعيدة.'),
            KeyValueLine(
                label: 'Feature Flag',
                value: 'مغلق افتراضيًا، يفتح فقط في UAT.'),
            KeyValueLine(
                label: 'Negative UAT',
                value:
                    'منع الكتابة، الإنتاج، File Center mutation، GIS mutation.'),
            KeyValueLine(
                label: 'Rollback',
                value: 'تعطيل flag + fallback + no data mutation.'),
          ],
        ),
        const SizedBox(height: 12),
        const GovernanceWarningCard(),
      ],
    );
  }
}

class ControlledUatScreen extends ConsumerWidget {
  const ControlledUatScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checkpoints = ref
        .watch(localOperationalProvider)
        .readiness
        .where((item) => item.stage == ReadinessStage.controlledUat)
        .toList(growable: false);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Controlled Remote UAT',
            style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        const LocalOnlyBanner(),
        const SizedBox(height: 12),
        const Text(
          'هذه شاشة تخطيط UAT فقط. الاختبار البعيد لم يبدأ لأن Staging غير معتمد. أي قراءة بعيدة لاحقة يجب أن تكون محدودة وموثقة.',
        ),
        const SizedBox(height: 16),
        for (final checkpoint in checkpoints)
          ReadinessCheckpointCard(checkpoint: checkpoint),
        const SizedBox(height: 12),
        const SectionCard(
          icon: Icons.security_outlined,
          title: 'سيناريوهات UAT السلبية',
          children: [
            KeyValueLine(
                label: 'Cross Unit', value: 'طلب وحدة غير مصرح بها → BLOCKED.'),
            KeyValueLine(
                label: 'Write Attempt',
                value: 'أي insert/update/delete/storage write → BLOCKED.'),
            KeyValueLine(
                label: 'Production Endpoint',
                value: 'أي مؤشر إنتاج → BLOCKED.'),
            KeyValueLine(
                label: 'File Center',
                value: 'لا رفع أو حذف ملفات في UAT الأول.'),
            KeyValueLine(
                label: 'GIS/PostGIS',
                value: 'قراءة محدودة فقط عند التفويض، لا تعديل طبقات.'),
          ],
        ),
      ],
    );
  }
}

class ProductionReadinessScreen extends ConsumerWidget {
  const ProductionReadinessScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checkpoints = ref
        .watch(localOperationalProvider)
        .readiness
        .where((item) => item.stage == ReadinessStage.productionReadiness)
        .toList(growable: false);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Production Readiness',
            style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        const LocalOnlyBanner(),
        const SizedBox(height: 12),
        const Text(
          'هذه الصفحة تعرض شروط الجاهزية ولا تعني اعتماد الإنتاج. Production approval ما زال مرفوضًا/غير ممنوح.',
        ),
        const SizedBox(height: 16),
        for (final checkpoint in checkpoints)
          ReadinessCheckpointCard(checkpoint: checkpoint),
        const SizedBox(height: 12),
        const SectionCard(
          icon: Icons.verified_user_outlined,
          title: 'شروط ما قبل الإنتاج',
          children: [
            KeyValueLine(
                label: 'Security Review',
                value: 'RLS/SECDEF/Authority/RBAC مراجعة مستقلة.'),
            KeyValueLine(
                label: 'Backup/Restore',
                value: 'خطة استرجاع قبل أي migration.'),
            KeyValueLine(
                label: 'Performance',
                value: 'اختبار تحميل للبحث والخرائط والملفات.'),
            KeyValueLine(
                label: 'Legal/Privacy',
                value: 'إتاحة عامة فقط بعد حقوق ومراجعة قانونية.'),
            KeyValueLine(
                label: 'Operator Handoff',
                value: 'SOP + Runbook + Error Record + Rollback.'),
          ],
        ),
        const SizedBox(height: 12),
        const GovernanceWarningCard(),
      ],
    );
  }
}

class ReadinessCheckpointCard extends StatelessWidget {
  const ReadinessCheckpointCard({required this.checkpoint, super.key});

  final ReadinessCheckpoint checkpoint;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                StatusPill(label: checkpoint.stage.label),
                StatusPill(label: checkpoint.state.label),
              ],
            ),
            const SizedBox(height: 8),
            Text(checkpoint.title,
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            KeyValueLine(label: 'Evidence', value: checkpoint.evidence),
            KeyValueLine(label: 'Blocker', value: checkpoint.blocker),
          ],
        ),
      ),
    );
  }
}
