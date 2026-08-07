# ARCHIVE PUBLIC HOME EXACT APPROVED SCREEN REBUILD V1

Batch: `MEGA_BATCH_ARCHIVE_PUBLIC_HOME_CATALOG_LANDING_AND_DEV_LOGIN_WORKSPACE_GATE_EXACT_SCREEN_REBUILD_V1`

## Purpose

Rebuild the public homepage to follow the approved visual reference as closely as possible in Flutter without external assets or real authentication.

## Implemented surface

- White header with PalWakf Archive brand and RTL top navigation.
- Development login CTA.
- Heritage hero treatment inspired by Jerusalem/waqf landmarks and manuscript imagery.
- Catalog card grid for Ottoman, British/English, Jordanian, and Palestinian archive catalogs.
- Technology strip: AI, spatial/temporal linking, translation/investigation, secure preservation, advanced search.
- Access CTA clarifying draft-development intake and no publication before human approval.
- Green footer.

## Boundaries

- No Auth backend.
- No username/password.
- No publication from public home.
- No remote, staging, or production connection.

## Guards

- `PUBLIC_HOME_APPROVED_REFERENCE_SCREEN=PASS`
- `APPROVED_HERITAGE_HERO_IMAGE_TREATMENT=PASS`
- `PUBLIC_HOME_EXACT_CATALOG_CARD_GRID=PASS`
- `PUBLIC_HOME_TECHNOLOGY_STRIP=PASS`
