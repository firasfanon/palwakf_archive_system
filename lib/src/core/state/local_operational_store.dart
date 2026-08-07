import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../platform_integration/contracts.dart';
import '../models/models.dart';

class LocalOperationalState {
  const LocalOperationalState({
    required this.evidence,
    required this.collections,
    required this.archiveCatalogs,
    required this.catalogDocumentTypeTabs,
    required this.metadataTemplates,
    required this.archiveNodes,
    required this.registry,
    required this.representations,
    required this.textDraftLayers,
    required this.spatialLinks,
    required this.temporalEvents,
    required this.relations,
    required this.reviewTasks,
    required this.importBatches,
    required this.policies,
    required this.readiness,
    required this.activities,
    required this.reports,
    required this.notifications,
    required this.backupSnapshots,
    required this.exportRequests,
    required this.smartIndexJobs,
    required this.duplicateCandidates,
    required this.savedSearches,
    required this.taxonomySuggestions,
    required this.accessPolicies,
    required this.publicationRequests,
    required this.retentionRules,
    required this.auditTrail,
  });

  final List<EvidenceItem> evidence;
  final List<ArchiveCollection> collections;
  final List<ArchiveCatalog> archiveCatalogs;
  final List<CatalogDocumentTypeTab> catalogDocumentTypeTabs;
  final List<CatalogMetadataTemplate> metadataTemplates;
  final List<ArchiveRecordNode> archiveNodes;
  final List<EvidenceRegistryEntry> registry;
  final List<ArchiveRepresentation> representations;
  final List<TextDraftLayer> textDraftLayers;
  final List<SpatialLink> spatialLinks;
  final List<TemporalEvent> temporalEvents;
  final List<EvidenceRelation> relations;
  final List<ReviewTask> reviewTasks;
  final List<ImportBatch> importBatches;
  final List<AdministrativePolicy> policies;
  final List<ReadinessCheckpoint> readiness;
  final List<LocalActivity> activities;
  final List<ArchiveReport> reports;
  final List<ArchiveNotification> notifications;
  final List<BackupSnapshot> backupSnapshots;
  final List<ExportRequest> exportRequests;
  final List<SmartIndexJob> smartIndexJobs;
  final List<DuplicateCandidate> duplicateCandidates;
  final List<SavedSearch> savedSearches;
  final List<TaxonomySuggestion> taxonomySuggestions;
  final List<AccessPolicyRule> accessPolicies;
  final List<PublicationRequest> publicationRequests;
  final List<RetentionRule> retentionRules;
  final List<AuditTrailEntry> auditTrail;

  int get textDraftLayerCount => textDraftLayers.length;

  int get ocrDraftLayerCount => textDraftLayers
      .where((item) => item.kind == TextDraftLayerKind.ocr)
      .length;

  int get transcriptionDraftLayerCount => textDraftLayers
      .where((item) => item.kind == TextDraftLayerKind.transcription)
      .length;

  int get translationDraftLayerCount => textDraftLayers
      .where((item) => item.kind == TextDraftLayerKind.translation)
      .length;

  int get humanReviewPendingTextDraftCount => textDraftLayers
      .where((item) => item.status.contains('مراجعة بشرية'))
      .length;

  List<TextDraftLayer> textDraftsForEvidence(String evidenceId) =>
      textDraftLayers
          .where((item) => item.evidenceId == evidenceId)
          .toList(growable: false);

  int get pendingPublicationRequestCount => publicationRequests
      .where((item) => item.status == 'بانتظار مراجعة الإتاحة')
      .length;

  int get activeRetentionRuleCount =>
      retentionRules.where((item) => item.status != 'منتهية').length;

  int get auditTrailCount => auditTrail.length;

  int get openDraftMaterialCount =>
      evidence.where((item) => item.draftStage.contains('مسودة')).length;

  int get publicationBlockedUntilHumanApprovalCount => evidence
      .where((item) => item.publicationStatus.contains('اعتمادًا بشريًا'))
      .length;

  int get layeredArchiveCatalogCount => archiveCatalogs.length;

  int get catalogDocumentTypeTabCount => catalogDocumentTypeTabs.length;

  int get catalogMetadataTemplateCount => metadataTemplates.length;

  CatalogMetadataTemplate? templateForDocumentType(String documentTypeTabId) {
    for (final template in metadataTemplates) {
      if (template.documentTypeTabId == documentTypeTabId) {
        return template;
      }
    }
    return null;
  }

  CatalogMetadataTemplate? metadataTemplateById(String templateId) {
    for (final template in metadataTemplates) {
      if (template.id == templateId) {
        return template;
      }
    }
    return null;
  }

  int get draftRepresentationCount => representations
      .where((item) =>
          item.uploadStatus.contains('طابور') ||
          item.uploadStatus.contains('مسودة'))
      .length;

  int openDraftCountForCatalog(String catalogId) => evidence
      .where((item) =>
          item.catalogId == catalogId && item.draftStage.contains('مسودة'))
      .length;

  List<CatalogDocumentTypeTab> tabsForCatalog(String catalogId) =>
      catalogDocumentTypeTabs
          .where((tab) => tab.catalogId == catalogId)
          .toList(growable: false);

  int get unacknowledgedNotificationCount =>
      notifications.where((item) => !item.acknowledged).length;

  int get completedBackupSnapshotCount =>
      backupSnapshots.where((item) => item.status == 'مكتمل محليًا').length;

  int get pendingExportRequestCount =>
      exportRequests.where((item) => item.status != 'جاهز محليًا').length;

  int get pendingSmartIndexJobCount =>
      smartIndexJobs.where((item) => item.status != 'مكتمل محليًا').length;

  int get activeDuplicateCandidateCount =>
      duplicateCandidates.where((item) => item.status == 'بانتظار قرار').length;

  int get acceptedTaxonomySuggestionCount =>
      taxonomySuggestions.where((item) => item.status == 'مقبول محليًا').length;

  int get openReviewCount => reviewTasks
      .where((task) => task.state != ReviewTaskState.completed)
      .length;

  int get quarantinedEvidenceCount => evidence
      .where((item) => item.status == EvidenceReviewStatus.quarantined)
      .length;

  int get linkedWaqfEvidenceCount =>
      evidence.where((item) => item.linkedWaqfAssetId != null).length;

  int get spatialReadyCount => spatialLinks
      .where((link) =>
          link.status == SpatialStatus.parcelLevel ||
          link.status == SpatialStatus.verifiedGeometry)
      .length;

  int get originalRepresentationCount =>
      representations.where((item) => item.isAuthoritativeOriginal).length;

  int get queuedRepresentationCount => representations
      .where((item) => item.uploadStatus.contains('طابور'))
      .length;

  int get reviewedRepresentationCount => representations
      .where((item) => item.uploadStatus.contains('مراجع'))
      .length;

  int get blockedOriginalReplacementCount => representations
      .where((item) => item.uploadStatus.contains('استبدال أصل محظور'))
      .length;

  int get internalReadyEvidenceCount => evidence
      .where((item) => item.status == EvidenceReviewStatus.internalReady)
      .length;

  int get restrictedEvidenceCount => evidence
      .where((item) => item.accessLevel == AccessLevel.restricted)
      .length;

  int get blockedReadinessCount =>
      readiness.where((item) => item.state == ReadinessState.blocked).length;

  LocalOperationalState copyWith({
    List<EvidenceItem>? evidence,
    List<ArchiveCollection>? collections,
    List<ArchiveCatalog>? archiveCatalogs,
    List<CatalogDocumentTypeTab>? catalogDocumentTypeTabs,
    List<CatalogMetadataTemplate>? metadataTemplates,
    List<ArchiveRecordNode>? archiveNodes,
    List<EvidenceRegistryEntry>? registry,
    List<ArchiveRepresentation>? representations,
    List<TextDraftLayer>? textDraftLayers,
    List<SpatialLink>? spatialLinks,
    List<TemporalEvent>? temporalEvents,
    List<EvidenceRelation>? relations,
    List<ReviewTask>? reviewTasks,
    List<ImportBatch>? importBatches,
    List<AdministrativePolicy>? policies,
    List<ReadinessCheckpoint>? readiness,
    List<LocalActivity>? activities,
    List<ArchiveReport>? reports,
    List<ArchiveNotification>? notifications,
    List<BackupSnapshot>? backupSnapshots,
    List<ExportRequest>? exportRequests,
    List<SmartIndexJob>? smartIndexJobs,
    List<DuplicateCandidate>? duplicateCandidates,
    List<SavedSearch>? savedSearches,
    List<TaxonomySuggestion>? taxonomySuggestions,
    List<AccessPolicyRule>? accessPolicies,
    List<PublicationRequest>? publicationRequests,
    List<RetentionRule>? retentionRules,
    List<AuditTrailEntry>? auditTrail,
  }) {
    return LocalOperationalState(
      evidence: evidence ?? this.evidence,
      collections: collections ?? this.collections,
      archiveCatalogs: archiveCatalogs ?? this.archiveCatalogs,
      catalogDocumentTypeTabs:
          catalogDocumentTypeTabs ?? this.catalogDocumentTypeTabs,
      metadataTemplates: metadataTemplates ?? this.metadataTemplates,
      archiveNodes: archiveNodes ?? this.archiveNodes,
      registry: registry ?? this.registry,
      representations: representations ?? this.representations,
      textDraftLayers: textDraftLayers ?? this.textDraftLayers,
      spatialLinks: spatialLinks ?? this.spatialLinks,
      temporalEvents: temporalEvents ?? this.temporalEvents,
      relations: relations ?? this.relations,
      reviewTasks: reviewTasks ?? this.reviewTasks,
      importBatches: importBatches ?? this.importBatches,
      policies: policies ?? this.policies,
      readiness: readiness ?? this.readiness,
      activities: activities ?? this.activities,
      reports: reports ?? this.reports,
      notifications: notifications ?? this.notifications,
      backupSnapshots: backupSnapshots ?? this.backupSnapshots,
      exportRequests: exportRequests ?? this.exportRequests,
      smartIndexJobs: smartIndexJobs ?? this.smartIndexJobs,
      duplicateCandidates: duplicateCandidates ?? this.duplicateCandidates,
      savedSearches: savedSearches ?? this.savedSearches,
      taxonomySuggestions: taxonomySuggestions ?? this.taxonomySuggestions,
      accessPolicies: accessPolicies ?? this.accessPolicies,
      publicationRequests: publicationRequests ?? this.publicationRequests,
      retentionRules: retentionRules ?? this.retentionRules,
      auditTrail: auditTrail ?? this.auditTrail,
    );
  }
}

/// Session-only fixture store. It is intentionally not a replacement for
/// platform repositories, server-side scope enforcement, audit, or storage.
class LocalOperationalController extends StateNotifier<LocalOperationalState> {
  LocalOperationalController({
    String localUnitScopeKey = localDevelopmentUnitKey,
  })  : localUnitScopeKey = localUnitScopeKey,
        super(_seedState(localUnitScopeKey));

  final String localUnitScopeKey;

  static LocalOperationalState _seedState(String localUnitScopeKey) {
    final now = DateTime.now();
    return LocalOperationalState(
      evidence: [
        EvidenceItem(
          id: 'EV-DEMO-WAQF-0001',
          title: 'وثيقة وقفية تجريبية — نموذج حجة محفوظة محليًا',
          domain: EvidenceDomain.waqf,
          sourceAuthority: 'بيانات تدريبية محلية',
          reference: 'LOCAL-WAQF/DEMO/0001',
          status: EvidenceReviewStatus.discovered,
          confidence: 'مرجع غير متحقق',
          unitScopeKey: localUnitScopeKey,
          isOriginalAvailableLocally: true,
          createdAt: now.subtract(const Duration(days: 2)),
          dateLabel: 'أواخر العهد العثماني — غير محقق',
          rightsStatus: 'حقوق داخلية قيد المراجعة',
          legalSensitivity: 'حساسية وقفية متوسطة',
          linkedWaqfAssetId: 'PWF-AST-DEMO-0001',
          accessLevel: AccessLevel.unitOnly,
          spatialStatus: SpatialStatus.parcelLevel,
        ),
        EvidenceItem(
          id: 'EV-DEMO-OTTOMAN-0001',
          title: 'وصف أرشيفي عثماني تجريبي ضمن سلسلة',
          domain: EvidenceDomain.ottoman,
          sourceAuthority: 'بيانات تدريبية محلية',
          reference: 'FONDS/DEMO/SERIES-01/FILE-001',
          status: EvidenceReviewStatus.inReview,
          confidence: 'مرجع تاريخي',
          unitScopeKey: localUnitScopeKey,
          isOriginalAvailableLocally: true,
          createdAt: now.subtract(const Duration(days: 1)),
          dateLabel: 'عثماني — تاريخ وصفي',
          rightsStatus: 'قيد توثيق المصدر',
          legalSensitivity: 'تاريخي غير منشور',
          accessLevel: AccessLevel.internal,
          spatialStatus: SpatialStatus.roughLocation,
        ),
        EvidenceItem(
          id: 'EV-DEMO-SPATIAL-0001',
          title: 'طبقة تحليلية تجريبية للمقارنة المكانية',
          domain: EvidenceDomain.spatial,
          sourceAuthority: 'محرك محلي تجريبي',
          reference: 'LOCAL-SPATIAL/ANALYTICS/0001',
          status: EvidenceReviewStatus.inReview,
          confidence: 'نتيجة تحليلية مشتقة',
          unitScopeKey: localUnitScopeKey,
          isOriginalAvailableLocally: false,
          createdAt: now.subtract(const Duration(hours: 6)),
          dateLabel: 'معاصر — تحليل محلي',
          rightsStatus: 'مشتق غير منشور',
          legalSensitivity: 'لا يعتمد قضائيًا',
          accessLevel: AccessLevel.restricted,
          spatialStatus: SpatialStatus.disputed,
        ),
      ],
      collections: [
        ArchiveCollection(
          id: 'COL-WAQF-ROOT',
          title: 'مجموعة الأدلة الوقفية المحلية',
          level: 'Collection',
          domain: EvidenceDomain.waqf,
          reference: 'LOCAL-WAQF',
          description: 'مجموعة محلية تجريبية لا تمثل أرشيفًا مركزيًا.',
          unitScopeKey: localUnitScopeKey,
        ),
        ArchiveCollection(
          id: 'COL-OTTOMAN-FONDS',
          title: 'Fonds تجريبي — مواد عثمانية',
          level: 'Fonds',
          domain: EvidenceDomain.ottoman,
          reference: 'FONDS/DEMO',
          description: 'نموذج توصيف Fonds → Series → File → Item.',
          unitScopeKey: localUnitScopeKey,
        ),
      ],
      archiveCatalogs: const [
        ArchiveCatalog(
          id: 'catalog-ottoman',
          title: 'الأرشيف العثماني',
          periodLabel: 'العهد العثماني',
          sourceAuthority: 'مصادر عثمانية وسجلات تاريخية',
          languageHints: 'عثماني / تركي / عربي',
          description:
              'كتالوج لسجلات الطابو والدفاتر والحجج الوقفية والخرائط القديمة والمراسلات.',
          documentTypeTabIds: [
            'ottoman-tapu',
            'ottoman-land',
            'ottoman-waqf-deeds',
            'ottoman-maps'
          ],
          colorLabel: 'أخضر سيادي',
        ),
        ArchiveCatalog(
          id: 'catalog-british',
          title: 'الأرشيف البريطاني / الإنجليزي',
          periodLabel: 'فترة الانتداب والوثائق الإنجليزية',
          sourceAuthority: 'سجلات الانتداب والخرائط والمراسلات الإدارية',
          languageHints: 'إنجليزي / عربي',
          description:
              'كتالوج لوثائق الانتداب وسجلات الأراضي والخرائط والتقارير القانونية والإدارية.',
          documentTypeTabIds: [
            'british-land-records',
            'british-survey-maps',
            'british-correspondence',
            'british-legal-records'
          ],
          colorLabel: 'أزرق أرشيفي',
        ),
        ArchiveCatalog(
          id: 'catalog-jordanian',
          title: 'الأرشيف الأردني',
          periodLabel: 'الإدارة الأردنية',
          sourceAuthority: 'دوائر الأراضي والمساحة والضرائب',
          languageHints: 'عربي',
          description:
              'كتالوج لشهادات التسجيل والمعاملات والمخططات وإيصالات الضرائب والوثائق الرسمية.',
          documentTypeTabIds: [
            'jordanian-registration',
            'jordanian-survey',
            'jordanian-tax',
            'jordanian-transactions'
          ],
          colorLabel: 'ذهبي إداري',
        ),
        ArchiveCatalog(
          id: 'catalog-palestinian',
          title: 'الأرشيف الفلسطيني',
          periodLabel: 'الإدارة الفلسطينية الحديثة',
          sourceAuthority: 'الأوقاف والوزارات وسلطة الأراضي والمحاكم',
          languageHints: 'عربي',
          description:
              'كتالوج لملفات التسوية وقرارات الوزارات وملفات الأوقاف والمراسلات والصور الحديثة.',
          documentTypeTabIds: [
            'palestinian-settlement',
            'palestinian-waqf-files',
            'palestinian-decisions',
            'palestinian-modern-maps'
          ],
          colorLabel: 'أخضر حديث',
        ),
      ],
      catalogDocumentTypeTabs: const [
        CatalogDocumentTypeTab(
          id: 'ottoman-tapu',
          metadataTemplateId: 'template-ottoman-tapu',
          catalogId: 'catalog-ottoman',
          title: 'سجلات الطابو',
          description:
              'دفاتر وسجلات ملكية وحقوق تحتاج قراءة مصدرية وترجمة عند اللزوم.',
          examples: ['دفتر طابو', 'رقم سجل', 'قيد أرض'],
          metadataHints: [
            'رقم الدفتر',
            'اللواء/الناحية',
            'اسم الموضع',
            'التاريخ الهجري'
          ],
          supportsSpatialLink: true,
        ),
        CatalogDocumentTypeTab(
          id: 'ottoman-land',
          catalogId: 'catalog-ottoman',
          title: 'سجلات الأراضي',
          description:
              'مواد تصف أراضي وحقوق استعمال وتحتاج ربطًا بالمكان والوقف.',
          examples: ['أراضٍ', 'حدود', 'موضع'],
          metadataHints: ['اسم الأرض', 'الحدود', 'الوحدة الإدارية', 'الأطراف'],
          supportsSpatialLink: true,
        ),
        CatalogDocumentTypeTab(
          id: 'ottoman-waqf-deeds',
          metadataTemplateId: 'template-ottoman-waqf-deeds',
          catalogId: 'catalog-ottoman',
          title: 'حجج وقفية',
          description: 'حجج ووثائق وقف تحتاج تفريغًا وتحقيقًا ومراجعة وقفية.',
          examples: ['حجة وقف', 'شرط واقف', 'متولي'],
          metadataHints: ['الواقف', 'الموقوف عليه', 'شروط الوقف', 'الشهود'],
          supportsSpatialLink: true,
        ),
        CatalogDocumentTypeTab(
          id: 'ottoman-maps',
          catalogId: 'catalog-ottoman',
          title: 'خرائط ودفاتر',
          description: 'خرائط ودفاتر تاريخية تحتاج تمثيل صورة وربطًا مكانيًا.',
          examples: ['خريطة', 'دفتر', 'مخطط قديم'],
          metadataHints: ['المقياس', 'الموقع', 'الرموز', 'المصدر'],
          supportsSpatialLink: true,
        ),
        CatalogDocumentTypeTab(
          id: 'british-land-records',
          metadataTemplateId: 'template-british-land-records',
          catalogId: 'catalog-british',
          title: 'Land Records',
          description: 'سجلات أراضٍ إنجليزية/انتدابية قابلة للترجمة والفهرسة.',
          examples: ['Land Register', 'Parcel Note'],
          metadataHints: [
            'record number',
            'locality',
            'owner/claimant',
            'date'
          ],
          supportsSpatialLink: true,
        ),
        CatalogDocumentTypeTab(
          id: 'british-survey-maps',
          catalogId: 'catalog-british',
          title: 'Survey Maps',
          description:
              'خرائط ومساحة من فترة الانتداب تحتاج georeference لاحقًا.',
          examples: ['Survey Map', 'Sheet Number'],
          metadataHints: ['sheet', 'scale', 'coordinates', 'survey authority'],
          supportsSpatialLink: true,
        ),
        CatalogDocumentTypeTab(
          id: 'british-correspondence',
          catalogId: 'catalog-british',
          title: 'Mandate Correspondence',
          description: 'مراسلات إدارية وتقارير تحتاج ترجمة واستخراج كيانات.',
          examples: ['Letter', 'Memo', 'Report'],
          metadataHints: ['sender', 'recipient', 'subject', 'file code'],
        ),
        CatalogDocumentTypeTab(
          id: 'british-legal-records',
          catalogId: 'catalog-british',
          title: 'Legal Records',
          description: 'وثائق قانونية أو إدارية حساسة تحتاج مراجعة نشر بشرية.',
          examples: ['Case Note', 'Order', 'Legal File'],
          metadataHints: [
            'case reference',
            'authority',
            'date',
            'legal sensitivity'
          ],
        ),
        CatalogDocumentTypeTab(
          id: 'jordanian-registration',
          metadataTemplateId: 'template-jordanian-registration',
          catalogId: 'catalog-jordanian',
          title: 'شهادات تسجيل',
          description:
              'شهادات تسجيل مجدد وبيانات ملكية/وقف تحتاج ربطًا بالحوض والقطعة.',
          examples: ['شهادة تسجيل', 'قيد مجدد'],
          metadataHints: ['رقم الشهادة', 'الحوض', 'القطعة', 'اسم المالك/الوقف'],
          supportsSpatialLink: true,
        ),
        CatalogDocumentTypeTab(
          id: 'jordanian-survey',
          catalogId: 'catalog-jordanian',
          title: 'مخططات مساحة',
          description: 'مخططات مساحة وخرائط تحتاج حفظ صورة وربطًا بالموقع.',
          examples: ['مخطط مساحة', 'مخطط حوض'],
          metadataHints: ['رقم المخطط', 'الحوض', 'القطعة', 'المساح'],
          supportsSpatialLink: true,
        ),
        CatalogDocumentTypeTab(
          id: 'jordanian-tax',
          catalogId: 'catalog-jordanian',
          title: 'إيصالات ضريبة',
          description: 'إيصالات ورسوم وويركو وسجلات ضريبية داعمة.',
          examples: ['ويركو', 'إيصال ضريبة أملاك'],
          metadataHints: ['رقم الإيصال', 'السنة', 'الدافع', 'الموقع'],
          supportsOcr: true,
          supportsTranslation: false,
        ),
        CatalogDocumentTypeTab(
          id: 'jordanian-transactions',
          catalogId: 'catalog-jordanian',
          title: 'معاملات أراضي',
          description: 'ملفات معاملات وتسجيل ومراسلات دائرة الأراضي.',
          examples: ['طلب تسجيل', 'معاملة منتهية'],
          metadataHints: ['رقم المعاملة', 'الجهة', 'الحالة', 'المرفقات'],
        ),
        CatalogDocumentTypeTab(
          id: 'palestinian-settlement',
          metadataTemplateId: 'template-palestinian-settlement',
          catalogId: 'catalog-palestinian',
          title: 'ملفات التسوية',
          description: 'ملفات تسوية واعتراضات وادعاءات تحفظ كمسودات قبل النشر.',
          examples: ['ملف تسوية', 'اعتراض', 'حوض معلن'],
          metadataHints: [
            'رقم الحوض',
            'القطعة',
            'مرحلة التسوية',
            'رقم الاعتراض'
          ],
          supportsSpatialLink: true,
        ),
        CatalogDocumentTypeTab(
          id: 'palestinian-waqf-files',
          catalogId: 'catalog-palestinian',
          title: 'ملفات أوقاف',
          description: 'ملفات داخلية وكتب أوقاف ومراسلات مرتبطة بأصل وقفي.',
          examples: ['كتاب أوقاف', 'ملف أصل', 'مراسلة داخلية'],
          metadataHints: ['الوحدة', 'رقم الملف', 'الوقف', 'القرار'],
          supportsSpatialLink: true,
        ),
        CatalogDocumentTypeTab(
          id: 'palestinian-decisions',
          catalogId: 'catalog-palestinian',
          title: 'قرارات وكتب رسمية',
          description: 'قرارات وكتب وزارات ومؤسسات تحتاج حالة نشر واضحة.',
          examples: ['قرار', 'كتاب رسمي', 'تعميم'],
          metadataHints: ['رقم الكتاب', 'الجهة', 'الموضوع', 'التاريخ'],
        ),
        CatalogDocumentTypeTab(
          id: 'palestinian-modern-maps',
          catalogId: 'catalog-palestinian',
          title: 'مخططات حديثة وصور',
          description: 'صور ومخططات حديثة ومرفقات مكانية تحفظ كمسودات.',
          examples: ['صورة', 'مخطط', 'مرفق مساحة'],
          metadataHints: ['الموقع', 'المصدر', 'التاريخ', 'نوع المرفق'],
          supportsSpatialLink: true,
        ),
      ],
      metadataTemplates: const [
        CatalogMetadataTemplate(
          id: 'template-ottoman-tapu',
          catalogId: 'catalog-ottoman',
          documentTypeTabId: 'ottoman-tapu',
          title: 'قالب سجلات الطابو العثمانية',
          description:
              'OTTOMAN_TAPU_DRAFT_FORM: حقول مصدرية مرنة لدفاتر الطابو، تقبل النقص كمسودة.',
          aiAssistancePlan:
              'OCR/HTR لاحقًا، قراءة عثمانية مساعدة، استخراج أسماء المواضع والأطراف، ثم مراجعة بشرية.',
          fields: [
            MetadataTemplateField(
                key: 'defter_number',
                label: 'رقم الدفتر/السجل',
                hint: 'مثال: دفتر رقم أو رمز أرشيفي'),
            MetadataTemplateField(
                key: 'administrative_unit',
                label: 'الولاية / اللواء / الناحية',
                hint: 'الوحدة الإدارية التاريخية'),
            MetadataTemplateField(
                key: 'place_name',
                label: 'اسم الموضع',
                hint: 'البلدة أو الموضع كما ورد في السجل'),
            MetadataTemplateField(
                key: 'hijri_date',
                label: 'التاريخ الهجري',
                hint: 'يقبل تاريخًا نصيًا غير محقق'),
            MetadataTemplateField(
                key: 'parties',
                label: 'الأسماء والأطراف',
                hint: 'أسماء واقفين/منتفعين/ملاك/شهود'),
            MetadataTemplateField(
                key: 'right_type',
                label: 'نوع الحق',
                hint: 'ملكية، انتفاع، وقف، حدود، ضريبة'),
          ],
        ),
        CatalogMetadataTemplate(
          id: 'template-ottoman-waqf-deeds',
          catalogId: 'catalog-ottoman',
          documentTypeTabId: 'ottoman-waqf-deeds',
          title: 'قالب الحجج الوقفية العثمانية',
          description:
              'OTTOMAN_WAQF_DEED_DRAFT_FORM: حقول الوقف والشروط والشهود مع مسار ترجمة/تحقيق.',
          aiAssistancePlan:
              'تفريغ مساعد، ترجمة أولية، استخراج الواقف والموقوف عليه وشروط الوقف، ثم مراجعة وقفية بشرية.',
          fields: [
            MetadataTemplateField(
                key: 'waqif_name',
                label: 'اسم الواقف',
                hint: 'كما ورد في الحجة'),
            MetadataTemplateField(
                key: 'beneficiary',
                label: 'الموقوف عليه',
                hint: 'جهة أو أشخاص الانتفاع'),
            MetadataTemplateField(
                key: 'waqf_conditions',
                label: 'شروط الوقف',
                hint: 'نص أو ملخص أولي غير معتمد'),
            MetadataTemplateField(
                key: 'asset_description',
                label: 'وصف الموقوف',
                hint: 'أرض، عقار، ماء، حق منفعة'),
            MetadataTemplateField(
                key: 'witnesses',
                label: 'الشهود / المحكمة',
                hint: 'أسماء أو جهة إصدار'),
          ],
        ),
        CatalogMetadataTemplate(
          id: 'template-british-land-records',
          catalogId: 'catalog-british',
          documentTypeTabId: 'british-land-records',
          title: 'Land Records Template',
          description:
              'BRITISH_LAND_RECORD_DRAFT_FORM: English/Mandate land metadata for translation and linking.',
          aiAssistancePlan:
              'English OCR, translation draft, entity extraction for locality, claimant, parcel references.',
          fields: [
            MetadataTemplateField(
                key: 'record_number',
                label: 'Record Number',
                hint: 'register or file reference'),
            MetadataTemplateField(
                key: 'locality',
                label: 'Locality',
                hint: 'village/site/place name'),
            MetadataTemplateField(
                key: 'claimant_owner',
                label: 'Owner / Claimant',
                hint: 'person, waqf, institution'),
            MetadataTemplateField(
                key: 'parcel_reference',
                label: 'Parcel / Sheet Reference',
                hint: 'if available'),
            MetadataTemplateField(
                key: 'issuing_authority',
                label: 'Authority',
                hint: 'Mandate department or court'),
          ],
        ),
        CatalogMetadataTemplate(
          id: 'template-jordanian-registration',
          catalogId: 'catalog-jordanian',
          documentTypeTabId: 'jordanian-registration',
          title: 'قالب شهادات التسجيل الأردنية',
          description:
              'JORDANIAN_REGISTRATION_DRAFT_FORM: شهادة تسجيل، حوض، قطعة، مالك/وقف، معاملة.',
          aiAssistancePlan:
              'OCR عربي، استخراج أرقام الحوض والقطعة والشهادة، وربط لاحق بـ waqf_asset_id.',
          fields: [
            MetadataTemplateField(
                key: 'certificate_number',
                label: 'رقم الشهادة',
                hint: 'رقم شهادة التسجيل'),
            MetadataTemplateField(
                key: 'basin_number', label: 'رقم الحوض', hint: 'حوض/لوحة/موقع'),
            MetadataTemplateField(
                key: 'parcel_number',
                label: 'رقم القطعة',
                hint: 'رقم القطعة إن وجد'),
            MetadataTemplateField(
                key: 'owner_or_waqf',
                label: 'المالك / الوقف',
                hint: 'اسم المالك أو الوقف'),
            MetadataTemplateField(
                key: 'transaction_number',
                label: 'رقم المعاملة',
                hint: 'اختياري أثناء التطوير'),
          ],
        ),
        CatalogMetadataTemplate(
          id: 'template-palestinian-settlement',
          catalogId: 'catalog-palestinian',
          documentTypeTabId: 'palestinian-settlement',
          title: 'قالب ملفات التسوية الفلسطينية',
          description:
              'PALESTINIAN_SETTLEMENT_DRAFT_FORM: تسوية، حوض، قطعة، اعتراض، مرحلة، جهة.',
          aiAssistancePlan:
              'استخراج أرقام الحوض والقطعة ومرحلة التسوية وربطها لاحقًا بمسار قانوني/وقفي.',
          fields: [
            MetadataTemplateField(
                key: 'settlement_file_number',
                label: 'رقم ملف التسوية',
                hint: 'رقم الملف أو الطلب'),
            MetadataTemplateField(
                key: 'basin_number', label: 'رقم الحوض', hint: 'الحوض المعلن'),
            MetadataTemplateField(
                key: 'parcel_number',
                label: 'رقم القطعة',
                hint: 'قطعة أو عدة قطع'),
            MetadataTemplateField(
                key: 'objection_number',
                label: 'رقم الاعتراض',
                hint: 'اختياري'),
            MetadataTemplateField(
                key: 'settlement_stage',
                label: 'مرحلة التسوية',
                hint: 'إعلان، اعتراض، تعليق، قرار'),
          ],
        ),
      ],
      archiveNodes: [
        ArchiveRecordNode(
          id: 'NODE-FONDS-001',
          title: 'Fonds تجريبي — وقف برك سليمان',
          type: ArchiveNodeType.fonds,
          reference: 'FONDS/BIRK-SULEIMAN',
          parentId: null,
          description: 'حاوية محلية لاختبار بنية الأرشيف السيادي.',
          unitScopeKey: localUnitScopeKey,
          accessLevel: AccessLevel.internal,
          reviewStatus: EvidenceReviewStatus.inReview,
          dateLabel: 'متعدد الفترات',
        ),
        ArchiveRecordNode(
          id: 'NODE-SERIES-001',
          title: 'سلسلة قواشين ووثائق ملكية',
          type: ArchiveNodeType.series,
          reference: 'FONDS/BIRK-SULEIMAN/SERIES/TITLE-DEEDS',
          parentId: 'NODE-FONDS-001',
          description: 'تمثيل منطقي لسلسلة وثائق حقوقية أصلية ومساندة.',
          unitScopeKey: localUnitScopeKey,
          accessLevel: AccessLevel.unitOnly,
          reviewStatus: EvidenceReviewStatus.inReview,
          dateLabel: 'عثماني / أردني / فلسطيني',
        ),
        ArchiveRecordNode(
          id: 'NODE-FILE-001',
          title: 'ملف أرطاس / برك سليمان — نموذج تشغيل',
          type: ArchiveNodeType.file,
          reference: 'FONDS/BIRK-SULEIMAN/SERIES/TITLE-DEEDS/FILE-ARTAS-001',
          parentId: 'NODE-SERIES-001',
          description: 'ملف تجريبي يجمع وثائق وخرائط وروابط مكانية.',
          unitScopeKey: localUnitScopeKey,
          accessLevel: AccessLevel.restricted,
          reviewStatus: EvidenceReviewStatus.inReview,
          dateLabel: 'ملف مستمر',
        ),
        ArchiveRecordNode(
          id: 'NODE-ITEM-001',
          title: 'عنصر تجريبي مرتبط بوثيقة وقفية',
          type: ArchiveNodeType.item,
          reference:
              'FONDS/BIRK-SULEIMAN/SERIES/TITLE-DEEDS/FILE-ARTAS-001/ITEM-001',
          parentId: 'NODE-FILE-001',
          description: 'يناظر EV-DEMO-WAQF-0001 ضمن التسلسل الأرشيفي.',
          unitScopeKey: localUnitScopeKey,
          accessLevel: AccessLevel.unitOnly,
          reviewStatus: EvidenceReviewStatus.discovered,
          dateLabel: 'غير محقق',
        ),
      ],
      registry: [
        EvidenceRegistryEntry(
          id: 'REG-DEMO-001',
          evidenceId: 'EV-DEMO-WAQF-0001',
          type: EvidenceType.waqf,
          confidenceLevel: 'T2 — مصدر موصوف يحتاج تدقيق أصل',
          sourceChain: 'استلام محلي → توصيف أولي → مراجعة وقفية مطلوبة',
          rightsStatus: 'غير قابل للنشر العام',
          legalSensitivity: 'قد يستخدم كدليل مساند فقط بعد اعتماد قانوني',
          reviewStatus: EvidenceReviewStatus.inReview,
          unitScopeKey: localUnitScopeKey,
          linkedWaqfAssetId: 'PWF-AST-DEMO-0001',
        ),
        EvidenceRegistryEntry(
          id: 'REG-DEMO-002',
          evidenceId: 'EV-DEMO-SPATIAL-0001',
          type: EvidenceType.spatial,
          confidenceLevel: 'تحليل مشتق — لا يغني عن طبقة GIS معتمدة',
          sourceChain: 'Fixture spatial note → مراجعة مكانية مطلوبة',
          rightsStatus: 'داخلي فقط',
          legalSensitivity: 'لا يرفق في ملف قضائي دون مصدر أصلي',
          reviewStatus: EvidenceReviewStatus.inReview,
          unitScopeKey: localUnitScopeKey,
        ),
      ],
      representations: [
        ArchiveRepresentation(
          id: 'REP-DEMO-ORIGINAL-001',
          evidenceId: 'EV-DEMO-WAQF-0001',
          type: RepresentationType.original,
          title: 'أصل وصفي محلي — غير مرفوع',
          format: 'PDF placeholder',
          hashPreview: 'sha256:LOCAL-DEMO-ORIGINAL-001',
          rightsStatus: 'قيد فحص الحقوق',
          unitScopeKey: localUnitScopeKey,
          isAuthoritativeOriginal: true,
        ),
        ArchiveRepresentation(
          id: 'REP-DEMO-OCR-001',
          evidenceId: 'EV-DEMO-WAQF-0001',
          type: RepresentationType.ocr,
          title: 'نص OCR تجريبي غير معتمد',
          format: 'text/plain',
          hashPreview: 'sha256:LOCAL-DEMO-OCR-001',
          rightsStatus: 'مشتق داخلي',
          unitScopeKey: localUnitScopeKey,
          isAuthoritativeOriginal: false,
        ),
        ArchiveRepresentation(
          id: 'REP-DEMO-GEO-001',
          evidenceId: 'EV-DEMO-SPATIAL-0001',
          type: RepresentationType.georeferencedImage,
          title: 'تمثيل جغرافي تجريبي',
          format: 'image/geotiff placeholder',
          hashPreview: 'sha256:LOCAL-DEMO-GEO-001',
          rightsStatus: 'مقيد مكانيًا',
          unitScopeKey: localUnitScopeKey,
          isAuthoritativeOriginal: false,
        ),
      ],
      textDraftLayers: [
        TextDraftLayer(
          id: 'TXT-DEMO-OCR-001',
          evidenceId: 'EV-DEMO-WAQF-0001',
          representationId: 'REP-DEMO-OCR-001',
          kind: TextDraftLayerKind.ocr,
          catalogId: 'catalog-ottoman',
          documentTypeTabId: 'ottoman-waqf-deeds',
          languageLabel: 'عربي / عثماني — قراءة أولية',
          sourceLabel: 'NO_REAL_OCR_ENGINE — نص تجريبي محلي فقط',
          textPreview:
              'نص OCR تجريبي مقتطع من وثيقة وقفية غير معتمد للنشر أو الاستدلال.',
          status:
              'مسودة OCR غير معتمدة — HUMAN_REVIEW_REQUIRED_FOR_TEXT_DRAFTS',
          qualityWarnings: [
            'احتمال أخطاء قراءة',
            'يلزم تدقيق بشري قبل الربط أو النشر'
          ],
          humanReviewPolicy:
              'PUBLICATION_REQUIRES_HUMAN_APPROVAL — NO_PUBLICATION_FROM_TEXT_DRAFTS — لا نشر قبل مراجعة بشرية.',
          createdAt: now.subtract(const Duration(minutes: 28)),
          unitScopeKey: localUnitScopeKey,
        ),
        TextDraftLayer(
          id: 'TXT-DEMO-TRANSCRIPTION-001',
          evidenceId: 'EV-DEMO-WAQF-0001',
          representationId: 'REP-DEMO-OCR-001',
          kind: TextDraftLayerKind.transcription,
          catalogId: 'catalog-ottoman',
          documentTypeTabId: 'ottoman-waqf-deeds',
          languageLabel: 'تفريغ عربي أولي',
          sourceLabel:
              'TRANSCRIPTION_DRAFT_LAYER_LOCAL — إدخال محلي قابل للتعديل',
          textPreview:
              'تفريغ حرفي أولي يلتقط أسماء وألفاظًا تحتاج تحقيقًا وقفيًا.',
          status: 'مسودة تفريغ غير معتمدة — تحتاج مراجعة بشرية',
          qualityWarnings: [
            'قد لا يطابق الأصل حرفيًا',
            'لا يستخدم كدليل دون اعتماد'
          ],
          humanReviewPolicy:
              'NO_PUBLICATION_FROM_TEXT_DRAFTS — لا يعتمد التفريغ قبل مقابلة الأصل ومراجعة مختص.',
          createdAt: now.subtract(const Duration(minutes: 24)),
          unitScopeKey: localUnitScopeKey,
        ),
        TextDraftLayer(
          id: 'TXT-DEMO-TRANSLATION-001',
          evidenceId: 'EV-DEMO-OTTOMAN-0001',
          representationId: 'REP-DEMO-OCR-001',
          kind: TextDraftLayerKind.translation,
          catalogId: 'catalog-ottoman',
          documentTypeTabId: 'ottoman-tapu',
          languageLabel: 'ترجمة عربية أولية',
          sourceLabel: 'NO_REAL_TRANSLATION_ENGINE — ترجمة مسودة محلية فقط',
          textPreview:
              'ترجمة أولية لمعنى وصفي من سجل عثماني، تحتاج مقابلة المصدر.',
          status:
              'مسودة ترجمة غير معتمدة — HUMAN_REVIEW_REQUIRED_FOR_TEXT_DRAFTS',
          qualityWarnings: [
            'المصطلحات القانونية تحتاج مدققًا',
            'لا نشر قبل اعتماد بشري'
          ],
          humanReviewPolicy: 'الترجمة مساعدة بحثية وليست نصًا رسميًا معتمدًا.',
          createdAt: now.subtract(const Duration(minutes: 20)),
          unitScopeKey: localUnitScopeKey,
        ),
      ],
      spatialLinks: [
        SpatialLink(
          id: 'SP-DEMO-001',
          evidenceId: 'EV-DEMO-WAQF-0001',
          placeLabel: 'أرطاس / برك سليمان — تمثيل محلي',
          status: SpatialStatus.parcelLevel,
          confidence: 'مرشح على مستوى قطعة — يحتاج PostGIS/Staging',
          geometrySummary: 'لا توجد هندسة حقيقية في المضيف المحلي',
          unitScopeKey: localUnitScopeKey,
          waqfAssetId: 'PWF-AST-DEMO-0001',
        ),
        SpatialLink(
          id: 'SP-DEMO-002',
          evidenceId: 'EV-DEMO-SPATIAL-0001',
          placeLabel: 'طبقة تحليلية تجريبية',
          status: SpatialStatus.disputed,
          confidence: 'متنازع / يحتاج مراجعة مكانية',
          geometrySummary: 'Marker وهمي فقط، لا PostGIS ولا خرائط إنتاجية',
          unitScopeKey: localUnitScopeKey,
        ),
      ],
      temporalEvents: [
        TemporalEvent(
          id: 'TMP-DEMO-001',
          evidenceId: 'EV-DEMO-OTTOMAN-0001',
          periodLabel: 'عثماني',
          title: 'وصف مصدر عثماني مرشح',
          dateLabel: 'تاريخ وصفي غير محقق',
          certainty: 'منخفضة',
          unitScopeKey: localUnitScopeKey,
        ),
        TemporalEvent(
          id: 'TMP-DEMO-002',
          evidenceId: 'EV-DEMO-WAQF-0001',
          periodLabel: 'أردني/فلسطيني',
          title: 'رابط مقارن مع وثائق تسجيل لاحقة',
          dateLabel: 'مرحلة لاحقة غير مثبتة',
          certainty: 'متوسطة',
          unitScopeKey: localUnitScopeKey,
        ),
      ],
      relations: [
        EvidenceRelation(
          id: 'REL-DEMO-001',
          fromEvidenceId: 'EV-DEMO-WAQF-0001',
          toEvidenceId: 'EV-DEMO-SPATIAL-0001',
          type: RelationType.spatiallyReferences,
          rationale: 'رابط مرشح محلي يحتاج مراجعة مصدر ومساحة.',
          confidence: 'متوسط',
          unitScopeKey: localUnitScopeKey,
        ),
      ],
      reviewTasks: [
        ReviewTask(
          id: 'REV-DEMO-001',
          title: 'تصنيف مصدر الوثيقة الوقفية والتحقق من المرجع',
          evidenceId: 'EV-DEMO-WAQF-0001',
          domain: EvidenceDomain.waqf,
          priority: 'عالية',
          assignedRole: 'مراجع وقفي',
          state: ReviewTaskState.open,
          unitScopeKey: localUnitScopeKey,
        ),
        ReviewTask(
          id: 'REV-DEMO-002',
          title: 'مراجعة وصف العنصر العثماني',
          evidenceId: 'EV-DEMO-OTTOMAN-0001',
          domain: EvidenceDomain.ottoman,
          priority: 'عادية',
          assignedRole: 'مختص أرشيف عثماني',
          state: ReviewTaskState.inProgress,
          unitScopeKey: localUnitScopeKey,
        ),
        ReviewTask(
          id: 'REV-DEMO-003',
          title: 'تدقيق حقوق النشر والإتاحة قبل أي نشر',
          evidenceId: 'EV-DEMO-SPATIAL-0001',
          domain: EvidenceDomain.spatial,
          priority: 'حرجة',
          assignedRole: 'مراجع حقوق ومكان',
          state: ReviewTaskState.blocked,
          unitScopeKey: localUnitScopeKey,
        ),
      ],
      importBatches: [
        ImportBatch(
          id: 'IMP-DEMO-001',
          fileName: 'waqf_assets_register_demo.xlsx',
          sheetName: 'Assets',
          domain: EvidenceDomain.waqf,
          rowCount: 28,
          status: 'بانتظار قاموس بيانات',
          unitScopeKey: localUnitScopeKey,
          importStatus: ImportStatus.needsMapping,
          validationSummary: 'تحتاج مطابقة أعمدة مع قاموس الأرشيف.',
        ),
      ],
      policies: const [
        AdministrativePolicy(
          id: 'POL-INTAKE-001',
          title: 'سياسة الاستلام الأدنى',
          ownerRole: 'أمين الأرشيف',
          status: ReadinessState.pass,
          summary:
              'العنوان، المصدر، النطاق، الحقوق، وحالة الأصل مطلوبة قبل المراجعة.',
        ),
        AdministrativePolicy(
          id: 'POL-RIGHTS-001',
          title: 'سياسة الحقوق والإتاحة',
          ownerRole: 'مراجع الحقوق',
          status: ReadinessState.warning,
          summary: 'النشر العام ممنوع حتى اعتماد الحقوق والمصدر.',
        ),
        AdministrativePolicy(
          id: 'POL-PRODUCTION-001',
          title: 'سياسة منع الإنتاج',
          ownerRole: 'مدير النظام',
          status: ReadinessState.blocked,
          summary: 'Production غير معتمد؛ لا يوجد ربط مباشر ولا كتابة بعيدة.',
        ),
      ],
      readiness: const [
        ReadinessCheckpoint(
          id: 'RDY-LOCAL-001',
          stage: ReadinessStage.localProduct,
          title: 'الجذر التشغيلي القانوني',
          state: ReadinessState.pass,
          evidence: 'lib/main.dart يشغل EvidenceArchiveApp وليس Flutter Demo.',
          blocker: 'لا يوجد',
        ),
        ReadinessCheckpoint(
          id: 'RDY-CORE-001',
          stage: ReadinessStage.coreArchive,
          title: 'Fonds/Series/File/Item محلي',
          state: ReadinessState.pass,
          evidence: 'ArchiveRecordNode seed يغطي التسلسل الكامل.',
          blocker: 'يتطلب DB schema لاحقًا قبل الإنتاج.',
        ),
        ReadinessCheckpoint(
          id: 'RDY-EVIDENCE-001',
          stage: ReadinessStage.evidence,
          title: 'Evidence Registry + Representations',
          state: ReadinessState.pass,
          evidence: 'سجل أدلة وتمثيلات محلية مع حقوق وسلسلة مصدر.',
          blocker: 'لا توجد ملفات فعلية أو File Center.',
        ),
        ReadinessCheckpoint(
          id: 'RDY-REVIEW-001',
          stage: ReadinessStage.review,
          title: 'مسار مراجعة محلي',
          state: ReadinessState.pass,
          evidence: 'Review Queue تدعم تغيير حالة المهمة محليًا.',
          blocker: 'الاعتماد النهائي يحتاج Authority/RLS لاحقًا.',
        ),
        ReadinessCheckpoint(
          id: 'RDY-SPATIAL-001',
          stage: ReadinessStage.spatialSearch,
          title: 'Spatial/Search/Temporal محلي',
          state: ReadinessState.warning,
          evidence: 'روابط مكانية وزمنية وفلاتر بحث تعمل على fixture.',
          blocker: 'لا PostGIS ولا flutter_map في هذا المسار المحلي.',
        ),
        ReadinessCheckpoint(
          id: 'RDY-ADMIN-001',
          stage: ReadinessStage.admin,
          title: 'حوكمة وإعدادات تشغيلية',
          state: ReadinessState.pass,
          evidence: 'Policies + Feature Flags + Health/Fallback ظاهرة.',
          blocker: 'تحتاج ربط سلطة مركزي لاحقًا.',
        ),
        ReadinessCheckpoint(
          id: 'RDY-STAGING-001',
          stage: ReadinessStage.stagingReadiness,
          title: 'جاهزية Staging',
          state: ReadinessState.warning,
          evidence: 'عقود الإدماج والـUAT matrix موجودة.',
          blocker: 'Staging غير معتمد بعد.',
        ),
        ReadinessCheckpoint(
          id: 'RDY-UAT-001',
          stage: ReadinessStage.controlledUat,
          title: 'Controlled Remote UAT',
          state: ReadinessState.notStarted,
          evidence: 'غير منفذ؛ هذه الشاشة تجهز الخطة فقط.',
          blocker: 'يتطلب تفويض Staging صريح.',
        ),
        ReadinessCheckpoint(
          id: 'RDY-PROD-001',
          stage: ReadinessStage.productionReadiness,
          title: 'Production Readiness',
          state: ReadinessState.blocked,
          evidence: 'Production approval غير موجود.',
          blocker: 'PRODUCTION_APPROVAL=NOT_APPROVED',
        ),
      ],
      activities: [
        LocalActivity(
          id: 'ACT-001',
          message:
              'تم تشغيل مساحة العمل المحلية ببيانات fixture ضمن وحدة محلية واحدة.',
          at: now,
        ),
      ],
      reports: [
        ArchiveReport(
          id: 'RPT-DAILY-001',
          title: 'تقرير الإنتاج اليومي',
          scope: 'الوثائق والمراجعات والتمثيلات',
          metric: '3 وثائق / 3 مراجعات / 3 تمثيلات',
          summary:
              'LOCAL_REPORTING_DASHBOARD: تقرير محلي للتجربة لا يمثل BI إنتاجيًا.',
          state: 'جاهز محليًا',
          unitScopeKey: localUnitScopeKey,
        ),
        ArchiveReport(
          id: 'RPT-RISK-001',
          title: 'تقرير المخاطر والقيود',
          scope: 'المواد المقيدة والمحجورة',
          metric: 'مقيد: 1 / محجور: 0',
          summary: 'يستخدم لمراجعة السرية والحقوق قبل الإتاحة.',
          state: 'يحتاج مراجعة دورية',
          unitScopeKey: localUnitScopeKey,
        ),
      ],
      notifications: [
        ArchiveNotification(
          id: 'NOTIF-001',
          title: 'مراجعة مفتوحة',
          message: 'توجد وثائق قيد المراجعة تحتاج قرارًا محليًا.',
          severity: 'عمل يومي',
          createdAt: now.subtract(const Duration(hours: 2)),
          acknowledged: false,
          unitScopeKey: localUnitScopeKey,
        ),
        ArchiveNotification(
          id: 'NOTIF-002',
          title: 'تنبيه أمان',
          message:
              'النسخ الاحتياطي هنا محاكاة محلية فقط ولا يغني عن Backup إنتاجي.',
          severity: 'حوكمة تشغيلية',
          createdAt: now.subtract(const Duration(hours: 4)),
          acknowledged: false,
          unitScopeKey: localUnitScopeKey,
        ),
      ],
      backupSnapshots: [
        BackupSnapshot(
          id: 'BKP-LOCAL-001',
          title: 'لقطة جلسة محلية أولية',
          createdAt: now.subtract(const Duration(hours: 1)),
          status: 'مكتمل محليًا',
          coverage: 'metadata + fixture state + activity log',
          hashPreview: 'sha256:LOCAL-BACKUP-SNAPSHOT-001',
          restoreDrillStatus: 'لم يبدأ اختبار الاسترجاع',
          unitScopeKey: localUnitScopeKey,
        ),
      ],
      exportRequests: [
        ExportRequest(
          id: 'EXP-LOCAL-001',
          title: 'تصدير نتائج البحث التجريبية',
          format: 'CSV',
          status: 'جاهز محليًا',
          requestedAt: now.subtract(const Duration(minutes: 45)),
          scope: 'نتائج بحث داخلية غير منشورة',
          unitScopeKey: localUnitScopeKey,
        ),
      ],
      smartIndexJobs: [
        SmartIndexJob(
          id: 'IDX-LOCAL-001',
          evidenceId: 'EV-DEMO-WAQF-0001',
          jobType: 'OCR + فهرسة كلمات مفتاحية',
          status: 'مكتمل محليًا',
          extractedTextPreview:
              'نص OCR تجريبي مقتطع من وثيقة وقفية محلية غير معتمد.',
          suggestedKeywords: const ['وقف', 'حجة', 'برك سليمان'],
          suggestedCategory: 'وثائق وقفية / حجج',
          confidence: 'متوسطة — تحتاج اعتماد بشري',
          createdAt: now.subtract(const Duration(minutes: 30)),
          unitScopeKey: localUnitScopeKey,
        ),
      ],
      duplicateCandidates: [
        DuplicateCandidate(
          id: 'DUP-LOCAL-001',
          primaryEvidenceId: 'EV-DEMO-WAQF-0001',
          candidateEvidenceId: 'EV-DEMO-OTTOMAN-0001',
          similarityLabel: 'تشابه وصفي متوسط',
          rationale: 'يتشاركان مرجع Fonds/ملف وقفي، ولا يوجد قرار دمج تلقائي.',
          status: 'بانتظار قرار',
          unitScopeKey: localUnitScopeKey,
        ),
      ],
      savedSearches: [
        SavedSearch(
          id: 'SRCH-LOCAL-001',
          title: 'وثائق مرتبطة بأصل وقفي',
          query: 'PWF-AST-DEMO-0001',
          filtersSummary: 'waqf_asset_id + داخلي/وحدة فقط',
          createdAt: now.subtract(const Duration(minutes: 20)),
          unitScopeKey: localUnitScopeKey,
        ),
      ],
      taxonomySuggestions: [
        TaxonomySuggestion(
          id: 'TAX-LOCAL-001',
          title: 'سلسلة وثائق وقفية مقترحة من الكلمات المفتاحية',
          suggestedNodeType: ArchiveNodeType.series,
          sourceEvidenceId: 'EV-DEMO-WAQF-0001',
          confidence: 'مرشح محلي — يتطلب أمين أرشيف',
          status: 'بانتظار قرار',
          unitScopeKey: localUnitScopeKey,
        ),
      ],
      accessPolicies: [
        AccessPolicyRule(
          id: 'POL-ACCESS-LOCAL-001',
          title: 'موظف الأرشيف — إدخال ومراجعة أولية',
          role: 'archivist',
          allowedAccessLevels: const [
            AccessLevel.internal,
            AccessLevel.unitOnly,
          ],
          scopeSummary: 'قراءة وتحديث وثائق الوحدة المحلية فقط؛ لا نشر عام.',
          status: 'مفعلة محليًا',
          unitScopeKey: localUnitScopeKey,
        ),
        AccessPolicyRule(
          id: 'POL-ACCESS-LOCAL-002',
          title: 'المراجع القانوني — وثائق مقيدة',
          role: 'legal_reviewer',
          allowedAccessLevels: const [
            AccessLevel.internal,
            AccessLevel.unitOnly,
            AccessLevel.restricted,
          ],
          scopeSummary: 'يرى المواد المقيدة ضمن الوحدة بغرض المراجعة فقط.',
          status: 'مفعلة محليًا',
          unitScopeKey: localUnitScopeKey,
        ),
      ],
      publicationRequests: [
        PublicationRequest(
          id: 'PUB-LOCAL-001',
          evidenceId: 'EV-DEMO-OTTOMAN-0001',
          title: 'طلب إتاحة داخلية لوصف عثماني تجريبي',
          requestedAccessLevel: AccessLevel.unitOnly,
          status: 'بانتظار مراجعة الإتاحة',
          reason: 'مادة أرشيفية تحتاج مراجعة حقوق قبل تعميمها على الوحدة.',
          requestedAt: now.subtract(const Duration(hours: 5)),
          unitScopeKey: localUnitScopeKey,
        ),
      ],
      retentionRules: [
        RetentionRule(
          id: 'RET-LOCAL-001',
          title: 'وثائق الملكية والوقف',
          evidenceId: 'EV-DEMO-WAQF-0001',
          retentionLabel: 'حفظ دائم',
          reviewDateLabel: 'مراجعة سنوية للحقوق والإتاحة',
          dispositionAction: 'لا إتلاف؛ مراجعة صلاحية النشر فقط.',
          status: 'نشطة',
          unitScopeKey: localUnitScopeKey,
        ),
        RetentionRule(
          id: 'RET-LOCAL-002',
          title: 'مخرجات التحليل المكاني المشتقة',
          evidenceId: 'EV-DEMO-SPATIAL-0001',
          retentionLabel: 'احتفاظ تشغيلي مؤقت',
          reviewDateLabel: 'كل 90 يومًا',
          dispositionAction: 'إعادة توليد أو حجر عند تغير المصدر.',
          status: 'تحتاج مراجعة',
          unitScopeKey: localUnitScopeKey,
        ),
      ],
      auditTrail: [
        AuditTrailEntry(
          id: 'AUD-LOCAL-001',
          actorLabel: 'local.session.operator',
          action: 'تهيئة سجل تدقيق محلي',
          targetId: 'LOCAL-DEMO-UNIT',
          outcome: 'تم إنشاء سجل تدريبي دون كتابة خارجية',
          createdAt: now.subtract(const Duration(hours: 4)),
          unitScopeKey: localUnitScopeKey,
        ),
      ],
    );
  }

  String createOcrTranslationTranscriptionDraftLayer({
    required String evidenceId,
    required TextDraftLayerKind kind,
    required String languageLabel,
    required String textPreview,
    String sourceLabel = 'إدخال/محاكاة محلية — لا يوجد محرك OCR أو ترجمة حقيقي',
    List<String> qualityWarnings = const [],
    bool createLinkedRepresentation = true,
  }) {
    // MEGA_BATCH_ARCHIVE_OCR_TRANSLATION_TRANSCRIPTION_DRAFT_LAYER_V1
    // OCR_TRANSLATION_TRANSCRIPTION_DRAFT_LAYER + TEXT_DRAFT_REPRESENTATION_LINKING.
    // NO_REAL_OCR_ENGINE + NO_REAL_TRANSLATION_ENGINE: this creates session-local draft text layers only.
    // REVIEW_STUDIO_R3_TEXT_DRAFT_POLICY_REPAIR + TEXT_DRAFT_POLICY_MARKER_RETENTION: HUMAN_REVIEW_REQUIRED_FOR_TEXT_DRAFTS + NO_PUBLICATION_FROM_TEXT_DRAFTS remain mandatory.
    final evidence = _evidenceById(evidenceId);
    _requireLocalUnit(evidence.unitScopeKey, 'إضافة طبقة نصية مسودة');
    final now = DateTime.now();
    final representationId = createLinkedRepresentation
        ? 'REP-TEXT-DRAFT-${now.microsecondsSinceEpoch}'
        : 'REP-TEXT-DRAFT-NOT-CREATED';
    final representation = createLinkedRepresentation
        ? ArchiveRepresentation(
            id: representationId,
            evidenceId: evidenceId,
            type: kind.representationType,
            title: '${kind.label} — ${evidence.documentTypeTabTitle}',
            format: 'text/plain; draft-layer',
            hashPreview: 'sha256:TEXT-DRAFT-${now.microsecondsSinceEpoch}',
            rightsStatus: 'مشتق نصي غير منشور — مراجعة بشرية مطلوبة',
            unitScopeKey: localUnitScopeKey,
            isAuthoritativeOriginal: false,
            uploadStatus:
                'مسودة نصية مرتبطة بالتمثيلات — TEXT_DRAFT_REPRESENTATION_LINKING',
            previewKind: kind.label,
            previewNote:
                'مسودة OCR/تفريغ/ترجمة داخلية لا تعتمد ولا تنشر قبل المراجعة.',
          )
        : null;
    final layer = TextDraftLayer(
      id: 'TXT-DRAFT-${now.microsecondsSinceEpoch}',
      evidenceId: evidenceId,
      representationId: representationId,
      kind: kind,
      catalogId: evidence.catalogId,
      documentTypeTabId: evidence.documentTypeTabId,
      languageLabel:
          languageLabel.trim().isEmpty ? 'غير محدد' : languageLabel.trim(),
      sourceLabel: sourceLabel.trim().isEmpty
          ? 'NO_REAL_OCR_ENGINE / NO_REAL_TRANSLATION_ENGINE — مسودة محلية'
          : sourceLabel.trim(),
      textPreview: textPreview.trim().isEmpty
          ? 'مسودة نصية فارغة مقبولة للتطوير؛ تحتاج إدخالًا ومراجعة بشرية.'
          : textPreview.trim(),
      status:
          '${kind.label} غير معتمدة — HUMAN_REVIEW_REQUIRED_FOR_TEXT_DRAFTS',
      qualityWarnings: qualityWarnings.isEmpty
          ? const ['مسودة غير معتمدة', 'لا نشر قبل المراجعة البشرية']
          : qualityWarnings,
      humanReviewPolicy:
          'PUBLICATION_REQUIRES_HUMAN_APPROVAL — NO_PUBLICATION_FROM_TEXT_DRAFTS',
      createdAt: now,
      unitScopeKey: localUnitScopeKey,
    );
    state = state.copyWith(
      textDraftLayers: [layer, ...state.textDraftLayers],
      representations: [
        if (representation != null) representation,
        ...state.representations,
      ],
      auditTrail: [
        _audit(
          'إضافة طبقة نصية مسودة',
          evidenceId,
          '${kind.label} مرتبطة بالكتالوج ${evidence.catalogId} ولا تنشر قبل الاعتماد البشري',
        ),
        ...state.auditTrail,
      ],
      activities:
          _withActivity('أضيفت ${kind.label} للوثيقة ${evidence.title}'),
    );
    return layer.id;
  }

  void markTextDraftLayerReviewed(String layerId) {
    // TEXT_DRAFT_HUMAN_REVIEW_GATE: review marks the layer internally only;
    // it does not publish and does not replace the original source.
    final existing =
        state.textDraftLayers.firstWhere((item) => item.id == layerId);
    _requireLocalUnit(existing.unitScopeKey, 'مراجعة طبقة نصية');
    state = state.copyWith(
      textDraftLayers: [
        for (final item in state.textDraftLayers)
          if (item.id == layerId)
            item.copyWith(
                status:
                    '${item.kind.label} مراجعة داخليًا — لا تزال غير منشورة')
          else
            item,
      ],
      auditTrail: [
        _audit('مراجعة طبقة نصية', existing.evidenceId,
            'تم وسم الطبقة كمراجعة داخليًا دون نشر'),
        ...state.auditTrail,
      ],
      activities: _withActivity('وُسمت ${existing.kind.label} كمراجعة داخليًا'),
    );
  }

  String createCatalogAwareDraftFromTemplate({
    required String catalogId,
    required String catalogTitle,
    required String documentTypeTabId,
    required String documentTypeTabTitle,
    required String metadataTemplateId,
    required Map<String, String> metadataValues,
    String title = '',
    String sourceAuthority = 'إدخال تطويري مفتوح',
    String reference = '',
    bool createDraftRepresentation = true,
  }) {
    // CATALOG_AWARE_METADATA_TEMPLATES_AND_DRAFT_FORMS:
    // CATALOG_AWARE_METADATA_TEMPLATES + DYNAMIC_DRAFT_FORM_FIELDS.
    // This accepts partial template metadata in the development draft zone.
    final template = state.metadataTemplateById(metadataTemplateId);
    final missingWarnings = <String>[
      if (template != null)
        for (final field in template.fields)
          if (field.isRecommended &&
              (metadataValues[field.key] == null ||
                  metadataValues[field.key]!.trim().isEmpty))
            'ينقص الحقل المقترح: ${field.label}',
    ];
    final aiPlan = template?.aiAssistancePlan ??
        'AI_ASSISTED_METADATA_DRAFTING_READY — OCR/translation/entity extraction later, with human review.';
    return createOpenDraftArchiveMaterial(
      catalogId: catalogId,
      catalogTitle: catalogTitle,
      documentTypeTabId: documentTypeTabId,
      documentTypeTabTitle: documentTypeTabTitle,
      title: title,
      sourceAuthority: sourceAuthority,
      reference: reference,
      notes:
          'قالب metadata حسب الكتالوج والنوع؛ يقبل النقص كمسودة ولا يسمح بالنشر قبل الاعتماد البشري.',
      metadataTemplateId: metadataTemplateId,
      structuredMetadata: metadataValues,
      missingMetadataWarnings: missingWarnings,
      templateReadinessLabel: missingWarnings.isEmpty
          ? 'قالب مكتمل مبدئيًا — لا يزال يحتاج مراجعة نشر'
          : 'قالب غير مكتمل مقبول كمسودة تطويرية',
      aiAssistancePlan: aiPlan,
      createDraftRepresentation: createDraftRepresentation,
    );
  }

  String createOpenDraftArchiveMaterial({
    required String catalogId,
    required String catalogTitle,
    required String documentTypeTabId,
    required String documentTypeTabTitle,
    required String title,
    String sourceAuthority = 'إدخال تطويري مفتوح',
    String reference = '',
    String dateLabel = 'غير محدد',
    String languageHint = 'غير محدد',
    String notes = 'مسودة أولية لتطوير الواجهات وفهم متطلبات الوثيقة',
    String metadataTemplateId = 'template-general-document',
    Map<String, String> structuredMetadata = const {},
    List<String> missingMetadataWarnings = const [],
    String templateReadinessLabel = 'مسودة ناقصة مقبولة للتطوير',
    String aiAssistancePlan = 'AI_ASSISTED_METADATA_DRAFTING_READY',
    bool createDraftRepresentation = true,
  }) {
    // LAYERED_CATALOGS_OPEN_DRAFT_INTAKE_AND_PAGE_ALIGNMENT:
    // OPEN_DRAFT_INTAKE_MODE + CATALOG_AWARE_INTAKE.
    // NO_INTAKE_BLOCKING_GOVERNANCE: missing metadata is accepted as warnings
    // in the development draft zone. Publication remains blocked until human approval.
    _requireLocalUnit(localUnitScopeKey, 'إدخال مسودة أرشيفية مفتوحة');
    final now = DateTime.now();
    final safeTitle = title.trim().isEmpty
        ? 'مسودة أرشيفية غير معنونة — ${documentTypeTabTitle.trim()}'
        : title.trim();
    final safeReference = reference.trim().isEmpty
        ? 'OPEN-DRAFT/${catalogId.toUpperCase()}/${now.microsecondsSinceEpoch}'
        : reference.trim();
    final id = 'EV-DRAFT-${now.microsecondsSinceEpoch}';
    final evidence = EvidenceItem(
      id: id,
      title: safeTitle,
      domain: catalogId.contains('ottoman')
          ? EvidenceDomain.ottoman
          : EvidenceDomain.general,
      sourceAuthority: sourceAuthority.trim().isEmpty
          ? 'إدخال تطويري مفتوح'
          : sourceAuthority.trim(),
      reference: safeReference,
      status: EvidenceReviewStatus.discovered,
      confidence: 'مسودة أولية غير مراجعة — للتطوير والفهم وبناء الواجهات',
      unitScopeKey: localUnitScopeKey,
      isOriginalAvailableLocally: createDraftRepresentation,
      createdAt: now,
      dateLabel: dateLabel.trim().isEmpty ? 'غير محدد' : dateLabel.trim(),
      rightsStatus: 'غير منشور — الحقوق قيد التوصيف',
      legalSensitivity: 'غير مصنف — يحتاج مراجعة قبل النشر',
      accessLevel: AccessLevel.internal,
      spatialStatus: SpatialStatus.notMapped,
      departmentLabel: catalogTitle,
      subjectLabel: documentTypeTabTitle,
      documentType: documentTypeTabTitle,
      keywords: [catalogTitle, documentTypeTabTitle, languageHint]
          .map((item) => item.trim())
          .where((item) => item.isNotEmpty)
          .toList(growable: false),
      workflowNote: notes.trim().isEmpty
          ? 'أدخل كل شيء للتطوير والفهم وبناء الواجهات؛ لا نشر قبل الاعتماد البشري.'
          : notes.trim(),
      catalogId: catalogId,
      catalogTitle: catalogTitle,
      documentTypeTabId: documentTypeTabId,
      documentTypeTabTitle: documentTypeTabTitle,
      draftStage: 'مسودة أولية — Open Draft Intake',
      publicationStatus:
          'PUBLICATION_REQUIRES_HUMAN_APPROVAL — النشر ممنوع قبل الاعتماد البشري',
      intakeMode: 'OPEN_DRAFT_INTAKE_MODE',
      metadataTemplateId: metadataTemplateId,
      structuredMetadata: structuredMetadata,
      missingMetadataWarnings: missingMetadataWarnings,
      templateReadinessLabel: templateReadinessLabel,
      aiAssistancePlan: aiAssistancePlan,
    );
    final representation = createDraftRepresentation
        ? ArchiveRepresentation(
            id: 'REP-DRAFT-${now.microsecondsSinceEpoch}',
            evidenceId: id,
            type: RepresentationType.scan,
            title: 'تمثيل مسودة — $documentTypeTabTitle',
            format: 'draft-placeholder',
            hashPreview: 'sha256:DRAFT-${now.microsecondsSinceEpoch}',
            rightsStatus: 'تمثيل مسودة غير منشور',
            unitScopeKey: localUnitScopeKey,
            isAuthoritativeOriginal: false,
            uploadStatus:
                'مسودة في طابور التمثيلات — DRAFT_REPRESENTATIONS_ALLOWED',
            previewKind: 'صورة/تمثيل أولي',
            previewNote: 'يقبل الصور والتفريغ والترجمة وOCR كمسودات تطويرية.',
          )
        : null;
    state = state.copyWith(
      evidence: [evidence, ...state.evidence],
      representations: [
        if (representation != null) representation,
        ...state.representations,
      ],
      auditTrail: [
        _audit(
          'إدخال مسودة أرشيفية مفتوحة',
          id,
          'قُبلت كمسودة تطويرية؛ النشر محجوب حتى مراجعة بشرية',
        ),
        ...state.auditTrail,
      ],
      activities:
          _withActivity('أدخلت مسودة من $catalogTitle / $documentTypeTabTitle'),
    );
    return id;
  }

  void addEvidence(EvidenceItem item) {
    _requireLocalUnit(item.unitScopeKey, 'إضافة دليل');
    state = state.copyWith(
      evidence: [...state.evidence, item],
      activities: _withActivity('أضيف دليل محلي جديد: ${item.title}'),
    );
  }

  void updateEvidence(EvidenceItem updated) {
    _requireLocalUnit(updated.unitScopeKey, 'تعديل دليل');
    final existing = _evidenceById(updated.id);
    _requireLocalUnit(existing.unitScopeKey, 'تعديل دليل قائم');
    state = state.copyWith(
      evidence: [
        for (final item in state.evidence)
          if (item.id == updated.id) updated else item,
      ],
      activities: _withActivity('تم تعديل وصف الدليل: ${updated.title}'),
    );
  }

  String createGovernedDocumentDraft({
    required String title,
    required String sourceAuthority,
    required String reference,
    required EvidenceDomain domain,
    required AccessLevel accessLevel,
    required SpatialStatus spatialStatus,
    required String dateLabel,
    required String rightsStatus,
    required String legalSensitivity,
    required String departmentLabel,
    required String subjectLabel,
    required String documentType,
    required List<String> keywords,
    required bool hasOriginal,
    required bool createInitialRepresentation,
    required bool submitForReview,
    String? linkedWaqfAssetId,
    String? linkedCaseId,
    String workflowNote = 'أُنشئت عبر تدفق إضافة وثيقة محكوم محليًا',
    String catalogId = 'catalog-general',
    String catalogTitle = 'كتالوج عام',
    String documentTypeTabId = 'general-document',
    String documentTypeTabTitle = 'وثيقة عامة',
    String metadataTemplateId = 'template-general-document',
    Map<String, String> structuredMetadata = const {},
    List<String> missingMetadataWarnings = const [],
    String templateReadinessLabel = 'مسودة ناقصة مقبولة للتطوير',
    String aiAssistancePlan = 'AI assistance pending human review',
  }) {
    // PRODUCTIVE_DOCUMENT_DETAIL_ADD_FLOW_AND_GOVERNED_WORKFLOW:
    // create document + optional representation + optional review task in one
    // scoped session-local transaction. This is not a database write.
    _requireLocalUnit(localUnitScopeKey, 'إنشاء وثيقة عبر تدفق محكوم');
    final now = DateTime.now();
    final safeTitle =
        title.trim().isEmpty ? 'وثيقة محلية دون عنوان' : title.trim();
    final safeReference = reference.trim().isEmpty
        ? 'LOCAL/DOC/${now.microsecondsSinceEpoch}'
        : reference.trim();
    final normalizedKeywords = keywords
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toSet()
        .toList(growable: false);
    final id = 'EV-LOCAL-${now.microsecondsSinceEpoch}';
    final evidence = EvidenceItem(
      id: id,
      title: safeTitle,
      domain: domain,
      sourceAuthority: sourceAuthority.trim().isEmpty
          ? 'إدخال محلي'
          : sourceAuthority.trim(),
      reference: safeReference,
      status: submitForReview
          ? EvidenceReviewStatus.inReview
          : EvidenceReviewStatus.discovered,
      confidence: 'مدخل محلي يحتاج مراجعة بشرية',
      unitScopeKey: localUnitScopeKey,
      isOriginalAvailableLocally: hasOriginal,
      createdAt: now,
      dateLabel: dateLabel.trim().isEmpty ? 'غير محدد' : dateLabel.trim(),
      rightsStatus: rightsStatus.trim().isEmpty
          ? 'حقوق داخلية قيد المراجعة'
          : rightsStatus.trim(),
      legalSensitivity: legalSensitivity.trim().isEmpty
          ? 'غير مصنف'
          : legalSensitivity.trim(),
      linkedWaqfAssetId:
          linkedWaqfAssetId == null || linkedWaqfAssetId.trim().isEmpty
              ? null
              : linkedWaqfAssetId.trim(),
      linkedCaseId: linkedCaseId == null || linkedCaseId.trim().isEmpty
          ? null
          : linkedCaseId.trim(),
      accessLevel: accessLevel,
      spatialStatus: spatialStatus,
      departmentLabel: departmentLabel.trim().isEmpty
          ? domain.label
          : departmentLabel.trim(),
      subjectLabel:
          subjectLabel.trim().isEmpty ? 'غير محدد' : subjectLabel.trim(),
      documentType:
          documentType.trim().isEmpty ? 'وثيقة عامة' : documentType.trim(),
      keywords: normalizedKeywords,
      workflowNote: workflowNote.trim().isEmpty
          ? 'أُنشئت عبر تدفق إضافة وثيقة محكوم محليًا'
          : workflowNote.trim(),
      catalogId: catalogId,
      catalogTitle: catalogTitle,
      documentTypeTabId: documentTypeTabId,
      documentTypeTabTitle: documentTypeTabTitle,
      draftStage: 'مسودة أولية',
      publicationStatus: 'غير منشور — يتطلب اعتمادًا بشريًا قبل النشر',
      intakeMode: 'Open Draft Intake',
      metadataTemplateId: metadataTemplateId,
      structuredMetadata: structuredMetadata,
      missingMetadataWarnings: missingMetadataWarnings,
      templateReadinessLabel: templateReadinessLabel,
      aiAssistancePlan: aiAssistancePlan,
    );

    final representation = createInitialRepresentation
        ? ArchiveRepresentation(
            id: 'REP-LOCAL-${now.microsecondsSinceEpoch}',
            evidenceId: id,
            type: RepresentationType.original,
            title: 'أصل محلي مؤقت — ${safeTitle}',
            format: 'local-placeholder',
            hashPreview: 'sha256:LOCAL-${now.microsecondsSinceEpoch}',
            rightsStatus: evidence.rightsStatus,
            unitScopeKey: localUnitScopeKey,
            isAuthoritativeOriginal: hasOriginal,
          )
        : null;

    final reviewTask = submitForReview
        ? ReviewTask(
            id: 'REV-LOCAL-${now.microsecondsSinceEpoch}',
            title: 'مراجعة وثيقة جديدة: $safeTitle',
            evidenceId: id,
            domain: domain,
            priority: accessLevel == AccessLevel.restricted ? 'عالية' : 'عادية',
            assignedRole: 'مراجع أرشيف',
            state: ReviewTaskState.open,
            unitScopeKey: localUnitScopeKey,
          )
        : null;

    state = state.copyWith(
      evidence: [evidence, ...state.evidence],
      representations: [
        if (representation != null) representation,
        ...state.representations,
      ],
      reviewTasks: [
        if (reviewTask != null) reviewTask,
        ...state.reviewTasks,
      ],
      auditTrail: [
        _audit(
          'إنشاء وثيقة عبر تدفق محكوم',
          id,
          submitForReview
              ? 'أُنشئت الوثيقة وأرسلت للمراجعة محليًا'
              : 'أُنشئت الوثيقة كمسودة محلية',
        ),
        ...state.auditTrail,
      ],
      activities: _withActivity('أُنشئت وثيقة محكومة محليًا: $safeTitle'),
    );
    return id;
  }

  void quarantineEvidence(String id) {
    final existing = _evidenceById(id);
    _requireLocalUnit(existing.unitScopeKey, 'حجر دليل');
    final updated = [
      for (final item in state.evidence)
        if (item.id == id)
          item.copyWith(status: EvidenceReviewStatus.quarantined)
        else
          item,
    ];
    state = state.copyWith(
      evidence: updated,
      activities: _withActivity('تم حجر دليل محليًا: $id'),
    );
  }

  void restoreEvidence(String id) {
    final existing = _evidenceById(id);
    _requireLocalUnit(existing.unitScopeKey, 'استعادة دليل');
    final updated = [
      for (final item in state.evidence)
        if (item.id == id)
          item.copyWith(status: EvidenceReviewStatus.inReview)
        else
          item,
    ];
    state = state.copyWith(
      evidence: updated,
      activities: _withActivity('تمت استعادة دليل داخل الجلسة: $id'),
    );
  }

  void approveEvidenceInternally(String id) {
    final existing = _evidenceById(id);
    _requireLocalUnit(existing.unitScopeKey, 'اعتماد داخلي');
    state = state.copyWith(
      evidence: [
        for (final item in state.evidence)
          if (item.id == id)
            item.copyWith(status: EvidenceReviewStatus.internalReady)
          else
            item,
      ],
      activities: _withActivity('تم اعتماد دليل داخليًا داخل الجلسة: $id'),
    );
  }

  void addCollection(ArchiveCollection collection) {
    _requireLocalUnit(collection.unitScopeKey, 'إضافة مجموعة');
    state = state.copyWith(
      collections: [...state.collections, collection],
      activities: _withActivity('أضيفت مجموعة محلية: ${collection.title}'),
    );
  }

  void addArchiveNode(ArchiveRecordNode node) {
    _requireLocalUnit(node.unitScopeKey, 'إضافة سجل أرشيفي');
    state = state.copyWith(
      archiveNodes: [...state.archiveNodes, node],
      activities: _withActivity('أضيف سجل أرشيفي محلي: ${node.title}'),
    );
  }

  void addRelation(EvidenceRelation relation) {
    _requireLocalUnit(relation.unitScopeKey, 'اقتراح علاقة');
    final from = _evidenceById(relation.fromEvidenceId);
    final to = _evidenceById(relation.toEvidenceId);
    _requireLocalUnit(from.unitScopeKey, 'مصدر العلاقة');
    _requireLocalUnit(to.unitScopeKey, 'هدف العلاقة');
    if (from.unitScopeKey != to.unitScopeKey ||
        from.unitScopeKey != relation.unitScopeKey) {
      throw StateError('CROSS_UNIT_RELATION_DENIED');
    }
    state = state.copyWith(
      relations: [...state.relations, relation],
      activities: _withActivity('أضيف رابط دليل مرشح: ${relation.id}'),
    );
  }

  void updateEvidenceStatus(String id, EvidenceReviewStatus status) {
    final existing = _evidenceById(id);
    _requireLocalUnit(existing.unitScopeKey, 'تحديث حالة وثيقة');
    state = state.copyWith(
      evidence: [
        for (final item in state.evidence)
          if (item.id == id) item.copyWith(status: status) else item,
      ],
      activities: _withActivity('تم تحديث حالة الوثيقة: $id → ${status.label}'),
    );
  }

  void submitEvidenceForReview(String id) {
    // DOCUMENTS_WORKFLOW_OPERATIONALIZATION: local-only workflow transition.
    final existing = _evidenceById(id);
    _requireLocalUnit(existing.unitScopeKey, 'إرسال وثيقة للمراجعة');
    final hasOpenTask = state.reviewTasks.any(
      (task) =>
          task.evidenceId == id &&
          task.state != ReviewTaskState.completed &&
          task.state != ReviewTaskState.cancelled,
    );
    final nextTasks = hasOpenTask
        ? state.reviewTasks
        : [
            ReviewTask(
              id: 'REV-LOCAL-${DateTime.now().microsecondsSinceEpoch}',
              title: 'مراجعة تشغيلية للوثيقة: ${existing.title}',
              evidenceId: existing.id,
              domain: existing.domain,
              priority: existing.accessLevel == AccessLevel.restricted
                  ? 'حرجة'
                  : 'عادية',
              assignedRole: 'مراجع أرشيف',
              state: ReviewTaskState.open,
              unitScopeKey: localUnitScopeKey,
            ),
            ...state.reviewTasks,
          ];
    state = state.copyWith(
      evidence: [
        for (final item in state.evidence)
          if (item.id == id)
            item.copyWith(status: EvidenceReviewStatus.inReview)
          else
            item,
      ],
      reviewTasks: nextTasks,
      activities: _withActivity('تم إرسال الوثيقة للمراجعة محليًا: $id'),
    );
  }

  void addReviewTask(ReviewTask task) {
    _requireLocalUnit(task.unitScopeKey, 'إضافة مهمة مراجعة');
    final evidence = _evidenceById(task.evidenceId);
    _requireLocalUnit(evidence.unitScopeKey, 'ربط مهمة مراجعة بوثيقة');
    state = state.copyWith(
      reviewTasks: [task, ...state.reviewTasks],
      activities: _withActivity('أضيفت مهمة مراجعة محلية: ${task.title}'),
    );
  }

  void updateReviewTask(String taskId, ReviewTaskState nextState) {
    final task = state.reviewTasks.firstWhere(
      (candidate) => candidate.id == taskId,
      orElse: () => throw StateError('REVIEW_TASK_NOT_FOUND'),
    );
    _requireLocalUnit(task.unitScopeKey, 'تحديث مهمة مراجعة');
    state = state.copyWith(
      reviewTasks: [
        for (final item in state.reviewTasks)
          if (item.id == taskId) item.copyWith(state: nextState) else item,
      ],
      activities: _withActivity(
          'تم تحديث حالة مهمة مراجعة: $taskId → ${nextState.label}'),
    );
  }

  void completeReviewTaskAndApprove(String taskId) {
    // REVIEW_QUEUE_WORKFLOW_ACTIONS: complete task and move linked document.
    final task = state.reviewTasks.firstWhere(
      (candidate) => candidate.id == taskId,
      orElse: () => throw StateError('REVIEW_TASK_NOT_FOUND'),
    );
    _requireLocalUnit(task.unitScopeKey, 'إكمال مهمة مراجعة');
    final evidence = _evidenceById(task.evidenceId);
    _requireLocalUnit(evidence.unitScopeKey, 'اعتماد وثيقة مرتبطة بمهمة');
    state = state.copyWith(
      reviewTasks: [
        for (final item in state.reviewTasks)
          if (item.id == taskId)
            item.copyWith(state: ReviewTaskState.completed)
          else
            item,
      ],
      evidence: [
        for (final item in state.evidence)
          if (item.id == evidence.id)
            item.copyWith(status: EvidenceReviewStatus.internalReady)
          else
            item,
      ],
      activities: _withActivity(
          'اكتملت المراجعة واعتمدت الوثيقة داخليًا: ${evidence.id}'),
    );
  }

  void returnReviewTaskForCorrection(String taskId) {
    final task = state.reviewTasks.firstWhere(
      (candidate) => candidate.id == taskId,
      orElse: () => throw StateError('REVIEW_TASK_NOT_FOUND'),
    );
    _requireLocalUnit(task.unitScopeKey, 'إرجاع مهمة مراجعة للتصحيح');
    final evidence = _evidenceById(task.evidenceId);
    _requireLocalUnit(evidence.unitScopeKey, 'إرجاع وثيقة مرتبطة بمهمة');
    state = state.copyWith(
      reviewTasks: [
        for (final item in state.reviewTasks)
          if (item.id == taskId)
            item.copyWith(state: ReviewTaskState.open)
          else
            item,
      ],
      evidence: [
        for (final item in state.evidence)
          if (item.id == evidence.id)
            item.copyWith(status: EvidenceReviewStatus.discovered)
          else
            item,
      ],
      activities: _withActivity('أعيدت الوثيقة للتصحيح المحلي: ${evidence.id}'),
    );
  }

  String queueLocalRepresentation({
    required String evidenceId,
    required RepresentationType type,
    required String title,
    required String format,
    required String rightsStatus,
    required bool isAuthoritativeOriginal,
    String fileSizeLabel = 'غير محدد',
    String previewKind = 'معاينة وصفية',
    String previewNote = 'تمثيل محلي لا يحمل مسار ملف فعليًا',
  }) {
    // UPLOAD_REPRESENTATION_PREVIEW_AND_LOCAL_FILE_QUEUE: governed local-only
    // upload queue. No file path, object storage, File Center, or remote write.
    final evidence = _evidenceById(evidenceId);
    _requireLocalUnit(evidence.unitScopeKey, 'ربط تمثيل بوثيقة');
    final now = DateTime.now();
    final safeTitle =
        title.trim().isEmpty ? 'تمثيل محلي دون اسم' : title.trim();
    final safeFormat = format.trim().isEmpty ? 'unknown/local' : format.trim();
    final originalExists = state.representations.any(
      (item) => item.evidenceId == evidenceId && item.isAuthoritativeOriginal,
    );
    final replacementBlocked = isAuthoritativeOriginal && originalExists;
    final representation = ArchiveRepresentation(
      id: 'REP-LOCAL-${now.microsecondsSinceEpoch}',
      evidenceId: evidenceId,
      type: type,
      title: safeTitle,
      format: safeFormat,
      hashPreview: _localHashPreview(safeTitle, safeFormat),
      rightsStatus: rightsStatus.trim().isEmpty
          ? 'حقوق داخلية قيد المراجعة'
          : rightsStatus.trim(),
      unitScopeKey: localUnitScopeKey,
      isAuthoritativeOriginal: isAuthoritativeOriginal && !replacementBlocked,
      uploadStatus: replacementBlocked
          ? 'استبدال أصل محظور — يحتاج Version Event'
          : 'ضمن طابور الرفع المحلي',
      fileSizeLabel:
          fileSizeLabel.trim().isEmpty ? 'غير محدد' : fileSizeLabel.trim(),
      previewKind: previewKind.trim().isEmpty ? type.label : previewKind.trim(),
      previewNote: previewNote.trim().isEmpty
          ? 'تمثيل محلي لا يحمل مسار ملف فعليًا'
          : previewNote.trim(),
    );
    state = state.copyWith(
      representations: [representation, ...state.representations],
      auditTrail: [
        _audit(
          replacementBlocked ? 'منع استبدال أصل' : 'إضافة تمثيل إلى طابور محلي',
          evidenceId,
          replacementBlocked
              ? 'تم تسجيل الطلب كحظر محلي دون استبدال الأصل'
              : '${representation.type.label} / ${representation.hashPreview}',
        ),
        ...state.auditTrail,
      ],
      activities: _withActivity(
        replacementBlocked
            ? 'مُنع استبدال أصل محلي للوثيقة: $evidenceId'
            : 'أضيف تمثيل إلى طابور الرفع المحلي: $safeTitle',
      ),
    );
    return representation.id;
  }

  void markRepresentationReviewed(String representationId) {
    // REPRESENTATION_PREVIEW_REVIEW_ACTION: session-local review marker only.
    final representation = state.representations.firstWhere(
      (item) => item.id == representationId,
      orElse: () => throw StateError('REPRESENTATION_NOT_FOUND'),
    );
    _requireLocalUnit(representation.unitScopeKey, 'مراجعة تمثيل محلي');
    state = state.copyWith(
      representations: [
        for (final item in state.representations)
          if (item.id == representationId)
            item.copyWith(uploadStatus: 'مراجع محليًا — جاهز للفحص اللاحق')
          else
            item,
      ],
      auditTrail: [
        _audit(
            'مراجعة تمثيل محلي', representation.evidenceId, representation.id),
        ...state.auditTrail,
      ],
      activities:
          _withActivity('تمت مراجعة تمثيل محليًا: ${representation.title}'),
    );
  }

  void addRepresentation(ArchiveRepresentation representation) {
    _requireLocalUnit(representation.unitScopeKey, 'إضافة تمثيل');
    final evidence = _evidenceById(representation.evidenceId);
    _requireLocalUnit(evidence.unitScopeKey, 'ربط تمثيل بوثيقة');
    state = state.copyWith(
      representations: [...state.representations, representation],
      auditTrail: [
        _audit(
            'إضافة تمثيل محلي', representation.evidenceId, representation.id),
        ...state.auditTrail,
      ],
      activities: _withActivity('أضيف تمثيل محلي: ${representation.title}'),
    );
  }

  void addImportBatch(ImportBatch batch) {
    _requireLocalUnit(batch.unitScopeKey, 'فهرسة دفعة');
    state = state.copyWith(
      importBatches: [...state.importBatches, batch],
      activities: _withActivity('تمت فهرسة دفعة استيراد: ${batch.fileName}'),
    );
  }

  void updateImportBatchStatus(String batchId, ImportStatus status) {
    final batch = state.importBatches.firstWhere(
      (candidate) => candidate.id == batchId,
      orElse: () => throw StateError('IMPORT_BATCH_NOT_FOUND'),
    );
    _requireLocalUnit(batch.unitScopeKey, 'تحديث حالة دفعة استيراد');
    state = state.copyWith(
      importBatches: [
        for (final item in state.importBatches)
          if (item.id == batchId)
            ImportBatch(
              id: item.id,
              fileName: item.fileName,
              sheetName: item.sheetName,
              domain: item.domain,
              rowCount: item.rowCount,
              status: item.status,
              unitScopeKey: item.unitScopeKey,
              importStatus: status,
              validationSummary: item.validationSummary,
            )
          else
            item,
      ],
      activities:
          _withActivity('تم تحديث دفعة الاستيراد: $batchId → ${status.label}'),
    );
  }

  void acknowledgeNotification(String id) {
    // REPORTS_NOTIFICATIONS_BACKUP_OPERATIONALIZATION: acknowledge a session-local alert only.
    final notification = state.notifications.firstWhere(
      (candidate) => candidate.id == id,
      orElse: () => throw StateError('NOTIFICATION_NOT_FOUND'),
    );
    _requireLocalUnit(notification.unitScopeKey, 'تأكيد قراءة تنبيه');
    state = state.copyWith(
      notifications: [
        for (final item in state.notifications)
          if (item.id == id) item.copyWith(acknowledged: true) else item,
      ],
      activities: _withActivity('تم تأكيد قراءة تنبيه محلي: $id'),
    );
  }

  void createLocalBackupSnapshot(String title) {
    // BACKUP_RESTORE_DRILL_LOCAL: snapshot is metadata-only and session-local.
    final now = DateTime.now();
    final snapshot = BackupSnapshot(
      id: 'BKP-LOCAL-${now.microsecondsSinceEpoch}',
      title: title.trim().isEmpty ? 'لقطة نسخ محلية' : title.trim(),
      createdAt: now,
      status: 'مكتمل محليًا',
      coverage: 'metadata + workflow state + local activity log',
      hashPreview: 'sha256:LOCAL-${now.microsecondsSinceEpoch}',
      restoreDrillStatus: 'لم يبدأ اختبار الاسترجاع',
      unitScopeKey: localUnitScopeKey,
    );
    state = state.copyWith(
      backupSnapshots: [snapshot, ...state.backupSnapshots],
      activities: _withActivity('أُنشئت لقطة نسخ محلية: ${snapshot.title}'),
    );
  }

  void markBackupRestoreDrill(String id) {
    final snapshot = state.backupSnapshots.firstWhere(
      (candidate) => candidate.id == id,
      orElse: () => throw StateError('BACKUP_SNAPSHOT_NOT_FOUND'),
    );
    _requireLocalUnit(snapshot.unitScopeKey, 'اختبار استرجاع محلي');
    state = state.copyWith(
      backupSnapshots: [
        for (final item in state.backupSnapshots)
          if (item.id == id)
            item.copyWith(restoreDrillStatus: 'تم اختبار الاسترجاع محليًا')
          else
            item,
      ],
      activities: _withActivity('تم توثيق اختبار استرجاع محلي: $id'),
    );
  }

  void requestLocalExport(String title, String format) {
    // EXPORT_REQUEST_QUEUE_LOCAL: creates a local export request without writing files.
    final now = DateTime.now();
    final request = ExportRequest(
      id: 'EXP-LOCAL-${now.microsecondsSinceEpoch}',
      title: title.trim().isEmpty ? 'طلب تصدير محلي' : title.trim(),
      format: format,
      status: 'جاهز محليًا',
      requestedAt: now,
      scope: 'session-local metadata only',
      unitScopeKey: localUnitScopeKey,
    );
    state = state.copyWith(
      exportRequests: [request, ...state.exportRequests],
      activities: _withActivity('أضيف طلب تصدير محلي: ${request.title}'),
    );
  }

  void createSmartIndexJob(String evidenceId, String jobType) {
    // SMART_INDEXING_OPERATIONALIZATION: session-local OCR/index request only.
    final evidence = _evidenceById(evidenceId);
    _requireLocalUnit(evidence.unitScopeKey, 'إنشاء مهمة فهرسة ذكية');
    final now = DateTime.now();
    final job = SmartIndexJob(
      id: 'IDX-LOCAL-${now.microsecondsSinceEpoch}',
      evidenceId: evidence.id,
      jobType: jobType,
      status: 'بانتظار التشغيل المحلي',
      extractedTextPreview:
          'لم يبدأ الاستخراج؛ لا يوجد OCR فعلي أو مزود AI متصل.',
      suggestedKeywords: const [],
      suggestedCategory: 'غير مصنف بعد',
      confidence: 'غير محتسب',
      createdAt: now,
      unitScopeKey: localUnitScopeKey,
    );
    state = state.copyWith(
      smartIndexJobs: [job, ...state.smartIndexJobs],
      activities: _withActivity('أُنشئت مهمة فهرسة ذكية محلية: ${job.id}'),
    );
  }

  void completeSmartIndexJob(String jobId) {
    final job = state.smartIndexJobs.firstWhere(
      (candidate) => candidate.id == jobId,
      orElse: () => throw StateError('SMART_INDEX_JOB_NOT_FOUND'),
    );
    _requireLocalUnit(job.unitScopeKey, 'إكمال فهرسة ذكية محلية');
    final evidence = _evidenceById(job.evidenceId);
    _requireLocalUnit(evidence.unitScopeKey, 'ربط نتيجة الفهرسة بوثيقة');
    state = state.copyWith(
      smartIndexJobs: [
        for (final item in state.smartIndexJobs)
          if (item.id == jobId)
            item.copyWith(
              status: 'مكتمل محليًا',
              extractedTextPreview:
                  'معاينة نصية محلية مولدة من metadata فقط: ${evidence.title}',
              suggestedKeywords: [
                evidence.domain.label,
                evidence.accessLevel.label,
                evidence.spatialStatus.label,
              ],
              suggestedCategory: evidence.domain.label,
              confidence: 'مؤشر محلي — يحتاج اعتماد بشري',
            )
          else
            item,
      ],
      activities: _withActivity('اكتملت مهمة فهرسة ذكية محلية: $jobId'),
    );
  }

  void saveSmartSearch(String title, String query, String filtersSummary) {
    // SAVED_SEARCH_LOCAL: stores only filter metadata in session memory.
    final now = DateTime.now();
    final saved = SavedSearch(
      id: 'SRCH-LOCAL-${now.microsecondsSinceEpoch}',
      title: title.trim().isEmpty ? 'بحث محفوظ محلي' : title.trim(),
      query: query.trim(),
      filtersSummary: filtersSummary.trim().isEmpty
          ? 'فلاتر غير محددة'
          : filtersSummary.trim(),
      createdAt: now,
      unitScopeKey: localUnitScopeKey,
    );
    state = state.copyWith(
      savedSearches: [saved, ...state.savedSearches],
      activities: _withActivity('حُفظ بحث ذكي محلي: ${saved.title}'),
    );
  }

  void confirmDuplicateCandidate(String id) {
    // DUPLICATE_DETECTION_LOCAL: marks a candidate only; no merge/delete happens.
    final candidate = state.duplicateCandidates.firstWhere(
      (item) => item.id == id,
      orElse: () => throw StateError('DUPLICATE_CANDIDATE_NOT_FOUND'),
    );
    _requireLocalUnit(candidate.unitScopeKey, 'تأكيد مرشح تكرار');
    state = state.copyWith(
      duplicateCandidates: [
        for (final item in state.duplicateCandidates)
          if (item.id == id)
            item.copyWith(status: 'مؤكد كمكرر محليًا')
          else
            item,
      ],
      activities: _withActivity('تم تأكيد مرشح تكرار دون دمج: $id'),
    );
  }

  void dismissDuplicateCandidate(String id) {
    final candidate = state.duplicateCandidates.firstWhere(
      (item) => item.id == id,
      orElse: () => throw StateError('DUPLICATE_CANDIDATE_NOT_FOUND'),
    );
    _requireLocalUnit(candidate.unitScopeKey, 'رفض مرشح تكرار');
    state = state.copyWith(
      duplicateCandidates: [
        for (final item in state.duplicateCandidates)
          if (item.id == id) item.copyWith(status: 'مرفوض محليًا') else item,
      ],
      activities: _withActivity('تم رفض مرشح تكرار: $id'),
    );
  }

  void acceptTaxonomySuggestion(String id) {
    // TAXONOMY_SUGGESTION_REVIEW: accept suggestion marker only; no automatic hierarchy write.
    final suggestion = state.taxonomySuggestions.firstWhere(
      (item) => item.id == id,
      orElse: () => throw StateError('TAXONOMY_SUGGESTION_NOT_FOUND'),
    );
    _requireLocalUnit(suggestion.unitScopeKey, 'اعتماد اقتراح تصنيف');
    state = state.copyWith(
      taxonomySuggestions: [
        for (final item in state.taxonomySuggestions)
          if (item.id == id) item.copyWith(status: 'مقبول محليًا') else item,
      ],
      activities:
          _withActivity('تم قبول اقتراح تصنيف محلي: ${suggestion.title}'),
    );
  }

  void requestPublicationReview(String evidenceId) {
    // ACCESS_PUBLICATION_RETENTION_AUDIT_OPERATIONALIZATION: session-local publication review request only.
    final evidence = _evidenceById(evidenceId);
    _requireLocalUnit(evidence.unitScopeKey, 'طلب مراجعة إتاحة');
    final now = DateTime.now();
    final request = PublicationRequest(
      id: 'PUB-LOCAL-${now.microsecondsSinceEpoch}',
      evidenceId: evidence.id,
      title: 'طلب إتاحة: ${evidence.title}',
      requestedAccessLevel: evidence.accessLevel == AccessLevel.restricted
          ? AccessLevel.internal
          : AccessLevel.publicCandidate,
      status: 'بانتظار مراجعة الإتاحة',
      reason: 'طلب محلي لاختبار مسار النشر دون نشر فعلي أو بوابة عامة.',
      requestedAt: now,
      unitScopeKey: localUnitScopeKey,
    );
    state = state.copyWith(
      publicationRequests: [request, ...state.publicationRequests],
      auditTrail: [
        _audit('طلب مراجعة إتاحة', evidence.id, 'تم تسجيل الطلب محليًا'),
        ...state.auditTrail,
      ],
      activities: _withActivity('أضيف طلب مراجعة إتاحة محلي: ${request.id}'),
    );
  }

  void approvePublicationRequest(String id) {
    // PUBLICATION_REVIEW_QUEUE_LOCAL: approval marks access level only; no public route or remote write.
    final request = state.publicationRequests.firstWhere(
      (item) => item.id == id,
      orElse: () => throw StateError('PUBLICATION_REQUEST_NOT_FOUND'),
    );
    _requireLocalUnit(request.unitScopeKey, 'اعتماد طلب إتاحة');
    final evidence = _evidenceById(request.evidenceId);
    _requireLocalUnit(evidence.unitScopeKey, 'تحديث مستوى إتاحة محلي');
    state = state.copyWith(
      evidence: [
        for (final item in state.evidence)
          if (item.id == evidence.id)
            item.copyWith(accessLevel: request.requestedAccessLevel)
          else
            item,
      ],
      publicationRequests: [
        for (final item in state.publicationRequests)
          if (item.id == id) item.copyWith(status: 'معتمد محليًا') else item,
      ],
      auditTrail: [
        _audit('اعتماد إتاحة محلية', evidence.id,
            request.requestedAccessLevel.label),
        ...state.auditTrail,
      ],
      activities: _withActivity('اعتمد طلب إتاحة محلي: $id'),
    );
  }

  void restrictPublicationRequest(String id) {
    final request = state.publicationRequests.firstWhere(
      (item) => item.id == id,
      orElse: () => throw StateError('PUBLICATION_REQUEST_NOT_FOUND'),
    );
    _requireLocalUnit(request.unitScopeKey, 'تقييد طلب إتاحة');
    final evidence = _evidenceById(request.evidenceId);
    state = state.copyWith(
      evidence: [
        for (final item in state.evidence)
          if (item.id == evidence.id)
            item.copyWith(accessLevel: AccessLevel.restricted)
          else
            item,
      ],
      publicationRequests: [
        for (final item in state.publicationRequests)
          if (item.id == id) item.copyWith(status: 'مقيّد محليًا') else item,
      ],
      auditTrail: [
        _audit('تقييد إتاحة', evidence.id, 'تم تقييد الوثيقة محليًا'),
        ...state.auditTrail,
      ],
      activities: _withActivity('قُيّد طلب إتاحة محلي: $id'),
    );
  }

  void markRetentionReview(String id) {
    // RETENTION_SCHEDULE_LOCAL: local retention review only; no deletion or legal disposition.
    final rule = state.retentionRules.firstWhere(
      (item) => item.id == id,
      orElse: () => throw StateError('RETENTION_RULE_NOT_FOUND'),
    );
    _requireLocalUnit(rule.unitScopeKey, 'مراجعة الاحتفاظ');
    state = state.copyWith(
      retentionRules: [
        for (final item in state.retentionRules)
          if (item.id == id)
            item.copyWith(status: 'تمت مراجعة الاحتفاظ محليًا')
          else
            item,
      ],
      auditTrail: [
        _audit('مراجعة سياسة احتفاظ', rule.evidenceId, rule.retentionLabel),
        ...state.auditTrail,
      ],
      activities: _withActivity('تمت مراجعة سياسة احتفاظ محلية: $id'),
    );
  }

  void recordAccessAudit(String evidenceId, String action) {
    // AUDIT_TRAIL_LOCAL: append-only session trail for sensitive reads/actions.
    final evidence = _evidenceById(evidenceId);
    _requireLocalUnit(evidence.unitScopeKey, 'تسجيل تدقيق وصول');
    state = state.copyWith(
      auditTrail: [
        _audit(action, evidence.id, 'مسجل في ذاكرة الجلسة فقط'),
        ...state.auditTrail,
      ],
      activities: _withActivity('سُجل حدث تدقيق محلي: $action'),
    );
  }

  List<EvidenceItem> searchEvidence(String query) {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) {
      return state.evidence;
    }
    return state.evidence
        .where((item) =>
            item.title.toLowerCase().contains(normalized) ||
            item.reference.toLowerCase().contains(normalized) ||
            item.sourceAuthority.toLowerCase().contains(normalized) ||
            (item.linkedWaqfAssetId ?? '').toLowerCase().contains(normalized))
        .toList(growable: false);
  }

  EvidenceItem _evidenceById(String id) {
    return state.evidence.firstWhere(
      (item) => item.id == id,
      orElse: () => throw StateError('EVIDENCE_NOT_FOUND'),
    );
  }

  String _localHashPreview(String title, String format) {
    final normalized = '$localUnitScopeKey|$title|$format'.codeUnits.fold<int>(
          17,
          (previous, value) => (previous * 31 + value) & 0x7fffffff,
        );
    return 'sha256:LOCAL-QUEUE-${normalized.toRadixString(16).toUpperCase()}';
  }

  void _requireLocalUnit(String targetUnitScopeKey, String action) {
    if (targetUnitScopeKey != localUnitScopeKey) {
      throw StateError(
        'CROSS_UNIT_LOCAL_DENIED: $action is limited to $localUnitScopeKey.',
      );
    }
  }

  AuditTrailEntry _audit(String action, String targetId, String outcome) {
    return AuditTrailEntry(
      id: 'AUD-${DateTime.now().microsecondsSinceEpoch}',
      actorLabel: 'local.session.operator',
      action: action,
      targetId: targetId,
      outcome: outcome,
      createdAt: DateTime.now(),
      unitScopeKey: localUnitScopeKey,
    );
  }

  List<LocalActivity> _withActivity(String message) {
    final item = LocalActivity(
      id: 'ACT-${DateTime.now().microsecondsSinceEpoch}',
      message: message,
      at: DateTime.now(),
    );
    return [item, ...state.activities].take(80).toList(growable: false);
  }
}

final localOperationalProvider =
    StateNotifierProvider<LocalOperationalController, LocalOperationalState>(
  (ref) => LocalOperationalController(),
);
