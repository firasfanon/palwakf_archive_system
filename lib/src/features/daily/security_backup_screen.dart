import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/state/local_operational_store.dart';
import '../../shared/widgets.dart';

class SecurityBackupScreen extends ConsumerWidget {
  const SecurityBackupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(localOperationalProvider);
    final controller = ref.read(localOperationalProvider.notifier);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('الأمان والنسخ الاحتياطي',
            style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        const Text(
            'SECURITY_BACKUP_OPERATIONALIZATION: هذه الصفحة تعرض سياسات الأمان مع محاكاة لقطات نسخ واختبار استرجاع محلي دون اتصال بمنظومة التخزين أو قاعدة البيانات.'),
        const SizedBox(height: 16),
        SectionCard(
          icon: Icons.shield_outlined,
          title: 'متطلبات الأمان',
          children: const [
            KeyValueLine(
                label: 'المصادقة',
                value: 'مركزية عبر PalWakf وليس حسابات محلية مستقلة.'),
            KeyValueLine(
                label: 'الصلاحيات',
                value: 'Role + Unit Scope + Workflow State + Access Level.'),
            KeyValueLine(
                label: 'RLS',
                value:
                    'تطبيق سياسات على مستوى الصف في schema الأرشيف عند الإدماج.'),
            KeyValueLine(
                label: 'التشفير',
                value:
                    'HTTPS + تشفير التخزين أو مفاتيح منصة التخزين المعتمدة.'),
            KeyValueLine(
                label: 'Audit',
                value: 'تسجيل كل قراءة حساسة وكل تعديل وكل تغيير حالة.'),
            KeyValueLine(
                label: 'إخفاء حساس',
                value: 'Masking للنتائج المقيدة بدل كشف المحتوى.'),
          ],
        ),
        const SizedBox(height: 12),
        SectionCard(
          icon: Icons.backup_outlined,
          title: 'النسخ الاحتياطي والاسترجاع',
          subtitle:
              'BACKUP_RESTORE_DRILL_LOCAL: محاكاة تشغيلية للتدريب على النسخ والاسترجاع.',
          children: [
            const KeyValueLine(
                label: 'نسخ يومية',
                value: 'نسخ قاعدة البيانات وmetadata وسجلات audit لاحقًا.'),
            const KeyValueLine(
                label: 'نسخ ملفات',
                value:
                    'نسخ File Center للأصول والتمثيلات مع hash verification لاحقًا.'),
            const KeyValueLine(
                label: 'Disaster Recovery',
                value: 'خطة RPO/RTO واضحة قبل Production.'),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: () => controller
                  .createLocalBackupSnapshot('لقطة أمان من صفحة النسخ'),
              icon: const Icon(Icons.backup_table_outlined),
              label: const Text('إنشاء لقطة نسخ محلية'),
            ),
            const SizedBox(height: 12),
            for (final snapshot in state.backupSnapshots.take(4))
              ListTile(
                leading: const Icon(Icons.storage_outlined),
                title: Text(snapshot.title),
                subtitle:
                    Text('${snapshot.status} — ${snapshot.restoreDrillStatus}'),
                trailing: TextButton.icon(
                  onPressed: () =>
                      controller.markBackupRestoreDrill(snapshot.id),
                  icon: const Icon(Icons.restore_outlined),
                  label: const Text('اختبار'),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
