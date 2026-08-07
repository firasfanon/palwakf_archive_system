import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/models.dart';
import '../../core/state/local_operational_store.dart';
import '../../platform_integration/archive_platform_integration.dart';
import '../../platform_integration/contracts.dart';
import '../../shared/widgets.dart';
import '../governance/governance_screen.dart';
import '../governance/platform_integration_readiness_screen.dart';
import '../readiness/staging_readiness_screen.dart';

class AdminGovernanceConsoleScreen extends ConsumerWidget {
  const AdminGovernanceConsoleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const DefaultTabController(
      length: 4,
      child: Column(
        children: [
          TabBar(
            tabs: [
              Tab(icon: Icon(Icons.tune_outlined), text: 'إدارة يومية'),
              Tab(icon: Icon(Icons.policy_outlined), text: 'الحوكمة'),
              Tab(icon: Icon(Icons.extension_outlined), text: 'الإدماج'),
              Tab(icon: Icon(Icons.rule_folder_outlined), text: 'Staging/UAT'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _DailyAdminPanel(),
                GovernanceScreen(),
                PlatformIntegrationReadinessScreen(),
                _ReadinessGovernanceSubpage(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DailyAdminPanel extends ConsumerWidget {
  const _DailyAdminPanel();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final local = ref.watch(localOperationalProvider);
    final integration = ref.watch(archivePlatformIntegrationProvider);
    final controller = ref.read(archivePlatformIntegrationProvider.notifier);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('الإدارة اليومية للنظام',
            style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        const Text(
            'هذه الصفحة تجمع إعدادات التشغيل اليومي: التصنيفات، السياسات، قوائم المراجعة، وحالة الصحة. تفاصيل الحوكمة والإدماج داخل تبويبات فرعية.'),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            MetricTile(
              icon: Icons.policy_outlined,
              label: 'سياسات إدارية',
              value: local.policies.length.toString(),
            ),
            MetricTile(
              icon: Icons.flag_outlined,
              label: 'Feature Flags',
              value: integration.featureFlags.length.toString(),
            ),
            MetricTile(
              icon: Icons.health_and_safety_outlined,
              label: 'حالة الصحة',
              value: integration.health.status.label,
            ),
          ],
        ),
        const SizedBox(height: 12),
        SectionCard(
          icon: Icons.category_outlined,
          title: 'إعدادات التصنيف اليومية',
          children: const [
            KeyValueLine(
                label: 'الإدارات',
                value:
                    'قانونية، أملاك، مالية، مشاريع، موارد بشرية، GIS، معرفة.'),
            KeyValueLine(
                label: 'الموضوعات',
                value: 'ملكية، مراسلات، خرائط، تسوية، قضايا، مالية، مشاريع.'),
            KeyValueLine(
                label: 'أنواع الوثائق',
                value: 'قرار، كتاب، قوشان، شهادة، خريطة، صورة، محضر، PDF.'),
            KeyValueLine(
                label: 'مستويات الإتاحة',
                value: 'داخلي، وحدة فقط، مقيد، مرشح نشر عام.'),
          ],
        ),
        const SizedBox(height: 12),
        SectionCard(
          icon: Icons.rule_outlined,
          title: 'السياسات الإدارية',
          children: [
            for (final policy in local.policies) _PolicyTile(policy: policy),
          ],
        ),
        const SizedBox(height: 12),
        SectionCard(
          icon: Icons.power_settings_new_outlined,
          title: 'Health / Fallback / Kill Switch',
          subtitle: 'اختبارات محلية فقط. لا تتحكم في منصة PalWakf.',
          children: [
            Text(integration.health.summaryAr),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton.tonalIcon(
                  onPressed: controller.simulateDegradedMode,
                  icon: const Icon(Icons.warning_amber_outlined),
                  label: const Text('محاكاة Degraded'),
                ),
                FilledButton.tonalIcon(
                  onPressed: controller.simulateDisabledMode,
                  icon: const Icon(Icons.extension_off_outlined),
                  label: const Text('تعطيل محلي'),
                ),
                FilledButton.icon(
                  onPressed: controller.restoreLocalMode,
                  icon: const Icon(Icons.restart_alt_outlined),
                  label: const Text('استعادة محلية'),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        SectionCard(
          icon: Icons.history_toggle_off_outlined,
          title: 'Audit Trace محلي مؤقت',
          subtitle: 'ليس Audit Trail مركزيًا ولا يحفظ خارج الجلسة.',
          children: [
            if (integration.localAuditTrail.isEmpty)
              const Text('لا توجد أحداث تكامل محلية بعد.')
            else
              for (final event in integration.localAuditTrail)
                ListTile(
                  leading: const Icon(Icons.receipt_long_outlined),
                  title: Text(event.eventType),
                  subtitle:
                      Text('${event.summaryAr}\n${event.at.toIso8601String()}'),
                  isThreeLine: true,
                ),
          ],
        ),
      ],
    );
  }
}

class _ReadinessGovernanceSubpage extends StatelessWidget {
  const _ReadinessGovernanceSubpage();

  @override
  Widget build(BuildContext context) {
    return const DefaultTabController(
      length: 3,
      child: Column(
        children: [
          TabBar(
            tabs: [
              Tab(text: 'Staging'),
              Tab(text: 'Controlled UAT'),
              Tab(text: 'Production Readiness'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                StagingReadinessScreen(),
                ControlledUatScreen(),
                ProductionReadinessScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PolicyTile extends StatelessWidget {
  const _PolicyTile({required this.policy});

  final AdministrativePolicy policy;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.policy_outlined),
        title: Text(policy.title),
        subtitle: Text('${policy.ownerRole}\n${policy.summary}'),
        isThreeLine: true,
        trailing: StatusPill(label: policy.status.label),
      ),
    );
  }
}
