import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/models.dart';
import '../../core/state/local_operational_store.dart';
import '../../shared/widgets.dart';

class EvidenceRegistryScreen extends ConsumerWidget {
  const EvidenceRegistryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(localOperationalProvider);
    final titles = {for (final item in state.evidence) item.id: item.title};

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('سجل الأدلة', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        const LocalOnlyBanner(),
        const SizedBox(height: 12),
        const Text(
          'سجل الأدلة يحول المادة الأرشيفية إلى دليل مؤسسي مع نوع، ثقة، سلسلة مصدر، حقوق، وحساسية. السجل محلي وغير معتمد قضائيًا.',
        ),
        const SizedBox(height: 16),
        for (final entry in state.registry)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titles[entry.evidenceId] ?? entry.evidenceId,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      StatusPill(label: entry.type.label),
                      StatusPill(label: entry.reviewStatus.label),
                      StatusPill(label: entry.rightsStatus),
                    ],
                  ),
                  const SizedBox(height: 10),
                  KeyValueLine(label: 'الثقة', value: entry.confidenceLevel),
                  KeyValueLine(label: 'سلسلة المصدر', value: entry.sourceChain),
                  KeyValueLine(
                      label: 'الحساسية', value: entry.legalSensitivity),
                  KeyValueLine(
                    label: 'waqf_asset_id',
                    value: entry.linkedWaqfAssetId ?? 'غير مربوط',
                  ),
                  KeyValueLine(
                    label: 'case_id',
                    value: entry.linkedCaseId ?? 'غير مربوط',
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
