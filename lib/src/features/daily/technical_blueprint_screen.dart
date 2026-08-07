import 'package:flutter/material.dart';

import '../../shared/widgets.dart';

class TechnicalBlueprintScreen extends StatelessWidget {
  const TechnicalBlueprintScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('التصور الفني الأولي',
            style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        const Text(
            'تصور معماري أولي لنظام الأرشفة الإلكترونية، قابل للإدماج لاحقًا داخل PalWakf عبر Staging Controlled UAT فقط.'),
        const SizedBox(height: 16),
        const SectionCard(
          icon: Icons.layers_outlined,
          title: 'طبقات النظام',
          children: [
            KeyValueLine(
                label: 'Presentation',
                value:
                    'Flutter Web، RTL، صفحات استخدام يومية، Riverpod، Widgets قابلة لإعادة الاستخدام.'),
            KeyValueLine(
                label: 'Application',
                value:
                    'Controllers/Providers لدورة الوثيقة، البحث، المراجعة، الرفع، والصلاحيات.'),
            KeyValueLine(
                label: 'Domain',
                value:
                    'Document، Classification، Representation، Evidence، Review، Permission، Backup.'),
            KeyValueLine(
                label: 'Infrastructure',
                value:
                    'Repositories/Services لاحقًا للـSupabase/File Center/PostGIS وفق عقود Staging.'),
            KeyValueLine(
                label: 'Integration',
                value:
                    'Adapter لسلطة المستخدم ونطاق الوحدة والـFeature Flags والـHealth/Fallback.'),
          ],
        ),
        const SizedBox(height: 12),
        const SectionCard(
          icon: Icons.table_rows_outlined,
          title: 'نموذج بيانات أولي',
          children: [
            KeyValueLine(label: 'archive.fonds', value: 'المجموعات العليا.'),
            KeyValueLine(
                label: 'archive.series',
                value: 'السلاسل الموضوعية أو الإدارية.'),
            KeyValueLine(
                label: 'archive.files', value: 'الملفات الجامعة للوثائق.'),
            KeyValueLine(
                label: 'archive.items', value: 'الوثيقة أو المادة المفردة.'),
            KeyValueLine(
                label: 'archive.representations',
                value: 'الأصل وOCR والترجمة والملخص والمصغرات.'),
            KeyValueLine(
                label: 'archive.review_tasks',
                value: 'مهام المراجعة وسير العمل.'),
            KeyValueLine(
                label: 'archive.audit_events',
                value: 'سجل الأحداث والتعديلات.'),
          ],
        ),
        const SizedBox(height: 12),
        const SectionCard(
          icon: Icons.integration_instructions_outlined,
          title: 'حدود الإدماج',
          children: [
            KeyValueLine(
                label: 'public',
                value: 'Views/RPC wrappers فقط عند الحاجة، لا جداول أساس.'),
            KeyValueLine(
                label: 'core/waqf',
                value: 'مصادر سيادية تقرأ عبر عقود لا تعدل مباشرة.'),
            KeyValueLine(
                label: 'waqf_asset_id', value: 'رابط مركزي مع الأصول الوقفية.'),
            KeyValueLine(
                label: 'Staging', value: 'بوابة اختبار قبل أي اتصال إنتاجي.'),
          ],
        ),
      ],
    );
  }
}
