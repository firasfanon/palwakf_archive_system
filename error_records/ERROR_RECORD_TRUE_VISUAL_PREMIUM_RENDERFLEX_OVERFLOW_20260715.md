# Error Record — Premium Public Catalog RenderFlex Overflow

## Symptom

Chrome runtime reported:

```text
A RenderFlex overflowed by 8.0 pixels on the bottom.
creator: Column ← Padding ← Stack ... _PremiumCatalogCard
```

Flutter analyze also reported unused fields `_oldGold` and `_warmPaper`.

## Root cause

Premium catalog card content exceeded the fixed 360 height at the active desktop width and text scale. Two palette constants were declared but not consumed.

## Repair

- Increase card height to 392.
- Bound catalog text with maxLines and ellipsis.
- Use `_oldGold` and `_warmPaper` in active visual styling.

## Status

Static package verification passed. Awaiting local Flutter analyze/test/run gates.
