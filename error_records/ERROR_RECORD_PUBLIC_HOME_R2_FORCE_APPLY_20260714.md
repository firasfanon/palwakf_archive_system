# Error Record — Public Home R2 Force Apply

## Observed
- Flutter compile still found `Container(minHeight: 300)` after prior repair package.
- Upload representation queue test still failed.

## Root cause
The corrected files were not reflected in the active project tree, likely due to applying the zip at the wrong level or from an older package.

## Repair
A top-level force-apply PowerShell script now copies the corrected files into the active project root and verifies the compile fix and upload queue markers.
