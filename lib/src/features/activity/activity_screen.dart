import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/state/local_operational_store.dart';
import '../../shared/widgets.dart';

class ActivityScreen extends ConsumerWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(localOperationalProvider);
    final activities = state.activities;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'سجل النشاط المحلي',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        const LocalOnlyBanner(),
        const SizedBox(height: 12),
        Text(
          'هذا سجل جلسة محلي وليس Audit Trail مركزيًا. يختفي عند إعادة تشغيل التطبيق. التنبيهات غير المقروءة: ${state.unacknowledgedNotificationCount}',
        ),
        const SizedBox(height: 16),
        for (final activity in activities)
          Card(
            child: ListTile(
              leading: const Icon(Icons.history_outlined),
              title: Text(activity.message),
              subtitle: Text(activity.at.toIso8601String()),
            ),
          ),
      ],
    );
  }
}
