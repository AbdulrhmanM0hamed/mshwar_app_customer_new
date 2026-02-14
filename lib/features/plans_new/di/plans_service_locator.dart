import '../../../core(new)/network/app_state_service.dart';
import '../../../service_locator.dart';
import '../../../core(new)/network/api_service.dart';
import '../data/repositories/package_repository.dart';
import '../data/repositories/subscription_repository.dart';
import '../data/repositories/coupon_repository.dart';
import '../presentation/cubit/package/package_cubit.dart';
import '../presentation/cubit/subscription/subscription_cubit.dart';
import '../presentation/cubit/coupon/coupon_cubit.dart';

/// Setup all dependencies for Plans feature
/// Call this in main.dart after core dependencies are registered
void setupPlansDependencies() {
  _registerRepositories();
  _registerCubits();
}

/// Register all repositories
void _registerRepositories() {
  // Package Repository
  if (!getIt.isRegistered<PackageRepository>()) {
    getIt.registerLazySingleton<PackageRepository>(
      () => PackageRepositoryImpl(
        apiService: getIt<ApiService>(),
        appStateService: getIt<AppStateService>(),
      ),
    );
  }

  // Subscription Repository
  if (!getIt.isRegistered<SubscriptionRepository>()) {
    getIt.registerLazySingleton<SubscriptionRepository>(
      () => SubscriptionRepositoryImpl(
        apiService: getIt<ApiService>(),
        appStateService: getIt<AppStateService>(),
      ),
    );
  }

  // Coupon Repository
  if (!getIt.isRegistered<PlansCouponRepository>()) {
    getIt.registerLazySingleton<PlansCouponRepository>(
      () => PlansCouponRepositoryImpl(
        apiService: getIt<ApiService>(),
      ),
    );
  }
}

/// Register all Cubits (Factory - new instance each time)
void _registerCubits() {
  // Package Cubit
  if (!getIt.isRegistered<PackageCubit>()) {
    getIt.registerFactory<PackageCubit>(
      () => PackageCubit(
        repository: getIt<PackageRepository>(),
      ),
    );
  }

  // Subscription Cubit
  if (!getIt.isRegistered<SubscriptionCubit>()) {
    getIt.registerFactory<SubscriptionCubit>(
      () => SubscriptionCubit(
        repository: getIt<SubscriptionRepository>(),
      ),
    );
  }

  // Coupon Cubit
  if (!getIt.isRegistered<PlansCouponCubit>()) {
    getIt.registerFactory<PlansCouponCubit>(
      () => PlansCouponCubit(
        repository: getIt<PlansCouponRepository>(),
      ),
    );
  }
}

/// Unregister all plans dependencies (useful for testing)
void unregisterPlansDependencies() {
  // Unregister Cubits
  if (getIt.isRegistered<PackageCubit>()) {
    getIt.unregister<PackageCubit>();
  }
  if (getIt.isRegistered<SubscriptionCubit>()) {
    getIt.unregister<SubscriptionCubit>();
  }
  if (getIt.isRegistered<PlansCouponCubit>()) {
    getIt.unregister<PlansCouponCubit>();
  }

  // Unregister Repositories
  if (getIt.isRegistered<PackageRepository>()) {
    getIt.unregister<PackageRepository>();
  }
  if (getIt.isRegistered<SubscriptionRepository>()) {
    getIt.unregister<SubscriptionRepository>();
  }
  if (getIt.isRegistered<PlansCouponRepository>()) {
    getIt.unregister<PlansCouponRepository>();
  }
}
