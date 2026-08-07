import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('public home catalog landing and dev login workspace gate are present',
      () {
    final app = File('lib/src/app.dart').readAsStringSync();
    final publicHome =
        File('lib/src/features/public/public_archive_landing_screen.dart')
            .readAsStringSync();

    expect(publicHome.contains('PUBLIC_HOME_LANDING_PAGE'), isTrue);
    expect(publicHome.contains('PUBLIC_HOME_APPROVED_VISUAL_DESIGN'), isTrue);
    expect(
        publicHome.contains('PUBLIC_HOME_APPROVED_REFERENCE_SCREEN'), isTrue);
    expect(publicHome.contains('PUBLIC_HOME_EXACT_CATALOG_CARD_GRID'), isTrue);
    expect(
        publicHome.contains('APPROVED_HERITAGE_HERO_IMAGE_TREATMENT'), isTrue);
    expect(publicHome.contains('PUBLIC_HOME_TECHNOLOGY_STRIP'), isTrue);
    expect(publicHome.contains('APPROVED_CATALOG_CARD_GRID'), isTrue);
    expect(publicHome.contains('HERO_HEADER_FOOTER_NAV_VISIBLE'), isTrue);
    expect(publicHome.contains('ARCHIVE_CATALOG_CARDS_VISIBLE'), isTrue);
    expect(publicHome.contains('DEV_LOGIN_WITHOUT_CREDENTIALS'), isTrue);
    expect(publicHome.contains('NO_PUBLICATION_FROM_PUBLIC_HOME'), isTrue);
    expect(publicHome.contains('الأرشيف العثماني'), isTrue);
    expect(publicHome.contains('الأرشيف البريطاني / الإنجليزي'), isTrue);
    expect(publicHome.contains('الأرشيف الأردني'), isTrue);
    expect(publicHome.contains('الأرشيف الفلسطيني'), isTrue);
    expect(publicHome.contains('تسجيل الدخول إلى مساحة العمل'), isTrue);
    expect(publicHome.contains('تقنيات متقدمة لخدمة التراث'), isTrue);
    expect(publicHome.contains('أرشيف الوقف الفلسطيني'), isTrue);
    expect(publicHome.contains('class _HeritageHeroPainter'), isTrue);
    expect(publicHome.contains('class _PublicFooter'), isTrue);
    expect(publicHome.contains('TextField('), isFalse);
    expect(publicHome.contains('TextFormField('), isFalse);
    expect(app.contains('class _ArchiveEntryGate'), isTrue);
    expect(app.contains('WORKSPACE_REQUIRES_DEV_LOGIN_ENTRY'), isTrue);
    expect(app.contains('SIDEBAR_NOT_ON_PUBLIC_HOME'), isTrue);
    expect(app.contains('NO_REAL_AUTH_BACKEND'), isTrue);
    expect(app.contains('home: const _ArchiveEntryGate()'), isTrue);
  });
}
