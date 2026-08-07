/// Contracts used by the Evidence Archive module before it receives an
/// authoritative PalWakf platform binding.
///
/// These classes contain no production URLs, credentials, Supabase clients,
/// RBAC tables, or storage implementation. The platform host owns those
/// concerns and supplies concrete adapters after an approved integration gate.
library;

const String archiveModuleId = 'evidence_archive';
const String archiveModuleVersion = '0.5.0';
const String localDevelopmentUnitKey = 'LOCAL-DEMO-UNIT';

enum ModuleRouteSlot {
  localProduct,
  dashboard,
  archiveCore,
  list,
  detail,
  create,
  registry,
  representations,
  review,
  spatial,
  temporal,
  search,
  admin,
  stagingReadiness,
  controlledUat,
  productionReadiness,
  reports,
  settings,
}

extension ModuleRouteSlotLabel on ModuleRouteSlot {
  String get label {
    switch (this) {
      case ModuleRouteSlot.localProduct:
        return 'المنتج المحلي';
      case ModuleRouteSlot.dashboard:
        return 'لوحة التشغيل';
      case ModuleRouteSlot.archiveCore:
        return 'قلب الأرشيف';
      case ModuleRouteSlot.list:
        return 'قائمة الأدلة';
      case ModuleRouteSlot.detail:
        return 'تفاصيل الدليل';
      case ModuleRouteSlot.create:
        return 'إدخال محلي';
      case ModuleRouteSlot.registry:
        return 'سجل الأدلة';
      case ModuleRouteSlot.representations:
        return 'التمثيلات';
      case ModuleRouteSlot.review:
        return 'المراجعة';
      case ModuleRouteSlot.spatial:
        return 'المستكشف المكاني';
      case ModuleRouteSlot.temporal:
        return 'المستكشف الزمني';
      case ModuleRouteSlot.search:
        return 'البحث';
      case ModuleRouteSlot.admin:
        return 'الإدارة';
      case ModuleRouteSlot.stagingReadiness:
        return 'جاهزية Staging';
      case ModuleRouteSlot.controlledUat:
        return 'Controlled UAT';
      case ModuleRouteSlot.productionReadiness:
        return 'جاهزية Production';
      case ModuleRouteSlot.reports:
        return 'التقارير';
      case ModuleRouteSlot.settings:
        return 'الإعدادات';
    }
  }
}

enum ArchiveCapability {
  evidenceRead,
  evidenceCreateLocalDraft,
  evidenceUpdateLocalDraft,
  evidenceQuarantineLocalDraft,
  collectionCreateLocalDraft,
  relationProposeLocalDraft,
  reviewUpdateLocalDraft,
  importCatalogLocalDraft,
  fileObjectReadAuthorized,
  fileObjectCreate,
  mapRender,
  layerRead,
  georeferenceSubmit,
}

extension ArchiveCapabilityKey on ArchiveCapability {
  String get key {
    switch (this) {
      case ArchiveCapability.evidenceRead:
        return 'evidence_archive.evidence.read';
      case ArchiveCapability.evidenceCreateLocalDraft:
        return 'evidence_archive.evidence.create_local_draft';
      case ArchiveCapability.evidenceUpdateLocalDraft:
        return 'evidence_archive.evidence.update_local_draft';
      case ArchiveCapability.evidenceQuarantineLocalDraft:
        return 'evidence_archive.evidence.quarantine_local_draft';
      case ArchiveCapability.collectionCreateLocalDraft:
        return 'evidence_archive.collections.create_local_draft';
      case ArchiveCapability.relationProposeLocalDraft:
        return 'evidence_archive.relations.propose_local_draft';
      case ArchiveCapability.reviewUpdateLocalDraft:
        return 'evidence_archive.review.update_local_draft';
      case ArchiveCapability.importCatalogLocalDraft:
        return 'evidence_archive.imports.catalog_local_draft';
      case ArchiveCapability.fileObjectReadAuthorized:
        return 'file_object.read_authorized';
      case ArchiveCapability.fileObjectCreate:
        return 'file_object.create';
      case ArchiveCapability.mapRender:
        return 'map.render';
      case ArchiveCapability.layerRead:
        return 'layer.read';
      case ArchiveCapability.georeferenceSubmit:
        return 'georeference.submit';
    }
  }

  String get label {
    switch (this) {
      case ArchiveCapability.evidenceRead:
        return 'قراءة الأدلة';
      case ArchiveCapability.evidenceCreateLocalDraft:
        return 'إضافة مسودة دليل محلية';
      case ArchiveCapability.evidenceUpdateLocalDraft:
        return 'تعديل مسودة دليل محلية';
      case ArchiveCapability.evidenceQuarantineLocalDraft:
        return 'حجر مسودة دليل محلية';
      case ArchiveCapability.collectionCreateLocalDraft:
        return 'إضافة مجموعة محلية';
      case ArchiveCapability.relationProposeLocalDraft:
        return 'اقتراح علاقة محلية';
      case ArchiveCapability.reviewUpdateLocalDraft:
        return 'تحديث مهمة مراجعة محلية';
      case ArchiveCapability.importCatalogLocalDraft:
        return 'فهرسة دفعة محلية';
      case ArchiveCapability.fileObjectReadAuthorized:
        return 'قراءة ملف معتمد';
      case ArchiveCapability.fileObjectCreate:
        return 'إنشاء كائن ملف';
      case ArchiveCapability.mapRender:
        return 'عرض خريطة';
      case ArchiveCapability.layerRead:
        return 'قراءة طبقة';
      case ArchiveCapability.georeferenceSubmit:
        return 'تقديم إسناد جغرافي';
    }
  }
}

enum ModuleHealthStatus {
  localReady,
  degraded,
  disabled,
  unavailable,
}

extension ModuleHealthStatusLabel on ModuleHealthStatus {
  String get label {
    switch (this) {
      case ModuleHealthStatus.localReady:
        return 'جاهز محليًا';
      case ModuleHealthStatus.degraded:
        return 'وضع محلي متدهور';
      case ModuleHealthStatus.disabled:
        return 'معطّل بمحاكاة محلية';
      case ModuleHealthStatus.unavailable:
        return 'غير متاح';
    }
  }

  bool get permitsModuleLoad =>
      this == ModuleHealthStatus.localReady ||
      this == ModuleHealthStatus.degraded;
}

class PlatformSystemContext {
  const PlatformSystemContext({
    required this.moduleId,
    required this.moduleVersion,
    required this.lifecycleMode,
    required this.platformHost,
    required this.isLocalDevelopmentHost,
  });

  final String moduleId;
  final String moduleVersion;
  final String lifecycleMode;
  final String platformHost;
  final bool isLocalDevelopmentHost;
}

class PlatformUnitContext {
  const PlatformUnitContext({
    required this.currentUnitKey,
    required this.authorizedUnitKeys,
    required this.isMock,
    required this.serverSideEnforcementRequired,
  });

  final String currentUnitKey;
  final Set<String> authorizedUnitKeys;
  final bool isMock;
  final bool serverSideEnforcementRequired;

  bool allowsUnit(String targetUnitKey) {
    return currentUnitKey == targetUnitKey &&
        authorizedUnitKeys.contains(targetUnitKey);
  }
}

class CapabilityRequest {
  const CapabilityRequest({
    required this.capability,
    required this.targetUnitKey,
    required this.actionLabel,
  });

  final ArchiveCapability capability;
  final String targetUnitKey;
  final String actionLabel;
}

class CapabilityDecision {
  const CapabilityDecision({
    required this.allowed,
    required this.reasonCode,
    required this.reasonAr,
    required this.capability,
    required this.targetUnitKey,
  });

  final bool allowed;
  final String reasonCode;
  final String reasonAr;
  final ArchiveCapability capability;
  final String targetUnitKey;
}

abstract interface class PlatformAuthorityPort {
  CapabilityDecision evaluate(CapabilityRequest request);
}

abstract interface class PlatformUnitContextPort {
  PlatformUnitContext get currentContext;
}

abstract interface class PlatformFeatureFlagPort {
  bool isEnabled(String key);
}

class ModuleHealthReport {
  const ModuleHealthReport({
    required this.status,
    required this.summaryAr,
    required this.fallbackMessageAr,
    required this.checkedAt,
  });

  final ModuleHealthStatus status;
  final String summaryAr;
  final String fallbackMessageAr;
  final DateTime checkedAt;
}

class PlatformAuditEvent {
  const PlatformAuditEvent({
    required this.eventType,
    required this.at,
    required this.summaryAr,
  });

  final String eventType;
  final DateTime at;
  final String summaryAr;
}

abstract interface class PlatformAuditPort {
  void record(PlatformAuditEvent event);
}

class ArchivePlatformAdapter {
  const ArchivePlatformAdapter({
    required this.systemContext,
    required this.unitContextPort,
    required this.authorityPort,
    required this.featureFlagPort,
    required this.auditPort,
  });

  final PlatformSystemContext systemContext;
  final PlatformUnitContextPort unitContextPort;
  final PlatformAuthorityPort authorityPort;
  final PlatformFeatureFlagPort featureFlagPort;
  final PlatformAuditPort auditPort;

  bool isRouteSlotDeclared(ModuleRouteSlot slot) {
    return const {
      ModuleRouteSlot.localProduct,
      ModuleRouteSlot.dashboard,
      ModuleRouteSlot.archiveCore,
      ModuleRouteSlot.list,
      ModuleRouteSlot.detail,
      ModuleRouteSlot.create,
      ModuleRouteSlot.registry,
      ModuleRouteSlot.representations,
      ModuleRouteSlot.review,
      ModuleRouteSlot.spatial,
      ModuleRouteSlot.temporal,
      ModuleRouteSlot.search,
      ModuleRouteSlot.admin,
      ModuleRouteSlot.stagingReadiness,
      ModuleRouteSlot.controlledUat,
      ModuleRouteSlot.productionReadiness,
      ModuleRouteSlot.reports,
      ModuleRouteSlot.settings,
    }.contains(slot);
  }
}
