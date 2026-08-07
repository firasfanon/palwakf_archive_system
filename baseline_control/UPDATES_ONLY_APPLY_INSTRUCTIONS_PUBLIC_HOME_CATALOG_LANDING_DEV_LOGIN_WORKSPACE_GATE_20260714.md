# Updates-only apply instructions

Target local project:

```powershell
C:\Users\DELL\StudioProjects\archive_system
```

Apply this updates-only package by copying its content over the project root, preserving relative paths.

Then run:

```powershell
cd C:\Users\DELL\StudioProjects\archive_system
python tools\verify_module_reception_static.py
flutter pub get
dart format lib test
flutter analyze
flutter test
flutter run -d chrome --target lib/main.dart
```

Acceptance requires:

```text
PUBLIC_HOME_LANDING_PAGE=PASS
ARCHIVE_CATALOG_CARDS_VISIBLE=PASS
HERO_HEADER_FOOTER_NAV_VISIBLE=PASS
DEV_LOGIN_WITHOUT_CREDENTIALS=PASS
WORKSPACE_REQUIRES_DEV_LOGIN_ENTRY=PASS
SIDEBAR_NOT_ON_PUBLIC_HOME=PASS
NO_REAL_AUTH_BACKEND=PASS
NO_PUBLICATION_FROM_PUBLIC_HOME=PASS
flutter analyze=PASS
flutter test=PASS
flutter run=PASS
```
