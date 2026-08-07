import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/models.dart';
import '../../core/state/local_operational_store.dart';
import '../../platform_integration/contracts.dart';
import '../../platform_integration/local_capability_gate.dart';
import '../../shared/widgets.dart';

class DocumentLifecycleScreen extends ConsumerWidget {
  const DocumentLifecycleScreen({super.key});

  static const _steps = [
    ['01', 'استلام', 'تسجيل مصدر الوثيقة والجهة الواردة ونطاق الوحدة.'],
    ['02', 'مسودة', 'إدخال البيانات الأساسية ورفع الأصل أو توصيفه.'],
    ['03', 'تحقق أولي', 'فحص اكتمال metadata، hash، نوع الملف، وحالة الحقوق.'],
    ['04', 'تصنيف', 'ربط الوثيقة بالإدارة، الموضوع، Fonds/Series/File/Item.'],
    ['05', 'مراجعة', 'مراجعة قانونية/حقوقية/مكانية/وقفية حسب النوع.'],
    ['06', 'تصحيح', 'إرجاع الوثيقة عند نقص البيانات أو تضارب المصدر.'],
    ['07', 'اعتماد داخلي', 'تصبح قابلة للاستخدام الداخلي والربط المؤسسي.'],
    ['08', 'إتاحة', 'داخلي، وحدة فقط، مقيد، أو مرشح للنشر العام.'],
    ['09', 'حفظ طويل الأجل', 'تثبيت الأصل والتمثيلات والنسخ الاحتياطي.'],
    [
      '10',
      'أرشفة/إقفال',
      'إغلاق دورة العمل مع بقاء البحث والاسترجاع والتدقيق.'
    ],
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(localOperationalProvider);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('دورة حياة الوثيقة',
            style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        const LocalOnlyBanner(),
        const SizedBox(height: 12),
        const Text(
            'الدورة تمنع القفز من الإدخال إلى النشر. كل انتقال له مسؤولية وشرط تحقق.'),
        const SizedBox(height: 16),
        SectionCard(
          icon: Icons.route_outlined,
          title: 'تشغيل دورة العمل الحالية',
          subtitle:
              'DOCUMENT_LIFECYCLE_OPERATIONAL_BOARD: تغيير حالة الوثيقة محليًا مع إنشاء مهام مراجعة عند الإرسال.',
          children: [
            for (final item in state.evidence)
              _LifecycleDocumentRow(item: item),
          ],
        ),
        const SizedBox(height: 12),
        SectionCard(
          icon: Icons.sync_alt_outlined,
          title: 'المراحل المرجعية',
          children: [
            for (final step in _steps)
              ListTile(
                leading: CircleAvatar(child: Text(step[0])),
                title: Text(step[1]),
                subtitle: Text(step[2]),
              ),
          ],
        ),
        const SizedBox(height: 12),
        const SectionCard(
          icon: Icons.block_outlined,
          title: 'حالات الإيقاف',
          children: [
            KeyValueLine(
                label: 'Needs Correction',
                value: 'نقص بيانات أو مصدر غير واضح.'),
            KeyValueLine(
                label: 'Restricted',
                value: 'معلومات حساسة أو حقوق غير محسومة.'),
            KeyValueLine(
                label: 'Quarantined',
                value: 'تضارب أو خطر قانوني أو مصدر مشكوك فيه.'),
            KeyValueLine(
                label: 'Legal Hold', value: 'تجميد بسبب مسار قضائي أو اعتراض.'),
          ],
        ),
      ],
    );
  }
}

class _LifecycleDocumentRow extends ConsumerWidget {
  const _LifecycleDocumentRow({required this.item});

  final EvidenceItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final details = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title,
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                Text('${item.id} • ${item.reference}'),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    StatusPill(label: item.status.label),
                    StatusPill(label: item.accessLevel.label),
                    StatusPill(label: item.rightsStatus),
                  ],
                ),
              ],
            );
            final actions = Wrap(
              spacing: 6,
              runSpacing: 6,
              alignment: WrapAlignment.end,
              children: [
                OutlinedButton.icon(
                  onPressed: () => _submit(context, ref),
                  icon: const Icon(Icons.send_outlined),
                  label: const Text('مراجعة'),
                ),
                FilledButton.tonalIcon(
                  onPressed: () => _approve(context, ref),
                  icon: const Icon(Icons.verified_outlined),
                  label: const Text('اعتماد'),
                ),
                OutlinedButton.icon(
                  onPressed: () => _return(context, ref),
                  icon: const Icon(Icons.undo_outlined),
                  label: const Text('تصحيح'),
                ),
                OutlinedButton.icon(
                  onPressed: () => _quarantine(context, ref),
                  icon: const Icon(Icons.block_outlined),
                  label: const Text('حجر'),
                ),
              ],
            );
            if (constraints.maxWidth < 700) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [details, const SizedBox(height: 10), actions],
              );
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: details),
                const SizedBox(width: 12),
                actions,
              ],
            );
          },
        ),
      ),
    );
  }

  void _submit(BuildContext context, WidgetRef ref) {
    if (!_authorize(context, ref, 'إرسال وثيقة للمراجعة')) {
      return;
    }
    ref
        .read(localOperationalProvider.notifier)
        .submitEvidenceForReview(item.id);
    _show(context, 'تم إرسال الوثيقة للمراجعة.');
  }

  void _approve(BuildContext context, WidgetRef ref) {
    if (!_authorize(context, ref, 'اعتماد داخلي')) {
      return;
    }
    ref
        .read(localOperationalProvider.notifier)
        .approveEvidenceInternally(item.id);
    _show(context, 'تم اعتماد الوثيقة داخليًا.');
  }

  void _return(BuildContext context, WidgetRef ref) {
    if (!_authorize(context, ref, 'إرجاع للتصحيح')) {
      return;
    }
    ref
        .read(localOperationalProvider.notifier)
        .updateEvidenceStatus(item.id, EvidenceReviewStatus.discovered);
    _show(context, 'تمت إعادة الوثيقة للتصحيح.');
  }

  void _quarantine(BuildContext context, WidgetRef ref) {
    if (!_authorize(context, ref, 'حجر وثيقة')) {
      return;
    }
    ref.read(localOperationalProvider.notifier).quarantineEvidence(item.id);
    _show(context, 'تم حجر الوثيقة محليًا.');
  }

  bool _authorize(BuildContext context, WidgetRef ref, String actionLabel) {
    return requireLocalCapability(
      context,
      ref,
      capability: ArchiveCapability.reviewUpdateLocalDraft,
      actionLabel: actionLabel,
    );
  }

  void _show(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
