# Apply Instructions — Requirements Documentation Patch — 2026-07-13

```text
BATCH=MEGA_BATCH_ARCHIVE_REQUIREMENTS_MEMORY_AND_PROJECT_DOCUMENTATION_V1
PATCH_TYPE=DOCUMENTATION_ONLY
```

## طريقة التطبيق

فك محتوى هذه الحزمة فوق جذر المشروع الحالي `archive_system` مع السماح بالاستبدال للملفات التوثيقية فقط.

## الملفات المضافة/المحدثة

- `docs/ARCHIVE_ELECTRONIC_SYSTEM_REQUIREMENTS_V1.md`
- `docs/ARCHIVE_REQUIREMENTS_INDEX_V1.md`
- `PALWAKF_PLATFORM_COMPREHENSIVE_GUIDE.md`
- `CHANGELOG.md`
- `PROJECT_SESSIONS_INDEX.md`
- `baseline_control/*REQUIREMENTS_DOCUMENTATION*`
- `handoff/*REQUIREMENTS_DOCUMENTATION*`
- `error_records/ERROR_RECORD.md`
- `SHA256SUMS.txt`

## تحقق سريع

```powershell
python toolserify_module_reception_static.py
```

هذه الحزمة لا تغيّر كود Flutter ولا تتطلب ربطًا أو قاعدة بيانات.
