# MEGA_BATCH_ARCHIVE_PUBLIC_HOME_CATALOG_LANDING_AND_DEV_LOGIN_WORKSPACE_GATE_V1

## الهدف

تحويل الصفحة الأولى في مشروع PalWakf Evidence Archive من مساحة عمل داخلية مباشرة إلى بوابة تعريفية عامة للأرشيف والكتالوجات، مع إبقاء مساحة العمل الداخلية خلف زر تسجيل دخول تطويري مؤقت دون بيانات تحقق.

## القرار الحاكم

```text
الصفحة الرئيسية = بوابة تعريفية للأرشيف والكتالوجات
تسجيل الدخول = دخول تطويري مؤقت
مساحة العمل = كل أدوات الإدخال والرفع والمراجعة والبحث
النشر = ممنوع قبل اعتماد بشري
```

## نطاق التنفيذ

### Public Home / Landing Page

أضيفت صفحة عامة جديدة:

```text
lib/src/features/public/public_archive_landing_screen.dart
```

وتشمل:

- Header علوي.
- شريط قوائم تعريفي.
- Hero للتعريف بالأرشيف الوقفي الفلسطيني.
- بطاقات نبذة عن الكتالوجات:
  - الأرشيف العثماني.
  - الأرشيف البريطاني / الإنجليزي.
  - الأرشيف الأردني.
  - الأرشيف الفلسطيني.
- قسم قدرات تقنية وذكاء صناعي مساعد.
- قسم دخول إلى مساحة العمل.
- Footer.

### Development Login

أضيف Gate داخلي:

```text
_ArchiveEntryGate
```

وظيفته:

- عرض الصفحة العامة عند بدء التطبيق.
- عند الضغط على `تسجيل الدخول` يدخل المستخدم إلى مساحة العمل.
- لا يوجد اسم مستخدم.
- لا توجد كلمة مرور.
- لا يوجد Auth backend.
- لا يوجد Supabase Auth أو أي ربط خارجي.

### Workspace Shell

تبقى مساحة العمل الداخلية كما هي، وتشمل:

- السايد بار المبوب.
- إدخال الوثائق/المسودات.
- الرفع والحفظ.
- التمثيلات.
- المراجعة.
- البحث.
- الإدارة والحوكمة.

وأضيف زر `الواجهة العامة` في AppBar الداخلي للعودة إلى صفحة التعريف العامة.

## حدود الحوكمة

- الصفحة العامة لا تنشر أي وثيقة.
- لا يوجد زر نشر عام من الصفحة العامة.
- النشر يظل محجوبًا قبل المراجعة والاعتماد البشري.
- الحوكمة التقنية الثقيلة تبقى داخل الإدارة.

## حواجز التحقق

```text
PUBLIC_HOME_LANDING_PAGE=PASS
ARCHIVE_CATALOG_CARDS_VISIBLE=PASS
HERO_HEADER_FOOTER_NAV_VISIBLE=PASS
DEV_LOGIN_WITHOUT_CREDENTIALS=PASS
WORKSPACE_REQUIRES_DEV_LOGIN_ENTRY=PASS
SIDEBAR_NOT_ON_PUBLIC_HOME=PASS
NO_REAL_AUTH_BACKEND=PASS
NO_PUBLICATION_FROM_PUBLIC_HOME=PASS
```

## الحدود الثابتة

```text
PALWAKF_REMOTE_INTEGRATION=NOT_CONNECTED_BY_DESIGN
STAGING_APPROVAL=NOT_APPROVED
PRODUCTION_APPROVAL=NOT_APPROVED
```

## التحقق المطلوب محليًا

```powershell
cd C:\Users\DELL\StudioProjects\archive_system
python tools\verify_module_reception_static.py
flutter pub get
dart format lib test
flutter analyze
flutter test
flutter run -d chrome --target lib/main.dart
```
