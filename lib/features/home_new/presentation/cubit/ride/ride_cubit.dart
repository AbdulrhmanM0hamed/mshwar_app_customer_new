import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/ride_repository.dart';
import '../../../data/models/ride_request_model.dart';
import '../../../data/models/price_calculation_model.dart';
import 'ride_state.dart';

class RideCubit extends Cubit<RideState> {
  final RideRepository repository;
  PriceCalculationModel? _lastCalculation;
  String? _lastBookingId;

  RideCubit({required this.repository}) : super(RideInitial());

  PriceCalculationModel? get lastCalculation => _lastCalculation;
  String? get lastBookingId => _lastBookingId;

  Future<void> calculatePrice({
    required String vehicleName,
    required String distance,
    required double departureLat,
    required double departureLng,
    required double destinationLat,
    required double destinationLng,
  }) async {
    try {
      emit(RideCalculating());

      final response = await repository.calculatePrice(
        vehicleName: vehicleName,
        distance: distance,
        departureLat: departureLat,
        departureLng: departureLng,
        destinationLat: destinationLat,
        destinationLng: destinationLng,
      );

      if (response['status'] == true) {
        final calculation = PriceCalculationModel.fromJson(response);
        _lastCalculation = calculation;
        emit(RidePriceCalculated(calculation));
      } else {
        emit(RideError(response['message'] ?? 'Failed to calculate price'));
      }
    } catch (e) {
      emit(RideError(e.toString()));
    }
  }

  Future<void> findAvailableDrivers({
    required double latitude,
    required double longitude,
    required String vehicleCategoryId,
  }) async {
    try {
      emit(RideFindingDrivers());

      final drivers = await repository.findAvailableDrivers(
        latitude: latitude,
        longitude: longitude,
        vehicleCategoryId: vehicleCategoryId,
      );

      if (drivers.isEmpty) {
        emit(const RideNoDriversAvailable(
          'No drivers available in your area at the moment',
        ));
      } else {
        emit(RideDriversFound(drivers));
      }
    } catch (e) {
      emit(RideError(e.toString()));
    }
  }

  Future<void> bookRide(RideRequestModel request) async {
    try {
      emit(RideBooking());

      final response = await repository.bookRide(request);
      _lastBookingId = response.rideId;

      emit(RideBooked(response));
    } catch (e) {
      emit(RideError(e.toString()));
    }
  }

  Future<void> confirmBooking(String rideId) async {
    try {
      final confirmation = await repository.confirmBooking(rideId);
      emit(RideConfirmed(confirmation));
    } catch (e) {
      emit(RideError(e.toString()));
    }
  }

  Future<void> cancelRide(String rideId, String reason) async {
    try {
      emit(RideCancelling());

      final success = await repository.cancelRide(rideId, reason);

      if (success) {
        emit(const RideCancelled('Ride cancelled successfully'));
      } else {
        emit(const RideError('Failed to cancel ride'));
      }
    } catch (e) {
      emit(RideError(e.toString()));
    }
  }

  void reset() {
    _lastCalculation = null;
    _lastBookingId = null;
    emit(RideInitial());
  }
}
