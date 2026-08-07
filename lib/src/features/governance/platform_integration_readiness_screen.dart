import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../platform_integration/archive_platform_integration.dart';
import '../../platform_integration/contracts.dart';
import '../../shared/widgets.dart';

class PlatformIntegrationReadinessScreen extends ConsumerWidget {
  const PlatformIntegrationReadinessScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(archivePlatformIntegrationProvider);
    final controller = ref.read(archivePlatformIntegrationProvider.notifier);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'جاهزية الإدماج المنصي',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        const LocalOnlyBanner(),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SelectableText(
              'MODULE_ID=${state.systemContext.moduleId}\n'
              'MODULE_VERSION=${state.systemContext.moduleVersion}\n'
              'LIFECYCLE_MODE=${state.systemContext.lifecycleMode}\n'
              'PLATFORM_HOST=${state.systemContext.platformHost}\n'
              'LOCAL_DEVELOPMENT_HOST=${state.systemContext.isLocalDevelopmentHost}\n'
              'PLATFORM_BOUND=${state.isPlatformBound}\n'
              'PRODUCTION_APPROVAL=NOT_IMPLIED',
            ),
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _ReadinessCard(
              icon: Icons.extension_outlined,
              label: 'Adapter Boundary',
              status: 'PASS',
              description: 'عقود نظام ووحدة وسلطة وFeature Flag مستقلة.',
            ),
            _ReadinessCard(
              icon: Icons.account_tree_outlined,
              label: 'Unit Scope',
              status: 'LOCAL MOCK',
              description:
                  'الوحدة ${state.unitContext.currentUnitKey} فقط؛ الإنفاذ الخادمي مطلوب عند الربط.',
            ),
            _ReadinessCard(
              icon: Icons.health_and_safety_outlined,
              label: 'Module Health',
              status: state.health.status.label,
              description: state.health.summaryAr,
            ),
            const _ReadinessCard(
              icon: Icons.folder_off_outlined,
              label: 'File Center',
              status: 'BLOCKED',
              description:
                  'لا تخزين أو URLs أو file objects قبل binding منصي معتمد.',
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          'اختبار العزل المحلي',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        const Text(
          'الأزرار التالية محاكاة fixture لا تغيّر سجل المنصة أو الحالة الإنتاجية. الهدف إثبات وجود kill switch وfallback قبل الاستضافة.',
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            OutlinedButton.icon(
              onPressed: controller.simulateDegradedMode,
              icon: const Icon(Icons.warning_amber_outlined),
              label: const Text('محاكاة Degraded'),
            ),
            OutlinedButton.icon(
              onPressed: controller.simulateDisabledMode,
              icon: const Icon(Icons.power_settings_new_outlined),
              label: const Text('محاكاة تعطيل'),
            ),
            FilledButton.icon(
              onPressed: controller.restoreLocalMode,
              icon: const Icon(Icons.restart_alt_outlined),
              label: const Text('استعادة المضيف المحلي'),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          'آخر أحداث الاختبار المحلية',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        if (state.localAuditTrail.isEmpty)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child:
                  Text('لا توجد أحداث بعد. لا يتم تخزين أي تدقيق محلي دائم.'),
            ),
          )
        else
          Card(
            child: Column(
              children: [
                for (final event in state.localAuditTrail.take(8))
                  ListTile(
                    leading: const Icon(Icons.receipt_long_outlined),
                    title: Text(event.eventType),
                    subtitle: Text(
                      '${event.summaryAr}\n${_formatDate(event.at)}',
                    ),
                    isThreeLine: true,
                  ),
              ],
            ),
          ),
      ],
    );
  }

  String _formatDate(DateTime value) {
    return '${value.year}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')} '
        '${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}';
  }
}

class ModuleFallbackScreen extends ConsumerWidget {
  const ModuleFallbackScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(archivePlatformIntegrationProvider);
    final controller = ref.read(archivePlatformIntegrationProvider.notifier);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.extension_off_outlined, size: 56),
                  const SizedBox(height: 16),
                  Text(
                    'الموديول المحلي غير متاح',
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    state.health.fallbackMessageAr,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 18),
                  FilledButton.icon(
                    onPressed: controller.restoreLocalMode,
                    icon: const Icon(Icons.restart_alt_outlined),
                    label: const Text('استعادة المحاكاة المحلية'),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'لا توجد مصادقة أو كتابة بيانات أو file storage أو تغيير منصي في هذا المسار.',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ReadinessCard extends StatelessWidget {
  const _ReadinessCard({
    required this.icon,
    required this.label,
    required this.status,
    required this.description,
  });

  final IconData icon;
  final String label;
  final String status;
  final String description;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 245,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon),
              const SizedBox(height: 12),
              Text(label, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              StatusPill(label: status),
              const SizedBox(height: 8),
              Text(description),
            ],
          ),
        ),
      ),
    );
  }
}
