import 'package:cabme/core(new)/network/api_service.dart';
import 'package:cabme/features/ride_new/di/ride_service_locator.dart';
import 'package:cabme/features/settings_new/di/settings_service_locator.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupAllDependencies() {
  // Core services
  if (!getIt.isRegistered<ApiService>()) {
    getIt.registerLazySingleton<ApiService>(() => ApiService());
  }

  // Features
  setupRideDependencies();
  setupSettingsDependencies();
}
