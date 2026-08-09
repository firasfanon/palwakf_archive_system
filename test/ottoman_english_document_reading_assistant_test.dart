import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('ottoman english document reading assistant exposes foundation contract',
      () {
    final screen = File(
            'lib/src/features/reading/ottoman_english_document_assistant_screen.dart')
        .readAsStringSync();
    final app = File('lib/src/app.dart').readAsStringSync();
    final verifier =
        File('tools/verify_module_reception_static.py').readAsStringSync();
    final combined = '$screen\n$app\n$verifier';

    for (final marker in [
      'OTTOMAN_ENGLISH_DOCUMENT_READING_TRANSLATION_ASSISTANT_FOUNDATION',
      'OTTOMAN_DOCUMENT_READING_ASSISTANT',
      'ENGLISH_DOCUMENT_READING_ASSISTANT',
      'PRINTED_AND_HANDWRITTEN_READING_PROFILES',
      'OTTOMAN_WORD_RECOGNITION_GLOSSARY',
      'OCR_HTR_TRANSLATION_LAYER_PIPELINE',
      'ARABIC_VERIFIED_TEXT_OUTPUT',
      'READING_CONFIDENCE_BY_WORD_LINE_PARAGRAPH',
      'SOURCE_IMAGE_TEXT_ALIGNMENT',
      'HUMAN_REVIEW_REQUIRED_FOR_HISTORICAL_TRANSLATION',
      'NO_REAL_OCR_ENGINE_IN_FOUNDATION',
      'NO_REAL_TRANSLATION_ENGINE_IN_FOUNDATION',
      'AI_READING_OUTPUT_DRAFT_ONLY',
      'OTTOMAN_TERMS_REQUIRE_GLOSSARY_REVIEW',
      'NO_PUBLICATION_FROM_DOCUMENT_READING_ASSISTANT',
      'DOCUMENT_READING_ASSISTANT_NAV_ENTRY',
      'DOCUMENT_READING_ASSISTANT_ROUTE',
    ]) {
      expect(combined, contains(marker), reason: marker);
    }

    expect(screen, contains('class DocumentReadingProfile'));
    expect(screen, contains('class ReadingLayer'));
    expect(screen, contains('class HistoricalTerm'));
    expect(app, contains('OttomanEnglishDocumentAssistantScreen'));
    expect(app, contains("document-reading-assistant"));
    expect(app, contains('مساعد قراءة الوثائق'));
  });
}
