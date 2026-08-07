import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/models.dart';
import '../../core/state/local_operational_store.dart';

class OperationsDashboardScreen extends ConsumerWidget {
  const OperationsDashboardScreen({
    required this.onNavigate,
    super.key,
  });

  final ValueChanged<int> onNavigate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(localOperationalProvider);
    final reviewOpen = state.reviewTasks
        .where((task) => task.state != ReviewTaskState.completed)
        .length;
    final quarantined = state.evidence
        .where((item) => item.status == EvidenceReviewStatus.quarantined)
        .length;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'لوحة المتابعة اليومية',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        const Text(
          'لوحة عمل يومية تعرض الوثائق، الرفع، المراجعات، والتصنيفات دون تحويل الحوكمة إلى واجهة المستخدم الرئيسية.',
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _MetricCard(
              icon: Icons.description_outlined,
              label: 'الوثائق',
              value: state.evidence.length.toString(),
              onTap: () => onNavigate(2),
            ),
            _MetricCard(
              icon: Icons.account_tree_outlined,
              label: 'التصنيفات',
              value: state.collections.length.toString(),
              onTap: () => onNavigate(3),
            ),
            _MetricCard(
              icon: Icons.fact_check_outlined,
              label: 'المراجعات المفتوحة',
              value: reviewOpen.toString(),
              onTap: () => onNavigate(9),
            ),
            _MetricCard(
              icon: Icons.gpp_maybe_outlined,
              label: 'المحجور',
              value: quarantined.toString(),
              onTap: () => onNavigate(2),
            ),
            _MetricCard(
              icon: Icons.notifications_active_outlined,
              label: 'تنبيهات غير مقروءة',
              value: state.unacknowledgedNotificationCount.toString(),
              onTap: () => onNavigate(18),
            ),
            _MetricCard(
              icon: Icons.backup_outlined,
              label: 'لقطات نسخ',
              value: state.backupSnapshots.length.toString(),
              onTap: () => onNavigate(18),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          'إجراءات سريعة',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            FilledButton.icon(
              onPressed: () => onNavigate(4),
              icon: const Icon(Icons.add),
              label: const Text('إدخال بيانات وثيقة'),
            ),
            OutlinedButton.icon(
              onPressed: () => onNavigate(5),
              icon: const Icon(Icons.upload_file_outlined),
              label: const Text('رفع وحفظ'),
            ),
            OutlinedButton.icon(
              onPressed: () => onNavigate(7),
              icon: const Icon(Icons.manage_search_outlined),
              label: const Text('بحث ذكي'),
            ),
            OutlinedButton.icon(
              onPressed: () => onNavigate(18),
              icon: const Icon(Icons.assessment_outlined),
              label: const Text('تقارير وتنبيهات'),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          'النشاط المحلي',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Card(
          child: Column(
            children: [
              for (final activity in state.activities.take(6))
                ListTile(
                  leading: const Icon(Icons.history_outlined),
                  title: Text(activity.message),
                  subtitle: Text(
                    '${activity.at.year}-${activity.at.month.toString().padLeft(2, '0')}-${activity.at.day.toString().padLeft(2, '0')} '
                    '${activity.at.hour.toString().padLeft(2, '0')}:${activity.at.minute.toString().padLeft(2, '0')}',
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 210,
      child: Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, size: 32),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(value,
                        style: Theme.of(context).textTheme.headlineSmall),
                    Text(label),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
