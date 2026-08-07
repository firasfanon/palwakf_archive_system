# MEGA_BATCH_ARCHIVE_TRUE_VISUAL_ART_DIRECTION_PREMIUM_UI_REBUILD_RUNTIME_OVERFLOW_CLEANUP_R2_V1

## Purpose

Repair the premium public landing runtime gate after local UAT exposed a `RenderFlex overflowed by 8.0 pixels on the bottom` in `_PremiumCatalogCard`, and remove analyzer warnings for unused public landing palette constants.

## Changes

- Increase premium catalog card height from `360` to `392`.
- Bound catalog era/title/description text with `maxLines` and `TextOverflow.ellipsis`.
- Use `_oldGold` for the Jordanian catalog tint.
- Use `_warmPaper` in the catalog section gradient.
- Add static gates:
  - `PREMIUM_CATALOG_CARD_OVERFLOW_REPAIR`
  - `PREMIUM_VISUAL_ANALYZE_CLEANUP`

## Boundaries

No remote integration, no staging, no production, no database mutation, no public publication.

## Required local gates

```text
python toolserify_module_reception_static.py
flutter pub get
dart format lib test
flutter analyze
flutter test
flutter run -d chrome --target lib/main.dart
```

Acceptance requires `flutter analyze=PASS`, `flutter test=PASS`, and no runtime RenderFlex overflow in Chrome.
