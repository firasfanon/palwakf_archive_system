import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'features/access/access_publication_retention_audit_screen.dart';
import 'features/activity/activity_screen.dart';
import 'features/admin/admin_governance_console_screen.dart';
import 'features/catalogs/archive_catalogs_screen.dart';
import 'features/daily/add_document_screen.dart';
import 'features/daily/archiving_steps_screen.dart';
import 'features/daily/daily_archive_home_screen.dart';
import 'features/daily/document_classification_screen.dart';
import 'features/daily/document_lifecycle_screen.dart';
import 'features/daily/document_metadata_screen.dart';
import 'features/daily/permissions_model_screen.dart';
import 'features/daily/security_backup_screen.dart';
import 'features/daily/smart_search_mechanism_screen.dart';
import 'features/daily/technical_blueprint_screen.dart';
import 'features/daily/upload_storage_screen.dart';
import 'features/dashboard/operations_dashboard_screen.dart';
import 'features/evidence/evidence_explorer_screen.dart';
import 'features/governance/platform_integration_readiness_screen.dart';
import 'features/public/public_archive_landing_screen.dart';
import 'features/reading/ottoman_english_document_assistant_screen.dart';
import 'features/imports/import_catalog_screen.dart';
import 'features/registry/evidence_registry_screen.dart';
import 'features/reports/reports_notifications_screen.dart';
import 'features/representations/representations_screen.dart';
import 'features/review/review_queue_screen.dart';
import 'features/search/search_discovery_screen.dart';
import 'features/smart_indexing/smart_indexing_screen.dart';
import 'features/spatial/spatial_readiness_screen.dart';
import 'features/temporal/temporal_explorer_screen.dart';
import 'features/text_layers/ocr_translation_transcription_screen.dart';
import 'platform_integration/archive_platform_integration.dart';
import 'platform_integration/contracts.dart';

class EvidenceArchiveApp extends ConsumerWidget {
  const EvidenceArchiveApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ARCHIVE_VISUAL_IDENTITY_REDESIGN: the app now uses a heritage archive palette
    // rather than a generic administrative blue shell.
    const archiveGreen = Color(0xFF073F31);
    const waqfGreen = Color(0xFF0E6A4D);
    const antiqueGold = Color(0xFFC79A35);
    const manuscriptInk = Color(0xFF2B2118);
    final colorScheme = ColorScheme.fromSeed(
      seedColor: archiveGreen,
      brightness: Brightness.light,
    ).copyWith(
      primary: archiveGreen,
      secondary: antiqueGold,
      tertiary: waqfGreen,
      error: const Color(0xFFB22222),
      surface: const Color(0xFFFFFCF4),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PalWakf Evidence Archive & Spatial Explorer',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        scaffoldBackgroundColor: const Color(0xFFF8F2E7),
        appBarTheme: const AppBarTheme(
          backgroundColor: archiveGreen,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          color: Colors.white,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: antiqueGold.withValues(alpha: 0.12),
          selectedColor: waqfGreen.withValues(alpha: 0.18),
          labelStyle: const TextStyle(color: manuscriptInk),
          side: BorderSide(color: antiqueGold.withValues(alpha: 0.20)),
        ),
      ),
      home: const _ArchiveEntryGate(),
    );
  }
}

class _ArchiveEntryGate extends StatefulWidget {
  const _ArchiveEntryGate();

  @override
  State<_ArchiveEntryGate> createState() => _ArchiveEntryGateState();
}

class _ArchiveEntryGateState extends State<_ArchiveEntryGate> {
  bool _workspaceOpen = false;

  void _openWorkspace() {
    // WORKSPACE_REQUIRES_DEV_LOGIN_ENTRY: the internal shell is opened only
    // after the public development-login call to action.
    // NO_REAL_AUTH_BACKEND: development login is local UI state only; no
    // username, password, Supabase Auth, or external identity provider.
    setState(() => _workspaceOpen = true);
  }

  void _returnToPublicHome() {
    setState(() => _workspaceOpen = false);
  }

  @override
  Widget build(BuildContext context) {
    if (!_workspaceOpen) {
      // SIDEBAR_NOT_ON_PUBLIC_HOME: the operational sidebar is not mounted on
      // the public landing page.
      return PublicArchiveLandingScreen(onDevLogin: _openWorkspace);
    }
    return _AppShell(onExitWorkspace: _returnToPublicHome);
  }
}

class _AppShell extends ConsumerStatefulWidget {
  const _AppShell({required this.onExitWorkspace});

  final VoidCallback onExitWorkspace;

  @override
  ConsumerState<_AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<_AppShell> {
  String _selectedId = 'home';

  // DAILY_USER_EXPERIENCE_FIRST
  // SIDEBAR_GROUPED_BY_USAGE: the side navigation is grouped by usage category.
  // DAILY_UX_PRIMARY_NAVIGATION: daily productive workspaces are first in the navigation hierarchy.
  // DOCUMENT_PRODUCTIVE_PAGES: documents, add-document, upload, review, search, and detail routes remain visible from user-first groups.
  // DOCUMENT_DETAIL_TABS_VISIBLE: the document detail screen remains reachable from the documents workspace.
  // NO_GOVERNANCE_FIRST_EXPERIENCE: governance is not the primary product experience.
  // GOVERNANCE_SUBPAGE_ONLY / GOVERNANCE_IS_ADMIN_SUBPAGE_ONLY: staging, controlled UAT,
  // production readiness, feature flags, and platform health remain inside the administration group.
  // DOCUMENT_READING_ASSISTANT_NAV_VISIBILITY_REPAIR_R3_ANCHORLESS: visible daily and explorer navigation entries are inserted without fragile text anchors.
  static const _groups = <_NavigationGroup>[
    _NavigationGroup(
      icon: Icons.work_outline,
      label: 'مساحة العمل اليومية',
      children: [
        _NavigationEntry('home', Icons.home_outlined, 'الرئيسية'),
        _NavigationEntry(
            'dashboard', Icons.dashboard_outlined, 'لوحة المتابعة'),
        _NavigationEntry('tasks', Icons.assignment_turned_in_outlined, 'مهامي'),
        _NavigationEntry('documents', Icons.folder_copy_outlined, 'الوثائق'),
        // ADD_DOCUMENT_FLOW_VISIBLE
        _NavigationEntry(
            'add-document', Icons.note_add_outlined, 'إضافة وثيقة'),
        _NavigationEntry('upload', Icons.cloud_upload_outlined, 'الرفع والحفظ'),
        _NavigationEntry(
            'smart-search', Icons.psychology_alt_outlined, 'البحث الذكي'),
        // DOCUMENT_READING_ASSISTANT_DAILY_VISIBLE_NAV_ENTRY
        _NavigationEntry('document-reading-assistant', Icons.translate_outlined,
            'مساعد قراءة الوثائق'),
      ],
    ),
    // LAYERED_ARCHIVE_CATALOGS: catalog entry points are first-class archive navigation, after daily work and before organization/governance.
    _NavigationGroup(
      icon: Icons.menu_book_outlined,
      label: 'كتالوجات الأرشيف',
      children: [
        _NavigationEntry(
            'catalogs', Icons.view_module_outlined, 'كل الكتالوجات'),
        _NavigationEntry(
            'catalog-ottoman', Icons.history_edu_outlined, 'الأرشيف العثماني'),
        _NavigationEntry('catalog-british', Icons.public_outlined,
            'الأرشيف البريطاني / الإنجليزي'),
        _NavigationEntry('catalog-jordanian', Icons.account_balance_outlined,
            'الأرشيف الأردني'),
        _NavigationEntry(
            'catalog-palestinian', Icons.flag_outlined, 'الأرشيف الفلسطيني'),
      ],
    ),
    _NavigationGroup(
      icon: Icons.account_tree_outlined,
      label: 'تنظيم الأرشيف',
      children: [
        _NavigationEntry(
            'classification', Icons.account_tree_outlined, 'التصنيف'),
        _NavigationEntry('metadata', Icons.badge_outlined, 'بيانات الوثيقة'),
        _NavigationEntry('lifecycle', Icons.sync_alt_outlined, 'دورة الحياة'),
        _NavigationEntry(
            'steps', Icons.checklist_rtl_outlined, 'خطوات الأرشفة'),
        _NavigationEntry('registry', Icons.verified_outlined, 'سجل الأدلة'),
        _NavigationEntry(
            'representations', Icons.file_copy_outlined, 'التمثيلات'),
        // OCR_TRANSLATION_TRANSCRIPTION_DRAFT_LAYER
        _NavigationEntry(
            'text-layers', Icons.article_outlined, 'OCR والترجمة والتفريغ'),
        // DOCUMENT_READING_ASSISTANT_NAV_ENTRY
        _NavigationEntry('document-reading-assistant', Icons.translate_outlined,
            'مساعد قراءة الوثائق'),
      ],
    ),
    _NavigationGroup(
      icon: Icons.fact_check_outlined,
      label: 'المراجعة والاعتماد',
      children: [
        _NavigationEntry(
            'review', Icons.fact_check_outlined, 'استوديو الاعتماد'),
        _NavigationEntry(
            'access-audit', Icons.policy_outlined, 'الإتاحة والتدقيق'),
        _NavigationEntry('publication', Icons.publish_outlined, 'طلبات النشر'),
        _NavigationEntry(
            'retention', Icons.inventory_2_outlined, 'سياسات الاحتفاظ'),
        _NavigationEntry(
            'audit-trail', Icons.manage_history_outlined, 'سجل التدقيق'),
      ],
    ),
    _NavigationGroup(
      icon: Icons.travel_explore_outlined,
      label: 'الاستكشاف والبحث',
      children: [
        _NavigationEntry(
            'search-index', Icons.manage_search_outlined, 'الفهرس والبحث'),
        _NavigationEntry(
            'smart-indexing', Icons.auto_awesome_outlined, 'الفهرسة الذكية'),
        _NavigationEntry(
            'duplicates', Icons.compare_arrows_outlined, 'كشف التكرار'),
        _NavigationEntry(
            'spatial-temporal', Icons.map_outlined, 'المكان والزمن'),
        _NavigationEntry(
            'saved-searches', Icons.bookmark_added_outlined, 'البحوث المحفوظة'),
        // DOCUMENT_READING_ASSISTANT_EXPLORER_VISIBLE_NAV_ENTRY
        _NavigationEntry('document-reading-assistant', Icons.translate_outlined,
            'مساعد قراءة الوثائق'),
      ],
    ),
    _NavigationGroup(
      icon: Icons.assessment_outlined,
      label: 'التقارير والتشغيل',
      children: [
        _NavigationEntry(
            'reports', Icons.assessment_outlined, 'التقارير والتنبيهات'),
        _NavigationEntry('exports', Icons.ios_share_outlined, 'التصدير'),
        _NavigationEntry('backup', Icons.backup_outlined, 'النسخ الاحتياطي'),
        _NavigationEntry('activity', Icons.history_outlined, 'سجل النشاط'),
        _NavigationEntry('kpi', Icons.insights_outlined, 'مؤشرات الأداء'),
      ],
    ),
    // ADMIN_GROUP_START: governance is nested below this administration group only.
    _NavigationGroup(
      icon: Icons.admin_panel_settings_outlined,
      label: 'الإدارة',
      children: [
        _NavigationEntry(
            'permissions', Icons.admin_panel_settings_outlined, 'الصلاحيات'),
        _NavigationEntry('security', Icons.security_outlined, 'الأمان والنسخ'),
        _NavigationEntry(
            'technical', Icons.developer_board_outlined, 'التصور الفني'),
        _NavigationEntry('imports', Icons.table_chart_outlined, 'الاستيراد'),
        _NavigationEntry(
            'admin-settings', Icons.settings_outlined, 'إعدادات النظام'),
        // GOVERNANCE_ADMIN_SUBPAGE_ENTRY
        _NavigationEntry(
            'governance', Icons.gpp_maybe_outlined, 'الحوكمة والتكامل'),
      ],
    ),
  ];

  static final _entries = [
    for (final group in _groups) ...group.children,
  ];

  static const _bottomDestinationIds = [
    'home',
    'documents',
    'add-document',
    'smart-search',
    'tasks',
  ];

  static const _legacyIndexToId = <int, String>{
    0: 'home',
    1: 'dashboard',
    2: 'documents',
    3: 'classification',
    4: 'metadata',
    5: 'upload',
    6: 'lifecycle',
    7: 'smart-search',
    8: 'smart-indexing',
    9: 'steps',
    10: 'review',
    11: 'registry',
    12: 'representations',
    13: 'spatial-temporal',
    14: 'permissions',
    15: 'access-audit',
    16: 'security',
    17: 'technical',
    18: 'reports',
    19: 'search-index',
    20: 'reports',
    21: 'admin-settings',
    22: 'activity',
    23: 'catalogs',
  };

  void _selectId(String id) {
    setState(() => _selectedId = id);
  }

  void _selectLegacyIndex(int index) {
    if (_legacyIndexToId.containsKey(index)) {
      _selectId(_legacyIndexToId[index]!);
      return;
    }
    final boundedIndex = index < 0
        ? 0
        : index >= _entries.length
            ? _entries.length - 1
            : index;
    _selectId(_entries[boundedIndex].id);
  }

  void _selectFromDrawer(String id) {
    _selectId(id);
    Navigator.of(context).pop();
  }

  _NavigationEntry get _selectedEntry => _entries.firstWhere(
        (entry) => entry.id == _selectedId,
        orElse: () => _entries.first,
      );

  _NavigationGroup get _selectedGroup => _groups.firstWhere(
        (group) => group.children.any((entry) => entry.id == _selectedId),
        orElse: () => _groups.first,
      );

  Widget _pageFor(String id) {
    switch (id) {
      case 'home':
        return DailyArchiveHomeScreen(onNavigate: _selectLegacyIndex);
      case 'dashboard':
      case 'kpi':
        return OperationsDashboardScreen(onNavigate: _selectLegacyIndex);
      case 'tasks':
      case 'review':
        // REVIEW_WORKFLOW_HUMAN_APPROVAL_STUDIO: tasks/review routes open the human approval studio.
        return const ReviewQueueScreen();
      case 'documents':
        return const EvidenceExplorerScreen();
      case 'add-document':
        return AddDocumentScreen(onOpenDocuments: () => _selectId('documents'));
      case 'catalogs':
        return const ArchiveCatalogsScreen();
      case 'catalog-ottoman':
        return const ArchiveCatalogsScreen(initialCatalogId: 'catalog-ottoman');
      case 'catalog-british':
        return const ArchiveCatalogsScreen(initialCatalogId: 'catalog-british');
      case 'catalog-jordanian':
        return const ArchiveCatalogsScreen(
            initialCatalogId: 'catalog-jordanian');
      case 'catalog-palestinian':
        return const ArchiveCatalogsScreen(
            initialCatalogId: 'catalog-palestinian');
      case 'classification':
        return const DocumentClassificationScreen();
      case 'metadata':
        return const DocumentMetadataScreen();
      case 'upload':
        return const UploadStorageScreen();
      case 'lifecycle':
        return const DocumentLifecycleScreen();
      case 'smart-search':
        return const SmartSearchMechanismScreen();
      case 'steps':
        return const ArchivingStepsScreen();
      case 'registry':
        return const EvidenceRegistryScreen();
      case 'representations':
        return const RepresentationsScreen();
      case 'text-layers':
        return const OcrTranslationTranscriptionScreen();
      case 'document-reading-assistant':
        // DOCUMENT_READING_ASSISTANT_ROUTE
        return const OttomanEnglishDocumentAssistantScreen();
      case 'access-audit':
      case 'publication':
      case 'retention':
      case 'audit-trail':
        return const AccessPublicationRetentionAuditScreen();
      case 'search-index':
        return const SearchDiscoveryScreen();
      case 'smart-indexing':
      case 'duplicates':
      case 'saved-searches':
        return const SmartIndexingScreen();
      case 'spatial-temporal':
        return const _SpatialTemporalWorkspace();
      case 'reports':
      case 'exports':
        return const ReportsNotificationsScreen();
      case 'backup':
      case 'security':
        return const SecurityBackupScreen();
      case 'activity':
        return const ActivityScreen();
      case 'permissions':
        return const PermissionsModelScreen();
      case 'technical':
        return const TechnicalBlueprintScreen();
      case 'imports':
        return const ImportCatalogScreen();
      case 'admin-settings':
      case 'governance':
        return const AdminGovernanceConsoleScreen();
      default:
        return DailyArchiveHomeScreen(onNavigate: _selectLegacyIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 1020;
    final integration = ref.watch(archivePlatformIntegrationProvider);
    final currentPage = integration.isModuleLoadPermitted
        ? _pageFor(_selectedId)
        : const ModuleFallbackScreen();
    final selectedBottomIndex = _bottomDestinationIds.indexOf(_selectedId);
    final selectedEntry = _selectedEntry;
    final selectedGroup = _selectedGroup;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          // WORKSPACE_COMMAND_CENTER_VISUAL_SHELL: the internal shell is styled
          // as an archival command center, not a default Flutter admin panel.
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: AlignmentDirectional.centerStart,
                end: AlignmentDirectional.centerEnd,
                colors: [
                  Color(0xFF073F31),
                  Color(0xFF0E6A4D),
                  Color(0xFF2B2118)
                ],
              ),
            ),
          ),
          title: Row(
            children: [
              const Icon(Icons.archive_outlined),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('PalWakf — مركز تشغيل الأرشيف الفلسطيني'),
                    Text(
                      '${selectedGroup.label} / ${selectedEntry.label}',
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            if (isWide)
              SizedBox(
                width: 300,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'بحث سريع عن وثيقة...',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white.withValues(alpha: 0.16),
                      border: const OutlineInputBorder(),
                      hintStyle: const TextStyle(color: Colors.white70),
                    ),
                    style: const TextStyle(color: Colors.white),
                    onSubmitted: (_) => _selectId('search-index'),
                  ),
                ),
              ),
            TextButton.icon(
              onPressed: widget.onExitWorkspace,
              icon: const Icon(Icons.logout_outlined),
              label: const Text('الواجهة العامة'),
              style: TextButton.styleFrom(foregroundColor: Colors.white),
            ),
            Tooltip(
              message: integration.health.status.label,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Icon(
                  integration.isModuleLoadPermitted
                      ? Icons.check_circle_outline
                      : Icons.extension_off_outlined,
                ),
              ),
            ),
          ],
        ),
        drawer: isWide
            ? null
            : Drawer(
                child: _GroupedNavigationList(
                    onSelect: _selectFromDrawer, selectedId: _selectedId)),
        body: isWide
            ? Row(
                children: [
                  SizedBox(
                    width: 318,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFCF4),
                        border: BorderDirectional(
                          end: BorderSide(
                            color: Theme.of(context).dividerColor,
                          ),
                        ),
                      ),
                      child: _GroupedNavigationList(
                        selectedId: _selectedId,
                        onSelect: _selectId,
                      ),
                    ),
                  ),
                  Expanded(child: currentPage),
                ],
              )
            : currentPage,
        bottomNavigationBar: isWide
            ? null
            : NavigationBar(
                selectedIndex:
                    selectedBottomIndex < 0 ? 0 : selectedBottomIndex,
                onDestinationSelected: (index) =>
                    _selectId(_bottomDestinationIds[index]),
                destinations: const [
                  NavigationDestination(
                    icon: Icon(Icons.home_outlined),
                    label: 'الرئيسية',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.folder_copy_outlined),
                    label: 'الوثائق',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.note_add_outlined),
                    label: 'إضافة',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.psychology_alt_outlined),
                    label: 'البحث',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.assignment_turned_in_outlined),
                    label: 'مهامي',
                  ),
                ],
              ),
      ),
    );
  }
}

class _GroupedNavigationList extends StatelessWidget {
  const _GroupedNavigationList({
    required this.selectedId,
    required this.onSelect,
  });

  final String selectedId;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    // SIDEBAR_LIST_MATERIAL_BOUNDARY: every ListTile/ExpansionTile in the
    // decorated navigation rail paints on a Material surface, not directly
    // behind the enclosing DecoratedBox.
    return SafeArea(
      child: Material(
        color: Colors.transparent,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 10),
              child: _NavigationSummaryHeader(),
            ),
            for (final group in _AppShellState._groups)
              _NavigationGroupTile(
                group: group,
                selectedId: selectedId,
                onSelect: onSelect,
              ),
          ],
        ),
      ),
    );
  }
}

class _NavigationSummaryHeader extends StatelessWidget {
  const _NavigationSummaryHeader();

  @override
  Widget build(BuildContext context) {
    // WORKSPACE_COMMAND_CENTER_VISUAL_SHELL: sidebar opens with an archive identity
    // plaque showing the operating principle and draft/publication boundary.
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xFF073F31), Color(0xFF0E6A4D)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Row(
            children: [
              Icon(Icons.account_balance_outlined, color: Colors.white),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'غرفة تشغيل الأرشيف',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 17),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'وثيقة ⇢ كتالوج ⇢ تمثيل ⇢ OCR/تفريغ ⇢ ترجمة ⇢ مراجعة بشرية',
            style: TextStyle(color: Colors.white, height: 1.55),
          ),
          SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              Chip(label: Text('مسودات فقط')),
              Chip(label: Text('لا نشر دون اعتماد')),
            ],
          ),
        ],
      ),
    );
  }
}

class _NavigationGroupTile extends StatefulWidget {
  const _NavigationGroupTile({
    required this.group,
    required this.selectedId,
    required this.onSelect,
  });

  final _NavigationGroup group;
  final String selectedId;
  final ValueChanged<String> onSelect;

  @override
  State<_NavigationGroupTile> createState() => _NavigationGroupTileState();
}

class _NavigationGroupTileState extends State<_NavigationGroupTile> {
  late bool _expanded;

  bool get _containsSelected => widget.group.children.any(
        (entry) => entry.id == widget.selectedId,
      );

  @override
  void initState() {
    super.initState();
    _expanded = _containsSelected;
  }

  @override
  void didUpdateWidget(covariant _NavigationGroupTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_containsSelected && !_expanded) {
      _expanded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    // NAVIGATION_GROUP_CUSTOM_EXPANDER: do not use ExpansionTile here.
    // CUSTOM_NAVIGATION_GROUP_TILE: the group header is a direct ListTile
    // with its own Material boundary, avoiding ExpansionTile's internal
    // DecoratedBox/ListTile assertion in Flutter web debug mode.
    // NAVIGATION_GROUP_EXPANSION_MATERIAL_BOUNDARY: preserved as a static
    // compatibility marker; the boundary is now enforced by custom widgets.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Material(
          color: Colors.transparent,
          child: ListTile(
            dense: true,
            leading: Icon(widget.group.icon),
            title: Text(widget.group.label),
            trailing: Icon(
              _expanded
                  ? Icons.keyboard_arrow_up_outlined
                  : Icons.keyboard_arrow_down_outlined,
            ),
            onTap: () => setState(() => _expanded = !_expanded),
          ),
        ),
        if (_expanded)
          for (final entry in widget.group.children)
            _NavigationRow(
              entry: entry,
              selected: entry.id == widget.selectedId,
              onTap: () => widget.onSelect(entry.id),
            ),
      ],
    );
  }
}

class _NavigationRow extends StatelessWidget {
  const _NavigationRow({
    required this.entry,
    required this.selected,
    required this.onTap,
  });

  final _NavigationEntry entry;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // LIST_TILE_MATERIAL_BOUNDARY: keep ListTile ink/selected effects visible
    // inside the decorated shell.
    return Material(
      color: Colors.transparent,
      child: ListTile(
        selected: selected,
        dense: true,
        contentPadding: const EdgeInsetsDirectional.only(start: 30, end: 16),
        leading: Icon(entry.icon),
        title: Text(entry.label),
        onTap: onTap,
      ),
    );
  }
}

class _SpatialTemporalWorkspace extends StatelessWidget {
  const _SpatialTemporalWorkspace();

  @override
  Widget build(BuildContext context) {
    return const DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            tabs: [
              Tab(icon: Icon(Icons.map_outlined), text: 'المستكشف المكاني'),
              Tab(icon: Icon(Icons.timeline_outlined), text: 'الخط الزمني'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                SpatialReadinessScreen(),
                TemporalExplorerScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NavigationGroup {
  const _NavigationGroup({
    required this.icon,
    required this.label,
    required this.children,
  });

  final IconData icon;
  final String label;
  final List<_NavigationEntry> children;
}

class _NavigationEntry {
  const _NavigationEntry(this.id, this.icon, this.label);

  final String id;
  final IconData icon;
  final String label;
}
