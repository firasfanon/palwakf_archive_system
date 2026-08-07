import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:palwakf_evidence_archive_spatial_explorer/src/core/state/local_operational_store.dart';

void main() {
  test('layered archive catalogs and open draft intake markers are present',
      () {
    final app = File('lib/src/app.dart').readAsStringSync();
    final catalogs =
        File('lib/src/features/catalogs/archive_catalogs_screen.dart')
            .readAsStringSync();
    final addDocument = File('lib/src/features/daily/add_document_screen.dart')
        .readAsStringSync();
    final store = File('lib/src/core/state/local_operational_store.dart')
        .readAsStringSync();
    final models = File('lib/src/core/models/models.dart').readAsStringSync();

    expect(app.contains('كتالوجات الأرشيف'), isTrue);
    expect(app.contains('ArchiveCatalogsScreen'), isTrue);
    expect(catalogs.contains('LAYERED_ARCHIVE_CATALOGS'), isTrue);
    expect(catalogs.contains('CATALOG_DOCUMENT_TYPE_TABS'), isTrue);
    expect(catalogs.contains('OPEN_DRAFT_INTAKE_MODE'), isTrue);
    expect(catalogs.contains('CATALOG_AWARE_INTAKE'), isTrue);
    expect(catalogs.contains('NO_INTAKE_BLOCKING_GOVERNANCE'), isTrue);
    expect(catalogs.contains('PUBLICATION_REQUIRES_HUMAN_APPROVAL'), isTrue);
    expect(catalogs.contains('DRAFT_REPRESENTATIONS_ALLOWED'), isTrue);
    expect(catalogs.contains('CATALOG_SEARCH_ENTRY_POINTS'), isTrue);
    expect(addDocument.contains('كتالوج الأرشيف'), isTrue);
    expect(addDocument.contains('تبويب نوع الوثيقة'), isTrue);
    expect(addDocument.contains('OPEN_DRAFT_INTAKE_MODE'), isTrue);
    expect(store.contains('String createOpenDraftArchiveMaterial('), isTrue);
    expect(models.contains('class ArchiveCatalog'), isTrue);
    expect(models.contains('class CatalogDocumentTypeTab'), isTrue);
  });

  test(
      'open draft controller accepts incomplete catalog material and blocks publication by status',
      () {
    final controller = LocalOperationalController();
    final beforeEvidence = controller.state.evidence.length;
    final beforeRepresentations = controller.state.representations.length;
    final beforeAudit = controller.state.auditTrail.length;

    final id = controller.createOpenDraftArchiveMaterial(
      catalogId: 'catalog-ottoman',
      catalogTitle: 'الأرشيف العثماني',
      documentTypeTabId: 'ottoman-tapu',
      documentTypeTabTitle: 'سجلات الطابو',
      title: '',
      sourceAuthority: '',
      reference: '',
      createDraftRepresentation: true,
    );

    expect(controller.state.evidence.length, beforeEvidence + 1);
    expect(controller.state.representations.length, beforeRepresentations + 1);
    expect(controller.state.auditTrail.length, beforeAudit + 1);

    final draft = controller.state.evidence.firstWhere((item) => item.id == id);
    expect(draft.catalogId, 'catalog-ottoman');
    expect(draft.documentTypeTabId, 'ottoman-tapu');
    expect(draft.draftStage, contains('مسودة'));
    expect(draft.publicationStatus, contains('الاعتماد البشري'));
    expect(draft.intakeMode, contains('OPEN_DRAFT_INTAKE_MODE'));
    expect(draft.title, contains('مسودة أرشيفية غير معنونة'));
  });
}
