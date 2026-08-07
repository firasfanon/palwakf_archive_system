import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('daily user experience pages are first-class surfaces', () {
    final app = File('lib/src/app.dart').readAsStringSync();
    final dailyRoot = Directory('lib/src/features/daily');
    final dailyFiles = dailyRoot
        .listSync()
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart'))
        .map((file) => file.path)
        .toSet();

    expect(app.contains('DAILY_USER_EXPERIENCE_FIRST'), isTrue);
    expect(app.contains('GOVERNANCE_SUBPAGE_ONLY'), isTrue);
    expect(dailyFiles.length >= 9, isTrue);
    expect(app.contains('DailyArchiveHomeScreen'), isTrue);
    expect(app.contains('DocumentClassificationScreen'), isTrue);
    expect(app.contains('UploadStorageScreen'), isTrue);
    expect(app.contains('SmartSearchMechanismScreen'), isTrue);
    expect(app.contains('SecurityBackupScreen'), isTrue);
    expect(app.contains('TechnicalBlueprintScreen'), isTrue);
  });

  test('governance staging and production are not primary navigation labels',
      () {
    final app = File('lib/src/app.dart').readAsStringSync();

    expect(
        app.contains("_NavigationItem(Icons.rule_folder_outlined, 'Staging')"),
        isFalse);
    expect(
        app.contains(
            "_NavigationItem(Icons.security_outlined, 'Controlled UAT')"),
        isFalse);
    expect(
        app.contains(
            "_NavigationItem(Icons.verified_user_outlined, 'Production Readiness')"),
        isFalse);
  });
}
