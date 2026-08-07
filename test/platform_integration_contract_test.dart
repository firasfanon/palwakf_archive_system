import 'package:flutter_test/flutter_test.dart';
import 'package:palwakf_evidence_archive_spatial_explorer/src/core/models/models.dart';
import 'package:palwakf_evidence_archive_spatial_explorer/src/core/state/local_operational_store.dart';
import 'package:palwakf_evidence_archive_spatial_explorer/src/platform_integration/archive_platform_integration.dart';
import 'package:palwakf_evidence_archive_spatial_explorer/src/platform_integration/contracts.dart';

void main() {
  test('module declares logical route slots without a production route', () {
    final controller = ArchivePlatformIntegrationController();

    expect(controller.adapter.isRouteSlotDeclared(ModuleRouteSlot.dashboard),
        isTrue);
    expect(
        controller.adapter.isRouteSlotDeclared(ModuleRouteSlot.review), isTrue);
    expect(
      controller.state.systemContext.platformHost,
      equals('platform_assigned'),
    );
    expect(controller.state.isPlatformBound, isFalse);
  });

  test('local mock allows only fixture operations inside the current unit', () {
    final controller = ArchivePlatformIntegrationController();

    final allowed = controller.authorize(
      const CapabilityRequest(
        capability: ArchiveCapability.evidenceRead,
        targetUnitKey: localDevelopmentUnitKey,
        actionLabel: 'اختبار قراءة محلية',
      ),
    );
    final denied = controller.authorize(
      const CapabilityRequest(
        capability: ArchiveCapability.evidenceRead,
        targetUnitKey: 'OTHER-UNIT',
        actionLabel: 'اختبار قراءة عابرة للوحدة',
      ),
    );

    expect(allowed.allowed, isTrue);
    expect(allowed.reasonCode, equals('LOCAL_MOCK_ALLOWED'));
    expect(denied.allowed, isFalse);
    expect(denied.reasonCode, equals('CROSS_UNIT_DENIED'));
  });

  test('file and spatial operations require a platform binding', () {
    final controller = ArchivePlatformIntegrationController();

    final fileDecision = controller.authorize(
      const CapabilityRequest(
        capability: ArchiveCapability.fileObjectCreate,
        targetUnitKey: localDevelopmentUnitKey,
        actionLabel: 'إنشاء كائن ملف',
      ),
    );
    final mapDecision = controller.authorize(
      const CapabilityRequest(
        capability: ArchiveCapability.mapRender,
        targetUnitKey: localDevelopmentUnitKey,
        actionLabel: 'عرض خريطة',
      ),
    );

    expect(fileDecision.allowed, isFalse);
    expect(fileDecision.reasonCode, equals('PLATFORM_BINDING_REQUIRED'));
    expect(mapDecision.allowed, isFalse);
    expect(mapDecision.reasonCode, equals('PLATFORM_BINDING_REQUIRED'));
  });

  test('disabled module switches to fallback state and can be restored', () {
    final controller = ArchivePlatformIntegrationController();

    controller.simulateDisabledMode();
    expect(controller.state.health.status, equals(ModuleHealthStatus.disabled));
    expect(controller.state.isModuleLoadPermitted, isFalse);
    expect(controller.state.isLocalWorkbenchEnabled, isFalse);

    controller.restoreLocalMode();
    expect(
      controller.state.health.status,
      equals(ModuleHealthStatus.localReady),
    );
    expect(controller.state.isModuleLoadPermitted, isTrue);
    expect(controller.state.isLocalWorkbenchEnabled, isTrue);
  });

  test('session store rejects a cross-unit fixture mutation', () {
    final controller = LocalOperationalController();

    final outsideItem = EvidenceItem(
      id: 'EV-CROSS-UNIT-001',
      title: 'اختبار رفض خارج الوحدة',
      domain: EvidenceDomain.general,
      sourceAuthority: 'اختبار',
      reference: 'TEST/CROSS-UNIT',
      status: EvidenceReviewStatus.discovered,
      confidence: 'اختبار',
      unitScopeKey: 'OTHER-UNIT',
      isOriginalAvailableLocally: false,
      createdAt: DateTime(2026),
    );

    expect(
      () => controller.addEvidence(outsideItem),
      throwsA(isA<StateError>()),
    );
  });
}
