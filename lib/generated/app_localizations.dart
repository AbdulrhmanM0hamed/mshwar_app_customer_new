import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_ur.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('ur')
  ];

  /// No description provided for @error_no_internet_connection.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get error_no_internet_connection;

  /// No description provided for @error_no_internet_connection_desc.
  ///
  /// In en, this message translates to:
  /// **'Please check your internet connection and try again'**
  String get error_no_internet_connection_desc;

  /// No description provided for @error_connection_timeout.
  ///
  /// In en, this message translates to:
  /// **'Connection timeout'**
  String get error_connection_timeout;

  /// No description provided for @error_connection_timeout_desc.
  ///
  /// In en, this message translates to:
  /// **'The connection took too long to establish. Please try again'**
  String get error_connection_timeout_desc;

  /// No description provided for @error_receive_timeout.
  ///
  /// In en, this message translates to:
  /// **'Receive timeout'**
  String get error_receive_timeout;

  /// No description provided for @error_receive_timeout_desc.
  ///
  /// In en, this message translates to:
  /// **'The server took too long to respond. Please try again'**
  String get error_receive_timeout_desc;

  /// No description provided for @error_send_timeout.
  ///
  /// In en, this message translates to:
  /// **'Send timeout'**
  String get error_send_timeout;

  /// No description provided for @error_send_timeout_desc.
  ///
  /// In en, this message translates to:
  /// **'Failed to send data to the server. Please try again'**
  String get error_send_timeout_desc;

  /// No description provided for @error_server_error.
  ///
  /// In en, this message translates to:
  /// **'Server error'**
  String get error_server_error;

  /// No description provided for @error_server_error_desc.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong on the server. Please try again later'**
  String get error_server_error_desc;

  /// No description provided for @error_internal_server_error.
  ///
  /// In en, this message translates to:
  /// **'Internal server error'**
  String get error_internal_server_error;

  /// No description provided for @error_internal_server_error_desc.
  ///
  /// In en, this message translates to:
  /// **'The server encountered an internal error. Please try again later'**
  String get error_internal_server_error_desc;

  /// No description provided for @error_bad_gateway.
  ///
  /// In en, this message translates to:
  /// **'Bad gateway'**
  String get error_bad_gateway;

  /// No description provided for @error_bad_gateway_desc.
  ///
  /// In en, this message translates to:
  /// **'The server received an invalid response. Please try again later'**
  String get error_bad_gateway_desc;

  /// No description provided for @error_service_unavailable.
  ///
  /// In en, this message translates to:
  /// **'Service unavailable'**
  String get error_service_unavailable;

  /// No description provided for @error_service_unavailable_desc.
  ///
  /// In en, this message translates to:
  /// **'The service is temporarily unavailable. Please try again later'**
  String get error_service_unavailable_desc;

  /// No description provided for @error_gateway_timeout.
  ///
  /// In en, this message translates to:
  /// **'Gateway timeout'**
  String get error_gateway_timeout;

  /// No description provided for @error_gateway_timeout_desc.
  ///
  /// In en, this message translates to:
  /// **'The gateway timed out. Please try again later'**
  String get error_gateway_timeout_desc;

  /// No description provided for @error_bad_request.
  ///
  /// In en, this message translates to:
  /// **'Bad request'**
  String get error_bad_request;

  /// No description provided for @properties_empty_message_favourite.
  ///
  /// In en, this message translates to:
  /// **'You have not added any properties to your favorites.'**
  String get properties_empty_message_favourite;

  /// No description provided for @error_bad_request_desc.
  ///
  /// In en, this message translates to:
  /// **'The request contains invalid data. Please check your input'**
  String get error_bad_request_desc;

  /// No description provided for @error_unauthorized.
  ///
  /// In en, this message translates to:
  /// **'Unauthorized'**
  String get error_unauthorized;

  /// No description provided for @error_unauthorized_desc.
  ///
  /// In en, this message translates to:
  /// **'You are not authorized to access this resource. Please login again'**
  String get error_unauthorized_desc;

  /// No description provided for @error_forbidden.
  ///
  /// In en, this message translates to:
  /// **'Access denied'**
  String get error_forbidden;

  /// No description provided for @error_forbidden_desc.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have permission to access this resource'**
  String get error_forbidden_desc;

  /// No description provided for @error_not_found.
  ///
  /// In en, this message translates to:
  /// **'Not found'**
  String get error_not_found;

  /// No description provided for @error_not_found_desc.
  ///
  /// In en, this message translates to:
  /// **'The requested resource was not found'**
  String get error_not_found_desc;

  /// No description provided for @error_method_not_allowed.
  ///
  /// In en, this message translates to:
  /// **'Method not allowed'**
  String get error_method_not_allowed;

  /// No description provided for @error_method_not_allowed_desc.
  ///
  /// In en, this message translates to:
  /// **'This method is not allowed for this resource'**
  String get error_method_not_allowed_desc;

  /// No description provided for @error_not_acceptable.
  ///
  /// In en, this message translates to:
  /// **'Not acceptable'**
  String get error_not_acceptable;

  /// No description provided for @error_not_acceptable_desc.
  ///
  /// In en, this message translates to:
  /// **'The request is not acceptable'**
  String get error_not_acceptable_desc;

  /// No description provided for @error_request_timeout.
  ///
  /// In en, this message translates to:
  /// **'Request timeout'**
  String get error_request_timeout;

  /// No description provided for @error_request_timeout_desc.
  ///
  /// In en, this message translates to:
  /// **'The request timed out. Please try again'**
  String get error_request_timeout_desc;

  /// No description provided for @error_conflict.
  ///
  /// In en, this message translates to:
  /// **'Conflict'**
  String get error_conflict;

  /// No description provided for @error_conflict_desc.
  ///
  /// In en, this message translates to:
  /// **'There is a conflict with the current state of the resource'**
  String get error_conflict_desc;

  /// No description provided for @error_gone.
  ///
  /// In en, this message translates to:
  /// **'Resource gone'**
  String get error_gone;

  /// No description provided for @error_gone_desc.
  ///
  /// In en, this message translates to:
  /// **'The requested resource is no longer available'**
  String get error_gone_desc;

  /// No description provided for @error_length_required.
  ///
  /// In en, this message translates to:
  /// **'Length required'**
  String get error_length_required;

  /// No description provided for @error_length_required_desc.
  ///
  /// In en, this message translates to:
  /// **'The request must specify the content length'**
  String get error_length_required_desc;

  /// No description provided for @error_precondition_failed.
  ///
  /// In en, this message translates to:
  /// **'Precondition failed'**
  String get error_precondition_failed;

  /// No description provided for @error_precondition_failed_desc.
  ///
  /// In en, this message translates to:
  /// **'One or more preconditions failed'**
  String get error_precondition_failed_desc;

  /// No description provided for @error_payload_too_large.
  ///
  /// In en, this message translates to:
  /// **'Payload too large'**
  String get error_payload_too_large;

  /// No description provided for @error_payload_too_large_desc.
  ///
  /// In en, this message translates to:
  /// **'The request payload is too large'**
  String get error_payload_too_large_desc;

  /// No description provided for @error_uri_too_long.
  ///
  /// In en, this message translates to:
  /// **'URI too long'**
  String get error_uri_too_long;

  /// No description provided for @error_uri_too_long_desc.
  ///
  /// In en, this message translates to:
  /// **'The request URI is too long'**
  String get error_uri_too_long_desc;

  /// No description provided for @lead_send_error.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while sending the contact request'**
  String get lead_send_error;

  /// No description provided for @lead_info_collected.
  ///
  /// In en, this message translates to:
  /// **'Lead information collected successfully'**
  String get lead_info_collected;

  /// No description provided for @lead_offline_mode.
  ///
  /// In en, this message translates to:
  /// **'Contact information saved offline'**
  String get lead_offline_mode;

  /// No description provided for @error_unsupported_media_type.
  ///
  /// In en, this message translates to:
  /// **'Unsupported media type'**
  String get error_unsupported_media_type;

  /// No description provided for @error_unsupported_media_type_desc.
  ///
  /// In en, this message translates to:
  /// **'The media type is not supported'**
  String get error_unsupported_media_type_desc;

  /// No description provided for @error_range_not_satisfiable.
  ///
  /// In en, this message translates to:
  /// **'Range not satisfiable'**
  String get error_range_not_satisfiable;

  /// No description provided for @error_range_not_satisfiable_desc.
  ///
  /// In en, this message translates to:
  /// **'The requested range cannot be satisfied'**
  String get error_range_not_satisfiable_desc;

  /// No description provided for @error_expectation_failed.
  ///
  /// In en, this message translates to:
  /// **'Expectation failed'**
  String get error_expectation_failed;

  /// No description provided for @error_expectation_failed_desc.
  ///
  /// In en, this message translates to:
  /// **'The expectation given in the request header field could not be met'**
  String get error_expectation_failed_desc;

  /// No description provided for @error_too_many_requests.
  ///
  /// In en, this message translates to:
  /// **'Too many requests'**
  String get error_too_many_requests;

  /// No description provided for @error_too_many_requests_desc.
  ///
  /// In en, this message translates to:
  /// **'You have sent too many requests. Please try again later'**
  String get error_too_many_requests_desc;

  /// No description provided for @error_unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown error'**
  String get error_unknown;

  /// No description provided for @error_unknown_desc.
  ///
  /// In en, this message translates to:
  /// **'An unknown error occurred. Please try again'**
  String get error_unknown_desc;

  /// No description provided for @error_cancelled.
  ///
  /// In en, this message translates to:
  /// **'Request cancelled'**
  String get error_cancelled;

  /// No description provided for @error_cancelled_desc.
  ///
  /// In en, this message translates to:
  /// **'The request was cancelled'**
  String get error_cancelled_desc;

  /// No description provided for @error_other.
  ///
  /// In en, this message translates to:
  /// **'Error occurred'**
  String get error_other;

  /// No description provided for @error_other_desc.
  ///
  /// In en, this message translates to:
  /// **'An error occurred. Please try again'**
  String get error_other_desc;

  /// Retry button text
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @contact_support.
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get contact_support;

  /// No description provided for @go_back.
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get go_back;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @check_connection.
  ///
  /// In en, this message translates to:
  /// **'Check Connection'**
  String get check_connection;

  /// Application title
  ///
  /// In en, this message translates to:
  /// **'Mshwar'**
  String get appTitle;

  /// Go back button text
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get goBack;

  /// Contact support button text
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get contactSupport;

  /// Check connection button text
  ///
  /// In en, this message translates to:
  /// **'Check Connection'**
  String get checkConnection;

  /// No internet error title
  ///
  /// In en, this message translates to:
  /// **'No Internet Connection'**
  String get errorNoInternet;

  /// No internet error description
  ///
  /// In en, this message translates to:
  /// **'Please check your internet connection and try again.'**
  String get errorNoInternetDesc;

  /// Timeout error title
  ///
  /// In en, this message translates to:
  /// **'Request Timeout'**
  String get errorTimeout;

  /// Timeout error description
  ///
  /// In en, this message translates to:
  /// **'The request took too long to complete. Please try again.'**
  String get errorTimeoutDesc;

  /// Server error title
  ///
  /// In en, this message translates to:
  /// **'Server Error'**
  String get errorServerError;

  /// Server error description
  ///
  /// In en, this message translates to:
  /// **'Something went wrong on our end. Please try again later.'**
  String get errorServerErrorDesc;

  /// Bad request error title
  ///
  /// In en, this message translates to:
  /// **'Invalid Request'**
  String get errorBadRequest;

  /// Bad request error description
  ///
  /// In en, this message translates to:
  /// **'The request could not be understood. Please check your input.'**
  String get errorBadRequestDesc;

  /// Unauthorized error title
  ///
  /// In en, this message translates to:
  /// **'Unauthorized'**
  String get errorUnauthorized;

  /// Unauthorized error description
  ///
  /// In en, this message translates to:
  /// **'Please log in to continue.'**
  String get errorUnauthorizedDesc;

  /// Forbidden error title
  ///
  /// In en, this message translates to:
  /// **'Access Denied'**
  String get errorForbidden;

  /// Forbidden error description
  ///
  /// In en, this message translates to:
  /// **'You don\'t have permission to access this resource.'**
  String get errorForbiddenDesc;

  /// Not found error title
  ///
  /// In en, this message translates to:
  /// **'Not Found'**
  String get errorNotFound;

  /// Not found error description
  ///
  /// In en, this message translates to:
  /// **'The requested resource could not be found.'**
  String get errorNotFoundDesc;

  /// Method not allowed error title
  ///
  /// In en, this message translates to:
  /// **'Method Not Allowed'**
  String get errorMethodNotAllowed;

  /// Method not allowed error description
  ///
  /// In en, this message translates to:
  /// **'This action is not allowed.'**
  String get errorMethodNotAllowedDesc;

  /// Not acceptable error title
  ///
  /// In en, this message translates to:
  /// **'Not Acceptable'**
  String get errorNotAcceptable;

  /// Not acceptable error description
  ///
  /// In en, this message translates to:
  /// **'The request format is not acceptable.'**
  String get errorNotAcceptableDesc;

  /// Conflict error title
  ///
  /// In en, this message translates to:
  /// **'Conflict'**
  String get errorConflict;

  /// Conflict error description
  ///
  /// In en, this message translates to:
  /// **'There was a conflict with the current state.'**
  String get errorConflictDesc;

  /// Gone error title
  ///
  /// In en, this message translates to:
  /// **'Resource Gone'**
  String get errorGone;

  /// Gone error description
  ///
  /// In en, this message translates to:
  /// **'This resource is no longer available.'**
  String get errorGoneDesc;

  /// Length required error title
  ///
  /// In en, this message translates to:
  /// **'Length Required'**
  String get errorLengthRequired;

  /// Length required error description
  ///
  /// In en, this message translates to:
  /// **'The request length is required.'**
  String get errorLengthRequiredDesc;

  /// Precondition failed error title
  ///
  /// In en, this message translates to:
  /// **'Precondition Failed'**
  String get errorPreconditionFailed;

  /// Precondition failed error description
  ///
  /// In en, this message translates to:
  /// **'A required condition was not met.'**
  String get errorPreconditionFailedDesc;

  /// Payload too large error title
  ///
  /// In en, this message translates to:
  /// **'File Too Large'**
  String get errorPayloadTooLarge;

  /// Payload too large error description
  ///
  /// In en, this message translates to:
  /// **'The file you\'re trying to upload is too large.'**
  String get errorPayloadTooLargeDesc;

  /// URI too long error title
  ///
  /// In en, this message translates to:
  /// **'URI Too Long'**
  String get errorUriTooLong;

  /// URI too long error description
  ///
  /// In en, this message translates to:
  /// **'The request URL is too long.'**
  String get errorUriTooLongDesc;

  /// Unsupported media type error title
  ///
  /// In en, this message translates to:
  /// **'Unsupported File Type'**
  String get errorUnsupportedMediaType;

  /// Unsupported media type error description
  ///
  /// In en, this message translates to:
  /// **'This file type is not supported.'**
  String get errorUnsupportedMediaTypeDesc;

  /// Range not satisfiable error title
  ///
  /// In en, this message translates to:
  /// **'Range Not Satisfiable'**
  String get errorRangeNotSatisfiable;

  /// Range not satisfiable error description
  ///
  /// In en, this message translates to:
  /// **'The requested range is not available.'**
  String get errorRangeNotSatisfiableDesc;

  /// Expectation failed error title
  ///
  /// In en, this message translates to:
  /// **'Expectation Failed'**
  String get errorExpectationFailed;

  /// Expectation failed error description
  ///
  /// In en, this message translates to:
  /// **'The server cannot meet the requirements.'**
  String get errorExpectationFailedDesc;

  /// Too many requests error title
  ///
  /// In en, this message translates to:
  /// **'Too Many Requests'**
  String get errorTooManyRequests;

  /// Too many requests error description
  ///
  /// In en, this message translates to:
  /// **'You\'ve made too many requests. Please wait and try again.'**
  String get errorTooManyRequestsDesc;

  /// Cancelled error title
  ///
  /// In en, this message translates to:
  /// **'Request Cancelled'**
  String get errorCancelled;

  /// Cancelled error description
  ///
  /// In en, this message translates to:
  /// **'The request was cancelled.'**
  String get errorCancelledDesc;

  /// Unknown error title
  ///
  /// In en, this message translates to:
  /// **'Something Went Wrong'**
  String get errorUnknown;

  /// Unknown error description
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred. Please try again.'**
  String get errorUnknownDesc;

  /// Other error title
  ///
  /// In en, this message translates to:
  /// **'Error Occurred'**
  String get errorOther;

  /// No description provided for @errorOtherDesc.
  ///
  /// In en, this message translates to:
  /// **'An error occurred. Please try again.'**
  String get errorOtherDesc;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Other error description'**
  String get description;

  /// No description provided for @yourJourneyOurPriority.
  ///
  /// In en, this message translates to:
  /// **'Your journey, our priority'**
  String get yourJourneyOurPriority;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @poweredByMshwar.
  ///
  /// In en, this message translates to:
  /// **'Powered by Mshwar'**
  String get poweredByMshwar;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back!'**
  String get welcomeBack;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Log in to your Mshwar account and continue your journey with seamless rides.'**
  String get loginSubtitle;

  /// No description provided for @firstTimeInMshwar.
  ///
  /// In en, this message translates to:
  /// **'First time in Mshwar?'**
  String get firstTimeInMshwar;

  /// No description provided for @createAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Create an account'**
  String get createAnAccount;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get emailAddress;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter password'**
  String get enterPassword;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password'**
  String get forgotPassword;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @orContinueWith.
  ///
  /// In en, this message translates to:
  /// **'Or continue with'**
  String get orContinueWith;

  /// No description provided for @mobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Mobile number'**
  String get mobileNumber;

  /// No description provided for @google.
  ///
  /// In en, this message translates to:
  /// **'Google'**
  String get google;

  /// No description provided for @apple.
  ///
  /// In en, this message translates to:
  /// **'Apple'**
  String get apple;

  /// No description provided for @pleaseEnterEmailAddress.
  ///
  /// In en, this message translates to:
  /// **'Please enter email address'**
  String get pleaseEnterEmailAddress;

  /// No description provided for @pleaseEnterPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter password'**
  String get pleaseEnterPassword;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @logInWithMobile.
  ///
  /// In en, this message translates to:
  /// **'Log in with mobile'**
  String get logInWithMobile;

  /// No description provided for @signUpWithMobile.
  ///
  /// In en, this message translates to:
  /// **'Sign up with mobile'**
  String get signUpWithMobile;

  /// No description provided for @mobileLoginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your mobile number to securely log in and access your Mshwar account.'**
  String get mobileLoginSubtitle;

  /// No description provided for @mobileSignupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign up using your mobile number for a fast and simple registration in Mshwar.'**
  String get mobileSignupSubtitle;

  /// No description provided for @sendOtp.
  ///
  /// In en, this message translates to:
  /// **'Send OTP'**
  String get sendOtp;

  /// No description provided for @alreadyBookRides.
  ///
  /// In en, this message translates to:
  /// **'Already book rides?'**
  String get alreadyBookRides;

  /// No description provided for @pleaseEnterMobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter mobile number'**
  String get pleaseEnterMobileNumber;

  /// No description provided for @phoneNumberIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get phoneNumberIsRequired;

  /// No description provided for @kuwaitNumberMustBe8Digits.
  ///
  /// In en, this message translates to:
  /// **'Kuwait number must be 8 digits'**
  String get kuwaitNumberMustBe8Digits;

  /// No description provided for @invalidKuwaitPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Invalid Kuwait phone number'**
  String get invalidKuwaitPhoneNumber;

  /// No description provided for @codeSending.
  ///
  /// In en, this message translates to:
  /// **'Sending code'**
  String get codeSending;

  /// No description provided for @verifyYourOtp.
  ///
  /// In en, this message translates to:
  /// **'Verify your OTP'**
  String get verifyYourOtp;

  /// No description provided for @otpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the one-time password sent to your mobile number to verify your account.'**
  String get otpSubtitle;

  /// No description provided for @alreadyHaveAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAnAccount;

  /// No description provided for @logIn.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get logIn;

  /// No description provided for @didntReceiveCode.
  ///
  /// In en, this message translates to:
  /// **'Didn�t receive the code?'**
  String get didntReceiveCode;

  /// No description provided for @resendCodeIn.
  ///
  /// In en, this message translates to:
  /// **'Resend code in '**
  String get resendCodeIn;

  /// No description provided for @resendOtp.
  ///
  /// In en, this message translates to:
  /// **'Resend OTP'**
  String get resendOtp;

  /// No description provided for @verifyOtp.
  ///
  /// In en, this message translates to:
  /// **'Verify OTP'**
  String get verifyOtp;

  /// No description provided for @pleaseEnterCompleteOtp.
  ///
  /// In en, this message translates to:
  /// **'Please enter complete OTP'**
  String get pleaseEnterCompleteOtp;

  /// No description provided for @createYourAccount.
  ///
  /// In en, this message translates to:
  /// **'Create your account'**
  String get createYourAccount;

  /// No description provided for @signupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign up for a personalized Mshwar experience. Start booking rides in just a few taps.'**
  String get signupSubtitle;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First name'**
  String get firstName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last name'**
  String get lastName;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPassword;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signUp;

  /// No description provided for @firstNameRequired.
  ///
  /// In en, this message translates to:
  /// **'First name is required'**
  String get firstNameRequired;

  /// No description provided for @lastNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Last name is required'**
  String get lastNameRequired;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailRequired;

  /// No description provided for @pleaseEnterValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get pleaseEnterValidEmail;

  /// No description provided for @passwordMustBeAtLeast6.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordMustBeAtLeast6;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @enterValidEmailAddress.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address'**
  String get enterValidEmailAddress;

  /// No description provided for @minCharacters.
  ///
  /// In en, this message translates to:
  /// **'Minimum {count} characters'**
  String minCharacters(Object count);

  /// No description provided for @reEnterYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Re-enter your password'**
  String get reEnterYourPassword;

  /// No description provided for @enter8DigitKuwaitMobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter an 8-digit Kuwait mobile number'**
  String get enter8DigitKuwaitMobileNumber;

  /// No description provided for @enterYourNameLettersOnly.
  ///
  /// In en, this message translates to:
  /// **'Enter your name (letters only)'**
  String get enterYourNameLettersOnly;

  /// No description provided for @thisFieldIsRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get thisFieldIsRequired;

  /// No description provided for @emailMustContainAt.
  ///
  /// In en, this message translates to:
  /// **'Email must contain @'**
  String get emailMustContainAt;

  /// No description provided for @emailMustContainDomain.
  ///
  /// In en, this message translates to:
  /// **'Email must contain a domain'**
  String get emailMustContainDomain;

  /// No description provided for @invalidEmailFormat.
  ///
  /// In en, this message translates to:
  /// **'Invalid email format'**
  String get invalidEmailFormat;

  /// No description provided for @validEmailAddress.
  ///
  /// In en, this message translates to:
  /// **'Valid email address'**
  String get validEmailAddress;

  /// No description provided for @passwordMustBeAtLeastCharacters.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least {count} characters'**
  String passwordMustBeAtLeastCharacters(Object count);

  /// No description provided for @validPassword.
  ///
  /// In en, this message translates to:
  /// **'Valid password'**
  String get validPassword;

  /// No description provided for @passwordControllerNotProvided.
  ///
  /// In en, this message translates to:
  /// **'Password controller not provided'**
  String get passwordControllerNotProvided;

  /// No description provided for @passwordsMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords match'**
  String get passwordsMatch;

  /// No description provided for @kuwaitNumbersStartWith.
  ///
  /// In en, this message translates to:
  /// **'Kuwait numbers start with 5, 6, 9, 2, or 41'**
  String get kuwaitNumbersStartWith;

  /// No description provided for @validKuwaitPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Valid Kuwait phone number'**
  String get validKuwaitPhoneNumber;

  /// No description provided for @nameMustBeAtLeast2Characters.
  ///
  /// In en, this message translates to:
  /// **'Name must be at least 2 characters'**
  String get nameMustBeAtLeast2Characters;

  /// No description provided for @nameCanOnlyContainLetters.
  ///
  /// In en, this message translates to:
  /// **'Name can only contain letters'**
  String get nameCanOnlyContainLetters;

  /// No description provided for @validName.
  ///
  /// In en, this message translates to:
  /// **'Valid name'**
  String get validName;

  /// No description provided for @forgotYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot your password?'**
  String get forgotYourPassword;

  /// No description provided for @forgotPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Don�t worry! Enter your email or mobile number and we�ll help you reset your password.'**
  String get forgotPasswordSubtitle;

  /// No description provided for @sendResetLink.
  ///
  /// In en, this message translates to:
  /// **'Send reset link'**
  String get sendResetLink;

  /// No description provided for @pleaseEnterYourEmailAddress.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email address'**
  String get pleaseEnterYourEmailAddress;

  /// No description provided for @resetYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset your password'**
  String get resetYourPassword;

  /// No description provided for @resetPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the OTP sent to your email and set a new password.'**
  String get resetPasswordSubtitle;

  /// No description provided for @checkEmailForOtp.
  ///
  /// In en, this message translates to:
  /// **'Check your email for OTP'**
  String get checkEmailForOtp;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get newPassword;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get resetPassword;

  /// No description provided for @passwordMustBeAtLeast6Characters.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordMustBeAtLeast6Characters;

  /// No description provided for @passwordsDoNotMatchValidation.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatchValidation;

  /// No description provided for @passwordChangedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Password changed successfully!'**
  String get passwordChangedSuccessfully;

  /// No description provided for @pleaseTryAgainLater.
  ///
  /// In en, this message translates to:
  /// **'Please try again later'**
  String get pleaseTryAgainLater;

  /// No description provided for @accountCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Account created\nsuccessfully!'**
  String get accountCreatedSuccessfully;

  /// No description provided for @signupSuccessSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Mshwar! Your account has been created successfully. Start booking rides now.'**
  String get signupSuccessSubtitle;

  /// No description provided for @startExploring.
  ///
  /// In en, this message translates to:
  /// **'Start exploring'**
  String get startExploring;

  /// No description provided for @skipForNow.
  ///
  /// In en, this message translates to:
  /// **'Skip for now'**
  String get skipForNow;

  /// No description provided for @pleaseWait.
  ///
  /// In en, this message translates to:
  /// **'Please wait'**
  String get pleaseWait;

  /// No description provided for @pleaseWaitDots.
  ///
  /// In en, this message translates to:
  /// **'Please wait...'**
  String get pleaseWaitDots;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again later'**
  String get somethingWentWrong;

  /// No description provided for @myProfile.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get myProfile;

  /// No description provided for @saveDetails.
  ///
  /// In en, this message translates to:
  /// **'Save details'**
  String get saveDetails;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @enterMobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter mobile number'**
  String get enterMobileNumber;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @emailNotValid.
  ///
  /// In en, this message translates to:
  /// **'Email not valid'**
  String get emailNotValid;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @tapToChangePhoto.
  ///
  /// In en, this message translates to:
  /// **'Tap to change photo'**
  String get tapToChangePhoto;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get deleteAccount;

  /// No description provided for @areYouSureDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete account?'**
  String get areYouSureDeleteAccount;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @changeInformation.
  ///
  /// In en, this message translates to:
  /// **'Change information'**
  String get changeInformation;

  /// No description provided for @chooseSource.
  ///
  /// In en, this message translates to:
  /// **'Choose source'**
  String get chooseSource;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @failedToPick.
  ///
  /// In en, this message translates to:
  /// **'Failed to pick'**
  String get failedToPick;

  /// No description provided for @rideManagement.
  ///
  /// In en, this message translates to:
  /// **'Ride Management'**
  String get rideManagement;

  /// No description provided for @allRides.
  ///
  /// In en, this message translates to:
  /// **'All rides'**
  String get allRides;

  /// No description provided for @scheduledRides.
  ///
  /// In en, this message translates to:
  /// **'Scheduled rides'**
  String get scheduledRides;

  /// No description provided for @accountPayments.
  ///
  /// In en, this message translates to:
  /// **'Account & Payments'**
  String get accountPayments;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get changePassword;

  /// No description provided for @appSettings.
  ///
  /// In en, this message translates to:
  /// **'App settings'**
  String get appSettings;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @termsConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get termsConditions;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy & Policy'**
  String get privacyPolicy;

  /// No description provided for @feedbackSupport.
  ///
  /// In en, this message translates to:
  /// **'Feedback & Support'**
  String get feedbackSupport;

  /// No description provided for @contactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact us'**
  String get contactUs;

  /// No description provided for @rateTheApp.
  ///
  /// In en, this message translates to:
  /// **'Rate the app'**
  String get rateTheApp;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark mode'**
  String get darkMode;

  /// No description provided for @areYouSureLogout.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get areYouSureLogout;

  /// No description provided for @serverError.
  ///
  /// In en, this message translates to:
  /// **'Server error. Please try again.'**
  String get serverError;

  /// No description provided for @connectionTimeout.
  ///
  /// In en, this message translates to:
  /// **'Connection timeout. Please check your internet connection.'**
  String get connectionTimeout;

  /// No description provided for @noInternetConnection.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Please check your network.'**
  String get noInternetConnection;

  /// No description provided for @invalidServerResponse.
  ///
  /// In en, this message translates to:
  /// **'Invalid server response. Please try again.'**
  String get invalidServerResponse;

  /// No description provided for @anErrorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred. Please try again.'**
  String get anErrorOccurred;

  /// No description provided for @unexpectedError.
  ///
  /// In en, this message translates to:
  /// **'Unexpected error. Please try again.'**
  String get unexpectedError;

  /// No description provided for @requestTimedOut.
  ///
  /// In en, this message translates to:
  /// **'Request timed out. Please try again.'**
  String get requestTimedOut;

  /// No description provided for @otpSentToEmail.
  ///
  /// In en, this message translates to:
  /// **'OTP has been sent to your email!'**
  String get otpSentToEmail;

  /// No description provided for @otpSent.
  ///
  /// In en, this message translates to:
  /// **'OTP sent'**
  String get otpSent;

  /// No description provided for @otpSentSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'OTP sent successfully'**
  String get otpSentSuccessfully;

  /// No description provided for @otpVerifiedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'OTP verified successfully'**
  String get otpVerifiedSuccessfully;

  /// No description provided for @failedToResendOtp.
  ///
  /// In en, this message translates to:
  /// **'Failed to resend OTP. Please try again.'**
  String get failedToResendOtp;

  /// No description provided for @invalidOtp.
  ///
  /// In en, this message translates to:
  /// **'Invalid OTP. Please try again.'**
  String get invalidOtp;

  /// No description provided for @invalidOtpOrRequestFailed.
  ///
  /// In en, this message translates to:
  /// **'Invalid OTP or request failed'**
  String get invalidOtpOrRequestFailed;

  /// No description provided for @emailNotFound.
  ///
  /// In en, this message translates to:
  /// **'Email not found or invalid request'**
  String get emailNotFound;

  /// No description provided for @failedToVerifyUser.
  ///
  /// In en, this message translates to:
  /// **'Failed to verify user'**
  String get failedToVerifyUser;

  /// No description provided for @unableToVerifyUser.
  ///
  /// In en, this message translates to:
  /// **'Unable to verify user. Please try again.'**
  String get unableToVerifyUser;

  /// No description provided for @failedToGetProfile.
  ///
  /// In en, this message translates to:
  /// **'Failed to get profile'**
  String get failedToGetProfile;

  /// No description provided for @unableToFetchProfile.
  ///
  /// In en, this message translates to:
  /// **'Unable to fetch profile. Please try again.'**
  String get unableToFetchProfile;

  /// No description provided for @invalidPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Invalid phone number'**
  String get invalidPhoneNumber;

  /// No description provided for @tooManyAttempts.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Please request OTP after some time'**
  String get tooManyAttempts;

  /// No description provided for @signInCancelled.
  ///
  /// In en, this message translates to:
  /// **'Sign in cancelled'**
  String get signInCancelled;

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change language'**
  String get changeLanguage;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select language'**
  String get selectLanguage;

  /// No description provided for @chooseLanguageDesc.
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred language to continue'**
  String get chooseLanguageDesc;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @skipDesc.
  ///
  /// In en, this message translates to:
  /// **'You can change your language anytime from settings'**
  String get skipDesc;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @continuee.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continuee;

  /// No description provided for @languageChangeSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Language changed successfully'**
  String get languageChangeSuccessfully;

  /// No description provided for @pressBackAgainToExit.
  ///
  /// In en, this message translates to:
  /// **'Press back again to exit'**
  String get pressBackAgainToExit;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logOut;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @ridesTitle.
  ///
  /// In en, this message translates to:
  /// **'Rides'**
  String get ridesTitle;

  /// No description provided for @subscriptions.
  ///
  /// In en, this message translates to:
  /// **'Subscriptions'**
  String get subscriptions;

  /// No description provided for @packages.
  ///
  /// In en, this message translates to:
  /// **'Packages'**
  String get packages;

  /// No description provided for @wallet.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get wallet;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @enterDestination.
  ///
  /// In en, this message translates to:
  /// **'Enter destination'**
  String get enterDestination;

  /// No description provided for @departure.
  ///
  /// In en, this message translates to:
  /// **'Departure'**
  String get departure;

  /// No description provided for @pickUpLocation.
  ///
  /// In en, this message translates to:
  /// **'Pick-up location'**
  String get pickUpLocation;

  /// No description provided for @destination.
  ///
  /// In en, this message translates to:
  /// **'Destination'**
  String get destination;

  /// No description provided for @whereYouWantToGo.
  ///
  /// In en, this message translates to:
  /// **'Where do you want to go?'**
  String get whereYouWantToGo;

  /// No description provided for @whereDoYouWantToStop.
  ///
  /// In en, this message translates to:
  /// **'Where do you want to stop?'**
  String get whereDoYouWantToStop;

  /// No description provided for @searchDestination.
  ///
  /// In en, this message translates to:
  /// **'Search destination'**
  String get searchDestination;

  /// No description provided for @pleaseEnterPickupAddress.
  ///
  /// In en, this message translates to:
  /// **'Please enter pickup address'**
  String get pleaseEnterPickupAddress;

  /// No description provided for @pleaseEnterDestinationAddress.
  ///
  /// In en, this message translates to:
  /// **'Please enter destination address'**
  String get pleaseEnterDestinationAddress;

  /// No description provided for @pleaseSelectVehicleType.
  ///
  /// In en, this message translates to:
  /// **'Please select vehicle type'**
  String get pleaseSelectVehicleType;

  /// No description provided for @classicRidesOnly.
  ///
  /// In en, this message translates to:
  /// **'Coming soon! ??\nCurrently we offer Classic rides only. Other vehicle types will be available soon!'**
  String get classicRidesOnly;

  /// No description provided for @unableToGetAddress.
  ///
  /// In en, this message translates to:
  /// **'Unable to get address information.'**
  String get unableToGetAddress;

  /// No description provided for @errorProcessingDestination.
  ///
  /// In en, this message translates to:
  /// **'Error processing destination'**
  String get errorProcessingDestination;

  /// No description provided for @paymentError.
  ///
  /// In en, this message translates to:
  /// **'Payment error'**
  String get paymentError;

  /// No description provided for @stop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get stop;

  /// No description provided for @selectPaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Select payment method'**
  String get selectPaymentMethod;

  /// No description provided for @totalAmount.
  ///
  /// In en, this message translates to:
  /// **'Total Amount'**
  String get totalAmount;

  /// No description provided for @discount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get discount;

  /// No description provided for @confirmPay.
  ///
  /// In en, this message translates to:
  /// **'Confirm & Pay'**
  String get confirmPay;

  /// No description provided for @cash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get cash;

  /// No description provided for @knetCreditCardOthers.
  ///
  /// In en, this message translates to:
  /// **'KNET, credit card & others'**
  String get knetCreditCardOthers;

  /// No description provided for @bookingConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Booking confirmed'**
  String get bookingConfirmed;

  /// No description provided for @bookingConfirmedExclamation.
  ///
  /// In en, this message translates to:
  /// **'Booking confirmed!'**
  String get bookingConfirmedExclamation;

  /// No description provided for @rideSuccessfullyBookedMessage.
  ///
  /// In en, this message translates to:
  /// **'Your ride has been successfully booked. Sit back and relax, your driver is on the way.'**
  String get rideSuccessfullyBookedMessage;

  /// No description provided for @trackRide.
  ///
  /// In en, this message translates to:
  /// **'Track ride'**
  String get trackRide;

  /// No description provided for @backToHome.
  ///
  /// In en, this message translates to:
  /// **'Back to home'**
  String get backToHome;

  /// No description provided for @walletBalance.
  ///
  /// In en, this message translates to:
  /// **'Wallet Balance'**
  String get walletBalance;

  /// No description provided for @transactionHistory.
  ///
  /// In en, this message translates to:
  /// **'Transaction history'**
  String get transactionHistory;

  /// No description provided for @transactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get transactions;

  /// No description provided for @transactionNotFound.
  ///
  /// In en, this message translates to:
  /// **'Transaction not found.'**
  String get transactionNotFound;

  /// No description provided for @topUpAmount.
  ///
  /// In en, this message translates to:
  /// **'Top up amount'**
  String get topUpAmount;

  /// No description provided for @addAmount.
  ///
  /// In en, this message translates to:
  /// **'Add amount'**
  String get addAmount;

  /// No description provided for @noNotifications.
  ///
  /// In en, this message translates to:
  /// **'No notifications'**
  String get noNotifications;

  /// No description provided for @youHaveNoNotificationsYet.
  ///
  /// In en, this message translates to:
  /// **'You have no notifications yet'**
  String get youHaveNoNotificationsYet;

  /// No description provided for @accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// No description provided for @decline.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get decline;

  /// No description provided for @permissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Permission denied'**
  String get permissionDenied;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @verificationCode.
  ///
  /// In en, this message translates to:
  /// **'Verification code'**
  String get verificationCode;

  /// No description provided for @confirmNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm new password'**
  String get confirmNewPassword;

  /// No description provided for @pleaseEnterVerificationCode.
  ///
  /// In en, this message translates to:
  /// **'Please enter verification code'**
  String get pleaseEnterVerificationCode;

  /// No description provided for @passwordResetSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Password reset successfully'**
  String get passwordResetSuccessfully;

  /// No description provided for @resetCodeSentSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Reset code sent successfully'**
  String get resetCodeSentSuccessfully;

  /// No description provided for @loginSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Login successful'**
  String get loginSuccessful;

  /// No description provided for @rememberYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Remember your password?'**
  String get rememberYourPassword;

  /// No description provided for @bookRide.
  ///
  /// In en, this message translates to:
  /// **'Book ride'**
  String get bookRide;

  /// No description provided for @whereToGo.
  ///
  /// In en, this message translates to:
  /// **'Where to go?'**
  String get whereToGo;

  /// No description provided for @pickupLocation.
  ///
  /// In en, this message translates to:
  /// **'Pickup location'**
  String get pickupLocation;

  /// No description provided for @dropoffLocation.
  ///
  /// In en, this message translates to:
  /// **'Dropoff location'**
  String get dropoffLocation;

  /// No description provided for @confirmLocation.
  ///
  /// In en, this message translates to:
  /// **'Confirm location'**
  String get confirmLocation;

  /// No description provided for @searchLocation.
  ///
  /// In en, this message translates to:
  /// **'Search Location'**
  String get searchLocation;

  /// No description provided for @useCurrentLocation.
  ///
  /// In en, this message translates to:
  /// **'Use current location'**
  String get useCurrentLocation;

  /// No description provided for @noResultsFound.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResultsFound;

  /// No description provided for @selectVehicle.
  ///
  /// In en, this message translates to:
  /// **'Select vehicle'**
  String get selectVehicle;

  /// No description provided for @vehicle.
  ///
  /// In en, this message translates to:
  /// **'Vehicle'**
  String get vehicle;

  /// No description provided for @passengers.
  ///
  /// In en, this message translates to:
  /// **'Passengers'**
  String get passengers;

  /// No description provided for @change.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get change;

  /// No description provided for @numberOfPassengers.
  ///
  /// In en, this message translates to:
  /// **'Number of passengers'**
  String get numberOfPassengers;

  /// No description provided for @scheduleRide.
  ///
  /// In en, this message translates to:
  /// **'Schedule ride'**
  String get scheduleRide;

  /// No description provided for @scheduledFor.
  ///
  /// In en, this message translates to:
  /// **'Scheduled for'**
  String get scheduledFor;

  /// No description provided for @continueToPayment.
  ///
  /// In en, this message translates to:
  /// **'Continue to payment'**
  String get continueToPayment;

  /// No description provided for @pleaseSelectVehicle.
  ///
  /// In en, this message translates to:
  /// **'Please select a vehicle'**
  String get pleaseSelectVehicle;

  /// No description provided for @paymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment method'**
  String get paymentMethod;

  /// No description provided for @totalFare.
  ///
  /// In en, this message translates to:
  /// **'Total fare'**
  String get totalFare;

  /// No description provided for @confirmBooking.
  ///
  /// In en, this message translates to:
  /// **'Confirm booking'**
  String get confirmBooking;

  /// No description provided for @pleaseSelectPaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Please select a payment method'**
  String get pleaseSelectPaymentMethod;

  /// No description provided for @yourRideHasBeenBooked.
  ///
  /// In en, this message translates to:
  /// **'Your ride has been booked successfully'**
  String get yourRideHasBeenBooked;

  /// No description provided for @bookingId.
  ///
  /// In en, this message translates to:
  /// **'Booking ID'**
  String get bookingId;

  /// No description provided for @estimatedArrival.
  ///
  /// In en, this message translates to:
  /// **'Estimated arrival'**
  String get estimatedArrival;

  /// No description provided for @otp.
  ///
  /// In en, this message translates to:
  /// **'OTP'**
  String get otp;

  /// No description provided for @driverDetails.
  ///
  /// In en, this message translates to:
  /// **'Driver details'**
  String get driverDetails;

  /// No description provided for @rides.
  ///
  /// In en, this message translates to:
  /// **'rides'**
  String get rides;

  /// No description provided for @priceSummary.
  ///
  /// In en, this message translates to:
  /// **'Price Summary'**
  String get priceSummary;

  /// No description provided for @basePrice.
  ///
  /// In en, this message translates to:
  /// **'Base price'**
  String get basePrice;

  /// No description provided for @distancePrice.
  ///
  /// In en, this message translates to:
  /// **'Distance price'**
  String get distancePrice;

  /// No description provided for @timePrice.
  ///
  /// In en, this message translates to:
  /// **'Time price'**
  String get timePrice;

  /// No description provided for @packageDiscount.
  ///
  /// In en, this message translates to:
  /// **'Package discount'**
  String get packageDiscount;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @pickup.
  ///
  /// In en, this message translates to:
  /// **'Pickup'**
  String get pickup;

  /// No description provided for @dropoff.
  ///
  /// In en, this message translates to:
  /// **'Dropoff'**
  String get dropoff;

  /// No description provided for @stops.
  ///
  /// In en, this message translates to:
  /// **'Stops'**
  String get stops;

  /// No description provided for @addStop.
  ///
  /// In en, this message translates to:
  /// **'Add Stop'**
  String get addStop;

  /// No description provided for @removeStop.
  ///
  /// In en, this message translates to:
  /// **'Remove Stop'**
  String get removeStop;

  /// No description provided for @noStopsAdded.
  ///
  /// In en, this message translates to:
  /// **'No stops added yet'**
  String get noStopsAdded;

  /// No description provided for @enterLocation.
  ///
  /// In en, this message translates to:
  /// **'Enter location'**
  String get enterLocation;

  /// No description provided for @usePackageKm.
  ///
  /// In en, this message translates to:
  /// **'Use Package KM'**
  String get usePackageKm;

  /// No description provided for @packageKmAvailable.
  ///
  /// In en, this message translates to:
  /// **'Package KM Available'**
  String get packageKmAvailable;

  /// No description provided for @packageKmToUse.
  ///
  /// In en, this message translates to:
  /// **'Package KM to Use'**
  String get packageKmToUse;

  /// No description provided for @packageKmRemaining.
  ///
  /// In en, this message translates to:
  /// **'Remaining KM'**
  String get packageKmRemaining;

  /// No description provided for @packageKmDiscountInfo.
  ///
  /// In en, this message translates to:
  /// **'Your package KM will be used for this ride'**
  String get packageKmDiscountInfo;

  /// No description provided for @haveCouponCode.
  ///
  /// In en, this message translates to:
  /// **'Have a Coupon Code?'**
  String get haveCouponCode;

  /// No description provided for @enterCouponCode.
  ///
  /// In en, this message translates to:
  /// **'Enter Coupon Code'**
  String get enterCouponCode;

  /// No description provided for @applyCoupon.
  ///
  /// In en, this message translates to:
  /// **'Apply Coupon'**
  String get applyCoupon;

  /// No description provided for @removeCoupon.
  ///
  /// In en, this message translates to:
  /// **'Remove Coupon'**
  String get removeCoupon;

  /// No description provided for @couponApplied.
  ///
  /// In en, this message translates to:
  /// **'Coupon Applied'**
  String get couponApplied;

  /// No description provided for @couponDiscount.
  ///
  /// In en, this message translates to:
  /// **'Coupon Discount'**
  String get couponDiscount;

  /// No description provided for @invalidCoupon.
  ///
  /// In en, this message translates to:
  /// **'Invalid Coupon Code'**
  String get invalidCoupon;

  /// No description provided for @couponCodeRemoved.
  ///
  /// In en, this message translates to:
  /// **'Coupon code removed'**
  String get couponCodeRemoved;

  /// No description provided for @insufficientBalance.
  ///
  /// In en, this message translates to:
  /// **'Insufficient Wallet Balance'**
  String get insufficientBalance;

  /// No description provided for @addFunds.
  ///
  /// In en, this message translates to:
  /// **'Add Funds to Wallet'**
  String get addFunds;

  /// No description provided for @pendingPayment.
  ///
  /// In en, this message translates to:
  /// **'Pending Payment'**
  String get pendingPayment;

  /// No description provided for @pendingPaymentMessage.
  ///
  /// In en, this message translates to:
  /// **'You have a pending payment. Please complete it to continue booking rides.'**
  String get pendingPaymentMessage;

  /// No description provided for @amountDue.
  ///
  /// In en, this message translates to:
  /// **'Amount Due'**
  String get amountDue;

  /// No description provided for @payNow.
  ///
  /// In en, this message translates to:
  /// **'Pay Now'**
  String get payNow;

  /// No description provided for @later.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get later;

  /// No description provided for @buyPackages.
  ///
  /// In en, this message translates to:
  /// **'Buy Packages'**
  String get buyPackages;

  /// No description provided for @myPackages.
  ///
  /// In en, this message translates to:
  /// **'My Packages'**
  String get myPackages;

  /// No description provided for @noPackagesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No Packages Available'**
  String get noPackagesAvailable;

  /// No description provided for @noPackagesAvailableDesc.
  ///
  /// In en, this message translates to:
  /// **'There are no KM packages available for purchase at the moment.'**
  String get noPackagesAvailableDesc;

  /// No description provided for @noPackagesPurchased.
  ///
  /// In en, this message translates to:
  /// **'No Packages Purchased'**
  String get noPackagesPurchased;

  /// No description provided for @noPackagesPurchasedDesc.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t purchased any KM packages yet. Buy one to save on your rides!'**
  String get noPackagesPurchasedDesc;

  /// No description provided for @buyMorePackages.
  ///
  /// In en, this message translates to:
  /// **'Buy More Packages'**
  String get buyMorePackages;

  /// No description provided for @buyMorePackagesDesc.
  ///
  /// In en, this message translates to:
  /// **'You can buy the same package multiple times!'**
  String get buyMorePackagesDesc;

  /// No description provided for @availableKm.
  ///
  /// In en, this message translates to:
  /// **'Available KM'**
  String get availableKm;

  /// No description provided for @usedKm.
  ///
  /// In en, this message translates to:
  /// **'Used KM'**
  String get usedKm;

  /// No description provided for @totalKm.
  ///
  /// In en, this message translates to:
  /// **'Total KM'**
  String get totalKm;

  /// No description provided for @remaining.
  ///
  /// In en, this message translates to:
  /// **'remaining'**
  String get remaining;

  /// No description provided for @used.
  ///
  /// In en, this message translates to:
  /// **'used'**
  String get used;

  /// No description provided for @purchased.
  ///
  /// In en, this message translates to:
  /// **'Purchased'**
  String get purchased;

  /// No description provided for @purchasePackage.
  ///
  /// In en, this message translates to:
  /// **'Purchase Package'**
  String get purchasePackage;

  /// No description provided for @totalKilometers.
  ///
  /// In en, this message translates to:
  /// **'Total Kilometers'**
  String get totalKilometers;

  /// No description provided for @pricePerKm.
  ///
  /// In en, this message translates to:
  /// **'Price per KM'**
  String get pricePerKm;

  /// No description provided for @proceedToPayment.
  ///
  /// In en, this message translates to:
  /// **'Proceed to Payment'**
  String get proceedToPayment;

  /// No description provided for @invalidPackagePrice.
  ///
  /// In en, this message translates to:
  /// **'Invalid package price'**
  String get invalidPackagePrice;

  /// No description provided for @packagePrice.
  ///
  /// In en, this message translates to:
  /// **'Package Price'**
  String get packagePrice;

  /// No description provided for @packagePurchaseInitiated.
  ///
  /// In en, this message translates to:
  /// **'Package purchase initiated'**
  String get packagePurchaseInitiated;

  /// No description provided for @packagePurchasedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Package purchased successfully!'**
  String get packagePurchasedSuccessfully;

  /// No description provided for @noSubscriptionsYet.
  ///
  /// In en, this message translates to:
  /// **'No Subscriptions Yet'**
  String get noSubscriptionsYet;

  /// No description provided for @noSubscriptionsYetDesc.
  ///
  /// In en, this message translates to:
  /// **'Create your first ride subscription for regular commutes'**
  String get noSubscriptionsYetDesc;

  /// No description provided for @subscriptionsNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Subscriptions Not Available'**
  String get subscriptionsNotAvailable;

  /// No description provided for @subscriptionsNotAvailableDesc.
  ///
  /// In en, this message translates to:
  /// **'Subscription service is not available at the moment. Please check back later.'**
  String get subscriptionsNotAvailableDesc;

  /// No description provided for @distance.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get distance;

  /// No description provided for @trips.
  ///
  /// In en, this message translates to:
  /// **'Trips'**
  String get trips;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @buyNow.
  ///
  /// In en, this message translates to:
  /// **'Buy Now'**
  String get buyNow;

  /// No description provided for @totalPrice.
  ///
  /// In en, this message translates to:
  /// **'Total Price'**
  String get totalPrice;

  /// No description provided for @walletPaymentNotImplemented.
  ///
  /// In en, this message translates to:
  /// **'Wallet payment not implemented yet'**
  String get walletPaymentNotImplemented;

  /// No description provided for @knetPaymentNotImplemented.
  ///
  /// In en, this message translates to:
  /// **'KNET payment not implemented yet'**
  String get knetPaymentNotImplemented;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'ur'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'ur':
      return AppLocalizationsUr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
