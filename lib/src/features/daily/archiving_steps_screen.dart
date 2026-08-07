import 'package:flutter/material.dart';

import '../../shared/widgets.dart';

class ArchivingStepsScreen extends StatelessWidget {
  const ArchivingStepsScreen({super.key});

  static const _steps = [
    'تجهيز الوثائق وفرز النسخ الأصلية عن النسخ المساندة.',
    'تحديد الإدارة المالكة والموضوع ونوع الوثيقة.',
    'إدخال metadata الإلزامية وتحديد مستوى الحساسية.',
    'رفع الأصل أو توصيف مكانه وتوليد hash للملف.',
    'إنشاء التمثيلات: OCR، ترجمة، ملخص، مصغّر، تمثيل مكاني.',
    'ربط الوثيقة بالسلسلة والملف والعنصر داخل التسلسل الأرشيفي.',
    'إرسالها إلى صف المراجعة المختص.',
    'تطبيق قرار المراجعة: اعتماد، تصحيح، تقييد، حجر.',
    'إتاحتها داخليًا أو للوحدة أو حجبها وفق الصلاحيات.',
    'حفظها ضمن backup/retention وإظهارها في البحث والاسترجاع.',
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('خطوات الأرشفة', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        const Text(
            'خطوات عملية تصلح كدليل يومي للفريق عند تحويل الوثائق الورقية أو الرقمية إلى أرشيف إلكتروني مضبوط.'),
        const SizedBox(height: 16),
        SectionCard(
          icon: Icons.checklist_rtl_outlined,
          title: 'قائمة العمل',
          children: [
            for (var index = 0; index < _steps.length; index++)
              CheckboxListTile(
                value: false,
                onChanged: null,
                title: Text(_steps[index]),
                secondary: CircleAvatar(child: Text('${index + 1}')),
              ),
          ],
        ),
        const SizedBox(height: 12),
        const SectionCard(
          icon: Icons.assignment_turned_in_outlined,
          title: 'مخرجات عملية الأرشفة',
          children: [
            KeyValueLine(
                label: 'سجل وثيقة', value: 'Metadata كاملة مع معرف داخلي.'),
            KeyValueLine(
                label: 'أصل محفوظ', value: 'ملف أصلي أو توصيف مصدره مع hash.'),
            KeyValueLine(
                label: 'تمثيلات',
                value: 'OCR/Translation/Summary/Thumbnail/Geo حسب الحاجة.'),
            KeyValueLine(label: 'مراجعة', value: 'قرار مراجعة وسجل أحداث.'),
            KeyValueLine(
                label: 'إتاحة', value: 'مستوى وصول واضح ومقيد بالصلاحيات.'),
          ],
        ),
      ],
    );
  }
}
