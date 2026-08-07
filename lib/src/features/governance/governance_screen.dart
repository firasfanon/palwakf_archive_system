import 'package:flutter/material.dart';

import '../../shared/widgets.dart';

class GovernanceScreen extends StatelessWidget {
  const GovernanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const rules = [
      'PALWAKF_MODULE_FACTORY_AND_PLATFORM_RECEPTION_FRAMEWORK_V1 هو مرجع تجهيز الإدماج.',
      'النظام Module متخصص ومحكوم، وليس منصة سيادية أو runtime إنتاجي مستقل.',
      'لا هوية محلية ولا RBAC محلي ولا نموذج Super Admin محلي.',
      'لا مسارات إنتاجية صريحة؛ الربط النهائي يتم عبر route slots تعيّنها المنصة.',
      'لا جداول أساس جديدة في public، ولا اتصال مباشر بجداول صلاحيات المنصة.',
      'الأرشيف الأصلي يبقى محليًا حتى تفويض migration صريح عبر File Center.',
      'OCR والترجمة والمشتقات لا تساوي الأصل، والنتيجة المكانية ليست حدًا قانونيًا.',
      'كل قراءة أو عملية مستقبلية تخضع للسياق الفعال: capability + authority + unit scope + ownership + workflow.',
      'النشر العام أو الربط الإنتاجي يحتاجان Staging Gate واعتمادًا صريحًا.',
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'الحوكمة',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        const LocalOnlyBanner(),
        const SizedBox(height: 16),
        const Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: SelectableText(
              'SYSTEM_ROLE=GOVERNED_SEMI_INDEPENDENT_MODULE\n'
              'MODULE_ID=evidence_archive\n'
              'DEVELOPMENT_MODE=LOCAL_FIXTURE_HOST\n'
              'PLATFORM_INTEGRATION=BOUNDARY_PREPARED_NOT_BOUND\n'
              'UNIT_SCOPE=LOCAL_MOCK_ONLY_SERVER_SIDE_REQUIRED\n'
              'DATABASE_MUTATION=NONE\n'
              'STORAGE_MIGRATION=NONE\n'
              'PRODUCTION_APPROVAL=NOT_IMPLIED',
            ),
          ),
        ),
        const SizedBox(height: 16),
        for (final rule in rules)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text('• $rule'),
          ),
      ],
    );
  }
}
