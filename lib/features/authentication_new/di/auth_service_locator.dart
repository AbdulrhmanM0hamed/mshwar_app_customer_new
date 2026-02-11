import 'package:get_it/get_it.dart';
import '../../../core(new)/network/api_service.dart';
import '../../../core(new)/network/app_state_service.dart';
import '../data/repositories/auth_repository.dart';
import '../presentation/cubit/login/login_cubit.dart';
import '../presentation/cubit/register/register_cubit.dart';
import '../presentation/cubit/otp/otp_cubit.dart';

final getIt = GetIt.instance;

/// Setup all dependencies for Authentication feature
/// Call this in main.dart after core dependencies are registered
void setupAuthDependencies() {
  _registerRepositories();
  _registerCubits();
}

/// Register all repositories
void _registerRepositories() {
  // Auth Repository
  if (!getIt.isRegistered<AuthRepository>()) {
    getIt.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        getIt<ApiService>(),
        getIt<AppStateService>(),
      ),
    );
  }
}

/// Register all Cubits (Factory - new instance each time)
void _registerCubits() {
  // Login Cubit
  if (!getIt.isRegistered<LoginCubit>()) {
    getIt.registerFactory<LoginCubit>(
      () => LoginCubit(getIt<AuthRepository>()),
    );
  }

  // Register Cubit
  if (!getIt.isRegistered<RegisterCubit>()) {
    getIt.registerFactory<RegisterCubit>(
      () => RegisterCubit(getIt<AuthRepository>()),
    );
  }

  // OTP Cubit
  if (!getIt.isRegistered<OtpCubit>()) {
    getIt.registerFactory<OtpCubit>(
      () => OtpCubit(getIt<AuthRepository>()),
    );
  }
}

/// Unregister all auth dependencies (useful for testing)
void unregisterAuthDependencies() {
  // Unregister Cubits
  if (getIt.isRegistered<LoginCubit>()) {
    getIt.unregister<LoginCubit>();
  }
  if (getIt.isRegistered<RegisterCubit>()) {
    getIt.unregister<RegisterCubit>();
  }
  if (getIt.isRegistered<OtpCubit>()) {
    getIt.unregister<OtpCubit>();
  }

  // Unregister Repositories
  if (getIt.isRegistered<AuthRepository>()) {
    getIt.unregister<AuthRepository>();
  }
}
