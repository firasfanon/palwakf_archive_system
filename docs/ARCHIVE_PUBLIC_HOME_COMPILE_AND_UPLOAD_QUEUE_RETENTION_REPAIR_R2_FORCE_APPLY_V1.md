# ARCHIVE Public Home Compile + Upload Queue Retention Repair R2 Force Apply V1

## Purpose
Force-apply the corrected public home screen and preserve the Upload & Representations queue after the previous package was not reflected in the active project files.

## Fixes
- Removes invalid `Container(minHeight: 300)` API usage.
- Uses `constraints: const BoxConstraints(minHeight: 300)`.
- Restores Upload & Representations local queue files and tests.
- Adds a top-level PowerShell apply script to prevent nested `archive_system\archive_system` extraction mistakes.

## Boundaries
- No remote integration.
- No staging approval.
- No production approval.
- No real Auth backend.
- No publication from the public home.
