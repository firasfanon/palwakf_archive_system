import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/models.dart';
import '../../core/state/local_operational_store.dart';
import '../../shared/widgets.dart';

class ArchiveCatalogsScreen extends ConsumerStatefulWidget {
  const ArchiveCatalogsScreen({
    this.initialCatalogId,
    super.key,
  });

  final String? initialCatalogId;

  @override
  ConsumerState<ArchiveCatalogsScreen> createState() =>
      _ArchiveCatalogsScreenState();
}

class _ArchiveCatalogsScreenState extends ConsumerState<ArchiveCatalogsScreen> {
  // LAYERED_ARCHIVE_CATALOGS: the archive is organized as source/period catalogs.
  // OPEN_DRAFT_INTAKE_MODE: all intake in the current development phase is draft-only.
  // NO_INTAKE_BLOCKING_GOVERNANCE: governance labels risks but does not block development intake.
  // PUBLICATION_REQUIRES_HUMAN_APPROVAL: publication remains blocked until human review.
  // CATALOG_ROOM_EXPERIENCE: each catalog renders as a visual room with
  // distinct source/period identity, document-type tabs, draft intake, and search entry points.
  String? _selectedCatalogId;
  String? _selectedTabId;
  final _titleController = TextEditingController();
  final _referenceController = TextEditingController();
  final _sourceController = TextEditingController(text: 'إدخال تطويري مفتوح');
  final _dateController = TextEditingController(text: 'غير محدد');
  final _notesController = TextEditingController(
    text:
        'أدخل كل شيء للتطوير والفهم وبناء الواجهات. لا تنشر شيئًا قبل المراجعة والاعتماد البشري.',
  );
  bool _createDraftRepresentation = true;
  String? _lastCreatedId;

  @override
  void initState() {
    super.initState();
    _selectedCatalogId = widget.initialCatalogId;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _referenceController.dispose();
    _sourceController.dispose();
    _dateController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(localOperationalProvider);
    final catalogs = state.archiveCatalogs;
    final selectedCatalog = _catalogOrDefault(catalogs);
    final tabs = state.tabsForCatalog(selectedCatalog.id);
    final selectedTab = _tabOrDefault(tabs);
    final selectedTemplate = state.templateForDocumentType(selectedTab.id);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _CatalogExperienceHero(catalog: selectedCatalog, tab: selectedTab),
        const SizedBox(height: 12),
        _PremiumCatalogRoomAtmospherePanel(
          catalog: selectedCatalog,
          tab: selectedTab,
          template: selectedTemplate,
        ),
        const SizedBox(height: 12),
        const LocalOnlyBanner(),
        const SizedBox(height: 12),
        _OpenDraftPolicyBanner(),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            MetricTile(
              icon: Icons.menu_book_outlined,
              label: 'كتالوجات مصدرية',
              value: '${state.layeredArchiveCatalogCount}',
            ),
            MetricTile(
              icon: Icons.tab_outlined,
              label: 'تبويبات أنواع وثائق',
              value: '${state.catalogDocumentTypeTabCount}',
            ),
            MetricTile(
              icon: Icons.view_list_outlined,
              label: 'قوالب Metadata',
              value: '${state.catalogMetadataTemplateCount}',
            ),
            MetricTile(
              icon: Icons.edit_note_outlined,
              label: 'مسودات مفتوحة',
              value: '${state.openDraftMaterialCount}',
            ),
            MetricTile(
              icon: Icons.no_accounts_outlined,
              label: 'النشر المحجوب',
              value: '${state.publicationBlockedUntilHumanApprovalCount}',
            ),
          ],
        ),
        const SizedBox(height: 16),
        SectionCard(
          icon: Icons.account_tree_outlined,
          title: 'طبقات الأرشيف المصدرية',
          subtitle:
              'CATALOG_DOCUMENT_TYPE_TABS: كل كتالوج يمثل طبقة مصدرية/حقبية وبداخله تبويبات لأنواع الوثائق. الإدخال مفتوح كمسودات فقط.',
          children: [
            _CatalogGrid(
              catalogs: catalogs,
              selectedCatalogId: selectedCatalog.id,
              draftCountForCatalog: state.openDraftCountForCatalog,
              onSelect: (catalog) => setState(() {
                _selectedCatalogId = catalog.id;
                final catalogTabs = state.tabsForCatalog(catalog.id);
                _selectedTabId =
                    catalogTabs.isEmpty ? null : catalogTabs.first.id;
              }),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SectionCard(
          icon: Icons.tab_outlined,
          title: '${selectedCatalog.title} — تبويبات أنواع الوثائق',
          subtitle:
              'CATALOG_AWARE_INTAKE: اختر نوع الوثيقة، ثم أدخل مادة كمسودة أولية قابلة للصور والترجمة والتفريغ والربط اللاحق.',
          children: [
            _PremiumDocumentTypeGallery(
              tabs: tabs,
              selectedTabId: selectedTab.id,
              onSelect: (tab) => setState(() => _selectedTabId = tab.id),
            ),
            const SizedBox(height: 12),
            _CatalogRoomEvidenceStudio(tab: selectedTab),
          ],
        ),
        const SizedBox(height: 16),
        SectionCard(
          icon: Icons.view_list_outlined,
          title: 'قالب metadata لهذا النوع',
          subtitle:
              'CATALOG_AWARE_METADATA_TEMPLATES: كل نوع وثيقة يملك حقولًا مقترحة تساعدنا على بناء واجهات الإدخال حسب الوثائق الفعلية.',
          children: [
            if (selectedTemplate == null)
              const Text(
                  'لا يوجد قالب مخصص بعد؛ سيتم استخدام الحقول العامة كمسودة.')
            else
              _MetadataTemplatePreview(template: selectedTemplate),
            const SizedBox(height: 12),
            _CatalogRoomMetadataReadinessPanel(
              tab: selectedTab,
              template: selectedTemplate,
            ),
          ],
        ),
        const SizedBox(height: 16),
        SectionCard(
          icon: Icons.note_add_outlined,
          title: 'إدخال مسودة من هذا النوع',
          subtitle:
              'OPEN_DRAFT_ARCHIVE_MATERIAL_CREATION: لا نمنع الإدخال بسبب نقص البيانات في مرحلة التطوير؛ نوسم النواقص ونمنع النشر فقط.',
          children: [
            _DraftIntakeForm(
              catalog: selectedCatalog,
              tab: selectedTab,
              titleController: _titleController,
              sourceController: _sourceController,
              referenceController: _referenceController,
              dateController: _dateController,
              notesController: _notesController,
              createDraftRepresentation: _createDraftRepresentation,
              onCreateDraftRepresentationChanged: (value) => setState(
                () => _createDraftRepresentation = value,
              ),
              onSave: () => _saveDraft(selectedCatalog, selectedTab),
            ),
            if (_lastCreatedId != null) ...[
              const SizedBox(height: 12),
              Card.filled(
                child: ListTile(
                  leading: const Icon(Icons.check_circle_outline),
                  title: const Text('تم حفظ مسودة أرشيفية مفتوحة'),
                  subtitle: Text(_lastCreatedId!),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 16),
        SectionCard(
          icon: Icons.manage_search_outlined,
          title: 'مداخل البحث الطبقي',
          subtitle:
              'CATALOG_SEARCH_ENTRY_POINTS: البحث يجب أن يدعم كل الأرشيف، كتالوجًا محددًا، نوع وثيقة، ترجمة، تفريغ، OCR، مكانًا، وقفًا، أو قضية.',
          children: const [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip(label: Text('بحث عبر كل الأرشيف')),
                Chip(label: Text('بحث داخل كتالوج')),
                Chip(label: Text('بحث داخل نوع وثيقة')),
                Chip(label: Text('بحث داخل الترجمة')),
                Chip(label: Text('بحث داخل OCR')),
                Chip(label: Text('بحث حسب المكان/الوقف')),
              ],
            ),
          ],
        ),
      ],
    );
  }

  ArchiveCatalog _catalogOrDefault(List<ArchiveCatalog> catalogs) {
    if (catalogs.isEmpty) {
      return const ArchiveCatalog(
        id: 'catalog-empty',
        title: 'كتالوج غير مهيأ',
        periodLabel: 'غير محدد',
        sourceAuthority: 'غير محدد',
        languageHints: 'غير محدد',
        description: 'لا توجد كتالوجات بعد.',
        documentTypeTabIds: [],
        colorLabel: 'رمادي',
      );
    }
    final selectedId = _selectedCatalogId;
    return catalogs.firstWhere(
      (catalog) => catalog.id == selectedId,
      orElse: () => catalogs.first,
    );
  }

  CatalogDocumentTypeTab _tabOrDefault(List<CatalogDocumentTypeTab> tabs) {
    if (tabs.isEmpty) {
      return const CatalogDocumentTypeTab(
        id: 'tab-empty',
        catalogId: 'catalog-empty',
        title: 'نوع غير مهيأ',
        description: 'لا توجد تبويبات أنواع وثائق بعد.',
        examples: [],
        metadataHints: [],
      );
    }
    final selectedId = _selectedTabId;
    return tabs.firstWhere(
      (tab) => tab.id == selectedId,
      orElse: () => tabs.first,
    );
  }

  void _saveDraft(ArchiveCatalog catalog, CatalogDocumentTypeTab tab) {
    final template =
        ref.read(localOperationalProvider).templateForDocumentType(tab.id);
    final id = ref
        .read(localOperationalProvider.notifier)
        .createOpenDraftArchiveMaterial(
          catalogId: catalog.id,
          catalogTitle: catalog.title,
          documentTypeTabId: tab.id,
          documentTypeTabTitle: tab.title,
          title: _titleController.text,
          sourceAuthority: _sourceController.text,
          reference: _referenceController.text,
          dateLabel: _dateController.text,
          languageHint: catalog.languageHints,
          notes: _notesController.text,
          metadataTemplateId: template?.id ?? tab.metadataTemplateId,
          structuredMetadata: {
            if (template != null)
              for (final field in template.fields) field.key: '',
          },
          missingMetadataWarnings: [
            if (template != null)
              for (final field in template.fields)
                if (field.isRecommended) 'ينقص الحقل المقترح: ${field.label}',
          ],
          templateReadinessLabel: 'قالب مفتوح كمسودة — لا يمنع الإدخال',
          aiAssistancePlan: template?.aiAssistancePlan ??
              'AI_ASSISTED_METADATA_DRAFTING_READY',
          createDraftRepresentation: _createDraftRepresentation,
        );
    setState(() {
      _lastCreatedId = id;
      _titleController.clear();
      _referenceController.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('تم إدخال مسودة أرشيفية: $id')),
    );
  }
}

class _OpenDraftPolicyBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card.filled(
      child: ListTile(
        leading: const Icon(Icons.edit_note_outlined),
        title: const Text('أدخل كل شيء للتطوير والفهم وبناء الواجهات'),
        subtitle: const Text(
          'كل مادة تدخل كمسودة أولية. النشر والإتاحة العامة ممنوعان قبل المراجعة والاعتماد البشري.',
        ),
        trailing: const Chip(label: Text('Open Draft Intake')),
      ),
    );
  }
}

class _CatalogExperienceHero extends StatelessWidget {
  const _CatalogExperienceHero({required this.catalog, required this.tab});

  final ArchiveCatalog catalog;
  final CatalogDocumentTypeTab tab;

  @override
  Widget build(BuildContext context) {
    // CATALOG_DISTINCT_VISUAL_THEMES: Ottoman, British, Jordanian, and Palestinian
    // catalog rooms receive distinct color accents and archival visual language.
    final palette = _CatalogPalette.forCatalog(catalog.id);
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [palette.primary, palette.secondary],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.10),
              blurRadius: 28,
              offset: const Offset(0, 14)),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final narrow = constraints.maxWidth < 840;
          final text = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: const [
                  Chip(label: Text('غرفة كتالوج أرشيفية')),
                  Chip(label: Text('مسودات أولية')),
                  Chip(label: Text('مراجعة بشرية قبل النشر')),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                catalog.title,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
              ),
              const SizedBox(height: 6),
              Text(
                '${catalog.periodLabel} — ${catalog.sourceAuthority}',
                style: const TextStyle(
                    color: Colors.white70, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 14),
              Text(
                catalog.description,
                style: const TextStyle(color: Colors.white, height: 1.6),
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  Chip(label: Text('النوع الحالي: ${tab.title}')),
                  Chip(label: Text('اللغة: ${catalog.languageHints}')),
                  Chip(label: Text('الهوية: ${catalog.colorLabel}')),
                ],
              ),
            ],
          );
          final visual = _CatalogRoomVisual(
              icon: palette.icon, accent: palette.accent, label: palette.label);
          if (narrow) {
            return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [text, const SizedBox(height: 18), visual]);
          }
          return Row(children: [
            Expanded(child: text),
            const SizedBox(width: 22),
            SizedBox(width: 300, child: visual)
          ]);
        },
      ),
    );
  }
}

class _CatalogRoomVisual extends StatelessWidget {
  const _CatalogRoomVisual(
      {required this.icon, required this.accent, required this.label});

  final IconData icon;
  final Color accent;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 210,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
      ),
      child: Stack(
        children: [
          Align(
              alignment: Alignment.topLeft,
              child: Icon(icon, color: accent, size: 64)),
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 170,
              height: 118,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.description_outlined, color: accent, size: 42),
                  const SizedBox(height: 8),
                  Text(label,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w900)),
                ],
              ),
            ),
          ),
          const Align(
            alignment: Alignment.bottomRight,
            child: Text('وثيقة • مكان • زمن • وقف',
                style: TextStyle(color: Colors.white70)),
          ),
        ],
      ),
    );
  }
}

class _CatalogPalette {
  const _CatalogPalette(
      this.primary, this.secondary, this.accent, this.icon, this.label);

  final Color primary;
  final Color secondary;
  final Color accent;
  final IconData icon;
  final String label;

  static _CatalogPalette forCatalog(String id) {
    if (id.contains('ottoman')) {
      return const _CatalogPalette(Color(0xFF4B2E16), Color(0xFF0E6A4D),
          Color(0xFFD7A83C), Icons.history_edu_outlined, 'ختم ودفتر');
    }
    if (id.contains('british')) {
      return const _CatalogPalette(Color(0xFF21364A), Color(0xFF6E7C84),
          Color(0xFFD6C7A1), Icons.public_outlined, 'خريطة ومساحة');
    }
    if (id.contains('jordanian')) {
      return const _CatalogPalette(Color(0xFF273C2B), Color(0xFF8B6F3F),
          Color(0xFFF0D58B), Icons.account_balance_outlined, 'شهادة تسجيل');
    }
    if (id.contains('palestinian')) {
      return const _CatalogPalette(Color(0xFF073F31), Color(0xFF8A1E1E),
          Color(0xFFFFFFFF), Icons.flag_outlined, 'تسوية وقرار');
    }
    return const _CatalogPalette(Color(0xFF073F31), Color(0xFF2B2118),
        Color(0xFFC79A35), Icons.menu_book_outlined, 'كتالوج');
  }
}

class _PremiumCatalogRoomAtmospherePanel extends StatelessWidget {
  const _PremiumCatalogRoomAtmospherePanel({
    required this.catalog,
    required this.tab,
    required this.template,
  });

  final ArchiveCatalog catalog;
  final CatalogDocumentTypeTab tab;
  final CatalogMetadataTemplate? template;

  @override
  Widget build(BuildContext context) {
    // CATALOG_ROOMS_PREMIUM_UI
// DOCUMENT_TYPE_UNUSED_CLASS_CLEANUP: catalog pages become archive rooms, not administrative lists.
    // CATALOG_ROOM_ATMOSPHERE_PANEL: each room shows source era, authority, document language, and review posture.
    final palette = _CatalogPalette.forCatalog(catalog.id);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: palette.accent.withValues(alpha: 0.32)),
        boxShadow: [
          BoxShadow(
            color: palette.primary.withValues(alpha: 0.08),
            blurRadius: 30,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final narrow = constraints.maxWidth < 820;
          final facts = _CatalogRoomFactStrip(
              catalog: catalog, tab: tab, template: template);
          final map = _CatalogRoomLayerMap(palette: palette);
          if (narrow) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [facts, const SizedBox(height: 14), map],
            );
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: facts),
              const SizedBox(width: 18),
              SizedBox(width: 330, child: map)
            ],
          );
        },
      ),
    );
  }
}

class _CatalogRoomFactStrip extends StatelessWidget {
  const _CatalogRoomFactStrip(
      {required this.catalog, required this.tab, required this.template});

  final ArchiveCatalog catalog;
  final CatalogDocumentTypeTab tab;
  final CatalogMetadataTemplate? template;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'غرفة ${catalog.title}',
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 6),
        Text(
          'CATALOG_ROOMS_PREMIUM_UI: هذه ليست قائمة وثائق؛ إنها غرفة مصدرية تعرض الحقبة، نوع المادة، مسار التحقيق، وموانع النشر.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.6),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _RoomFactChip(
                icon: Icons.schedule_outlined, label: catalog.periodLabel),
            _RoomFactChip(
                icon: Icons.account_balance_outlined,
                label: catalog.sourceAuthority),
            _RoomFactChip(
                icon: Icons.translate_outlined, label: catalog.languageHints),
            _RoomFactChip(icon: Icons.article_outlined, label: tab.title),
            _RoomFactChip(
                icon: Icons.fact_check_outlined,
                label: template?.title ?? 'قالب عام'),
          ],
        ),
      ],
    );
  }
}

class _RoomFactChip extends StatelessWidget {
  const _RoomFactChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 18),
      label: Text(label),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
    );
  }
}

class _CatalogRoomLayerMap extends StatelessWidget {
  const _CatalogRoomLayerMap({required this.palette});

  final _CatalogPalette palette;

  @override
  Widget build(BuildContext context) {
    // ARCHIVE_ROOM_LAYER_MAP: document image, OCR, transcription, translation, metadata, place, and waqf are shown as one investigation stack.
    const stages = [
      'وثيقة أصلية',
      'تمثيل رقمي',
      'OCR / تفريغ',
      'ترجمة',
      'Metadata',
      'مكان / وقف',
      'مراجعة بشرية',
    ];
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            palette.primary.withValues(alpha: 0.12),
            palette.accent.withValues(alpha: 0.10),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.layers_outlined, color: palette.primary),
              const SizedBox(width: 8),
              Text('خريطة طبقات التحقيق',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(fontWeight: FontWeight.w900)),
            ],
          ),
          const SizedBox(height: 12),
          for (final stage in stages) ...[
            Row(
              children: [
                Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                        color: palette.accent, shape: BoxShape.circle)),
                const SizedBox(width: 8),
                Expanded(
                    child: Text(stage,
                        maxLines: 1, overflow: TextOverflow.ellipsis)),
              ],
            ),
            if (stage != stages.last)
              Padding(
                padding: const EdgeInsetsDirectional.only(start: 4),
                child: Container(
                    width: 2,
                    height: 12,
                    color: palette.primary.withValues(alpha: 0.25)),
              ),
          ],
        ],
      ),
    );
  }
}

class _PremiumDocumentTypeGallery extends StatelessWidget {
  const _PremiumDocumentTypeGallery(
      {required this.tabs,
      required this.selectedTabId,
      required this.onSelect});

  final List<CatalogDocumentTypeTab> tabs;
  final String selectedTabId;
  final ValueChanged<CatalogDocumentTypeTab> onSelect;

  @override
  Widget build(BuildContext context) {
    // DOCUMENT_TYPE_PREMIUM_GALLERY: document types are shown as workbenches with supported layers.
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        for (final tab in tabs)
          _PremiumDocumentTypeCard(
            tab: tab,
            selected: tab.id == selectedTabId,
            onSelect: () => onSelect(tab),
          ),
      ],
    );
  }
}

class _PremiumDocumentTypeCard extends StatelessWidget {
  const _PremiumDocumentTypeCard(
      {required this.tab, required this.selected, required this.onSelect});

  final CatalogDocumentTypeTab tab;
  final bool selected;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    final color = selected ? const Color(0xFF073F31) : const Color(0xFF5E4A2A);
    return SizedBox(
      width: 320,
      child: InkWell(
        onTap: onSelect,
        borderRadius: BorderRadius.circular(22),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFF4E9CF) : Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
                color: selected
                    ? const Color(0xFFC79A35)
                    : const Color(0xFFE7DCC3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: color.withValues(alpha: 0.12),
                    child: Icon(Icons.article_outlined, color: color),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      tab.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w900, color: color),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(tab.description,
                  maxLines: 3, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 12),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  if (tab.supportsImages) const Chip(label: Text('صورة')),
                  if (tab.supportsOcr) const Chip(label: Text('OCR')),
                  if (tab.supportsTranscription)
                    const Chip(label: Text('تفريغ')),
                  if (tab.supportsTranslation) const Chip(label: Text('ترجمة')),
                  if (tab.supportsSpatialLink) const Chip(label: Text('مكان')),
                ],
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: onSelect,
                icon: const Icon(Icons.table_rows_outlined),
                label: const Text('فتح منضدة النوع'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CatalogRoomEvidenceStudio extends StatelessWidget {
  const _CatalogRoomEvidenceStudio({required this.tab});

  final CatalogDocumentTypeTab tab;

  @override
  Widget build(BuildContext context) {
    // CATALOG_ROOM_EVIDENCE_STUDIO: each selected document type exposes the actual investigation benches before intake.
    final benches = <({IconData icon, String title, String body})>[
      (
        icon: Icons.image_outlined,
        title: 'عارض الأصل والتمثيلات',
        body: tab.supportsImages
            ? 'جاهز للصور والمسح والنسخ المشتقة.'
            : 'تمثيلات محدودة لهذا النوع.'
      ),
      (
        icon: Icons.text_fields_outlined,
        title: 'منضدة القراءة',
        body: tab.supportsOcr
            ? 'OCR مسودة + تفريغ بشري لاحق.'
            : 'قراءة يدوية فقط.'
      ),
      (
        icon: Icons.translate_outlined,
        title: 'منضدة الترجمة',
        body: tab.supportsTranslation
            ? 'ترجمة مسودة لا تعتمد إلا بعد تدقيق.'
            : 'لا توجد ترجمة افتراضية.'
      ),
      (
        icon: Icons.map_outlined,
        title: 'منضدة المكان والوقف',
        body: tab.supportsSpatialLink
            ? 'جاهز للحوض/القطعة/الخريطة.'
            : 'ربط مكاني لاحق عند توفر دليل.'
      ),
    ];
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        for (final bench in benches)
          SizedBox(
            width: 250,
            child: Card.filled(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(bench.icon),
                    const SizedBox(height: 8),
                    Text(bench.title,
                        style: const TextStyle(fontWeight: FontWeight.w900)),
                    const SizedBox(height: 4),
                    Text(bench.body,
                        maxLines: 3, overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _CatalogRoomMetadataReadinessPanel extends StatelessWidget {
  const _CatalogRoomMetadataReadinessPanel(
      {required this.tab, required this.template});

  final CatalogDocumentTypeTab tab;
  final CatalogMetadataTemplate? template;

  @override
  Widget build(BuildContext context) {
    // CATALOG_METADATA_PREMIUM_FORM_RAIL: the template appears as a form rail, not a plain chip list.
    final fields = template?.fields ?? const <MetadataTemplateField>[];
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFAEF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE6D6B2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('سكة نموذج الإدخال: ${tab.title}',
              style: const TextStyle(fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          if (fields.isEmpty)
            const Text('لا يوجد قالب مفصل بعد؛ الإدخال مسودة مفتوحة.')
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final field in fields)
                  Chip(
                    avatar: Icon(
                        field.isRecommended
                            ? Icons.star_outline
                            : Icons.info_outline,
                        size: 18),
                    label: Text(field.label),
                  ),
              ],
            ),
          const SizedBox(height: 8),
          const Text(
              'الحقول الناقصة تنتج تحذيرًا ولا تمنع الإدخال. النشر يبقى محجوبًا.'),
        ],
      ),
    );
  }
}

class _CatalogGrid extends StatelessWidget {
  const _CatalogGrid({
    required this.catalogs,
    required this.selectedCatalogId,
    required this.draftCountForCatalog,
    required this.onSelect,
  });

  final List<ArchiveCatalog> catalogs;
  final String selectedCatalogId;
  final int Function(String catalogId) draftCountForCatalog;
  final ValueChanged<ArchiveCatalog> onSelect;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        for (final catalog in catalogs)
          SizedBox(
            width: 280,
            child: Card(
              color: catalog.id == selectedCatalogId
                  ? Theme.of(context).colorScheme.primaryContainer
                  : null,
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          child: Icon(_iconForCatalog(catalog.id)),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            catalog.title,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(catalog.periodLabel),
                    const SizedBox(height: 4),
                    Text(catalog.description,
                        maxLines: 3, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        Chip(
                            label: Text(
                                '${catalog.documentTypeTabIds.length} أنواع وثائق')),
                        Chip(
                            label: Text(
                                '${draftCountForCatalog(catalog.id)} مسودات')),
                        Chip(label: Text(catalog.languageHints)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    FilledButton.tonalIcon(
                      onPressed: () => onSelect(catalog),
                      icon: const Icon(Icons.open_in_new_outlined),
                      label: const Text('فتح الكتالوج'),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  IconData _iconForCatalog(String id) {
    if (id.contains('ottoman')) return Icons.history_edu_outlined;
    if (id.contains('british')) return Icons.public_outlined;
    if (id.contains('jordanian')) return Icons.account_balance_outlined;
    if (id.contains('palestinian')) return Icons.flag_outlined;
    return Icons.menu_book_outlined;
  }
}

class _MetadataTemplatePreview extends StatelessWidget {
  const _MetadataTemplatePreview({required this.template});

  final CatalogMetadataTemplate template;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.fact_check_outlined),
          title: Text(template.title),
          subtitle: Text(template.description),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final field in template.fields) Chip(label: Text(field.label)),
          ],
        ),
        const SizedBox(height: 8),
        Text(
            'AI_ASSISTED_METADATA_DRAFTING_READY: ${template.aiAssistancePlan}'),
        const SizedBox(height: 4),
        const Text(
            'PUBLICATION_REQUIRES_HUMAN_APPROVAL: لا تعتمد هذه القيم للنشر إلا بعد مراجعة بشرية.'),
      ],
    );
  }
}

class _DraftIntakeForm extends StatelessWidget {
  const _DraftIntakeForm({
    required this.catalog,
    required this.tab,
    required this.titleController,
    required this.sourceController,
    required this.referenceController,
    required this.dateController,
    required this.notesController,
    required this.createDraftRepresentation,
    required this.onCreateDraftRepresentationChanged,
    required this.onSave,
  });

  final ArchiveCatalog catalog;
  final CatalogDocumentTypeTab tab;
  final TextEditingController titleController;
  final TextEditingController sourceController;
  final TextEditingController referenceController;
  final TextEditingController dateController;
  final TextEditingController notesController;
  final bool createDraftRepresentation;
  final ValueChanged<bool> onCreateDraftRepresentationChanged;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            Chip(label: Text(catalog.title)),
            Chip(label: Text(tab.title)),
            const Chip(label: Text('مسودة أولية')),
            const Chip(label: Text('النشر يتطلب اعتمادًا بشريًا')),
          ],
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            final narrow = constraints.maxWidth < 760;
            final fields = [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'عنوان المسودة — يمكن تركه فارغًا مؤقتًا',
                ),
              ),
              TextField(
                controller: sourceController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'المصدر / المرجع الأولي',
                ),
              ),
              TextField(
                controller: referenceController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'رقم أو كود مرجعي اختياري',
                ),
              ),
              TextField(
                controller: dateController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'تاريخ أو حقبة تقريبية',
                ),
              ),
            ];
            if (narrow) {
              return Column(
                children: [
                  for (final field in fields) ...[
                    field,
                    const SizedBox(height: 12)
                  ],
                ],
              );
            }
            return Column(
              children: [
                Row(children: [
                  Expanded(child: fields[0]),
                  const SizedBox(width: 12),
                  Expanded(child: fields[1])
                ]),
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(child: fields[2]),
                  const SizedBox(width: 12),
                  Expanded(child: fields[3])
                ]),
              ],
            );
          },
        ),
        TextField(
          controller: notesController,
          maxLines: 3,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'ملاحظات التطوير/الترجمة/التفريغ/الربط',
          ),
        ),
        SwitchListTile(
          value: createDraftRepresentation,
          title: const Text('إنشاء تمثيل مسودة مبدئي'),
          subtitle: const Text(
              'DRAFT_REPRESENTATIONS_ALLOWED: صور، OCR، ترجمة، تفريغ، وملاحظات كمادة تطويرية.'),
          onChanged: onCreateDraftRepresentationChanged,
        ),
        FilledButton.icon(
          onPressed: onSave,
          icon: const Icon(Icons.save_outlined),
          label: const Text('حفظ مسودة أرشيفية'),
        ),
      ],
    );
  }
}
