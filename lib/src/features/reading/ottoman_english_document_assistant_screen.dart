// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';

// OTTOMAN_ENGLISH_DOCUMENT_READING_TRANSLATION_ASSISTANT_FOUNDATION:
// Foundational internal assistant for reading, transcribing, translating, and
// reviewing Ottoman and English archive documents as draft-only archival layers.
// AI_READING_OUTPUT_DRAFT_ONLY
// HUMAN_REVIEW_REQUIRED_FOR_HISTORICAL_TRANSLATION
// NO_REAL_OCR_ENGINE_IN_FOUNDATION
// NO_REAL_TRANSLATION_ENGINE_IN_FOUNDATION
// NO_PUBLICATION_FROM_DOCUMENT_READING_ASSISTANT
// DOCUMENT_READING_ASSISTANT_INTERACTIVE_WORKBENCH
// DOCUMENT_READING_IMAGE_SELECTION_PANEL
// DOCUMENT_READING_PROFILE_SELECTOR
// READING_LAYER_MANUAL_DRAFT_EDITOR
// OTTOMAN_GLOSSARY_INTERACTIVE_BUILDER
// SOURCE_IMAGE_TEXT_COMPARISON_WORKBENCH
// ARABIC_TRANSLATION_DRAFT_EDITOR
// REVIEWER_DECISION_AND_CONFIDENCE_PANEL
// NO_FILE_UPLOAD_BACKEND_IN_WORKBENCH
// NO_REAL_OCR_ENGINE_IN_WORKBENCH
// NO_REAL_HTR_ENGINE_IN_WORKBENCH
// NO_REAL_TRANSLATION_ENGINE_IN_WORKBENCH
// DRAFT_ONLY_INTERACTIVE_READING_OUTPUT
// HUMAN_APPROVAL_REQUIRED_FOR_WORKBENCH_TEXT

class OttomanEnglishDocumentAssistantScreen extends StatefulWidget {
  const OttomanEnglishDocumentAssistantScreen({super.key});

  @override
  State<OttomanEnglishDocumentAssistantScreen> createState() =>
      _OttomanEnglishDocumentAssistantScreenState();
}

class _OttomanEnglishDocumentAssistantScreenState
    extends State<OttomanEnglishDocumentAssistantScreen> {
  static const _profiles = <DocumentReadingProfile>[
    DocumentReadingProfile(
      title: 'وثيقة عثمانية مطبوعة أو بخط الديوان',
      language: 'عثمانية / عربية / تركية عثمانية مختلطة',
      script: 'حرف عربي عثماني — مطبوع أو handwritten',
      sourcePeriod: 'العهد العثماني',
      readingDifficulty: 'عالٍ — يحتاج قاموس مصطلحات ومراجعة محقق',
      terminologyDomain: 'طابو، وقف، حكر، عشر، حدود، أسماء مواضع',
      icon: Icons.history_edu_outlined,
    ),
    DocumentReadingProfile(
      title: 'وثيقة إنجليزية من فترة الانتداب',
      language: 'English',
      script: 'Latin script — printed / handwritten',
      sourcePeriod: 'British Mandate',
      readingDifficulty: 'متوسط — يحتاج ضبط مصطلحات قانونية وتاريخية',
      terminologyDomain: 'Land registry, survey, endowment, parcel, taxation',
      icon: Icons.public_outlined,
    ),
    DocumentReadingProfile(
      title: 'وثيقة مختلطة أو مرفقات متعددة',
      language: 'Ottoman / English / Arabic mixed',
      script: 'مختلط: صورة، ختم، هامش، توقيع، جدول',
      sourcePeriod: 'عثماني / بريطاني / لاحق',
      readingDifficulty: 'عالٍ — يحتاج تقسيم مناطق وربط كل منطقة بطبقة نصية',
      terminologyDomain: 'أعلام، أماكن، أوقاف، حوض/قطعة، وحدات قياس',
      icon: Icons.layers_outlined,
    ),
  ];

  static const _seedLayers = <ReadingLayer>[
    ReadingLayer(
      title: 'الصورة الأصلية وتقسيم المناطق',
      engineRole: 'SOURCE_IMAGE_TEXT_ALIGNMENT',
      draftText: 'Region A / seal / margin / handwritten note',
      arabicOutput: 'تحديد مواضع الختم والهامش والسطر قبل أي قراءة نصية.',
      confidence: 'ثقة مكانية: 82%',
      reviewerStatus: 'بحاجة ضبط يدوي',
    ),
    ReadingLayer(
      title: 'OCR / HTR أولي',
      engineRole: 'OCR_HTR_TRANSLATION_LAYER_PIPELINE',
      draftText: 'وقف / طابو / tapu / endowment / parcel',
      arabicOutput: 'تفريغ أولي غير معتمد، لا يصلح للنشر.',
      confidence: 'ثقة كلمة/سطر: 61%',
      reviewerStatus: 'مراجعة محقق لازمة',
    ),
    ReadingLayer(
      title: 'قراءة عثمانية محافظة',
      engineRole: 'OTTOMAN_WORD_RECOGNITION_GLOSSARY',
      draftText: 'حكر، عشر، مقاطعة، ويركو، دفتر خانة',
      arabicOutput: 'قراءة المصطلح كما هو ثم شرحه قبل ترجمته أو تطبيعه.',
      confidence: 'ثقة مصطلحية: 55%',
      reviewerStatus: 'يعتمد بعد مراجعة قاموس المصطلحات',
    ),
    ReadingLayer(
      title: 'ترجمة عربية دقيقة',
      engineRole: 'ARABIC_VERIFIED_TEXT_OUTPUT',
      draftText: 'The land parcel is registered as an endowment holding.',
      arabicOutput: 'القطعة مسجلة بوصفها حيازة/ملك منفعة وقفي بحسب سياق السجل.',
      confidence: 'ثقة ترجمة: 70%',
      reviewerStatus: 'اعتماد بشري قبل الإتاحة',
    ),
  ];

  DocumentReadingProfile _profile = _profiles.first;
  String _scriptMode = 'مطبوع وخط يد';
  String _readingStatus = 'مسودة تحتاج مراجعة';
  double _confidence = 0.62;

  final _sourceRegionController = TextEditingController(
    text: 'Region A — header / seal / right margin / handwritten note',
  );
  final _draftReadingController = TextEditingController(
    text: 'وقف / طابو / حكر / عشر / tapu / endowment / parcel',
  );
  final _arabicTranslationController = TextEditingController(
    text:
        'ترجمة عربية مسودة: يتم تثبيت معنى المصطلح بعد مقارنة الصورة والتفريغ والقاموس ومراجعة المحقق.',
  );
  final _glossaryTermController = TextEditingController(text: 'ويركو / Verko');
  final _glossaryEquivalentController = TextEditingController(
    text: 'ضريبة/تخمين مالي مرتبط بالسجل',
  );
  final _reviewerNoteController = TextEditingController(
    text:
        'لا يعتمد النص قبل مطابقة موضع الكلمة في الصورة ومراجعة المصطلح التاريخي.',
  );

  final List<HistoricalTerm> _terms = <HistoricalTerm>[
    const HistoricalTerm(
      sourceTerm: 'ويركو / Verko',
      language: 'عثمانية / تركية عثمانية',
      arabicEquivalent: 'ضريبة/تخمين مالي مرتبط بالسجل',
      domain: 'ضرائب وأراضي',
      reviewNote: 'لا يترجم حرفيًا؛ يربط بسياق التخمين والاحتساب.',
    ),
    const HistoricalTerm(
      sourceTerm: 'Tapu / طابو',
      language: 'عثمانية / إنجليزية إدارية',
      arabicEquivalent: 'سجل ملكية/تصرف أرضي',
      domain: 'أراضي وتسجيل',
      reviewNote: 'قد يشير إلى السجل أو سند التسجيل حسب الوثيقة.',
    ),
    const HistoricalTerm(
      sourceTerm: 'Endowment',
      language: 'English',
      arabicEquivalent: 'وقف',
      domain: 'وقف وقانون',
      reviewNote:
          'يفرق بين charitable endowment وreligious endowment بحسب السياق.',
    ),
    const HistoricalTerm(
      sourceTerm: 'مقاطعة / حكر / عشر',
      language: 'عثمانية / عربية قانونية',
      arabicEquivalent: 'مصطلحات مالية/وقفية يجب شرحها لا تطبيعها فقط',
      domain: 'وقف ومالية تاريخية',
      reviewNote: 'OTTOMAN_TERMS_REQUIRE_GLOSSARY_REVIEW',
    ),
  ];

  @override
  void dispose() {
    _sourceRegionController.dispose();
    _draftReadingController.dispose();
    _arabicTranslationController.dispose();
    _glossaryTermController.dispose();
    _glossaryEquivalentController.dispose();
    _reviewerNoteController.dispose();
    super.dispose();
  }

  void _simulateDraftLayer() {
    setState(() {
      _draftReadingController.text = _profile.title.contains('إنجليزية')
          ? 'Land registry / survey / endowment / parcel / taxation note'
          : 'وقف، طابو، حكر، عشر، ويركو، حد قبلي، حد شرقي';
      _arabicTranslationController.text = _profile.title.contains('إنجليزية')
          ? 'مسودة ترجمة: سجل أرضي من فترة الانتداب يتضمن إحالة إلى وقف أو قطعة مرتبطة بقيود مساحة وضريبة.'
          : 'مسودة ترجمة: نص عثماني يتضمن ألفاظًا وقفية ومالية تحتاج ضبطًا مصطلحيًا قبل الاعتماد.';
      _confidence = _profile.title.contains('إنجليزية') ? 0.74 : 0.58;
      _readingStatus = 'مسودة مولدة محليًا — تحتاج اعتماد محقق';
    });
  }

  void _addGlossaryTerm() {
    final term = _glossaryTermController.text.trim();
    final equivalent = _glossaryEquivalentController.text.trim();
    if (term.isEmpty || equivalent.isEmpty) return;
    setState(() {
      _terms.insert(
        0,
        HistoricalTerm(
          sourceTerm: term,
          language: _profile.language,
          arabicEquivalent: equivalent,
          domain: _profile.terminologyDomain,
          reviewNote: _reviewerNoteController.text.trim().isEmpty
              ? 'مصطلح تفاعلي يحتاج مراجعة قاموس.'
              : _reviewerNoteController.text.trim(),
        ),
      );
      _glossaryTermController.clear();
      _glossaryEquivalentController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _HeroPanel(onGenerateDraft: _simulateDraftLayer),
          const SizedBox(height: 18),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: const [
              _StatusChip(
                  label: 'وثائق عثمانية',
                  marker: 'OTTOMAN_DOCUMENT_READING_ASSISTANT'),
              _StatusChip(
                  label: 'وثائق إنجليزية',
                  marker: 'ENGLISH_DOCUMENT_READING_ASSISTANT'),
              _StatusChip(
                  label: 'مطبوع وخط يد',
                  marker: 'PRINTED_AND_HANDWRITTEN_READING_PROFILES'),
              _StatusChip(
                  label: 'ورشة تفاعلية',
                  marker: 'DOCUMENT_READING_ASSISTANT_INTERACTIVE_WORKBENCH'),
              _StatusChip(
                  label: 'مسودة فقط',
                  marker: 'DRAFT_ONLY_INTERACTIVE_READING_OUTPUT'),
              _StatusChip(
                  label: 'لا نشر قبل الاعتماد',
                  marker: 'HUMAN_APPROVAL_REQUIRED_FOR_WORKBENCH_TEXT'),
            ],
          ),
          const SizedBox(height: 22),
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 1080;
              final profile = _ProfileSelectorPanel(
                profile: _profile,
                profiles: _profiles,
                scriptMode: _scriptMode,
                onProfileChanged: (value) => setState(() => _profile = value),
                onScriptChanged: (value) => setState(() => _scriptMode = value),
              );
              final image = _ImageSelectionPanel(
                sourceRegionController: _sourceRegionController,
                onSimulateDraft: _simulateDraftLayer,
              );
              if (!isWide) {
                return Column(
                    children: [profile, const SizedBox(height: 16), image]);
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: profile),
                  const SizedBox(width: 16),
                  Expanded(child: image),
                ],
              );
            },
          ),
          const SizedBox(height: 22),
          _ComparisonWorkbenchPanel(
            draftReadingController: _draftReadingController,
            arabicTranslationController: _arabicTranslationController,
            sourceRegionController: _sourceRegionController,
          ),
          const SizedBox(height: 22),
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 1080;
              final glossary = _GlossaryBuilderPanel(
                terms: _terms,
                termController: _glossaryTermController,
                equivalentController: _glossaryEquivalentController,
                onAdd: _addGlossaryTerm,
              );
              final review = _ReviewerDecisionPanel(
                confidence: _confidence,
                readingStatus: _readingStatus,
                reviewerNoteController: _reviewerNoteController,
                onConfidenceChanged: (value) =>
                    setState(() => _confidence = value),
                onStatusChanged: (value) =>
                    setState(() => _readingStatus = value),
              );
              if (!isWide) {
                return Column(
                    children: [glossary, const SizedBox(height: 16), review]);
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 3, child: glossary),
                  const SizedBox(width: 16),
                  Expanded(flex: 2, child: review),
                ],
              );
            },
          ),
          const SizedBox(height: 22),
          _PipelinePanel(layers: _seedLayers),
          const SizedBox(height: 22),
          _BoundaryPanel(theme: theme),
        ],
      ),
    );
  }
}

class DocumentReadingProfile {
  const DocumentReadingProfile({
    required this.title,
    required this.language,
    required this.script,
    required this.sourcePeriod,
    required this.readingDifficulty,
    required this.terminologyDomain,
    required this.icon,
  });

  final String title;
  final String language;
  final String script;
  final String sourcePeriod;
  final String readingDifficulty;
  final String terminologyDomain;
  final IconData icon;
}

class ReadingLayer {
  const ReadingLayer({
    required this.title,
    required this.engineRole,
    required this.draftText,
    required this.arabicOutput,
    required this.confidence,
    required this.reviewerStatus,
  });

  final String title;
  final String engineRole;
  final String draftText;
  final String arabicOutput;
  final String confidence;
  final String reviewerStatus;
}

class HistoricalTerm {
  const HistoricalTerm({
    required this.sourceTerm,
    required this.language,
    required this.arabicEquivalent,
    required this.domain,
    required this.reviewNote,
  });

  final String sourceTerm;
  final String language;
  final String arabicEquivalent;
  final String domain;
  final String reviewNote;
}

class _HeroPanel extends StatelessWidget {
  const _HeroPanel({required this.onGenerateDraft});

  final VoidCallback onGenerateDraft;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [Color(0xFF073F31), Color(0xFF0B6F54), Color(0xFF2B2118)],
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth > 900;
          return Flex(
            direction: wide ? Axis.horizontal : Axis.vertical,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: wide ? 3 : 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ورشة قراءة الوثائق العثمانية والإنجليزية',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'اختيار صورة وثيقة، تحديد اللغة والخط، بناء طبقات قراءة يدوية، مقارنة النص بالصورة، ثم إنتاج ترجمة عربية مسودة قابلة للمراجعة البشرية.',
                      style: TextStyle(color: Color(0xFFF5EEDC), height: 1.7),
                    ),
                    const SizedBox(height: 18),
                    FilledButton.icon(
                      onPressed: onGenerateDraft,
                      icon: const Icon(Icons.auto_fix_high_outlined),
                      label: const Text('إنشاء طبقة قراءة مسودة'),
                    ),
                  ],
                ),
              ),
              if (wide)
                const SizedBox(width: 28)
              else
                const SizedBox(height: 18),
              Expanded(
                flex: wide ? 2 : 0,
                child: const _MarkerCard(),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _MarkerCard extends StatelessWidget {
  const _MarkerCard();

  @override
  Widget build(BuildContext context) {
    const markers = [
      'DOCUMENT_READING_IMAGE_SELECTION_PANEL',
      'SOURCE_IMAGE_TEXT_COMPARISON_WORKBENCH',
      'READING_LAYER_MANUAL_DRAFT_EDITOR',
      'ARABIC_TRANSLATION_DRAFT_EDITOR',
    ];
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.22),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: markers
            .map(
              (marker) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_outline,
                        color: Color(0xFFC79A35), size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        marker,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label, required this.marker});

  final String label;
  final String marker;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: marker,
      child: Chip(
        avatar: const Icon(Icons.verified_outlined, size: 18),
        label: Text(label),
        backgroundColor: const Color(0xFFFFF6E4),
        side: const BorderSide(color: Color(0xFFE0C47E)),
      ),
    );
  }
}

class _ProfileSelectorPanel extends StatelessWidget {
  const _ProfileSelectorPanel({
    required this.profile,
    required this.profiles,
    required this.scriptMode,
    required this.onProfileChanged,
    required this.onScriptChanged,
  });

  final DocumentReadingProfile profile;
  final List<DocumentReadingProfile> profiles;
  final String scriptMode;
  final ValueChanged<DocumentReadingProfile> onProfileChanged;
  final ValueChanged<String> onScriptChanged;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      title: 'DocumentReadingProfile — محدد القراءة',
      subtitle:
          'DOCUMENT_READING_PROFILE_SELECTOR: تحديد اللغة والحقبة والخط قبل إنشاء أي طبقة قراءة.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonFormField<DocumentReadingProfile>(
            value: profile,
            items: profiles
                .map(
                  (item) => DropdownMenuItem<DocumentReadingProfile>(
                    value: item,
                    child: Text(item.title),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value != null) onProfileChanged(value);
            },
            decoration: const InputDecoration(labelText: 'نوع الوثيقة واللغة'),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: scriptMode,
            items: const [
              DropdownMenuItem(
                  value: 'مطبوع وخط يد', child: Text('مطبوع وخط يد')),
              DropdownMenuItem(value: 'خط عثماني', child: Text('خط عثماني')),
              DropdownMenuItem(
                  value: 'خط إنجليزي يدوي', child: Text('خط إنجليزي يدوي')),
              DropdownMenuItem(
                  value: 'مختلط/أختام/هوامش', child: Text('مختلط/أختام/هوامش')),
            ],
            onChanged: (value) {
              if (value != null) onScriptChanged(value);
            },
            decoration: const InputDecoration(labelText: 'نمط الخط أو التمثيل'),
          ),
          const SizedBox(height: 16),
          _KeyValue(label: 'اللغة', value: profile.language),
          _KeyValue(label: 'الخط', value: profile.script),
          _KeyValue(label: 'الحقبة', value: profile.sourcePeriod),
          _KeyValue(label: 'الصعوبة', value: profile.readingDifficulty),
          _KeyValue(label: 'المجال المصطلحي', value: profile.terminologyDomain),
        ],
      ),
    );
  }
}

class _ImageSelectionPanel extends StatelessWidget {
  const _ImageSelectionPanel({
    required this.sourceRegionController,
    required this.onSimulateDraft,
  });

  final TextEditingController sourceRegionController;
  final VoidCallback onSimulateDraft;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      title: 'اختيار صورة الوثيقة وتقسيم المناطق',
      subtitle:
          'DOCUMENT_READING_IMAGE_SELECTION_PANEL + NO_FILE_UPLOAD_BACKEND_IN_WORKBENCH: تمثيل محلي فقط دون رفع فعلي.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 260,
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFFF4E5BF),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0xFFC79A35)),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white.withValues(alpha: 0.45),
                    ),
                  ),
                ),
                const Positioned(
                  top: 18,
                  right: 18,
                  child: Text('صورة وثيقة تجريبية',
                      style: TextStyle(fontWeight: FontWeight.w900)),
                ),
                const Positioned(
                  top: 58,
                  right: 28,
                  left: 28,
                  child: Divider(thickness: 5, color: Color(0xFFD4C39B)),
                ),
                const Positioned(
                  top: 88,
                  right: 48,
                  left: 36,
                  child: Divider(thickness: 4, color: Color(0xFFD4C39B)),
                ),
                Positioned(
                  bottom: 22,
                  left: 24,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF7F271C),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text('منطقة ختم / هامش',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: sourceRegionController,
            decoration: const InputDecoration(
              labelText: 'تعريف منطقة الصورة المرتبطة بالنص',
              prefixIcon: Icon(Icons.crop_free_outlined),
            ),
          ),
          const SizedBox(height: 14),
          OutlinedButton.icon(
            onPressed: onSimulateDraft,
            icon: const Icon(Icons.add_photo_alternate_outlined),
            label: const Text('استخدام صورة تجريبية وإنشاء قراءة أولية'),
          ),
        ],
      ),
    );
  }
}

class _ComparisonWorkbenchPanel extends StatelessWidget {
  const _ComparisonWorkbenchPanel({
    required this.draftReadingController,
    required this.arabicTranslationController,
    required this.sourceRegionController,
  });

  final TextEditingController draftReadingController;
  final TextEditingController arabicTranslationController;
  final TextEditingController sourceRegionController;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      title: 'مقارنة الصورة بالنص والترجمة',
      subtitle:
          'SOURCE_IMAGE_TEXT_COMPARISON_WORKBENCH + READING_LAYER_MANUAL_DRAFT_EDITOR + ARABIC_TRANSLATION_DRAFT_EDITOR.',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 900;
          final region = _EditableBox(
            title: 'منطقة الصورة',
            controller: sourceRegionController,
            maxLines: 8,
          );
          final draft = _EditableBox(
            title: 'تفريغ/قراءة أولية',
            controller: draftReadingController,
            maxLines: 8,
          );
          final translation = _EditableBox(
            title: 'ترجمة عربية مسودة',
            controller: arabicTranslationController,
            maxLines: 8,
          );
          if (!wide) {
            return Column(children: [
              region,
              const SizedBox(height: 12),
              draft,
              const SizedBox(height: 12),
              translation
            ]);
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: region),
              const SizedBox(width: 12),
              Expanded(child: draft),
              const SizedBox(width: 12),
              Expanded(child: translation),
            ],
          );
        },
      ),
    );
  }
}

class _GlossaryBuilderPanel extends StatelessWidget {
  const _GlossaryBuilderPanel({
    required this.terms,
    required this.termController,
    required this.equivalentController,
    required this.onAdd,
  });

  final List<HistoricalTerm> terms;
  final TextEditingController termController;
  final TextEditingController equivalentController;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      title: 'قاموس المصطلحات العثمانية والإنجليزية',
      subtitle:
          'OTTOMAN_GLOSSARY_INTERACTIVE_BUILDER: كل مصطلح يحتاج مراجعة قاموس قبل الاعتماد.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth >= 720;
              final termField = TextField(
                controller: termController,
                decoration: const InputDecoration(labelText: 'المصطلح الأصلي'),
              );
              final equivalentField = TextField(
                controller: equivalentController,
                decoration:
                    const InputDecoration(labelText: 'المقابل أو الشرح العربي'),
              );
              if (!wide) {
                return Column(children: [
                  termField,
                  const SizedBox(height: 10),
                  equivalentField
                ]);
              }
              return Row(
                children: [
                  Expanded(child: termField),
                  const SizedBox(width: 12),
                  Expanded(child: equivalentField),
                ],
              );
            },
          ),
          const SizedBox(height: 10),
          FilledButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.playlist_add_outlined),
            label: const Text('إضافة مصطلح للقاموس المحلي'),
          ),
          const SizedBox(height: 16),
          ...terms.take(6).map((term) => _TermTile(term: term)),
        ],
      ),
    );
  }
}

class _ReviewerDecisionPanel extends StatelessWidget {
  const _ReviewerDecisionPanel({
    required this.confidence,
    required this.readingStatus,
    required this.reviewerNoteController,
    required this.onConfidenceChanged,
    required this.onStatusChanged,
  });

  final double confidence;
  final String readingStatus;
  final TextEditingController reviewerNoteController;
  final ValueChanged<double> onConfidenceChanged;
  final ValueChanged<String> onStatusChanged;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      title: 'قرار المراجع والثقة',
      subtitle:
          'REVIEWER_DECISION_AND_CONFIDENCE_PANEL: لا يصبح النص authoritative قبل الاعتماد البشري.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonFormField<String>(
            value: readingStatus,
            items: const [
              DropdownMenuItem(
                  value: 'مسودة تحتاج مراجعة',
                  child: Text('مسودة تحتاج مراجعة')),
              DropdownMenuItem(
                  value: 'مسودة مولدة محليًا — تحتاج اعتماد محقق',
                  child: Text('مسودة مولدة محليًا — تحتاج اعتماد محقق')),
              DropdownMenuItem(
                  value: 'راجعت المصطلحات — بانتظار تدقيق الصورة',
                  child: Text('راجعت المصطلحات — بانتظار تدقيق الصورة')),
              DropdownMenuItem(
                  value: 'معتمد داخليًا — غير منشور',
                  child: Text('معتمد داخليًا — غير منشور')),
            ],
            onChanged: (value) {
              if (value != null) onStatusChanged(value);
            },
            decoration: const InputDecoration(labelText: 'حالة القراءة'),
          ),
          const SizedBox(height: 18),
          Text('ثقة القراءة: ${(confidence * 100).round()}%'),
          Slider(value: confidence, onChanged: onConfidenceChanged),
          TextField(
            controller: reviewerNoteController,
            minLines: 5,
            maxLines: 8,
            decoration: const InputDecoration(
              labelText: 'ملاحظات المحقق',
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'HUMAN_APPROVAL_REQUIRED_FOR_WORKBENCH_TEXT — DRAFT_ONLY_INTERACTIVE_READING_OUTPUT',
            style: TextStyle(
                fontWeight: FontWeight.w800, color: Color(0xFF7F271C)),
          ),
        ],
      ),
    );
  }
}

class _PipelinePanel extends StatelessWidget {
  const _PipelinePanel({required this.layers});

  final List<ReadingLayer> layers;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      title: 'طبقات القراءة والترجمة — ReadingLayer',
      subtitle:
          'OCR_HTR_TRANSLATION_LAYER_PIPELINE مع ثقة على مستوى الكلمة/السطر/الفقرة.',
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: layers.map((layer) => _LayerCard(layer: layer)).toList(),
      ),
    );
  }
}

class _BoundaryPanel extends StatelessWidget {
  const _BoundaryPanel({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFCF4),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE0C47E)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('حدود التشغيل الحالية',
              style: theme.textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.w900)),
          const SizedBox(height: 10),
          const Text(
            'NO_REAL_OCR_ENGINE_IN_WORKBENCH — لا يوجد OCR حقيقي داخل هذه الدفعة.\n'
            'NO_REAL_HTR_ENGINE_IN_WORKBENCH — لا يوجد تعرف حقيقي على خط اليد بعد.\n'
            'NO_REAL_TRANSLATION_ENGINE_IN_WORKBENCH — لا توجد ترجمة آلية خارجية أو نموذج متصل.\n'
            'NO_FILE_UPLOAD_BACKEND_IN_WORKBENCH — لا رفع ملفات فعلي ولا قاعدة بيانات.\n'
            'ARABIC_VERIFIED_TEXT_OUTPUT — النص العربي الدقيق لا يعتمد إلا بعد مراجعة بشرية.',
            style: TextStyle(height: 1.8, color: Color(0xFF073F31)),
          ),
        ],
      ),
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel(
      {required this.title, required this.subtitle, required this.child});

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE8DEC9)),
        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            offset: const Offset(0, 8),
            color: Colors.black.withValues(alpha: 0.05),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: theme.textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.w900)),
          const SizedBox(height: 6),
          Text(subtitle,
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: const Color(0xFF5F6F67))),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _EditableBox extends StatelessWidget {
  const _EditableBox(
      {required this.title, required this.controller, required this.maxLines});

  final String title;
  final TextEditingController controller;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
      ],
    );
  }
}

class _KeyValue extends StatelessWidget {
  const _KeyValue({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              width: 120,
              child: Text(label,
                  style: const TextStyle(fontWeight: FontWeight.w800))),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

class _TermTile extends StatelessWidget {
  const _TermTile({required this.term});

  final HistoricalTerm term;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0C47E)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(term.sourceTerm,
              style: const TextStyle(fontWeight: FontWeight.w900)),
          const SizedBox(height: 4),
          Text(term.arabicEquivalent),
          const SizedBox(height: 4),
          Text('${term.language} — ${term.domain}',
              style: const TextStyle(color: Color(0xFF5F6F67))),
          const SizedBox(height: 4),
          Text(term.reviewNote,
              style: const TextStyle(color: Color(0xFF7F271C))),
        ],
      ),
    );
  }
}

class _LayerCard extends StatelessWidget {
  const _LayerCard({required this.layer});

  final ReadingLayer layer;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 320),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F4E9),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE8DEC9)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(layer.title,
                style: const TextStyle(fontWeight: FontWeight.w900)),
            const SizedBox(height: 8),
            Text(layer.engineRole,
                style: const TextStyle(
                    color: Color(0xFF0B6F54), fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Text(layer.draftText),
            const SizedBox(height: 8),
            Text(layer.arabicOutput),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                Chip(label: Text(layer.confidence)),
                Chip(label: Text(layer.reviewerStatus)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// DOCUMENT_READING_WORKBENCH_DROPDOWN_INITIAL_VALUE_CLEANUP
