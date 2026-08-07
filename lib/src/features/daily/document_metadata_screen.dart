import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/models.dart';
import '../../core/state/local_operational_store.dart';
import '../../platform_integration/contracts.dart';
import '../../platform_integration/local_capability_gate.dart';
import '../../shared/widgets.dart';

// DAILY_OPERATIONS_FULL_UI: editable metadata workbench for document records.
class DocumentMetadataScreen extends ConsumerStatefulWidget {
  const DocumentMetadataScreen({super.key});

  @override
  ConsumerState<DocumentMetadataScreen> createState() =>
      _DocumentMetadataScreenState();
}

class _DocumentMetadataScreenState
    extends ConsumerState<DocumentMetadataScreen> {
  final _title = TextEditingController();
  final _source = TextEditingController();
  final _reference = TextEditingController();
  final _dateLabel = TextEditingController();
  final _rights = TextEditingController();
  final _sensitivity = TextEditingController();
  final _linkedAsset = TextEditingController();
  String? _selectedId;
  EvidenceDomain _domain = EvidenceDomain.general;
  EvidenceReviewStatus _status = EvidenceReviewStatus.discovered;
  AccessLevel _accessLevel = AccessLevel.internal;
  SpatialStatus _spatialStatus = SpatialStatus.notMapped;
  bool _hasOriginal = false;

  @override
  void dispose() {
    _title.dispose();
    _source.dispose();
    _reference.dispose();
    _dateLabel.dispose();
    _rights.dispose();
    _sensitivity.dispose();
    _linkedAsset.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(localOperationalProvider);
    if (_selectedId == null && state.evidence.isNotEmpty) {
      _load(state.evidence.first);
    }
    EvidenceItem? selected;
    for (final item in state.evidence) {
      if (item.id == _selectedId) {
        selected = item;
        break;
      }
    }

    final selectedItem = selected;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('بيانات الوثيقة',
            style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        const LocalOnlyBanner(),
        const SizedBox(height: 8),
        const Text(
            'نموذج metadata عملي لتعديل بيانات الوثيقة داخل الجلسة: العنوان، المصدر، التاريخ، الحقوق، الحساسية، وروابط waqf_asset_id المستقبلية.'),
        const SizedBox(height: 16),
        SectionCard(
          icon: Icons.article_outlined,
          title: 'اختيار الوثيقة',
          children: [
            DropdownButtonFormField<String>(
              initialValue: _selectedId,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'الوثيقة الحالية',
              ),
              items: [
                for (final item in state.evidence)
                  DropdownMenuItem(
                      value: item.id,
                      child: Text('${item.id} — ${item.title}')),
              ],
              onChanged: (value) {
                final item = state.evidence
                    .firstWhere((candidate) => candidate.id == value);
                setState(() => _load(item));
              },
            ),
          ],
        ),
        const SizedBox(height: 12),
        SectionCard(
          icon: Icons.badge_outlined,
          title: 'نموذج بيانات كل وثيقة',
          subtitle:
              'الحقول المحفوظة هنا محلية فقط، لكنها تعكس نموذج الإدخال الإنتاجي المطلوب.',
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                final wide = constraints.maxWidth >= 720;
                final fields = [
                  _text(_title, 'عنوان الوثيقة', Icons.title_outlined),
                  _text(_reference, 'الرقم/المرجع', Icons.tag_outlined),
                  _text(_source, 'جهة المصدر', Icons.source_outlined),
                  _text(_dateLabel, 'التاريخ النصي', Icons.event_outlined),
                  _text(_rights, 'حالة الحقوق', Icons.verified_user_outlined),
                  _text(
                      _sensitivity, 'الحساسية القانونية', Icons.gavel_outlined),
                  _text(_linkedAsset, 'waqf_asset_id مستقبلي',
                      Icons.link_outlined),
                ];
                return Column(
                  children: [
                    for (var index = 0;
                        index < fields.length;
                        index += wide ? 2 : 1)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: wide && index + 1 < fields.length
                            ? Row(
                                children: [
                                  Expanded(child: fields[index]),
                                  const SizedBox(width: 10),
                                  Expanded(child: fields[index + 1]),
                                ],
                              )
                            : fields[index],
                      ),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        _domainField(),
                        _statusField(),
                        _accessField(),
                        _spatialField(),
                      ],
                    ),
                    SwitchListTile(
                      value: _hasOriginal,
                      title: const Text('الأصل متوفر/موصوف محليًا'),
                      subtitle: const Text(
                          'لا يوجد رفع حقيقي أو File Center في هذه المرحلة.'),
                      onChanged: (value) =>
                          setState(() => _hasOriginal = value),
                    ),
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: FilledButton.icon(
                        onPressed: selectedItem == null
                            ? null
                            : () => _save(context, selectedItem),
                        icon: const Icon(Icons.save_outlined),
                        label: const Text('حفظ metadata محليًا'),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 12),
        const SectionCard(
          icon: Icons.fact_check_outlined,
          title: 'قواعد التحقق المطلوبة قبل المراجعة',
          children: [
            KeyValueLine(
                label: 'إلزامي',
                value:
                    'العنوان، المرجع، المصدر، الإدارة/المجال، مستوى الإتاحة، حالة الحقوق.'),
            KeyValueLine(
                label: 'مستحسن',
                value:
                    'تاريخ وصفي، waqf_asset_id إن وجد، حساسية قانونية، حالة الأصل والـHash.'),
            KeyValueLine(
                label: 'مؤجل',
                value:
                    'المعرف السيادي، File Center path، PostGIS geometry، Audit المركزي.'),
          ],
        ),
      ],
    );
  }

  TextField _text(
      TextEditingController controller, String label, IconData icon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: label,
        prefixIcon: Icon(icon),
      ),
    );
  }

  SizedBox _domainField() {
    return SizedBox(
      width: 220,
      child: DropdownButtonFormField<EvidenceDomain>(
        initialValue: _domain,
        decoration: const InputDecoration(labelText: 'الإدارة/المجال'),
        items: [
          for (final value in EvidenceDomain.values)
            DropdownMenuItem(value: value, child: Text(value.label)),
        ],
        onChanged: (value) {
          if (value != null) {
            setState(() => _domain = value);
          }
        },
      ),
    );
  }

  SizedBox _statusField() {
    return SizedBox(
      width: 220,
      child: DropdownButtonFormField<EvidenceReviewStatus>(
        initialValue: _status,
        decoration: const InputDecoration(labelText: 'حالة الوثيقة'),
        items: [
          for (final value in EvidenceReviewStatus.values)
            DropdownMenuItem(value: value, child: Text(value.label)),
        ],
        onChanged: (value) {
          if (value != null) {
            setState(() => _status = value);
          }
        },
      ),
    );
  }

  SizedBox _accessField() {
    return SizedBox(
      width: 220,
      child: DropdownButtonFormField<AccessLevel>(
        initialValue: _accessLevel,
        decoration: const InputDecoration(labelText: 'مستوى الإتاحة'),
        items: [
          for (final value in AccessLevel.values)
            DropdownMenuItem(value: value, child: Text(value.label)),
        ],
        onChanged: (value) {
          if (value != null) {
            setState(() => _accessLevel = value);
          }
        },
      ),
    );
  }

  SizedBox _spatialField() {
    return SizedBox(
      width: 220,
      child: DropdownButtonFormField<SpatialStatus>(
        initialValue: _spatialStatus,
        decoration: const InputDecoration(labelText: 'الحالة المكانية'),
        items: [
          for (final value in SpatialStatus.values)
            DropdownMenuItem(value: value, child: Text(value.label)),
        ],
        onChanged: (value) {
          if (value != null) {
            setState(() => _spatialStatus = value);
          }
        },
      ),
    );
  }

  void _load(EvidenceItem item) {
    _selectedId = item.id;
    _title.text = item.title;
    _source.text = item.sourceAuthority;
    _reference.text = item.reference;
    _dateLabel.text = item.dateLabel;
    _rights.text = item.rightsStatus;
    _sensitivity.text = item.legalSensitivity;
    _linkedAsset.text = item.linkedWaqfAssetId ?? '';
    _domain = item.domain;
    _status = item.status;
    _accessLevel = item.accessLevel;
    _spatialStatus = item.spatialStatus;
    _hasOriginal = item.isOriginalAvailableLocally;
  }

  void _save(BuildContext context, EvidenceItem selected) {
    if (_title.text.trim().isEmpty || _reference.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('العنوان والمرجع مطلوبان.')),
      );
      return;
    }
    if (!requireLocalCapability(
      context,
      ref,
      capability: ArchiveCapability.evidenceUpdateLocalDraft,
      actionLabel: 'حفظ بيانات وثيقة محلية',
    )) {
      return;
    }
    ref.read(localOperationalProvider.notifier).updateEvidence(
          selected.copyWith(
            title: _title.text.trim(),
            domain: _domain,
            sourceAuthority: _source.text.trim(),
            reference: _reference.text.trim(),
            status: _status,
            dateLabel: _dateLabel.text.trim(),
            rightsStatus: _rights.text.trim(),
            legalSensitivity: _sensitivity.text.trim(),
            linkedWaqfAssetId: _linkedAsset.text.trim().isEmpty
                ? null
                : _linkedAsset.text.trim(),
            accessLevel: _accessLevel,
            spatialStatus: _spatialStatus,
            isOriginalAvailableLocally: _hasOriginal,
          ),
        );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم حفظ metadata داخل الجلسة المحلية.')),
    );
  }
}
