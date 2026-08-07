import 'package:flutter/material.dart';

import '../../shared/widgets.dart';

class SpatialReadinessScreen extends StatelessWidget {
  const SpatialReadinessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const layers = [
      (
        title: 'رستر مسند جغرافيًا تجريبي',
        kind: 'GEOREFERENCED_MAP_REPRESENTATION',
        limit: 'ليس حدًا قانونيًا',
      ),
      (
        title: 'طبقة مواقع مرجعية تجريبية',
        kind: 'GIS_LAYER_OR_FEATURE',
        limit: 'مرجع غير متحقق',
      ),
      (
        title: 'نتيجة تراكب تحليلية',
        kind: 'DERIVED_ANALYTICAL_RESULT',
        limit: 'نتيجة تحليلية وليست مسحًا رسميًا',
      ),
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'الخرائط والطبقات',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        const LocalOnlyBanner(),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Icon(Icons.map_outlined, size: 64),
                const SizedBox(height: 12),
                Text(
                  'جاهزية العرض المكاني',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                const Text(
                  'لا توجد خريطة حية أو basemap أو PostGIS أو إحداثيات فعلية في هذه الدفعة. '
                  'المعروض هو سجل metadata وحدود استخدام فقط.',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        for (final layer in layers)
          Card(
            child: ListTile(
              leading: const Icon(Icons.layers_outlined),
              title: Text(layer.title),
              subtitle: Text('${layer.kind}\nالحد: ${layer.limit}'),
              isThreeLine: true,
              trailing: const StatusPill(label: 'محلي'),
            ),
          ),
      ],
    );
  }
}
