import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('sidebar is grouped by daily usage categories', () {
    final app = File('lib/src/app.dart').readAsStringSync();

    expect(app.contains('SIDEBAR_GROUPED_BY_USAGE'), isTrue);
    expect(app.contains('DAILY_UX_PRIMARY_NAVIGATION'), isTrue);
    expect(app.contains('NO_GOVERNANCE_FIRST_EXPERIENCE'), isTrue);
    expect(app.contains('class _NavigationGroup'), isTrue);
    expect(app.contains('class _NavigationGroupTile'), isTrue);
    expect(app.contains('SIDEBAR_LIST_MATERIAL_BOUNDARY'), isTrue);
    expect(
        app.contains('NAVIGATION_GROUP_EXPANSION_MATERIAL_BOUNDARY'), isTrue);
    expect(app.contains('CUSTOM_NAVIGATION_GROUP_TILE'), isTrue);
    expect(app.contains('ExpansionTile('), isFalse);
    expect(app.contains('مساحة العمل اليومية'), isTrue);
    expect(app.contains('تنظيم الأرشيف'), isTrue);
    expect(app.contains('المراجعة والاعتماد'), isTrue);
    expect(app.contains('الاستكشاف والبحث'), isTrue);
    expect(app.contains('التقارير والتشغيل'), isTrue);
    expect(app.contains('الإدارة'), isTrue);
  });

  test('governance remains an administration subpage only', () {
    final app = File('lib/src/app.dart').readAsStringSync();

    expect(app.contains('GOVERNANCE_IS_ADMIN_SUBPAGE_ONLY'), isTrue);
    expect(app.contains('ADMIN_GROUP_START'), isTrue);
    expect(app.contains('GOVERNANCE_ADMIN_SUBPAGE_ENTRY'), isTrue);
    expect(app.contains('الحوكمة والتكامل'), isTrue);

    final adminGroupStart = app.indexOf('ADMIN_GROUP_START');
    final governanceEntry = app.indexOf('GOVERNANCE_ADMIN_SUBPAGE_ENTRY');
    final appShellGroupsEnd =
        app.indexOf('static final _entries', adminGroupStart);

    expect(adminGroupStart, isNot(-1));
    expect(governanceEntry, greaterThan(adminGroupStart));
    expect(appShellGroupsEnd, greaterThan(governanceEntry));
    expect(
        app.contains(RegExp(r"_NavigationEntry\s*\(\s*'governance'")), isTrue);
  });

  test('productive document surfaces and add document flow are visible', () {
    final app = File('lib/src/app.dart').readAsStringSync();
    final addDocument = File('lib/src/features/daily/add_document_screen.dart')
        .readAsStringSync();

    expect(app.contains('DOCUMENT_PRODUCTIVE_PAGES'), isTrue);
    expect(app.contains('ADD_DOCUMENT_FLOW_VISIBLE'), isTrue);
    expect(app.contains('DOCUMENT_DETAIL_TABS_VISIBLE'), isTrue);
    expect(app.contains('AddDocumentScreen'), isTrue);
    expect(addDocument.contains('class AddDocumentScreen'), isTrue);
    expect(addDocument.contains('حفظ وثيقة محليًا'), isTrue);
    expect(addDocument.contains('createGovernedDocumentDraft'), isTrue);
  });
}
