import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/models.dart';
import '../../core/state/local_operational_store.dart';
import '../../platform_integration/contracts.dart';
import '../../platform_integration/local_capability_gate.dart';
import '../../shared/widgets.dart';

// CATALOG_AWARE_FORM_VISUAL_IDENTITY: draft intake form carries catalog/type/metadata visual identity and draft warning language.
class AddDocumentScreen extends ConsumerStatefulWidget {
  const AddDocumentScreen({
    required this.onOpenDocuments,
    super.key,
  });

  final VoidCallback onOpenDocuments;

  @override
  ConsumerState<AddDocumentScreen> createState() => _AddDocumentScreenState();
}

class _AddDocumentScreenState extends ConsumerState<AddDocumentScreen> {
  // DOCUMENT_INTAKE_VALIDATION_RULES: title, source/department, reference, and
  // access/classification controls are validated before creating a local draft.
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _departmentController = TextEditingController(text: 'إدارة الأرشيف');
  final _subjectController = TextEditingController(text: 'تصنيف أولي');
  final _typeController = TextEditingController(text: 'كتاب/وثيقة');
  final _sourceController = TextEditingController(text: 'إدخال محلي');
  final _referenceController = TextEditingController(text: 'LOCAL/DOC/NEW');
  final _dateController = TextEditingController(text: 'غير محدد');
  final _rightsController =
      TextEditingController(text: 'حقوق داخلية قيد المراجعة');
  final _sensitivityController = TextEditingController(text: 'غير مصنف');
  final _assetController = TextEditingController();
  final _caseController = TextEditingController();
  final _keywordsController =
      TextEditingController(text: 'أرشيف، وثيقة، مراجعة');
  final _workflowNoteController = TextEditingController(
    text: 'تدفق إدخال محلي محكوم قبل أي ربط خارجي.',
  );
  final Map<String, TextEditingController> _metadataControllers = {};

  String _catalogId = 'catalog-ottoman';
  String _documentTypeTabId = 'ottoman-tapu';
  EvidenceDomain _domain = EvidenceDomain.general;
  AccessLevel _accessLevel = AccessLevel.internal;
  SpatialStatus _spatialStatus = SpatialStatus.notMapped;
  bool _hasOriginal = false;
  bool _createRepresentation = true;
  bool _submitForReview = true;
  int _currentStep = 0;
  String? _lastCreatedId;

  @override
  void dispose() {
    _titleController.dispose();
    _departmentController.dispose();
    _subjectController.dispose();
    _typeController.dispose();
    _sourceController.dispose();
    _referenceController.dispose();
    _dateController.dispose();
    _rightsController.dispose();
    _sensitivityController.dispose();
    _assetController.dispose();
    _caseController.dispose();
    _keywordsController.dispose();
    _workflowNoteController.dispose();
    for (final controller in _metadataControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(localOperationalProvider);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('إضافة مسودة أرشيفية',
            style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        const LocalOnlyBanner(),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            MetricTile(
              icon: Icons.folder_copy_outlined,
              label: 'وثائق الجلسة',
              value: '${state.evidence.length}',
              onTap: widget.onOpenDocuments,
            ),
            MetricTile(
              icon: Icons.fact_check_outlined,
              label: 'مهام مراجعة',
              value: '${state.openReviewCount}',
            ),
            MetricTile(
              icon: Icons.manage_history_outlined,
              label: 'أحداث تدقيق',
              value: '${state.auditTrailCount}',
            ),
          ],
        ),
        const SizedBox(height: 12),
        SectionCard(
          icon: Icons.note_add_outlined,
          title: 'إدخال مسودة أرشيفية حسب الكتالوج',
          subtitle:
              'ADD_DOCUMENT_MULTI_STEP_FLOW + GOVERNED_DOCUMENT_DRAFT_CREATION + CATALOG_AWARE_METADATA_TEMPLATES + DYNAMIC_DRAFT_FORM_FIELDS + OPEN_DRAFT_INTAKE_MODE: بيانات كتالوجية، نوع وثيقة، قالب metadata متغير، وتمثيل أولي. الإدخال لا يمنع بسبب نقص البيانات؛ النشر فقط يتطلب اعتمادًا بشريًا.',
          children: [
            Form(
              key: _formKey,
              child: Stepper(
                type: StepperType.vertical,
                currentStep: _currentStep,
                onStepTapped: (step) => setState(() => _currentStep = step),
                onStepCancel: _currentStep == 0
                    ? null
                    : () => setState(() => _currentStep -= 1),
                onStepContinue: _currentStep == 3
                    ? _save
                    : () {
                        if (_currentStep == 0 && !_validateBasics()) return;
                        setState(() => _currentStep += 1);
                      },
                controlsBuilder: (context, details) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        FilledButton.icon(
                          onPressed: details.onStepContinue,
                          icon: Icon(
                            _currentStep == 3
                                ? Icons.save_outlined
                                : Icons.arrow_back_outlined,
                          ),
                          label: Text(
                            _currentStep == 3 ? 'حفظ وثيقة محليًا' : 'التالي',
                          ),
                        ),
                        if (details.onStepCancel != null)
                          OutlinedButton.icon(
                            onPressed: details.onStepCancel,
                            icon: const Icon(Icons.arrow_forward_outlined),
                            label: const Text('السابق'),
                          ),
                        OutlinedButton.icon(
                          onPressed: widget.onOpenDocuments,
                          icon: const Icon(Icons.folder_open_outlined),
                          label: const Text('فتح الوثائق'),
                        ),
                      ],
                    ),
                  );
                },
                steps: [
                  Step(
                    title: const Text('الكتالوج والبيانات الأساسية'),
                    subtitle: const Text(
                        'الكتالوج، نوع الوثيقة، العنوان، المصدر، المرجع'),
                    isActive: _currentStep >= 0,
                    content: _basicFields(),
                  ),
                  Step(
                    title: const Text('التصنيف والإتاحة'),
                    subtitle: const Text(
                        'الإدارة، الموضوع، النوع، السرية، الحالة المكانية'),
                    isActive: _currentStep >= 1,
                    content: _classificationFields(),
                  ),
                  Step(
                    title: const Text('الملف والتمثيل الأولي'),
                    subtitle: const Text('قناة محلية لا تنشئ ملفًا فعليًا'),
                    isActive: _currentStep >= 2,
                    content: _representationFields(),
                  ),
                  Step(
                    title: const Text('وسم التطوير ومنع النشر'),
                    subtitle: const Text(
                        'مسودة أولية؛ لا نشر قبل المراجعة والاعتماد البشري'),
                    isActive: _currentStep >= 3,
                    content: _governedReviewFields(),
                  ),
                ],
              ),
            ),
            if (_lastCreatedId != null) ...[
              const SizedBox(height: 12),
              Card.filled(
                child: ListTile(
                  leading: const Icon(Icons.check_circle_outline),
                  title: const Text('تم إنشاء الوثيقة محليًا'),
                  subtitle: Text(_lastCreatedId!),
                  trailing: OutlinedButton(
                    onPressed: widget.onOpenDocuments,
                    child: const Text('فتح الوثائق'),
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 12),
        const GovernanceWarningCard(),
      ],
    );
  }

  Widget _basicFields() {
    final state = ref.watch(localOperationalProvider);
    final catalogs = state.archiveCatalogs;
    final selectedCatalog = catalogs.firstWhere(
      (catalog) => catalog.id == _catalogId,
      orElse: () => catalogs.isEmpty
          ? const ArchiveCatalog(
              id: 'catalog-general',
              title: 'كتالوج عام',
              periodLabel: 'غير محدد',
              sourceAuthority: 'إدخال محلي',
              languageHints: 'غير محدد',
              description: 'كتالوج عام للمسودات.',
              documentTypeTabIds: ['general-document'],
              colorLabel: 'رمادي',
            )
          : catalogs.first,
    );
    final tabs = state.tabsForCatalog(selectedCatalog.id);
    final selectedTab = tabs.firstWhere(
      (tab) => tab.id == _documentTypeTabId,
      orElse: () => tabs.isEmpty
          ? const CatalogDocumentTypeTab(
              id: 'general-document',
              catalogId: 'catalog-general',
              title: 'وثيقة عامة',
              description: 'نوع وثيقة عام.',
              examples: [],
              metadataHints: [],
            )
          : tabs.first,
    );
    final selectedTemplate = state.templateForDocumentType(selectedTab.id);

    return Column(
      children: [
        // CATALOG_AWARE_INTAKE: intake starts from archive catalog and document-type tab.
        // NO_INTAKE_BLOCKING_GOVERNANCE: fields are captured as draft metadata warnings, not hard blockers.
        _responsivePair(
          DropdownButtonFormField<String>(
            initialValue: selectedCatalog.id,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'كتالوج الأرشيف',
            ),
            items: [
              for (final catalog in catalogs)
                DropdownMenuItem(value: catalog.id, child: Text(catalog.title)),
            ],
            onChanged: (value) {
              if (value == null) return;
              final catalogTabs = state.tabsForCatalog(value);
              setState(() {
                _catalogId = value;
                _documentTypeTabId = catalogTabs.isEmpty
                    ? 'general-document'
                    : catalogTabs.first.id;
                final catalog = catalogs.firstWhere((item) => item.id == value);
                _departmentController.text = catalog.title;
              });
            },
          ),
          DropdownButtonFormField<String>(
            initialValue: selectedTab.id,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'تبويب نوع الوثيقة',
            ),
            items: [
              for (final tab in tabs)
                DropdownMenuItem(value: tab.id, child: Text(tab.title)),
            ],
            onChanged: (value) {
              if (value == null) return;
              final tab = tabs.firstWhere((item) => item.id == value);
              setState(() {
                _documentTypeTabId = value;
                _typeController.text = tab.title;
                _subjectController.text = tab.title;
              });
            },
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _titleController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'عنوان المسودة — يمكن استكماله لاحقًا',
          ),
        ),
        const SizedBox(height: 12),
        _responsivePair(
          TextFormField(
            controller: _sourceController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'مصدر الوثيقة / المرجع الأولي',
            ),
          ),
          TextFormField(
            controller: _referenceController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'رقم أو مرجع الوثيقة — اختياري أثناء التطوير',
            ),
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _dateController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'تاريخ أو وصف زمني',
          ),
        ),
        const SizedBox(height: 12),
        _templateFields(selectedTemplate, selectedTab),
      ],
    );
  }

  // CATALOG_AWARE_METADATA_TEMPLATES: metadata forms change by archive catalog and document type.
  // DYNAMIC_DRAFT_FORM_FIELDS: template fields are draft-only and do not block intake.
  // OTTOMAN_TAPU_DRAFT_FORM + OTTOMAN_WAQF_DEED_DRAFT_FORM + JORDANIAN_REGISTRATION_DRAFT_FORM + PALESTINIAN_SETTLEMENT_DRAFT_FORM.
  Widget _templateFields(
    CatalogMetadataTemplate? template,
    CatalogDocumentTypeTab selectedTab,
  ) {
    final fields = template?.fields ??
        selectedTab.metadataHints
            .map(
              (hint) => MetadataTemplateField(
                key: hint,
                label: hint,
                hint: 'حقل مقترح لهذا النوع — يقبل الفراغ كمسودة',
              ),
            )
            .toList(growable: false);
    return Card.filled(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.view_list_outlined),
              title: Text(template?.title ?? 'قالب metadata مرن'),
              subtitle: Text(
                template?.description ??
                    'حقول metadata مقترحة من تبويب نوع الوثيقة؛ النقص لا يمنع الإدخال في مرحلة التطوير.',
              ),
            ),
            if (template != null) ...[
              const SizedBox(height: 4),
              Text('خطة مساعدة الذكاء الصناعي: ${template.aiAssistancePlan}'),
              const SizedBox(height: 8),
            ],
            for (final field in fields) ...[
              TextFormField(
                controller: _metadataControllerFor(field.key),
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: field.label,
                  helperText: field.hint,
                  suffixText: field.isRecommended ? 'مقترح' : 'اختياري',
                ),
              ),
              const SizedBox(height: 10),
            ],
            const Text(
              'هذه الحقول مسودة تطويرية: يمكن تركها ناقصة الآن، ولا تصبح قابلة للنشر إلا بعد مراجعة واعتماد بشري.',
            ),
          ],
        ),
      ),
    );
  }

  TextEditingController _metadataControllerFor(String key) {
    return _metadataControllers.putIfAbsent(
      key,
      () => TextEditingController(),
    );
  }

  Map<String, String> _metadataValuesFor(CatalogMetadataTemplate? template) {
    final fieldKeys = template == null
        ? _metadataControllers.keys.toList(growable: false)
        : template.fields.map((field) => field.key).toList(growable: false);
    return {
      for (final key in fieldKeys)
        key: _metadataControllers[key]?.text.trim() ?? '',
    };
  }

  Widget _classificationFields() {
    return Column(
      children: [
        _responsiveTriple(
          TextFormField(
            controller: _departmentController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'الإدارة',
            ),
          ),
          TextFormField(
            controller: _subjectController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'الموضوع',
            ),
          ),
          TextFormField(
            controller: _typeController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'نوع الوثيقة',
            ),
          ),
        ),
        const SizedBox(height: 12),
        _responsiveTriple(
          DropdownButtonFormField<EvidenceDomain>(
            initialValue: _domain,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'المجال',
            ),
            items: [
              for (final value in EvidenceDomain.values)
                DropdownMenuItem(value: value, child: Text(value.label)),
            ],
            onChanged: (value) {
              if (value != null) setState(() => _domain = value);
            },
          ),
          DropdownButtonFormField<AccessLevel>(
            initialValue: _accessLevel,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'مستوى الإتاحة',
            ),
            items: [
              for (final value in AccessLevel.values)
                DropdownMenuItem(value: value, child: Text(value.label)),
            ],
            onChanged: (value) {
              if (value != null) setState(() => _accessLevel = value);
            },
          ),
          DropdownButtonFormField<SpatialStatus>(
            initialValue: _spatialStatus,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'الحالة المكانية',
            ),
            items: [
              for (final value in SpatialStatus.values)
                DropdownMenuItem(value: value, child: Text(value.label)),
            ],
            onChanged: (value) {
              if (value != null) setState(() => _spatialStatus = value);
            },
          ),
        ),
        const SizedBox(height: 12),
        _responsivePair(
          TextFormField(
            controller: _assetController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'waqf_asset_id مستقبلي اختياري',
            ),
          ),
          TextFormField(
            controller: _caseController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'case_id اختياري',
            ),
          ),
        ),
      ],
    );
  }

  Widget _representationFields() {
    return Column(
      children: [
        SwitchListTile(
          value: _hasOriginal,
          title: const Text('الأصل متوفر محليًا'),
          subtitle:
              const Text('لا يتم حفظ ملف فعلي؛ يتم إنشاء تمثيل metadata فقط.'),
          onChanged: (value) => setState(() => _hasOriginal = value),
        ),
        SwitchListTile(
          value: _createRepresentation,
          title: const Text('إنشاء تمثيل أولي'),
          subtitle:
              const Text('ينشئ ArchiveRepresentation محليًا مع hash وهمي.'),
          onChanged: (value) => setState(() => _createRepresentation = value),
        ),
        TextFormField(
          controller: _keywordsController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'كلمات مفتاحية مفصولة بفواصل',
          ),
        ),
      ],
    );
  }

  Widget _governedReviewFields() {
    return Column(
      children: [
        _responsivePair(
          TextFormField(
            controller: _rightsController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'حالة الحقوق',
            ),
          ),
          TextFormField(
            controller: _sensitivityController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'الحساسية القانونية/الإدارية',
            ),
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _workflowNoteController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'ملاحظة دورة العمل',
          ),
          maxLines: 2,
        ),
        SwitchListTile(
          value: _submitForReview,
          title: const Text('تعليمها بحاجة مراجعة لاحقًا'),
          subtitle: const Text(
              'في هذه المرحلة يبقى الإدخال مسودة، ولا يوجد نشر قبل اعتماد بشري.'),
          onChanged: (value) => setState(() => _submitForReview = value),
        ),
      ],
    );
  }

  Widget _responsivePair(Widget first, Widget second) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 760) {
          return Column(
            children: [first, const SizedBox(height: 12), second],
          );
        }
        return Row(
          children: [
            Expanded(child: first),
            const SizedBox(width: 12),
            Expanded(child: second),
          ],
        );
      },
    );
  }

  Widget _responsiveTriple(Widget first, Widget second, Widget third) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 900) {
          return Column(
            children: [
              first,
              const SizedBox(height: 12),
              second,
              const SizedBox(height: 12),
              third,
            ],
          );
        }
        return Row(
          children: [
            Expanded(child: first),
            const SizedBox(width: 12),
            Expanded(child: second),
            const SizedBox(width: 12),
            Expanded(child: third),
          ],
        );
      },
    );
  }

  bool _validateBasics() {
    return _formKey.currentState?.validate() ?? false;
  }

  void _save() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      setState(() => _currentStep = 0);
      return;
    }
    if (!requireLocalCapability(
      context,
      ref,
      capability: ArchiveCapability.evidenceCreateLocalDraft,
      actionLabel: 'إنشاء وثيقة بتدفق محكوم',
    )) {
      return;
    }

    final state = ref.read(localOperationalProvider);
    final selectedCatalog = state.archiveCatalogs.firstWhere(
      (catalog) => catalog.id == _catalogId,
      orElse: () => state.archiveCatalogs.first,
    );
    final tabs = state.tabsForCatalog(selectedCatalog.id);
    final selectedTab = tabs.firstWhere(
      (tab) => tab.id == _documentTypeTabId,
      orElse: () => tabs.first,
    );
    final selectedTemplate = state.templateForDocumentType(selectedTab.id);
    final templateValues = _metadataValuesFor(selectedTemplate);
    final missingWarnings = selectedTemplate == null
        ? const <String>[]
        : [
            for (final field in selectedTemplate.fields)
              if (field.isRecommended &&
                  (templateValues[field.key] == null ||
                      templateValues[field.key]!.isEmpty))
                'ينقص الحقل المقترح: ${field.label}',
          ];
    // createGovernedDocumentDraft remains supported; now it carries catalog-aware metadata template drafts.
    final id =
        ref.read(localOperationalProvider.notifier).createGovernedDocumentDraft(
              title: _titleController.text,
              sourceAuthority: _sourceController.text,
              reference: _referenceController.text,
              domain: _domain,
              accessLevel: _accessLevel,
              spatialStatus: _spatialStatus,
              dateLabel: _dateController.text,
              rightsStatus: _rightsController.text,
              legalSensitivity: _sensitivityController.text,
              departmentLabel: _departmentController.text,
              subjectLabel: _subjectController.text,
              documentType: _typeController.text,
              keywords: _keywordsController.text.split(RegExp(r'[,،]')),
              hasOriginal: _hasOriginal,
              createInitialRepresentation: _createRepresentation,
              submitForReview: _submitForReview,
              linkedWaqfAssetId: _assetController.text,
              linkedCaseId: _caseController.text,
              workflowNote: _workflowNoteController.text,
              catalogId: selectedCatalog.id,
              catalogTitle: selectedCatalog.title,
              documentTypeTabId: selectedTab.id,
              documentTypeTabTitle: selectedTab.title,
              metadataTemplateId:
                  selectedTemplate?.id ?? selectedTab.metadataTemplateId,
              structuredMetadata: templateValues,
              missingMetadataWarnings: missingWarnings,
              templateReadinessLabel: missingWarnings.isEmpty
                  ? 'قالب مكتمل مبدئيًا — بانتظار مراجعة بشرية قبل النشر'
                  : 'قالب ناقص مقبول كمسودة تطويرية',
              aiAssistancePlan: selectedTemplate?.aiAssistancePlan ??
                  'AI_ASSISTED_METADATA_DRAFTING_READY — OCR/Translation/Entity extraction لاحقًا',
            );

    setState(() {
      _lastCreatedId = id;
      _currentStep = 0;
      _titleController.clear();
      _assetController.clear();
      _caseController.clear();
      for (final controller in _metadataControllers.values) {
        controller.clear();
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('تم إنشاء مسودة أرشيفية محلية: $id')),
    );
  }
}
