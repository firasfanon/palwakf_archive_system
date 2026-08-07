# MEGA_BATCH_ARCHIVE_PUBLIC_HOME_CATALOG_LANDING_AND_DEV_LOGIN_WORKSPACE_GATE_V1 — Approved Visual Alignment V1.0.1

## Purpose

Align the public archive landing page with the approved visual concept: a public-facing archive gateway with hero, header, catalog cards, technology section, footer, and development-login entry to the internal workspace.

## Scope

- Public landing page only.
- Workspace gate remains local and temporary.
- No username/password fields.
- No real auth backend.
- Sidebar stays inside the workspace only.
- No publication path from public home.

## UI alignment

- White header with brand, top navigation, and login button.
- Large archival hero with historical/document texture treatment.
- Catalog cards for:
  - الأرشيف العثماني
  - الأرشيف البريطاني / الإنجليزي
  - الأرشيف الأردني
  - الأرشيف الفلسطيني
- Section: تقنيات متقدمة لخدمة التراث.
- Footer with institutional links and social placeholders.

## Guards

```text
PUBLIC_HOME_LANDING_PAGE=PASS
PUBLIC_HOME_APPROVED_VISUAL_DESIGN=PASS
ARCHIVE_CATALOG_CARDS_VISIBLE=PASS
APPROVED_CATALOG_CARD_GRID=PASS
HERO_HEADER_FOOTER_NAV_VISIBLE=PASS
DEV_LOGIN_WITHOUT_CREDENTIALS=PASS
WORKSPACE_REQUIRES_DEV_LOGIN_ENTRY=PASS
SIDEBAR_NOT_ON_PUBLIC_HOME=PASS
NO_REAL_AUTH_BACKEND=PASS
NO_PUBLICATION_FROM_PUBLIC_HOME=PASS
```
