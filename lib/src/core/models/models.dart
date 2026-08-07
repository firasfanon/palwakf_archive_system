enum EvidenceDomain {
  waqf,
  ottoman,
  general,
  spatial,
}

enum EvidenceReviewStatus {
  discovered,
  inReview,
  internalReady,
  quarantined,
  rejected,
}

enum ReviewTaskState {
  open,
  inProgress,
  blocked,
  completed,
  cancelled,
}

enum RelationType {
  supports,
  describes,
  derivedFrom,
  spatiallyReferences,
  waqfAssetCandidate,
  legalCaseCandidate,
}

enum ArchiveNodeType {
  fonds,
  series,
  file,
  item,
}

enum RepresentationType {
  original,
  scan,
  ocr,
  transcription,
  translation,
  summary,
  thumbnail,
  georeferencedImage,
  vectorLayer,
}

enum AccessLevel {
  internal,
  unitOnly,
  restricted,
  publicCandidate,
}

enum EvidenceType {
  legal,
  historical,
  spatial,
  administrative,
  waqf,
}

enum SpatialStatus {
  notMapped,
  roughLocation,
  parcelLevel,
  verifiedGeometry,
  disputed,
  restricted,
}

enum ImportStatus {
  staged,
  validated,
  needsMapping,
  readyForImport,
  imported,
  rejected,
}

enum ReadinessState {
  pass,
  warning,
  blocked,
  notStarted,
}

enum ReadinessStage {
  localProduct,
  coreArchive,
  evidence,
  review,
  spatialSearch,
  admin,
  stagingReadiness,
  controlledUat,
  productionReadiness,
}

extension EvidenceDomainLabel on EvidenceDomain {
  String get label {
    switch (this) {
      case EvidenceDomain.waqf:
        return 'الأوقاف';
      case EvidenceDomain.ottoman:
        return 'الأرشيف العثماني';
      case EvidenceDomain.general:
        return 'مواد مرتبطة بالأوقاف';
      case EvidenceDomain.spatial:
        return 'دليل مكاني';
    }
  }
}

extension EvidenceReviewStatusLabel on EvidenceReviewStatus {
  String get label {
    switch (this) {
      case EvidenceReviewStatus.discovered:
        return 'مكتشف';
      case EvidenceReviewStatus.inReview:
        return 'قيد المراجعة';
      case EvidenceReviewStatus.internalReady:
        return 'جاهز داخليًا';
      case EvidenceReviewStatus.quarantined:
        return 'محجور';
      case EvidenceReviewStatus.rejected:
        return 'مرفوض';
    }
  }
}

extension ReviewTaskStateLabel on ReviewTaskState {
  String get label {
    switch (this) {
      case ReviewTaskState.open:
        return 'مفتوحة';
      case ReviewTaskState.inProgress:
        return 'قيد العمل';
      case ReviewTaskState.blocked:
        return 'محجوبة';
      case ReviewTaskState.completed:
        return 'مكتملة';
      case ReviewTaskState.cancelled:
        return 'ملغاة';
    }
  }
}

extension RelationTypeLabel on RelationType {
  String get label {
    switch (this) {
      case RelationType.supports:
        return 'يدعم';
      case RelationType.describes:
        return 'يصف';
      case RelationType.derivedFrom:
        return 'مشتق من';
      case RelationType.spatiallyReferences:
        return 'مرجع مكاني';
      case RelationType.waqfAssetCandidate:
        return 'مرشح ارتباط أصل وقفي';
      case RelationType.legalCaseCandidate:
        return 'مرشح ارتباط قضية قانونية';
    }
  }
}

extension ArchiveNodeTypeLabel on ArchiveNodeType {
  String get label {
    switch (this) {
      case ArchiveNodeType.fonds:
        return 'Fonds';
      case ArchiveNodeType.series:
        return 'Series';
      case ArchiveNodeType.file:
        return 'File';
      case ArchiveNodeType.item:
        return 'Item';
    }
  }
}

extension RepresentationTypeLabel on RepresentationType {
  String get label {
    switch (this) {
      case RepresentationType.original:
        return 'الأصل';
      case RepresentationType.scan:
        return 'مسح ضوئي';
      case RepresentationType.ocr:
        return 'OCR';
      case RepresentationType.transcription:
        return 'نسخ حرفي';
      case RepresentationType.translation:
        return 'ترجمة';
      case RepresentationType.summary:
        return 'ملخص';
      case RepresentationType.thumbnail:
        return 'مصغّر';
      case RepresentationType.georeferencedImage:
        return 'صورة مسندة';
      case RepresentationType.vectorLayer:
        return 'طبقة متجهة';
    }
  }
}

enum TextDraftLayerKind {
  ocr,
  transcription,
  translation,
}

extension TextDraftLayerKindLabel on TextDraftLayerKind {
  String get label {
    switch (this) {
      case TextDraftLayerKind.ocr:
        return 'مسودة OCR';
      case TextDraftLayerKind.transcription:
        return 'مسودة تفريغ';
      case TextDraftLayerKind.translation:
        return 'مسودة ترجمة';
    }
  }

  RepresentationType get representationType {
    switch (this) {
      case TextDraftLayerKind.ocr:
        return RepresentationType.ocr;
      case TextDraftLayerKind.transcription:
        return RepresentationType.transcription;
      case TextDraftLayerKind.translation:
        return RepresentationType.translation;
    }
  }
}

extension AccessLevelLabel on AccessLevel {
  String get label {
    switch (this) {
      case AccessLevel.internal:
        return 'داخلي';
      case AccessLevel.unitOnly:
        return 'وحدة فقط';
      case AccessLevel.restricted:
        return 'مقيد';
      case AccessLevel.publicCandidate:
        return 'مرشح إتاحة عامة';
    }
  }
}

extension EvidenceTypeLabel on EvidenceType {
  String get label {
    switch (this) {
      case EvidenceType.legal:
        return 'قانوني';
      case EvidenceType.historical:
        return 'تاريخي';
      case EvidenceType.spatial:
        return 'مكاني';
      case EvidenceType.administrative:
        return 'إداري';
      case EvidenceType.waqf:
        return 'وقفي';
    }
  }
}

extension SpatialStatusLabel on SpatialStatus {
  String get label {
    switch (this) {
      case SpatialStatus.notMapped:
        return 'غير مموقع';
      case SpatialStatus.roughLocation:
        return 'موقع تقريبي';
      case SpatialStatus.parcelLevel:
        return 'مستوى قطعة';
      case SpatialStatus.verifiedGeometry:
        return 'هندسة موثقة';
      case SpatialStatus.disputed:
        return 'متنازع';
      case SpatialStatus.restricted:
        return 'مقيد مكانيًا';
    }
  }
}

extension ImportStatusLabel on ImportStatus {
  String get label {
    switch (this) {
      case ImportStatus.staged:
        return 'مجهز';
      case ImportStatus.validated:
        return 'متحقق';
      case ImportStatus.needsMapping:
        return 'يحتاج مطابقة';
      case ImportStatus.readyForImport:
        return 'جاهز للاستيراد';
      case ImportStatus.imported:
        return 'مستورد';
      case ImportStatus.rejected:
        return 'مرفوض';
    }
  }
}

extension ReadinessStateLabel on ReadinessState {
  String get label {
    switch (this) {
      case ReadinessState.pass:
        return 'PASS';
      case ReadinessState.warning:
        return 'WARNING';
      case ReadinessState.blocked:
        return 'BLOCKED';
      case ReadinessState.notStarted:
        return 'NOT_STARTED';
    }
  }
}

extension ReadinessStageLabel on ReadinessStage {
  String get label {
    switch (this) {
      case ReadinessStage.localProduct:
        return 'Local Product';
      case ReadinessStage.coreArchive:
        return 'Core Archive';
      case ReadinessStage.evidence:
        return 'Evidence';
      case ReadinessStage.review:
        return 'Review';
      case ReadinessStage.spatialSearch:
        return 'Spatial/Search';
      case ReadinessStage.admin:
        return 'Admin';
      case ReadinessStage.stagingReadiness:
        return 'Staging Readiness';
      case ReadinessStage.controlledUat:
        return 'Controlled UAT';
      case ReadinessStage.productionReadiness:
        return 'Production Readiness';
    }
  }
}

class EvidenceItem {
  const EvidenceItem({
    required this.id,
    required this.title,
    required this.domain,
    required this.sourceAuthority,
    required this.reference,
    required this.status,
    required this.confidence,
    required this.unitScopeKey,
    required this.isOriginalAvailableLocally,
    required this.createdAt,
    this.dateLabel = 'غير محدد',
    this.rightsStatus = 'قيد التحقق',
    this.legalSensitivity = 'غير مصنف',
    this.linkedWaqfAssetId,
    this.linkedCaseId,
    this.accessLevel = AccessLevel.internal,
    this.spatialStatus = SpatialStatus.notMapped,
    this.departmentLabel = 'غير محدد',
    this.subjectLabel = 'غير محدد',
    this.documentType = 'وثيقة عامة',
    this.keywords = const [],
    this.workflowNote = 'لا توجد ملاحظة تشغيلية',
    this.catalogId = 'catalog-general',
    this.catalogTitle = 'كتالوج عام',
    this.documentTypeTabId = 'general-document',
    this.documentTypeTabTitle = 'وثيقة عامة',
    this.draftStage = 'مسودة أولية',
    this.publicationStatus = 'غير منشور — يتطلب اعتمادًا بشريًا',
    this.intakeMode = 'Open Draft Intake',
    this.metadataTemplateId = 'template-general-document',
    this.structuredMetadata = const <String, String>{},
    this.missingMetadataWarnings = const <String>[],
    this.templateReadinessLabel = 'مسودة ناقصة مقبولة للتطوير',
    this.aiAssistancePlan = 'AI assistance pending human review',
  });

  final String id;
  final String title;
  final EvidenceDomain domain;
  final String sourceAuthority;
  final String reference;
  final EvidenceReviewStatus status;
  final String confidence;

  /// A local fixture ownership marker. Production ownership must be resolved by
  /// PalWakf central unit context and enforced on the server.
  final String unitScopeKey;

  final bool isOriginalAvailableLocally;
  final DateTime createdAt;
  final String dateLabel;
  final String rightsStatus;
  final String legalSensitivity;
  final String? linkedWaqfAssetId;
  final String? linkedCaseId;
  final AccessLevel accessLevel;
  final SpatialStatus spatialStatus;
  final String departmentLabel;
  final String subjectLabel;
  final String documentType;
  final List<String> keywords;
  final String workflowNote;
  final String catalogId;
  final String catalogTitle;
  final String documentTypeTabId;
  final String documentTypeTabTitle;
  final String draftStage;
  final String publicationStatus;
  final String intakeMode;
  final String metadataTemplateId;
  final Map<String, String> structuredMetadata;
  final List<String> missingMetadataWarnings;
  final String templateReadinessLabel;
  final String aiAssistancePlan;

  EvidenceItem copyWith({
    String? title,
    EvidenceDomain? domain,
    String? sourceAuthority,
    String? reference,
    EvidenceReviewStatus? status,
    String? confidence,
    String? unitScopeKey,
    bool? isOriginalAvailableLocally,
    String? dateLabel,
    String? rightsStatus,
    String? legalSensitivity,
    String? linkedWaqfAssetId,
    String? linkedCaseId,
    AccessLevel? accessLevel,
    SpatialStatus? spatialStatus,
    String? departmentLabel,
    String? subjectLabel,
    String? documentType,
    List<String>? keywords,
    String? workflowNote,
    String? catalogId,
    String? catalogTitle,
    String? documentTypeTabId,
    String? documentTypeTabTitle,
    String? draftStage,
    String? publicationStatus,
    String? intakeMode,
    String? metadataTemplateId,
    Map<String, String>? structuredMetadata,
    List<String>? missingMetadataWarnings,
    String? templateReadinessLabel,
    String? aiAssistancePlan,
  }) {
    return EvidenceItem(
      id: id,
      title: title ?? this.title,
      domain: domain ?? this.domain,
      sourceAuthority: sourceAuthority ?? this.sourceAuthority,
      reference: reference ?? this.reference,
      status: status ?? this.status,
      confidence: confidence ?? this.confidence,
      unitScopeKey: unitScopeKey ?? this.unitScopeKey,
      isOriginalAvailableLocally:
          isOriginalAvailableLocally ?? this.isOriginalAvailableLocally,
      createdAt: createdAt,
      dateLabel: dateLabel ?? this.dateLabel,
      rightsStatus: rightsStatus ?? this.rightsStatus,
      legalSensitivity: legalSensitivity ?? this.legalSensitivity,
      linkedWaqfAssetId: linkedWaqfAssetId ?? this.linkedWaqfAssetId,
      linkedCaseId: linkedCaseId ?? this.linkedCaseId,
      accessLevel: accessLevel ?? this.accessLevel,
      spatialStatus: spatialStatus ?? this.spatialStatus,
      departmentLabel: departmentLabel ?? this.departmentLabel,
      subjectLabel: subjectLabel ?? this.subjectLabel,
      documentType: documentType ?? this.documentType,
      keywords: keywords ?? this.keywords,
      workflowNote: workflowNote ?? this.workflowNote,
      catalogId: catalogId ?? this.catalogId,
      catalogTitle: catalogTitle ?? this.catalogTitle,
      documentTypeTabId: documentTypeTabId ?? this.documentTypeTabId,
      documentTypeTabTitle: documentTypeTabTitle ?? this.documentTypeTabTitle,
      draftStage: draftStage ?? this.draftStage,
      publicationStatus: publicationStatus ?? this.publicationStatus,
      intakeMode: intakeMode ?? this.intakeMode,
      metadataTemplateId: metadataTemplateId ?? this.metadataTemplateId,
      structuredMetadata: structuredMetadata ?? this.structuredMetadata,
      missingMetadataWarnings:
          missingMetadataWarnings ?? this.missingMetadataWarnings,
      templateReadinessLabel:
          templateReadinessLabel ?? this.templateReadinessLabel,
      aiAssistancePlan: aiAssistancePlan ?? this.aiAssistancePlan,
    );
  }
}

class ArchiveCollection {
  const ArchiveCollection({
    required this.id,
    required this.title,
    required this.level,
    required this.domain,
    required this.reference,
    required this.description,
    required this.unitScopeKey,
  });

  final String id;
  final String title;
  final String level;
  final EvidenceDomain domain;
  final String reference;
  final String description;
  final String unitScopeKey;
}

class ArchiveCatalog {
  const ArchiveCatalog({
    required this.id,
    required this.title,
    required this.periodLabel,
    required this.sourceAuthority,
    required this.languageHints,
    required this.description,
    required this.documentTypeTabIds,
    required this.colorLabel,
  });

  final String id;
  final String title;
  final String periodLabel;
  final String sourceAuthority;
  final String languageHints;
  final String description;
  final List<String> documentTypeTabIds;
  final String colorLabel;
}

class CatalogDocumentTypeTab {
  const CatalogDocumentTypeTab({
    required this.id,
    required this.catalogId,
    required this.title,
    required this.description,
    required this.examples,
    required this.metadataHints,
    this.metadataTemplateId = '',
    this.supportsImages = true,
    this.supportsOcr = true,
    this.supportsTranscription = true,
    this.supportsTranslation = true,
    this.supportsSpatialLink = false,
    this.supportsWaqfLink = true,
  });

  final String id;
  final String catalogId;
  final String title;
  final String description;
  final List<String> examples;
  final List<String> metadataHints;
  final String metadataTemplateId;
  final bool supportsImages;
  final bool supportsOcr;
  final bool supportsTranscription;
  final bool supportsTranslation;
  final bool supportsSpatialLink;
  final bool supportsWaqfLink;
}

class MetadataTemplateField {
  const MetadataTemplateField({
    required this.key,
    required this.label,
    required this.hint,
    this.isRecommended = true,
    this.aiAssistHint =
        'يقترح الذكاء الصناعي قيمة أولية فقط، ولا يعتمدها للنشر.',
  });

  final String key;
  final String label;
  final String hint;
  final bool isRecommended;
  final String aiAssistHint;
}

class CatalogMetadataTemplate {
  const CatalogMetadataTemplate({
    required this.id,
    required this.catalogId,
    required this.documentTypeTabId,
    required this.title,
    required this.description,
    required this.fields,
    required this.aiAssistancePlan,
    this.openDraftPolicy =
        'OPEN_DRAFT_INTAKE_MODE — تقبل البيانات الناقصة كمسودة تطويرية.',
    this.publicationPolicy =
        'PUBLICATION_REQUIRES_HUMAN_APPROVAL — لا نشر قبل مراجعة بشرية.',
  });

  final String id;
  final String catalogId;
  final String documentTypeTabId;
  final String title;
  final String description;
  final List<MetadataTemplateField> fields;
  final String aiAssistancePlan;
  final String openDraftPolicy;
  final String publicationPolicy;
}

class TextDraftLayer {
  const TextDraftLayer({
    required this.id,
    required this.evidenceId,
    required this.representationId,
    required this.kind,
    required this.catalogId,
    required this.documentTypeTabId,
    required this.languageLabel,
    required this.sourceLabel,
    required this.textPreview,
    required this.status,
    required this.qualityWarnings,
    required this.humanReviewPolicy,
    required this.createdAt,
    required this.unitScopeKey,
  });

  final String id;
  final String evidenceId;
  final String representationId;
  final TextDraftLayerKind kind;
  final String catalogId;
  final String documentTypeTabId;
  final String languageLabel;
  final String sourceLabel;
  final String textPreview;
  final String status;
  final List<String> qualityWarnings;
  final String humanReviewPolicy;
  final DateTime createdAt;
  final String unitScopeKey;

  TextDraftLayer copyWith({
    String? representationId,
    String? languageLabel,
    String? sourceLabel,
    String? textPreview,
    String? status,
    List<String>? qualityWarnings,
    String? humanReviewPolicy,
  }) {
    return TextDraftLayer(
      id: id,
      evidenceId: evidenceId,
      representationId: representationId ?? this.representationId,
      kind: kind,
      catalogId: catalogId,
      documentTypeTabId: documentTypeTabId,
      languageLabel: languageLabel ?? this.languageLabel,
      sourceLabel: sourceLabel ?? this.sourceLabel,
      textPreview: textPreview ?? this.textPreview,
      status: status ?? this.status,
      qualityWarnings: qualityWarnings ?? this.qualityWarnings,
      humanReviewPolicy: humanReviewPolicy ?? this.humanReviewPolicy,
      createdAt: createdAt,
      unitScopeKey: unitScopeKey,
    );
  }
}

class ArchiveRecordNode {
  const ArchiveRecordNode({
    required this.id,
    required this.title,
    required this.type,
    required this.reference,
    required this.parentId,
    required this.description,
    required this.unitScopeKey,
    required this.accessLevel,
    required this.reviewStatus,
    required this.dateLabel,
  });

  final String id;
  final String title;
  final ArchiveNodeType type;
  final String reference;
  final String? parentId;
  final String description;
  final String unitScopeKey;
  final AccessLevel accessLevel;
  final EvidenceReviewStatus reviewStatus;
  final String dateLabel;
}

class EvidenceRelation {
  const EvidenceRelation({
    required this.id,
    required this.fromEvidenceId,
    required this.toEvidenceId,
    required this.type,
    required this.rationale,
    required this.confidence,
    required this.unitScopeKey,
  });

  final String id;
  final String fromEvidenceId;
  final String toEvidenceId;
  final RelationType type;
  final String rationale;
  final String confidence;
  final String unitScopeKey;
}

class ReviewTask {
  const ReviewTask({
    required this.id,
    required this.title,
    required this.evidenceId,
    required this.domain,
    required this.priority,
    required this.assignedRole,
    required this.state,
    required this.unitScopeKey,
  });

  final String id;
  final String title;
  final String evidenceId;
  final EvidenceDomain domain;
  final String priority;
  final String assignedRole;
  final ReviewTaskState state;
  final String unitScopeKey;

  ReviewTask copyWith({ReviewTaskState? state}) {
    return ReviewTask(
      id: id,
      title: title,
      evidenceId: evidenceId,
      domain: domain,
      priority: priority,
      assignedRole: assignedRole,
      state: state ?? this.state,
      unitScopeKey: unitScopeKey,
    );
  }
}

class ImportBatch {
  const ImportBatch({
    required this.id,
    required this.fileName,
    required this.sheetName,
    required this.domain,
    required this.rowCount,
    required this.status,
    required this.unitScopeKey,
    this.importStatus = ImportStatus.needsMapping,
    this.validationSummary = 'لم يبدأ التحقق التفصيلي',
  });

  final String id;
  final String fileName;
  final String sheetName;
  final EvidenceDomain domain;
  final int rowCount;
  final String status;
  final String unitScopeKey;
  final ImportStatus importStatus;
  final String validationSummary;
}

class ArchiveRepresentation {
  const ArchiveRepresentation({
    required this.id,
    required this.evidenceId,
    required this.type,
    required this.title,
    required this.format,
    required this.hashPreview,
    required this.rightsStatus,
    required this.unitScopeKey,
    required this.isAuthoritativeOriginal,
    this.uploadStatus = 'محفوظ في ذاكرة الجلسة',
    this.fileSizeLabel = 'غير محدد',
    this.previewKind = 'معاينة وصفية',
    this.previewNote = 'لا يوجد مسار ملف أو File Center في النسخة المحلية',
  });

  final String id;
  final String evidenceId;
  final RepresentationType type;
  final String title;
  final String format;
  final String hashPreview;
  final String rightsStatus;
  final String unitScopeKey;
  final bool isAuthoritativeOriginal;
  final String uploadStatus;
  final String fileSizeLabel;
  final String previewKind;
  final String previewNote;

  ArchiveRepresentation copyWith({
    String? title,
    String? format,
    String? hashPreview,
    String? rightsStatus,
    bool? isAuthoritativeOriginal,
    String? uploadStatus,
    String? fileSizeLabel,
    String? previewKind,
    String? previewNote,
  }) {
    return ArchiveRepresentation(
      id: id,
      evidenceId: evidenceId,
      type: type,
      title: title ?? this.title,
      format: format ?? this.format,
      hashPreview: hashPreview ?? this.hashPreview,
      rightsStatus: rightsStatus ?? this.rightsStatus,
      unitScopeKey: unitScopeKey,
      isAuthoritativeOriginal:
          isAuthoritativeOriginal ?? this.isAuthoritativeOriginal,
      uploadStatus: uploadStatus ?? this.uploadStatus,
      fileSizeLabel: fileSizeLabel ?? this.fileSizeLabel,
      previewKind: previewKind ?? this.previewKind,
      previewNote: previewNote ?? this.previewNote,
    );
  }
}

class EvidenceRegistryEntry {
  const EvidenceRegistryEntry({
    required this.id,
    required this.evidenceId,
    required this.type,
    required this.confidenceLevel,
    required this.sourceChain,
    required this.rightsStatus,
    required this.legalSensitivity,
    required this.reviewStatus,
    required this.unitScopeKey,
    this.linkedWaqfAssetId,
    this.linkedCaseId,
  });

  final String id;
  final String evidenceId;
  final EvidenceType type;
  final String confidenceLevel;
  final String sourceChain;
  final String rightsStatus;
  final String legalSensitivity;
  final EvidenceReviewStatus reviewStatus;
  final String unitScopeKey;
  final String? linkedWaqfAssetId;
  final String? linkedCaseId;
}

class SpatialLink {
  const SpatialLink({
    required this.id,
    required this.evidenceId,
    required this.placeLabel,
    required this.status,
    required this.confidence,
    required this.geometrySummary,
    required this.unitScopeKey,
    this.waqfAssetId,
  });

  final String id;
  final String evidenceId;
  final String placeLabel;
  final SpatialStatus status;
  final String confidence;
  final String geometrySummary;
  final String unitScopeKey;
  final String? waqfAssetId;
}

class TemporalEvent {
  const TemporalEvent({
    required this.id,
    required this.evidenceId,
    required this.periodLabel,
    required this.title,
    required this.dateLabel,
    required this.certainty,
    required this.unitScopeKey,
  });

  final String id;
  final String evidenceId;
  final String periodLabel;
  final String title;
  final String dateLabel;
  final String certainty;
  final String unitScopeKey;
}

class AdministrativePolicy {
  const AdministrativePolicy({
    required this.id,
    required this.title,
    required this.ownerRole,
    required this.status,
    required this.summary,
  });

  final String id;
  final String title;
  final String ownerRole;
  final ReadinessState status;
  final String summary;
}

class ReadinessCheckpoint {
  const ReadinessCheckpoint({
    required this.id,
    required this.stage,
    required this.title,
    required this.state,
    required this.evidence,
    required this.blocker,
  });

  final String id;
  final ReadinessStage stage;
  final String title;
  final ReadinessState state;
  final String evidence;
  final String blocker;
}

class LocalActivity {
  const LocalActivity({
    required this.id,
    required this.message,
    required this.at,
  });

  final String id;
  final String message;
  final DateTime at;
}

class ArchiveReport {
  const ArchiveReport({
    required this.id,
    required this.title,
    required this.scope,
    required this.metric,
    required this.summary,
    required this.state,
    required this.unitScopeKey,
  });

  final String id;
  final String title;
  final String scope;
  final String metric;
  final String summary;
  final String state;
  final String unitScopeKey;
}

class ArchiveNotification {
  const ArchiveNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.severity,
    required this.createdAt,
    required this.acknowledged,
    required this.unitScopeKey,
  });

  final String id;
  final String title;
  final String message;
  final String severity;
  final DateTime createdAt;
  final bool acknowledged;
  final String unitScopeKey;

  ArchiveNotification copyWith({bool? acknowledged}) {
    return ArchiveNotification(
      id: id,
      title: title,
      message: message,
      severity: severity,
      createdAt: createdAt,
      acknowledged: acknowledged ?? this.acknowledged,
      unitScopeKey: unitScopeKey,
    );
  }
}

class BackupSnapshot {
  const BackupSnapshot({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.status,
    required this.coverage,
    required this.hashPreview,
    required this.restoreDrillStatus,
    required this.unitScopeKey,
  });

  final String id;
  final String title;
  final DateTime createdAt;
  final String status;
  final String coverage;
  final String hashPreview;
  final String restoreDrillStatus;
  final String unitScopeKey;

  BackupSnapshot copyWith({String? status, String? restoreDrillStatus}) {
    return BackupSnapshot(
      id: id,
      title: title,
      createdAt: createdAt,
      status: status ?? this.status,
      coverage: coverage,
      hashPreview: hashPreview,
      restoreDrillStatus: restoreDrillStatus ?? this.restoreDrillStatus,
      unitScopeKey: unitScopeKey,
    );
  }
}

class ExportRequest {
  const ExportRequest({
    required this.id,
    required this.title,
    required this.format,
    required this.status,
    required this.requestedAt,
    required this.scope,
    required this.unitScopeKey,
  });

  final String id;
  final String title;
  final String format;
  final String status;
  final DateTime requestedAt;
  final String scope;
  final String unitScopeKey;

  ExportRequest copyWith({String? status}) {
    return ExportRequest(
      id: id,
      title: title,
      format: format,
      status: status ?? this.status,
      requestedAt: requestedAt,
      scope: scope,
      unitScopeKey: unitScopeKey,
    );
  }
}

class SmartIndexJob {
  const SmartIndexJob({
    required this.id,
    required this.evidenceId,
    required this.jobType,
    required this.status,
    required this.extractedTextPreview,
    required this.suggestedKeywords,
    required this.suggestedCategory,
    required this.confidence,
    required this.createdAt,
    required this.unitScopeKey,
  });

  final String id;
  final String evidenceId;
  final String jobType;
  final String status;
  final String extractedTextPreview;
  final List<String> suggestedKeywords;
  final String suggestedCategory;
  final String confidence;
  final DateTime createdAt;
  final String unitScopeKey;

  SmartIndexJob copyWith({
    String? status,
    String? extractedTextPreview,
    List<String>? suggestedKeywords,
    String? suggestedCategory,
    String? confidence,
  }) {
    return SmartIndexJob(
      id: id,
      evidenceId: evidenceId,
      jobType: jobType,
      status: status ?? this.status,
      extractedTextPreview: extractedTextPreview ?? this.extractedTextPreview,
      suggestedKeywords: suggestedKeywords ?? this.suggestedKeywords,
      suggestedCategory: suggestedCategory ?? this.suggestedCategory,
      confidence: confidence ?? this.confidence,
      createdAt: createdAt,
      unitScopeKey: unitScopeKey,
    );
  }
}

class DuplicateCandidate {
  const DuplicateCandidate({
    required this.id,
    required this.primaryEvidenceId,
    required this.candidateEvidenceId,
    required this.similarityLabel,
    required this.rationale,
    required this.status,
    required this.unitScopeKey,
  });

  final String id;
  final String primaryEvidenceId;
  final String candidateEvidenceId;
  final String similarityLabel;
  final String rationale;
  final String status;
  final String unitScopeKey;

  DuplicateCandidate copyWith({String? status}) {
    return DuplicateCandidate(
      id: id,
      primaryEvidenceId: primaryEvidenceId,
      candidateEvidenceId: candidateEvidenceId,
      similarityLabel: similarityLabel,
      rationale: rationale,
      status: status ?? this.status,
      unitScopeKey: unitScopeKey,
    );
  }
}

class SavedSearch {
  const SavedSearch({
    required this.id,
    required this.title,
    required this.query,
    required this.filtersSummary,
    required this.createdAt,
    required this.unitScopeKey,
  });

  final String id;
  final String title;
  final String query;
  final String filtersSummary;
  final DateTime createdAt;
  final String unitScopeKey;
}

class TaxonomySuggestion {
  const TaxonomySuggestion({
    required this.id,
    required this.title,
    required this.suggestedNodeType,
    required this.sourceEvidenceId,
    required this.confidence,
    required this.status,
    required this.unitScopeKey,
  });

  final String id;
  final String title;
  final ArchiveNodeType suggestedNodeType;
  final String sourceEvidenceId;
  final String confidence;
  final String status;
  final String unitScopeKey;

  TaxonomySuggestion copyWith({String? status}) {
    return TaxonomySuggestion(
      id: id,
      title: title,
      suggestedNodeType: suggestedNodeType,
      sourceEvidenceId: sourceEvidenceId,
      confidence: confidence,
      status: status ?? this.status,
      unitScopeKey: unitScopeKey,
    );
  }
}

class AccessPolicyRule {
  const AccessPolicyRule({
    required this.id,
    required this.title,
    required this.role,
    required this.allowedAccessLevels,
    required this.scopeSummary,
    required this.status,
    required this.unitScopeKey,
  });

  final String id;
  final String title;
  final String role;
  final List<AccessLevel> allowedAccessLevels;
  final String scopeSummary;
  final String status;
  final String unitScopeKey;
}

class PublicationRequest {
  const PublicationRequest({
    required this.id,
    required this.evidenceId,
    required this.title,
    required this.requestedAccessLevel,
    required this.status,
    required this.reason,
    required this.requestedAt,
    required this.unitScopeKey,
  });

  final String id;
  final String evidenceId;
  final String title;
  final AccessLevel requestedAccessLevel;
  final String status;
  final String reason;
  final DateTime requestedAt;
  final String unitScopeKey;

  PublicationRequest copyWith({String? status}) {
    return PublicationRequest(
      id: id,
      evidenceId: evidenceId,
      title: title,
      requestedAccessLevel: requestedAccessLevel,
      status: status ?? this.status,
      reason: reason,
      requestedAt: requestedAt,
      unitScopeKey: unitScopeKey,
    );
  }
}

class RetentionRule {
  const RetentionRule({
    required this.id,
    required this.title,
    required this.evidenceId,
    required this.retentionLabel,
    required this.reviewDateLabel,
    required this.dispositionAction,
    required this.status,
    required this.unitScopeKey,
  });

  final String id;
  final String title;
  final String evidenceId;
  final String retentionLabel;
  final String reviewDateLabel;
  final String dispositionAction;
  final String status;
  final String unitScopeKey;

  RetentionRule copyWith({String? status}) {
    return RetentionRule(
      id: id,
      title: title,
      evidenceId: evidenceId,
      retentionLabel: retentionLabel,
      reviewDateLabel: reviewDateLabel,
      dispositionAction: dispositionAction,
      status: status ?? this.status,
      unitScopeKey: unitScopeKey,
    );
  }
}

class AuditTrailEntry {
  const AuditTrailEntry({
    required this.id,
    required this.actorLabel,
    required this.action,
    required this.targetId,
    required this.outcome,
    required this.createdAt,
    required this.unitScopeKey,
  });

  final String id;
  final String actorLabel;
  final String action;
  final String targetId;
  final String outcome;
  final DateTime createdAt;
  final String unitScopeKey;
}
