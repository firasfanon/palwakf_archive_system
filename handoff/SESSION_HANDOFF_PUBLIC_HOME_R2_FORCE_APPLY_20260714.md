# Session Handoff — Public Home R2 Force Apply

Use this package only to force correct active files after compile/test regressions from public home visual alignment.

Expected gates after apply:
- PUBLIC_HOME_CONTAINER_MIN_HEIGHT_COMPILE_FIX=PASS
- UPLOAD_QUEUE_FEATURE_RETENTION=PASS
- flutter analyze=PASS
- flutter test=PASS
- flutter run=PASS
