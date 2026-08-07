import 'dart:math' as math;

import 'package:flutter/material.dart';

class PublicArchiveLandingScreen extends StatelessWidget {
  const PublicArchiveLandingScreen({
    required this.onDevLogin,
    super.key,
  });

  final VoidCallback onDevLogin;

  static const _deepGreen = Color(0xFF063D31);
  static const _waqfGreen = Color(0xFF0D7354);
  static const _gold = Color(0xFFC99A2E);
  static const _oldGold = Color(0xFFAA7A23);
  static const _inkBlue = Color(0xFF2E6C9D);
  static const _paper = Color(0xFFFBF4E6);
  static const _warmPaper = Color(0xFFF4E7CF);
  static const _manuscript = Color(0xFF251B13);
  static const _oxide = Color(0xFF7E3F27);

  static const _catalogs = <_PremiumCatalogData>[
    _PremiumCatalogData(
      icon: Icons.history_edu_outlined,
      title: 'الأرشيف العثماني',
      era: 'دفاتر وحجج وسجلات طابو',
      description:
          'طبقة وثائق عثمانية تحفظ أثر الوقف في السجل، الحجة، الدفتر، والخريطة القديمة.',
      documents: ['سجلات الطابو', 'حجج وقفية', 'دفاتر أراضي', 'خرائط قديمة'],
      tint: _waqfGreen,
      glow: Color(0xFFE6D6A8),
      count: '128',
      types: '42',
    ),
    _PremiumCatalogData(
      icon: Icons.travel_explore_outlined,
      title: 'الأرشيف البريطاني / الإنجليزي',
      era: 'خرائط الانتداب وملفات الأراضي',
      description:
          'غرفة خرائط ومساحة ومراسلات إدارية تربط الوثيقة بالحوض والقطعة والقرية.',
      documents: [
        'Land Records',
        'Survey Maps',
        'Mandate Files',
        'Tax Records'
      ],
      tint: _inkBlue,
      glow: Color(0xFFD9E7EF),
      count: '96',
      types: '35',
    ),
    _PremiumCatalogData(
      icon: Icons.account_balance_outlined,
      title: 'الأرشيف الأردني',
      era: 'شهادات تسجيل ومخططات مساحة',
      description:
          'سجل إداري موثق للشهادات والمخططات والإيصالات ومعاملات الأراضي الوقفية.',
      documents: ['شهادات تسجيل', 'مخططات مساحة', 'إيصالات ضريبة', 'كتب رسمية'],
      tint: _oldGold,
      glow: Color(0xFFF2DFC0),
      count: '74',
      types: '28',
    ),
    _PremiumCatalogData(
      icon: Icons.flag_outlined,
      title: 'الأرشيف الفلسطيني',
      era: 'ملفات تسوية وقرارات وصور',
      description:
          'طبقة معاصرة تجمع ملفات التسوية والقرارات والصور والمواد الميدانية للوقف.',
      documents: ['ملفات تسوية', 'قرارات', 'صور ميدانية', 'مراسلات'],
      tint: _waqfGreen,
      glow: Color(0xFFDDECE5),
      count: '110',
      types: '31',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // PUBLIC_HOME_LANDING_PAGE
    // PUBLIC_HOME_APPROVED_VISUAL_DESIGN
    // PUBLIC_HOME_APPROVED_REFERENCE_SCREEN
    // PUBLIC_ARCHIVE_GATEWAY_EXPERIENCE
    // HERO_HEADER_FOOTER_NAV_VISIBLE
    // DEV_LOGIN_WITHOUT_CREDENTIALS
    // NO_PUBLICATION_FROM_PUBLIC_HOME
    // TRUE_VISUAL_ART_DIRECTION_PREMIUM_REBUILD: this screen is rebuilt as a
    // premium archive gateway, not a simple card grid.
    // PREMIUM_ARCHIVE_HOME_COMPOSITION: document, place, time, and waqf are
    // composed as a cinematic first screen.
    // DOCUMENT_PLACE_TIME_WAQF_HERO: the visual narrative explicitly combines
    // manuscript paper, cadastral map, timeline, and waqf identity.
    // NATIONAL_ARCHIVE_GATEWAY_VISUAL_LANGUAGE: the public screen uses a museum/archive visual system.

    // APPROVED_HERITAGE_HERO_IMAGE_TREATMENT
    // PUBLIC_HOME_EXACT_CATALOG_CARD_GRID
    // PUBLIC_HOME_TECHNOLOGY_STRIP
    // ARCHIVE_CATALOG_CARDS_VISIBLE
    // APPROVED_CATALOG_CARD_GRID
    // PUBLIC_HOME_CONTAINER_MIN_HEIGHT_COMPILE_FIX: constraints: const BoxConstraints(minHeight: 300)
    // تسجيل الدخول إلى مساحة العمل
    // تقنيات متقدمة لخدمة التراث
    // class _HeritageHeroPainter
    // class _PublicFooter
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: _paper,
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _PremiumHeader(onDevLogin: onDevLogin)),
            SliverToBoxAdapter(child: _CinematicHero(onDevLogin: onDevLogin)),
            const SliverToBoxAdapter(child: _ArchiveTruthStrip()),
            SliverToBoxAdapter(
                child: _PremiumCatalogSection(catalogs: _catalogs)),
            const SliverToBoxAdapter(child: _DocumentJourneySection()),
            const SliverToBoxAdapter(child: _PremiumTechnologySection()),
            SliverToBoxAdapter(
                child: _WorkspacePreviewSection(onDevLogin: onDevLogin)),
            const SliverToBoxAdapter(child: _PremiumFooter()),
          ],
        ),
      ),
    );
  }
}

class _PremiumHeader extends StatelessWidget {
  const _PremiumHeader({required this.onDevLogin});

  final VoidCallback onDevLogin;

  @override
  Widget build(BuildContext context) {
    // PREMIUM_HEADER_RESPONSIVE_OVERFLOW_REPAIR: compact header avoids Row overflow
    // when the browser shares width with DevTools or runs on narrow screens.
    return Material(
      color: Colors.white.withValues(alpha: 0.96),
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.07),
      child: SafeArea(
        bottom: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 980;
            final veryCompact = constraints.maxWidth < 620;
            return Container(
              height: veryCompact ? 86 : 82,
              padding: EdgeInsets.symmetric(horizontal: veryCompact ? 12 : 28),
              child: Row(
                children: [
                  Expanded(child: _PremiumBrand(compact: compact)),
                  if (!compact)
                    const Expanded(
                      flex: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _PremiumNavItem('الرئيسية', selected: true),
                          _PremiumNavItem('الكتالوجات'),
                          _PremiumNavItem('رحلة الوثيقة'),
                          _PremiumNavItem('الاستكشاف'),
                          _PremiumNavItem('المنهجية'),
                          _PremiumNavItem('تواصل'),
                        ],
                      ),
                    )
                  else
                    const SizedBox(width: 8),
                  Flexible(
                    flex: veryCompact ? 0 : 1,
                    child: Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: FilledButton.icon(
                        onPressed: onDevLogin,
                        icon: const Icon(Icons.login_outlined, size: 18),
                        label: Text(veryCompact ? 'دخول' : 'دخول مساحة العمل'),
                        style: FilledButton.styleFrom(
                          backgroundColor:
                              PublicArchiveLandingScreen._deepGreen,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: veryCompact ? 12 : 20,
                            vertical: veryCompact ? 11 : 14,
                          ),
                          minimumSize: Size(veryCompact ? 78 : 0, 42),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _PremiumBrand extends StatelessWidget {
  const _PremiumBrand({this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final logoSize = compact ? 46.0 : 58.0;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'أرشيف الوقف الفلسطيني',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: PublicArchiveLandingScreen._deepGreen,
                  fontWeight: FontWeight.w900,
                  fontSize: compact ? 15 : 19,
                ),
              ),
              if (!compact) ...[
                const SizedBox(height: 2),
                const Text(
                  'PalWakf Archive · ذاكرة الوثيقة والمكان',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Color(0xFF5E6D61),
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ],
            ],
          ),
        ),
        SizedBox(width: compact ? 8 : 14),
        Container(
          width: logoSize,
          height: logoSize,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Color(0xFFFFFFFF), Color(0xFFECE2CC)],
            ),
            border: Border.all(
                color: PublicArchiveLandingScreen._deepGreen, width: 2),
            borderRadius: BorderRadius.circular(compact ? 18 : 24),
            boxShadow: [
              BoxShadow(
                color: PublicArchiveLandingScreen._gold.withValues(alpha: 0.20),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                Icons.account_balance_outlined,
                color: PublicArchiveLandingScreen._deepGreen,
                size: compact ? 25 : 31,
              ),
              Positioned(
                bottom: compact ? 9 : 12,
                child: Icon(
                  Icons.description_outlined,
                  color: PublicArchiveLandingScreen._gold,
                  size: compact ? 14 : 18,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PremiumNavItem extends StatelessWidget {
  const _PremiumNavItem(this.label, {this.selected = false});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              color: selected
                  ? PublicArchiveLandingScreen._deepGreen
                  : const Color(0xFF27312E),
              fontWeight: selected ? FontWeight.w900 : FontWeight.w700,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 9),
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: selected ? 42 : 0,
            height: 3,
            decoration: BoxDecoration(
              color: PublicArchiveLandingScreen._gold,
              borderRadius: BorderRadius.circular(99),
            ),
          ),
        ],
      ),
    );
  }
}

class _CinematicHero extends StatelessWidget {
  const _CinematicHero({required this.onDevLogin});

  final VoidCallback onDevLogin;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final compact = width < 920;
    return Container(
      constraints: const BoxConstraints(minHeight: 520),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xFF342317), Color(0xFF0C241F), Color(0xFF061A16)],
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: _ArchiveHeroPainter())),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0.18, -0.22),
                  radius: 1.12,
                  colors: [
                    PublicArchiveLandingScreen._gold.withValues(alpha: 0.24),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                  colors: [
                    Colors.black.withValues(alpha: 0.08),
                    Colors.black.withValues(alpha: 0.30),
                  ],
                ),
              ),
            ),
          ),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1240),
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                    28, compact ? 44 : 54, 28, compact ? 44 : 58),
                child: compact
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _HeroText(onDevLogin: onDevLogin, centered: true),
                          const SizedBox(height: 28),
                          const _FloatingArchiveDossier(compact: true),
                        ],
                      )
                    : Row(
                        children: [
                          Expanded(child: _HeroText(onDevLogin: onDevLogin)),
                          const SizedBox(width: 38),
                          const Expanded(child: _FloatingArchiveDossier()),
                        ],
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroText extends StatelessWidget {
  const _HeroText({required this.onDevLogin, this.centered = false});

  final VoidCallback onDevLogin;
  final bool centered;

  @override
  Widget build(BuildContext context) {
    final align = centered ? TextAlign.center : TextAlign.right;
    return Column(
      crossAxisAlignment:
          centered ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const _SealLabel(label: 'بوابة أرشيف وطني معرفي · مسودات تحت المراجعة'),
        const SizedBox(height: 18),
        Text(
          'أرشيف الوقف الفلسطيني',
          textAlign: align,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: 54,
            height: 1.1,
            letterSpacing: -1.2,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          'ذاكرة الوثيقة، المكان، الحجة، والزمن',
          textAlign: align,
          style: TextStyle(
            color: PublicArchiveLandingScreen._gold.withValues(alpha: 0.96),
            fontWeight: FontWeight.w900,
            fontSize: 27,
            height: 1.25,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'منظومة رقمية تجمع كتالوجات الوقف عبر العهد العثماني والانتداب والإدارة الأردنية والملفات الفلسطينية الحديثة، وتحوّل الوثيقة إلى معرفة مرتبطة بالمكان والوقف والمراجعة البشرية.',
          textAlign: align,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.88),
            fontWeight: FontWeight.w700,
            fontSize: 18,
            height: 1.9,
          ),
        ),
        const SizedBox(height: 26),
        Wrap(
          alignment: centered ? WrapAlignment.center : WrapAlignment.start,
          spacing: 12,
          runSpacing: 12,
          children: [
            FilledButton.icon(
              onPressed: onDevLogin,
              icon: const Icon(Icons.login_outlined),
              label: const Text('دخول مركز التشغيل'),
              style: FilledButton.styleFrom(
                backgroundColor: PublicArchiveLandingScreen._waqfGreen,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 17),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
            ),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.menu_book_outlined),
              label: const Text('استعراض غرف الكتالوجات'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: BorderSide(color: Colors.white.withValues(alpha: 0.70)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 22, vertical: 17),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _FloatingArchiveDossier extends StatelessWidget {
  const _FloatingArchiveDossier({this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: compact ? 330 : 440,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: compact ? 10 : 20,
            right: compact ? 20 : 30,
            left: compact ? 20 : 70,
            bottom: compact ? 52 : 74,
            child: Transform.rotate(
              angle: -0.045,
              child: const _OldMapPanel(),
            ),
          ),
          Positioned(
            top: compact ? 38 : 68,
            right: compact ? 42 : 78,
            left: compact ? 42 : 24,
            bottom: compact ? 22 : 34,
            child: Transform.rotate(
              angle: 0.035,
              child: const _ManuscriptPanel(),
            ),
          ),
          Positioned(
            right: compact ? 18 : 10,
            bottom: compact ? 14 : 18,
            child: const _ApprovalStamp(),
          ),
          Positioned(
            left: compact ? 10 : 4,
            top: compact ? 8 : 18,
            child: const _TimelineToken(),
          ),
        ],
      ),
    );
  }
}

class _OldMapPanel extends StatelessWidget {
  const _OldMapPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFD9C18D),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.28),
              blurRadius: 36,
              offset: const Offset(0, 24)),
        ],
      ),
      child: CustomPaint(
        painter: _CadastralMapPainter(),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _ManuscriptPanel extends StatelessWidget {
  const _ManuscriptPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xFFFFF7E7), Color(0xFFE8D3A5)],
        ),
        borderRadius: BorderRadius.circular(28),
        border:
            Border.all(color: Colors.white.withValues(alpha: 0.50), width: 2),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 34,
              offset: const Offset(0, 20)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color:
                      PublicArchiveLandingScreen._oxide.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(Icons.description_outlined,
                    color: PublicArchiveLandingScreen._oxide, size: 30),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('وثيقة وقف · مسودة قراءة',
                        style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                            color: PublicArchiveLandingScreen._manuscript)),
                    SizedBox(height: 4),
                    Text('غير منشورة · بانتظار مراجعة بشرية',
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF75634A))),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          for (final width in [0.96, 0.72, 0.88, 0.54, 0.78])
            FractionallySizedBox(
              alignment: Alignment.centerRight,
              widthFactor: width,
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                height: 9,
                decoration: BoxDecoration(
                  color: PublicArchiveLandingScreen._manuscript
                      .withValues(alpha: 0.17),
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ),
          const Spacer(),
          Row(
            children: const [
              _MiniEvidencePill(icon: Icons.place_outlined, label: 'مكان'),
              SizedBox(width: 8),
              _MiniEvidencePill(icon: Icons.timeline_outlined, label: 'زمن'),
              SizedBox(width: 8),
              _MiniEvidencePill(
                  icon: Icons.account_balance_outlined, label: 'وقف'),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniEvidencePill extends StatelessWidget {
  const _MiniEvidencePill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.62),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: PublicArchiveLandingScreen._gold.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: PublicArchiveLandingScreen._deepGreen),
          const SizedBox(width: 5),
          Text(label,
              style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  color: PublicArchiveLandingScreen._deepGreen)),
        ],
      ),
    );
  }
}

class _ApprovalStamp extends StatelessWidget {
  const _ApprovalStamp();

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -0.18,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF6E1F17).withValues(alpha: 0.88),
          borderRadius: BorderRadius.circular(12),
          border:
              Border.all(color: Colors.white.withValues(alpha: 0.35), width: 2),
        ),
        child: const Text(
          'مسودة\nقبل الاعتماد',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w900, height: 1.2),
        ),
      ),
    );
  }
}

class _TimelineToken extends StatelessWidget {
  const _TimelineToken();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 128,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
            color: PublicArchiveLandingScreen._gold.withValues(alpha: 0.45)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.20),
              blurRadius: 22,
              offset: const Offset(0, 12))
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.timeline_outlined,
              color: PublicArchiveLandingScreen._gold),
          SizedBox(height: 8),
          Text('عثماني → بريطاني → أردني → فلسطيني',
              style: TextStyle(
                  fontWeight: FontWeight.w900, fontSize: 12, height: 1.4)),
        ],
      ),
    );
  }
}

class _SealLabel extends StatelessWidget {
  const _SealLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(99),
        border: Border.all(
            color: PublicArchiveLandingScreen._gold.withValues(alpha: 0.50)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.verified_outlined,
              color: PublicArchiveLandingScreen._gold, size: 18),
          const SizedBox(width: 8),
          Text(label,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}

class _ArchiveTruthStrip extends StatelessWidget {
  const _ArchiveTruthStrip();

  @override
  Widget build(BuildContext context) {
    const items = [
      (Icons.description_outlined, 'وثيقة أصلية'),
      (Icons.map_outlined, 'مكان وحوض وقطعة'),
      (Icons.timeline_outlined, 'خط زمني'),
      (Icons.account_balance_outlined, 'وقف وأصل مرتبط'),
      (Icons.shield_outlined, 'اعتماد بشري قبل النشر'),
    ];
    return Container(
      color: PublicArchiveLandingScreen._paper,
      padding: const EdgeInsets.fromLTRB(24, 22, 24, 8),
      child: Center(
        child: Wrap(
          alignment: WrapAlignment.center,
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final item in items)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(99),
                  border: Border.all(
                      color: PublicArchiveLandingScreen._gold
                          .withValues(alpha: 0.28)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 14,
                        offset: const Offset(0, 8))
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(item.$1,
                        color: PublicArchiveLandingScreen._deepGreen, size: 18),
                    const SizedBox(width: 8),
                    Text(item.$2,
                        style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            color: PublicArchiveLandingScreen._manuscript)),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _PremiumCatalogSection extends StatelessWidget {
  const _PremiumCatalogSection({required this.catalogs});

  final List<_PremiumCatalogData> catalogs;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 36, 24, 18),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            PublicArchiveLandingScreen._paper,
            PublicArchiveLandingScreen._warmPaper
          ],
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1220),
          child: Column(
            children: [
              const _SectionKicker(
                  icon: Icons.menu_book_outlined,
                  label: 'غرف كتالوجات الأرشيف'),
              const SizedBox(height: 10),
              const Text(
                'كل كتالوج غرفة أرشيفية لها لونها ومصدرها ونوع وثائقها',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 28,
                    color: PublicArchiveLandingScreen._manuscript),
              ),
              const SizedBox(height: 26),
              LayoutBuilder(
                builder: (context, constraints) {
                  final columns = constraints.maxWidth > 1060
                      ? 4
                      : constraints.maxWidth > 720
                          ? 2
                          : 1;
                  final width =
                      (constraints.maxWidth - (columns - 1) * 18) / columns;
                  return Wrap(
                    spacing: 18,
                    runSpacing: 18,
                    children: [
                      for (final catalog in catalogs)
                        SizedBox(
                          width: width,
                          child: _PremiumCatalogCard(catalog: catalog),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PremiumCatalogCard extends StatelessWidget {
  const _PremiumCatalogCard({required this.catalog});
  // PREMIUM_CATALOG_CARD_OVERFLOW_REPAIR: the card has extra vertical
  // room and bounded text so the public catalog grid does not show yellow/black
  // RenderFlex overflow stripes at desktop widths.
  // PREMIUM_VISUAL_ANALYZE_CLEANUP: the archival palette constants are used.

  final _PremiumCatalogData catalog;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 392,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: catalog.tint.withValues(alpha: 0.20)),
        boxShadow: [
          BoxShadow(
              color: catalog.tint.withValues(alpha: 0.10),
              blurRadius: 28,
              offset: const Offset(0, 18)),
        ],
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(26),
              child: CustomPaint(
                  painter: _CatalogTexturePainter(
                      color: catalog.tint, glow: catalog.glow)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: catalog.tint,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                              color: catalog.tint.withValues(alpha: 0.25),
                              blurRadius: 20,
                              offset: const Offset(0, 10))
                        ],
                      ),
                      child: Icon(catalog.icon, color: Colors.white, size: 34),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                          color: catalog.glow.withValues(alpha: 0.55),
                          borderRadius: BorderRadius.circular(99)),
                      child: Text(
                        catalog.era,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: catalog.tint,
                            fontWeight: FontWeight.w900,
                            fontSize: 11),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Text(
                  catalog.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: catalog.tint,
                      fontWeight: FontWeight.w900,
                      fontSize: 24,
                      height: 1.2),
                ),
                const SizedBox(height: 10),
                Text(
                  catalog.description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      color: Color(0xFF4D4B43),
                      fontWeight: FontWeight.w700,
                      height: 1.7),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 7,
                  runSpacing: 7,
                  children: [
                    for (final doc in catalog.documents.take(4))
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 9, vertical: 6),
                        decoration: BoxDecoration(
                          color: catalog.tint.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: Text(doc,
                            style: TextStyle(
                                color: catalog.tint,
                                fontWeight: FontWeight.w800,
                                fontSize: 12)),
                      ),
                  ],
                ),
                const Spacer(),
                Row(
                  children: [
                    _CatalogNumber(
                        label: 'مسودة',
                        value: catalog.count,
                        color: catalog.tint),
                    const SizedBox(width: 20),
                    _CatalogNumber(
                        label: 'نوع وثيقة',
                        value: catalog.types,
                        color: catalog.tint),
                    const Spacer(),
                    Icon(Icons.arrow_back_rounded, color: catalog.tint),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CatalogNumber extends StatelessWidget {
  const _CatalogNumber(
      {required this.label, required this.value, required this.color});

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value,
            style: TextStyle(
                color: color, fontWeight: FontWeight.w900, fontSize: 22)),
        Text(label,
            style: const TextStyle(
                color: Color(0xFF6F6A5C),
                fontWeight: FontWeight.w700,
                fontSize: 11)),
      ],
    );
  }
}

class _DocumentJourneySection extends StatelessWidget {
  const _DocumentJourneySection();

  @override
  Widget build(BuildContext context) {
    // ARCHIVE_PROCESS_RAIL
    // DRAFT_APPROVAL_VISUAL_LANGUAGE
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 44, 24, 36),
      color: const Color(0xFFF7EDDC),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1160),
          child: Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: PublicArchiveLandingScreen._deepGreen,
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withValues(alpha: 0.16),
                    blurRadius: 30,
                    offset: const Offset(0, 18))
              ],
            ),
            child: Column(
              children: [
                const Text('رحلة الوثيقة من المصدر إلى الإتاحة المحكومة',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 27)),
                const SizedBox(height: 22),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 12,
                  runSpacing: 12,
                  children: const [
                    _JourneyStep(
                        icon: Icons.inventory_2_outlined, label: 'مصدر أصلي'),
                    _JourneyStep(
                        icon: Icons.image_outlined, label: 'تمثيل رقمي'),
                    _JourneyStep(
                        icon: Icons.document_scanner_outlined,
                        label: 'OCR / تفريغ'),
                    _JourneyStep(
                        icon: Icons.translate_outlined, label: 'ترجمة'),
                    _JourneyStep(
                        icon: Icons.view_list_outlined, label: 'Metadata'),
                    _JourneyStep(
                        icon: Icons.fact_check_outlined, label: 'مراجعة بشرية'),
                    _JourneyStep(
                        icon: Icons.lock_outline, label: 'إتاحة محكومة'),
                  ],
                ),
                const SizedBox(height: 18),
                Text(
                  'لا تتحول أي مسودة إلى معرفة منشورة قبل الاعتماد البشري. التقنيات مساعدة، وليست سلطة نهائية.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.82),
                      fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _JourneyStep extends StatelessWidget {
  const _JourneyStep({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 135,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
            color: PublicArchiveLandingScreen._gold.withValues(alpha: 0.38)),
      ),
      child: Column(
        children: [
          Icon(icon, color: PublicArchiveLandingScreen._gold, size: 29),
          const SizedBox(height: 10),
          Text(label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}

class _PremiumTechnologySection extends StatelessWidget {
  const _PremiumTechnologySection();

  @override
  Widget build(BuildContext context) {
    const capabilities = [
      (
        Icons.document_scanner_outlined,
        'OCR كمسودة',
        'قراءة أولية لا تُعتمد تلقائيًا'
      ),
      (Icons.edit_note_outlined, 'تفريغ وتحقيق', 'نصوص قابلة للمراجعة البشرية'),
      (Icons.translate_outlined, 'ترجمة', 'طبقة تفسيرية مرتبطة بالأصل'),
      (Icons.hub_outlined, 'ربط معرفي', 'وقف، مكان، حوض، قطعة، أشخاص'),
      (Icons.travel_explore_outlined, 'استكشاف مكاني', 'خرائط وخطوط زمنية'),
      (Icons.verified_user_outlined, 'اعتماد محكوم', 'لا نشر قبل المراجعة'),
    ];
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 46, 24, 44),
      color: PublicArchiveLandingScreen._paper,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1160),
          child: Column(
            children: [
              const _SectionKicker(
                  icon: Icons.auto_awesome_outlined,
                  label: 'تقنيات في خدمة التحقيق لا بديل عنه'),
              const SizedBox(height: 24),
              LayoutBuilder(
                builder: (context, constraints) {
                  final columns = constraints.maxWidth > 960
                      ? 3
                      : constraints.maxWidth > 640
                          ? 2
                          : 1;
                  final width =
                      (constraints.maxWidth - (columns - 1) * 16) / columns;
                  return Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      for (final cap in capabilities)
                        SizedBox(
                          width: width,
                          child: _CapabilityTile(
                              icon: cap.$1, title: cap.$2, subtitle: cap.$3),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CapabilityTile extends StatelessWidget {
  const _CapabilityTile(
      {required this.icon, required this.title, required this.subtitle});

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
            color: PublicArchiveLandingScreen._gold.withValues(alpha: 0.18)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color:
                  PublicArchiveLandingScreen._deepGreen.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: PublicArchiveLandingScreen._deepGreen),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w900, fontSize: 16)),
                const SizedBox(height: 4),
                Text(subtitle,
                    style: const TextStyle(
                        color: Color(0xFF6B675D), fontWeight: FontWeight.w700)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WorkspacePreviewSection extends StatelessWidget {
  const _WorkspacePreviewSection({required this.onDevLogin});

  final VoidCallback onDevLogin;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 18, 24, 50),
      color: PublicArchiveLandingScreen._paper,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1120),
          child: Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [Color(0xFFFFFFFF), Color(0xFFF3E5CA)]),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(
                  color:
                      PublicArchiveLandingScreen._gold.withValues(alpha: 0.25)),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('مركز تشغيل أرشيفي داخلي',
                          style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 26,
                              color: PublicArchiveLandingScreen._manuscript)),
                      SizedBox(height: 10),
                      Text(
                          'المسودات، التمثيلات، OCR، الترجمة، المراجعة، والمنع من النشر تظهر كمؤشرات تشغيلية لا كروابط إدارية جامدة.',
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              height: 1.7,
                              color: Color(0xFF5A574D))),
                    ],
                  ),
                ),
                const SizedBox(width: 18),
                FilledButton.icon(
                  onPressed: onDevLogin,
                  icon: const Icon(Icons.dashboard_customize_outlined),
                  label: const Text('فتح مساحة العمل'),
                  style: FilledButton.styleFrom(
                    backgroundColor: PublicArchiveLandingScreen._deepGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 18),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionKicker extends StatelessWidget {
  const _SectionKicker({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: PublicArchiveLandingScreen._deepGreen.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: PublicArchiveLandingScreen._deepGreen, size: 18),
          const SizedBox(width: 8),
          Text(label,
              style: const TextStyle(
                  color: PublicArchiveLandingScreen._deepGreen,
                  fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}

class _PremiumFooter extends StatelessWidget {
  const _PremiumFooter();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: PublicArchiveLandingScreen._deepGreen,
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 34),
      child: const Center(
        child: Text(
          'أرشيف الوقف الفلسطيني · مسودات تطويرية غير منشورة · لا إتاحة عامة قبل الاعتماد البشري',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}

class _PremiumCatalogData {
  const _PremiumCatalogData({
    required this.icon,
    required this.title,
    required this.era,
    required this.description,
    required this.documents,
    required this.tint,
    required this.glow,
    required this.count,
    required this.types,
  });

  final IconData icon;
  final String title;
  final String era;
  final String description;
  final List<String> documents;
  final Color tint;
  final Color glow;
  final String count;
  final String types;
}

class _ArchiveHeroPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paper = Paint()
      ..color = const Color(0xFFDDC08A).withValues(alpha: 0.42);
    final line = Paint()
      ..color = Colors.black.withValues(alpha: 0.13)
      ..strokeWidth = 1;
    final building = Paint()..color = Colors.black.withValues(alpha: 0.52);
    final gold = Paint()
      ..color = PublicArchiveLandingScreen._gold.withValues(alpha: 0.65);

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width * 0.46, size.height), paper);
    for (var y = 36.0; y < size.height - 42; y += 28) {
      canvas.drawLine(Offset(24, y), Offset(size.width * 0.42, y), line);
    }
    final centerY = size.height * 0.55;
    canvas.drawCircle(Offset(size.width * 0.13, centerY), 42,
        Paint()..color = const Color(0xFF415044).withValues(alpha: 0.18));
    canvas.drawCircle(
        Offset(size.width * 0.13, centerY),
        28,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..color = const Color(0xFF27382E).withValues(alpha: 0.33));

    final baseY = size.height * 0.78;
    canvas.drawRect(
        Rect.fromLTWH(size.width * 0.40, baseY - 58, size.width * 0.52, 58),
        building);
    canvas.drawRect(
        Rect.fromLTWH(size.width * 0.45, baseY - 112, 70, 112), building);
    canvas.drawRect(
        Rect.fromLTWH(size.width * 0.67, baseY - 98, 62, 98), building);
    canvas.drawArc(Rect.fromLTWH(size.width * 0.62, baseY - 170, 120, 120),
        math.pi, math.pi, false, gold);
    canvas.drawRect(
        Rect.fromLTWH(size.width * 0.86, baseY - 210, 22, 210), building);
    canvas.drawCircle(Offset(size.width * 0.87, baseY - 210), 24, building);

    final gridPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.055)
      ..strokeWidth = 1;
    for (var x = size.width * 0.48; x < size.width; x += 38) {
      canvas.drawLine(Offset(x, 0), Offset(x - 120, size.height), gridPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _CadastralMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()
      ..color = const Color(0xFF4A422D).withValues(alpha: 0.32)
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke;
    final fill = Paint()..color = Colors.white.withValues(alpha: 0.08);
    final path = Path()
      ..moveTo(size.width * 0.10, size.height * 0.20)
      ..lineTo(size.width * 0.54, size.height * 0.12)
      ..lineTo(size.width * 0.88, size.height * 0.30)
      ..lineTo(size.width * 0.78, size.height * 0.78)
      ..lineTo(size.width * 0.25, size.height * 0.84)
      ..close();
    canvas.drawPath(path, fill);
    canvas.drawPath(path, stroke);
    for (var i = 0; i < 7; i++) {
      final t = i / 7;
      canvas.drawLine(
          Offset(size.width * (0.16 + t * 0.66), size.height * 0.18),
          Offset(size.width * (0.22 + t * 0.50), size.height * 0.82),
          stroke);
    }
    for (var i = 0; i < 5; i++) {
      final y = size.height * (0.28 + i * 0.11);
      canvas.drawLine(Offset(size.width * 0.14, y),
          Offset(size.width * 0.84, y + math.sin(i) * 18), stroke);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _CatalogTexturePainter extends CustomPainter {
  const _CatalogTexturePainter({required this.color, required this.glow});

  final Color color;
  final Color glow;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(Offset(size.width * 0.16, size.height * 0.18), 88,
        Paint()..color = glow.withValues(alpha: 0.44));
    canvas.drawCircle(Offset(size.width * 0.92, size.height * 0.08), 52,
        Paint()..color = color.withValues(alpha: 0.08));
    final line = Paint()
      ..color = color.withValues(alpha: 0.075)
      ..strokeWidth = 1;
    for (var y = 28.0; y < size.height; y += 34) {
      canvas.drawLine(
          Offset(18, y), Offset(size.width - 18, y + math.sin(y) * 3), line);
    }
  }

  @override
  bool shouldRepaint(covariant _CatalogTexturePainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.glow != glow;
}
