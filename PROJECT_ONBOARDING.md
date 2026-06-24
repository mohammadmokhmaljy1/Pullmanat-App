

# دليل الانضمام إلى مشروع Pullmanat

هذا المستند هو نقطة البداية الرسمية لأي متدرب أو مطور جديد يريد فهم مشروع `pullmanat_app` من الصفر. الهدف منه ليس فقط شرح أين توجد الملفات، بل شرح لماذا صُمم المشروع بهذه الطريقة وكيف تنتقل البيانات بين واجهة المستخدم، الحالة، الخدمات، والـ Backend.

> اللغة المستخدمة في هذا التقرير: العربية.

---

## 1. نظرة عامة على المشروع

`pullmanat_app` هو تطبيق Flutter لحجز رحلات البولمان بين المدن السورية. التطبيق موجّه للمستخدم النهائي الذي يريد:

- إنشاء حساب أو تسجيل الدخول.
- مشاهدة الرحلات المقترحة.
- البحث عن رحلة بين مدينتين في تاريخ محدد ومن نقطة انطلاق محددة.
- عرض تفاصيل الرحلة.
- حجز رحلة أو تعديل الحجز أو إلغاؤه.
- متابعة الحجوزات السابقة والقادمة.
- استعراض شركات النقل.
- إرسال طلب رحلة مخصصة عند عدم وجود رحلة مناسبة.
- إدارة الملف الشخصي.

### الفكرة التجارية الأساسية

المشروع يحاكي تطبيق حجز نقل بين المدن. من منظور الأعمال، لدينا أربعة عناصر رئيسية:

1. **المستخدم**: يسجل الدخول، يبحث، يحجز، ويدير بياناته.
2. **الرحلة**: تحتوي على مدينة الانطلاق، مدينة الوصول، التاريخ، الوقت، السعر، الشركة، ونقطة الانطلاق.
3. **الحجز**: يربط المستخدم برحلة محددة ويحتفظ بحالة الحجز ورقم المقعد والرقم الوطني.
4. **الشركة**: شركة النقل المسؤولة عن تشغيل الرحلات.

توجد أيضاً ميزة **طلب رحلة مخصصة**، وهي تسمح للمستخدم بإرسال طلب عند عدم توفر رحلة مناسبة في الجدول الحالي.

### مصدر الحقيقة للبيانات

يعتمد التطبيق على Backend خارجي موثق في:

- `postman_collections.json`: يوضح endpoints المتاحة وطريقة استدعائها.
- `db_schema.sql`: يوضح جداول قاعدة البيانات والعلاقات المتوقعة.
- `backend_requirements.md`: يوثق endpoints غير المكتملة أو المفقودة التي احتاجها التطبيق أثناء التطوير.

---

## 2. التقنيات والاعتمادات

### اللغات والأطر

- **Dart**: لغة البرمجة الأساسية لتطبيق Flutter.
- **Flutter**: إطار بناء واجهات متعددة المنصات، ويستخدم هنا لبناء تطبيق موبايل بواجهة عربية RTL.
- **Material 3**: نظام تصميم Flutter المستخدم داخل `ThemeData`.

### أهم الحزم في `pubspec.yaml`

```yaml
dependencies:
  provider: ^6.1.5
  go_router: ^16.0.0
  google_fonts: ^6.2.1
  dio: ^5.8.0
  shared_preferences: ^2.5.3
```

| الحزمة | الدور في المشروع | سبب الاستخدام |
|---|---|---|
| `provider` | إدارة الحالة عبر `ChangeNotifier` | بسيط وواضح للمتدربين، وملائم لفصل واجهة المستخدم عن منطق العمل. |
| `go_router` | التنقل بين الشاشات | يوفر تعريفاً مركزياً للمسارات داخل `AppRouter`. |
| `dio` | تنفيذ طلبات HTTP | أقوى من `http` في التعامل مع interceptors، timeouts، الأخطاء، وتهيئة base URL. |
| `shared_preferences` | تخزين بيانات محلية بسيطة | يستخدم لحفظ جلسة المستخدم وحالة إكمال شاشات التعريف. |
| `google_fonts` | تحميل خط Cairo | مناسب للواجهة العربية ويحافظ على مظهر موحد للنصوص. |
| `flutter_lints` | قواعد تحليل الكود | يساعد على الحفاظ على جودة الكود واكتشاف الأخطاء المبكرة. |

### الأصول Assets

الأصول معرفة في `pubspec.yaml`:

```yaml
assets:
  - assets/images/logo_dark.png
  - assets/images/logo_light.png
  - assets/images/onboarding_1.png
  - assets/images/onboarding_2.png
  - assets/images/onboarding_3.png
```

هذه الصور مستخدمة في شاشات البداية والتعريف.

---

## 3. هيكل المجلدات

الهيكل العام للمشروع:

```text
pullmanat_app/
├── android/                         # إعدادات بناء Android
├── ios/                             # إعدادات بناء iOS
├── linux/                           # إعدادات بناء Linux
├── macos/                           # إعدادات بناء macOS
├── web/                             # إعدادات تطبيق الويب
├── windows/                         # إعدادات بناء Windows
├── assets/
│   └── images/                      # صور الشعار وشاشات التعريف
├── lib/
│   ├── main.dart                    # نقطة دخول التطبيق وتسجيل Providers
│   ├── core/                        # طبقات مشتركة لا تتبع ميزة واحدة
│   │   ├── network/                 # DioClient، endpoints، ApiException
│   │   ├── routing/                 # go_router والمسارات المركزية
│   │   ├── storage/                 # تخزين الجلسة والتعريف محلياً
│   │   ├── theme/                   # الألوان والثيم العام
│   │   └── utils/                   # Validators، ترجمة الأخطاء، المدن السورية
│   ├── features/                    # الميزات مقسمة حسب المجال
│   │   ├── auth/                    # تسجيل الدخول وإنشاء الحساب
│   │   ├── bookings/                # حجوزاتي وفلاتر الحجوزات
│   │   ├── companies/               # شركات النقل
│   │   ├── custom_trip/             # طلب رحلة مخصصة
│   │   ├── home/                    # الشاشة الرئيسية والرحلات المقترحة
│   │   ├── onboarding/              # شاشات التعريف الأولى
│   │   ├── profile/                 # الملف الشخصي والمحتوى القانوني
│   │   ├── search/                  # البحث عن الرحلات ونقاط الانطلاق
│   │   ├── splash/                  # شاشة البداية ومنطق التوجيه الأولي
│   │   └── trip_details/            # تفاصيل الرحلة والحجز/الإلغاء/التعديل
│   └── shared_widgets/              # Widgets مشتركة بين أكثر من ميزة
├── test/                            # اختبارات Flutter
├── db_schema.sql                    # مخطط قاعدة البيانات المرجعي
├── postman_collections.json         # توثيق API من Postman
├── backend_requirements.md          # endpoints مطلوبة وغير مكتملة
├── pubspec.yaml                     # تعريف المشروع والاعتمادات
└── analysis_options.yaml            # إعدادات التحليل والـ lints
```

### نمط تقسيم كل ميزة

معظم الميزات تتبع هذا الشكل:

```text
feature_name/
├── screens/       # واجهات المستخدم فقط
├── widgets/       # Widgets صغيرة خاصة بالميزة
├── providers/     # الحالة ومنطق العمل
├── models/        # تحويل JSON إلى كائنات Dart
└── services/      # استدعاءات API عبر Dio
```

مثال:

```text
features/search/
├── screens/search_screen.dart
├── screens/flight_list_screen.dart
├── providers/search_provider.dart
├── models/departure_point_model.dart
├── services/departure_points_service.dart
└── widgets/
```

---

## 4. المعمارية وأنماط التصميم

المشروع يستخدم معمارية مبسطة قريبة من **MVVM** ومناسبة للتعليم:

- **View**: ملفات `screens/` و `widgets/`.
- **ViewModel / State**: ملفات `providers/` المبنية على `ChangeNotifier`.
- **Model**: ملفات `models/`.
- **Service / Repository-like layer**: ملفات `services/` التي تتعامل مع الـ API.
- **Core Infrastructure**: ملفات `core/network`, `core/routing`, `core/storage`, `core/theme`, `core/utils`.

هذه ليست Clean Architecture كاملة بطبقات domain/use cases مستقلة، لكنها تطبق أهم مبدأ: **فصل المسؤوليات**.

### نقطة دخول التطبيق

يبدأ التطبيق من `lib/main.dart`. قبل تشغيل الواجهة، يتم تحميل جلسة المستخدم من التخزين المحلي:

```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final authProvider = AuthProvider();
  await authProvider.initializeSession();

  runApp(PullmanatApp(authProvider: authProvider));
}
```

بعد ذلك يتم تسجيل كل Providers عبر `MultiProvider`:

```dart
return MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => SplashProvider()),
    ChangeNotifierProvider(create: (_) => OnboardingProvider()),
    ChangeNotifierProvider.value(value: authProvider),
    ChangeNotifierProvider(create: (_) => HomeProvider()),
    ChangeNotifierProvider(create: (_) => CompaniesProvider()),
    ChangeNotifierProvider(create: (_) => CustomTripProvider()),
    ChangeNotifierProvider(create: (_) => BookingsProvider()),
    ChangeNotifierProvider(create: (_) => TripDetailsProvider()),
    ChangeNotifierProvider(create: (_) => SearchProvider()),
    ChangeNotifierProvider(create: (_) => ProfileProvider()),
  ],
  child: MaterialApp.router(
    title: 'بين المدن',
    theme: AppTheme.lightTheme,
    routerConfig: AppRouter.router,
  ),
);
```

### التوجيه Routing

المسارات معرفة في:

- `lib/core/routing/app_routes.dart`
- `lib/core/routing/app_router.dart`

مثال من المسارات:

```dart
static const String splash = '/';
static const String signIn = '/sign-in';
static const String home = '/home';
static const String search = '/search';
static const String tripDetails = '/trip-details';
```

`AppRouter` يربط كل مسار بالشاشة المناسبة باستخدام `GoRoute`.

### الشبكة Network

كل طلبات الشبكة تمر عبر `DioClient`:

```dart
static final DioClient instance = DioClient._();

late final Dio _dio = Dio(
  BaseOptions(
    baseUrl: ApiEndpoints.baseUrl,
    connectTimeout: const Duration(seconds: 20),
    receiveTimeout: const Duration(seconds: 20),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  ),
)..interceptors.add(
    LogInterceptor(
      requestBody: true,
      responseBody: true,
    ),
  );
```

هذا يعني أن الخدمات لا تنشئ `Dio` جديداً في كل مرة، بل تستخدم النسخة الموحدة:

```dart
class AuthService {
  AuthService({Dio? dio}) : _dio = dio ?? DioClient.instance.dio;

  final Dio _dio;
}
```

### إدارة الأخطاء

الأخطاء القادمة من Dio تتحول إلى `ApiException` موحد:

```dart
ApiException handleError(DioException error) {
  final response = error.response;

  if (response != null && response.data is Map) {
    final data = response.data as Map;
    final message = data['message'] ?? data['error'] ?? data['msg'];
    if (message != null) {
      return ApiException(
        ErrorMessageTranslator.translate(
          message.toString(),
          statusCode: response.statusCode,
        ),
        statusCode: response.statusCode,
      );
    }
  }

  return ApiException('حدث خطأ غير متوقع');
}
```

ثم يتعامل الـ Provider مع `ApiException` ويعرض رسالة مناسبة للمستخدم.

---

## 5. تدفق البيانات والتكامل

### التدفق العام للطلب

الشكل التالي يوضح دورة الطلب داخل التطبيق:

```text
User
  ↓
Screen / Widget
  ↓
Provider (ChangeNotifier)
  ↓
Service
  ↓
DioClient
  ↓
Backend API
  ↓
JSON Response
  ↓
Model.fromJson()
  ↓
Provider state update + notifyListeners()
  ↓
UI rebuild
```

### مثال عملي: البحث عن رحلة

1. المستخدم يفتح `SearchScreen`.
2. يختار مدينة الانطلاق والوصول ونقطة الانطلاق والتاريخ.
3. الشاشة تستدعي:

```dart
final search = context.read<SearchProvider>();
final userId = context.read<AuthProvider>().currentUser?.userId;
final success = await search.searchTrips(userId: userId);
```

4. `SearchProvider` يتحقق من اكتمال البيانات ومن وجود مستخدم مسجل.
5. يحول أسماء المدن العربية إلى أسماء يتوقعها الـ API عبر `SyrianCities.toApiName`.
6. يستدعي `TripsService.searchTrips`.
7. `TripsService` يرسل الطلب إلى:

```text
POST /trips/index.php
```

8. الاستجابة تتحول إلى `List<TripModel>`.
9. `SearchProvider` يصفي النتائج حسب نقطة الانطلاق.
10. عند النجاح، تنتقل الشاشة إلى `FlightListScreen`.

### مثال عملي: تسجيل الدخول

1. المستخدم يكتب البريد/الهاتف وكلمة المرور في `SignInScreen`.
2. الشاشة تستدعي `AuthProvider.login`.
3. `AuthProvider` يستدعي `AuthService.login`.
4. `AuthService` يحدد هل المدخل بريد أم هاتف:

```dart
if (identifier.contains('@')) {
  body = {'email': identifier.trim(), 'password': password};
} else {
  body = {
    'phone': _parsePhone(identifier),
    'password': password,
  };
}
```

5. الطلب يرسل إلى:

```text
POST /users/login.php
```

6. الاستجابة تتحول إلى `UserModel`.
7. `AuthProvider` يحفظ المستخدم في `SharedPreferences` عبر `AuthSessionStorage`.
8. الواجهة تتحدث بعد `notifyListeners`.

### مثال عملي: حجز رحلة

1. المستخدم يفتح `TripDetailsScreen` من قائمة الرحلات.
2. الشاشة تمرر الرحلة عبر `TripDetailsArgs` في `go_router`.
3. عند ضغط زر الحجز، يتم طلب الرقم الوطني.
4. `TripDetailsProvider.bookTrip` يستدعي:

```text
POST /reservations/add.php
```

5. بعد نجاح الحجز، يتم جلب حجوزات المستخدم مرة أخرى للتأكد من الحالة الفعلية.
6. إذا وجد حجز نشط لنفس الرحلة، تظهر الشاشة في وضع "مسجل".

---

## 6. الميزات الرئيسية

### 6.1 البداية والتعريف

الملفات المهمة:

- `lib/features/splash/screens/splash_screen.dart`
- `lib/features/splash/screens/splash_loading_screen.dart`
- `lib/features/splash/providers/splash_provider.dart`
- `lib/features/onboarding/screens/getting_started_screen.dart`
- `lib/features/onboarding/providers/onboarding_provider.dart`
- `lib/core/storage/onboarding_storage.dart`

منطق البداية:

- إذا كان المستخدم لديه جلسة صالحة، ينتقل إلى `home`.
- إذا لم يكمل شاشات التعريف، ينتقل إلى `getting-started`.
- إذا أكمل التعريف ولا توجد جلسة، ينتقل إلى `sign-in`.

### 6.2 المصادقة Auth

الملفات المهمة:

- `lib/features/auth/screens/sign_in_screen.dart`
- `lib/features/auth/screens/sign_up_screen.dart`
- `lib/features/auth/providers/auth_provider.dart`
- `lib/features/auth/services/auth_service.dart`
- `lib/features/auth/models/user_model.dart`
- `lib/core/storage/auth_session_storage.dart`

المصادقة تعتمد على بيانات المستخدم المخزنة محلياً، ولا يوجد token حالياً. مدة الجلسة المحلية 7 أيام:

```dart
static const Duration sessionDuration = Duration(days: 7);
```

### 6.3 الرئيسية Home

الملفات المهمة:

- `lib/features/home/screens/home_screen.dart`
- `lib/features/home/providers/home_provider.dart`
- `lib/features/home/services/trips_service.dart`
- `lib/features/home/models/trip_model.dart`

تعرض الشاشة الرئيسية الرحلات القادمة أو المقترحة من:

```text
GET /trips/view.php
```

كما يوجد بحث محلي داخل الرحلات المحملة في `HomeProvider.filteredTrips`.

### 6.4 البحث Search

الملفات المهمة:

- `lib/features/search/screens/search_screen.dart`
- `lib/features/search/screens/flight_list_screen.dart`
- `lib/features/search/providers/search_provider.dart`
- `lib/features/search/services/departure_points_service.dart`
- `lib/features/search/models/departure_point_model.dart`
- `lib/core/utils/syrian_cities.dart`

البحث يعتمد على:

- اختيار مدينة الانطلاق.
- اختيار مدينة الوصول.
- اختيار نقطة الانطلاق.
- اختيار التاريخ.
- وجود `user_id` من الجلسة.

توجد بيانات احتياطية لنقاط الانطلاق لأن endpoint القائمة غير مكتمل حسب `backend_requirements.md`.

### 6.5 تفاصيل الرحلة والحجز

الملفات المهمة:

- `lib/features/trip_details/screens/trip_details_screen.dart`
- `lib/features/trip_details/providers/trip_details_provider.dart`
- `lib/features/trip_details/models/trip_details_args.dart`
- `lib/features/trip_details/widgets/trip_details_dialogs.dart`
- `lib/features/bookings/services/bookings_service.dart`

العمليات المدعومة:

- إنشاء حجز: `POST /reservations/add.php`
- تعديل حجز: `PUT /reservations/update.php` مع fallback إلى `POST`
- إلغاء حجز: `PUT /reservations/status.php` مع fallback إلى `POST`
- جلب حجوزات المستخدم: `GET /reservations/index.php?user_id=...`

### 6.6 حجوزاتي

الملفات المهمة:

- `lib/features/bookings/screens/my_bookings_screen.dart`
- `lib/features/bookings/providers/bookings_provider.dart`
- `lib/features/bookings/models/booking_model.dart`
- `lib/features/bookings/models/booking_filter.dart`

تعرض الشاشة حجوزات المستخدم وتفلترها إلى:

- الكل.
- قادمة.
- ملغاة.
- مكتملة.

`BookingModel` يحسب حالة العرض من `res_status` وتاريخ الرحلة.

### 6.7 الشركات

الملفات المهمة:

- `lib/features/companies/screens/companies_screen.dart`
- `lib/features/companies/providers/companies_provider.dart`
- `lib/features/companies/services/companies_service.dart`
- `lib/features/companies/models/company_model.dart`

الشركات تُجلب من:

```text
GET /company/index.php
```

إذا فشل الـ API، يستخدم التطبيق بيانات mock تعليمية من `CompaniesService.mockCompanies`.

### 6.8 طلب رحلة مخصصة

الملفات المهمة:

- `lib/features/custom_trip/screens/custom_trip_screen.dart`
- `lib/features/custom_trip/providers/custom_trip_provider.dart`
- `lib/features/custom_trip/services/custom_trip_service.dart`

يرسل الطلب إلى:

```text
POST /special_requests/index.php
```

ويعتمد على جدول `special_requests` في `db_schema.sql`.

### 6.9 الملف الشخصي

الملفات المهمة:

- `lib/features/profile/screens/profile_screen.dart`
- `lib/features/profile/screens/profile_content_screen.dart`
- `lib/features/profile/providers/profile_provider.dart`
- `lib/features/profile/services/profile_service.dart`
- `lib/features/profile/data/profile_legal_content.dart`

يدعم:

- جلب بيانات المستخدم: `GET /users/index.php?user_id=...`
- تحديث الاسم والهاتف والصورة: `PUT /users/update.php` مع fallback إلى `POST`
- عرض صفحات المساعدة والخصوصية والشروط.

---

## 7. قاعدة البيانات والـ API

### الجداول المهمة في `db_schema.sql`

| الجدول | دوره في التطبيق |
|---|---|
| `users` | بيانات المستخدمين وحساباتهم. |
| `trips` | الرحلات المتاحة بين المدن. |
| `reservations` | الحجوزات التي تربط المستخدمين بالرحلات. |
| `company` | شركات النقل. |
| `departure_points` | نقاط الانطلاق داخل المدن. |
| `special_requests` | طلبات الرحلات المخصصة. |
| `payments` | مدفوعات الحجوزات، غير مستخدمة حالياً في الواجهة. |
| `employees` | موظفو الشركات أو الإدارة، غير مستخدمين حالياً في تطبيق المستخدم. |

### أهم endpoints المستخدمة

| الغرض | Method | Path |
|---|---:|---|
| تسجيل الدخول | `POST` | `/users/login.php` |
| إنشاء حساب | `POST` | `/users/create.php` |
| جلب الملف الشخصي | `GET` | `/users/index.php` |
| تحديث الملف الشخصي | `PUT/POST` | `/users/update.php` |
| جلب الرحلات | `GET` | `/trips/view.php` |
| البحث عن رحلات | `POST/GET` | `/trips/index.php` |
| جلب نقاط الانطلاق | `GET` | `/departure_points/index.php` |
| جلب الشركات | `GET` | `/company/index.php` |
| جلب حجوزات المستخدم | `GET` | `/reservations/index.php` |
| إضافة حجز | `POST` | `/reservations/add.php` |
| تعديل حجز | `PUT/POST` | `/reservations/update.php` |
| إلغاء حجز | `PUT/POST` | `/reservations/status.php` |
| طلب رحلة مخصصة | `POST` | `/special_requests/index.php` |

### ملاحظات تكامل مهمة

- `ApiEndpoints.baseUrl` مضبوط حالياً داخل الكود:

```dart
static const String baseUrl =
    'https://wheat-magpie-215255.hostingersite.com';
```

- لا يوجد ملف `.env` حالياً.
- بعض خوادم PHP قد لا تدعم `PUT`، لذلك توجد fallbacks إلى `POST` في خدمات مثل `ProfileService` و `BookingsService`.
- بعض endpoints غير مكتملة أو لا تطابق احتياج الواجهة، لذلك وُثق ذلك في `backend_requirements.md`.
- بعض الخدمات تستخدم بيانات mock مؤقتة عند فشل الـ API أو نقص endpoint، مثل `DeparturePointsService` و `CompaniesService`.

---

## 8. تعليمات الإعداد والتشغيل

### المتطلبات

قبل تشغيل المشروع، تأكد من تثبيت:

- Flutter SDK متوافق مع Dart SDK المحدد في `pubspec.yaml`:

```yaml
environment:
  sdk: ^3.12.0
```

- Android Studio أو VS Code/Cursor مع إضافات Flutter وDart.
- Android Emulator أو جهاز حقيقي.
- Git.

### خطوات التشغيل المحلي

1. انتقل إلى مجلد المشروع:

```powershell
cd C:\Users\CMD\Desktop\pullmanat_app
```

2. تأكد من جاهزية Flutter:

```powershell
flutter doctor
```

3. ثبّت الاعتمادات:

```powershell
flutter pub get
```

4. شغّل التحليل الساكن:

```powershell
flutter analyze
```

5. شغّل الاختبارات:

```powershell
flutter test
```

6. شغّل التطبيق على جهاز متصل أو محاكي:

```powershell
flutter run
```

### تشغيل على منصة محددة

Android:

```powershell
flutter run -d android
```

Chrome/Web:

```powershell
flutter run -d chrome
```

Windows Desktop:

```powershell
flutter run -d windows
```

### أوامر البناء

Android APK:

```powershell
flutter build apk
```

Android App Bundle:

```powershell
flutter build appbundle
```

Web:

```powershell
flutter build web
```

Windows:

```powershell
flutter build windows
```

### إعداد قاعدة البيانات والبيئة

التطبيق الحالي لا يشغل قاعدة بيانات محلية مباشرة؛ هو يتصل بـ Backend خارجي عبر `ApiEndpoints.baseUrl`.

إذا كنت تعمل على Backend محلي:

1. استورد `db_schema.sql` في MariaDB/MySQL.
2. شغّل ملفات PHP الخاصة بالـ Backend على خادم محلي مثل XAMPP أو Laragon.
3. حدّث `ApiEndpoints.baseUrl` داخل:

```text
lib/core/network/api_endpoints.dart
```

مثال:

```dart
static const String baseUrl = 'http://localhost/back_end-pullmanat-garage-management';
```

4. افتح `postman_collections.json` في Postman وتأكد أن endpoints تعمل قبل اختبار التطبيق.

> ملاحظة: من الأفضل مستقبلاً نقل `baseUrl` إلى ملف بيئة أو `--dart-define` بدلاً من تثبيته داخل الكود.

---

## 9. دليل دراسة الكود: من أين تبدأ؟

إذا كنت طالباً أو متدرباً جديداً، لا تبدأ بقراءة كل الملفات عشوائياً. اتبع هذا المسار:

### الخطوة 1: نقطة الدخول

ابدأ من:

```text
lib/main.dart
```

افهم:

- كيف يتم تهيئة Flutter.
- لماذا يتم تحميل `AuthProvider` قبل `runApp`.
- كيف يتم تسجيل Providers عبر `MultiProvider`.
- كيف يستخدم التطبيق `MaterialApp.router`.

### الخطوة 2: التوجيه

اقرأ:

```text
lib/core/routing/app_routes.dart
lib/core/routing/app_router.dart
```

افهم:

- أسماء المسارات.
- كيف ينتقل التطبيق بين الشاشات.
- كيف يتم تمرير بيانات الرحلة إلى شاشة التفاصيل عبر `state.extra`.

### الخطوة 3: الشبكة والـ API

اقرأ:

```text
lib/core/network/api_endpoints.dart
lib/core/network/dio_client.dart
lib/core/network/api_exception.dart
```

ثم افتح:

```text
postman_collections.json
db_schema.sql
```

افهم العلاقة بين:

- endpoint في `ApiEndpoints`.
- request في Postman.
- جدول في قاعدة البيانات.
- model في Flutter.

### الخطوة 4: المصادقة والجلسة

اقرأ:

```text
lib/features/auth/providers/auth_provider.dart
lib/features/auth/services/auth_service.dart
lib/features/auth/models/user_model.dart
lib/core/storage/auth_session_storage.dart
```

هذه أفضل ميزة لفهم نمط المشروع لأنها تحتوي على:

- Provider.
- Service.
- Model.
- تخزين محلي.
- تعامل مع أخطاء API.

### الخطوة 5: الرحلات والبحث

اقرأ:

```text
lib/features/home/providers/home_provider.dart
lib/features/home/services/trips_service.dart
lib/features/home/models/trip_model.dart
lib/features/search/providers/search_provider.dart
lib/features/search/screens/search_screen.dart
```

هنا ستفهم كيف تدخل بيانات المستخدم من الواجهة ثم تتحول إلى request للـ API.

### الخطوة 6: الحجز

اقرأ:

```text
lib/features/trip_details/screens/trip_details_screen.dart
lib/features/trip_details/providers/trip_details_provider.dart
lib/features/bookings/services/bookings_service.dart
lib/features/bookings/models/booking_model.dart
```

هذه هي أهم دورة عمل تجارية في التطبيق: من عرض الرحلة إلى إنشاء الحجز وتحديث حالة الواجهة.

### الخطوة 7: باقي الميزات

بعد فهم التدفق الأساسي، اقرأ:

```text
lib/features/companies/
lib/features/custom_trip/
lib/features/profile/
lib/features/onboarding/
lib/features/splash/
```

هذه الميزات تكرر نفس النمط، لذلك ستكون أسهل بعد فهم المصادقة والبحث والحجز.

---

## 10. قواعد العمل على المشروع

### عند إضافة شاشة جديدة

ضعها داخل:

```text
lib/features/<feature_name>/screens/
```

ولا تضع داخلها طلبات API مباشرة.

### عند إضافة منطق حالة

ضعه داخل:

```text
lib/features/<feature_name>/providers/
```

واستخدم `ChangeNotifier` مع `notifyListeners`.

### عند إضافة endpoint جديد

1. أضف المسار في:

```text
lib/core/network/api_endpoints.dart
```

2. أنشئ أو حدّث service داخل:

```text
lib/features/<feature_name>/services/
```

3. إذا كان الـ endpoint غير موجود في Postman أو Backend، وثقه في:

```text
backend_requirements.md
```

4. إذا احتجت بيانات مؤقتة، اجعلها داخل Provider أو Service بشكل واضح ومحدود.

### عند إضافة model جديد

ضعه داخل:

```text
lib/features/<feature_name>/models/
```

واحرص أن يحتوي على:

- constructor واضح.
- `fromJson`.
- `toJson` عند الحاجة للإرسال.
- parsing آمن للأرقام والنصوص.

### التعليقات

الكود الحالي يستخدم تعليقات عربية تعليمية. عند إضافة منطق غير بديهي، اكتب تعليقاً عربياً قصيراً يشرح السبب، وليس فقط ما يفعله السطر.

مثال جيد:

```dart
// بعض خوادم PHP لا تدعم PUT — نجرب POST كاحتياط
if (error.response?.statusCode == 405) {
  await _dio.post(ApiEndpoints.reservationsUpdate, data: body);
  return;
}
```

---

## 11. ملاحظات جودة ومخاطر حالية

- `README.md` ما زال افتراضياً من Flutter ولا يشرح المشروع؛ هذا الملف يعوض ذلك كدليل onboarding.
- لا يوجد `.env` أو إعداد بيئات منفصل، والـ `baseUrl` مثبت داخل الكود.
- لا توجد طبقة authentication token أو interceptor لإضافة token، لأن الجلسة الحالية تعتمد على بيانات المستخدم المحفوظة فقط.
- لا توجد حماية مركزية للمسارات داخل `AppRouter` مثل `redirect` أو auth guards؛ الحماية حالياً تتم داخل الشاشات ومزودات الحالة.
- `LogInterceptor` مفعّل دائماً ويطبع bodies للطلبات والاستجابات، لذلك يجب تعطيله أو تقييده قبل إصدار إنتاجي.
- صلاحية الإنترنت موجودة في `android/app/src/debug/AndroidManifest.xml` فقط، وليست في `android/app/src/main/AndroidManifest.xml`؛ قد تفشل طلبات الشبكة في build الإصدار على Android.
- بعض الخدمات تستخدم fallback بسبب اختلاف دعم PHP لبعض methods مثل `PUT`.
- بعض بيانات قاعدة البيانات التجريبية في `db_schema.sql` غير نظيفة، لذلك يجب عدم اعتبارها بيانات إنتاج.
- يوجد اختبار واحد فقط في `test/widget_test.dart`، وهو اختبار smoke بسيط للتأكد من تحميل التطبيق.
- لا توجد اختبارات unit للـ Providers أو Services حالياً.
- بعض endpoints الناقصة أو غير المكتملة موثقة في `backend_requirements.md`.
- قواعد المشروع تشير إلى `figma_screens/` و `postman_collection.json`، بينما الموجود فعلياً هو `postman_collections.json` ولم يظهر مجلد `figma_screens/` ضمن هيكل المشروع الحالي.

---

## 12. خريطة ذهنية مختصرة

إذا أردت تلخيص المشروع في جملة واحدة:

> الواجهة تعرض شاشات عربية لحجز رحلات، الـ Provider يدير الحالة ومنطق العمل، الـ Service يتصل بالـ API عبر Dio، والـ Model يحول بيانات JSON إلى كائنات يستخدمها التطبيق.

الخريطة المختصرة:

```text
main.dart
  ├── MultiProvider
  ├── AppTheme
  └── AppRouter

AppRouter
  └── Screens
      └── Providers
          └── Services
              └── DioClient
                  └── Backend API

Backend API
  └── JSON
      └── Models
          └── Providers notifyListeners
              └── UI rebuild
```

---

## 13. قائمة قراءة سريعة للمتدرب

اقرأ الملفات بهذا الترتيب:

1. `lib/main.dart`
2. `lib/core/routing/app_routes.dart`
3. `lib/core/routing/app_router.dart`
4. `lib/core/network/api_endpoints.dart`
5. `lib/core/network/dio_client.dart`
6. `lib/features/auth/providers/auth_provider.dart`
7. `lib/features/auth/services/auth_service.dart`
8. `lib/features/auth/models/user_model.dart`
9. `lib/features/home/providers/home_provider.dart`
10. `lib/features/home/services/trips_service.dart`
11. `lib/features/search/providers/search_provider.dart`
12. `lib/features/search/screens/search_screen.dart`
13. `lib/features/trip_details/providers/trip_details_provider.dart`
14. `lib/features/bookings/services/bookings_service.dart`
15. `lib/features/bookings/models/booking_model.dart`
16. `db_schema.sql`
17. `postman_collections.json`
18. `backend_requirements.md`

بعد هذه القراءة، سيكون لديك تصور واضح عن معظم المشروع، ويمكنك بعدها قراءة أي ميزة جديدة بسهولة لأنها تتبع نفس النمط.
