import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:palwakf_evidence_archive_spatial_explorer/src/core/state/local_operational_store.dart';

void main() {
  test('smart indexing surfaces expose OCR duplicate and saved search markers',
      () {
    final app = File('lib/src/app.dart').readAsStringSync();
    final screen =
        File('lib/src/features/smart_indexing/smart_indexing_screen.dart')
            .readAsStringSync();
    final store = File('lib/src/core/state/local_operational_store.dart')
        .readAsStringSync();

    expect(app.contains('SmartIndexingScreen'), isTrue);
    expect(screen.contains('SMART_INDEXING_OPERATIONALIZATION'), isTrue);
    expect(screen.contains('OCR_INDEX_QUEUE_LOCAL'), isTrue);
    expect(screen.contains('DUPLICATE_DETECTION_LOCAL'), isTrue);
    expect(screen.contains('SAVED_SEARCH_LOCAL'), isTrue);
    expect(screen.contains('TAXONOMY_SUGGESTION_REVIEW'), isTrue);
    expect(store.contains('void createSmartIndexJob('), isTrue);
    expect(store.contains('void completeSmartIndexJob('), isTrue);
    expect(store.contains('void saveSmartSearch('), isTrue);
  });

  test('local controller runs smart indexing and duplicate decisions', () {
    final controller = LocalOperationalController();
    final jobsBefore = controller.state.smartIndexJobs.length;
    final savedBefore = controller.state.savedSearches.length;

    controller.createSmartIndexJob(
        'EV-DEMO-WAQF-0001', 'OCR + فهرسة كلمات مفتاحية');
    expect(controller.state.smartIndexJobs.length, jobsBefore + 1);

    final newestJob = controller.state.smartIndexJobs.first;
    controller.completeSmartIndexJob(newestJob.id);
    expect(controller.state.smartIndexJobs.first.status, 'مكتمل محليًا');
    expect(controller.state.smartIndexJobs.first.suggestedKeywords, isNotEmpty);

    controller.confirmDuplicateCandidate('DUP-LOCAL-001');
    expect(
        controller.state.duplicateCandidates.first.status, 'مؤكد كمكرر محليًا');

    controller.saveSmartSearch('اختبار بحث محفوظ', 'وقف', 'داخلي');
    expect(controller.state.savedSearches.length, savedBefore + 1);

    controller.acceptTaxonomySuggestion('TAX-LOCAL-001');
    expect(controller.state.taxonomySuggestions.first.status, 'مقبول محليًا');
  });
}
