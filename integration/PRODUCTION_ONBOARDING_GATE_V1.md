# Production Onboarding Gate — Evidence Archive V1

## يجب أن تكون جميع البنود PASS قبل طلب الإنتاج
1. Module Registry وcompatibility range مسجلان.
2. Route slots مخصصة من المنصة مع feature flag.
3. Central effective authority وcurrent unit context وserver-side scope enforcement مثبتة.
4. لا Login/RBAC/Org unit registry محلي.
5. owner schema وAPI/RPC/file-object mapping معتمدة، ولا public base tables.
6. audit + observability events تستقبل في المنصة.
7. File Center + retention + quarantine + restore محكومة.
8. GIS capability مقيّدة؛ والنتائج المشتقة لا تعد حدودًا قانونية.
9. UAT سلبي عبر الوحدات للقراءة/الكتابة/الملفات/الطبقات ناجح.
10. module disabled/failure/rollback continuity ناجحة في staging.
11. migration/rollback/provenance/data classification approved.
12. release approver/production evidence موجودان.

```text
CURRENT_GATE=BLOCKED
PRODUCTION_APPROVAL=NOT_IMPLIED
```
