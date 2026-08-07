نستكمل مشروع PalWakf Evidence Archive من دفعة `MEGA_BATCH_ARCHIVE_PUBLIC_HOME_CATALOG_LANDING_AND_DEV_LOGIN_WORKSPACE_GATE_V1`.

القاعدة المعتمدة:

```text
الصفحة الرئيسية = بوابة تعريفية للأرشيف والكتالوجات
تسجيل الدخول = دخول تطويري مؤقت
مساحة العمل = كل أدوات الإدخال والرفع والمراجعة والبحث
النشر = ممنوع قبل اعتماد بشري
```

تحقق محليًا أولًا من:

```powershell
python tools\verify_module_reception_static.py
flutter pub get
dart format lib test
flutter analyze
flutter test
flutter run -d chrome --target lib/main.dart
```

بعد القبول المحلي، تصبح الدفعة baseline جديدًا، والخطوة التالية المقترحة: `MEGA_BATCH_ARCHIVE_LAYERED_CATALOGS_OPEN_DRAFT_INTAKE_AND_PAGE_ALIGNMENT_V1`.
