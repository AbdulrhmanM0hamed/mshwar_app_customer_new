import '../../../service_locator.dart';
import '../../../core(new)/network/api_service.dart';
import '../../../core/constant/constant.dart';
import '../data/repositories/location_repository.dart';
import '../data/repositories/vehicle_repository.dart';
import '../data/repositories/ride_repository.dart';
import '../data/repositories/map_repository.dart';
import '../presentation/cubit/location/location_cubit.dart';
import '../presentation/cubit/vehicle/vehicle_cubit.dart';
import '../presentation/cubit/ride/ride_cubit.dart';
import '../presentation/cubit/booking/booking_cubit.dart';
import '../presentation/cubit/map/map_cubit.dart';

/// Setup all dependencies for Home feature
void setupHomeDependencies() {
  _registerRepositories();
  _registerCubits();
}

/// Register all repositories
void _registerRepositories() {
  // Location Repository
  if (!getIt.isRegistered<LocationRepository>()) {
    getIt.registerLazySingleton<LocationRepository>(
      () => LocationRepositoryImpl(),
    );
  }

  // Vehicle Repository
  if (!getIt.isRegistered<VehicleRepository>()) {
    getIt.registerLazySingleton<VehicleRepository>(
      () => VehicleRepositoryImpl(apiService: getIt<ApiService>()),
    );
  }

  // Ride Repository
  if (!getIt.isRegistered<RideRepository>()) {
    getIt.registerLazySingleton<RideRepository>(
      () => RideRepositoryImpl(apiService: getIt<ApiService>()),
    );
  }

  // Map Repository
  if (!getIt.isRegistered<MapRepository>()) {
    getIt.registerLazySingleton<MapRepository>(
      () => MapRepositoryImpl(
        googleApiKey: Constant.kGoogleApiKey ?? '',
      ),
    );
  }
}

/// Register all Cubits (Factory - new instance each time)
void _registerCubits() {
  // Booking Cubit
  if (!getIt.isRegistered<BookingCubit>()) {
    getIt.registerLazySingleton<BookingCubit>(
      () => BookingCubit(),
    );
  }

  // Location Cubit
  if (!getIt.isRegistered<LocationCubit>()) {
    getIt.registerFactory<LocationCubit>(
      () => LocationCubit(repository: getIt<LocationRepository>()),
    );
  }

  // Vehicle Cubit
  if (!getIt.isRegistered<VehicleCubit>()) {
    getIt.registerFactory<VehicleCubit>(
      () => VehicleCubit(repository: getIt<VehicleRepository>()),
    );
  }

  // Ride Cubit
  if (!getIt.isRegistered<RideCubit>()) {
    getIt.registerFactory<RideCubit>(
      () => RideCubit(repository: getIt<RideRepository>()),
    );
  }

  // Map Cubit
  if (!getIt.isRegistered<MapCubit>()) {
    getIt.registerFactory<MapCubit>(
      () => MapCubit(repository: getIt<MapRepository>()),
    );
  }
}

/// Unregister all home dependencies
void unregisterHomeDependencies() {
  // Unregister Cubits
  if (getIt.isRegistered<BookingCubit>()) {
    getIt.unregister<BookingCubit>();
  }
  if (getIt.isRegistered<LocationCubit>()) {
    getIt.unregister<LocationCubit>();
  }
  if (getIt.isRegistered<VehicleCubit>()) {
    getIt.unregister<VehicleCubit>();
  }
  if (getIt.isRegistered<RideCubit>()) {
    getIt.unregister<RideCubit>();
  }
  if (getIt.isRegistered<MapCubit>()) {
    getIt.unregister<MapCubit>();
  }

  // Unregister Repositories
  if (getIt.isRegistered<LocationRepository>()) {
    getIt.unregister<LocationRepository>();
  }
  if (getIt.isRegistered<VehicleRepository>()) {
    getIt.unregister<VehicleRepository>();
  }
  if (getIt.isRegistered<RideRepository>()) {
    getIt.unregister<RideRepository>();
  }
  if (getIt.isRegistered<MapRepository>()) {
    getIt.unregister<MapRepository>();
  }
}
