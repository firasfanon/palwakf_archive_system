PalWakf Evidence Archive & Spatial Explorer

هذه حزمة تصحيح Compile Gate للمسار الكامل المحلي:
Local Product → Core Archive → Evidence → Review → Spatial/Search → Admin → Staging Readiness → Controlled UAT → Production Readiness

قبل التشغيل على شجرة عمل محلية سبق تطبيق Updates-only فوقها، نفذ:

powershell -ExecutionPolicy Bypass -File .\APPLY_COMPILE_GATE_CLEANUP.ps1
python tools\verify_module_reception_static.py
flutter pub get
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
flutter run -d chrome --target lib/main.dart

لا يوجد اتصال فعلي مع PalWakf أو Supabase أو File Center أو GIS.
PALWAKF_REMOTE_INTEGRATION=NOT_CONNECTED_BY_DESIGN
STAGING_APPROVAL=NOT_APPROVED
PRODUCTION_APPROVAL=NOT_APPROVED
