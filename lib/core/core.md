# 📚 دليل مجلد Core - تطبيق مشوار

## 📋 جدول المحتويات
1. [نظرة عامة](#نظرة-عامة)
2. [هيكل المجلد](#هيكل-المجلد)
3. [app_initializer.dart](#app_initializerdart)
4. [مجلد constant](#مجلد-constant)
5. [مجلد lang](#مجلد-lang)
6. [مجلد themes](#مجلد-themes)
7. [مجلد utils](#مجلد-utils)
8. [أفضل الممارسات](#أفضل-الممارسات)

---

## 🎯 نظرة عامة

مجلد **Core** هو القلب النابض لتطبيق مشوار، حيث يحتوي على جميع الوظائف الأساسية والمشتركة التي يستخدمها التطبيق بأكمله. يتضمن:

- **تهيئة التطبيق** (App Initialization)
- **الثوابت والإعدادات** (Constants & Configuration)
- **الترجمة والتعريب** (Localization)
- **السمات والألوان** (Themes & Colors)
- **الأدوات المساعدة** (Utilities)

---

## 📁 هيكل المجلد

```
lib/core/
├── app_initializer.dart          # تهيئة التطبيق الرئيسية
├── constant/                     # الثوابت والإعدادات
│   ├── constant.dart            # الثوابت العامة والدوال المساعدة
│   ├── images.dart              # مسارات الصور والأيقونات
│   ├── logdata.dart             # تسجيل البيانات
│   ├── media_query.dart         # امتدادات MediaQuery
│   ├── send_notification.dart   # إرسال الإشعارات
│   ├── show_toast_dialog.dart   # عرض رسائل Toast
│   └── size_box.dart            # امتدادات SizedBox
├── lang/                         # ملفات الترجمة
│   ├── app_ar.dart              # الترجمة العربية
│   ├── app_en.dart              # الترجمة الإنجليزية
│   └── app_ur.dart              # الترجمة الأردية
├── themes/                       # السمات والتصميم
│   ├── appbar_cust.dart         # تخصيص AppBar
│   ├── button_them.dart         # تصميم الأزرار
│   ├── constant_colors.dart     # الألوان الثابتة
│   ├── custom_alert_dialog.dart # مربعات الحوار المخصصة
│   ├── custom_dialog_box.dart   # صناديق الحوار
│   ├── radio_button.dart        # أزرار الراديو
│   ├── responsive.dart          # التصميم المتجاوب
│   ├── styles.dart              # الأنماط العامة
│   └── text_field_them.dart     # تصميم حقول النص
└── utils/                        # الأدوات المساعدة
    ├── dark_theme_preference.dart    # تفضيلات الوضع الداكن
    ├── dark_theme_provider.dart      # مزود الوضع الداكن
    └── Preferences.dart              # إدارة SharedPreferences
```

---

## 🚀 app_initializer.dart

### الوصف
ملف **app_initializer.dart** هو نقطة البداية لتهيئة جميع خدمات التطبيق الأساسية قبل تشغيله.

### المكونات الرئيسية

#### 1. **AppInitializer Class**
```dart
class AppInitializer {
  static Future<void> initializeApp() async { ... }
}
```

### الوظائف الأساسية

#### ✅ `initializeFirebase()`
**الغرض:** تهيئة خدمات Firebase
- تهيئة Firebase Core
- إعداد معالج الرسائل في الخلفية
- تفعيل Firebase App Check للأمان

```dart
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

#### ✅ `initializeNotifications()`
**الغرض:** إعداد نظام الإشعارات
- تهيئة الإشعارات المحلية (Local Notifications)
- طلب أذونات الإشعارات للمستخدم
- إعداد قنوات الإشعارات لنظام Android

**مثال:**
```dart
await FirebaseMessaging.instance.requestPermission(
  alert: true,
  badge: true,
  sound: true,
);
```

#### ✅ `initializeGoogleMaps()`
**الغرض:** تهيئة خرائط Google
- استخدام Hybrid Composition لأجهزة Android API 29+
- تحسين أداء الخرائط

```dart
if (androidInfo.version.sdkInt > 28) {
  mapsImplementation.useAndroidViewSurface = true;
}
```

#### ✅ `setOrientation()`
**الغرض:** تحديد اتجاه الشاشة
- قفل التطبيق على الوضع العمودي فقط

```dart
await SystemChrome.setPreferredOrientations([
  DeviceOrientation.portraitUp,
  DeviceOrientation.portraitDown,
]);
```

#### ✅ `initializePreferences()`
**الغرض:** تهيئة SharedPreferences
- تحميل الإعدادات المحفوظة محلياً

#### 🔔 `firebaseMessagingBackgroundHandler()`
**الغرض:** معالجة الإشعارات في الخلفية
- استقبال رسائل FCM عندما يكون التطبيق مغلقاً
- عرض الإشعارات للمستخدم

### ترتيب التهيئة
```dart
1. WidgetsFlutterBinding.ensureInitialized()
2. initializeFirebase()
3. setOrientation()
4. initializePreferences()
5. initializeNotifications()
6. initializeGoogleMaps()
```

### الاستخدام في main.dart
```dart
void main() async {
  await AppInitializer.initializeApp();
  runApp(MyApp());
}
```

---

## 📦 مجلد constant

### 1. **constant.dart** - الثوابت والدوال المساعدة

#### 🔧 المتغيرات الثابتة الرئيسية

```dart
class Constant {
  // إعدادات Google Maps
  static String? kGoogleApiKey = "";
  
  // إعدادات العملة والقياس
  static String? distanceUnit = "KM";
  static String? currency = "KWD";
  static String? decimal = "2";
  static bool symbolAtRight = false;
  
  // إعدادات التطبيق
  static String? appVersion = "0.0";
  static String? driverRadius = "0";
  static String? homeScreenType = "UberHome";
  
  // إعدادات الخرائط
  static String liveTrackingMapType = "google";
  static String selectedMapType = 'google';
  
  // إعدادات الرحلات
  static String? rideOtp = "yes";
  static String? showDriverInfoBeforePayment = "no";
  static String? passengerCountRequired = "optional";
  
  // معلومات الاتصال
  static String? contactUsEmail = "";
  static String? contactUsAddress = "";
  static String? contactUsPhone = "";
  
  // الضرائب
  static List<TaxModel> allTaxList = [];
  static List<TaxModel> taxList = [];
}
```

#### 🛠️ الدوال المساعدة الرئيسية

##### 1. **getUserData()**
```dart
static UserModel getUserData() {
  final String user = Preferences.getString(Preferences.user);
  Map<String, dynamic> userMap = jsonDecode(user);
  return UserModel.fromJson(userMap);
}
```
**الاستخدام:**
```dart
UserModel currentUser = Constant.getUserData();
print(currentUser.firstName);
```

##### 2. **amountShow()**
```dart
String amountShow({required String? amount}) {
  // تنسيق المبلغ مع العملة
  return "$formattedAmount KWD";
}
```
**الاستخدام:**
```dart
Constant().amountShow(amount: "25.500"); // "25.50 KWD"
```

##### 3. **emptyView()**
```dart
static Widget emptyView(BuildContext context, String msg, bool isButtonShow)
```
**الاستخدام:**
```dart
Constant.emptyView(context, "لا توجد رحلات", false)
```

##### 4. **loader()**
```dart
static Widget loader(context, {Color? loadingcolor, Color? bgColor})
```
**الاستخدام:**
```dart
Constant.loader(context)
```

##### 5. **makePhoneCall()**
```dart
static Future<void> makePhoneCall(String phoneNumber) async {
  final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
  await launchUrl(launchUri);
}
```
**الاستخدام:**
```dart
await Constant.makePhoneCall("+96512345678");
```

##### 6. **openExternalMapWithDirections()**
```dart
static Future<void> openExternalMapWithDirections({
  required double originLat,
  required double originLng,
  required double destLat,
  required double destLng,
  String originTitle = 'Pickup',
  String destTitle = 'Dropoff',
})
```
**الاستخدام:**
```dart
await Constant.openExternalMapWithDirections(
  originLat: 29.3759,
  originLng: 47.9774,
  destLat: 29.3117,
  destLng: 47.4818,
  originTitle: 'موقع الاستلام',
  destTitle: 'الوجهة',
);
```

##### 7. **placeSelectAPI()**
```dart
Future<PlacesDetailsResponse?> placeSelectAPI(
  BuildContext context, 
  TextEditingController ctrl
)
```
**الاستخدام:**
```dart
final result = await Constant().placeSelectAPI(context, addressController);
if (result != null) {
  print(result.result.formattedAddress);
}
```

##### 8. **getDurationDistance()**
```dart
Future<dynamic> getDurationDistance({
  required LatLng departureLatLong,
  required LatLng destinationLatLong,
})
```
**الاستخدام:**
```dart
var data = await Constant().getDurationDistance(
  departureLatLong: LatLng(29.3759, 47.9774),
  destinationLatLong: LatLng(29.3117, 47.4818),
);
print("المسافة: ${data['distance']} كم");
print("المدة: ${data['duration']}");
```

##### 9. **uploadChatImageToFireStorage()**
```dart
static Future<Url> uploadChatImageToFireStorage(File image)
```
**الاستخدام:**
```dart
Url imageUrl = await Constant.uploadChatImageToFireStorage(imageFile);
print(imageUrl.url);
```

##### 10. **getAmount()**
```dart
static Future<String?> getAmount() async
```
**الاستخدام:**
```dart
String? walletBalance = await Constant.getAmount();
print("رصيد المحفظة: $walletBalance");
```

---

### 2. **images.dart** - مسارات الصور

```dart
class CustomImages {
  // الأيقونات
  static String defaultProfile = 'assets/icons/userAvatar.png';
  
  // ملفات Lottie
  static String loginJson = 'assets/files/loginAnimation.json';
}
```

**الاستخدام:**
```dart
Image.asset(CustomImages.defaultProfile)
```

---

### 3. **show_toast_dialog.dart** - رسائل Toast

```dart
class ShowToastDialog {
  // عرض رسالة Toast
  static void showToast(String? message, {
    EasyLoadingToastPosition position = EasyLoadingToastPosition.top
  })
  
  // عرض Loader
  static void showLoader(String message)
  
  // إغلاق Loader
  static void closeLoader()
}
```

**الاستخدام:**
```dart
// عرض رسالة
ShowToastDialog.showToast("تم الحفظ بنجاح");

// عرض loader
ShowToastDialog.showLoader("جاري التحميل...");

// إغلاق loader
ShowToastDialog.closeLoader();
```

---

### 4. **media_query.dart** - امتدادات MediaQuery

```dart
extension MediaQueryExtension on BuildContext {
  double getWidth(double percentage)
  double getHeight(double percentage)
}
```

**الاستخدام:**
```dart
Container(
  width: context.getWidth(0.8),  // 80% من عرض الشاشة
  height: context.getHeight(0.5), // 50% من ارتفاع الشاشة
)
```

---

### 5. **size_box.dart** - امتدادات SizedBox

```dart
extension SizedBoxExtension on BuildContext {
  Widget sizedBoxHeight(double percentage)
  Widget sizedBoxWidth(double percentage)
}
```

**الاستخدام:**
```dart
Column(
  children: [
    Text("مرحباً"),
    context.sizedBoxHeight(0.02), // مسافة 2% من ارتفاع الشاشة
    Text("أهلاً"),
  ],
)
```

---

## 🌍 مجلد lang - الترجمة والتعريب

### البنية
```
lang/
├── app_ar.dart  # الترجمة العربية (أكثر من 800 مفتاح)
├── app_en.dart  # الترجمة الإنجليزية (أكثر من 800 مفتاح)
└── app_ur.dart  # الترجمة الأردية
```

### الاستخدام

#### 1. **في الكود**
```dart
import 'package:get/get.dart';

Text('welcome_back'.tr)  // سيعرض "مرحباً بعودتك!" بالعربية
```

#### 2. **مع متغيرات**
```dart
'not_enough_balance_wallet'.trParams({
  'amount1': '5.000',
  'amount2': '10.000'
})
// النتيجة: "عذراً! لا يوجد رصيد كافٍ في محفظتك. لديك 5.000 ولكن تحتاج 10.000"
```

### أقسام الترجمة الرئيسية

#### 🔐 المصادقة (Authentication)
```dart
'welcome_back'
'login_subtitle'
'create_an_account'
'email_address'
'password'
'forgot_password'
'sign_up'
'verify_your_otp'
```

#### 🏠 الشاشة الرئيسية (Home)
```dart
'enter_destination'
'departure'
'pick_up_location'
'destination'
'search_destination'
'please_enter_pickup_address'
```

#### 🚗 الرحلات (Rides)
```dart
'all_rides'
'scheduled_rides'
'ride_details'
'track_ride'
'cancel_ride'
'add_review'
```

#### 💳 المدفوعات (Payments)
```dart
'select_payment_method'
'total_amount'
'discount'
'confirm_pay'
'wallet'
'cash'
```

#### ⚙️ الإعدادات (Settings)
```dart
'my_profile'
'change_password'
'change_language'
'dark_mode'
'notifications'
'privacy_policy'
'terms_conditions'
```

#### 📦 الباقات (Packages)
```dart
'packages'
'buy_packages'
'my_packages'
'available_km'
'used_km'
'buy_now'
```

#### 🔔 الاشتراكات (Subscriptions)
```dart
'subscriptions'
'create_subscription'
'subscription_details'
'cancel_subscription'
'one_way'
'two_way'
```

### إضافة ترجمة جديدة

#### الخطوة 1: إضافة المفتاح في app_en.dart
```dart
const Map<String, String> enUS = {
  'new_feature': 'New Feature',
  'new_feature_description': 'This is a new feature',
};
```

#### الخطوة 2: إضافة الترجمة العربية في app_ar.dart
```dart
const Map<String, String> arAE = {
  'new_feature': 'ميزة جديدة',
  'new_feature_description': 'هذه ميزة جديدة',
};
```

#### الخطوة 3: الاستخدام
```dart
Text('new_feature'.tr)
```

---

## 🎨 مجلد themes - السمات والتصميم

### 1. **constant_colors.dart** - الألوان الثابتة

#### نظام الألوان الرئيسي

```dart
class AppThemeData {
  // الألوان الأساسية
  static Color surface50 = const Color(0XFFFFFFFF);      // خلفية فاتحة
  static Color surface50Dark = const Color(0XFF09090B);  // خلفية داكنة
  
  // الألوان الرئيسية (Primary)
  static Color primary50 = const Color(0XFFE6F1FF);
  static Color primary200 = const Color(0XFF018484);     // اللون الأساسي للتطبيق
  static Color primary300 = const Color(0XFF018484);
  static Color primary300Dark = const Color(0XFF018484);
  
  // الألوان الرمادية (Grey)
  static Color grey50 = const Color(0XFF18181B);
  static Color grey100 = const Color(0XFFF4F4F5);
  static Color grey200 = const Color(0XFFE4E4E7);
  static Color grey300 = const Color(0XFFD4D4D8);
  static Color grey400 = const Color(0XFFA1A1AA);
  static Color grey500 = const Color(0XFF18181B);
  static Color grey800 = const Color(0XFF27272A);
  static Color grey900 = const Color(0XFF18181B);
  
  // الألوان الثانوية (Secondary)
  static Color secondary200 = const Color(0XFF018484);
  static Color secondary300 = const Color(0XFF018484);
  
  // ألوان الحالات
  static Color warning200 = const Color(0XFFF26850);    // تحذير
  static Color success200 = const Color(0XFF22C55E);    // نجاح
  static Color error200 = const Color(0XFFD61600);      // خطأ
  static Color info200 = const Color(0XFF50DAF2);       // معلومات
  
  // الخطوط
  static const String regular = 'Cairo';
  static const String medium = 'Cairo';
  static const String bold = 'Cairo';
  static const String semiBold = 'Cairo';
}
```

#### الاستخدام
```dart
Container(
  color: AppThemeData.primary200,
  child: Text(
    'مرحباً',
    style: TextStyle(
      color: AppThemeData.grey900,
      fontFamily: AppThemeData.medium,
    ),
  ),
)
```

---

### 2. **styles.dart** - الأنماط العامة

```dart
class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
      scaffoldBackgroundColor: isDarkTheme 
        ? AppThemeData.surface50Dark 
        : AppThemeData.surface50,
      primaryColor: isDarkTheme 
        ? AppThemeData.grey900Dark 
        : AppThemeData.grey900,
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,
      fontFamily: 'Cairo', // الخط الافتراضي للتطبيق
      // ... المزيد من الإعدادات
    );
  }
}
```

**الاستخدام:**
```dart
MaterialApp(
  theme: Styles.themeData(false, context), // الوضع الفاتح
  darkTheme: Styles.themeData(true, context), // الوضع الداكن
)
```

---

### 3. **button_them.dart** - تصميم الأزرار

#### أنواع الأزرار

##### 1. **زر عادي (buildButton)**
```dart
ButtonThem.buildButton(
  context,
  title: "تسجيل الدخول",
  btnColor: AppThemeData.primary200,
  txtColor: Colors.white,
  btnHeight: 50,
  radius: 8,
  onPress: () {
    // الإجراء عند الضغط
  },
)
```

##### 2. **زر بحدود (buildBorderButton)**
```dart
ButtonThem.buildBorderButton(
  context,
  title: "إلغاء",
  btnBorderColor: AppThemeData.primary200,
  txtColor: AppThemeData.primary200,
  onPress: () {
    // الإجراء عند الضغط
  },
)
```

##### 3. **زر مع أيقونة (buildIconButton)**
```dart
ButtonThem.buildIconButton(
  context,
  title: "اتصل الآن",
  icon: Icons.phone,
  iconColor: Colors.white,
  btnColor: AppThemeData.success200,
  onPress: () {
    // الإجراء عند الضغط
  },
)
```

##### 4. **زر مع Widget مخصص (buildIconButtonWidget)**
```dart
ButtonThem.buildIconButtonWidget(
  context,
  title: "تسجيل الدخول بجوجل",
  icon: SvgPicture.asset('assets/icons/ic_google.svg'),
  iconColor: Colors.white,
  onPress: () {
    // الإجراء عند الضغط
  },
)
```

---

### 4. **text_field_them.dart** - حقول النص

#### أنواع حقول النص

##### 1. **حقل نص عادي (TextFieldWidget)**
```dart
TextFieldWidget(
  hintText: "أدخل البريد الإلكتروني",
  controller: emailController,
  textInputType: TextInputType.emailAddress,
  validators: (value) {
    if (value!.isEmpty) return "هذا الحقل مطلوب";
    return null;
  },
)
```

##### 2. **حقل رقم الجوال (MobileTextFieldWidget)**
```dart
MobileTextFieldWidget(
  hintText: "رقم الجوال",
  controller: phoneController,
  onChanged: (PhoneNumber number) {
    print(number.completeNumber);
  },
)
```

##### 3. **حقل نص بحدود (TextFieldWidgetBorder)**
```dart
TextFieldWidgetBorder(
  hintText: "اكتب رسالتك هنا",
  controller: messageController,
  maxLine: 5,
  radius: BorderRadius.circular(12),
)
```

#### خصائص مشتركة
```dart
TextFieldWidget(
  hintText: "النص التوضيحي",
  controller: controller,
  textInputType: TextInputType.text,
  obscureText: true,              // لإخفاء النص (كلمات المرور)
  maxLine: 1,                     // عدد الأسطر
  maxLength: 300,                 // الحد الأقصى للأحرف
  enabled: true,                  // تفعيل/تعطيل الحقل
  isReadOnly: false,              // للقراءة فقط
  prefix: Icon(Icons.email),      // أيقونة في البداية
  suffix: Icon(Icons.visibility), // أيقونة في النهاية
  validators: (value) { ... },   // دالة التحقق
  onChanged: (value) { ... },    // عند التغيير
  onTap: () { ... },             // عند الضغط
)
```

---

### 5. **responsive.dart** - التصميم المتجاوب

```dart
class Responsive {
  static double width(double percentage, BuildContext context) {
    return MediaQuery.of(context).size.width * (percentage / 100);
  }
  
  static double height(double percentage, BuildContext context) {
    return MediaQuery.of(context).size.height * (percentage / 100);
  }
}
```

**الاستخدام:**
```dart
Container(
  width: Responsive.width(80, context),   // 80% من عرض الشاشة
  height: Responsive.height(50, context), // 50% من ارتفاع الشاشة
)
```

---

## 🛠️ مجلد utils - الأدوات المساعدة

### 1. **Preferences.dart** - إدارة SharedPreferences

#### الثوابت المتاحة
```dart
class Preferences {
  static const isFinishOnBoardingKey = "isFinishOnBoardingKey";
  static const languageCodeKey = "languageCodeKey";
  static const isLogin = "isLogin";
  static const userId = "userId";
  static const user = "userData";
  static const paymentSetting = "paymentSetting";
  static const currency = "currency";
  static const accesstoken = "accesstoken";
  static const admincommission = "adminCommission";
}
```

#### الدوال المتاحة

##### 1. **التهيئة**
```dart
await Preferences.initPref();
```

##### 2. **حفظ واسترجاع Boolean**
```dart
// حفظ
await Preferences.setBoolean(Preferences.isLogin, true);

// استرجاع
bool isLoggedIn = Preferences.getBoolean(Preferences.isLogin);
```

##### 3. **حفظ واسترجاع String**
```dart
// حفظ
await Preferences.setString(Preferences.user, jsonEncode(userData));

// استرجاع
String userData = Preferences.getString(Preferences.user);
```

##### 4. **حفظ واسترجاع Int**
```dart
// حفظ
await Preferences.setInt(Preferences.userId, 12345);

// استرجاع
int userId = Preferences.getInt(Preferences.userId);
```

##### 5. **مسح البيانات**
```dart
// مسح كل البيانات
await Preferences.clearSharPreference();

// مسح مفتاح محدد
await Preferences.clearKeyData(Preferences.user);
```

#### مثال عملي كامل
```dart
// عند تسجيل الدخول
Future<void> saveUserData(UserModel user) async {
  await Preferences.setBoolean(Preferences.isLogin, true);
  await Preferences.setInt(Preferences.userId, user.id);
  await Preferences.setString(Preferences.user, jsonEncode(user.toJson()));
  await Preferences.setString(Preferences.accesstoken, user.token);
}

// عند التحقق من تسجيل الدخول
bool isUserLoggedIn() {
  return Preferences.getBoolean(Preferences.isLogin);
}

// عند تسجيل الخروج
Future<void> logout() async {
  await Preferences.clearSharPreference();
}
```

---

### 2. **dark_theme_provider.dart** - مزود الوضع الداكن

```dart
class DarkThemeProvider with ChangeNotifier {
  int _darkTheme = 0; // 0: داكن، 1: فاتح، 2: تلقائي
  
  int get darkTheme => _darkTheme;
  
  set darkTheme(int value) {
    _darkTheme = value;
    darkThemePreference.setDarkTheme(value);
    notifyListeners();
  }
  
  bool getThem() {
    return darkTheme == 0
        ? true  // داكن
        : darkTheme == 1
            ? false  // فاتح
            : getSystemThem(); // تلقائي حسب النظام
  }
  
  bool getSystemThem() {
    var brightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;
    return brightness == Brightness.dark;
  }
}
```

#### الاستخدام

##### 1. **إعداد Provider في main.dart**
```dart
void main() {
  runApp(
    ChangeNotifierProvider<DarkThemeProvider>(
      create: (_) => DarkThemeProvider(),
      child: MyApp(),
    ),
  );
}
```

##### 2. **استخدام الوضع الداكن في Widget**
```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    
    return Container(
      color: themeChange.getThem() 
        ? AppThemeData.surface50Dark  // لون الوضع الداكن
        : AppThemeData.surface50,     // لون الوضع الفاتح
      child: Text(
        'مرحباً',
        style: TextStyle(
          color: themeChange.getThem()
            ? AppThemeData.grey900Dark
            : AppThemeData.grey900,
        ),
      ),
    );
  }
}
```

##### 3. **تغيير الوضع**
```dart
// تفعيل الوضع الداكن
themeChange.darkTheme = 0;

// تفعيل الوضع الفاتح
themeChange.darkTheme = 1;

// تفعيل الوضع التلقائي (حسب النظام)
themeChange.darkTheme = 2;
```

##### 4. **مثال: زر تبديل الوضع**
```dart
Switch(
  value: themeChange.darkTheme == 0,
  onChanged: (value) {
    themeChange.darkTheme = value ? 0 : 1;
  },
)
```

---

### 3. **dark_theme_preference.dart** - تفضيلات الوضع الداكن

```dart
class DarkThemePreference {
  static const THEME_STATUS = "THEMESTATUS";
  
  // حفظ الوضع
  Future<void> setDarkTheme(int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(THEME_STATUS, value);
  }
  
  // استرجاع الوضع
  Future<int> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(THEME_STATUS) ?? 2; // الافتراضي: تلقائي
  }
}
```

---

## 📚 أفضل الممارسات

### 1. **استخدام الثوابت**
❌ **خطأ:**
```dart
Text('مرحباً بعودتك!')
```

✅ **صحيح:**
```dart
Text('welcome_back'.tr)
```

---

### 2. **استخدام الألوان**
❌ **خطأ:**
```dart
Container(color: Color(0XFF018484))
```

✅ **صحيح:**
```dart
Container(color: AppThemeData.primary200)
```

---

### 3. **التصميم المتجاوب**
❌ **خطأ:**
```dart
Container(width: 300, height: 200)
```

✅ **صحيح:**
```dart
Container(
  width: Responsive.width(80, context),
  height: Responsive.height(25, context),
)
```

أو:
```dart
Container(
  width: context.getWidth(0.8),
  height: context.getHeight(0.25),
)
```

---

### 4. **الوضع الداكن**
❌ **خطأ:**
```dart
Container(color: Colors.white)
```

✅ **صحيح:**
```dart
final themeChange = Provider.of<DarkThemeProvider>(context);
Container(
  color: themeChange.getThem() 
    ? AppThemeData.surface50Dark 
    : AppThemeData.surface50,
)
```

---

### 5. **حفظ البيانات**
❌ **خطأ:**
```dart
SharedPreferences prefs = await SharedPreferences.getInstance();
await prefs.setString('user', userData);
```

✅ **صحيح:**
```dart
await Preferences.setString(Preferences.user, userData);
```

---

### 6. **عرض رسائل Toast**
❌ **خطأ:**
```dart
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(content: Text('تم الحفظ'))
);
```

✅ **صحيح:**
```dart
ShowToastDialog.showToast('تم الحفظ بنجاح');
```

---

### 7. **عرض Loader**
❌ **خطأ:**
```dart
showDialog(
  context: context,
  builder: (_) => CircularProgressIndicator(),
);
```

✅ **صحيح:**
```dart
ShowToastDialog.showLoader('جاري التحميل...');
// ... عملية طويلة
ShowToastDialog.closeLoader();
```

---

### 8. **استخدام الخطوط**
❌ **خطأ:**
```dart
Text(
  'مرحباً',
  style: TextStyle(fontFamily: 'Cairo'),
)
```

✅ **صحيح:**
```dart
Text(
  'مرحباً',
  style: TextStyle(fontFamily: AppThemeData.medium),
)
```

---

### 9. **التحقق من الحقول**
❌ **خطأ:**
```dart
TextFormField(
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'هذا الحقل مطلوب';
    }
    return null;
  },
)
```

✅ **صحيح:**
```dart
TextFieldWidget(
  hintText: 'email_address'.tr,
  controller: emailController,
  validators: (value) {
    if (value!.isEmpty) return 'email_required'.tr;
    if (!value.contains('@')) return 'invalid_email_format'.tr;
    return null;
  },
)
```

---

### 10. **استخدام الأزرار**
❌ **خطأ:**
```dart
ElevatedButton(
  onPressed: () {},
  child: Text('تسجيل الدخول'),
)
```

✅ **صحيح:**
```dart
ButtonThem.buildButton(
  context,
  title: 'login'.tr,
  btnColor: AppThemeData.primary200,
  radius: 8,
  onPress: () {
    // الإجراء
  },
)
```

---

## 🔍 نصائح إضافية

### 1. **تنظيم الكود**
- استخدم الثوابت من `Constant` بدلاً من القيم المباشرة
- استخدم الألوان من `AppThemeData` لضمان التناسق
- استخدم الترجمة `.tr` لجميع النصوص

### 2. **الأداء**
- استخدم `const` للـ Widgets الثابتة
- تجنب إعادة بناء الـ Widgets غير الضرورية
- استخدم `Provider` بشكل صحيح

### 3. **الصيانة**
- اتبع نفس نمط التسمية في جميع الملفات
- أضف تعليقات للكود المعقد
- حافظ على تنظيم الملفات

### 4. **الأمان**
- لا تحفظ معلومات حساسة في SharedPreferences
- استخدم Firebase App Check للأمان
- تحقق من صلاحيات المستخدم

---

## 📝 ملاحظات مهمة

### 1. **التهيئة الإلزامية**
يجب استدعاء `AppInitializer.initializeApp()` قبل تشغيل التطبيق:
```dart
void main() async {
  await AppInitializer.initializeApp();
  runApp(MyApp());
}
```

### 2. **الترجمة**
- جميع النصوص يجب أن تكون مترجمة
- استخدم `.tr` لعرض الترجمة
- أضف المفاتيح الجديدة في جميع ملفات اللغات

### 3. **الألوان**
- استخدم الألوان من `AppThemeData` فقط
- لا تستخدم ألوان مباشرة في الكود
- دعم الوضع الداكن إلزامي

### 4. **الخطوط**
- الخط الافتراضي هو Cairo
- استخدم `AppThemeData.regular`, `AppThemeData.medium`, `AppThemeData.bold`

---

## 🎯 الخلاصة

مجلد **Core** هو الأساس الذي يبنى عليه التطبيق بأكمله. يحتوي على:

✅ **التهيئة**: Firebase, Notifications, Maps, Preferences  
✅ **الثوابت**: API Keys, Settings, Helper Functions  
✅ **الترجمة**: دعم متعدد اللغات (عربي، إنجليزي، أردو)  
✅ **السمات**: ألوان، خطوط، أزرار، حقول نص  
✅ **الأدوات**: SharedPreferences, Dark Mode, Extensions  

### الاستخدام الصحيح لهذا المجلد يضمن:
- 🎨 تصميم متناسق في جميع أنحاء التطبيق
- 🌍 دعم سلس للغات متعددة
- 🌓 تبديل سهل بين الوضع الفاتح والداكن
- 📱 تصميم متجاوب على جميع الأجهزة
- 🔧 صيانة وتطوير أسهل

---

## 📞 للمساعدة

إذا كان لديك أي استفسار حول استخدام مجلد Core، يرجى:
1. مراجعة هذا الدليل أولاً
2. فحص الأمثلة الموجودة في الكود
3. التواصل مع فريق التطوير

---

**آخر تحديث:** فبراير 2026  
**الإصدار:** 1.0.0  
**المطور:** فريق مشوار
