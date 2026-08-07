# Updates Only Apply Instructions — UI/UX Grouped Sidebar Refocus

Apply over parent baseline:

`PALWAKF_ARCHIVE_ACCESS_PUBLICATION_RETENTION_AUDIT_20260713_BASELINE`

PowerShell:

```powershell
cd C:\Users\DELL\StudioProjects\archive_system
# extract updates-only zip over the project root, preserving paths
python tools\verify_module_reception_static.py
flutter pub get
dart format lib test
flutter analyze
flutter test
flutter run -d chrome --target lib/main.dart
```

Expected static markers:

```text
SIDEBAR_GROUPED_BY_USAGE=PASS
GOVERNANCE_IS_ADMIN_SUBPAGE_ONLY=PASS
DAILY_UX_PRIMARY_NAVIGATION=PASS
DOCUMENT_PRODUCTIVE_PAGES=PASS
ADD_DOCUMENT_FLOW_VISIBLE=PASS
DOCUMENT_DETAIL_TABS_VISIBLE=PASS
NO_GOVERNANCE_FIRST_EXPERIENCE=PASS
```
