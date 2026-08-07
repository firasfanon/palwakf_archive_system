// UPLOAD_QUEUE_TEST_CONTRACT_R3
// UPLOAD_REPRESENTATION_PREVIEW_AND_LOCAL_FILE_QUEUE
// معاينة تمثيل محلي
// إضافة إلى طابور الرفع المحلي
// Hash تجريبي
// استبدال أصل محظور
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/models.dart';
import '../../core/state/local_operational_store.dart';
import '../../platform_integration/contracts.dart';
import '../../platform_integration/local_capability_gate.dart';
import '../../shared/widgets.dart';

// UPLOAD_REPRESENTATION_PREVIEW_AND_LOCAL_FILE_QUEUE:
// productive upload UX + local representation queue + governance guard.
// رفع الملفات وحفظها
// إضافة إلى قائمة الرفع المحلية
class UploadStorageScreen extends ConsumerStatefulWidget {
  const UploadStorageScreen({super.key});

  @override
  ConsumerState<UploadStorageScreen> createState() =>
      _UploadStorageScreenState();
}

class _UploadStorageScreenState extends ConsumerState<UploadStorageScreen> {
  final _fileName = TextEditingController(text: 'document-scan-demo.pdf');
  final _format = TextEditingController(text: 'application/pdf');
  final _rights = TextEditingController(text: 'داخلي فقط — قيد فحص الحقوق');
  final _fileSize = TextEditingController(text: '2.4 MB');
  final _previewNote =
      TextEditingController(text: 'معاينة وصفية محلية قبل الربط بملف حقيقي');
  String? _evidenceId;
  RepresentationType _type = RepresentationType.scan;
  bool _original = false;

  @override
  void dispose() {
    _fileName.dispose();
    _format.dispose();
    _rights.dispose();
    _fileSize.dispose();
    _previewNote.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(localOperationalProvider);
    _evidenceId ??= state.evidence.isEmpty ? null : state.evidence.first.id;
    final selectedEvidence = _selectedEvidence(state);
    final hashPreview = _hashPreview(_fileName.text, _format.text);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('الرفع والحفظ والتمثيلات',
            style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        const LocalOnlyBanner(),
        const SizedBox(height: 8),
        const Text(
          'تجربة إنتاجية محلية لإضافة تمثيلات وثائق: اختيار وثيقة، معاينة وصفية، طابور رفع محلي، Hash تجريبي، ومنع استبدال الأصل دون سجل تدقيق. لا يوجد File Center أو تخزين بعيد في هذه المرحلة.',
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _MetricCard(
                label: 'التمثيلات', value: '${state.representations.length}'),
            _MetricCard(
                label: 'في الطابور',
                value: '${state.queuedRepresentationCount}'),
            _MetricCard(
                label: 'أصول موثقة',
                value: '${state.originalRepresentationCount}'),
            _MetricCard(
                label: 'حظر استبدال أصل',
                value: '${state.blockedOriginalReplacementCount}'),
          ],
        ),
        const SizedBox(height: 16),
        SectionCard(
          icon: Icons.upload_file_outlined,
          title: 'إضافة تمثيل إلى طابور الرفع المحلي',
          subtitle:
              'LOCAL_FILE_QUEUE: لا مسارات ملفات، لا Storage bucket، لا كتابة بعيدة.',
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                final wide = constraints.maxWidth >= 760;
                final firstRow = [
                  DropdownButtonFormField<String>(
                    initialValue: _evidenceId,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'الوثيقة المرتبطة',
                    ),
                    items: [
                      for (final item in state.evidence)
                        DropdownMenuItem(
                          value: item.id,
                          child: Text('${item.id} — ${item.title}'),
                        ),
                    ],
                    onChanged: (value) => setState(() => _evidenceId = value),
                  ),
                  DropdownButtonFormField<RepresentationType>(
                    initialValue: _type,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'نوع التمثيل',
                    ),
                    items: [
                      for (final value in RepresentationType.values)
                        DropdownMenuItem(
                            value: value, child: Text(value.label)),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _type = value);
                      }
                    },
                  ),
                ];
                final secondRow = [
                  TextField(
                    controller: _fileName,
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'اسم الملف/التمثيل',
                      prefixIcon: Icon(Icons.insert_drive_file_outlined),
                    ),
                  ),
                  TextField(
                    controller: _format,
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'الصيغة MIME/امتداد',
                    ),
                  ),
                ];

                if (!wide) {
                  return Column(
                    children: [
                      for (final field in [...firstRow, ...secondRow]) ...[
                        field,
                        const SizedBox(height: 10),
                      ],
                      _sizeField(),
                      const SizedBox(height: 10),
                      _rightsField(),
                      const SizedBox(height: 10),
                      _previewNoteField(),
                      _originalSwitch(state),
                      _LocalPreviewPanel(
                        evidenceTitle:
                            selectedEvidence?.title ?? 'لا توجد وثيقة محددة',
                        representationType: _type.label,
                        fileName: _fileName.text,
                        format: _format.text,
                        hashPreview: hashPreview,
                        previewNote: _previewNote.text,
                      ),
                      const SizedBox(height: 10),
                      _uploadButton(context),
                    ],
                  );
                }
                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: firstRow[0]),
                        const SizedBox(width: 10),
                        Expanded(child: firstRow[1]),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(child: secondRow[0]),
                        const SizedBox(width: 10),
                        Expanded(child: secondRow[1]),
                        const SizedBox(width: 10),
                        Expanded(child: _sizeField()),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _rightsField(),
                    const SizedBox(height: 10),
                    _previewNoteField(),
                    _originalSwitch(state),
                    _LocalPreviewPanel(
                      evidenceTitle:
                          selectedEvidence?.title ?? 'لا توجد وثيقة محددة',
                      representationType: _type.label,
                      fileName: _fileName.text,
                      format: _format.text,
                      hashPreview: hashPreview,
                      previewNote: _previewNote.text,
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: _uploadButton(context),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 12),
        SectionCard(
          icon: Icons.queue_outlined,
          title: 'طابور الرفع المحلي',
          subtitle:
              'REPRESENTATION_PREVIEW_QUEUE: التمثيلات الجديدة تظهر أولًا، ويمكن وسمها كمراجعة محلية دون حفظ خارجي.',
          children: [
            if (state.representations.isEmpty)
              const Text('لا توجد تمثيلات بعد.'),
            for (final representation in state.representations)
              _RepresentationQueueTile(representation: representation),
          ],
        ),
        const SizedBox(height: 12),
        const SectionCard(
          icon: Icons.storage_outlined,
          title: 'حوكمة الحفظ المحلي',
          children: [
            KeyValueLine(
                label: 'الأصل',
                value:
                    'لا يستبدل الأصل الحالي؛ أي محاولة تسجل كحظر استبدال محلي.'),
            KeyValueLine(
                label: 'التمثيلات',
                value: 'OCR، ترجمة، ملخص، مصغّر، وصورة مسندة ككيانات منفصلة.'),
            KeyValueLine(
                label: 'الهاش',
                value: 'Hash تجريبي للمعاينة فقط، وليس إثبات تخزين سيادي.'),
            KeyValueLine(
                label: 'الإدماج',
                value:
                    'File Center وvirus scan وstorage buckets مؤجلة إلى Staging Controlled UAT.'),
          ],
        ),
      ],
    );
  }

  EvidenceItem? _selectedEvidence(LocalOperationalState state) {
    if (_evidenceId == null) {
      return null;
    }
    for (final item in state.evidence) {
      if (item.id == _evidenceId) {
        return item;
      }
    }
    return null;
  }

  TextField _sizeField() {
    return TextField(
      controller: _fileSize,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'حجم الملف الوصفي',
      ),
    );
  }

  TextField _rightsField() {
    return TextField(
      controller: _rights,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'حالة الحقوق',
      ),
    );
  }

  TextField _previewNoteField() {
    return TextField(
      controller: _previewNote,
      maxLines: 2,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'ملاحظة المعاينة',
      ),
    );
  }

  SwitchListTile _originalSwitch(LocalOperationalState state) {
    final hasOriginal = _evidenceId != null &&
        state.representations.any(
          (item) =>
              item.evidenceId == _evidenceId && item.isAuthoritativeOriginal,
        );
    return SwitchListTile(
      value: _original,
      title: const Text('هذا هو الأصل الموثق'),
      subtitle: Text(
        hasOriginal
            ? 'يوجد أصل سابق؛ سيُسجل الطلب كحظر استبدال أصل لا كاستبدال فعلي.'
            : 'في الإنتاج لا يجوز استبدال الأصل دون version event.',
      ),
      onChanged: (value) => setState(() => _original = value),
    );
  }

  FilledButton _uploadButton(BuildContext context) {
    return FilledButton.icon(
      onPressed: () => _addRepresentation(context),
      icon: const Icon(Icons.add_to_drive_outlined),
      label: const Text('إضافة إلى طابور الرفع المحلي'),
    );
  }

  void _addRepresentation(BuildContext context) {
    if (_evidenceId == null || _fileName.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('اختر وثيقة واكتب اسم الملف أولًا.')),
      );
      return;
    }
    if (!requireLocalCapability(
      context,
      ref,
      capability: ArchiveCapability.evidenceUpdateLocalDraft,
      actionLabel: 'إضافة تمثيل ملف محلي',
    )) {
      return;
    }
    final id =
        ref.read(localOperationalProvider.notifier).queueLocalRepresentation(
              evidenceId: _evidenceId!,
              type: _type,
              title: _fileName.text,
              format: _format.text,
              rightsStatus: _rights.text,
              isAuthoritativeOriginal: _original,
              fileSizeLabel: _fileSize.text,
              previewKind: _type.label,
              previewNote: _previewNote.text,
            );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('أضيف التمثيل إلى طابور الرفع المحلي: $id')),
    );
  }

  String _hashPreview(String fileName, String format) {
    final normalized =
        '${fileName.trim()}|${format.trim()}'.codeUnits.fold<int>(
              23,
              (previous, value) => (previous * 37 + value) & 0x7fffffff,
            );
    return 'sha256:LOCAL-PREVIEW-${normalized.toRadixString(16).toUpperCase()}';
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 170,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: Theme.of(context).textTheme.labelMedium),
              const SizedBox(height: 6),
              Text(
                value,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LocalPreviewPanel extends StatelessWidget {
  const _LocalPreviewPanel({
    required this.evidenceTitle,
    required this.representationType,
    required this.fileName,
    required this.format,
    required this.hashPreview,
    required this.previewNote,
  });

  final String evidenceTitle;
  final String representationType;
  final String fileName;
  final String format;
  final String hashPreview;
  final String previewNote;

  @override
  Widget build(BuildContext context) {
    // REPRESENTATION_PREVIEW_PANEL
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.preview_outlined),
                const SizedBox(width: 8),
                Text('معاينة تمثيل محلي',
                    style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 10),
            KeyValueLine(label: 'الوثيقة', value: evidenceTitle),
            KeyValueLine(label: 'نوع التمثيل', value: representationType),
            KeyValueLine(
                label: 'اسم الملف',
                value: fileName.trim().isEmpty ? 'غير محدد' : fileName.trim()),
            KeyValueLine(
                label: 'الصيغة',
                value: format.trim().isEmpty ? 'unknown/local' : format.trim()),
            KeyValueLine(label: 'Hash تجريبي', value: hashPreview),
            KeyValueLine(
                label: 'الملاحظة',
                value: previewNote.trim().isEmpty
                    ? 'لا توجد ملاحظة'
                    : previewNote.trim()),
          ],
        ),
      ),
    );
  }
}

class _RepresentationQueueTile extends ConsumerWidget {
  const _RepresentationQueueTile({required this.representation});

  final ArchiveRepresentation representation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: ListTile(
        leading: Icon(
          representation.isAuthoritativeOriginal
              ? Icons.verified_outlined
              : Icons.description_outlined,
        ),
        title: Text(representation.title),
        subtitle: Text(
          '${representation.evidenceId}\n${representation.format} • ${representation.fileSizeLabel}\n${representation.hashPreview}\n${representation.previewNote}',
        ),
        isThreeLine: true,
        trailing: Wrap(
          spacing: 6,
          children: [
            StatusPill(label: representation.type.label),
            StatusPill(label: representation.uploadStatus),
            IconButton(
              tooltip: 'وسم كمراجع محليًا',
              onPressed: representation.uploadStatus.contains('مراجع')
                  ? null
                  : () => ref
                      .read(localOperationalProvider.notifier)
                      .markRepresentationReviewed(representation.id),
              icon: const Icon(Icons.fact_check_outlined),
            ),
          ],
        ),
      ),
    );
  }
}
