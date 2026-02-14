import '../../../core(new)/network/app_state_service.dart';
import '../../../service_locator.dart';
import '../../../core(new)/network/api_service.dart';
import '../data/repositories/ride_repository.dart';
import '../data/repositories/chat_repository.dart';
import '../data/repositories/review_repository.dart';
import '../data/repositories/complaint_repository.dart';
import '../presentation/cubit/active_ride/active_ride_cubit.dart';
import '../presentation/cubit/ride_history/ride_history_cubit.dart';
import '../presentation/cubit/chat/chat_cubit.dart';
import '../presentation/cubit/review/review_cubit.dart';
import '../presentation/cubit/complaint/complaint_cubit.dart';

/// Setup all dependencies for Ride feature
/// Call this in main.dart after core dependencies are registered
void setupRideDependencies() {
  _registerRepositories();
  _registerCubits();
}

/// Register all repositories
void _registerRepositories() {
  // Ride Repository
  if (!getIt.isRegistered<RideRepository>()) {
    getIt.registerLazySingleton<RideRepository>(
      () => RideRepositoryImpl(
        apiService: getIt<ApiService>(),
        appStateService: getIt<AppStateService>(),
      ),
    );
  }

  // Chat Repository
  if (!getIt.isRegistered<ChatRepository>()) {
    getIt.registerLazySingleton<ChatRepository>(
      () => ChatRepositoryImpl(
        apiService: getIt<ApiService>(),
      ),
    );
  }

  // Review Repository
  if (!getIt.isRegistered<ReviewRepository>()) {
    getIt.registerLazySingleton<ReviewRepository>(
      () => ReviewRepositoryImpl(
        apiService: getIt<ApiService>(),
      ),
    );
  }

  // Complaint Repository
  if (!getIt.isRegistered<ComplaintRepository>()) {
    getIt.registerLazySingleton<ComplaintRepository>(
      () => ComplaintRepositoryImpl(
        apiService: getIt<ApiService>(),
      ),
    );
  }
}

/// Register all Cubits (Factory - new instance each time)
void _registerCubits() {
  // Active Ride Cubit
  if (!getIt.isRegistered<ActiveRideCubit>()) {
    getIt.registerFactory<ActiveRideCubit>(
      () => ActiveRideCubit(
        repository: getIt<RideRepository>(),
      ),
    );
  }

  // Ride History Cubit
  if (!getIt.isRegistered<RideHistoryCubit>()) {
    getIt.registerFactory<RideHistoryCubit>(
      () => RideHistoryCubit(
        repository: getIt<RideRepository>(),
      ),
    );
  }

  // Chat Cubit
  if (!getIt.isRegistered<ChatCubit>()) {
    getIt.registerFactory<ChatCubit>(
      () => ChatCubit(
        repository: getIt<ChatRepository>(),
      ),
    );
  }

  // Review Cubit
  if (!getIt.isRegistered<ReviewCubit>()) {
    getIt.registerFactory<ReviewCubit>(
      () => ReviewCubit(
        repository: getIt<ReviewRepository>(),
      ),
    );
  }

  // Complaint Cubit
  if (!getIt.isRegistered<ComplaintCubit>()) {
    getIt.registerFactory<ComplaintCubit>(
      () => ComplaintCubit(
        repository: getIt<ComplaintRepository>(),
      ),
    );
  }
}

/// Unregister all ride dependencies (useful for testing)
void unregisterRideDependencies() {
  // Unregister Cubits
  if (getIt.isRegistered<ActiveRideCubit>()) {
    getIt.unregister<ActiveRideCubit>();
  }
  if (getIt.isRegistered<RideHistoryCubit>()) {
    getIt.unregister<RideHistoryCubit>();
  }
  if (getIt.isRegistered<ChatCubit>()) {
    getIt.unregister<ChatCubit>();
  }
  if (getIt.isRegistered<ReviewCubit>()) {
    getIt.unregister<ReviewCubit>();
  }
  if (getIt.isRegistered<ComplaintCubit>()) {
    getIt.unregister<ComplaintCubit>();
  }

  // Unregister Repositories
  if (getIt.isRegistered<RideRepository>()) {
    getIt.unregister<RideRepository>();
  }
  if (getIt.isRegistered<ChatRepository>()) {
    getIt.unregister<ChatRepository>();
  }
  if (getIt.isRegistered<ReviewRepository>()) {
    getIt.unregister<ReviewRepository>();
  }
  if (getIt.isRegistered<ComplaintRepository>()) {
    getIt.unregister<ComplaintRepository>();
  }
}
