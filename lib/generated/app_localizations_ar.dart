// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get error_no_internet_connection => 'لا يوجد اتصال بالإنترنت';

  @override
  String get error_no_internet_connection_desc =>
      'يرجى التحقق من اتصالك بالإنترنت والمحاولة مرة أخرى';

  @override
  String get error_connection_timeout => 'انتهت مهلة الاتصال';

  @override
  String get error_connection_timeout_desc =>
      'استغرق الاتصال وقتاً طويلاً. يرجى المحاولة مرة أخرى';

  @override
  String get error_receive_timeout => 'انتهت مهلة الاستقبال';

  @override
  String get error_receive_timeout_desc =>
      'استغرق الخادم وقتاً طويلاً للرد. يرجى المحاولة مرة أخرى';

  @override
  String get error_send_timeout => 'انتهت مهلة الإرسال';

  @override
  String get error_send_timeout_desc =>
      'فشل في إرسال البيانات إلى الخادم. يرجى المحاولة مرة أخرى';

  @override
  String get error_server_error => 'خطأ في الخادم';

  @override
  String get error_server_error_desc =>
      'حدث خطأ في الخادم. يرجى المحاولة لاحقاً';

  @override
  String get error_internal_server_error => 'خطأ داخلي في الخادم';

  @override
  String get error_internal_server_error_desc =>
      'واجه الخادم خطأ داخلي. يرجى المحاولة لاحقاً';

  @override
  String get error_bad_gateway => 'بوابة سيئة';

  @override
  String get error_bad_gateway_desc =>
      'تلقى الخادم استجابة غير صالحة. يرجى المحاولة لاحقاً';

  @override
  String get error_service_unavailable => 'الخدمة غير متاحة';

  @override
  String get error_service_unavailable_desc =>
      'الخدمة غير متاحة مؤقتاً. يرجى المحاولة لاحقاً';

  @override
  String get error_gateway_timeout => 'انتهت مهلة البوابة';

  @override
  String get error_gateway_timeout_desc =>
      'انتهت مهلة البوابة. يرجى المحاولة لاحقاً';

  @override
  String get error_bad_request => 'طلب خاطئ';

  @override
  String get properties_empty_message_favourite =>
      'You have not added any properties to your favorites.';

  @override
  String get error_bad_request_desc =>
      'يحتوي الطلب على بيانات غير صالحة. يرجى التحقق من المدخلات';

  @override
  String get error_unauthorized => 'غير مصرح للوصول';

  @override
  String get error_unauthorized_desc =>
      'أنت غير مصرح للوصول إلى هذا المورد. يرجى تسجيل الدخول مرة أخرى';

  @override
  String get error_forbidden => 'الوصول مرفوض';

  @override
  String get error_forbidden_desc => 'ليس لديك إذن للوصول إلى هذا المورد';

  @override
  String get error_not_found => 'غير موجود';

  @override
  String get error_not_found_desc => 'المورد المطلوب غير موجود';

  @override
  String get error_method_not_allowed => 'الطريقة غير مسموحة';

  @override
  String get error_method_not_allowed_desc =>
      'هذه الطريقة غير مسموحة لهذا المورد';

  @override
  String get error_not_acceptable => 'غير مقبول';

  @override
  String get error_not_acceptable_desc => 'الطلب غير مقبول';

  @override
  String get error_request_timeout => 'انتهت مهلة الطلب';

  @override
  String get error_request_timeout_desc =>
      'انتهت مهلة الطلب. يرجى المحاولة مرة أخرى';

  @override
  String get error_conflict => 'تعارض';

  @override
  String get error_conflict_desc => 'يوجد تعارض مع الحالة الحالية للمورد';

  @override
  String get error_gone => 'المورد غير متاح';

  @override
  String get error_gone_desc => 'المورد المطلوب لم يعد متاحاً';

  @override
  String get error_length_required => 'الطول مطلوب';

  @override
  String get error_length_required_desc => 'يجب أن يحدد الطلب طول المحتوى';

  @override
  String get error_precondition_failed => 'فشل الشرط المسبق';

  @override
  String get error_precondition_failed_desc => 'فشل شرط مسبق واحد أو أكثر';

  @override
  String get error_payload_too_large => 'الحمولة كبيرة جداً';

  @override
  String get error_payload_too_large_desc => 'حمولة الطلب كبيرة جداً';

  @override
  String get error_uri_too_long => 'الرابط طويل جداً';

  @override
  String get error_uri_too_long_desc => 'رابط الطلب طويل جداً';

  @override
  String get lead_send_error => 'حدث خطأ أثناء إرسال طلب التواصل';

  @override
  String get lead_info_collected => 'تم جمع معلومات العميل المحتمل بنجاح';

  @override
  String get lead_offline_mode => 'تم حفظ معلومات التواصل محلياً';

  @override
  String get error_unsupported_media_type => 'نوع الوسائط غير مدعوم';

  @override
  String get error_unsupported_media_type_desc => 'نوع الوسائط غير مدعوم';

  @override
  String get error_range_not_satisfiable => 'النطاق غير قابل للتحقيق';

  @override
  String get error_range_not_satisfiable_desc => 'لا يمكن تحقيق النطاق المطلوب';

  @override
  String get error_expectation_failed => 'فشل التوقع';

  @override
  String get error_expectation_failed_desc =>
      'لا يمكن تلبية التوقع المحدد في حقل رأس الطلب';

  @override
  String get error_too_many_requests => 'طلبات كثيرة جداً';

  @override
  String get error_too_many_requests_desc =>
      'لقد أرسلت طلبات كثيرة جداً. يرجى المحاولة لاحقاً';

  @override
  String get error_unknown => 'خطأ غير معروف';

  @override
  String get error_unknown_desc => 'حدث خطأ غير معروف. يرجى المحاولة مرة أخرى';

  @override
  String get error_cancelled => 'تم إلغاء الطلب';

  @override
  String get error_cancelled_desc => 'تم إلغاء الطلب';

  @override
  String get error_other => 'حدث خطأ';

  @override
  String get error_other_desc => 'حدث خطأ. يرجى المحاولة مرة أخرى';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get contact_support => 'تواصل مع الدعم';

  @override
  String get go_back => 'العودة';

  @override
  String get refresh => 'تحديث';

  @override
  String get check_connection => 'فحص الاتصال';

  @override
  String get appTitle => 'مشوار';

  @override
  String get goBack => 'رجوع';

  @override
  String get contactSupport => 'تواصل مع الدعم';

  @override
  String get checkConnection => 'فحص الاتصال';

  @override
  String get errorNoInternet => 'لا يوجد اتصال بالإنترنت';

  @override
  String get errorNoInternetDesc =>
      'يرجى التحقق من اتصالك بالإنترنت والمحاولة مرة أخرى.';

  @override
  String get errorTimeout => 'انتهت مهلة الطلب';

  @override
  String get errorTimeoutDesc =>
      'استغرق الطلب وقتًا طويلاً. يرجى المحاولة مرة أخرى.';

  @override
  String get errorServerError => 'خطأ في الخادم';

  @override
  String get errorServerErrorDesc => 'حدث خطأ من جانبنا. يرجى المحاولة لاحقًا.';

  @override
  String get errorBadRequest => 'طلب غير صالح';

  @override
  String get errorBadRequestDesc =>
      'لم يتم فهم الطلب. يرجى التحقق من المدخلات.';

  @override
  String get errorUnauthorized => 'غير مصرح';

  @override
  String get errorUnauthorizedDesc => 'يرجى تسجيل الدخول للمتابعة.';

  @override
  String get errorForbidden => 'تم رفض الوصول';

  @override
  String get errorForbiddenDesc => 'ليس لديك إذن للوصول إلى هذا المورد.';

  @override
  String get errorNotFound => 'غير موجود';

  @override
  String get errorNotFoundDesc => 'لم يتم العثور على المورد المطلوب.';

  @override
  String get errorMethodNotAllowed => 'الطريقة غير مسموح بها';

  @override
  String get errorMethodNotAllowedDesc => 'هذا الإجراء غير مسموح به.';

  @override
  String get errorNotAcceptable => 'غير مقبول';

  @override
  String get errorNotAcceptableDesc => 'تنسيق الطلب غير مقبول.';

  @override
  String get errorConflict => 'تعارض';

  @override
  String get errorConflictDesc => 'حدث تعارض مع الحالة الحالية.';

  @override
  String get errorGone => 'المورد غير متاح';

  @override
  String get errorGoneDesc => 'هذا المورد لم يعد متاحًا.';

  @override
  String get errorLengthRequired => 'الطول مطلوب';

  @override
  String get errorLengthRequiredDesc => 'طول الطلب مطلوب.';

  @override
  String get errorPreconditionFailed => 'فشل الشرط المسبق';

  @override
  String get errorPreconditionFailedDesc => 'لم يتم استيفاء شرط مطلوب.';

  @override
  String get errorPayloadTooLarge => 'الملف كبير جدًا';

  @override
  String get errorPayloadTooLargeDesc => 'الملف الذي تحاول تحميله كبير جدًا.';

  @override
  String get errorUriTooLong => 'عنوان URL طويل جدًا';

  @override
  String get errorUriTooLongDesc => 'عنوان URL للطلب طويل جدًا.';

  @override
  String get errorUnsupportedMediaType => 'نوع الملف غير مدعوم';

  @override
  String get errorUnsupportedMediaTypeDesc => 'نوع الملف هذا غير مدعوم.';

  @override
  String get errorRangeNotSatisfiable => 'النطاق غير قابل للتحقيق';

  @override
  String get errorRangeNotSatisfiableDesc => 'النطاق المطلوب غير متاح.';

  @override
  String get errorExpectationFailed => 'فشل التوقع';

  @override
  String get errorExpectationFailedDesc => 'لا يمكن للخادم تلبية المتطلبات.';

  @override
  String get errorTooManyRequests => 'طلبات كثيرة جدًا';

  @override
  String get errorTooManyRequestsDesc =>
      'لقد قمت بإجراء طلبات كثيرة جدًا. يرجى الانتظار والمحاولة مرة أخرى.';

  @override
  String get errorCancelled => 'تم إلغاء الطلب';

  @override
  String get errorCancelledDesc => 'تم إلغاء الطلب.';

  @override
  String get errorUnknown => 'حدث خطأ ما';

  @override
  String get errorUnknownDesc => 'حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى.';

  @override
  String get errorOther => 'حدث خطأ';

  @override
  String get errorOtherDesc => 'حدث خطأ. يرجى المحاولة مرة أخرى.';

  @override
  String get description => 'Other error description';

  @override
  String get yourJourneyOurPriority => 'رحلتك، أولويتنا';

  @override
  String get version => 'الإصدار';

  @override
  String get poweredByMshwar => 'مدعوم من مشوار';

  @override
  String get welcomeBack => 'مرحباً بعودتك!';

  @override
  String get loginSubtitle =>
      'سجل الدخول إلى حسابك في مشوار واستمر في رحلتك مع رحلات سلسة.';

  @override
  String get firstTimeInMshwar => 'أول مرة في مشوار؟';

  @override
  String get createAnAccount => 'إنشاء حساب';

  @override
  String get emailAddress => 'عنوان البريد الإلكتروني';

  @override
  String get enterPassword => 'أدخل كلمة المرور';

  @override
  String get forgotPassword => 'نسيت كلمة المرور';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get orContinueWith => 'أو تابع مع';

  @override
  String get mobileNumber => 'رقم الجوال';

  @override
  String get google => 'جوجل';

  @override
  String get apple => 'آبل';

  @override
  String get pleaseEnterEmailAddress => 'الرجاء إدخال عنوان البريد الإلكتروني';

  @override
  String get pleaseEnterPassword => 'الرجاء إدخال كلمة المرور';

  @override
  String get loading => 'جاري التحميل...';

  @override
  String get logInWithMobile => 'تسجيل الدخول بالجوال';

  @override
  String get signUpWithMobile => 'التسجيل بالجوال';

  @override
  String get mobileLoginSubtitle =>
      'أدخل رقم جوالك لتسجيل الدخول بأمان والحصول على الوصول إلى حسابك في مشوار.';

  @override
  String get mobileSignupSubtitle =>
      'سجل باستخدام رقم جوالك لعملية تسجيل سريعة وبسيطة في مشوار.';

  @override
  String get sendOtp => 'إرسال رمز التحقق';

  @override
  String get alreadyBookRides => 'هل حجزت رحلات من قبل؟';

  @override
  String get pleaseEnterMobileNumber => 'الرجاء إدخال رقم الجوال';

  @override
  String get phoneNumberIsRequired => 'رقم الهاتف مطلوب';

  @override
  String get kuwaitNumberMustBe8Digits => 'يجب أن يكون رقم الكويت 8 أرقام';

  @override
  String get invalidKuwaitPhoneNumber => 'رقم هاتف الكويت غير صحيح';

  @override
  String get codeSending => 'جاري إرسال الرمز';

  @override
  String get verifyYourOtp => 'تحقق من رمز التحقق';

  @override
  String get otpSubtitle =>
      'أدخل كلمة المرور لمرة واحدة المرسلة إلى رقم جوالك للتحقق من حسابك.';

  @override
  String get alreadyHaveAnAccount => 'هل لديك حساب بالفعل؟';

  @override
  String get logIn => 'تسجيل الدخول';

  @override
  String get didntReceiveCode => 'لم تستلم الرمز؟';

  @override
  String get resendCodeIn => 'إعادة إرسال الرمز خلال ';

  @override
  String get resendOtp => 'إعادة إرسال رمز التحقق';

  @override
  String get verifyOtp => 'تحقق من رمز التحقق';

  @override
  String get pleaseEnterCompleteOtp => 'الرجاء إدخال رمز التحقق الكامل';

  @override
  String get createYourAccount => 'إنشاء حسابك';

  @override
  String get signupSubtitle =>
      'سجل للحصول على تجربة مشوار مخصصة. ابدأ في حجز رحلاتك ببضع نقرات فقط.';

  @override
  String get firstName => 'الاسم الأول';

  @override
  String get lastName => 'اسم العائلة';

  @override
  String get password => 'كلمة المرور';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get signUp => 'التسجيل';

  @override
  String get firstNameRequired => 'الاسم الأول مطلوب';

  @override
  String get lastNameRequired => 'اسم العائلة مطلوب';

  @override
  String get emailRequired => 'البريد الإلكتروني مطلوب';

  @override
  String get pleaseEnterValidEmail => 'الرجاء إدخال بريد إلكتروني صحيح';

  @override
  String get passwordMustBeAtLeast6 =>
      'يجب أن تكون كلمة المرور 6 أحرف على الأقل';

  @override
  String get passwordsDoNotMatch => 'كلمات المرور غير متطابقة';

  @override
  String get enterValidEmailAddress => 'أدخل عنوان بريد إلكتروني صحيح';

  @override
  String minCharacters(Object count) {
    return 'الحد الأدنى $count أحرف';
  }

  @override
  String get reEnterYourPassword => 'أعد إدخال كلمة المرور';

  @override
  String get enter8DigitKuwaitMobileNumber =>
      'أدخل رقم جوال كويتي مكون من 8 أرقام';

  @override
  String get enterYourNameLettersOnly => 'أدخل اسمك (أحرف فقط)';

  @override
  String get thisFieldIsRequired => 'هذا الحقل مطلوب';

  @override
  String get emailMustContainAt => 'يجب أن يحتوي البريد الإلكتروني على @';

  @override
  String get emailMustContainDomain =>
      'يجب أن يحتوي البريد الإلكتروني على نطاق';

  @override
  String get invalidEmailFormat => 'تنسيق البريد الإلكتروني غير صحيح';

  @override
  String get validEmailAddress => 'عنوان بريد إلكتروني صحيح';

  @override
  String passwordMustBeAtLeastCharacters(Object count) {
    return 'يجب أن تكون كلمة المرور $count أحرف على الأقل';
  }

  @override
  String get validPassword => 'كلمة مرور صحيحة';

  @override
  String get passwordControllerNotProvided => 'لم يتم توفير متحكم كلمة المرور';

  @override
  String get passwordsMatch => 'كلمات المرور متطابقة';

  @override
  String get kuwaitNumbersStartWith => 'أرقام الكويت تبدأ بـ 5، 6، 9، 2، أو 41';

  @override
  String get validKuwaitPhoneNumber => 'رقم هاتف كويتي صحيح';

  @override
  String get nameMustBeAtLeast2Characters =>
      'يجب أن يكون الاسم حرفين على الأقل';

  @override
  String get nameCanOnlyContainLetters => 'يمكن أن يحتوي الاسم على أحرف فقط';

  @override
  String get validName => 'اسم صحيح';

  @override
  String get forgotYourPassword => 'نسيت كلمة المرور؟';

  @override
  String get forgotPasswordSubtitle =>
      'لا تقلق! أدخل بريدك الإلكتروني أو رقم جوالك، وسنساعدك في إعادة تعيين كلمة المرور.';

  @override
  String get sendResetLink => 'إرسال رابط إعادة التعيين';

  @override
  String get pleaseEnterYourEmailAddress =>
      'الرجاء إدخال عنوان بريدك الإلكتروني';

  @override
  String get resetYourPassword => 'إعادة تعيين كلمة المرور';

  @override
  String get resetPasswordSubtitle =>
      'أدخل رمز التحقق المرسل إلى بريدك الإلكتروني وقم بتعيين كلمة مرور جديدة.';

  @override
  String get checkEmailForOtp =>
      'تحقق من بريدك الإلكتروني للحصول على رمز التحقق';

  @override
  String get newPassword => 'كلمة المرور الجديدة';

  @override
  String get resetPassword => 'إعادة تعيين كلمة المرور';

  @override
  String get passwordMustBeAtLeast6Characters =>
      'يجب أن تكون كلمة المرور 6 أحرف على الأقل';

  @override
  String get passwordsDoNotMatchValidation => 'كلمات المرور غير متطابقة';

  @override
  String get passwordChangedSuccessfully => 'تم تغيير كلمة المرور بنجاح!';

  @override
  String get pleaseTryAgainLater => 'الرجاء المحاولة مرة أخرى لاحقاً';

  @override
  String get accountCreatedSuccessfully => 'تم إنشاء الحساب\nبنجاح!';

  @override
  String get signupSuccessSubtitle =>
      'مرحباً بك في مشوار! تم إنشاء حسابك بنجاح. ابدأ في حجز رحلاتك الآن.';

  @override
  String get startExploring => 'ابدأ الاستكشاف';

  @override
  String get skipForNow => 'تخطي الآن';

  @override
  String get pleaseWait => 'الرجاء الانتظار';

  @override
  String get pleaseWaitDots => 'الرجاء الانتظار...';

  @override
  String get somethingWentWrong => 'حدث خطأ ما. يرجى المحاولة مرة أخرى لاحقاً';

  @override
  String get myProfile => 'ملفي الشخصي';

  @override
  String get saveDetails => 'حفظ التفاصيل';

  @override
  String get name => 'Name';

  @override
  String get enterMobileNumber => 'Enter mobile number';

  @override
  String get email => 'Email';

  @override
  String get emailNotValid => 'Email not valid';

  @override
  String get required => 'Required';

  @override
  String get tapToChangePhoto => 'اضغط لتغيير الصورة';

  @override
  String get deleteAccount => 'حذف الحساب';

  @override
  String get areYouSureDeleteAccount => 'هل أنت متأكد من حذف الحساب؟';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'لا';

  @override
  String get changeInformation => 'تغيير المعلومات';

  @override
  String get chooseSource => 'اختر المصدر';

  @override
  String get camera => 'Camera';

  @override
  String get gallery => 'Gallery';

  @override
  String get failedToPick => 'فشل الاختيار: ';

  @override
  String get rideManagement => 'إدارة الرحلات';

  @override
  String get allRides => 'جميع الرحلات';

  @override
  String get scheduledRides => 'الرحلات المجدولة';

  @override
  String get accountPayments => 'الحساب والمدفوعات';

  @override
  String get changePassword => 'تغيير كلمة المرور';

  @override
  String get appSettings => 'إعدادات التطبيق';

  @override
  String get notifications => 'Notifications';

  @override
  String get termsConditions => 'الشروط والأحكام';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get feedbackSupport => 'الملاحظات والدعم';

  @override
  String get contactUs => 'اتصل بنا';

  @override
  String get rateTheApp => 'قيم التطبيق';

  @override
  String get darkMode => 'الوضع الداكن';

  @override
  String get areYouSureLogout => 'هل أنت متأكد أنك تريد تسجيل الخروج؟';

  @override
  String get serverError => 'خطأ في الخادم. يرجى المحاولة مرة أخرى.';

  @override
  String get connectionTimeout =>
      'انتهت مهلة الاتصال. يرجى التحقق من اتصالك بالإنترنت.';

  @override
  String get noInternetConnection =>
      'لا يوجد اتصال بالإنترنت. يرجى التحقق من شبكتك.';

  @override
  String get invalidServerResponse =>
      'استجابة غير صالحة من الخادم. يرجى المحاولة مرة أخرى.';

  @override
  String get anErrorOccurred => 'حدث خطأ. يرجى المحاولة مرة أخرى.';

  @override
  String get unexpectedError => 'حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى.';

  @override
  String get requestTimedOut => 'انتهت مهلة الطلب. يرجى المحاولة مرة أخرى.';

  @override
  String get otpSentToEmail => 'تم إرسال رمز التحقق إلى بريدك الإلكتروني!';

  @override
  String get otpSent => 'تم إرسال رمز التحقق';

  @override
  String get otpSentSuccessfully => 'تم إرسال رمز التحقق بنجاح';

  @override
  String get otpVerifiedSuccessfully => 'تم التحقق من رمز التحقق بنجاح';

  @override
  String get failedToResendOtp =>
      'فشل إعادة إرسال رمز التحقق. يرجى المحاولة مرة أخرى.';

  @override
  String get invalidOtp => 'رمز التحقق غير صحيح. يرجى المحاولة مرة أخرى.';

  @override
  String get invalidOtpOrRequestFailed => 'رمز التحقق غير صحيح أو فشل الطلب';

  @override
  String get emailNotFound => 'البريد الإلكتروني غير موجود أو الطلب غير صحيح';

  @override
  String get failedToVerifyUser => 'فشل التحقق من المستخدم';

  @override
  String get unableToVerifyUser =>
      'تعذر التحقق من المستخدم. يرجى المحاولة مرة أخرى.';

  @override
  String get failedToGetProfile => 'فشل الحصول على ملف المستخدم';

  @override
  String get unableToFetchProfile =>
      'تعذر جلب ملف المستخدم. يرجى المحاولة مرة أخرى.';

  @override
  String get invalidPhoneNumber => 'رقم الهاتف غير صحيح';

  @override
  String get tooManyAttempts =>
      'لقد حاولت عدة مرات. يرجى إرسال رمز التحقق بعد قليل';

  @override
  String get signInCancelled => 'تم إلغاء تسجيل الدخول';

  @override
  String get changeLanguage => 'تغيير اللغة';

  @override
  String get selectLanguage => 'اختر اللغة';

  @override
  String get chooseLanguageDesc => 'اختر لغتك المفضلة للمتابعة';

  @override
  String get skip => 'تخطي';

  @override
  String get skipDesc => 'يمكنك تغيير لغتك في أي وقت من الإعدادات';

  @override
  String get save => 'حفظ';

  @override
  String get continuee => 'متابعة';

  @override
  String get languageChangeSuccessfully => 'تم تغيير اللغة بنجاح';

  @override
  String get pressBackAgainToExit => 'اضغط زر الرجوع مرة أخرى للخروج';

  @override
  String get logOut => 'تسجيل الخروج';

  @override
  String get cancel => 'إلغاء';

  @override
  String get home => 'الرئيسية';

  @override
  String get ridesTitle => 'الرحلات';

  @override
  String get subscriptions => 'الاشتراكات';

  @override
  String get packages => 'الباقات';

  @override
  String get wallet => 'المحفظة';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get enterDestination => 'أدخل الوجهة';

  @override
  String get departure => 'نقطة الانطلاق';

  @override
  String get pickUpLocation => 'موقع الاستلام';

  @override
  String get destination => 'الوجهة';

  @override
  String get whereYouWantToGo => 'إلى أين تريد الذهاب؟';

  @override
  String get whereDoYouWantToStop => 'أين تريد التوقف؟';

  @override
  String get searchDestination => 'ابحث عن الوجهة';

  @override
  String get pleaseEnterPickupAddress => 'الرجاء إدخال عنوان الاستلام';

  @override
  String get pleaseEnterDestinationAddress => 'الرجاء إدخال عنوان الوجهة';

  @override
  String get pleaseSelectVehicleType => 'الرجاء اختيار نوع المركبة';

  @override
  String get classicRidesOnly =>
      'قريباً! 🚗\nنحن نقدم حالياً رحلات الكلاسيك فقط. أنواع المركبات الأخرى ستكون متاحة قريباً!';

  @override
  String get unableToGetAddress => 'تعذر الحصول على معلومات العنوان.';

  @override
  String get errorProcessingDestination => 'خطأ في معالجة الوجهة';

  @override
  String get paymentError => 'خطأ في الدفع';

  @override
  String get stop => 'توقف';

  @override
  String get selectPaymentMethod => 'اختر طريقة الدفع';

  @override
  String get totalAmount => 'المبلغ الإجمالي';

  @override
  String get discount => 'خصم';

  @override
  String get confirmPay => 'تأكيد والدفع';

  @override
  String get cash => 'نقد';

  @override
  String get knetCreditCardOthers => 'كي نت، بطاقة ائتمانية وأخرى';

  @override
  String get bookingConfirmed => 'تم تأكيد الحجز';

  @override
  String get bookingConfirmedExclamation => 'تم تأكيد الحجز!';

  @override
  String get rideSuccessfullyBookedMessage =>
      'تم حجز رحلتك بنجاح. اجلس واسترخِ، سائقك في الطريق إليك.';

  @override
  String get trackRide => 'تتبع الرحلة';

  @override
  String get backToHome => 'العودة إلى الرئيسية';

  @override
  String get walletBalance => 'رصيد المحفظة';

  @override
  String get transactionHistory => 'سجل المعاملات';

  @override
  String get transactions => 'المعاملات';

  @override
  String get transactionNotFound => 'لم يتم العثور على معاملة.';

  @override
  String get topUpAmount => 'مبلغ الشحن';

  @override
  String get addAmount => 'إضافة مبلغ';

  @override
  String get noNotifications => 'لا توجد إشعارات';

  @override
  String get youHaveNoNotificationsYet => 'لا توجد لديك إشعارات بعد';

  @override
  String get accept => 'قبول';

  @override
  String get decline => 'رفض';

  @override
  String get permissionDenied => 'تم رفض الإذن';

  @override
  String get done => 'تم';

  @override
  String get verificationCode => 'Verification code';

  @override
  String get confirmNewPassword => 'Confirm new password';

  @override
  String get pleaseEnterVerificationCode => 'Please enter verification code';

  @override
  String get passwordResetSuccessfully => 'Password reset successfully';

  @override
  String get resetCodeSentSuccessfully => 'Reset code sent successfully';

  @override
  String get loginSuccessful => 'Login successful';

  @override
  String get rememberYourPassword => 'Remember your password?';

  @override
  String get bookRide => 'حجز رحلة';

  @override
  String get whereToGo => 'إلى أين تريد الذهاب؟';

  @override
  String get pickupLocation => 'موقع الاستلام';

  @override
  String get dropoffLocation => 'موقع التوصيل';

  @override
  String get confirmLocation => 'تأكيد الموقع';

  @override
  String get searchLocation => 'البحث عن موقع';

  @override
  String get useCurrentLocation => 'استخدام الموقع الحالي';

  @override
  String get noResultsFound => 'لم يتم العثور على نتائج';

  @override
  String get selectVehicle => 'اختر المركبة';

  @override
  String get vehicle => 'مركبة';

  @override
  String get passengers => 'ركاب';

  @override
  String get change => 'تغيير';

  @override
  String get numberOfPassengers => 'عدد الركاب';

  @override
  String get scheduleRide => 'جدولة الرحلة';

  @override
  String get scheduledFor => 'مجدولة لـ';

  @override
  String get continueToPayment => 'المتابعة للدفع';

  @override
  String get pleaseSelectVehicle => 'يرجى اختيار مركبة';

  @override
  String get paymentMethod => 'طريقة الدفع';

  @override
  String get totalFare => 'إجمالي الأجرة';

  @override
  String get confirmBooking => 'تأكيد الحجز';

  @override
  String get pleaseSelectPaymentMethod => 'يرجى اختيار طريقة الدفع';

  @override
  String get yourRideHasBeenBooked => 'تم حجز رحلتك بنجاح';

  @override
  String get bookingId => 'رقم الحجز';

  @override
  String get estimatedArrival => 'الوصول المتوقع';

  @override
  String get otp => 'رمز التحقق';

  @override
  String get driverDetails => 'تفاصيل السائق';

  @override
  String get rides => 'رحلات';

  @override
  String get priceSummary => 'ملخص السعر';

  @override
  String get basePrice => 'السعر الأساسي';

  @override
  String get distancePrice => 'سعر المسافة';

  @override
  String get timePrice => 'سعر الوقت';

  @override
  String get packageDiscount => 'خصم الباقة';

  @override
  String get total => 'الإجمالي';

  @override
  String get pickup => 'الاستلام';

  @override
  String get dropoff => 'التوصيل';

  @override
  String get stops => 'التوقفات';

  @override
  String get addStop => 'إضافة توقف';

  @override
  String get removeStop => 'إزالة توقف';

  @override
  String get noStopsAdded => 'لم تتم إضافة توقفات بعد';

  @override
  String get enterLocation => 'أدخل الموقع';

  @override
  String get usePackageKm => 'استخدام باقة الكيلومترات';

  @override
  String get packageKmAvailable => 'الكيلومترات المتاحة في الباقة';

  @override
  String get packageKmToUse => 'الكيلومترات المستخدمة';

  @override
  String get packageKmRemaining => 'الكيلومترات المتبقية';

  @override
  String get packageKmDiscountInfo =>
      'سيتم استخدام كيلومترات الباقة لهذه الرحلة';

  @override
  String get haveCouponCode => 'لديك كود خصم؟';

  @override
  String get enterCouponCode => 'أدخل كود الخصم';

  @override
  String get applyCoupon => 'تطبيق الكود';

  @override
  String get removeCoupon => 'إزالة الكود';

  @override
  String get couponApplied => 'تم تطبيق الكود';

  @override
  String get couponDiscount => 'خصم الكود';

  @override
  String get invalidCoupon => 'كود خصم غير صالح';

  @override
  String get couponCodeRemoved => 'تم إزالة كود الخصم';

  @override
  String get insufficientBalance => 'رصيد المحفظة غير كافٍ';

  @override
  String get addFunds => 'إضافة رصيد للمحفظة';

  @override
  String get pendingPayment => 'دفع معلق';

  @override
  String get pendingPaymentMessage =>
      'لديك دفع معلق. يرجى إكماله لمتابعة حجز الرحلات.';

  @override
  String get amountDue => 'المبلغ المستحق';

  @override
  String get payNow => 'ادفع الآن';

  @override
  String get later => 'لاحقاً';

  @override
  String get buyPackages => 'شراء الباقات';

  @override
  String get myPackages => 'باقاتي';

  @override
  String get noPackagesAvailable => 'لا توجد باقات متاحة';

  @override
  String get noPackagesAvailableDesc =>
      'لا توجد باقات كيلومترات متاحة للشراء في الوقت الحالي.';

  @override
  String get noPackagesPurchased => 'لم تشتري أي باقات';

  @override
  String get noPackagesPurchasedDesc =>
      'لم تشتري أي باقات كيلومترات بعد. اشتري واحدة لتوفير المال على رحلاتك!';

  @override
  String get buyMorePackages => 'شراء المزيد من الباقات';

  @override
  String get buyMorePackagesDesc => 'يمكنك شراء نفس الباقة عدة مرات!';

  @override
  String get availableKm => 'المتاح';

  @override
  String get usedKm => 'كم مستخدم';

  @override
  String get totalKm => 'الإجمالي';

  @override
  String get remaining => 'متبقي';

  @override
  String get used => 'مستخدم';

  @override
  String get purchased => 'تم الشراء';

  @override
  String get purchasePackage => 'شراء الباقة';

  @override
  String get totalKilometers => 'إجمالي الكيلومترات';

  @override
  String get pricePerKm => 'السعر لكل كم';

  @override
  String get proceedToPayment => 'المتابعة للدفع';

  @override
  String get invalidPackagePrice => 'سعر الباقة غير صحيح';

  @override
  String get packagePrice => 'سعر الباقة';

  @override
  String get packagePurchaseInitiated => 'تم بدء شراء الباقة';

  @override
  String get packagePurchasedSuccessfully => 'تم شراء الباقة بنجاح!';

  @override
  String get noSubscriptionsYet => 'لا توجد اشتراكات بعد';

  @override
  String get noSubscriptionsYetDesc => 'أنشئ أول اشتراك رحلة للتنقلات المنتظمة';

  @override
  String get subscriptionsNotAvailable => 'الاشتراكات غير متاحة';

  @override
  String get subscriptionsNotAvailableDesc =>
      'خدمة الاشتراكات غير متاحة في الوقت الحالي. يرجى المحاولة لاحقاً.';

  @override
  String get distance => 'المسافة';

  @override
  String get trips => 'الرحلات';

  @override
  String get price => 'السعر';

  @override
  String get buyNow => 'اشتري الآن';

  @override
  String get totalPrice => 'السعر الإجمالي';

  @override
  String get walletPaymentNotImplemented => 'الدفع بالمحفظة غير متاح حالياً';

  @override
  String get knetPaymentNotImplemented => 'الدفع بالكي نت غير متاح حالياً';
}
