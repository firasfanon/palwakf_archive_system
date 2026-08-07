# Staging Integration UAT Matrix — Evidence Archive V1

| UAT | الحالة الآن | دليل القبول المطلوب |
|---|---|---|
| Module Registry registration | BLOCKED | registry record + version + health |
| Platform route-slot mount | BLOCKED | host route and feature flag evidence |
| Disabled module continuity | LOCAL SIMULATION ONLY | staging: core and unrelated module remain available |
| Module failure isolation | LOCAL SIMULATION ONLY | staging error/fallback trace |
| Effective authority binding | BLOCKED | positive + negative capability results |
| Unit context propagation | LOCAL MOCK ONLY | actor/unit context audit trace |
| Cross-unit read denial | BLOCKED | server-side negative UAT |
| Cross-unit write denial | LOCAL MOCK ONLY | server-side negative UAT |
| Cross-unit file denial | BLOCKED | File Center negative UAT |
| Super Admin multi-unit | BLOCKED | super_admin audit evidence |
| File object mapping | BLOCKED | approved mapping + audit |
| GIS capability | BLOCKED | scoped layer/read review UAT |
| Rollback without core outage | BLOCKED | feature flag / unmount evidence |
| Production promotion | NOT REQUESTED | all prior tests + approval |

## قواعد التنفيذ
- لا يستخدم UAT بيانات أصلية حساسة دون التفويض اللازم.
- لا يعد نجاح local fixture دليلًا لنجاح staging.
- لا يقبل أي cross-unit behavior إلا بدليل server-side.
- لا Production Promotion من هذه الحزمة.
