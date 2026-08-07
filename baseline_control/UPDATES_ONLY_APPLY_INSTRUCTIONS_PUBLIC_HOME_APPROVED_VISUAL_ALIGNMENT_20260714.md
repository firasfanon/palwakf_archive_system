# Apply Instructions — Public Home Approved Visual Alignment V1.0.1

Apply over the current local project root:

```powershell
cd C:\Users\DELL\StudioProjects\archive_system
```

Copy the files from this updates-only package into the matching project paths, replacing existing files.

Then verify:

```powershell
python tools\verify_module_reception_static.py
flutter pub get
dart format lib test
flutter analyze
flutter test
flutter run -d chrome --target lib/main.dart
```

Expected static guards include:

```text
PUBLIC_HOME_APPROVED_VISUAL_DESIGN=PASS
APPROVED_CATALOG_CARD_GRID=PASS
DEV_LOGIN_WITHOUT_CREDENTIALS=PASS
SIDEBAR_NOT_ON_PUBLIC_HOME=PASS
NO_REAL_AUTH_BACKEND=PASS
NO_PUBLICATION_FROM_PUBLIC_HOME=PASS
```
