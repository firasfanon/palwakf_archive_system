# Session Handoff — Public Home Catalog Landing and Dev Login Workspace Gate

## Batch

`MEGA_BATCH_ARCHIVE_PUBLIC_HOME_CATALOG_LANDING_AND_DEV_LOGIN_WORKSPACE_GATE_V1`

## Parent baseline

`PALWAKF_ARCHIVE_PRODUCTIVE_DOCUMENT_DETAIL_ADD_FLOW_TEST_CONTRACT_REPAIR_20260714_BASELINE`

## Implemented

- Public landing page as the first app screen.
- Header, top nav labels, hero, catalog cards, capability section, workspace access section, footer.
- Development-login gate without credentials.
- Workspace shell mounts only after dev login.
- Operational sidebar remains unavailable on public home.
- Publication remains blocked before human approval.

## Files

- `lib/src/app.dart`
- `lib/src/features/public/public_archive_landing_screen.dart`
- `test/public_home_workspace_gate_test.dart`
- `tools/verify_module_reception_static.py`
- `docs/ARCHIVE_PUBLIC_HOME_CATALOG_LANDING_AND_DEV_LOGIN_WORKSPACE_GATE_V1.md`

## Static verification in packaging environment

`python tools/verify_module_reception_static.py = PASS`

New gates:

```text
PUBLIC_HOME_LANDING_PAGE=PASS
ARCHIVE_CATALOG_CARDS_VISIBLE=PASS
HERO_HEADER_FOOTER_NAV_VISIBLE=PASS
DEV_LOGIN_WITHOUT_CREDENTIALS=PASS
WORKSPACE_REQUIRES_DEV_LOGIN_ENTRY=PASS
SIDEBAR_NOT_ON_PUBLIC_HOME=PASS
NO_REAL_AUTH_BACKEND=PASS
NO_PUBLICATION_FROM_PUBLIC_HOME=PASS
```

## Required local verification

```powershell
cd C:\Users\DELL\StudioProjects\archive_system
python tools\verify_module_reception_static.py
flutter pub get
dart format lib test
flutter analyze
flutter test
flutter run -d chrome --target lib/main.dart
```

## Governance

```text
PALWAKF_REMOTE_INTEGRATION=NOT_CONNECTED_BY_DESIGN
STAGING_APPROVAL=NOT_APPROVED
PRODUCTION_APPROVAL=NOT_APPROVED
```
