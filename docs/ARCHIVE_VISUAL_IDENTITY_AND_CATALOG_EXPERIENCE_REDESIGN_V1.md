# MEGA_BATCH_ARCHIVE_VISUAL_IDENTITY_AND_CATALOG_EXPERIENCE_REDESIGN_V1

## الغرض
تنفيذ إعادة تصميم واجهات المشروع بصريًا ووظيفيًا وفق تصور بوابة أرشيف وطني رقمي: الصفحة الرئيسية، صفحات الكتالوج، مساحة العمل، تفاصيل الوثيقة، وطبقة OCR/التفريغ/الترجمة.

## نقطة البناء
يبنى فوق الحزمة التحضيرية الأخيرة التي تحتوي طبقة OCR / الترجمة / التفريغ، مع الحفاظ على حدود التشغيل المحلي.

## ما تغير
- `ARCHIVE_VISUAL_IDENTITY_REDESIGN`: اعتماد لوحة تراثية/أرشيفية بدل الطابع الإداري العام.
- `PUBLIC_ARCHIVE_GATEWAY_EXPERIENCE`: الصفحة العامة أصبحت بوابة أرشيفية تظهر الوثيقة والمكان والزمن والوقف.
- `WORKSPACE_COMMAND_CENTER_VISUAL_SHELL`: مساحة العمل صارت مركز تشغيل أرشيفي واضح.
- `ARCHIVE_PROCESS_RAIL`: شرح دورة المصدر → التمثيل → OCR/تفريغ → ترجمة → metadata → مراجعة → إتاحة.
- `CATALOG_ROOM_EXPERIENCE`: صفحات الكتالوج تعمل كغرف أرشيف مستقلة.
- `CATALOG_DISTINCT_VISUAL_THEMES`: لكل كتالوج هوية بصرية: عثماني/بريطاني/أردني/فلسطيني.
- `DOCUMENT_INVESTIGATION_ROOM`: تفاصيل الوثيقة تبدأ كرأس تحقيق يوضح الكتالوج والنوع والمصدر والثقة وحالة النشر.
- `TEXT_LAYER_STUDIO_EXPERIENCE`: OCR/التفريغ/الترجمة تظهر كاستوديو مسودات نصية لا كمحرك اعتماد.
- `CATALOG_AWARE_FORM_VISUAL_IDENTITY`: نموذج الإدخال يحمل هوية الكتالوج والنوع والقوالب.

## ما لا يتغير
- لا Supabase.
- لا OCR حقيقي.
- لا ترجمة حقيقية.
- لا نشر.
- لا Staging.
- لا Production.

## التحقق المطلوب محليًا
```powershell
python tools\verify_module_reception_static.py
flutter pub get
dart format lib test
flutter analyze
flutter test
flutter run -d chrome --target lib/main.dart
```
