import '../../../service_locator.dart';
import '../../../core(new)/network/api_service.dart';
import '../data/repositories/payment_repository.dart';
import '../data/repositories/wallet_repository.dart';
import '../data/repositories/coupon_repository.dart';
import '../presentation/cubit/payment/payment_cubit.dart';
import '../presentation/cubit/wallet/wallet_cubit.dart';
import '../presentation/cubit/coupon/coupon_cubit.dart';

/// Setup all dependencies for Payment feature
/// Call this in main.dart after core dependencies are registered
void setupPaymentDependencies() {
  _registerRepositories();
  _registerCubits();
}

/// Register all repositories
void _registerRepositories() {
  // Payment Repository
  if (!getIt.isRegistered<PaymentRepository>()) {
    getIt.registerLazySingleton<PaymentRepository>(
      () => PaymentRepositoryImpl(
        apiService: getIt<ApiService>(),
      ),
    );
  }

  // Wallet Repository
  if (!getIt.isRegistered<WalletRepository>()) {
    getIt.registerLazySingleton<WalletRepository>(
      () => WalletRepositoryImpl(
        apiService: getIt<ApiService>(),
      ),
    );
  }

  // Coupon Repository
  if (!getIt.isRegistered<CouponRepository>()) {
    getIt.registerLazySingleton<CouponRepository>(
      () => CouponRepositoryImpl(
        apiService: getIt<ApiService>(),
      ),
    );
  }
}

/// Register all Cubits (Factory - new instance each time)
void _registerCubits() {
  // Payment Cubit
  if (!getIt.isRegistered<PaymentCubit>()) {
    getIt.registerFactory<PaymentCubit>(
      () => PaymentCubit(
        repository: getIt<PaymentRepository>(),
      ),
    );
  }

  // Wallet Cubit
  if (!getIt.isRegistered<WalletCubit>()) {
    getIt.registerFactory<WalletCubit>(
      () => WalletCubit(
        repository: getIt<WalletRepository>(),
      ),
    );
  }

  // Coupon Cubit
  if (!getIt.isRegistered<CouponCubit>()) {
    getIt.registerFactory<CouponCubit>(
      () => CouponCubit(
        repository: getIt<CouponRepository>(),
      ),
    );
  }
}

/// Unregister all payment dependencies (useful for testing)
void unregisterPaymentDependencies() {
  // Unregister Cubits
  if (getIt.isRegistered<PaymentCubit>()) {
    getIt.unregister<PaymentCubit>();
  }
  if (getIt.isRegistered<WalletCubit>()) {
    getIt.unregister<WalletCubit>();
  }
  if (getIt.isRegistered<CouponCubit>()) {
    getIt.unregister<CouponCubit>();
  }

  // Unregister Repositories
  if (getIt.isRegistered<PaymentRepository>()) {
    getIt.unregister<PaymentRepository>();
  }
  if (getIt.isRegistered<WalletRepository>()) {
    getIt.unregister<WalletRepository>();
  }
  if (getIt.isRegistered<CouponRepository>()) {
    getIt.unregister<CouponRepository>();
  }
}
