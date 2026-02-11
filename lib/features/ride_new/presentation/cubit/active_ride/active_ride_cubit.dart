import 'package:cabme/features/ride_new/data/models/ride_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cabme/features/ride_new/data/repositories/ride_repository.dart';
import 'active_ride_state.dart';

/// Active Ride Cubit - Manages active and scheduled rides
class ActiveRideCubit extends Cubit<ActiveRideState> {
  final RideRepository repository;

  ActiveRideCubit({required this.repository}) : super(ActiveRideInitial());

  /// Load active rides
  Future<void> loadActiveRides() async {
    emit(ActiveRideLoading());
    try {
      final rides = await repository.getActiveRides();

      if (rides.isEmpty) {
        emit(ActiveRideEmpty());
      } else {
        emit(ActiveRideLoaded(rides));
      }
    } catch (e) {
      emit(ActiveRideError(e.toString()));
    }
  }

  /// Load ride details
  Future<void> loadRideDetails(String rideId) async {
    emit(RideDetailsLoading());
    try {
      final ride = await repository.getRideDetails(rideId);
      emit(RideDetailsLoaded(ride));
    } catch (e) {
      emit(RideDetailsError(e.toString()));
    }
  }

  /// Cancel ride
  Future<void> cancelRide(Map<String, dynamic> bodyParams) async {
    emit(RideCancelling());
    try {
      // Extract needed params or pass map if repository supports it
      final rideId = bodyParams['id_ride']?.toString() ?? '';
      final reason = bodyParams['reason']?.toString();

      await repository.cancelRide(rideId, reason);
      emit(RideCancelled(rideId));

      // Reload active rides after cancellation
      await loadActiveRides();
    } catch (e) {
      emit(RideCancelError(e.toString()));
    }
  }

  /// Report safety (SOS)
  Future<void> reportSafety(Map<String, dynamic> bodyParams) async {
    try {
      // Implement repository call here if supported, for now just log or allow
      await repository.reportSafety(bodyParams);
      // Since repository might not have this yet, we can add it or ignore for now
    } catch (e) {
      // Handle error
    }
  }

  /// Get driver location - Returns location directly for UI polling
  Future<Map<String, double>?> getDriverLocation(String rideId) async {
    // Only emit loading if not already loaded to avoid flicker during polling
    if (state is! DriverLocationLoaded) {
      // emit(DriverLocationLoading()); // Optional: maybe too noisy for polling
    }
    try {
      final location = await repository.getDriverLocation(rideId);

      if (location != null) {
        emit(DriverLocationLoaded(location));
        return {
          'lat': location.latitudeValue,
          'lng': location.longitudeValue,
          'rotation': location.rotationValue,
        };
      } else {
        // emit(const DriverLocationError('Driver location not available'));
        return null;
      }
    } catch (e) {
      // emit(DriverLocationError(e.toString()));
      return null;
    }
  }

  /// Refresh active rides
  Future<void> refresh() async {
    await loadActiveRides();
  }
}
