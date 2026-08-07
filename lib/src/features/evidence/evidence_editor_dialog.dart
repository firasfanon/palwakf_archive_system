import 'package:flutter/material.dart';

import '../../core/models/models.dart';
import '../../platform_integration/contracts.dart';

class EvidenceEditorDialog extends StatefulWidget {
  const EvidenceEditorDialog({
    required this.onSubmit,
    this.existing,
    super.key,
  });

  final EvidenceItem? existing;
  final ValueChanged<EvidenceItem> onSubmit;

  @override
  State<EvidenceEditorDialog> createState() => _EvidenceEditorDialogState();
}

class _EvidenceEditorDialogState extends State<EvidenceEditorDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _sourceController;
  late final TextEditingController _referenceController;
  late EvidenceDomain _domain;
  late EvidenceReviewStatus _status;
  late bool _hasOriginal;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _titleController = TextEditingController(text: existing?.title ?? '');
    _sourceController = TextEditingController(
        text: existing?.sourceAuthority ?? 'بيانات محلية');
    _referenceController =
        TextEditingController(text: existing?.reference ?? 'LOCAL/NEW');
    _domain = existing?.domain ?? EvidenceDomain.waqf;
    _status = existing?.status ?? EvidenceReviewStatus.discovered;
    _hasOriginal = existing?.isOriginalAvailableLocally ?? false;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _sourceController.dispose();
    _referenceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.existing == null ? 'إضافة دليل محلي' : 'تعديل الدليل'),
      content: SizedBox(
        width: 520,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'العنوان'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'العنوان مطلوب';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _sourceController,
                  decoration: const InputDecoration(labelText: 'جهة المصدر'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'جهة المصدر مطلوبة';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _referenceController,
                  decoration: const InputDecoration(labelText: 'المرجع المحلي'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'المرجع مطلوب';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<EvidenceDomain>(
                  initialValue: _domain,
                  decoration: const InputDecoration(labelText: 'المجال'),
                  items: [
                    for (final value in EvidenceDomain.values)
                      DropdownMenuItem(
                        value: value,
                        child: Text(value.label),
                      ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _domain = value);
                    }
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<EvidenceReviewStatus>(
                  initialValue: _status,
                  decoration: const InputDecoration(labelText: 'حالة المراجعة'),
                  items: [
                    for (final value in EvidenceReviewStatus.values)
                      DropdownMenuItem(
                        value: value,
                        child: Text(value.label),
                      ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _status = value);
                    }
                  },
                ),
                SwitchListTile(
                  value: _hasOriginal,
                  title: const Text('الأصل متوفر محليًا'),
                  subtitle: const Text('لا يظهر مسار الملف في الواجهة'),
                  onChanged: (value) => setState(() => _hasOriginal = value),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('إلغاء'),
        ),
        FilledButton(
          onPressed: _save,
          child: const Text('حفظ محلي'),
        ),
      ],
    );
  }

  void _save() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final existing = widget.existing;
    final item = EvidenceItem(
      id: existing?.id ?? 'EV-LOCAL-${DateTime.now().millisecondsSinceEpoch}',
      title: _titleController.text.trim(),
      domain: _domain,
      sourceAuthority: _sourceController.text.trim(),
      reference: _referenceController.text.trim(),
      status: _status,
      confidence: existing?.confidence ?? 'قيد التصنيف',
      unitScopeKey: existing?.unitScopeKey ?? localDevelopmentUnitKey,
      isOriginalAvailableLocally: _hasOriginal,
      createdAt: existing?.createdAt ?? DateTime.now(),
    );

    widget.onSubmit(item);
    Navigator.of(context).pop();
  }
}
