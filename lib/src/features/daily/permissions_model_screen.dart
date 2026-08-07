import 'package:flutter/material.dart';

import '../../shared/widgets.dart';

class PermissionsModelScreen extends StatelessWidget {
  const PermissionsModelScreen({super.key});

  static const _rows = [
    ['مدير الأرشيف', 'إدارة التصنيفات، السياسات، الاعتماد النهائي، التقارير'],
    ['أمين الأرشيف', 'إدخال وتعديل metadata، تجهيز الاستيراد، إدارة السلاسل'],
    ['مدخل بيانات', 'إنشاء مسودات ورفع ملفات مرشحة دون اعتماد'],
    ['مراجع قانوني', 'مراجعة الحساسية القانونية وحالات Legal Hold'],
    ['مراجع حقوق', 'اعتماد الحقوق ومستويات الإتاحة'],
    ['مراجع مكاني', 'تدقيق الروابط المكانية ومستوى الثقة'],
    ['مدير وحدة', 'رؤية مواد وحدته واعتماد تشغيلي محدود'],
    ['مشاهد داخلي', 'قراءة المواد المصرح بها فقط'],
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('نموذج صلاحيات المستخدمين',
            style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        const Text(
            'الصلاحيات اليومية تُعرض هنا كنموذج تشغيلي. التنفيذ الحقيقي لاحقًا يكون عبر Authority/RLS مركزي داخل PalWakf وليس RBAC محلي مستقل.'),
        const SizedBox(height: 16),
        SectionCard(
          icon: Icons.group_outlined,
          title: 'الأدوار والفئات المستفيدة',
          children: [
            for (final row in _rows)
              ListTile(
                leading: const Icon(Icons.person_outline),
                title: Text(row[0]),
                subtitle: Text(row[1]),
              ),
          ],
        ),
        const SizedBox(height: 12),
        const SectionCard(
          icon: Icons.admin_panel_settings_outlined,
          title: 'مصفوفة العمليات',
          children: [
            KeyValueLine(
                label: 'إنشاء وثيقة',
                value: 'مدخل بيانات، أمين أرشيف، مدير أرشيف.'),
            KeyValueLine(
                label: 'تعديل بيانات',
                value:
                    'أمين أرشيف قبل الاعتماد؛ بعد الاعتماد عبر مسار تصحيح فقط.'),
            KeyValueLine(
                label: 'اعتماد',
                value: 'مراجع مختص + مدير أرشيف حسب الحساسية.'),
            KeyValueLine(
                label: 'نشر/إتاحة', value: 'مدير أرشيف بعد حقوق ومراجعة مصدر.'),
            KeyValueLine(
                label: 'حجر',
                value: 'أمين أرشيف أو مراجع عند وجود نقص أو حساسية.'),
            KeyValueLine(
                label: 'حذف',
                value: 'حذف منطقي فقط وفق سياسة، لا حذف أصل دون إجراء خاص.'),
          ],
        ),
      ],
    );
  }
}
