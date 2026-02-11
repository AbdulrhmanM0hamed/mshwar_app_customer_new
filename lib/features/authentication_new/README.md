# Authentication Feature - Clean Architecture

## 📁 Structure

```
authentication_new/
├── data/
│   ├── models/                    # Data models with JSON serialization
│   │   ├── user_model.dart
│   │   ├── login_request.dart
│   │   ├── login_response.dart
│   │   ├── register_request.dart
│   │   ├── register_response.dart
│   │   ├── otp_request.dart
│   │   ├── otp_response.dart
│   │   ├── phone_check_request.dart
│   │   └── forgot_password_request.dart
│   └── repositories/              # Data layer - API communication
│       └── auth_repository.dart
├── presentation/
│   ├── cubit/                     # State management
│   │   ├── login/
│   │   │   ├── login_cubit.dart
│   │   │   └── login_state.dart
│   │   ├── register/
│   │   │   ├── register_cubit.dart
│   │   │   └── register_state.dart
│   │   └── otp/
│   │       ├── otp_cubit.dart
│   │       └── otp_state.dart
│   ├── pages/                     # Full screen pages
│   │   ├── login_page.dart
│   │   ├── register_page.dart
│   │   ├── otp_page.dart
│   │   ├── phone_auth_page.dart
│   │   ├── forgot_password_page.dart
│   │   ├── reset_password_page.dart
│   │   └── signup_success_page.dart
│   └── widgets/                   # Reusable widgets
│       ├── auth_screen_layout.dart
│       └── auth_bottom_link.dart
├── di/
│   └── auth_service_locator.dart  # Dependency injection setup
├── auth_di.dart                   # DI export wrapper
└── README.md                      # This file
```

## 🚀 Features

### Authentication Management
- Email/Password login
- Phone number authentication
- OTP verification
- User registration
- Password reset
- Social login support (Google, Apple)
- Session management
- Token refresh

### User Management
- User profile data
- Save/load user data
- Logout functionality
- User preferences

## 📦 Models

### UserModel
```dart
- id: String
- fullName: String
- email: String
- phone: String
- profilePic: String?
- accessToken: String?
- adminCommission: String?
- userCat: String
```

### LoginRequest
```dart
- email: String
- password: String
- userCat: String
```

### RegisterRequest
```dart
- fullName: String
- email: String
- phone: String
- password: String
- confirmPassword: String
- userCat: String
```

### OtpRequest
```dart
- phone: String
- otp: String
```

## 🎯 Usage

### 1. Setup Dependencies

In `main.dart`:
```dart
import 'package:cabme/features/authentication_new/auth_di.dart';

void main() async {
  // ... other setup
  
  // Setup auth dependencies
  setupAuthDependencies();
  
  runApp(MyApp());
}
```

### 2. Use Login Page

```dart
import 'package:cabme/features/authentication_new/presentation/pages/login_page.dart';

// Navigate to login
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => BlocProvider(
      create: (context) => getIt<LoginCubit>(),
      child: const LoginPage(),
    ),
  ),
);
```

### 3. Use Register Page

```dart
import 'package:cabme/features/authentication_new/presentation/pages/register_page.dart';

// Navigate to register
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => BlocProvider(
      create: (context) => getIt<RegisterCubit>(),
      child: const RegisterPage(),
    ),
  ),
);
```

### 4. Login with Email/Password

```dart
import 'package:cabme/features/authentication_new/presentation/cubit/login/login_cubit.dart';

// In your widget
final loginCubit = context.read<LoginCubit>();

// Login
loginCubit.login(
  email: 'user@example.com',
  password: 'password123',
);

// Listen to state
BlocListener<LoginCubit, LoginState>(
  listener: (context, state) {
    if (state is LoginSuccess) {
      // Navigate to home
    } else if (state is LoginError) {
      // Show error
    }
  },
  child: YourWidget(),
)
```

### 5. Phone Authentication

```dart
import 'package:cabme/features/authentication_new/presentation/cubit/login/login_cubit.dart';

// Check if phone exists
loginCubit.checkPhoneExists('+1234567890');

// Get user by phone
loginCubit.getUserByPhone('+1234567890');
```

### 6. OTP Verification

```dart
import 'package:cabme/features/authentication_new/presentation/cubit/otp/otp_cubit.dart';

// Send OTP
otpCubit.sendOtp('+1234567890');

// Verify OTP
otpCubit.verifyOtp(
  phone: '+1234567890',
  otp: '123456',
);

// Resend OTP
otpCubit.resendOtp('+1234567890');
```

## 🔄 State Management

### Login States
- LoginInitial
- LoginLoading
- LoginSuccess
- LoginError
- PhoneCheckLoading
- PhoneExists
- PhoneNotExists
- PhoneCheckError
- UserByPhoneLoading
- UserByPhoneSuccess
- UserByPhoneError

### Register States
- RegisterInitial
- RegisterLoading
- RegisterSuccess
- RegisterError

### OTP States
- OtpInitial
- OtpSending
- OtpSent
- OtpSendError
- OtpVerifying
- OtpVerified
- OtpVerificationError
- OtpResending
- OtpResent
- OtpResendError

## 🌐 API Endpoints

### Authentication
- `POST /user-login` - Login with email/password
- `POST /user-signup` - Register new user
- `POST /get-existing-user-or-not` - Check if phone exists
- `POST /get-profile-by-phone` - Get user by phone

### OTP
- `POST /send-otp` - Send OTP to phone
- `POST /verify-otp` - Verify OTP code
- `POST /resend-otp` - Resend OTP

### Password Reset
- `POST /send-reset-password-otp` - Send reset password OTP
- `POST /reset-password-otp` - Reset password with OTP

## 🎯 Best Practices

1. **Always use BlocProvider** when navigating to auth pages
2. **Handle all auth states** in your UI
3. **Show loading indicators** during API calls
4. **Display error messages** to users
5. **Validate input** before submission
6. **Save user data** after successful login/register
7. **Clear user data** on logout

## 🔒 Security

- Passwords are transmitted securely via HTTPS
- Tokens are stored securely using SharedPreferences
- User authentication required for protected routes
- OTP verification for phone authentication
- Password reset via OTP

## 📱 Supported Authentication Methods

1. **Email/Password** - Traditional login
2. **Phone/OTP** - Phone number with OTP verification
3. **Social Login** - Google and Apple (UI ready)

## 🌍 Localization

All text is localized using `AppLocalizations`:
- English (en_US)
- Arabic (ar_AE) with RTL support
- Urdu (ur_PK) with RTL support

## 🎨 Theme Support

- Full dark mode support
- Uses `AppThemeData` colors
- Responsive design
- RTL layout support

## ✅ Testing

```dart
// Example test
test('Login repository authenticates user successfully', () async {
  final repository = AuthRepositoryImpl(mockApiService, mockAppStateService);
  final request = LoginRequest(...);
  
  final result = await repository.login(request);
  
  expect(result.isSuccess, true);
});
```

## 📝 Notes

- Repository uses `ApiResult` pattern for error handling
- All models have full null safety
- All models have `fromJson`, `toJson`, and `copyWith` methods
- User data is saved to both Preferences and AppStateService
- Tokens are automatically added to API headers

## 🔄 Migration from Old Authentication

If migrating from old authentication feature:
1. Update imports to use `authentication_new`
2. Replace GetX controllers with Cubits
3. Update state handling from GetX to Bloc
4. Use new models with proper null safety
5. Update API endpoints to new format

## 📚 Dependencies

- `flutter_bloc` - State management
- `get_it` - Dependency injection
- `shared_preferences` - Local storage
- `provider` - Theme management

---

**Last Updated**: Now
**Status**: ✅ Complete - Ready for production
**Compilation**: ✅ 0 Errors
