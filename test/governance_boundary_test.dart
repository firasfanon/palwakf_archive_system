import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('local source does not contain forbidden platform-auth markers', () {
    final sourceRoot = Directory('lib');
    final sources = sourceRoot
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart'));

    final combined = sources.map((file) => file.readAsStringSync()).join('\n');
    const forbidden = [
      'Supabase.initialize(',
      'service_role',
      'signInWithPassword',
      'platform_access.admin_users',
    ];

    for (final marker in forbidden) {
      expect(combined.contains(marker), isFalse, reason: marker);
    }
  });
}
