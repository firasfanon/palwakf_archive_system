import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/models.dart';
import '../../core/state/local_operational_store.dart';
import '../../shared/widgets.dart';

class SmartSearchMechanismScreen extends ConsumerWidget {
  const SmartSearchMechanismScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(localOperationalProvider);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('البحث الذكي والاسترجاع',
            style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        const Text(
            'البحث الذكي المقترح يبدأ ببحث نصي وفلترة منظمة، ثم ينتقل لاحقًا إلى OCR ومرادفات وربط مكاني وزمني ومعرفي بعد الاعتماد.'),
        const SizedBox(height: 16),
        SectionCard(
          icon: Icons.search_outlined,
          title: 'نموذج بحث يومي',
          subtitle: 'يعرض أمثلة من بيانات fixture الحالية.',
          children: [
            for (final item in state.evidence)
              ListTile(
                leading: const Icon(Icons.description_outlined),
                title: Text(item.title),
                subtitle: Text('${item.reference} • ${item.sourceAuthority}'),
                trailing: StatusPill(label: item.accessLevel.label),
              ),
          ],
        ),
        const SizedBox(height: 12),
        const SectionCard(
          icon: Icons.tune_outlined,
          title: 'آلية البحث المقترحة',
          children: [
            KeyValueLine(
                label: 'بحث نصي',
                value:
                    'العنوان، الرقم المرجعي، الجهة، الملاحظات، OCR المعتمد.'),
            KeyValueLine(
                label: 'فلاتر',
                value:
                    'الإدارة، الموضوع، النوع، التاريخ، المكان، الحالة، الحقوق، مستوى الإتاحة.'),
            KeyValueLine(
                label: 'بحث ذكي',
                value:
                    'مرادفات عربية، اقتراحات، مطابقة رقم أصل وقفي، كشف مواد مشابهة.'),
            KeyValueLine(
                label: 'بحث مكاني',
                value: 'بلدة، حوض، قطعة، waqf_asset_id، حالة الثقة المكانية.'),
            KeyValueLine(
                label: 'بحث زمني',
                value:
                    'فترة عثمانية، انتداب، أردني، فلسطيني، معاصر، أو تاريخ تقريبي.'),
            KeyValueLine(
                label: 'إخفاء النتائج',
                value:
                    'المواد المقيدة تظهر كمؤشر محجوب حسب الصلاحية ولا تكشف محتواها.'),
          ],
        ),
      ],
    );
  }
}
