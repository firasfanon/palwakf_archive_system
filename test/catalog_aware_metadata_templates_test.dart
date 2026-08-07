import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:palwakf_evidence_archive_spatial_explorer/src/core/state/local_operational_store.dart';

void main() {
  test(
      'catalog-aware metadata templates and dynamic draft form markers are present',
      () {
    final models = File('lib/src/core/models/models.dart').readAsStringSync();
    final store = File('lib/src/core/state/local_operational_store.dart')
        .readAsStringSync();
    final addDocument = File('lib/src/features/daily/add_document_screen.dart')
        .readAsStringSync();
    final catalogs =
        File('lib/src/features/catalogs/archive_catalogs_screen.dart')
            .readAsStringSync();

    expect(models.contains('class CatalogMetadataTemplate'), isTrue);
    expect(models.contains('class MetadataTemplateField'), isTrue);
    expect(store.contains('metadataTemplates'), isTrue);
    expect(store.contains('template-ottoman-tapu'), isTrue);
    expect(store.contains('template-ottoman-waqf-deeds'), isTrue);
    expect(store.contains('template-british-land-records'), isTrue);
    expect(store.contains('template-jordanian-registration'), isTrue);
    expect(store.contains('template-palestinian-settlement'), isTrue);
    expect(
        store.contains('String createCatalogAwareDraftFromTemplate('), isTrue);
    expect(addDocument.contains('CATALOG_AWARE_METADATA_TEMPLATES'), isTrue);
    expect(addDocument.contains('DYNAMIC_DRAFT_FORM_FIELDS'), isTrue);
    expect(addDocument.contains('OTTOMAN_TAPU_DRAFT_FORM'), isTrue);
    expect(addDocument.contains('metadataTemplateId'), isTrue);
    expect(catalogs.contains('قالب metadata لهذا النوع'), isTrue);
    expect(catalogs.contains('AI_ASSISTED_METADATA_DRAFTING_READY'), isTrue);
  });

  test(
      'controller accepts incomplete template metadata as open draft and keeps publication blocked',
      () {
    final controller = LocalOperationalController();
    final beforeEvidence = controller.state.evidence.length;
    final beforeAudit = controller.state.auditTrail.length;

    final id = controller.createCatalogAwareDraftFromTemplate(
      catalogId: 'catalog-ottoman',
      catalogTitle: 'الأرشيف العثماني',
      documentTypeTabId: 'ottoman-tapu',
      documentTypeTabTitle: 'سجلات الطابو',
      metadataTemplateId: 'template-ottoman-tapu',
      metadataValues: const {
        'defter_number': 'دفتر تجريبي 1',
        'place_name': 'أرطاس',
      },
      createDraftRepresentation: false,
    );

    expect(controller.state.evidence.length, beforeEvidence + 1);
    expect(controller.state.auditTrail.length, beforeAudit + 1);

    final draft = controller.state.evidence.firstWhere((item) => item.id == id);
    expect(draft.metadataTemplateId, 'template-ottoman-tapu');
    expect(draft.structuredMetadata['place_name'], 'أرطاس');
    expect(draft.missingMetadataWarnings, isNotEmpty);
    expect(draft.templateReadinessLabel, contains('مسودة'));
    expect(draft.aiAssistancePlan, contains('OCR'));
    expect(draft.publicationStatus, contains('الاعتماد البشري'));
  });
}
