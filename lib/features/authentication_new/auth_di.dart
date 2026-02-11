/// Authentication Feature Dependency Injection
/// 
/// This file serves as a wrapper for the authentication feature's dependency injection.
/// It exports the main service locator for easy access throughout the app.
/// 
/// Usage:
/// ```dart
/// import 'package:cabme/features/authentication_new/auth_di.dart';
/// 
/// // In main.dart or app initialization
/// setupAuthDependencies();
/// 
/// // In widgets
/// final loginCubit = getIt<LoginCubit>();
/// ```

export 'di/auth_service_locator.dart';
