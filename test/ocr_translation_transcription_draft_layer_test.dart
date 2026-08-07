import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:palwakf_evidence_archive_spatial_explorer/src/core/models/models.dart';
import 'package:palwakf_evidence_archive_spatial_explorer/src/core/state/local_operational_store.dart';

void main() {
  test('OCR translation transcription draft layer markers are present', () {
    final models = File('lib/src/core/models/models.dart').readAsStringSync();
    final store = File('lib/src/core/state/local_operational_store.dart')
        .readAsStringSync();
    final screen = File(
            'lib/src/features/text_layers/ocr_translation_transcription_screen.dart')
        .readAsStringSync();
    final app = File('lib/src/app.dart').readAsStringSync();
    final detail = File('lib/src/features/evidence/evidence_detail_screen.dart')
        .readAsStringSync();

    expect(models.contains('class TextDraftLayer'), isTrue);
    expect(models.contains('enum TextDraftLayerKind'), isTrue);
    expect(store.contains('textDraftLayers'), isTrue);
    expect(
        store.contains('String createOcrTranslationTranscriptionDraftLayer('),
        isTrue);
    expect(store.contains('void markTextDraftLayerReviewed('), isTrue);
    expect(
        screen.contains('OCR_TRANSLATION_TRANSCRIPTION_DRAFT_LAYER'), isTrue);
    expect(screen.contains('OCR_DRAFT_LAYER_LOCAL'), isTrue);
    expect(screen.contains('TRANSCRIPTION_DRAFT_LAYER_LOCAL'), isTrue);
    expect(screen.contains('TRANSLATION_DRAFT_LAYER_LOCAL'), isTrue);
    expect(screen.contains('NO_REAL_OCR_ENGINE'), isTrue);
    expect(screen.contains('NO_REAL_TRANSLATION_ENGINE'), isTrue);
    expect(screen.contains('HUMAN_REVIEW_REQUIRED_FOR_TEXT_DRAFTS'), isTrue);
    expect(screen.contains('NO_PUBLICATION_FROM_TEXT_DRAFTS'), isTrue);
    expect(app.contains('OcrTranslationTranscriptionScreen'), isTrue);
    expect(detail.contains('CATALOG_TEXT_DRAFTS_ON_DETAIL'), isTrue);
  });

  test(
      'controller creates reviewed local OCR transcription translation draft layers without publishing',
      () {
    final controller = LocalOperationalController();
    final evidenceId = controller.state.evidence.first.id;
    final beforeLayers = controller.state.textDraftLayers.length;
    final beforeRepresentations = controller.state.representations.length;
    final beforeAudit = controller.state.auditTrail.length;

    final ocrId = controller.createOcrTranslationTranscriptionDraftLayer(
      evidenceId: evidenceId,
      kind: TextDraftLayerKind.ocr,
      languageLabel: 'عربي — OCR تجريبي',
      textPreview: 'نص OCR محلي غير معتمد',
    );
    final transcriptionId =
        controller.createOcrTranslationTranscriptionDraftLayer(
      evidenceId: evidenceId,
      kind: TextDraftLayerKind.transcription,
      languageLabel: 'تفريغ عربي أولي',
      textPreview: 'تفريغ محلي غير معتمد',
    );
    final translationId =
        controller.createOcrTranslationTranscriptionDraftLayer(
      evidenceId: evidenceId,
      kind: TextDraftLayerKind.translation,
      languageLabel: 'ترجمة عربية أولية',
      textPreview: 'ترجمة مسودة غير معتمدة',
    );

    expect(controller.state.textDraftLayers.length, beforeLayers + 3);
    expect(controller.state.representations.length, beforeRepresentations + 3);
    expect(controller.state.auditTrail.length, beforeAudit + 3);
    expect(controller.state.textDraftLayers.map((item) => item.id),
        contains(ocrId));
    expect(controller.state.textDraftLayers.map((item) => item.id),
        contains(transcriptionId));
    expect(controller.state.textDraftLayers.map((item) => item.id),
        contains(translationId));

    final ocrLayer =
        controller.state.textDraftLayers.firstWhere((item) => item.id == ocrId);
    expect(ocrLayer.catalogId, isNotEmpty);
    expect(ocrLayer.documentTypeTabId, isNotEmpty);
    expect(ocrLayer.status, contains('HUMAN_REVIEW_REQUIRED_FOR_TEXT_DRAFTS'));
    expect(ocrLayer.humanReviewPolicy,
        contains('NO_PUBLICATION_FROM_TEXT_DRAFTS'));

    controller.markTextDraftLayerReviewed(ocrId);
    final reviewed =
        controller.state.textDraftLayers.firstWhere((item) => item.id == ocrId);
    expect(reviewed.status, contains('مراجعة داخليًا'));
  });
}
