import 'package:cabme/core(new)/network/api_service.dart';
import 'package:cabme/core(new)/network/app_state_service.dart';
import 'package:cabme/core/utils/Preferences.dart';
import 'package:cabme/features/ride_new/di/ride_service_locator.dart';
import 'package:cabme/features/settings_new/di/settings_service_locator.dart';
import 'package:cabme/features/authentication_new/di/auth_service_locator.dart';
import 'package:cabme/features/home_new/di/home_service_locator.dart';
import 'package:cabme/features/payment_new/di/payment_service_locator.dart';
import 'package:cabme/features/plans_new/di/plans_service_locator.dart';
import 'package:cabme/core(new)/network/dio_client.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupAllDependencies() {
  // Core services
  if (!getIt.isRegistered<DioClient>()) {
    getIt.registerLazySingleton<DioClient>(() => DioClient.instance);
  }

  if (!getIt.isRegistered<ApiService>()) {
    getIt.registerLazySingleton<ApiService>(() => ApiService());
  }

  if (!getIt.isRegistered<AppStateService>()) {
    getIt.registerLazySingleton<AppStateService>(
        () => AppStateService(Preferences.pref));
  }

  // Features
  setupAuthDependencies();
  setupHomeDependencies();
  setupPaymentDependencies();
  setupPlansDependencies();
  setupRideDependencies();
  setupSettingsDependencies();
}
