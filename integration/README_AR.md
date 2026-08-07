# حزمة إدماج مشروع الأرشيف داخل PalWakf

## الغاية
هذه الحزمة تجهّز **أرشيف الأدلة والمستكشف المكاني** (`evidence_archive`) لربط مستقبلي مع PalWakf دون تحويله إلى منصة مستقلة أو الادعاء بأنه مدمج أو معتمد إنتاجيًا.

## ما تم في هذا baseline
- فصل واجهة المشروع المحلية عن أي URL إنتاجي عبر **Route Slots** منطقية.
- إضافة عقود `PlatformSystemContext` و`PlatformUnitContext` و`PlatformAuthorityPort` و`PlatformFeatureFlagPort` و`PlatformAuditPort`.
- إضافة Local Mock Adapter محكوم: لا Login، لا RBAC، لا Supabase، لا File Center، ولا تخزين دائم.
- إضافة Feature Flag وHealth/Fallback/Kill-switch محاكاة محلية.
- ربط عمليات التعديل المحلية بـ Capability Gate تجريبي.
- إضافة marker `unitScopeKey` إلى بيانات fixture، مع رفض صريح لأي cross-unit mutation داخل الذاكرة المحلية.
- تجهيز manifest، intake، مصفوفة نطاق، خريطة تدقيق، نية Owner Schema، UAT staging، وبوابة إنتاج.

## ما لم يتم
- لم يُحدَّث مستودع PalWakf المركزي.
- لم يُعيَّن `HOST_SYSTEM_KEY` أو `HOST_ROOT_ROUTE`.
- لم تُنشأ جداول، views، RPCs، grants، buckets، أو storage mappings.
- لم تُربط authority أو unit context الفعلية، ولا يمكن اعتبار mock client-side إنفاذًا خادميًا.
- لم يتم تشغيل UAT staging أو اعتماد إنتاج.

## قرار الحالة
```text
LOCAL_FUNCTIONAL=TRUE
PLATFORM_ADAPTER_BOUNDARY=PREPARED
PLATFORM_INTEGRATED=FALSE
STAGING_INTEGRATION_AUTHORIZED=FALSE
PRODUCTION_APPROVAL=NOT_IMPLIED
```
