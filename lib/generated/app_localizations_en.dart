// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get error_no_internet_connection => 'No internet connection';

  @override
  String get error_no_internet_connection_desc =>
      'Please check your internet connection and try again';

  @override
  String get error_connection_timeout => 'Connection timeout';

  @override
  String get error_connection_timeout_desc =>
      'The connection took too long to establish. Please try again';

  @override
  String get error_receive_timeout => 'Receive timeout';

  @override
  String get error_receive_timeout_desc =>
      'The server took too long to respond. Please try again';

  @override
  String get error_send_timeout => 'Send timeout';

  @override
  String get error_send_timeout_desc =>
      'Failed to send data to the server. Please try again';

  @override
  String get error_server_error => 'Server error';

  @override
  String get error_server_error_desc =>
      'Something went wrong on the server. Please try again later';

  @override
  String get error_internal_server_error => 'Internal server error';

  @override
  String get error_internal_server_error_desc =>
      'The server encountered an internal error. Please try again later';

  @override
  String get error_bad_gateway => 'Bad gateway';

  @override
  String get error_bad_gateway_desc =>
      'The server received an invalid response. Please try again later';

  @override
  String get error_service_unavailable => 'Service unavailable';

  @override
  String get error_service_unavailable_desc =>
      'The service is temporarily unavailable. Please try again later';

  @override
  String get error_gateway_timeout => 'Gateway timeout';

  @override
  String get error_gateway_timeout_desc =>
      'The gateway timed out. Please try again later';

  @override
  String get error_bad_request => 'Bad request';

  @override
  String get properties_empty_message_favourite =>
      'You have not added any properties to your favorites.';

  @override
  String get error_bad_request_desc =>
      'The request contains invalid data. Please check your input';

  @override
  String get error_unauthorized => 'Unauthorized';

  @override
  String get error_unauthorized_desc =>
      'You are not authorized to access this resource. Please login again';

  @override
  String get error_forbidden => 'Access denied';

  @override
  String get error_forbidden_desc =>
      'You don\'t have permission to access this resource';

  @override
  String get error_not_found => 'Not found';

  @override
  String get error_not_found_desc => 'The requested resource was not found';

  @override
  String get error_method_not_allowed => 'Method not allowed';

  @override
  String get error_method_not_allowed_desc =>
      'This method is not allowed for this resource';

  @override
  String get error_not_acceptable => 'Not acceptable';

  @override
  String get error_not_acceptable_desc => 'The request is not acceptable';

  @override
  String get error_request_timeout => 'Request timeout';

  @override
  String get error_request_timeout_desc =>
      'The request timed out. Please try again';

  @override
  String get error_conflict => 'Conflict';

  @override
  String get error_conflict_desc =>
      'There is a conflict with the current state of the resource';

  @override
  String get error_gone => 'Resource gone';

  @override
  String get error_gone_desc => 'The requested resource is no longer available';

  @override
  String get error_length_required => 'Length required';

  @override
  String get error_length_required_desc =>
      'The request must specify the content length';

  @override
  String get error_precondition_failed => 'Precondition failed';

  @override
  String get error_precondition_failed_desc =>
      'One or more preconditions failed';

  @override
  String get error_payload_too_large => 'Payload too large';

  @override
  String get error_payload_too_large_desc => 'The request payload is too large';

  @override
  String get error_uri_too_long => 'URI too long';

  @override
  String get error_uri_too_long_desc => 'The request URI is too long';

  @override
  String get lead_send_error =>
      'An error occurred while sending the contact request';

  @override
  String get lead_info_collected => 'Lead information collected successfully';

  @override
  String get lead_offline_mode => 'Contact information saved offline';

  @override
  String get error_unsupported_media_type => 'Unsupported media type';

  @override
  String get error_unsupported_media_type_desc =>
      'The media type is not supported';

  @override
  String get error_range_not_satisfiable => 'Range not satisfiable';

  @override
  String get error_range_not_satisfiable_desc =>
      'The requested range cannot be satisfied';

  @override
  String get error_expectation_failed => 'Expectation failed';

  @override
  String get error_expectation_failed_desc =>
      'The expectation given in the request header field could not be met';

  @override
  String get error_too_many_requests => 'Too many requests';

  @override
  String get error_too_many_requests_desc =>
      'You have sent too many requests. Please try again later';

  @override
  String get error_unknown => 'Unknown error';

  @override
  String get error_unknown_desc =>
      'An unknown error occurred. Please try again';

  @override
  String get error_cancelled => 'Request cancelled';

  @override
  String get error_cancelled_desc => 'The request was cancelled';

  @override
  String get error_other => 'Error occurred';

  @override
  String get error_other_desc => 'An error occurred. Please try again';

  @override
  String get retry => 'Retry';

  @override
  String get contact_support => 'Contact Support';

  @override
  String get go_back => 'Go Back';

  @override
  String get refresh => 'Refresh';

  @override
  String get check_connection => 'Check Connection';

  @override
  String get appTitle => 'Mshwar';

  @override
  String get goBack => 'Go Back';

  @override
  String get contactSupport => 'Contact Support';

  @override
  String get checkConnection => 'Check Connection';

  @override
  String get errorNoInternet => 'No Internet Connection';

  @override
  String get errorNoInternetDesc =>
      'Please check your internet connection and try again.';

  @override
  String get errorTimeout => 'Request Timeout';

  @override
  String get errorTimeoutDesc =>
      'The request took too long to complete. Please try again.';

  @override
  String get errorServerError => 'Server Error';

  @override
  String get errorServerErrorDesc =>
      'Something went wrong on our end. Please try again later.';

  @override
  String get errorBadRequest => 'Invalid Request';

  @override
  String get errorBadRequestDesc =>
      'The request could not be understood. Please check your input.';

  @override
  String get errorUnauthorized => 'Unauthorized';

  @override
  String get errorUnauthorizedDesc => 'Please log in to continue.';

  @override
  String get errorForbidden => 'Access Denied';

  @override
  String get errorForbiddenDesc =>
      'You don\'t have permission to access this resource.';

  @override
  String get errorNotFound => 'Not Found';

  @override
  String get errorNotFoundDesc => 'The requested resource could not be found.';

  @override
  String get errorMethodNotAllowed => 'Method Not Allowed';

  @override
  String get errorMethodNotAllowedDesc => 'This action is not allowed.';

  @override
  String get errorNotAcceptable => 'Not Acceptable';

  @override
  String get errorNotAcceptableDesc => 'The request format is not acceptable.';

  @override
  String get errorConflict => 'Conflict';

  @override
  String get errorConflictDesc =>
      'There was a conflict with the current state.';

  @override
  String get errorGone => 'Resource Gone';

  @override
  String get errorGoneDesc => 'This resource is no longer available.';

  @override
  String get errorLengthRequired => 'Length Required';

  @override
  String get errorLengthRequiredDesc => 'The request length is required.';

  @override
  String get errorPreconditionFailed => 'Precondition Failed';

  @override
  String get errorPreconditionFailedDesc => 'A required condition was not met.';

  @override
  String get errorPayloadTooLarge => 'File Too Large';

  @override
  String get errorPayloadTooLargeDesc =>
      'The file you\'re trying to upload is too large.';

  @override
  String get errorUriTooLong => 'URI Too Long';

  @override
  String get errorUriTooLongDesc => 'The request URL is too long.';

  @override
  String get errorUnsupportedMediaType => 'Unsupported File Type';

  @override
  String get errorUnsupportedMediaTypeDesc =>
      'This file type is not supported.';

  @override
  String get errorRangeNotSatisfiable => 'Range Not Satisfiable';

  @override
  String get errorRangeNotSatisfiableDesc =>
      'The requested range is not available.';

  @override
  String get errorExpectationFailed => 'Expectation Failed';

  @override
  String get errorExpectationFailedDesc =>
      'The server cannot meet the requirements.';

  @override
  String get errorTooManyRequests => 'Too Many Requests';

  @override
  String get errorTooManyRequestsDesc =>
      'You\'ve made too many requests. Please wait and try again.';

  @override
  String get errorCancelled => 'Request Cancelled';

  @override
  String get errorCancelledDesc => 'The request was cancelled.';

  @override
  String get errorUnknown => 'Something Went Wrong';

  @override
  String get errorUnknownDesc =>
      'An unexpected error occurred. Please try again.';

  @override
  String get errorOther => 'Error Occurred';

  @override
  String get errorOtherDesc => 'An error occurred. Please try again.';

  @override
  String get description => 'Other error description';

  @override
  String get yourJourneyOurPriority => 'Your journey, our priority';

  @override
  String get version => 'Version';

  @override
  String get poweredByMshwar => 'Powered by Mshwar';

  @override
  String get welcomeBack => 'Welcome back!';

  @override
  String get loginSubtitle =>
      'Log in to your Mshwar account and continue your journey with seamless rides.';

  @override
  String get firstTimeInMshwar => 'First time in Mshwar?';

  @override
  String get createAnAccount => 'Create an account';

  @override
  String get emailAddress => 'Email address';

  @override
  String get enterPassword => 'Enter password';

  @override
  String get forgotPassword => 'Forgot password';

  @override
  String get login => 'Login';

  @override
  String get orContinueWith => 'Or continue with';

  @override
  String get mobileNumber => 'Mobile number';

  @override
  String get google => 'Google';

  @override
  String get apple => 'Apple';

  @override
  String get pleaseEnterEmailAddress => 'Please enter email address';

  @override
  String get pleaseEnterPassword => 'Please enter password';

  @override
  String get loading => 'Loading...';

  @override
  String get logInWithMobile => 'Log in with mobile';

  @override
  String get signUpWithMobile => 'Sign up with mobile';

  @override
  String get mobileLoginSubtitle =>
      'Enter your mobile number to securely log in and access your Mshwar account.';

  @override
  String get mobileSignupSubtitle =>
      'Sign up using your mobile number for a fast and simple registration in Mshwar.';

  @override
  String get sendOtp => 'Send OTP';

  @override
  String get alreadyBookRides => 'Already book rides?';

  @override
  String get pleaseEnterMobileNumber => 'Please enter mobile number';

  @override
  String get phoneNumberIsRequired => 'Phone number is required';

  @override
  String get kuwaitNumberMustBe8Digits => 'Kuwait number must be 8 digits';

  @override
  String get invalidKuwaitPhoneNumber => 'Invalid Kuwait phone number';

  @override
  String get codeSending => 'Sending code';

  @override
  String get verifyYourOtp => 'Verify your OTP';

  @override
  String get otpSubtitle =>
      'Enter the one-time password sent to your mobile number to verify your account.';

  @override
  String get alreadyHaveAnAccount => 'Already have an account?';

  @override
  String get logIn => 'Log in';

  @override
  String get didntReceiveCode => 'Didn’t receive the code?';

  @override
  String get resendCodeIn => 'Resend code in ';

  @override
  String get resendOtp => 'Resend OTP';

  @override
  String get verifyOtp => 'Verify OTP';

  @override
  String get pleaseEnterCompleteOtp => 'Please enter complete OTP';

  @override
  String get createYourAccount => 'Create your account';

  @override
  String get signupSubtitle =>
      'Sign up for a personalized Mshwar experience. Start booking rides in just a few taps.';

  @override
  String get firstName => 'First name';

  @override
  String get lastName => 'Last name';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get signUp => 'Sign up';

  @override
  String get firstNameRequired => 'First name is required';

  @override
  String get lastNameRequired => 'Last name is required';

  @override
  String get emailRequired => 'Email is required';

  @override
  String get pleaseEnterValidEmail => 'Please enter a valid email';

  @override
  String get passwordMustBeAtLeast6 => 'Password must be at least 6 characters';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get enterValidEmailAddress => 'Enter a valid email address';

  @override
  String minCharacters(Object count) {
    return 'Minimum $count characters';
  }

  @override
  String get reEnterYourPassword => 'Re-enter your password';

  @override
  String get enter8DigitKuwaitMobileNumber =>
      'Enter an 8-digit Kuwait mobile number';

  @override
  String get enterYourNameLettersOnly => 'Enter your name (letters only)';

  @override
  String get thisFieldIsRequired => 'This field is required';

  @override
  String get emailMustContainAt => 'Email must contain @';

  @override
  String get emailMustContainDomain => 'Email must contain a domain';

  @override
  String get invalidEmailFormat => 'Invalid email format';

  @override
  String get validEmailAddress => 'Valid email address';

  @override
  String passwordMustBeAtLeastCharacters(Object count) {
    return 'Password must be at least $count characters';
  }

  @override
  String get validPassword => 'Valid password';

  @override
  String get passwordControllerNotProvided =>
      'Password controller not provided';

  @override
  String get passwordsMatch => 'Passwords match';

  @override
  String get kuwaitNumbersStartWith =>
      'Kuwait numbers start with 5, 6, 9, 2, or 41';

  @override
  String get validKuwaitPhoneNumber => 'Valid Kuwait phone number';

  @override
  String get nameMustBeAtLeast2Characters =>
      'Name must be at least 2 characters';

  @override
  String get nameCanOnlyContainLetters => 'Name can only contain letters';

  @override
  String get validName => 'Valid name';

  @override
  String get forgotYourPassword => 'Forgot your password?';

  @override
  String get forgotPasswordSubtitle =>
      'Don’t worry! Enter your email or mobile number and we’ll help you reset your password.';

  @override
  String get sendResetLink => 'Send reset link';

  @override
  String get pleaseEnterYourEmailAddress => 'Please enter your email address';

  @override
  String get resetYourPassword => 'Reset your password';

  @override
  String get resetPasswordSubtitle =>
      'Enter the OTP sent to your email and set a new password.';

  @override
  String get checkEmailForOtp => 'Check your email for OTP';

  @override
  String get newPassword => 'New password';

  @override
  String get resetPassword => 'Reset password';

  @override
  String get passwordMustBeAtLeast6Characters =>
      'Password must be at least 6 characters';

  @override
  String get passwordsDoNotMatchValidation => 'Passwords do not match';

  @override
  String get passwordChangedSuccessfully => 'Password changed successfully!';

  @override
  String get pleaseTryAgainLater => 'Please try again later';

  @override
  String get accountCreatedSuccessfully => 'Account created\nsuccessfully!';

  @override
  String get signupSuccessSubtitle =>
      'Welcome to Mshwar! Your account has been created successfully. Start booking rides now.';

  @override
  String get startExploring => 'Start exploring';

  @override
  String get skipForNow => 'Skip for now';

  @override
  String get pleaseWait => 'Please wait';

  @override
  String get pleaseWaitDots => 'Please wait...';

  @override
  String get somethingWentWrong =>
      'Something went wrong. Please try again later';

  @override
  String get myProfile => 'My Profile';

  @override
  String get saveDetails => 'Save details';

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
  String get tapToChangePhoto => 'Tap to change photo';

  @override
  String get deleteAccount => 'Delete account';

  @override
  String get areYouSureDeleteAccount =>
      'Are you sure you want to delete account?';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get changeInformation => 'Change information';

  @override
  String get chooseSource => 'Choose source';

  @override
  String get camera => 'Camera';

  @override
  String get gallery => 'Gallery';

  @override
  String get failedToPick => 'Failed to pick';

  @override
  String get rideManagement => 'Ride Management';

  @override
  String get allRides => 'All Rides';

  @override
  String get scheduledRides => 'Scheduled Rides';

  @override
  String get accountPayments => 'Account & Payments';

  @override
  String get changePassword => 'Change password';

  @override
  String get appSettings => 'App settings';

  @override
  String get notifications => 'Notifications';

  @override
  String get termsConditions => 'Terms & Conditions';

  @override
  String get privacyPolicy => 'Privacy & Policy';

  @override
  String get feedbackSupport => 'Feedback & Support';

  @override
  String get contactUs => 'Contact us';

  @override
  String get rateTheApp => 'Rate the app';

  @override
  String get darkMode => 'Dark mode';

  @override
  String get areYouSureLogout => 'Are you sure you want to log out?';

  @override
  String get serverError => 'Server error. Please try again.';

  @override
  String get connectionTimeout =>
      'Connection timeout. Please check your internet connection.';

  @override
  String get noInternetConnection =>
      'No internet connection. Please check your network.';

  @override
  String get invalidServerResponse =>
      'Invalid server response. Please try again.';

  @override
  String get anErrorOccurred => 'An error occurred. Please try again.';

  @override
  String get unexpectedError => 'Unexpected error. Please try again.';

  @override
  String get requestTimedOut => 'Request timed out. Please try again.';

  @override
  String get otpSentToEmail => 'OTP has been sent to your email!';

  @override
  String get otpSent => 'OTP sent';

  @override
  String get otpSentSuccessfully => 'OTP sent successfully';

  @override
  String get otpVerifiedSuccessfully => 'OTP verified successfully';

  @override
  String get failedToResendOtp => 'Failed to resend OTP. Please try again.';

  @override
  String get invalidOtp => 'Invalid OTP. Please try again.';

  @override
  String get invalidOtpOrRequestFailed => 'Invalid OTP or request failed';

  @override
  String get emailNotFound => 'Email not found or invalid request';

  @override
  String get failedToVerifyUser => 'Failed to verify user';

  @override
  String get unableToVerifyUser => 'Unable to verify user. Please try again.';

  @override
  String get failedToGetProfile => 'Failed to get profile';

  @override
  String get unableToFetchProfile =>
      'Unable to fetch profile. Please try again.';

  @override
  String get invalidPhoneNumber => 'Invalid phone number';

  @override
  String get tooManyAttempts =>
      'Too many attempts. Please request OTP after some time';

  @override
  String get signInCancelled => 'Sign in cancelled';

  @override
  String get changeLanguage => 'Change language';

  @override
  String get selectLanguage => 'Select language';

  @override
  String get chooseLanguageDesc => 'Choose your preferred language to continue';

  @override
  String get skip => 'Skip';

  @override
  String get skipDesc => 'You can change your language anytime from settings';

  @override
  String get save => 'Save';

  @override
  String get continuee => 'Continue';

  @override
  String get languageChangeSuccessfully => 'Language changed successfully';

  @override
  String get pressBackAgainToExit => 'Press back again to exit';

  @override
  String get logOut => 'Log out';

  @override
  String get cancel => 'Cancel';

  @override
  String get home => 'Home';

  @override
  String get ridesTitle => 'Rides';

  @override
  String get subscriptions => 'Subscriptions';

  @override
  String get packages => 'Packages';

  @override
  String get wallet => 'Wallet';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get enterDestination => 'Enter destination';

  @override
  String get departure => 'Departure';

  @override
  String get pickUpLocation => 'Pick-up location';

  @override
  String get destination => 'Destination';

  @override
  String get whereYouWantToGo => 'Where do you want to go?';

  @override
  String get whereDoYouWantToStop => 'Where do you want to stop?';

  @override
  String get searchDestination => 'Search destination';

  @override
  String get pleaseEnterPickupAddress => 'Please enter pickup address';

  @override
  String get pleaseEnterDestinationAddress =>
      'Please enter destination address';

  @override
  String get pleaseSelectVehicleType => 'Please select vehicle type';

  @override
  String get classicRidesOnly =>
      'Coming soon! 🚗\nCurrently we offer Classic rides only. Other vehicle types will be available soon!';

  @override
  String get unableToGetAddress => 'Unable to get address information.';

  @override
  String get errorProcessingDestination => 'Error processing destination';

  @override
  String get paymentError => 'Payment error';

  @override
  String get stop => 'Stop';

  @override
  String get selectPaymentMethod => 'Select payment method';

  @override
  String get totalAmount => 'Total Amount';

  @override
  String get discount => 'Discount';

  @override
  String get confirmPay => 'Confirm & Pay';

  @override
  String get cash => 'Cash';

  @override
  String get knetCreditCardOthers => 'KNET, credit card & others';

  @override
  String get bookingConfirmed => 'Booking confirmed';

  @override
  String get bookingConfirmedExclamation => 'Booking confirmed!';

  @override
  String get rideSuccessfullyBookedMessage =>
      'Your ride has been successfully booked. Sit back and relax, your driver is on the way.';

  @override
  String get trackRide => 'Track ride';

  @override
  String get backToHome => 'Back to home';

  @override
  String get walletBalance => 'Wallet Balance';

  @override
  String get transactionHistory => 'Transaction history';

  @override
  String get transactions => 'Transactions';

  @override
  String get transactionNotFound => 'Transaction not found.';

  @override
  String get topUpAmount => 'Top up amount';

  @override
  String get addAmount => 'Add amount';

  @override
  String get noNotifications => 'No notifications';

  @override
  String get youHaveNoNotificationsYet => 'You have no notifications yet';

  @override
  String get accept => 'Accept';

  @override
  String get decline => 'Decline';

  @override
  String get permissionDenied => 'Permission denied';

  @override
  String get done => 'Done';

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
  String get bookRide => 'Book ride';

  @override
  String get whereToGo => 'Where to go?';

  @override
  String get pickupLocation => 'Pickup location';

  @override
  String get dropoffLocation => 'Dropoff location';

  @override
  String get confirmLocation => 'Confirm location';

  @override
  String get searchLocation => 'Search Location';

  @override
  String get useCurrentLocation => 'Use current location';

  @override
  String get noResultsFound => 'No results found';

  @override
  String get selectVehicle => 'Select vehicle';

  @override
  String get vehicle => 'Vehicle';

  @override
  String get passengers => 'Passengers';

  @override
  String get change => 'Change';

  @override
  String get numberOfPassengers => 'Number of passengers';

  @override
  String get scheduleRide => 'Schedule ride';

  @override
  String get scheduledFor => 'Scheduled for';

  @override
  String get continueToPayment => 'Continue to payment';

  @override
  String get pleaseSelectVehicle => 'Please select a vehicle';

  @override
  String get paymentMethod => 'Payment method';

  @override
  String get totalFare => 'Total fare';

  @override
  String get confirmBooking => 'Confirm booking';

  @override
  String get pleaseSelectPaymentMethod => 'Please select a payment method';

  @override
  String get yourRideHasBeenBooked => 'Your ride has been booked successfully';

  @override
  String get bookingId => 'Booking ID';

  @override
  String get estimatedArrival => 'Estimated arrival';

  @override
  String get otp => 'OTP';

  @override
  String get driverDetails => 'Driver details';

  @override
  String get rides => 'rides';

  @override
  String get priceSummary => 'Price Summary';

  @override
  String get basePrice => 'Base price';

  @override
  String get distancePrice => 'Distance price';

  @override
  String get timePrice => 'Time price';

  @override
  String get packageDiscount => 'Package discount';

  @override
  String get total => 'Total';

  @override
  String get pickup => 'Pickup';

  @override
  String get dropoff => 'Dropoff';

  @override
  String get stops => 'Stops';

  @override
  String get addStop => 'Add Stop';

  @override
  String get removeStop => 'Remove Stop';

  @override
  String get noStopsAdded => 'No stops added yet';

  @override
  String get enterLocation => 'Enter location';

  @override
  String get usePackageKm => 'Use Package KM';

  @override
  String get packageKmAvailable => 'Package KM Available';

  @override
  String get packageKmToUse => 'Package KM to Use';

  @override
  String get packageKmRemaining => 'Remaining KM';

  @override
  String get packageKmDiscountInfo =>
      'Your package KM will be used for this ride';

  @override
  String get haveCouponCode => 'Have a Coupon Code?';

  @override
  String get enterCouponCode => 'Enter Coupon Code';

  @override
  String get applyCoupon => 'Apply Coupon';

  @override
  String get removeCoupon => 'Remove Coupon';

  @override
  String get couponApplied => 'Coupon Applied';

  @override
  String get couponDiscount => 'Coupon Discount';

  @override
  String get invalidCoupon => 'Invalid Coupon Code';

  @override
  String get couponCodeRemoved => 'Coupon code removed';

  @override
  String get insufficientBalance => 'Insufficient Wallet Balance';

  @override
  String get addFunds => 'Add Funds to Wallet';

  @override
  String get pendingPayment => 'Pending Payment';

  @override
  String get pendingPaymentMessage =>
      'You have a pending payment. Please complete it to continue booking rides.';

  @override
  String get amountDue => 'Amount Due';

  @override
  String get payNow => 'Pay Now';

  @override
  String get later => 'Later';

  @override
  String get buyPackages => 'Buy Packages';

  @override
  String get myPackages => 'My Packages';

  @override
  String get noPackagesAvailable => 'No Packages Available';

  @override
  String get noPackagesAvailableDesc =>
      'There are no KM packages available for purchase at the moment.';

  @override
  String get noPackagesPurchased => 'No Packages Purchased';

  @override
  String get noPackagesPurchasedDesc =>
      'You haven\'t purchased any KM packages yet. Buy one to save on your rides!';

  @override
  String get buyMorePackages => 'Buy More Packages';

  @override
  String get buyMorePackagesDesc =>
      'You can buy the same package multiple times!';

  @override
  String get availableKm => 'Available';

  @override
  String get usedKm => 'Used KM';

  @override
  String get totalKm => 'Total';

  @override
  String get remaining => 'remaining';

  @override
  String get used => 'used';

  @override
  String get purchased => 'Purchased';

  @override
  String get purchasePackage => 'Purchase Package';

  @override
  String get totalKilometers => 'Total Kilometers';

  @override
  String get pricePerKm => 'Price per KM';

  @override
  String get proceedToPayment => 'Proceed to Payment';

  @override
  String get invalidPackagePrice => 'Invalid package price';

  @override
  String get packagePrice => 'Package Price';

  @override
  String get packagePurchaseInitiated => 'Package purchase initiated';

  @override
  String get packagePurchasedSuccessfully => 'Package purchased successfully!';

  @override
  String get noSubscriptionsYet => 'No Subscriptions Yet';

  @override
  String get noSubscriptionsYetDesc =>
      'Create your first ride subscription for regular commutes';

  @override
  String get subscriptionsNotAvailable => 'Subscriptions Not Available';

  @override
  String get subscriptionsNotAvailableDesc =>
      'Subscription service is not available at the moment. Please check back later.';

  @override
  String get distance => 'Distance';

  @override
  String get trips => 'Trips';

  @override
  String get price => 'Price';

  @override
  String get buyNow => 'Buy Now';

  @override
  String get totalPrice => 'Total Price';

  @override
  String get walletPaymentNotImplemented =>
      'Wallet payment not implemented yet';

  @override
  String get knetPaymentNotImplemented => 'KNET payment not implemented yet';

  @override
  String get coupons => 'Coupons';

  @override
  String get noCouponsAvailable => 'No Coupons Available';

  @override
  String get couponCodeCopied => 'Coupon code copied to clipboard';

  @override
  String get validTill => 'Valid till';

  @override
  String get activeRides => 'Active Rides';

  @override
  String get rideHistory => 'Ride History';

  @override
  String get rideDetails => 'Ride Details';

  @override
  String get searchingForDriver => 'Searching for driver';

  @override
  String get driverAssigned => 'Driver assigned';

  @override
  String get driverArrived => 'Driver arrived';

  @override
  String get onRide => 'On Ride';

  @override
  String get rejected => 'Rejected';

  @override
  String get errorLoadingRides => 'Error Loading Rides';

  @override
  String get errorLoadingHistory => 'Error Loading History';

  @override
  String get noActiveRides => 'No Active Rides';

  @override
  String get noRideHistory => 'No Ride History';

  @override
  String get bookARideToGetStarted => 'Book a ride to get started';

  @override
  String get yourCompletedRidesWillAppearHere =>
      'Your completed rides will appear here';

  @override
  String get chatWithDriver => 'Chat with Driver';

  @override
  String get sendMessage => 'Send message';

  @override
  String get typeAMessage => 'Type a message';

  @override
  String get addReview => 'Add Review';

  @override
  String get rateYourRide => 'Rate your ride';

  @override
  String get writeAReview => 'Write a review (optional)';

  @override
  String get submitReview => 'Submit Review';

  @override
  String get reviewSubmitted => 'Review submitted successfully';

  @override
  String get addComplaint => 'Add Complaint';

  @override
  String get complaintType => 'Complaint Type';

  @override
  String get selectComplaintType => 'Select complaint type';

  @override
  String get driverBehavior => 'Driver Behavior';

  @override
  String get vehicleCondition => 'Vehicle Condition';

  @override
  String get routeIssue => 'Route Issue';

  @override
  String get paymentIssue => 'Payment Issue';

  @override
  String get safetyIssue => 'Safety Issue';

  @override
  String get describeYourComplaint => 'Describe your complaint';

  @override
  String get submitComplaint => 'Submit Complaint';

  @override
  String get complaintSubmitted => 'Complaint submitted successfully';

  @override
  String get callDriver => 'Call Driver';

  @override
  String get cancelRide => 'Cancel Ride';

  @override
  String get confirmCancellation => 'Confirm Cancellation';

  @override
  String get areYouSureYouWantToCancelThisRide =>
      'Are you sure you want to cancel this ride?';

  @override
  String get cancellationReason => 'Cancellation reason (optional)';

  @override
  String get rideCancelled => 'Ride cancelled successfully';

  @override
  String get route => 'Route';

  @override
  String get vehicleDetails => 'Vehicle Details';

  @override
  String get vehiclePlate => 'Vehicle Plate';

  @override
  String get vehicleModel => 'Vehicle Model';

  @override
  String get vehicleColor => 'Vehicle Color';

  @override
  String get contactDriver => 'Contact Driver';

  @override
  String get viewOnMap => 'View on Map';

  @override
  String get ok => 'OK';

  @override
  String get online => 'Online';

  @override
  String get enRoute => 'En Route';

  @override
  String get arrived => 'Arrived';

  @override
  String get offline => 'Offline';

  @override
  String get driverInfoAfterPayment =>
      'Driver information will be shown after payment';

  @override
  String get driverContact => 'Driver\'s Contact';

  @override
  String get carDetails => 'Car Details';

  @override
  String get licensePlate => 'License Plate';

  @override
  String get close => 'Close';

  @override
  String get searchByLocation =>
      'Search by location, date, time, or ride ID...';

  @override
  String get searchByHint =>
      'Search by: Pickup, Destination, Date, Time, or Ride ID';

  @override
  String get errorLoadingScheduledRides => 'Error Loading Scheduled Rides';

  @override
  String get noScheduledRidesFound => 'No scheduled rides found';

  @override
  String get tryDifferentSearch => 'Try a different search term';

  @override
  String get noRecentSearches => 'No Recent Searches';

  @override
  String get startTypingToSearch => 'Start typing to search for locations';

  @override
  String get recentSearches => 'Recent Searches';

  @override
  String get clear => 'Clear';

  @override
  String get locationSearching => 'Searching location...';

  @override
  String get notFoundLocation => 'Location not found';

  @override
  String get suggestedLocation => 'Suggested location';

  @override
  String get searchAddress => 'Search Address';

  @override
  String get scheduled => 'SCHEDULED';

  @override
  String get normal => 'Normal';

  @override
  String get driverEstimateArrivalTime => 'Driver Estimate Arrival Time';

  @override
  String get hideMyLocation => 'Hide my location';

  @override
  String get showMyLocation => 'Show my location';

  @override
  String get locationPermissionDenied => 'Location permission denied';

  @override
  String get locationPermissionsPermanentlyDenied =>
      'Location permissions are permanently denied. Please enable them in settings.';

  @override
  String get tripHash => 'Trip #';

  @override
  String get paid => 'Paid';

  @override
  String get all => 'All';

  @override
  String get pending => 'Pending';

  @override
  String get newStatus => 'New';

  @override
  String get confirmed => 'Confirmed';

  @override
  String get other => 'Other';

  @override
  String get thankYouForFeedback => 'Thank you for your feedback!';

  @override
  String get reviewSubmittedSuccessfully =>
      'Your rating has been submitted successfully. We appreciate your input in helping us improve your ride experience.';

  @override
  String get cancelTrip => 'Cancel Trip';

  @override
  String get writeCancelReason => 'Write a reason for trip cancellation';

  @override
  String get pleaseEnterReason => 'Please enter a reason';

  @override
  String get doYouWantToCancel => 'Do you want to cancel this booking?';

  @override
  String get iDoNotFeelSafe => 'I do not feel safe';

  @override
  String get reportSubmitted => 'Report submitted';
}
