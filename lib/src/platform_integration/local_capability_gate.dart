import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'archive_platform_integration.dart';
import 'contracts.dart';

/// Applies the local mock capability decision before a session-only mutation.
/// The production host must replace this with server-enforced capability
/// binding; this helper never represents a production authorization decision.
bool requireLocalCapability(
  BuildContext context,
  WidgetRef ref, {
  required ArchiveCapability capability,
  required String actionLabel,
}) {
  final decision =
      ref.read(archivePlatformIntegrationProvider.notifier).authorize(
            CapabilityRequest(
              capability: capability,
              targetUnitKey: localDevelopmentUnitKey,
              actionLabel: actionLabel,
            ),
          );

  if (decision.allowed) {
    return true;
  }

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('تم رفض الإجراء المحلي: ${decision.reasonAr}')),
  );
  return false;
}
