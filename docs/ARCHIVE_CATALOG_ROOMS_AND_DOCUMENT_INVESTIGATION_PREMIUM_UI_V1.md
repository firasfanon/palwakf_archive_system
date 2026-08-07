# MEGA_BATCH_ARCHIVE_CATALOG_ROOMS_AND_DOCUMENT_INVESTIGATION_PREMIUM_UI_V1

## Purpose
تحويل صفحات الكتالوجات الداخلية وتفاصيل الوثيقة من صفحات تشغيلية عامة إلى تجربة أرشيفية Premium: غرف كتالوجات مستقلة، ومنضدة تحقيق وثيقة، وعارض تمثيلات وطبقات نصية، وسكة مراجعة بشرية.

## Scope
- `ArchiveCatalogsScreen`: إضافة لوحة جو الغرفة، خريطة طبقات التحقيق، معرض أنواع وثائق Premium، استوديو نوع الوثيقة، وسكة قوالب Metadata.
- `EvidenceDetailScreen`: إضافة مركز قيادة التحقيق، خط زمن/مكان/وقف، عارض وثيقة وتمثيلات، سكة طبقات نصية، وسكة قرار المراجعة البشرية.
- `verify_module_reception_static.py`: حواجز static جديدة.
- اختبار static جديد للماركرز.

## Governance
- لا OCR حقيقي.
- لا ترجمة حقيقية.
- لا نشر من المسودات.
- لا اتصال قاعدة بيانات أو Supabase.
- لا Staging أو Production.
- النشر يتطلب اعتمادًا بشريًا.

## Local gates required
```powershell
python tools\verify_module_reception_static.py
flutter pub get
dart format lib test
flutter analyze
flutter test
flutter run -d chrome --target lib/main.dart
```
