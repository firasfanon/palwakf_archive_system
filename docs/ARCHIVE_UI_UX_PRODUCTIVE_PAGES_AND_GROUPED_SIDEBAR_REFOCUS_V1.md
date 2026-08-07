# MEGA_BATCH_ARCHIVE_UI_UX_PRODUCTIVE_PAGES_AND_GROUPED_SIDEBAR_REFOCUS_V1

## الهدف

تثبيت واجهة استخدام يومية إنتاجية لنظام الأرشفة الإلكترونية قبل أي توسع إضافي في الذكاء أو التكامل أو قواعد البيانات. تضع هذه الدفعة المستخدم التشغيلي أولًا، وتنقل الحوكمة والتكامل إلى صفحة فرعية داخل الإدارة.

## المبادئ

- UI/UX أولًا.
- الصفحات الإنتاجية اليومية هي المسار الأساسي.
- الحوكمة لا تظهر كواجهة رئيسية.
- لا Supabase ولا File Center ولا GIS ولا Staging ولا Production.
- كل العمل داخل ذاكرة الجلسة المحلية فقط.

## تبويبات السايد بار المعتمدة

1. مساحة العمل اليومية.
2. تنظيم الأرشيف.
3. المراجعة والاعتماد.
4. الاستكشاف والبحث.
5. التقارير والتشغيل.
6. الإدارة.

## عزل الحوكمة

الحوكمة والتكامل موجودة فقط تحت:

```text
الإدارة → الحوكمة والتكامل
```

ولا تظهر Staging أو Controlled UAT أو Production Readiness كبنود تنقل يومية مستقلة.

## الصفحات الإنتاجية الأساسية

- الرئيسية.
- لوحة المتابعة.
- مهامي.
- الوثائق.
- إضافة وثيقة.
- الرفع والحفظ.
- البحث الذكي.
- التصنيف.
- بيانات الوثيقة.
- دورة الحياة.
- قائمة المراجعة.
- الإتاحة والتدقيق.
- الفهرس والبحث.
- الفهرسة الذكية.
- التقارير والتنبيهات.

## حواجز القبول

```text
SIDEBAR_GROUPED_BY_USAGE=PASS
GOVERNANCE_IS_ADMIN_SUBPAGE_ONLY=PASS
DAILY_UX_PRIMARY_NAVIGATION=PASS
DOCUMENT_PRODUCTIVE_PAGES=PASS
ADD_DOCUMENT_FLOW_VISIBLE=PASS
DOCUMENT_DETAIL_TABS_VISIBLE=PASS
NO_GOVERNANCE_FIRST_EXPERIENCE=PASS
```

## حدود الحوكمة

```text
PALWAKF_REMOTE_INTEGRATION=NOT_CONNECTED_BY_DESIGN
STAGING_APPROVAL=NOT_APPROVED
PRODUCTION_APPROVAL=NOT_APPROVED
```
