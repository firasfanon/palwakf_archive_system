import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/models.dart';
import '../../core/state/local_operational_store.dart';
import '../../shared/widgets.dart';

class OcrTranslationTranscriptionScreen extends ConsumerStatefulWidget {
  const OcrTranslationTranscriptionScreen({super.key});

  @override
  ConsumerState<OcrTranslationTranscriptionScreen> createState() =>
      _OcrTranslationTranscriptionScreenState();
}

class _OcrTranslationTranscriptionScreenState
    extends ConsumerState<OcrTranslationTranscriptionScreen> {
  String? _evidenceId;
  TextDraftLayerKind _kind = TextDraftLayerKind.ocr;
  final _languageController =
      TextEditingController(text: 'عربي / عثماني — مسودة');
  final _previewController = TextEditingController(
    text:
        'مسودة نصية أولية مرتبطة بالكتالوج، تحتاج مراجعة بشرية قبل الاعتماد أو النشر.',
  );

  @override
  void dispose() {
    _languageController.dispose();
    _previewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(localOperationalProvider);
    final controller = ref.read(localOperationalProvider.notifier);
    final selectedId = _evidenceId ??
        (state.evidence.isEmpty ? null : state.evidence.first.id);

    // OCR_TRANSLATION_TRANSCRIPTION_DRAFT_LAYER: this page creates and reviews
    // OCR, transcription, and translation drafts as session-local derivative text layers.
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const _TextLayerStudioHero(),
        const SizedBox(height: 12),
        const LocalOnlyBanner(),
        const SizedBox(height: 12),
        SectionCard(
          icon: Icons.article_outlined,
          title: 'مسودات نصية مشتقة من الوثائق',
          subtitle:
              'OCR_DRAFT_LAYER_LOCAL + TRANSCRIPTION_DRAFT_LAYER_LOCAL + TRANSLATION_DRAFT_LAYER_LOCAL: لا OCR حقيقي ولا ترجمة آلية فعلية؛ كل شيء مسودة قابلة للمراجعة البشرية.',
          children: [
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                MetricTile(
                  icon: Icons.document_scanner_outlined,
                  label: 'مسودات OCR',
                  value: '${state.ocrDraftLayerCount}',
                ),
                MetricTile(
                  icon: Icons.edit_note_outlined,
                  label: 'مسودات تفريغ',
                  value: '${state.transcriptionDraftLayerCount}',
                ),
                MetricTile(
                  icon: Icons.translate_outlined,
                  label: 'مسودات ترجمة',
                  value: '${state.translationDraftLayerCount}',
                ),
                MetricTile(
                  icon: Icons.verified_user_outlined,
                  label: 'بانتظار مراجعة بشرية',
                  value: '${state.humanReviewPendingTextDraftCount}',
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        SectionCard(
          icon: Icons.note_add_outlined,
          title: 'إضافة طبقة نصية مسودة',
          subtitle:
              'CATALOG_LINKED_TEXT_DRAFTS + TEXT_DRAFT_REPRESENTATION_LINKING: الطبقة تحفظ catalogId/documentTypeTabId من الوثيقة ولا تستبدل الأصل.',
          children: [
            Wrap(
              spacing: 12,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SizedBox(
                  width: 360,
                  child: DropdownButtonFormField<String>(
                    initialValue: selectedId,
                    decoration: const InputDecoration(labelText: 'الوثيقة'),
                    items: [
                      for (final item in state.evidence)
                        DropdownMenuItem(
                            value: item.id, child: Text(item.title)),
                    ],
                    onChanged: (value) => setState(() => _evidenceId = value),
                  ),
                ),
                SizedBox(
                  width: 260,
                  child: DropdownButtonFormField<TextDraftLayerKind>(
                    initialValue: _kind,
                    decoration: const InputDecoration(labelText: 'نوع الطبقة'),
                    items: const [
                      DropdownMenuItem(
                        value: TextDraftLayerKind.ocr,
                        child: Text('مسودة OCR'),
                      ),
                      DropdownMenuItem(
                        value: TextDraftLayerKind.transcription,
                        child: Text('مسودة تفريغ'),
                      ),
                      DropdownMenuItem(
                        value: TextDraftLayerKind.translation,
                        child: Text('مسودة ترجمة'),
                      ),
                    ],
                    onChanged: (value) =>
                        setState(() => _kind = value ?? _kind),
                  ),
                ),
                SizedBox(
                  width: 280,
                  child: TextField(
                    controller: _languageController,
                    decoration:
                        const InputDecoration(labelText: 'لغة/وصف القراءة'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _previewController,
              minLines: 3,
              maxLines: 6,
              decoration: const InputDecoration(
                labelText: 'نص المسودة / مقتطف OCR / تفريغ / ترجمة',
                helperText:
                    'NO_REAL_OCR_ENGINE + NO_REAL_TRANSLATION_ENGINE: إدخال محلي فقط.',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: selectedId == null
                  ? null
                  : () {
                      controller.createOcrTranslationTranscriptionDraftLayer(
                        evidenceId: selectedId,
                        kind: _kind,
                        languageLabel: _languageController.text,
                        textPreview: _previewController.text,
                        qualityWarnings: const [
                          'تحذير جودة: المسودة غير معتمدة',
                          'HUMAN_REVIEW_REQUIRED_FOR_TEXT_DRAFTS',
                        ],
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('أضيفت الطبقة النصية كمسودة محلية.')),
                      );
                    },
              icon: const Icon(Icons.playlist_add_outlined),
              label: const Text('إضافة طبقة نصية مسودة'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SectionCard(
          icon: Icons.rule_outlined,
          title: 'قواعد الاعتماد والنشر',
          subtitle:
              'HUMAN_REVIEW_REQUIRED_FOR_TEXT_DRAFTS + NO_PUBLICATION_FROM_TEXT_DRAFTS: هذه الطبقات مساعدة بحثية فقط.',
          children: const [
            KeyValueLine(
                label: 'OCR',
                value:
                    'NO_REAL_OCR_ENGINE — لا يوجد محرك OCR فعلي في هذا المسار.'),
            KeyValueLine(
                label: 'Translation',
                value:
                    'NO_REAL_TRANSLATION_ENGINE — لا ترجمة آلية فعلية أو اعتماد لغوي.'),
            KeyValueLine(
                label: 'Publication',
                value:
                    'PUBLICATION_REQUIRES_HUMAN_APPROVAL — لا نشر قبل الاعتماد البشري.'),
          ],
        ),
        const SizedBox(height: 12),
        SectionCard(
          icon: Icons.library_books_outlined,
          title: 'طبقات النص المسودة',
          children: [
            if (state.textDraftLayers.isEmpty)
              const EmptyState(message: 'لا توجد طبقات نصية مسودة.')
            else
              for (final layer in state.textDraftLayers)
                _TextDraftLayerCard(
                  layer: layer,
                  evidence: state.evidence,
                  onReviewed: controller.markTextDraftLayerReviewed,
                ),
          ],
        ),
      ],
    );
  }
}

class _TextLayerStudioHero extends StatelessWidget {
  const _TextLayerStudioHero();

  @override
  Widget build(BuildContext context) {
    // TEXT_LAYER_STUDIO_EXPERIENCE: OCR/transcription/translation is presented
    // as a draft text studio, not as an approved AI engine.
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF073F31),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'استوديو OCR والترجمة والتفريغ',
            style: TextStyle(
                color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900),
          ),
          SizedBox(height: 8),
          Text(
            'طبقات نصية مساعدة مرتبطة بالكتالوج والوثيقة والتمثيل. لا OCR حقيقي ولا ترجمة معتمدة؛ كل قراءة تبقى مسودة حتى المراجعة البشرية.',
            style: TextStyle(color: Colors.white70, height: 1.6),
          ),
          SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Chip(label: Text('OCR Draft')),
              Chip(label: Text('Transcription Draft')),
              Chip(label: Text('Translation Draft')),
              Chip(label: Text('Human Review Required')),
            ],
          ),
        ],
      ),
    );
  }
}

class _TextDraftLayerCard extends StatelessWidget {
  const _TextDraftLayerCard({
    required this.layer,
    required this.evidence,
    required this.onReviewed,
  });

  final TextDraftLayer layer;
  final List<EvidenceItem> evidence;
  final ValueChanged<String> onReviewed;

  @override
  Widget build(BuildContext context) {
    final item = evidence.firstWhere(
      (candidate) => candidate.id == layer.evidenceId,
      orElse: () => EvidenceItem(
        id: layer.evidenceId,
        title: layer.evidenceId,
        domain: EvidenceDomain.general,
        sourceAuthority: 'غير معروف',
        reference: layer.evidenceId,
        status: EvidenceReviewStatus.discovered,
        confidence: 'غير معروف',
        unitScopeKey: layer.unitScopeKey,
        isOriginalAvailableLocally: false,
        createdAt: layer.createdAt,
      ),
    );
    return Card.filled(
      child: ListTile(
        leading: Icon(_iconFor(layer.kind)),
        title: Text('${layer.kind.label} — ${item.title}'),
        subtitle: Text(
          '${layer.languageLabel}\n${layer.textPreview}\n${layer.status}\n${layer.humanReviewPolicy}',
        ),
        isThreeLine: true,
        trailing: Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            StatusPill(label: layer.catalogId),
            OutlinedButton.icon(
              onPressed: layer.status.contains('مراجعة داخليًا')
                  ? null
                  : () => onReviewed(layer.id),
              icon: const Icon(Icons.fact_check_outlined),
              label: const Text('وسم كمراجع'),
            ),
          ],
        ),
      ),
    );
  }

  IconData _iconFor(TextDraftLayerKind kind) {
    switch (kind) {
      case TextDraftLayerKind.ocr:
        return Icons.document_scanner_outlined;
      case TextDraftLayerKind.transcription:
        return Icons.edit_note_outlined;
      case TextDraftLayerKind.translation:
        return Icons.translate_outlined;
    }
  }
}
