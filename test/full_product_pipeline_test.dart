import 'package:flutter_test/flutter_test.dart';
import 'package:palwakf_evidence_archive_spatial_explorer/src/core/models/models.dart';
import 'package:palwakf_evidence_archive_spatial_explorer/src/core/state/local_operational_store.dart';

void main() {
  test('full local product pipeline exposes all readiness stages', () {
    final controller = LocalOperationalController();
    final stages = controller.state.readiness.map((item) => item.stage).toSet();

    expect(stages.contains(ReadinessStage.localProduct), isTrue);
    expect(stages.contains(ReadinessStage.coreArchive), isTrue);
    expect(stages.contains(ReadinessStage.evidence), isTrue);
    expect(stages.contains(ReadinessStage.review), isTrue);
    expect(stages.contains(ReadinessStage.spatialSearch), isTrue);
    expect(stages.contains(ReadinessStage.admin), isTrue);
    expect(stages.contains(ReadinessStage.stagingReadiness), isTrue);
    expect(stages.contains(ReadinessStage.controlledUat), isTrue);
    expect(stages.contains(ReadinessStage.productionReadiness), isTrue);
  });

  test('archive hierarchy includes fonds series file and item nodes', () {
    final controller = LocalOperationalController();
    final nodeTypes =
        controller.state.archiveNodes.map((item) => item.type).toSet();

    expect(nodeTypes.contains(ArchiveNodeType.fonds), isTrue);
    expect(nodeTypes.contains(ArchiveNodeType.series), isTrue);
    expect(nodeTypes.contains(ArchiveNodeType.file), isTrue);
    expect(nodeTypes.contains(ArchiveNodeType.item), isTrue);
  });

  test('production readiness remains explicitly blocked', () {
    final controller = LocalOperationalController();
    final production = controller.state.readiness.firstWhere(
      (item) => item.stage == ReadinessStage.productionReadiness,
    );

    expect(production.state, ReadinessState.blocked);
    expect(production.blocker, contains('PRODUCTION_APPROVAL=NOT_APPROVED'));
  });

  test('search uses local fixture only and finds waqf asset links', () {
    final controller = LocalOperationalController();
    final results = controller.searchEvidence('PWF-AST-DEMO-0001');

    expect(results.length, 1);
    expect(results.single.linkedWaqfAssetId, 'PWF-AST-DEMO-0001');
  });
}
