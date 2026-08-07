import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/models.dart';
import '../../core/state/local_operational_store.dart';
import '../../platform_integration/contracts.dart';
import '../../platform_integration/local_capability_gate.dart';
import '../../shared/widgets.dart';

class CollectionsScreen extends ConsumerWidget {
  const CollectionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collections = ref.watch(localOperationalProvider).collections;

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddCollection(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('إضافة مجموعة'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'المجموعات الأرشيفية',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          const LocalOnlyBanner(),
          const SizedBox(height: 12),
          const Text(
            'التسلسل المقصود للأرشيف العثماني: Fonds → Series → File → Item. '
            'المجموعات الحالية محلية تجريبية ولا تمثل جهة حفظ رسمية.',
          ),
          const SizedBox(height: 16),
          for (final collection in collections)
            Card(
              child: ListTile(
                leading: const Icon(Icons.account_tree_outlined),
                title: Text(collection.title),
                subtitle: Text(
                  '${collection.level} • ${collection.reference}\n${collection.description}',
                ),
                isThreeLine: true,
                trailing: StatusPill(label: collection.domain.label),
              ),
            ),
        ],
      ),
    );
  }

  void _showAddCollection(BuildContext context, WidgetRef ref) {
    showDialog<ArchiveCollection>(
      context: context,
      builder: (context) => const _CollectionDialog(),
    ).then((value) {
      if (value != null) {
        if (!requireLocalCapability(
          context,
          ref,
          capability: ArchiveCapability.collectionCreateLocalDraft,
          actionLabel: 'إضافة مجموعة محلية',
        )) {
          return;
        }
        ref.read(localOperationalProvider.notifier).addCollection(value);
      }
    });
  }
}

class _CollectionDialog extends StatefulWidget {
  const _CollectionDialog();

  @override
  State<_CollectionDialog> createState() => _CollectionDialogState();
}

class _CollectionDialogState extends State<_CollectionDialog> {
  final _title = TextEditingController();
  final _reference = TextEditingController(text: 'LOCAL/COLLECTION');
  final _description = TextEditingController();
  EvidenceDomain _domain = EvidenceDomain.waqf;
  String _level = 'Collection';

  @override
  void dispose() {
    _title.dispose();
    _reference.dispose();
    _description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('إضافة مجموعة محلية'),
      content: SizedBox(
        width: 500,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _title,
                decoration: const InputDecoration(labelText: 'العنوان'),
              ),
              TextField(
                controller: _reference,
                decoration: const InputDecoration(labelText: 'المرجع'),
              ),
              TextField(
                controller: _description,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'الوصف'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _level,
                decoration: const InputDecoration(labelText: 'المستوى'),
                items: const [
                  DropdownMenuItem(
                      value: 'Collection', child: Text('Collection')),
                  DropdownMenuItem(value: 'Fonds', child: Text('Fonds')),
                  DropdownMenuItem(value: 'Series', child: Text('Series')),
                  DropdownMenuItem(value: 'File', child: Text('File')),
                  DropdownMenuItem(value: 'Item', child: Text('Item')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _level = value);
                  }
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<EvidenceDomain>(
                initialValue: _domain,
                decoration: const InputDecoration(labelText: 'المجال'),
                items: [
                  for (final domain in EvidenceDomain.values)
                    DropdownMenuItem(
                      value: domain,
                      child: Text(domain.label),
                    ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _domain = value);
                  }
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('إلغاء'),
        ),
        FilledButton(
          onPressed: () {
            if (_title.text.trim().isEmpty) {
              return;
            }
            Navigator.of(context).pop(
              ArchiveCollection(
                id: 'COL-LOCAL-${DateTime.now().millisecondsSinceEpoch}',
                title: _title.text.trim(),
                level: _level,
                domain: _domain,
                reference: _reference.text.trim(),
                description: _description.text.trim(),
                unitScopeKey: localDevelopmentUnitKey,
              ),
            );
          },
          child: const Text('إضافة'),
        ),
      ],
    );
  }
}
