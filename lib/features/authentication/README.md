# 🔐 دليل مجلد Authentication - تطبيق مشوار

## 📋 جدول المحتويات
1. [نظرة عامة](#نظرة-عامة)
2. [هيكل المجلد](#هيكل-المجلد)
3. [نموذج البيانات (Model)](#نموذج-البيانات-model)
4. [المتحكمات (Controllers)](#المتحكمات-controllers)
5. [الشاشات (Views)](#الشاشات-views)
6. [الواجهات المخصصة (Widgets)](#الواجهات-المخصصة-widgets)
7. [تدفق المصادقة](#تدفق-المصادقة)
8. [أمثلة الاستخدام](#أمثلة-الاستخدام)
9. [أفضل الممارسات](#أفضل-الممارسات)

---

## 🎯 نظرة عامة

مجلد **Authentication** يحتوي على جميع وظائف المصادقة والتسجيل في تطبيق مشوار، بما في ذلك:

- ✅ تسجيل الدخول بالبريد الإلكتروني وكلمة المرور
- ✅ تسجيل الدخول برقم الجوال + OTP
- ✅ تسجيل الدخول بحساب Google
- ✅ تسجيل الدخول بحساب Apple
- ✅ إنشاء حساب جديد
- ✅ التحقق من OTP
- ✅ نسيت كلمة المرور
- ✅ إعادة تعيين كلمة المرور

---

## 📁 هيكل المجلد

```
lib/features/authentication/
├── controller/                           # المتحكمات (Business Logic)
│   ├── login_conroller.dart             # متحكم تسجيل الدخول
│   ├── sign_up_controller.dart          # متحكم التسجيل
│   ├── phone_number_controller.dart     # متحكم رقم الجوال
│   ├── otp_controller.dart              # متحكم OTP
│   ├── forgot_password_controller.dart  # متحكم نسيت كلمة المرور
│   └── sign_success_controller.dart     # متحكم نجاح التسجيل
│
├── model/                                # نماذج البيانات
│   └── user_model.dart                  # نموذج المستخدم
│
├── view/                                 # الشاشات
│   ├── login_screen.dart                # شاشة تسجيل الدخول
│   ├── signup_screen.dart               # شاشة التسجيل
│   ├── mobile_number_screen.dart        # شاشة رقم الجوال
│   ├── otp_screen.dart                  # شاشة OTP
│   ├── forgot_password.dart             # شاشة نسيت كلمة المرور
│   ├── forgot_password_otp_screen.dart  # شاشة OTP لإعادة التعيين
│   └── signup_success_screen.dart       # شاشة نجاح التسجيل
│
└── widget/                               # الواجهات المخصصة
    ├── auth_screen_layout.dart          # تخطيط شاشات المصادقة
    ├── auth_header_widget.dart          # رأس شاشات المصادقة
    ├── auth_background_widget.dart      # خلفية شاشات المصادقة
    ├── auth_form_card.dart              # بطاقة النموذج
    ├── auth_divider_widget.dart         # فاصل "أو تابع مع"
    ├── auth_widgets.dart                # واجهات مشتركة
    ├── otp_input_widget.dart            # حقل إدخال OTP
    ├── phone_input_widget.dart          # حقل إدخال الجوال
    └── social_login_button.dart         # أزرار تسجيل الدخول الاجتماعي
```

---

## 📊 نموذج البيانات (Model)

### UserModel - نموذج المستخدم

```dart
class UserModel {
  String? success;      // حالة النجاح
  dynamic error;        // رسالة الخطأ
  String? message;      // رسالة الاستجابة
  User? data;          // بيانات المستخدم
}
```

### User - بيانات المستخدم

```dart
class User {
  String? id;                    // معرف المستخدم
  String? nom;                   // الاسم الأول
  String? prenom;                // اسم العائلة
  String? email;                 // البريد الإلكتروني
  String? phone;                 // رقم الجوال
  String? loginType;             // نوع تسجيل الدخول (email, phoneNumber, google, apple)
  String? photo;                 // صورة الملف الشخصي
  String? photoPath;             // مسار الصورة
  String? statut;                // حالة الحساب
  String? tonotify;              // تفعيل الإشعارات
  String? deviceId;              // معرف الجهاز
  String? fcmId;                 // معرف FCM للإشعارات
  DateTime? creer;               // تاريخ الإنشاء
  DateTime? updatedAt;           // تاريخ آخر تحديث
  String? amount;                // رصيد المحفظة
  String? age;                   // العمر
  String? gender;                // الجنس
  String? userCat;               // فئة المستخدم (customer)
  String? online;                // حالة الاتصال
  String? country;               // الدولة
  String? accesstoken;           // رمز الوصول
  String? adminCommission;       // عمولة الإدارة
}
```

### الاستخدام

```dart
// تحويل من JSON
UserModel user = UserModel.fromJson(responseBody);

// الوصول للبيانات
print(user.data?.nom);           // الاسم الأول
print(user.data?.email);         // البريد الإلكتروني
print(user.data?.phone);         // رقم الجوال
print(user.data?.accesstoken);   // رمز الوصول

// تحويل إلى JSON
Map<String, dynamic> json = user.toJson();

// حفظ في SharedPreferences
Preferences.setString(Preferences.user, jsonEncode(user));

// استرجاع من SharedPreferences
String userData = Preferences.getString(Preferences.user);
UserModel savedUser = UserModel.fromJson(jsonDecode(userData));
```

---

## 🎮 المتحكمات (Controllers)

### 1. LoginController - متحكم تسجيل الدخول

#### الوظائف الرئيسية

##### 📧 `loginAPI()` - تسجيل الدخول بالبريد الإلكتروني
```dart
Future<UserModel?> loginAPI(Map<String, String> bodyParams)
```

**المعاملات:**
```dart
{
  'email': 'user@example.com',
  'password': '123456',
  'user_cat': 'customer'
}
```

**الاستخدام:**
```dart
final controller = Get.put(LoginController());

Map<String, String> params = {
  'email': controller.phoneController.value.text,
  'password': controller.passwordController.value.text,
  'user_cat': 'customer',
};

UserModel? user = await controller.loginAPI(params);
if (user != null && user.success == "Success") {
  // حفظ البيانات
  Preferences.setInt(Preferences.userId, int.parse(user.data!.id!));
  Preferences.setString(Preferences.user, jsonEncode(user));
  Preferences.setBoolean(Preferences.isLogin, true);
  
  // الانتقال للشاشة الرئيسية
  Get.offAll(BottomNavBar());
}
```

##### 🔍 `phoneNumberIsExit()` - التحقق من وجود رقم الجوال
```dart
Future<bool?> phoneNumberIsExit(Map<String, String> bodyParams)
```

**المعاملات:**
```dart
{
  'user_cat': 'customer',
  'email': 'user@example.com',
  'login_type': 'google'
}
```

**الاستخدام:**
```dart
bool? exists = await controller.phoneNumberIsExit(params);
if (exists == true) {
  // المستخدم موجود - تسجيل الدخول
} else {
  // المستخدم غير موجود - التسجيل
  Get.to(SignupScreen());
}
```

##### 📱 `getDataByPhoneNumber()` - جلب بيانات المستخدم
```dart
Future<UserModel?> getDataByPhoneNumber(Map<String, String> bodyParams)
```

##### 🔵 `loginWithGoogle()` - تسجيل الدخول بـ Google
```dart
Future<void> loginWithGoogle() async
```

**الاستخدام:**
```dart
await controller.loginWithGoogle();
```

**التدفق:**
1. فتح نافذة تسجيل الدخول بـ Google
2. التحقق من وجود المستخدم في قاعدة البيانات
3. إذا كان موجوداً: تسجيل الدخول
4. إذا لم يكن موجوداً: الانتقال لشاشة التسجيل

##### 🍎 `loginWithApple()` - تسجيل الدخول بـ Apple
```dart
Future<void> loginWithApple() async
```

**الاستخدام:**
```dart
await controller.loginWithApple();
```

**ملاحظة:** متاح فقط على أجهزة iOS

---

### 2. SignUpController - متحكم التسجيل

#### المتغيرات
```dart
var firstNameController = TextEditingController().obs;
var lastNameController = TextEditingController().obs;
var phoneNumber = TextEditingController().obs;
var emailController = TextEditingController().obs;
var passwordController = TextEditingController().obs;
var conformPasswordController = TextEditingController().obs;
RxString loginType = "".obs;  // phoneNumber, google, apple, email
```

#### الوظائف

##### ✍️ `signUp()` - إنشاء حساب جديد
```dart
Future<UserModel?> signUp(Map<String, String> bodyParams)
```

**المعاملات:**
```dart
{
  'nom': 'أحمد',
  'prenom': 'محمد',
  'email': 'ahmed@example.com',
  'phone': '96512345678',
  'password': '123456',
  'user_cat': 'customer',
  'login_type': 'email'  // أو phoneNumber, google, apple
}
```

**الاستخدام:**
```dart
final controller = Get.put(SignUpController());

Map<String, String> params = {
  'nom': controller.firstNameController.value.text,
  'prenom': controller.lastNameController.value.text,
  'email': controller.emailController.value.text,
  'phone': controller.phoneNumber.value.text,
  'password': controller.passwordController.value.text,
  'user_cat': 'customer',
  'login_type': controller.loginType.value,
};

UserModel? user = await controller.signUp(params);
if (user != null) {
  // حفظ البيانات والانتقال
  Preferences.setString(Preferences.accesstoken, user.data!.accesstoken!);
  Get.to(SignupSuccessScreen());
}
```

---

### 3. PhoneNumberController - متحكم رقم الجوال

#### المتغيرات
```dart
var phoneNumber = TextEditingController().obs;
var resendTokenData = 0.obs;
```

#### الوظائف

##### 📲 `sendCode()` - إرسال OTP عبر Firebase
```dart
Future<void> sendCode() async
```

**الاستخدام:**
```dart
final controller = Get.put(PhoneNumberController());
controller.phoneNumber.value.text = "12345678";
await controller.sendCode();
```

**التدفق:**
1. إرسال OTP إلى رقم الجوال (+965xxxxxxxx)
2. عند النجاح: الانتقال لشاشة OTP
3. عند الفشل: عرض رسالة خطأ

##### 📧 `SendOTPApiMethod()` - إرسال OTP عبر API
```dart
Future SendOTPApiMethod(Map<String, String> bodyParams)
```

**المعاملات:**
```dart
{
  'mobile': '96512345678'
}
```

---

### 4. OTPController - متحكم التحقق من OTP

#### المتغيرات
```dart
RxString phoneNumber = "".obs;
var otpController = TextEditingController().obs;
var verificationId = ''.obs;
var resendToken = 0.obs;
RxInt secondsRemaining = 60.obs;
RxBool enableResend = false.obs;
Timer? timer;
```

#### الوظائف

##### ✅ `verifyOTP()` - التحقق من OTP
```dart
Future<void> verifyOTP() async
```

**الاستخدام:**
```dart
final controller = Get.put(OTPController());
// المستخدم يدخل OTP
controller.otpController.value.text = "123456";
await controller.verifyOTP();
```

##### 🔄 `resendOTP()` - إعادة إرسال OTP
```dart
Future<void> resendOTP() async
```

**الاستخدام:**
```dart
await controller.resendOTP();
```

**التدفق:**
1. إعادة إرسال OTP
2. إعادة تعيين المؤقت (60 ثانية)
3. تعطيل زر إعادة الإرسال

##### ⏱️ `startTimer()` - بدء مؤقت العد التنازلي
```dart
void startTimer()
```

---

### 5. ForgotPasswordController - متحكم نسيت كلمة المرور

#### الوظائف

##### 📧 `sendEmail()` - إرسال OTP للبريد الإلكتروني
```dart
Future<bool?> sendEmail(Map<String, String> bodyParams)
```

**المعاملات:**
```dart
{
  'email': 'user@example.com',
  'user_cat': 'customer'
}
```

**الاستخدام:**
```dart
final controller = Get.put(ForgotPasswordController());

Map<String, String> params = {
  'email': emailController.text,
  'user_cat': 'customer',
};

bool? sent = await controller.sendEmail(params);
if (sent == true) {
  Get.to(ForgotPasswordOtpScreen());
}
```

##### 🔐 `resetPassword()` - إعادة تعيين كلمة المرور
```dart
Future<bool?> resetPassword(Map<String, String> bodyParams)
```

**المعاملات:**
```dart
{
  'email': 'user@example.com',
  'otp': '123456',
  'password': 'newPassword123',
  'user_cat': 'customer'
}
```

**الاستخدام:**
```dart
Map<String, String> params = {
  'email': emailController.text,
  'otp': otpController.text,
  'password': newPasswordController.text,
  'user_cat': 'customer',
};

bool? reset = await controller.resetPassword(params);
if (reset == true) {
  ShowToastDialog.showToast('password_changed_successfully'.tr);
  Get.offAll(LoginScreen());
}
```

---

## 📱 الشاشات (Views)

### 1. LoginScreen - شاشة تسجيل الدخول

#### المكونات
- حقل البريد الإلكتروني
- حقل كلمة المرور
- زر "نسيت كلمة المرور"
- زر "تسجيل الدخول"
- فاصل "أو تابع مع"
- زر تسجيل الدخول بـ Google
- زر تسجيل الدخول بـ Apple (iOS فقط)
- زر "تسجيل الدخول برقم الجوال"
- رابط "إنشاء حساب"

#### الاستخدام
```dart
Get.to(LoginScreen());
```

#### مثال التحقق من الحقول
```dart
final _formKey = GlobalKey<FormState>();

Form(
  key: _formKey,
  child: Column(
    children: [
      CustomTextField(
        text: 'email_address'.tr,
        controller: controller.phoneController.value,
        validationType: ValidationType.email,
      ),
      CustomTextField(
        text: 'enter_password'.tr,
        controller: controller.passwordController.value,
        validationType: ValidationType.password,
        obscureText: true,
      ),
      CustomButton(
        text: 'login'.tr,
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            // تسجيل الدخول
            Map<String, String> params = {
              'email': controller.phoneController.value.text,
              'password': controller.passwordController.value.text,
              'user_cat': 'customer',
            };
            
            UserModel? user = await controller.loginAPI(params);
            if (user != null && user.success == "Success") {
              // حفظ البيانات
              Preferences.setInt(Preferences.userId, int.parse(user.data!.id!));
              Preferences.setString(Preferences.user, jsonEncode(user));
              Preferences.setBoolean(Preferences.isLogin, true);
              
              // الانتقال للشاشة الرئيسية
              Get.offAll(BottomNavBar());
            }
          }
        },
      ),
    ],
  ),
)
```

---

### 2. MobileNumberScreen - شاشة رقم الجوال

#### المعاملات
```dart
MobileNumberScreen({
  required bool isLogin,  // true للدخول، false للتسجيل
})
```

#### المكونات
- حقل رقم الجوال (8 أرقام للكويت)
- زر "إرسال OTP"
- رابط للتبديل بين الدخول والتسجيل

#### الاستخدام
```dart
// للتسجيل
Get.to(MobileNumberScreen(isLogin: false));

// لتسجيل الدخول
Get.to(MobileNumberScreen(isLogin: true));
```

#### التحقق من رقم الجوال
```dart
CustomTextField(
  text: 'mobile_number'.tr,
  controller: controller.phoneNumber.value,
  keyboardType: TextInputType.phone,
  maxLength: 8,
  validators: (value) {
    if (value == null || value.isEmpty) {
      return 'phone_number_is_required'.tr;
    }
    if (value.length != 8) {
      return 'kuwait_number_must_be_8_digits'.tr;
    }
    // التحقق من أن الرقم يبدأ بـ 5, 6, 9, 2, أو 41
    if (!RegExp(r'^[5692]|^41').hasMatch(value)) {
      return 'kuwait_numbers_start_with'.tr;
    }
    return null;
  },
)
```

---

### 3. OtpScreen - شاشة التحقق من OTP

#### المعاملات (Arguments)
```dart
{
  'phoneNumber': '+96512345678',
  'verificationId': 'xxx',  // من Firebase
  'resendTokenData': 12345,  // من Firebase
}
```

#### المكونات
- 6 حقول لإدخال OTP
- مؤقت عد تنازلي (60 ثانية)
- زر "إعادة إرسال OTP"
- زر "تحقق من OTP"

#### الاستخدام
```dart
Get.to(
  OtpScreen(),
  arguments: {
    'phoneNumber': '+96512345678',
    'verificationId': verificationId,
    'resendTokenData': resendToken,
  },
);
```

#### مثال واجهة OTP
```dart
OtpInputWidget(
  controller: controller.otpController.value,
  onCompleted: (otp) {
    // تم إدخال OTP كاملاً
    controller.verifyOTP();
  },
)

// مؤقت العد التنازلي
Obx(() => Text(
  controller.enableResend.value
    ? 'resend_otp'.tr
    : '${'resend_code_in'.tr}${controller.secondsRemaining.value}s',
))

// زر إعادة الإرسال
Obx(() => TextButton(
  onPressed: controller.enableResend.value
    ? () => controller.resendOTP()
    : null,
  child: Text('resend_otp'.tr),
))
```

---

### 4. SignupScreen - شاشة التسجيل

#### المعاملات (Arguments)
```dart
{
  'email': 'user@example.com',      // اختياري
  'firstName': 'أحمد',              // اختياري
  'lastname': 'محمد',               // اختياري
  'phoneNumber': '96512345678',     // اختياري
  'login_type': 'email',            // phoneNumber, google, apple
}
```

#### المكونات
- حقل الاسم الأول
- حقل اسم العائلة
- حقل البريد الإلكتروني
- حقل رقم الجوال (إذا كان login_type ليس phoneNumber)
- حقل كلمة المرور
- حقل تأكيد كلمة المرور
- زر "التسجيل"

#### الاستخدام
```dart
// تسجيل عادي
Get.to(SignupScreen());

// تسجيل بعد Google
Get.to(SignupScreen(), arguments: {
  'email': googleUser.email,
  'firstName': googleUser.displayName,
  'login_type': 'google',
});

// تسجيل بعد رقم الجوال
Get.to(SignupScreen(), arguments: {
  'phoneNumber': '96512345678',
  'login_type': 'phoneNumber',
});
```

#### مثال التحقق من الحقول
```dart
Form(
  key: _formKey,
  child: Column(
    children: [
      CustomTextField(
        text: 'first_name'.tr,
        controller: controller.firstNameController.value,
        validators: (value) {
          if (value == null || value.isEmpty) {
            return 'first_name_required'.tr;
          }
          if (value.length < 2) {
            return 'name_must_be_at_least_2_characters'.tr;
          }
          return null;
        },
      ),
      
      CustomTextField(
        text: 'email_address'.tr,
        controller: controller.emailController.value,
        validationType: ValidationType.email,
      ),
      
      CustomTextField(
        text: 'password'.tr,
        controller: controller.passwordController.value,
        validationType: ValidationType.password,
        obscureText: true,
      ),
      
      CustomTextField(
        text: 'confirm_password'.tr,
        controller: controller.conformPasswordController.value,
        validators: (value) {
          if (value != controller.passwordController.value.text) {
            return 'passwords_do_not_match'.tr;
          }
          return null;
        },
        obscureText: true,
      ),
      
      CustomButton(
        text: 'sign_up'.tr,
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            Map<String, String> params = {
              'nom': controller.firstNameController.value.text,
              'prenom': controller.lastNameController.value.text,
              'email': controller.emailController.value.text,
              'phone': controller.phoneNumber.value.text,
              'password': controller.passwordController.value.text,
              'user_cat': 'customer',
              'login_type': controller.loginType.value,
            };
            
            UserModel? user = await controller.signUp(params);
            if (user != null) {
              Get.to(SignupSuccessScreen());
            }
          }
        },
      ),
    ],
  ),
)
```

---

### 5. ForgotPasswordScreen - شاشة نسيت كلمة المرور

#### المكونات
- حقل البريد الإلكتروني
- زر "إرسال رابط إعادة التعيين"

#### الاستخدام
```dart
Get.to(ForgotPasswordScreen());
```

#### مثال
```dart
CustomTextField(
  text: 'email_address'.tr,
  controller: emailController,
  validationType: ValidationType.email,
)

CustomButton(
  text: 'send_reset_link'.tr,
  onPressed: () async {
    if (_formKey.currentState!.validate()) {
      Map<String, String> params = {
        'email': emailController.text,
        'user_cat': 'customer',
      };
      
      bool? sent = await controller.sendEmail(params);
      if (sent == true) {
        Get.to(ForgotPasswordOtpScreen(), arguments: {
          'email': emailController.text,
        });
      }
    }
  },
)
```

---

### 6. ForgotPasswordOtpScreen - شاشة إعادة تعيين كلمة المرور

#### المعاملات (Arguments)
```dart
{
  'email': 'user@example.com',
}
```

#### المكونات
- حقل OTP (6 أرقام)
- حقل كلمة المرور الجديدة
- حقل تأكيد كلمة المرور
- زر "إعادة تعيين كلمة المرور"

#### الاستخدام
```dart
Get.to(ForgotPasswordOtpScreen(), arguments: {
  'email': 'user@example.com',
});
```

#### مثال
```dart
OtpInputWidget(
  controller: otpController,
)

CustomTextField(
  text: 'new_password'.tr,
  controller: newPasswordController,
  validationType: ValidationType.password,
  obscureText: true,
)

CustomTextField(
  text: 'confirm_password'.tr,
  controller: confirmPasswordController,
  validators: (value) {
    if (value != newPasswordController.text) {
      return 'passwords_do_not_match'.tr;
    }
    return null;
  },
  obscureText: true,
)

CustomButton(
  text: 'reset_password'.tr,
  onPressed: () async {
    if (_formKey.currentState!.validate()) {
      Map<String, String> params = {
        'email': email,
        'otp': otpController.text,
        'password': newPasswordController.text,
        'user_cat': 'customer',
      };
      
      bool? reset = await controller.resetPassword(params);
      if (reset == true) {
        ShowToastDialog.showToast('password_changed_successfully'.tr);
        Get.offAll(LoginScreen());
      }
    }
  },
)
```

---

### 7. SignupSuccessScreen - شاشة نجاح التسجيل

#### المكونات
- أيقونة نجاح
- رسالة تهنئة
- زر "ابدأ الاستكشاف"
- زر "تخطي الآن"

#### الاستخدام
```dart
Get.to(SignupSuccessScreen());
```

#### مثال
```dart
Column(
  children: [
    Image.asset('assets/images/sucess_account.png'),
    
    Text(
      'account_created_successfully'.tr,
      style: TextStyle(
        fontSize: 24,
        fontFamily: AppThemeData.bold,
      ),
    ),
    
    Text(
      'signup_success_subtitle'.tr,
      textAlign: TextAlign.center,
    ),
    
    CustomButton(
      text: 'start_exploring'.tr,
      onPressed: () {
        Get.offAll(BottomNavBar());
      },
    ),
    
    TextButton(
      onPressed: () {
        Get.offAll(BottomNavBar());
      },
      child: Text('skip_for_now'.tr),
    ),
  ],
)
```

---

## 🎨 الواجهات المخصصة (Widgets)

### 1. AuthScreenLayout - تخطيط شاشات المصادقة

تخطيط موحد لجميع شاشات المصادقة مع خلفية وتصميم متناسق.

```dart
AuthScreenLayout({
  required String title,           // العنوان الرئيسي
  required String subtitle,        // العنوان الفرعي
  required Widget child,           // محتوى الشاشة
  Widget? bottomWidget,            // واجهة في الأسفل
  bool showBackButton = true,      // إظهار زر الرجوع
})
```

**الاستخدام:**
```dart
AuthScreenLayout(
  title: 'welcome_back'.tr,
  subtitle: 'login_subtitle'.tr,
  showBackButton: false,
  bottomWidget: AuthBottomLink(
    text: 'first_time_in_mshwar'.tr,
    linkText: 'create_an_account'.tr,
    onTap: () => Get.to(SignupScreen()),
  ),
  child: Column(
    children: [
      // حقول النموذج
    ],
  ),
)
```

---

### 2. AuthHeaderWidget - رأس شاشات المصادقة

```dart
AuthHeaderWidget({
  required String title,
  required String subtitle,
  bool showBackButton = true,
})
```

**الاستخدام:**
```dart
AuthHeaderWidget(
  title: 'create_your_account'.tr,
  subtitle: 'signup_subtitle'.tr,
  showBackButton: true,
)
```

---

### 3. AuthBackgroundWidget - خلفية شاشات المصادقة

خلفية متدرجة مع تصميم جذاب.

```dart
AuthBackgroundWidget({
  required Widget child,
})
```

**الاستخدام:**
```dart
AuthBackgroundWidget(
  child: YourContent(),
)
```

---

### 4. AuthFormCard - بطاقة النموذج

بطاقة بيضاء مع ظل لاحتواء حقول النموذج.

```dart
AuthFormCard({
  required Widget child,
  EdgeInsets? padding,
})
```

**الاستخدام:**
```dart
AuthFormCard(
  padding: EdgeInsets.all(24),
  child: Column(
    children: [
      CustomTextField(...),
      CustomTextField(...),
      CustomButton(...),
    ],
  ),
)
```

---

### 5. AuthDividerWidget - فاصل "أو تابع مع"

```dart
AuthDividerWidget({
  String text = 'or_continue_with',
})
```

**الاستخدام:**
```dart
AuthDividerWidget(
  text: 'or_continue_with'.tr,
)
```

**النتيجة:**
```
────────  أو تابع مع  ────────
```

---

### 6. OtpInputWidget - حقل إدخال OTP

واجهة مخصصة لإدخال OTP مكونة من 6 حقول.

```dart
OtpInputWidget({
  required TextEditingController controller,
  Function(String)? onCompleted,
  int length = 6,
})
```

**الاستخدام:**
```dart
OtpInputWidget(
  controller: otpController,
  length: 6,
  onCompleted: (otp) {
    print('OTP entered: $otp');
    // التحقق من OTP
    controller.verifyOTP();
  },
)
```

**المميزات:**
- 6 حقول منفصلة
- الانتقال التلقائي بين الحقول
- دعم اللصق من الحافظة
- تصميم متجاوب
- دعم الوضع الداكن

---

### 7. PhoneInputWidget - حقل إدخال رقم الجوال

```dart
PhoneInputWidget({
  required TextEditingController controller,
  String? Function(String?)? validators,
  bool enabled = true,
})
```

**الاستخدام:**
```dart
PhoneInputWidget(
  controller: phoneController,
  validators: (value) {
    if (value == null || value.isEmpty) {
      return 'phone_number_is_required'.tr;
    }
    if (value.length != 8) {
      return 'kuwait_number_must_be_8_digits'.tr;
    }
    return null;
  },
)
```

**المميزات:**
- رمز الدولة (+965) ثابت
- قناع للإدخال (8 أرقام)
- التحقق التلقائي
- تصميم متناسق

---

### 8. SocialLoginButton - أزرار تسجيل الدخول الاجتماعي

```dart
SocialLoginButton({
  required String text,
  required String iconPath,
  required VoidCallback onPressed,
  Color? backgroundColor,
  Color? textColor,
})
```

**الاستخدام:**
```dart
// زر Google
SocialLoginButton(
  text: 'google'.tr,
  iconPath: 'assets/icons/ic_google.svg',
  onPressed: () => controller.loginWithGoogle(),
  backgroundColor: Colors.white,
  textColor: Colors.black87,
)

// زر Apple
if (Platform.isIOS)
  SocialLoginButton(
    text: 'apple'.tr,
    iconPath: 'assets/icons/ic_apple.svg',
    onPressed: () => controller.loginWithApple(),
    backgroundColor: Colors.black,
    textColor: Colors.white,
  )
```

---

### 9. AuthBottomLink - رابط في أسفل الشاشة

```dart
AuthBottomLink({
  required String text,
  required String linkText,
  required VoidCallback onTap,
})
```

**الاستخدام:**
```dart
AuthBottomLink(
  text: 'first_time_in_mshwar'.tr,
  linkText: 'create_an_account'.tr,
  onTap: () => Get.to(SignupScreen()),
)
```

**النتيجة:**
```
أول مرة في مشوار؟ إنشاء حساب
                    ^^^^^^^^^ (رابط)
```

---

## 🔄 تدفق المصادقة

### 1. تسجيل الدخول بالبريد الإلكتروني

```
LoginScreen
    ↓
إدخال البريد وكلمة المرور
    ↓
LoginController.loginAPI()
    ↓
حفظ البيانات في Preferences
    ↓
BottomNavBar (الشاشة الرئيسية)
```

### 2. تسجيل الدخول برقم الجوال

```
LoginScreen
    ↓
الضغط على "تسجيل الدخول برقم الجوال"
    ↓
MobileNumberScreen (isLogin: true)
    ↓
إدخال رقم الجوال
    ↓
PhoneNumberController.sendCode()
    ↓
OtpScreen
    ↓
إدخال OTP
    ↓
OTPController.verifyOTP()
    ↓
التحقق من وجود المستخدم
    ├─ موجود → تسجيل الدخول → BottomNavBar
    └─ غير موجود → SignupScreen
```

### 3. التسجيل برقم الجوال

```
LoginScreen
    ↓
الضغط على "إنشاء حساب"
    ↓
MobileNumberScreen (isLogin: false)
    ↓
إدخال رقم الجوال
    ↓
PhoneNumberController.sendCode()
    ↓
OtpScreen
    ↓
إدخال OTP
    ↓
OTPController.verifyOTP()
    ↓
SignupScreen (phoneNumber مملوء مسبقاً)
    ↓
إدخال البيانات الشخصية
    ↓
SignUpController.signUp()
    ↓
SignupSuccessScreen
    ↓
BottomNavBar
```

### 4. تسجيل الدخول بـ Google

```
LoginScreen
    ↓
الضغط على زر Google
    ↓
LoginController.loginWithGoogle()
    ↓
فتح نافذة Google Sign In
    ↓
اختيار الحساب
    ↓
LoginController.phoneNumberIsExit()
    ├─ موجود → getDataByPhoneNumber() → BottomNavBar
    └─ غير موجود → SignupScreen (email مملوء مسبقاً)
```

### 5. تسجيل الدخول بـ Apple

```
LoginScreen
    ↓
الضغط على زر Apple (iOS فقط)
    ↓
LoginController.loginWithApple()
    ↓
فتح نافذة Apple Sign In
    ↓
Face ID / Touch ID
    ↓
LoginController.phoneNumberIsExit()
    ├─ موجود → getDataByPhoneNumber() → BottomNavBar
    └─ غير موجود → SignupScreen (email + name مملوء مسبقاً)
```

### 6. نسيت كلمة المرور

```
LoginScreen
    ↓
الضغط على "نسيت كلمة المرور"
    ↓
ForgotPasswordScreen
    ↓
إدخال البريد الإلكتروني
    ↓
ForgotPasswordController.sendEmail()
    ↓
ForgotPasswordOtpScreen
    ↓
إدخال OTP + كلمة المرور الجديدة
    ↓
ForgotPasswordController.resetPassword()
    ↓
LoginScreen
```

---

## 💡 أمثلة الاستخدام

### مثال 1: تسجيل دخول كامل

```dart
import 'package:get/get.dart';
import 'package:cabme/features/authentication/controller/login_conroller.dart';
import 'package:cabme/features/authentication/view/login_screen.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: LoginScreen(),
    );
  }
}

// في LoginScreen
class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final controller = Get.put(LoginController());

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      Map<String, String> params = {
        'email': controller.phoneController.value.text.trim(),
        'password': controller.passwordController.value.text,
        'user_cat': 'customer',
      };

      UserModel? user = await controller.loginAPI(params);
      
      if (user != null && user.success == "Success") {
        // حفظ بيانات المستخدم
        await Preferences.setInt(
          Preferences.userId, 
          int.parse(user.data!.id!)
        );
        await Preferences.setString(
          Preferences.user, 
          jsonEncode(user)
        );
        await Preferences.setString(
          Preferences.accesstoken, 
          user.data!.accesstoken!
        );
        await Preferences.setBoolean(
          Preferences.isLogin, 
          true
        );

        // تحديث API header
        API.header['accesstoken'] = user.data!.accesstoken!;

        // تحميل بيانات الشاشة الرئيسية
        final homeController = Get.put(HomeController());
        await homeController.setInitData();

        // الانتقال للشاشة الرئيسية
        Get.offAll(() => BottomNavBar());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthScreenLayout(
      title: 'welcome_back'.tr,
      subtitle: 'login_subtitle'.tr,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            CustomTextField(
              text: 'email_address'.tr,
              controller: controller.phoneController.value,
              validationType: ValidationType.email,
            ),
            SizedBox(height: 16),
            CustomTextField(
              text: 'enter_password'.tr,
              controller: controller.passwordController.value,
              validationType: ValidationType.password,
              obscureText: true,
            ),
            SizedBox(height: 24),
            CustomButton(
              text: 'login'.tr,
              onPressed: _handleLogin,
            ),
          ],
        ),
      ),
    );
  }
}
```

---

### مثال 2: تسجيل حساب جديد

```dart
class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final controller = Get.put(SignUpController());

  Future<void> _handleSignup() async {
    if (_formKey.currentState!.validate()) {
      Map<String, String> params = {
        'nom': controller.firstNameController.value.text.trim(),
        'prenom': controller.lastNameController.value.text.trim(),
        'email': controller.emailController.value.text.trim(),
        'phone': controller.phoneNumber.value.text.trim(),
        'password': controller.passwordController.value.text,
        'user_cat': 'customer',
        'login_type': controller.loginType.value,
      };

      UserModel? user = await controller.signUp(params);
      
      if (user != null && user.success == "Success") {
        // حفظ البيانات
        await Preferences.setInt(
          Preferences.userId, 
          int.parse(user.data!.id!)
        );
        await Preferences.setString(
          Preferences.user, 
          jsonEncode(user)
        );
        await Preferences.setString(
          Preferences.accesstoken, 
          user.data!.accesstoken!
        );
        await Preferences.setBoolean(
          Preferences.isLogin, 
          true
        );

        // الانتقال لشاشة النجاح
        Get.to(() => SignupSuccessScreen());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthScreenLayout(
      title: 'create_your_account'.tr,
      subtitle: 'signup_subtitle'.tr,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            CustomTextField(
              text: 'first_name'.tr,
              controller: controller.firstNameController.value,
              validators: (value) {
                if (value == null || value.isEmpty) {
                  return 'first_name_required'.tr;
                }
                if (value.length < 2) {
                  return 'name_must_be_at_least_2_characters'.tr;
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            CustomTextField(
              text: 'last_name'.tr,
              controller: controller.lastNameController.value,
              validators: (value) {
                if (value == null || value.isEmpty) {
                  return 'last_name_required'.tr;
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            CustomTextField(
              text: 'email_address'.tr,
              controller: controller.emailController.value,
              validationType: ValidationType.email,
            ),
            SizedBox(height: 16),
            CustomTextField(
              text: 'password'.tr,
              controller: controller.passwordController.value,
              validationType: ValidationType.password,
              obscureText: true,
            ),
            SizedBox(height: 16),
            CustomTextField(
              text: 'confirm_password'.tr,
              controller: controller.conformPasswordController.value,
              validators: (value) {
                if (value != controller.passwordController.value.text) {
                  return 'passwords_do_not_match'.tr;
                }
                return null;
              },
              obscureText: true,
            ),
            SizedBox(height: 24),
            CustomButton(
              text: 'sign_up'.tr,
              onPressed: _handleSignup,
            ),
          ],
        ),
      ),
    );
  }
}
```

---

### مثال 3: التحقق من OTP

```dart
class _OtpScreenState extends State<OtpScreen> {
  final controller = Get.put(OTPController());

  @override
  Widget build(BuildContext context) {
    return AuthScreenLayout(
      title: 'verify_your_otp'.tr,
      subtitle: 'otp_subtitle'.tr,
      child: Column(
        children: [
          // حقل OTP
          OtpInputWidget(
            controller: controller.otpController.value,
            length: 6,
            onCompleted: (otp) async {
              // التحقق من OTP تلقائياً عند الإدخال الكامل
              await controller.verifyOTP();
            },
          ),

          SizedBox(height: 24),

          // مؤقت العد التنازلي
          Obx(() => Text(
            controller.enableResend.value
              ? 'didnt_receive_code'.tr
              : '${'resend_code_in'.tr}${controller.secondsRemaining.value}s',
            style: TextStyle(
              color: AppThemeData.grey500,
              fontSize: 14,
            ),
          )),

          SizedBox(height: 8),

          // زر إعادة الإرسال
          Obx(() => TextButton(
            onPressed: controller.enableResend.value
              ? () => controller.resendOTP()
              : null,
            child: Text(
              'resend_otp'.tr,
              style: TextStyle(
                color: controller.enableResend.value
                  ? AppThemeData.primary200
                  : AppThemeData.grey400,
                fontSize: 16,
                fontFamily: AppThemeData.medium,
              ),
            ),
          )),

          SizedBox(height: 24),

          // زر التحقق
          CustomButton(
            text: 'verify_otp'.tr,
            onPressed: () async {
              if (controller.otpController.value.text.length == 6) {
                await controller.verifyOTP();
              } else {
                ShowToastDialog.showToast('please_enter_complete_otp'.tr);
              }
            },
          ),
        ],
      ),
    );
  }
}
```

---

### مثال 4: نسيت كلمة المرور

```dart
class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final controller = Get.put(ForgotPasswordController());
  final emailController = TextEditingController();

  Future<void> _handleSendOTP() async {
    if (_formKey.currentState!.validate()) {
      Map<String, String> params = {
        'email': emailController.text.trim(),
        'user_cat': 'customer',
      };

      bool? sent = await controller.sendEmail(params);
      
      if (sent == true) {
        Get.to(() => ForgotPasswordOtpScreen(), arguments: {
          'email': emailController.text.trim(),
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthScreenLayout(
      title: 'forgot_your_password'.tr,
      subtitle: 'forgot_password_subtitle'.tr,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            CustomTextField(
              text: 'email_address'.tr,
              controller: emailController,
              validationType: ValidationType.email,
            ),
            SizedBox(height: 24),
            CustomButton(
              text: 'send_reset_link'.tr,
              onPressed: _handleSendOTP,
            ),
          ],
        ),
      ),
    );
  }
}

// شاشة إعادة تعيين كلمة المرور
class _ForgotPasswordOtpScreenState extends State<ForgotPasswordOtpScreen> {
  final _formKey = GlobalKey<FormState>();
  final controller = Get.put(ForgotPasswordController());
  final otpController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  late String email;

  @override
  void initState() {
    super.initState();
    email = Get.arguments['email'];
  }

  Future<void> _handleResetPassword() async {
    if (_formKey.currentState!.validate()) {
      Map<String, String> params = {
        'email': email,
        'otp': otpController.text,
        'password': newPasswordController.text,
        'user_cat': 'customer',
      };

      bool? reset = await controller.resetPassword(params);
      
      if (reset == true) {
        ShowToastDialog.showToast('password_changed_successfully'.tr);
        Get.offAll(() => LoginScreen());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthScreenLayout(
      title: 'reset_your_password'.tr,
      subtitle: 'reset_password_subtitle'.tr,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Text(
              'check_email_for_otp'.tr,
              style: TextStyle(
                color: AppThemeData.grey500,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 16),
            OtpInputWidget(
              controller: otpController,
              length: 6,
            ),
            SizedBox(height: 16),
            CustomTextField(
              text: 'new_password'.tr,
              controller: newPasswordController,
              validationType: ValidationType.password,
              obscureText: true,
            ),
            SizedBox(height: 16),
            CustomTextField(
              text: 'confirm_password'.tr,
              controller: confirmPasswordController,
              validators: (value) {
                if (value != newPasswordController.text) {
                  return 'passwords_do_not_match'.tr;
                }
                return null;
              },
              obscureText: true,
            ),
            SizedBox(height: 24),
            CustomButton(
              text: 'reset_password'.tr,
              onPressed: _handleResetPassword,
            ),
          ],
        ),
      ),
    );
  }
}
```

---

### مثال 5: تسجيل الدخول بـ Google

```dart
class _LoginScreenState extends State<LoginScreen> {
  final controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return AuthScreenLayout(
      title: 'welcome_back'.tr,
      subtitle: 'login_subtitle'.tr,
      child: Column(
        children: [
          // حقول البريد وكلمة المرور
          // ...

          SizedBox(height: 24),

          // فاصل
          AuthDividerWidget(
            text: 'or_continue_with'.tr,
          ),

          SizedBox(height: 24),

          // أزرار تسجيل الدخول الاجتماعي
          Row(
            children: [
              // زر Google
              Expanded(
                child: SocialLoginButton(
                  text: 'google'.tr,
                  iconPath: 'assets/icons/ic_google.svg',
                  onPressed: () async {
                    await controller.loginWithGoogle();
                  },
                  backgroundColor: Colors.white,
                  textColor: Colors.black87,
                ),
              ),

              SizedBox(width: 16),

              // زر Apple (iOS فقط)
              if (Platform.isIOS)
                Expanded(
                  child: SocialLoginButton(
                    text: 'apple'.tr,
                    iconPath: 'assets/icons/ic_apple.svg',
                    onPressed: () async {
                      await controller.loginWithApple();
                    },
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
```

---

## 📚 أفضل الممارسات

### 1. التحقق من الحقول

❌ **خطأ:**
```dart
TextFormField(
  controller: emailController,
  validator: (value) {
    if (value!.isEmpty) return 'مطلوب';
    return null;
  },
)
```

✅ **صحيح:**
```dart
CustomTextField(
  text: 'email_address'.tr,
  controller: emailController,
  validationType: ValidationType.email,
)
```

---

### 2. حفظ بيانات المستخدم

❌ **خطأ:**
```dart
SharedPreferences prefs = await SharedPreferences.getInstance();
await prefs.setString('user', jsonEncode(user));
```

✅ **صحيح:**
```dart
await Preferences.setString(Preferences.user, jsonEncode(user));
await Preferences.setInt(Preferences.userId, int.parse(user.data!.id!));
await Preferences.setBoolean(Preferences.isLogin, true);
```

---

### 3. معالجة الأخطاء

❌ **خطأ:**
```dart
try {
  UserModel? user = await controller.loginAPI(params);
  Get.offAll(BottomNavBar());
} catch (e) {
  print(e);
}
```

✅ **صحيح:**
```dart
UserModel? user = await controller.loginAPI(params);

if (user != null && user.success == "Success") {
  // حفظ البيانات
  await Preferences.setString(Preferences.user, jsonEncode(user));
  await Preferences.setBoolean(Preferences.isLogin, true);
  
  // الانتقال
  Get.offAll(() => BottomNavBar());
} else if (user != null && user.error != null) {
  ShowToastDialog.showToast(user.error.toString());
}
```

---

### 4. استخدام GetX بشكل صحيح

❌ **خطأ:**
```dart
final controller = LoginController();
```

✅ **صحيح:**
```dart
final controller = Get.put(LoginController());
// أو
final controller = Get.find<LoginController>();
```

---

### 5. التنظيف عند الخروج

❌ **خطأ:**
```dart
// عدم تنظيف المتحكمات
```

✅ **صحيح:**
```dart
@override
void dispose() {
  controller.phoneController.value.dispose();
  controller.passwordController.value.dispose();
  super.dispose();
}
```

---

### 6. استخدام الترجمة

❌ **خطأ:**
```dart
Text('مرحباً بعودتك!')
```

✅ **صحيح:**
```dart
Text('welcome_back'.tr)
```

---

### 7. التحقق من نوع تسجيل الدخول

❌ **خطأ:**
```dart
if (loginType == "phoneNumber") {
  // عرض حقل الجوال
}
```

✅ **صحيح:**
```dart
Obx(() {
  if (controller.loginType.value == "phoneNumber") {
    return PhoneInputWidget(
      controller: controller.phoneNumber.value,
    );
  } else {
    return CustomTextField(
      text: 'email_address'.tr,
      controller: controller.emailController.value,
    );
  }
})
```

---

### 8. معالجة OTP

❌ **خطأ:**
```dart
TextField(
  maxLength: 6,
  onChanged: (value) {
    if (value.length == 6) {
      verifyOTP();
    }
  },
)
```

✅ **صحيح:**
```dart
OtpInputWidget(
  controller: otpController,
  length: 6,
  onCompleted: (otp) async {
    await controller.verifyOTP();
  },
)
```

---

### 9. تحديث API Header

❌ **خطأ:**
```dart
// عدم تحديث header بعد تسجيل الدخول
```

✅ **صحيح:**
```dart
// بعد تسجيل الدخول الناجح
Preferences.setString(Preferences.accesstoken, user.data!.accesstoken!);
API.header['accesstoken'] = user.data!.accesstoken!;
```

---

### 10. التحقق من حالة تسجيل الدخول

❌ **خطأ:**
```dart
void main() {
  runApp(MyApp());
}
```

✅ **صحيح:**
```dart
void main() async {
  await AppInitializer.initializeApp();
  
  // التحقق من حالة تسجيل الدخول
  bool isLoggedIn = Preferences.getBoolean(Preferences.isLogin);
  
  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  
  MyApp({required this.isLoggedIn});
  
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: isLoggedIn ? BottomNavBar() : LoginScreen(),
    );
  }
}
```

---

## 🔒 الأمان

### 1. تشفير كلمة المرور

```dart
// لا يتم تشفير كلمة المرور في الـ Frontend
// يتم إرسالها كما هي للـ Backend
// Backend يقوم بالتشفير باستخدام bcrypt أو مشابه
```

### 2. حماية Access Token

```dart
// تخزين Access Token في SharedPreferences
await Preferences.setString(Preferences.accesstoken, token);

// استخدامه في API Headers
API.header['accesstoken'] = Preferences.getString(Preferences.accesstoken);
```

### 3. التحقق من صلاحية Token

```dart
// في كل API call، Backend يتحقق من صلاحية Token
// إذا كان Token منتهي الصلاحية، يتم إرجاع خطأ 401
// Frontend يجب أن يتعامل مع هذا الخطأ ويعيد المستخدم لشاشة تسجيل الدخول
```

### 4. تسجيل الخروج الآمن

```dart
Future<void> logout() async {
  // مسح جميع البيانات المحفوظة
  await Preferences.clearSharPreference();
  
  // مسح API Header
  API.header.remove('accesstoken');
  
  // حذف جميع المتحكمات
  Get.deleteAll(force: true);
  
  // الانتقال لشاشة تسجيل الدخول
  Get.offAll(() => LoginScreen());
}
```

---

## 🐛 معالجة الأخطاء الشائعة

### 1. خطأ "Invalid phone number"

**السبب:** رقم الجوال غير صحيح أو لا يبدأ بـ 5, 6, 9, 2, أو 41

**الحل:**
```dart
validators: (value) {
  if (!RegExp(r'^[5692]|^41').hasMatch(value)) {
    return 'kuwait_numbers_start_with'.tr;
  }
  return null;
}
```

---

### 2. خطأ "Too many attempts"

**السبب:** محاولات كثيرة لإرسال OTP

**الحل:**
```dart
// الانتظار 5-10 دقائق قبل المحاولة مرة أخرى
// أو استخدام طريقة تسجيل دخول أخرى
```

---

### 3. خطأ "Invalid OTP"

**السبب:** OTP خاطئ أو منتهي الصلاحية

**الحل:**
```dart
// طلب إعادة إرسال OTP
await controller.resendOTP();
```

---

### 4. خطأ "Email already exists"

**السبب:** البريد الإلكتروني مسجل مسبقاً

**الحل:**
```dart
// استخدام بريد إلكتروني آخر
// أو تسجيل الدخول بدلاً من التسجيل
```

---

### 5. خطأ "Network error"

**السبب:** لا يوجد اتصال بالإنترنت

**الحل:**
```dart
try {
  // API call
} on SocketException {
  ShowToastDialog.showToast('no_internet_connection'.tr);
} on TimeoutException {
  ShowToastDialog.showToast('connection_timeout'.tr);
}
```

---

## 📝 ملاحظات مهمة

### 1. أنواع تسجيل الدخول المدعومة
- ✅ البريد الإلكتروني + كلمة المرور
- ✅ رقم الجوال + OTP
- ✅ Google Sign In
- ✅ Apple Sign In (iOS فقط)

### 2. متطلبات كلمة المرور
- الحد الأدنى: 6 أحرف
- يمكن أن تحتوي على أحرف وأرقام ورموز

### 3. تنسيق رقم الجوال
- رمز الدولة: +965 (ثابت)
- عدد الأرقام: 8
- يجب أن يبدأ بـ: 5, 6, 9, 2, أو 41

### 4. صلاحية OTP
- مدة الصلاحية: 5 دقائق
- عدد المحاولات: 3 محاولات
- يمكن إعادة الإرسال بعد: 60 ثانية

### 5. Firebase Authentication
- يستخدم لـ OTP فقط
- لا يتم حفظ المستخدمين في Firebase
- جميع البيانات في Backend الخاص

---

## 🎯 الخلاصة

مجلد **Authentication** يوفر نظام مصادقة شامل ومتكامل يشمل:

✅ **تسجيل الدخول المتعدد**: البريد، الجوال، Google، Apple  
✅ **التسجيل السهل**: خطوات بسيطة وواضحة  
✅ **التحقق الآمن**: OTP عبر Firebase  
✅ **إعادة تعيين كلمة المرور**: عملية سهلة وآمنة  
✅ **واجهات مخصصة**: تصميم موحد وجذاب  
✅ **معالجة الأخطاء**: رسائل واضحة ومفيدة  
✅ **دعم متعدد اللغات**: عربي، إنجليزي، أردو  

### الاستخدام الصحيح لهذا المجلد يضمن:
- 🔒 أمان عالي للمستخدمين
- 🎨 تجربة مستخدم سلسة
- 🌍 دعم طرق تسجيل دخول متعددة
- 📱 تصميم متجاوب على جميع الأجهزة
- 🔧 صيانة وتطوير أسهل

---

## 📞 للمساعدة

إذا كان لديك أي استفسار حول استخدام مجلد Authentication، يرجى:
1. مراجعة هذا الدليل أولاً
2. فحص الأمثلة الموجودة في الكود
3. التواصل مع فريق التطوير

---

**آخر تحديث:** فبراير 2026  
**الإصدار:** 1.0.0  
**المطور:** فريق مشوار
