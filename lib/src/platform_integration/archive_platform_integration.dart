import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'contracts.dart';

const String archiveLocalWorkbenchFlag = 'evidence_archive.local_workbench';
const String archivePlatformMountFlag = 'evidence_archive.platform_mount';

class ArchivePlatformIntegrationState {
  const ArchivePlatformIntegrationState({
    required this.systemContext,
    required this.unitContext,
    required this.featureFlags,
    required this.health,
    required this.localAuditTrail,
  });

  final PlatformSystemContext systemContext;
  final PlatformUnitContext unitContext;
  final Map<String, bool> featureFlags;
  final ModuleHealthReport health;
  final List<PlatformAuditEvent> localAuditTrail;

  bool get isModuleLoadPermitted => health.status.permitsModuleLoad;

  bool get isPlatformBound => featureFlags[archivePlatformMountFlag] ?? false;

  bool get isLocalWorkbenchEnabled =>
      featureFlags[archiveLocalWorkbenchFlag] ?? false;

  ArchivePlatformIntegrationState copyWith({
    Map<String, bool>? featureFlags,
    ModuleHealthReport? health,
    List<PlatformAuditEvent>? localAuditTrail,
  }) {
    return ArchivePlatformIntegrationState(
      systemContext: systemContext,
      unitContext: unitContext,
      featureFlags: featureFlags ?? this.featureFlags,
      health: health ?? this.health,
      localAuditTrail: localAuditTrail ?? this.localAuditTrail,
    );
  }
}

class _LocalMockUnitContextPort implements PlatformUnitContextPort {
  const _LocalMockUnitContextPort();

  @override
  PlatformUnitContext get currentContext => const PlatformUnitContext(
        currentUnitKey: localDevelopmentUnitKey,
        authorizedUnitKeys: {localDevelopmentUnitKey},
        isMock: true,
        serverSideEnforcementRequired: true,
      );
}

class _LocalFeatureFlagPort implements PlatformFeatureFlagPort {
  const _LocalFeatureFlagPort(this._flags);

  final Map<String, bool> _flags;

  @override
  bool isEnabled(String key) => _flags[key] ?? false;
}

class _LocalAuditPort implements PlatformAuditPort {
  const _LocalAuditPort();

  @override
  void record(PlatformAuditEvent event) {
    // The local adapter deliberately does not persist audit data. The
    // controller keeps a bounded session trace only for development evidence.
  }
}

class _LocalMockAuthorityPort implements PlatformAuthorityPort {
  const _LocalMockAuthorityPort({
    required this.unitContext,
    required this.featureFlags,
    required this.health,
  });

  final PlatformUnitContext unitContext;
  final Map<String, bool> featureFlags;
  final ModuleHealthReport health;

  static const _localFixtureCapabilities = {
    ArchiveCapability.evidenceRead,
    ArchiveCapability.evidenceCreateLocalDraft,
    ArchiveCapability.evidenceUpdateLocalDraft,
    ArchiveCapability.evidenceQuarantineLocalDraft,
    ArchiveCapability.collectionCreateLocalDraft,
    ArchiveCapability.relationProposeLocalDraft,
    ArchiveCapability.reviewUpdateLocalDraft,
    ArchiveCapability.importCatalogLocalDraft,
  };

  @override
  CapabilityDecision evaluate(CapabilityRequest request) {
    if (!(featureFlags[archiveLocalWorkbenchFlag] ?? false)) {
      return CapabilityDecision(
        allowed: false,
        reasonCode: 'MODULE_FEATURE_FLAG_DISABLED',
        reasonAr: 'وضع العمل المحلي معطّل بواسطة Feature Flag.',
        capability: request.capability,
        targetUnitKey: request.targetUnitKey,
      );
    }

    if (!health.status.permitsModuleLoad) {
      return CapabilityDecision(
        allowed: false,
        reasonCode: 'MODULE_UNAVAILABLE',
        reasonAr: 'الموديول غير متاح في حالة الصحة الحالية.',
        capability: request.capability,
        targetUnitKey: request.targetUnitKey,
      );
    }

    if (!unitContext.allowsUnit(request.targetUnitKey)) {
      return CapabilityDecision(
        allowed: false,
        reasonCode: 'CROSS_UNIT_DENIED',
        reasonAr: 'الوحدة المستهدفة خارج سياق الوحدة المحلي المصرح به.',
        capability: request.capability,
        targetUnitKey: request.targetUnitKey,
      );
    }

    if (!_localFixtureCapabilities.contains(request.capability)) {
      return CapabilityDecision(
        allowed: false,
        reasonCode: 'PLATFORM_BINDING_REQUIRED',
        reasonAr:
            'هذه القدرة تتطلب ربطًا منصيًا معتمدًا ولا تتاح في المضيف المحلي.',
        capability: request.capability,
        targetUnitKey: request.targetUnitKey,
      );
    }

    return CapabilityDecision(
      allowed: true,
      reasonCode: 'LOCAL_MOCK_ALLOWED',
      reasonAr: 'مسموح ضمن fixture محلي محكوم وداخل وحدة واحدة فقط.',
      capability: request.capability,
      targetUnitKey: request.targetUnitKey,
    );
  }
}

/// Local-development adapter only. It establishes the boundary expected by
/// PalWakf without impersonating central identity, authority, storage, audit,
/// routes, or any production service.
class ArchivePlatformIntegrationController
    extends StateNotifier<ArchivePlatformIntegrationState> {
  ArchivePlatformIntegrationController()
      : super(
          ArchivePlatformIntegrationState(
            systemContext: const PlatformSystemContext(
              moduleId: archiveModuleId,
              moduleVersion: archiveModuleVersion,
              lifecycleMode: 'in_progress_module_development',
              platformHost: 'platform_assigned',
              isLocalDevelopmentHost: true,
            ),
            unitContext: const PlatformUnitContext(
              currentUnitKey: localDevelopmentUnitKey,
              authorizedUnitKeys: {localDevelopmentUnitKey},
              isMock: true,
              serverSideEnforcementRequired: true,
            ),
            featureFlags: const {
              archiveLocalWorkbenchFlag: true,
              archivePlatformMountFlag: false,
            },
            health: ModuleHealthReport(
              status: ModuleHealthStatus.localReady,
              summaryAr:
                  'المضيف المحلي يعمل ببيانات fixture ولا يمثل mount منصيًا.',
              fallbackMessageAr:
                  'الموديول المحلي غير متاح. لا يجوز تفسير هذه المحاكاة كتعطل لمنصة PalWakf.',
              checkedAt: DateTime.now(),
            ),
            localAuditTrail: const [],
          ),
        );

  ArchivePlatformAdapter get adapter => ArchivePlatformAdapter(
        systemContext: state.systemContext,
        unitContextPort: const _LocalMockUnitContextPort(),
        authorityPort: _LocalMockAuthorityPort(
          unitContext: state.unitContext,
          featureFlags: state.featureFlags,
          health: state.health,
        ),
        featureFlagPort: _LocalFeatureFlagPort(state.featureFlags),
        auditPort: const _LocalAuditPort(),
      );

  CapabilityDecision authorize(CapabilityRequest request) {
    final decision = adapter.authorityPort.evaluate(request);
    _record(
      'module_capability_${decision.allowed ? 'allowed' : 'denied'}',
      '${request.capability.key}: ${decision.reasonCode}',
    );
    return decision;
  }

  void simulateDegradedMode() {
    _setHealth(
      ModuleHealthStatus.degraded,
      'وضع محلي متدهور بمحاكاة اختبارية؛ يستمر العرض دون أي خدمة منصية.',
    );
    _record('module_degraded', 'تم تفعيل محاكاة degraded mode محليًا.');
  }

  void simulateDisabledMode() {
    final flags = Map<String, bool>.from(state.featureFlags)
      ..[archiveLocalWorkbenchFlag] = false;
    state = state.copyWith(featureFlags: flags);
    _setHealth(
      ModuleHealthStatus.disabled,
      'تم تعطيل الموديول محليًا عبر kill switch تجريبي.',
    );
    _record('module_unavailable', 'تم تفعيل محاكاة تعطيل الموديول محليًا.');
  }

  void restoreLocalMode() {
    final flags = Map<String, bool>.from(state.featureFlags)
      ..[archiveLocalWorkbenchFlag] = true;
    state = state.copyWith(featureFlags: flags);
    _setHealth(
      ModuleHealthStatus.localReady,
      'تمت استعادة المضيف المحلي ضمن fixture محكوم.',
    );
    _record('module_mounted', 'تمت استعادة وضع العمل المحلي.');
  }

  void _setHealth(ModuleHealthStatus status, String summary) {
    state = state.copyWith(
      health: ModuleHealthReport(
        status: status,
        summaryAr: summary,
        fallbackMessageAr:
            'الموديول المحلي غير متاح. تستمر المنصة المستضيفة وبقية الأنظمة دون الاعتماد عليه.',
        checkedAt: DateTime.now(),
      ),
    );
  }

  void _record(String eventType, String summaryAr) {
    final event = PlatformAuditEvent(
      eventType: eventType,
      at: DateTime.now(),
      summaryAr: summaryAr,
    );
    adapter.auditPort.record(event);
    state = state.copyWith(
      localAuditTrail: [event, ...state.localAuditTrail].take(30).toList(),
    );
  }
}

final archivePlatformIntegrationProvider = StateNotifierProvider<
    ArchivePlatformIntegrationController, ArchivePlatformIntegrationState>(
  (ref) => ArchivePlatformIntegrationController(),
);
