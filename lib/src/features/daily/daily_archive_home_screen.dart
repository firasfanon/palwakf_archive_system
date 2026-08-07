import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/state/local_operational_store.dart';
import '../../shared/widgets.dart';

class DailyArchiveHomeScreen extends ConsumerWidget {
  const DailyArchiveHomeScreen({
    required this.onNavigate,
    super.key,
  });

  final ValueChanged<int> onNavigate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(localOperationalProvider);
    // WORKSPACE_COMMAND_CENTER_VISUAL_SHELL
    // PREMIUM_WORKSPACE_COMMAND_CENTER: the internal first screen is a real
    // archive operations command center, not a plain administrative dashboard.
    // ARCHIVE_OPERATIONS_INTELLIGENCE_DASHBOARD: it surfaces queues by document,
    // metadata, OCR, translation, review, and blocked publication state.
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF7EDDC), Color(0xFFFFFCF4)],
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.all(22),
        children: [
          _CommandHero(onNavigate: onNavigate),
          const SizedBox(height: 18),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              MetricTile(
                icon: Icons.folder_copy_outlined,
                label: 'وثائق وسجلات',
                value: state.evidence.length.toString(),
                onTap: () => onNavigate(2),
              ),
              MetricTile(
                icon: Icons.menu_book_outlined,
                label: 'كتالوجات مصدرية',
                value: state.layeredArchiveCatalogCount.toString(),
                onTap: () => onNavigate(23),
              ),
              MetricTile(
                icon: Icons.fact_check_outlined,
                label: 'مراجعات مفتوحة',
                value: state.openReviewCount.toString(),
                onTap: () => onNavigate(10),
              ),
              MetricTile(
                icon: Icons.backup_table_outlined,
                label: 'تمثيلات محفوظة',
                value: state.representations.length.toString(),
                onTap: () => onNavigate(12),
              ),
              MetricTile(
                icon: Icons.article_outlined,
                label: 'طبقات نصية',
                value: state.textDraftLayers.length.toString(),
                onTap: () => onNavigate(12),
              ),
              MetricTile(
                icon: Icons.lock_outline,
                label: 'النشر المحجوب',
                value:
                    state.publicationBlockedUntilHumanApprovalCount.toString(),
                onTap: () => onNavigate(15),
              ),
            ],
          ),
          const SizedBox(height: 18),
          _OperationalQueues(onNavigate: onNavigate),
          const SizedBox(height: 18),
          SectionCard(
            icon: Icons.widgets_outlined,
            title: 'واجهات الاستخدام اليومية',
            subtitle:
                'هذه هي صفحات العمل الأساسية للموظف والمراجع والمدير، والحوكمة محفوظة داخل صفحة الإدارة فقط.',
            children: [
              _QuickActionGrid(onNavigate: onNavigate),
            ],
          ),
          const SizedBox(height: 12),
          SectionCard(
            icon: Icons.info_outline,
            title: 'وصف النظام وأهدافه',
            children: const [
              KeyValueLine(
                label: 'وصف النظام',
                value:
                    'نظام أرشيف معرفي لإدارة الوثائق الوقفية والمكانية من المصدر الأصلي إلى التمثيل الرقمي والقراءة والترجمة والمراجعة.',
              ),
              KeyValueLine(
                label: 'الأهداف',
                value:
                    'توحيد الكتالوجات، ضبط metadata، حماية الأصل، دعم OCR والتفريغ والترجمة، وربط الوثائق بالوقف والمكان قبل أي إتاحة محكومة.',
              ),
              KeyValueLine(
                label: 'الفئات المستفيدة',
                value:
                    'أمناء الأرشيف، مدخلو البيانات، الباحثون، المراجعون، الإدارة القانونية، GIS، ومديرو الوحدات.',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CommandHero extends StatelessWidget {
  const _CommandHero({required this.onNavigate});

  final ValueChanged<int> onNavigate;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 270),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xFF073F31), Color(0xFF0E6A4D), Color(0xFF2B2118)],
        ),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.18),
              blurRadius: 32,
              offset: const Offset(0, 20))
        ],
      ),
      child: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: _CommandCenterPainter())),
          Padding(
            padding: const EdgeInsets.all(28),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('مركز تشغيل الأرشيف',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 34)),
                      const SizedBox(height: 10),
                      Text(
                        'مساحة عمل يومية تراقب المسودات، التمثيلات، OCR، التفريغ، الترجمة، metadata، والمراجعة البشرية قبل أي نشر.',
                        style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.86),
                            fontWeight: FontWeight.w700,
                            height: 1.7,
                            fontSize: 16),
                      ),
                      const SizedBox(height: 20),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          FilledButton.tonalIcon(
                              onPressed: () => onNavigate(4),
                              icon: const Icon(Icons.note_add_outlined),
                              label: const Text('إدخال وثيقة')),
                          FilledButton.tonalIcon(
                              onPressed: () => onNavigate(23),
                              icon: const Icon(Icons.menu_book_outlined),
                              label: const Text('فتح الكتالوجات')),
                          OutlinedButton.icon(
                            onPressed: () => onNavigate(7),
                            icon: const Icon(Icons.manage_search_outlined),
                            label: const Text('بحث واستكشاف'),
                            style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                side: BorderSide(
                                    color:
                                        Colors.white.withValues(alpha: 0.65))),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 26),
                const _CommandDossier(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OperationalQueues extends StatelessWidget {
  const _OperationalQueues({required this.onNavigate});

  final ValueChanged<int> onNavigate;

  @override
  Widget build(BuildContext context) {
    const queues = [
      _QueueCard(4, Icons.view_list_outlined, 'Metadata ناقصة',
          'أكمل القوالب حسب الكتالوج ونوع الوثيقة.', Color(0xFF0E6A4D)),
      _QueueCard(12, Icons.image_outlined, 'تمثيلات تحتاج مراجعة',
          'صورة أصلية، Scan، Thumbnail، أو مرفق.', Color(0xFF2E6C9D)),
      _QueueCard(12, Icons.article_outlined, 'OCR / تفريغ',
          'طبقات نصية أولية غير معتمدة.', Color(0xFFAA7A23)),
      _QueueCard(10, Icons.fact_check_outlined, 'مراجعة واعتماد',
          'المواد الجاهزة للتحقق البشري.', Color(0xFF6A2F20)),
    ];
    return Wrap(
      spacing: 14,
      runSpacing: 14,
      children: [
        for (final queue in queues)
          SizedBox(
            width: 285,
            child: InkWell(
              borderRadius: BorderRadius.circular(22),
              onTap: () => onNavigate(queue.index),
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border:
                      Border.all(color: queue.color.withValues(alpha: 0.18)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(queue.icon, color: queue.color, size: 30),
                    const SizedBox(height: 13),
                    Text(queue.title,
                        style: TextStyle(
                            color: queue.color,
                            fontWeight: FontWeight.w900,
                            fontSize: 18)),
                    const SizedBox(height: 6),
                    Text(queue.subtitle,
                        style: const TextStyle(
                            color: Color(0xFF5D5A52),
                            fontWeight: FontWeight.w700,
                            height: 1.5)),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _CommandDossier extends StatelessWidget {
  const _CommandDossier();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(26),
        border:
            Border.all(color: const Color(0xFFC99A2E).withValues(alpha: 0.34)),
      ),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.folder_special_outlined,
              color: Color(0xFFC99A2E), size: 38),
          SizedBox(height: 14),
          Text('غرفة تحقيق وثيقة',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 20)),
          SizedBox(height: 10),
          Text('الأصل ← التمثيل ← OCR ← التفريغ ← الترجمة ← المراجعة ← الإتاحة',
              style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.w700,
                  height: 1.7)),
        ],
      ),
    );
  }
}

class _QuickActionGrid extends StatelessWidget {
  const _QuickActionGrid({required this.onNavigate});

  final ValueChanged<int> onNavigate;

  static const _cards = [
    _DailyCard(23, Icons.menu_book_outlined, 'كتالوجات الأرشيف',
        'غرف عثمانية وبريطانية وأردنية وفلسطينية.'),
    _DailyCard(4, Icons.note_add_outlined, 'إدخال مسودة',
        'نموذج ديناميكي حسب الكتالوج ونوع الوثيقة.'),
    _DailyCard(5, Icons.cloud_upload_outlined, 'رفع وحفظ الملفات',
        'قناة رفع محكومة مع hash وتمثيلات.'),
    _DailyCard(12, Icons.article_outlined, 'OCR والترجمة',
        'طبقات نصية مسودة تحت المراجعة.'),
    _DailyCard(10, Icons.fact_check_outlined, 'قائمة المراجعة',
        'الاعتماد البشري قبل النشر.'),
    _DailyCard(7, Icons.psychology_alt_outlined, 'البحث الذكي',
        'فلاتر وسجل كلمات وربط وقفي مستقبلي.'),
    _DailyCard(
        13, Icons.map_outlined, 'المكان والزمن', 'حوض، قطعة، خريطة، وخط زمني.'),
    _DailyCard(20, Icons.assessment_outlined, 'التقارير والتنبيهات',
        'تقارير يومية وتنبيهات وتصدير محلي.'),
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        for (final card in _cards)
          SizedBox(
            width: 274,
            child: Card(
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () => onNavigate(card.index),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(card.icon, color: const Color(0xFF073F31)),
                      const SizedBox(height: 10),
                      Text(card.title,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.w900)),
                      const SizedBox(height: 4),
                      Text(card.description,
                          style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _CommandCenterPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final line = Paint()
      ..color = Colors.white.withValues(alpha: 0.07)
      ..strokeWidth = 1;
    for (var x = 0.0; x < size.width; x += 36) {
      canvas.drawLine(Offset(x, 0), Offset(x - 120, size.height), line);
    }
    final gold = Paint()
      ..color = const Color(0xFFC99A2E).withValues(alpha: 0.18);
    canvas.drawCircle(Offset(size.width * 0.88, size.height * 0.18), 130, gold);
    canvas.drawCircle(Offset(size.width * 0.10, size.height * 0.78), 92, gold);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _QueueCard {
  const _QueueCard(
      this.index, this.icon, this.title, this.subtitle, this.color);

  final int index;
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
}

class _DailyCard {
  const _DailyCard(this.index, this.icon, this.title, this.description);

  final int index;
  final IconData icon;
  final String title;
  final String description;
}
