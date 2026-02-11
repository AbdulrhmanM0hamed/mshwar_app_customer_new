/// Payment Feature Dependency Injection
/// 
/// This file serves as a wrapper for the payment feature's dependency injection.
/// It exports the main service locator for easy access throughout the app.
/// 
/// Usage:
/// ```dart
/// import 'package:cabme/features/payment_new/payment_di.dart';
/// 
/// // In main.dart or app initialization
/// setupPaymentDependencies();
/// 
/// // In widgets
/// final paymentCubit = getIt<PaymentCubit>();
/// ```

export 'di/payment_service_locator.dart';
