import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/state/local_operational_store.dart';
import '../../shared/widgets.dart';

class TemporalExplorerScreen extends ConsumerWidget {
  const TemporalExplorerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(localOperationalProvider);
    final titles = {for (final item in state.evidence) item.id: item.title};

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('المستكشف الزمني',
            style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        const LocalOnlyBanner(),
        const SizedBox(height: 12),
        const Text(
          'يعرض الخط الزمني للأدلة حسب الفترة والتاريخ الوصفي ومستوى اليقين. التواريخ غير المؤكدة لا تتحول إلى حقائق قانونية.',
        ),
        const SizedBox(height: 16),
        for (final event in state.temporalEvents)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.timeline_outlined),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            StatusPill(label: event.periodLabel),
                            StatusPill(label: event.certainty),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(event.title,
                            style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 4),
                        Text(titles[event.evidenceId] ?? event.evidenceId),
                        const SizedBox(height: 4),
                        Text(event.dateLabel),
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
