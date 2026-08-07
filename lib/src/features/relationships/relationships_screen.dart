import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/models.dart';
import '../../core/state/local_operational_store.dart';
import '../../platform_integration/contracts.dart';
import '../../platform_integration/local_capability_gate.dart';
import '../../shared/widgets.dart';

class RelationshipsScreen extends ConsumerWidget {
  const RelationshipsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(localOperationalProvider);
    final titles = {
      for (final item in state.evidence) item.id: item.title,
    };

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showRelationDialog(context, ref),
        icon: const Icon(Icons.add_link),
        label: const Text('اقتراح علاقة'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'العلاقات والروابط',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          const LocalOnlyBanner(),
          const SizedBox(height: 12),
          const Text(
            'كل علاقة هنا مرشحة محلية مع سبب وثقة. لا تشكل رابطًا قانونيًا أو رابطًا منصيًا معتمدًا.',
          ),
          const SizedBox(height: 16),
          if (state.relations.isEmpty)
            const EmptyState(message: 'لا توجد علاقات مرشحة.')
          else
            for (final relation in state.relations)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        titles[relation.fromEvidenceId] ??
                            relation.fromEvidenceId,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 6),
                        child: Icon(Icons.arrow_downward),
                      ),
                      Text(
                        titles[relation.toEvidenceId] ?? relation.toEvidenceId,
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          StatusPill(label: relation.type.label),
                          StatusPill(label: relation.confidence),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(relation.rationale),
                    ],
                  ),
                ),
              ),
        ],
      ),
    );
  }

  void _showRelationDialog(BuildContext context, WidgetRef ref) {
    final evidence = ref.read(localOperationalProvider).evidence;
    if (evidence.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يلزم دليلان على الأقل لإنشاء علاقة.')),
      );
      return;
    }

    showDialog<EvidenceRelation>(
      context: context,
      builder: (context) => _RelationDialog(evidence: evidence),
    ).then((value) {
      if (value != null) {
        if (!requireLocalCapability(
          context,
          ref,
          capability: ArchiveCapability.relationProposeLocalDraft,
          actionLabel: 'اقتراح علاقة محلية',
        )) {
          return;
        }
        ref.read(localOperationalProvider.notifier).addRelation(value);
      }
    });
  }
}

class _RelationDialog extends StatefulWidget {
  const _RelationDialog({required this.evidence});

  final List<EvidenceItem> evidence;

  @override
  State<_RelationDialog> createState() => _RelationDialogState();
}

class _RelationDialogState extends State<_RelationDialog> {
  late String _fromId;
  late String _toId;
  RelationType _type = RelationType.supports;
  final _rationale = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fromId = widget.evidence.first.id;
    _toId = widget.evidence[1].id;
  }

  @override
  void dispose() {
    _rationale.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('اقتراح علاقة محلية'),
      content: SizedBox(
        width: 520,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _EvidencePicker(
                label: 'من الدليل',
                value: _fromId,
                evidence: widget.evidence,
                onChanged: (value) => setState(() => _fromId = value),
              ),
              const SizedBox(height: 12),
              _EvidencePicker(
                label: 'إلى الدليل',
                value: _toId,
                evidence: widget.evidence,
                onChanged: (value) => setState(() => _toId = value),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<RelationType>(
                initialValue: _type,
                decoration: const InputDecoration(labelText: 'نوع العلاقة'),
                items: [
                  for (final type in RelationType.values)
                    DropdownMenuItem(
                      value: type,
                      child: Text(type.label),
                    ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _type = value);
                  }
                },
              ),
              TextField(
                controller: _rationale,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'سبب الربط'),
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
            if (_fromId == _toId || _rationale.text.trim().isEmpty) {
              return;
            }
            Navigator.of(context).pop(
              EvidenceRelation(
                id: 'REL-LOCAL-${DateTime.now().millisecondsSinceEpoch}',
                fromEvidenceId: _fromId,
                toEvidenceId: _toId,
                type: _type,
                rationale: _rationale.text.trim(),
                confidence: 'قيد المراجعة',
                unitScopeKey: localDevelopmentUnitKey,
              ),
            );
          },
          child: const Text('حفظ محلي'),
        ),
      ],
    );
  }
}

class _EvidencePicker extends StatelessWidget {
  const _EvidencePicker({
    required this.label,
    required this.value,
    required this.evidence,
    required this.onChanged,
  });

  final String label;
  final String value;
  final List<EvidenceItem> evidence;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: InputDecoration(labelText: label),
      items: [
        for (final item in evidence)
          DropdownMenuItem(
            value: item.id,
            child: Text(item.title, overflow: TextOverflow.ellipsis),
          ),
      ],
      onChanged: (next) {
        if (next != null) {
          onChanged(next);
        }
      },
    );
  }
}
