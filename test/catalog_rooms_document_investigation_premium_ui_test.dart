import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('premium catalog rooms and document investigation markers are present',
      () {
    final catalogs =
        File('lib/src/features/catalogs/archive_catalogs_screen.dart')
            .readAsStringSync();
    final detail = File('lib/src/features/evidence/evidence_detail_screen.dart')
        .readAsStringSync();

    expect(catalogs.contains('CATALOG_ROOMS_PREMIUM_UI'), isTrue);
    expect(catalogs.contains('CATALOG_ROOM_ATMOSPHERE_PANEL'), isTrue);
    expect(catalogs.contains('ARCHIVE_ROOM_LAYER_MAP'), isTrue);
    expect(catalogs.contains('DOCUMENT_TYPE_PREMIUM_GALLERY'), isTrue);
    expect(catalogs.contains('CATALOG_ROOM_EVIDENCE_STUDIO'), isTrue);
    expect(catalogs.contains('CATALOG_METADATA_PREMIUM_FORM_RAIL'), isTrue);

    expect(detail.contains('DOCUMENT_INVESTIGATION_PREMIUM_UI'), isTrue);
    expect(detail.contains('DOCUMENT_INVESTIGATION_COMMAND_CENTER'), isTrue);
    expect(detail.contains('EVIDENCE_TIMELINE_PLACE_WAQF_PANEL'), isTrue);
    expect(detail.contains('DOCUMENT_VIEWER_REPRESENTATION_STACK'), isTrue);
    expect(detail.contains('TEXT_LAYER_INVESTIGATION_STACK'), isTrue);
    expect(detail.contains('HUMAN_REVIEW_DECISION_RAIL'), isTrue);
    expect(detail.contains('RELATIONSHIP_CONTEXT_GRAPH'), isTrue);
  });
}
