import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/models.dart';
import '../../core/state/local_operational_store.dart';
import '../../shared/widgets.dart';

class AccessPublicationRetentionAuditScreen extends ConsumerWidget {
  const AccessPublicationRetentionAuditScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(localOperationalProvider);
    final controller = ref.read(localOperationalProvider.notifier);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('الإتاحة والنشر والاحتفاظ والتدقيق',
            style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        const LocalOnlyBanner(),
        const SizedBox(height: 12),
        const Text(
          'ACCESS_PUBLICATION_RETENTION_AUDIT_OPERATIONALIZATION: تشغيل محلي لمصفوفة الإتاحة، طلبات النشر، سياسات الاحتفاظ، وسجل التدقيق. لا توجد بوابة عامة، لا حذف، ولا كتابة خارج ذاكرة الجلسة.',
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            MetricTile(
              icon: Icons.policy_outlined,
              label: 'سياسات إتاحة',
              value: '${state.accessPolicies.length}',
            ),
            MetricTile(
              icon: Icons.public_off_outlined,
              label: 'طلبات إتاحة معلقة',
              value: '${state.pendingPublicationRequestCount}',
            ),
            MetricTile(
              icon: Icons.event_repeat_outlined,
              label: 'قواعد احتفاظ نشطة',
              value: '${state.activeRetentionRuleCount}',
            ),
            MetricTile(
              icon: Icons.receipt_long_outlined,
              label: 'أحداث تدقيق',
              value: '${state.auditTrailCount}',
            ),
          ],
        ),
        const SizedBox(height: 12),
        _AccessPoliciesSection(policies: state.accessPolicies),
        const SizedBox(height: 12),
        _PublicationQueueSection(
          evidence: state.evidence,
          requests: state.publicationRequests,
          onRequest: controller.requestPublicationReview,
          onApprove: controller.approvePublicationRequest,
          onRestrict: controller.restrictPublicationRequest,
          onAuditRead: (id) => controller.recordAccessAudit(
              id, 'تسجيل قراءة حساسة من صفحة الإتاحة'),
        ),
        const SizedBox(height: 12),
        _RetentionSection(
          rules: state.retentionRules,
          onReview: controller.markRetentionReview,
        ),
        const SizedBox(height: 12),
        _AuditTrailSection(entries: state.auditTrail),
      ],
    );
  }
}

class _AccessPoliciesSection extends StatelessWidget {
  const _AccessPoliciesSection({required this.policies});

  final List<AccessPolicyRule> policies;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      icon: Icons.admin_panel_settings_outlined,
      title: 'مصفوفة الإتاحة والصلاحيات',
      subtitle:
          'ACCESS_POLICY_MATRIX_LOCAL: قراءة محلية لنموذج RBAC + Unit Scope + Access Level، وليست مصدر صلاحيات إنتاجي.',
      children: [
        if (policies.isEmpty)
          const EmptyState(message: 'لا توجد سياسات إتاحة محلية.')
        else
          for (final policy in policies)
            Card(
              child: ListTile(
                leading: const Icon(Icons.verified_user_outlined),
                title: Text(policy.title),
                subtitle: Text(
                  '${policy.role}\n${policy.scopeSummary}\nالمستويات: ${policy.allowedAccessLevels.map((item) => item.label).join('، ')}',
                ),
                isThreeLine: true,
                trailing: StatusPill(label: policy.status),
              ),
            ),
      ],
    );
  }
}

class _PublicationQueueSection extends StatefulWidget {
  const _PublicationQueueSection({
    required this.evidence,
    required this.requests,
    required this.onRequest,
    required this.onApprove,
    required this.onRestrict,
    required this.onAuditRead,
  });

  final List<EvidenceItem> evidence;
  final List<PublicationRequest> requests;
  final ValueChanged<String> onRequest;
  final ValueChanged<String> onApprove;
  final ValueChanged<String> onRestrict;
  final ValueChanged<String> onAuditRead;

  @override
  State<_PublicationQueueSection> createState() =>
      _PublicationQueueSectionState();
}

class _PublicationQueueSectionState extends State<_PublicationQueueSection> {
  String? _selectedEvidenceId;

  @override
  void didUpdateWidget(covariant _PublicationQueueSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_selectedEvidenceId != null &&
        !widget.evidence.any((item) => item.id == _selectedEvidenceId)) {
      _selectedEvidenceId = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final selected = _selectedEvidenceId ??
        (widget.evidence.isEmpty ? null : widget.evidence.first.id);

    return SectionCard(
      icon: Icons.campaign_outlined,
      title: 'طلبات الإتاحة والنشر الداخلي',
      subtitle:
          'PUBLICATION_REVIEW_QUEUE_LOCAL: اعتماد محلي يغيّر مستوى الإتاحة فقط؛ لا public route ولا نشر خارجي.',
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 12,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SizedBox(
              width: 420,
              child: DropdownButtonFormField<String>(
                initialValue: selected,
                decoration:
                    const InputDecoration(labelText: 'وثيقة لطلب الإتاحة'),
                items: [
                  for (final item in widget.evidence)
                    DropdownMenuItem(value: item.id, child: Text(item.title)),
                ],
                onChanged: (value) =>
                    setState(() => _selectedEvidenceId = value),
              ),
            ),
            FilledButton.icon(
              onPressed:
                  selected == null ? null : () => widget.onRequest(selected),
              icon: const Icon(Icons.add_task_outlined),
              label: const Text('طلب مراجعة إتاحة'),
            ),
            OutlinedButton.icon(
              onPressed:
                  selected == null ? null : () => widget.onAuditRead(selected),
              icon: const Icon(Icons.visibility_outlined),
              label: const Text('تسجيل قراءة حساسة'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (widget.requests.isEmpty)
          const EmptyState(message: 'لا توجد طلبات إتاحة محلية.')
        else
          for (final request in widget.requests)
            Card(
              child: ListTile(
                leading: const Icon(Icons.public_off_outlined),
                title: Text(request.title),
                subtitle: Text(
                  '${request.evidenceId}\nالمستوى المطلوب: ${request.requestedAccessLevel.label}\n${request.reason}',
                ),
                isThreeLine: true,
                trailing: Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    StatusPill(label: request.status),
                    FilledButton.tonalIcon(
                      onPressed: request.status == 'معتمد محليًا'
                          ? null
                          : () => widget.onApprove(request.id),
                      icon: const Icon(Icons.verified_outlined),
                      label: const Text('اعتماد'),
                    ),
                    OutlinedButton.icon(
                      onPressed: request.status == 'مقيّد محليًا'
                          ? null
                          : () => widget.onRestrict(request.id),
                      icon: const Icon(Icons.lock_outline),
                      label: const Text('تقييد'),
                    ),
                  ],
                ),
              ),
            ),
      ],
    );
  }
}

class _RetentionSection extends StatelessWidget {
  const _RetentionSection({required this.rules, required this.onReview});

  final List<RetentionRule> rules;
  final ValueChanged<String> onReview;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      icon: Icons.event_repeat_outlined,
      title: 'سياسات الاحتفاظ والمراجعة الدورية',
      subtitle:
          'RETENTION_SCHEDULE_LOCAL: مراجعة سياسة احتفاظ محلية فقط؛ لا حذف ولا إتلاف ولا قرار قانوني.',
      children: [
        if (rules.isEmpty)
          const EmptyState(message: 'لا توجد قواعد احتفاظ محلية.')
        else
          for (final rule in rules)
            Card(
              child: ListTile(
                leading: const Icon(Icons.inventory_2_outlined),
                title: Text(rule.title),
                subtitle: Text(
                  '${rule.evidenceId}\n${rule.retentionLabel} — ${rule.reviewDateLabel}\n${rule.dispositionAction}',
                ),
                isThreeLine: true,
                trailing: Wrap(
                  spacing: 6,
                  children: [
                    StatusPill(label: rule.status),
                    OutlinedButton.icon(
                      onPressed: () => onReview(rule.id),
                      icon: const Icon(Icons.fact_check_outlined),
                      label: const Text('مراجعة'),
                    ),
                  ],
                ),
              ),
            ),
      ],
    );
  }
}

class _AuditTrailSection extends StatelessWidget {
  const _AuditTrailSection({required this.entries});

  final List<AuditTrailEntry> entries;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      icon: Icons.receipt_long_outlined,
      title: 'سجل التدقيق المحلي',
      subtitle:
          'AUDIT_TRAIL_LOCAL: سجل append-only داخل الذاكرة للتدريب على تتبع القراءة والتعديل والإتاحة.',
      children: [
        if (entries.isEmpty)
          const EmptyState(message: 'لا توجد أحداث تدقيق محلية.')
        else
          for (final entry in entries.take(12))
            ListTile(
              leading: const Icon(Icons.history_outlined),
              title: Text(entry.action),
              subtitle: Text(
                  '${entry.targetId}\n${entry.outcome}\n${_formatDate(entry.createdAt)}'),
              isThreeLine: true,
              trailing: Text(entry.actorLabel),
            ),
      ],
    );
  }
}

String _formatDate(DateTime value) {
  final local = value.toLocal();
  return '${local.year}-${local.month.toString().padLeft(2, '0')}-${local.day.toString().padLeft(2, '0')} '
      '${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
}
