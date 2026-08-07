# Route Slot Request — Evidence Archive V1

## طلب المشروع
لا يطلب المشروع URL إنتاجيًا، بل slots فقط. تعيين المسار الفعلي، المضيف، التسجيل في القائمة، سياسة الـdeep link، وFeature Flag ملك لمنصة PalWakf.

| Route Slot | وظيفة محلية حالية | شرط الاستضافة |
|---|---|---|
| `dashboard` | لوحة الأدلة والمراجعات | Feature Flag + central authority |
| `list` | مستكشف الأدلة | capability `evidence_archive.evidence.read` |
| `detail` | تفاصيل دليل | read + unit scope + ownership |
| `create` | مسودة دليل/مجموعة/دفعة | create capability + workflow |
| `review` | قائمة مراجعة | review capability + workflow |
| `reports` | غير مكتمل محليًا | platform-defined reporting contract |
| `settings` | الحوكمة وجاهزية الإدماج | admin/platform capability |

## قيود
```text
NO_NEW_PLATFORM_ROOT_ROUTE
NO_HARDCODED_PRODUCTION_URL
NO_LOCAL_DEEP_LINK_POLICY
NO_MOUNT_WITHOUT_FEATURE_FLAG
NO_ROUTE_ACCESS_WITHOUT_EFFECTIVE_AUTHORITY_AND_UNIT_CONTEXT
```

## المخرج المطلوب من المنصة
```text
HOST_SYSTEM_KEY=PLATFORM_ASSIGNED
HOST_ROOT_ROUTE=PLATFORM_ASSIGNED
APPROVED_CHILD_ROUTE_PATTERN=PLATFORM_ASSIGNED
SIDEBAR_REGISTRATION=PLATFORM_ASSIGNED
```
