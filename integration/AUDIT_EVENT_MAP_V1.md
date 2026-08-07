# Audit and Observability Event Map — Evidence Archive V1

## أحداث مشتركة مطلوبة عند الربط
| الحدث | متى يسجل | الحد الأدنى للبيانات |
|---|---|---|
| `module_registered` | التسجيل في Module Registry | module id/version/actor |
| `module_mounted` | mount ناجح | host/feature flag/health |
| `module_unavailable` | فشل أو تعطيل | reason/health/fallback |
| `module_degraded` | تفعيل degraded mode | reason/timeout/fallback |
| `module_route_denied` | رفض route slot | slot/capability/unit context |
| `module_capability_denied` | رفض عملية | capability/reason/unit context |
| `module_unit_context_changed` | تبديل وحدة | previous/current/reason |
| `module_file_accessed` | قراءة/إرفاق ملف | file object/action/classification |
| `module_rollback_started` | بدء rollback | version/actor/reason |
| `module_rollback_completed` | نهاية rollback | status/evidence |

## أحداث domain مقترحة
- `evidence_draft_created`
- `evidence_metadata_updated`
- `evidence_quarantined`
- `evidence_relation_proposed`
- `review_task_state_changed`
- `import_batch_cataloged`
- `spatial_artifact_submitted_for_review`

## الوضع الحالي
الـ`localAuditTrail` ذاكرة جلسة محدودة للاختبار، وليست audit log سياديًا ولا يجوز استخدامها كدليل اعتماد.
