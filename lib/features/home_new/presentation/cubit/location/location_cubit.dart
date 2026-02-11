import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/location_repository.dart';
import '../../../data/models/location_model.dart';
import 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  final LocationRepository repository;

  LocationCubit({required this.repository}) : super(LocationInitial());

  Future<void> getCurrentLocation() async {
    try {
      emit(LocationLoading());

      // Check if location service is enabled
      final isEnabled = await repository.isLocationServiceEnabled();
      if (!isEnabled) {
        emit(const LocationServiceDisabled(
          'Location services are disabled. Please enable them.',
        ));
        return;
      }

      // Check permissions
      final hasPermission = await repository.checkLocationPermission();
      if (!hasPermission) {
        final granted = await repository.requestLocationPermission();
        if (!granted) {
          emit(const LocationPermissionDenied(
            'Location permission is required to use this feature.',
          ));
          return;
        }
      }

      // Get current location
      final location = await repository.getCurrentLocation();
      emit(LocationLoaded(location));
    } catch (e) {
      emit(LocationError(e.toString()));
    }
  }

  Future<void> getAddressFromCoordinates(double lat, double lng) async {
    try {
      emit(LocationLoading());
      final location = await repository.getAddressFromCoordinates(lat, lng);
      emit(LocationLoaded(location));
    } catch (e) {
      emit(LocationError(e.toString()));
    }
  }

  Future<void> searchLocation(String query) async {
    try {
      if (query.isEmpty) {
        emit(const LocationSearchResults([]));
        return;
      }

      emit(LocationSearching());
      final results = await repository.searchLocation(query);
      emit(LocationSearchResults(results));
    } catch (e) {
      emit(LocationError(e.toString()));
    }
  }

  Future<bool> requestPermission() async {
    try {
      return await repository.requestLocationPermission();
    } catch (e) {
      return false;
    }
  }

  void clearSearch() {
    emit(const LocationSearchResults([]));
  }

  void reset() {
    emit(LocationInitial());
  }
}
