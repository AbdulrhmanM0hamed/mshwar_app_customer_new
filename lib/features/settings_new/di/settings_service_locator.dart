import 'package:cabme/core(new)/network/api_service.dart';
import 'package:cabme/features/settings_new/data/repositories/settings_repository.dart';
import 'package:cabme/features/settings_new/data/repositories/notification_repository.dart';
import 'package:cabme/features/settings_new/presentation/cubit/profile/profile_cubit.dart';
import 'package:cabme/features/settings_new/presentation/cubit/settings/settings_cubit.dart';
import 'package:cabme/features/settings_new/presentation/cubit/contact_us/contact_us_cubit.dart';
import 'package:cabme/features/settings_new/presentation/cubit/notification/notification_cubit.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupSettingsDependencies() {
  _registerRepositories();
  _registerCubits();
}

void _registerRepositories() {
  if (!getIt.isRegistered<SettingsRepository>()) {
    getIt.registerLazySingleton<SettingsRepository>(
      () => SettingsRepositoryImpl(
        apiService: getIt<ApiService>(),
      ),
    );
  }

  if (!getIt.isRegistered<NotificationRepository>()) {
    getIt.registerLazySingleton<NotificationRepository>(
      () => NotificationRepositoryImpl(
        apiService: getIt<ApiService>(),
      ),
    );
  }
}

void _registerCubits() {
  if (!getIt.isRegistered<SettingsCubit>()) {
    getIt.registerFactory<SettingsCubit>(
      () => SettingsCubit(
        repository: getIt<SettingsRepository>(),
      ),
    );
  }

  if (!getIt.isRegistered<ProfileCubit>()) {
    getIt.registerFactory<ProfileCubit>(
      () => ProfileCubit(
        repository: getIt<SettingsRepository>(),
      ),
    );
  }

  if (!getIt.isRegistered<ContactUsCubit>()) {
    getIt.registerFactory<ContactUsCubit>(
      () => ContactUsCubit(
        repository: getIt<SettingsRepository>(),
      ),
    );
  }

  if (!getIt.isRegistered<NotificationCubit>()) {
    getIt.registerFactory<NotificationCubit>(
      () => NotificationCubit(
        repository: getIt<NotificationRepository>(),
      ),
    );
  }
}
