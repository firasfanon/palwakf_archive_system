import 'package:flutter/material.dart';

// OTTOMAN_ENGLISH_DOCUMENT_READING_TRANSLATION_ASSISTANT_FOUNDATION:
// Foundational internal assistant for reading, transcribing, translating, and
// reviewing Ottoman and English archive documents as draft-only archival layers.
// AI_READING_OUTPUT_DRAFT_ONLY
// HUMAN_REVIEW_REQUIRED_FOR_HISTORICAL_TRANSLATION
// NO_REAL_OCR_ENGINE_IN_FOUNDATION
// NO_REAL_TRANSLATION_ENGINE_IN_FOUNDATION
// NO_PUBLICATION_FROM_DOCUMENT_READING_ASSISTANT

class OttomanEnglishDocumentAssistantScreen extends StatelessWidget {
  const OttomanEnglishDocumentAssistantScreen({super.key});

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

  static const _layers = <ReadingLayer>[
    ReadingLayer(
      title: 'الصورة الأصلية وتقسيم المناطق',
      engineRole: 'منطقة صورة ← سطر ← كلمة',
      draftText: 'Region A / seal / margin / handwritten note',
      arabicOutput: 'تحديد مواضع الختم والهامش والسطر قبل أي قراءة نصية.',
      confidence: 'ثقة مكانية: 82%',
      reviewerStatus: 'بحاجة ضبط يدوي',
    ),
    ReadingLayer(
      title: 'OCR / HTR أولي',
      engineRole: 'Printed OCR + Handwritten Text Recognition',
      draftText: 'وقف / طابو / tapu / endowment / parcel',
      arabicOutput: 'تفريغ أولي غير معتمد، لا يصلح للنشر.',
      confidence: 'ثقة كلمة/سطر: 61%',
      reviewerStatus: 'مراجعة محقق لازمة',
    ),
    ReadingLayer(
      title: 'قراءة عثمانية محافظة',
      engineRole: 'Ottoman word recognition + glossary review',
      draftText: 'حكر، عشر، مقاطعة، ويركو، دفتر خانة',
      arabicOutput: 'قراءة المصطلح كما هو ثم شرحه قبل ترجمته أو تطبيعه.',
      confidence: 'ثقة مصطلحية: 55%',
      reviewerStatus: 'يعتمد بعد مراجعة قاموس المصطلحات',
    ),
    ReadingLayer(
      title: 'ترجمة عربية دقيقة',
      engineRole: 'Historical translation with legal terminology control',
      draftText: 'The land parcel is registered as an endowment holding.',
      arabicOutput: 'القطعة مسجلة بوصفها حيازة/ملك منفعة وقفي بحسب سياق السجل.',
      confidence: 'ثقة ترجمة: 70%',
      reviewerStatus: 'اعتماد بشري قبل الإتاحة',
    ),
  ];

  static const _terms = <HistoricalTerm>[
    HistoricalTerm(
      sourceTerm: 'ويركو / Verko',
      language: 'عثمانية / تركية عثمانية',
      arabicEquivalent: 'ضريبة/تخمين مالي مرتبط بالسجل',
      domain: 'ضرائب وأراضي',
      reviewNote: 'لا يترجم حرفيًا؛ يربط بسياق التخمين والاحتساب.',
    ),
    HistoricalTerm(
      sourceTerm: 'Tapu / طابو',
      language: 'عثمانية / إنجليزية إدارية',
      arabicEquivalent: 'سجل ملكية/تصرف أرضي',
      domain: 'أراضي وتسجيل',
      reviewNote: 'قد يشير إلى السجل أو سند التسجيل حسب الوثيقة.',
    ),
    HistoricalTerm(
      sourceTerm: 'Endowment',
      language: 'English',
      arabicEquivalent: 'وقف',
      domain: 'وقف وقانون',
      reviewNote:
          'يفرق بين charitable endowment وreligious endowment بحسب السياق.',
    ),
    HistoricalTerm(
      sourceTerm: 'مقاطعة / حكر / عشر',
      language: 'عثمانية / عربية قانونية',
      arabicEquivalent: 'مصطلحات مالية/وقفية يجب شرحها لا تطبيعها فقط',
      domain: 'وقف ومالية تاريخية',
      reviewNote: 'OTTOMAN_TERMS_REQUIRE_GLOSSARY_REVIEW',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const archiveGreen = Color(0xFF073F31);
    const manuscript = Color(0xFF2B2118);
    const paper = Color(0xFFFFFCF4);
    const gold = Color(0xFFC79A35);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _HeroPanel(theme: theme),
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
                  label: 'مسودة فقط', marker: 'AI_READING_OUTPUT_DRAFT_ONLY'),
              _StatusChip(
                  label: 'لا نشر قبل الاعتماد',
                  marker: 'HUMAN_REVIEW_REQUIRED_FOR_HISTORICAL_TRANSLATION'),
            ],
          ),
          const SizedBox(height: 22),
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 960;
              final profileGrid = _ProfilesPanel(profiles: _profiles);
              final pipeline = _PipelinePanel(layers: _layers);
              if (!isWide) {
                return Column(
                  children: [profileGrid, const SizedBox(height: 16), pipeline],
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: profileGrid),
                  const SizedBox(width: 16),
                  Expanded(child: pipeline),
                ],
              );
            },
          ),
          const SizedBox(height: 22),
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 980;
              final glossary = _GlossaryPanel(terms: _terms);
              final review = const _ReviewControlPanel();
              if (!isWide) {
                return Column(
                  children: [glossary, const SizedBox(height: 16), review],
                );
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
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: paper,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: gold.withValues(alpha: 0.30)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('حدود التشغيل الحالية',
                    style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w900, color: manuscript)),
                const SizedBox(height: 10),
                const Text(
                  'NO_REAL_OCR_ENGINE_IN_FOUNDATION — هذه الصفحة تؤسس الواجهة والعقود والطبقات فقط، ولا تشغل OCR/HTR حقيقيًا بعد.\n'
                  'NO_REAL_TRANSLATION_ENGINE_IN_FOUNDATION — لا توجد ترجمة آلية خارجية أو نموذج متصل بعد.\n'
                  'ARABIC_VERIFIED_TEXT_OUTPUT — النص العربي الدقيق يصبح authoritative فقط بعد مراجعة بشرية.\n'
                  'SOURCE_IMAGE_TEXT_ALIGNMENT — كل نص يجب أن يبقى مرتبطًا بمنطقة الصورة والسطر والكلمة.',
                  style: TextStyle(height: 1.7, color: archiveGreen),
                ),
              ],
            ),
          ),
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
  const _HeroPanel({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xFF073F31), Color(0xFF0E6A4D), Color(0xFF2B2118)],
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 26,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 760;
          final heroText = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'مساعد قراءة الوثائق العثمانية والإنجليزية',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 30,
                    height: 1.25),
              ),
              const SizedBox(height: 10),
              Text(
                'طبقة تأسيسية لقراءة الوثيقة من الصورة إلى التفريغ والترجمة العربية المحققة، مع قاموس مصطلحات وثقة ومراجعة بشرية قبل أي نشر.',
                style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.86), height: 1.7),
              ),
            ],
          );
          final pipelineCard = Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withValues(alpha: 0.20)),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _PipelineStep('صورة الوثيقة', 'SOURCE_IMAGE_TEXT_ALIGNMENT'),
                _PipelineStep(
                    'OCR / HTR', 'OCR_HTR_TRANSLATION_LAYER_PIPELINE'),
                _PipelineStep('قراءة عثمانية / إنجليزية',
                    'OTTOMAN_WORD_RECOGNITION_GLOSSARY'),
                _PipelineStep('نص عربي محقق', 'ARABIC_VERIFIED_TEXT_OUTPUT'),
              ],
            ),
          );
          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                heroText,
                const SizedBox(height: 18),
                pipelineCard,
              ],
            );
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 3, child: heroText),
              const SizedBox(width: 24),
              Expanded(flex: 2, child: pipelineCard),
            ],
          );
        },
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
      ),
    );
  }
}

class _PipelineStep extends StatelessWidget {
  const _PipelineStep(this.label, this.marker);

  final String label;
  final String marker;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          const Icon(Icons.arrow_circle_left_outlined,
              color: Color(0xFFC79A35)),
          const SizedBox(width: 8),
          Expanded(
            child: Text('$label — $marker',
                style: const TextStyle(color: Colors.white, height: 1.45)),
          ),
        ],
      ),
    );
  }
}

class _ProfilesPanel extends StatelessWidget {
  const _ProfilesPanel({required this.profiles});

  final List<DocumentReadingProfile> profiles;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      title: 'DocumentReadingProfile — بروفايلات القراءة',
      subtitle: 'تحديد اللغة والخط والحقبة والصعوبة قبل إنشاء طبقات القراءة.',
      children: [
        for (final profile in profiles) _ProfileCard(profile: profile),
      ],
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.profile});

  final DocumentReadingProfile profile;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(profile.icon, color: const Color(0xFF073F31)),
                const SizedBox(width: 8),
                Expanded(
                    child: Text(profile.title,
                        style: const TextStyle(fontWeight: FontWeight.w900))),
              ],
            ),
            const SizedBox(height: 8),
            Text('اللغة: ${profile.language}'),
            Text('الخط: ${profile.script}'),
            Text('الحقبة: ${profile.sourcePeriod}'),
            Text('الصعوبة: ${profile.readingDifficulty}'),
            Text('المجال المصطلحي: ${profile.terminologyDomain}'),
          ],
        ),
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
      title: 'ReadingLayer — طبقات القراءة والترجمة',
      subtitle:
          'READING_CONFIDENCE_BY_WORD_LINE_PARAGRAPH — الثقة تحفظ على مستوى الكلمة/السطر/الفقرة.',
      children: [
        for (final layer in layers) _LayerCard(layer: layer),
      ],
    );
  }
}

class _LayerCard extends StatelessWidget {
  const _LayerCard({required this.layer});

  final ReadingLayer layer;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(layer.title,
                style: const TextStyle(fontWeight: FontWeight.w900)),
            const SizedBox(height: 6),
            Text(layer.engineRole),
            const SizedBox(height: 6),
            Text('Draft: ${layer.draftText}'),
            Text('العربية: ${layer.arabicOutput}'),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 8,
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

class _GlossaryPanel extends StatelessWidget {
  const _GlossaryPanel({required this.terms});

  final List<HistoricalTerm> terms;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      title: 'HistoricalTerm — قاموس المصطلحات التاريخية',
      subtitle:
          'OTTOMAN_WORD_RECOGNITION_GLOSSARY — لا يطبّع المصطلح قبل مراجعته في القاموس.',
      children: [
        for (final term in terms)
          Card(
            child: ListTile(
              leading: const Icon(Icons.menu_book_outlined,
                  color: Color(0xFF073F31)),
              title: Text(term.sourceTerm),
              subtitle: Text(
                  '${term.language} • ${term.domain}\n${term.arabicEquivalent}\n${term.reviewNote}'),
              isThreeLine: true,
            ),
          ),
      ],
    );
  }
}

class _ReviewControlPanel extends StatelessWidget {
  const _ReviewControlPanel();

  @override
  Widget build(BuildContext context) {
    return _Panel(
      title: 'اعتماد القراءة والترجمة',
      subtitle: 'النص العربي الدقيق لا يصبح مرجعًا إلا بعد قرار بشري.',
      children: const [
        _DecisionRow('قبول التفريغ العثماني', 'مسودة داخلية فقط'),
        _DecisionRow('إرجاع قراءة كلمة مشكوك بها', 'مراجعة قاموس'),
        _DecisionRow('اعتماد الترجمة العربية', 'ينشئ نصًا محققًا داخليًا'),
        _DecisionRow(
            'منع النشر', 'TRANSLATION_IS_NOT_PUBLISHED_WITHOUT_APPROVAL'),
      ],
    );
  }
}

class _DecisionRow extends StatelessWidget {
  const _DecisionRow(this.title, this.status);

  final String title;
  final String status;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading:
            const Icon(Icons.fact_check_outlined, color: Color(0xFFC79A35)),
        title: Text(title),
        subtitle: Text(status),
      ),
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel(
      {required this.title, required this.subtitle, required this.children});

  final String title;
  final String subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border:
            Border.all(color: const Color(0xFFC79A35).withValues(alpha: 0.22)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.w900)),
          const SizedBox(height: 6),
          Text(subtitle,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(height: 1.5)),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }
}
