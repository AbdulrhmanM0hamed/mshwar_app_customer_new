import '../../../../core(new)/network/api_service.dart';
import '../models/ride_request_model.dart';
import '../models/ride_response_model.dart';
import '../models/price_calculation_model.dart';
import '../models/booking_confirmation_model.dart';
import '../models/driver_model.dart';

abstract class RideRepository {
  Future<PriceCalculationModel> calculatePrice({
    required double departureLat,
    required double departureLng,
    required double destinationLat,
    required double destinationLng,
    required String vehicleCategoryId,
    String? couponCode,
    bool usePackageKm = false,
  });

  Future<List<DriverModel>> findAvailableDrivers({
    required double latitude,
    required double longitude,
    required String vehicleCategoryId,
    double radiusKm = 10.0,
  });

  Future<RideResponseModel> bookRide(RideRequestModel request);

  Future<BookingConfirmationModel> confirmBooking(String rideId);

  Future<bool> cancelRide(String rideId, String reason);
}

class RideRepositoryImpl implements RideRepository {
  final ApiService apiService;

  RideRepositoryImpl({required this.apiService});

  @override
  Future<PriceCalculationModel> calculatePrice({
    required double departureLat,
    required double departureLng,
    required double destinationLat,
    required double destinationLng,
    required String vehicleCategoryId,
    String? couponCode,
    bool usePackageKm = false,
  }) async {
    try {
      final response = await apiService.post(
        '/ride/calculate-price',
        data: {
          'departure_latitude': departureLat,
          'departure_longitude': departureLng,
          'destination_latitude': destinationLat,
          'destination_longitude': destinationLng,
          'vehicle_category_id': vehicleCategoryId,
          if (couponCode != null) 'coupon_code': couponCode,
          'use_package_km': usePackageKm,
        },
      );

      if (response['success'] == 'success' && response['data'] != null) {
        return PriceCalculationModel.fromJson(response['data']);
      }

      throw Exception(response['message'] ?? 'Failed to calculate price');
    } catch (e) {
      throw Exception('Failed to calculate price: $e');
    }
  }

  @override
  Future<List<DriverModel>> findAvailableDrivers({
    required double latitude,
    required double longitude,
    required String vehicleCategoryId,
    double radiusKm = 10.0,
  }) async {
    try {
      final response = await apiService.post(
        '/ride/find-drivers',
        data: {
          'latitude': latitude,
          'longitude': longitude,
          'vehicle_category_id': vehicleCategoryId,
          'radius_km': radiusKm,
        },
      );

      if (response['success'] == 'success' && response['data'] != null) {
        List<dynamic> data = response['data'];
        return data.map((json) => DriverModel.fromJson(json)).toList();
      }

      // Return empty list if no drivers found
      if (response['message']?.toString().contains('No drivers') == true) {
        return [];
      }

      throw Exception(response['message'] ?? 'Failed to find drivers');
    } catch (e) {
      throw Exception('Failed to find available drivers: $e');
    }
  }

  @override
  Future<RideResponseModel> bookRide(RideRequestModel request) async {
    try {
      final response = await apiService.post(
        '/ride/book',
        data: request.toJson(),
      );

      if (response['success'] == 'success' && response['data'] != null) {
        return RideResponseModel.fromJson(response['data']);
      }

      throw Exception(response['message'] ?? 'Failed to book ride');
    } catch (e) {
      throw Exception('Failed to book ride: $e');
    }
  }

  @override
  Future<BookingConfirmationModel> confirmBooking(String rideId) async {
    try {
      final response = await apiService.get('/ride/$rideId/confirm');

      if (response['success'] == 'success' && response['data'] != null) {
        return BookingConfirmationModel.fromJson(response['data']);
      }

      throw Exception(response['message'] ?? 'Failed to confirm booking');
    } catch (e) {
      throw Exception('Failed to confirm booking: $e');
    }
  }

  @override
  Future<bool> cancelRide(String rideId, String reason) async {
    try {
      final response = await apiService.post(
        '/ride/$rideId/cancel',
        data: {'reason': reason},
      );

      return response['success'] == 'success';
    } catch (e) {
      throw Exception('Failed to cancel ride: $e');
    }
  }
}
