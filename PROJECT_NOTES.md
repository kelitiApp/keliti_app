# كليتي (Kelayti) — توثيق المشروع

هذا الملف هو المرجع الأساسي لكل ما تم بناؤه في التطبيق حتى الآن. اقرأه أول شي قبل ما تبلش أي شغل جديد أو تحاول تحل أي مشكلة، لأنه بيشرح **ليش** الأشياء متبنية هيك مش بس **شو** تم عمله.

آخر تحديث: بعد بناء الهيكل الكامل للتطبيق + جولة تحقق بصري (screenshots) لقت وصلحت 3 مشاكل حقيقية.

---

## 1. الوضع العام

المشروع كان فاضي تماماً (Flutter scaffold افتراضي بس) وتم بناؤه بالكامل من الصفر اعتماداً على مجموعة تصاميم (screenshots) شاملة تغطي كل شاشات التطبيق. التطبيق موجه لمرضى غسيل الكلى ومتابعة العائلة لهم، بواجهة عربية RTL بالكامل.

- **Flutter SDK**: 3.29.3 / Dart 3.7.2
- **الاتجاه**: RTL بالكامل (`Directionality` مضبوطة على `TextDirection.rtl` في `app.dart`)
- **الحالة الحالية**: التطبيق شغال end-to-end من تسجيل الدخول لحد كل الميزات الرئيسية، متصل بـ Cubits حقيقية (مو بيانات وهمية ثابتة بالواجهة).
- **لا يوجد باك-إند حقيقي بعد** — كل الـ Cubits مبنية على بيانات وهمية (`seed()`) في الذاكرة. أي تكامل مستقبلي مع API/Firebase لازم يستبدل الـ repositories الوهمية هاي بس يخلي شكل الـ Cubit/State زي ما هو.

---

## 2. البنية المعمارية (Feature-First)

```
lib/
├── main.dart                  # نقطة الدخول — بس بينادي app.dart
├── app.dart                   # MaterialApp + كل الـ BlocProviders + الراوتر
├── core/
│   ├── theme/                 # نظام التصميم الموحّد (ألوان، خطوط، مسافات...)
│   ├── widgets/                # مكتبة الويدجتس المشتركة (أزرار، كروت، حقول...)
│   ├── routes/                 # AppRoutes (أسماء) + AppRouter (onGenerateRoute) + NotFoundPage
│   ├── session/                # PatientCubit — بيانات المريض، مشتركة بين ميزات كتير
│   └── notifications/          # NotificationsCubit — قائمة الإشعارات المشتركة (bell badge)
└── features/
    ├── auth/                   # تسجيل دخول، إنشاء حساب، OTP، نسيت كلمة المرور
    ├── onboarding/              # بيانات أساسية، طبية، اختيار مركز/طبيب، الإكمال
    ├── family/                  # دعوة أفراد العائلة، جهات الاتصال (تُستخدم من onboarding والملف الشخصي)
    ├── shell/                   # MainShellPage — الحاوية الرئيسية بالـ bottom nav (5 تابات)
    ├── home/                    # لوحة التحكم الرئيسية (الداشبورد)
    ├── medications/              # الأدوية: قائمة، إضافة/تعديل، تفاصيل، تأكيد الجرعة
    ├── appointments/             # المواعيد: قائمة/تقويم، 3 أنواع مواعيد، إلغاء/تأجيل
    ├── reports/                  # التقارير: نتائج فحوصات، سجل غسيل، مؤشرات حيوية، التزام
    ├── profile/                  # الملف الشخصي وكل الإعدادات الفرعية
    ├── community/                 # مجتمع الدعم (منشورات، تعليقات، هوية مستعارة)
    ├── fluids/                    # تتبع السوائل اليومي
    ├── food_assistant/            # مساعد الغذاء الذكي
    ├── assistance/                 # طلب مساعدة سريعة / تقرير أعراض
    └── notifications/               # صفحة الإشعارات (تستهلك core/notifications)
```

كل ميزة فيها بنية موحدة:
```
feature_name/
├── data/                # الموديلات + أي بيانات وهمية seed()
└── presentation/
    ├── cubit/           # منطق الأعمال (flutter_bloc)
    └── pages/           # الشاشات (Widgets فقط، بدون منطق أعمال مباشر)
```

### قاعدة مهمة: متى نحط شي بـ `core/` ومتى بـ `features/`
شي بيروح على `core/` فقط لو مستخدم فعلياً من أكتر من ميزة وحدة (مثال: `PatientCubit` مستخدم من home + profile + medications + appointments). أي شي خاص بميزة وحدة يضل جوّاها.

---

## 3. نظام التصميم (Design System) — `lib/core/theme/`

القيم مستخرجة/مقاربة من التصاميم المرفقة، ومركزية بالكامل — **ممنوع** حط قيم عشوائية (magic numbers) بأي شاشة جديدة، استخدم هاي الملفات:

| الملف | المحتوى |
|---|---|
| `app_colors.dart` | كل الألوان (primary teal `#2F6F6B`, error, warning, نيوترالز...) |
| `app_text_styles.dart` | كل أنماط الخط، مبنية على خط **Cairo** (مثبت محلياً — بند 6) |
| `app_spacing.dart` | مقياس المسافات (xxs → xxxl) |
| `app_radius.dart` | مقياس الحواف الدائرية |
| `app_dimensions.dart` | ارتفاعات الأزرار/الحقول، أحجام الأيقونات والأفاتار |
| `app_theme.dart` | يجمع كل شي بـ `ThemeData` واحد يُستخدم بـ `MaterialApp` |

### الويدجتس المشتركة — `lib/core/widgets/widgets.dart` (barrel export)
قبل ما تسوي أي widget جديد، دوّر هون أول — الأغلب موجود:

- `AppButton` (primary/secondary/outlined/destructive/text + loading state)
- `AppTextField`, `AppPickerField` (حقل يفتح bottom sheet/date picker بدل كتابة مباشرة)
- `AppScaffold` — **استخدمه دايماً بدل `Scaffold` مباشرة** (فيه SafeArea + padding + scrolling جاهزين)
- `AppPageHeader` (هيدر الصفحات الفرعية مع زر رجوع دائري + step dots اختيارية)
- `AppTopBar` (هيدر تابات الشاشة الرئيسية مع جرس الإشعارات)
- `AppCard`, `AppIconBadge`, `StatusChip`, `SelectableChip`, `SegmentedTabs`
- `AppEmptyState`, `AppResultView` (شاشات النجاح/التحذير/الخطأ الكاملة)
- `showAppConfirmSheet(...)`, `showAppSelectSheet(...)` (bottom sheets جاهزة للتأكيد والاختيار)
- `OtpInputField`, `AppToggleTile`, `AppCircleIconButton`

---

## 4. إدارة الحالة (State Management)

`flutter_bloc` (Cubit pattern) بكل مكان. كل الـ Cubits مسجّلة بـ `MultiBlocProvider` بملف `lib/app.dart` وبالتالي متاحة بأي مكان بالتطبيق عبر `context.watch<X>()` / `context.read<X>()`.

**قائمة كل الـ Cubits الموجودة:**
`AuthCubit`, `PatientCubit` (core), `NotificationsCubit` (core), `OnboardingCubit`, `FamilyCubit`, `MedicationsCubit`, `AppointmentsCubit`, `ReportsCubit`, `FluidsCubit`, `AssistanceCubit`, `CommunityCubit`, `FoodHistoryCubit`.

كل واحد فيه `seed()` static method يبني بيانات وهمية أولية — هون بالضبط وين لازم يصير التبديل لما يجي API حقيقي.

---

## 5. التوجيه (Routing) — نمط هجين مقصود

فيه نمطين متعمدين:

1. **Named routes** (`AppRoutes` بـ `core/routes/routes.dart` + `AppRouter.onGenerateRoute`) — تُستخدم فقط لنقاط الدخول الرئيسية اللي محتاجة `Navigator.pushNamed`: تسجيل الدخول، onboarding، الانتقال للـ `MainShellPage`، صفحة الإشعارات.
2. **`MaterialPageRoute` مباشر مع typed constructor args** — تُستخدم لكل التنقل الداخلي بالميزات (مثلاً `MaterialPageRoute(builder: (_) => MedicationDetailPage(medicationId: id))`). هاد أوضح وأأمن من تمرير objects معقدة (زي `Medication` كامل) عبر `route.arguments`.

**ملاحظة**: مو كل ثوابت `AppRoutes` مربوطة فعلياً بـ `AppRouter` — بعضها معرّف للمرجعية المستقبلية بس مش مستخدم لأن التنقل ليها بيصير عبر `MaterialPageRoute` مباشر. هاد قرار مقصود مش خطأ.

`NotFoundPage` موجودة كـ fallback لأي route غير معروف.

---

## 6. الخط (Cairo) — مهم جداً، سبب باج حقيقي

**تم اكتشاف مشكلة حقيقية وإصلاحها**: كان الخط يتحمّل عبر مكتبة `google_fonts` وقت التشغيل (runtime fetch من Google CDN). هاد سبب ظهور النص العربي كمربعات فاضية (tofu boxes) بأي بيئة ما عندها اتصال فوري بـ Google Fonts وقت أول تحميل.

**الحل المطبّق**: تم تحميل ملف خط Cairo (variable font) وتخزينه محلياً بـ:
```
assets/fonts/Cairo-Variable.ttf
```
ومُعرّف بـ `pubspec.yaml` تحت `flutter: fonts:` بأربع أوزان (400/500/600/700) كلها تشاور على نفس الملف (variable font بيدعم هيك). **تم حذف `google_fonts` نهائياً من `pubspec.yaml`**. أي نص بالتطبيق لازم يستخدم `AppTextStyles.*` مش خط ثابت يدوي.

⚠️ **لو حسّيت مستقبلاً إن النص العربي رجع يظهر كمربعات**: افحص إن `assets/fonts/Cairo-Variable.ttf` لسا موجود ومُعرّف صح بـ `pubspec.yaml`، ولا حد رجّع `google_fonts` بالغلط.

---

## 7. باجات حقيقية اتكتشفت وانصلحت أثناء التحقق البصري

بعملية تحقق بصري فعلية (screenshots حقيقية عبر Playwright + Chrome المثبت على الجهاز، على نسخة `flutter build web --release`)، انلقت 3 مشاكل حقيقية:

### أ) الخط العربي (مشروح بالأعلى، بند 6)

### ب) تابات "الأدوية" و"المواعيد" كانوا يطلعوا فاضيين تماماً!
**السبب الجذري**: `MedicationsPage` و `AppointmentsPage` كانوا يمررو `bottomBar` (زر FAB) لـ `AppScaffold`، اللي كان يحطه بـ `Scaffold.bottomNavigationBar`. بما إن هاي الصفحات نفسها متضمّنة جوّا `IndexedStack` جوّا `Scaffold` تاني (`MainShellPage`)، صار عندنا **Scaffold متعشش جوّا Scaffold وكل وحدة فيها `bottomNavigationBar` خاص فيها** — هاد سبب انهيار حساب الارتفاع (height) للـ body بشكل صامت (بدون أي error يظهر بالـ console)، فصار الـ body يرتسم بارتفاع شبه صفر وما يبين شي غير الـ FAB.

**الحل**: تم إعادة كتابة `lib/core/widgets/app_scaffold.dart` بحيث `bottomBar` يترسم كـ **overlay** (`Stack` + `Positioned`) بدل ما يروح لـ `Scaffold.bottomNavigationBar`. هيك ما في تعشيش لـ Scaffold slots، وبيشتغل صح سواء الصفحة مفتوحة لحالها (`push`) أو جوّا الـ tab shell.

**درس مستفاد**: أي صفحة جديدة إلها `bottomBar` (زر FAB أو زر ثابت بالأسفل) ولازم تنضاف كـ tab جديد بالـ `MainShellPage` مستقبلاً — ما رح تواجه هاي المشكلة لأن الحل صار جزء من `AppScaffold` نفسه. بس لو حد "أصلح" أو غيّر `AppScaffold` ورجّع نمط `bottomNavigationBar` القديم، الباج رح يرجع.

### ج) تداخل اسم الدواء مع شارة "نشط" بصفحة تفاصيل الدواء
كان `medication_detail_page.dart` يستخدم `Stack` + `Positioned` + `Align(bottomRight)` لحط اسم الدواء وشارة الحالة سوا، وهاد سبب تداخل بصري بينهم. تم استبداله بـ `Column` بسيط (الشارة فوق، بعدها مسافة، بعدها الاسم) — تصميم مضمون بدون تداخل ببنيته.

---

## 8. طريقة التحقق البصري (لو احتجت تعيدها مستقبلاً)

ما كان فيه mobile emulator متاح بهاي البيئة، فتم:

1. إضافة دعم منصة الويب للمشروع (`flutter create . --platforms=web`) — **موجودة الآن دائماً بالمشروع**، فيه مجلد `web/`.
2. بناء نسخة release: `flutter build web --release`
3. تشغيل سيرفر ستاتيك بسيط (Node.js) يخدّم `build/web`
4. استخدام `playwright-core` (بدون تحميل متصفح خاص فيها — بيستخدم Chrome المثبت أصلاً على الجهاز عبر `executablePath`) للتحكم بالصفحة وأخذ screenshots

**ليش مو `flutter run -d web-server` مباشرة؟** — وضع الـ debug بينتظر اتصال من نفس المتصفح اللي هو فتحه (hot-reload handshake)، فلو فتحت المتصفح ببرنامج منفصل (Playwright) ما بيكمل التحميل ويضل الشاشة بيضاء. لازم `release` build يتقدم بشكل مستقل.

**ليش مو `playwright` العادية؟** — بتحاول تحمّل نسخة Chromium خاصة فيها (~300MB) وهاد ممكن يعلق بهاي البيئة. `playwright-core` ما بيجيب متصفح، بس بيوصل لأي متصفح موجود عبر `executablePath`.

---

## 9. ملخص الميزات المُنفّذة (شاشة بشاشة تقريباً)

- **Auth**: تسجيل دخول (مريض/فرد عائلة toggle)، إنشاء حساب، تأكيد OTP، نسيت كلمة المرور، إعادة تعيين
- **Onboarding**: بيانات أساسية (ميلاد/جنس/فصيلة دم)، بيانات طبية (نوع غسيل/جلسات/تاريخ بدء)، اختيار مركز غسيل، اختيار طبيب، دعوة فرد عائلة، شاشة الإكمال
- **Home Dashboard**: تحية + جلسة قادمة + ملاحظة ذكية + مؤشرات حيوية (سوائل/وزن/ضغط) + أدوية الصباح + زر مساعدة سريعة — **كل البيانات متصلة بـ Cubits حقيقية مش mock ثابت بالواجهة**
- **Medications**: قائمة (نشط/متوقف)، إضافة/تعديل (شكل دوائي، جرعة، أوقات)، تفاصيل مع تعليمات، تأكيد جرعة، إيقاف دواء
- **Appointments**: قائمة + تقويم (`table_calendar`)، 3 أنواع (جلسة غسيل متكررة أسبوعياً / زيارة طبيب / فحص مخبري مع صيام)، تفاصيل، تعديل، إلغاء (بخيارات للمتكرر)، تأكيد حضور
- **Reports**: نتائج فحوصات (قيم + تنبيهات + ملاحظة طبيب)، سجل جلسات غسيل، مؤشرات حيوية (رسم بياني `fl_chart` + قياسات يدوية)، تقرير التزام (halka heatmap)، مشاركة PDF
- **Profile**: معلومات شخصية، بطاقة طبية طارئة (QR)، جهات اتصال عائلة، طبيب ومركز، إعدادات إشعارات، لغة، مساعدة ودعم، تقييم، حذف حساب
- **Community**: انضمام بهوية مستعارة، فئات، منشورات وتعليقات، إبلاغ عن محتوى، إعدادات، مغادرة
- **Fluids**: حلقة تقدم يومية، إضافة سريعة، سجل، تحذير اقتراب الحد، تعديل الحد اليومي
- **Food Assistant**: بحث/سؤال عن طعام، نتيجة (آمن/باعتدال/تجنّب) مبنية على آخر فحص بوتاسيوم، بدائل آمنة، سجل أسئلة
- **Assistance**: شبكة خيارات مساعدة، تقرير أعراض (رموز تعبيرية لشدة التعب)، تأكيد جهة تواصل، إرسال، تفاصيل طلب مع timeline

---

## 10. أشياء تم تخطيها عن قصد (Scope تم توضيحه للمستخدم)

- **Widgetbook** — ما تم إعداده (وقت/تعقيد إضافي كبير مقابل ~150 شاشة)
- **Localization كامل (.arb files)** — كل النصوص عربي مباشر بالكود، مو مستخرجة لملفات ترجمة. `flutter_localizations` مضاف بس بس لدعم RTL وwidgets النظام (date pickers...)، مش لترجمة نصوص التطبيق فعلياً. لو المطلوب إنجليزي حقيقي مستقبلاً، لازم إعداد ARB كامل.
- **"نشاطي" (My Activity) بالمجتمع** — الموديل/الشاشة مب مبنية، ومافي زر يودّي إلها حالياً.
- **لا يوجد باك-إند حقيقي** — كل شي مبني على `seed()` بالذاكرة، بيضيع عند إعادة تشغيل التطبيق (لا يوجد `shared_preferences` تخزين فعلي بعد رغم إنه مضاف كـ dependency).

---

## 11. أوامر مفيدة

```bash
# فحص الكود (لازم يطلع "No issues found!")
flutter analyze

# تشغيل الاختبارات
flutter test

# تشغيل على الويب للمعاينة السريعة (بدون emulator)
flutter build web --release
# بعدها خدّم مجلد build/web بأي static server

# جلب/تحديث الحزم بعد أي تعديل على pubspec.yaml
flutter pub get
```

---

## 12. لو رجعت مشكلة "الشاشة فاضية" بأي تاب أو صفحة جديدة

هاي كانت أخطر مشكلة انلقت (بند 7-ب). لو صفحة جديدة طلعت فاضية:

1. تأكد هل هي مستخدمة جوّا `IndexedStack` أو أي حاوية تانية بتبني كذا صفحة مع بعض؟
2. تأكد هل بتستخدم `Expanded`/`Flexible` جوّا `Column` مع `scrollable: false` بـ `AppScaffold`؟
3. لو الجواب نعم للاثنين، تأكد إن `AppScaffold` لسا يستخدم نمط الـ `Positioned` overlay للـ `bottomBar` (مش `Scaffold.bottomNavigationBar` المباشر) — هاد هو الإصلاح الأساسي.
4. أفضل طريقة تتأكد: سوي `flutter build web --release` وصور الشاشة فعلياً (زي بند 8) بدل ما تعتمد بس على قراءة الكود — الباج هاد ما كان يطلع بـ `flutter analyze` ولا بأي console error.
