# Module Health, Fallback, and Rollback — Evidence Archive V1

## Health Contract
| الحالة | السلوك المحلي | ما يطلب من المضيف المنصي |
|---|---|---|
| `localReady` | واجهات fixture متاحة | mount عادي بعد health check |
| `degraded` | الواجهة تبقى مرئية مع تنبيه | fallback محدود بلا عمليات حساسة |
| `disabled` | يظهر ModuleFallbackScreen | platform core وبقية modules تستمر |
| `unavailable` | يظهر fallback فقط | circuit breaker + observability |

## Feature Flags
- `evidence_archive.local_workbench`: محلي فقط، default `true`.
- `evidence_archive.platform_mount`: placeholder، default `false`.

لا توجد Feature Flag منصية فعلية في هذا المشروع. تعيينها النهائي ملك للمنصة.

## Rollback
```text
LOCAL_ROLLBACK=RESTORE_LOCAL_MODE
PLATFORM_ROLLBACK=HOST_UNMOUNT + FEATURE_FLAG_DISABLE + VERSION_COMPATIBILITY_CHECK
NO_DATABASE_ROLLBACK_PLAN_IS_CLAIMED
```

## حدود
تطبيق Flutter المنفصل ليس App Shell المنصي؛ لذلك لا يمكنه إثبات أن core أو module آخر استمر فعليًا. الاختبار المحلي يثبت فقط أن boundary يمكن أن تدخل fallback دون استمرار العمليات المحلية.
