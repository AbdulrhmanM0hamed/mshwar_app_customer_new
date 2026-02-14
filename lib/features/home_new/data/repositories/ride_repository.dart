import '../../../../core(new)/network/api_service.dart';
import '../models/ride_request_model.dart';
import '../models/ride_response_model.dart';
import '../models/booking_confirmation_model.dart';
import '../models/driver_model.dart';

abstract class RideRepository {
  Future<Map<String, dynamic>> calculatePrice({
    required String vehicleName,
    required String distance,
    required double departureLat,
    required double departureLng,
    required double destinationLat,
    required double destinationLng,
  });

  Future<List<DriverModel>> findAvailableDrivers({
    required double latitude,
    required double longitude,
    required String vehicleCategoryId,
  });

  Future<RideResponseModel> bookRide(RideRequestModel request);

  Future<BookingConfirmationModel> confirmBooking(String rideId);

  Future<bool> cancelRide(String rideId, String reason);

  Future<Map<String, dynamic>?> getUserPendingPayment();
}

class RideRepositoryImpl implements RideRepository {
  final ApiService apiService;

  RideRepositoryImpl({required this.apiService});

  @override
  Future<Map<String, dynamic>> calculatePrice({
    required String vehicleName,
    required String distance,
    required double departureLat,
    required double departureLng,
    required double destinationLat,
    required double destinationLng,
  }) async {
    try {
      // Mapping vehicle name to what the old backend expects
      final normalization = vehicleName.toLowerCase().trim();
      final backendName = normalization == 'classic' ? 'classic' : 'business';

      final response = await apiService.post(
        'calculate-fare', // Use old endpoint
        data: {
          'name': backendName,
          'distance': distance,
          'pickup_latitude': departureLat.toString(),
          'pickup_longitude': departureLng.toString(),
          'destination_latitude': destinationLat.toString(),
          'destination_longitude': destinationLng.toString(),
        },
      );

      return response;
    } catch (e) {
      throw Exception('Failed to calculate price: $e');
    }
  }

  @override
  Future<List<DriverModel>> findAvailableDrivers({
    required double latitude,
    required double longitude,
    required String vehicleCategoryId,
  }) async {
    try {
      final response = await apiService.get(
        'driver?id_type_vehicule=$vehicleCategoryId&lat=$latitude&lng=$longitude',
      );

      if (response['success'] == 'success' && response['data'] != null) {
        List<dynamic> data = response['data'];
        return data.map((json) => DriverModel.fromJson(json)).toList();
      }

      return [];
    } catch (e) {
      throw Exception('Failed to find available drivers: $e');
    }
  }

  @override
  Future<RideResponseModel> bookRide(RideRequestModel request) async {
    try {
      final response = await apiService.post(
        'requete-register', // Correct endpoint from API.dart
        data: request.toJson(),
      );

      if (response['success'] == 'success' && response['data'] != null) {
        // The old backend returns data as a list or map
        final rideData = response['data'];
        Map<String, dynamic> mappedData = {};
        if (rideData is List && rideData.isNotEmpty) {
          mappedData = rideData[0];
        } else if (rideData is Map<String, dynamic>) {
          mappedData = rideData;
        }

        return RideResponseModel.fromJson(mappedData);
      }

      throw Exception(response['message'] ?? 'Failed to book ride');
    } catch (e) {
      throw Exception('Failed to book ride: $e');
    }
  }

  @override
  Future<BookingConfirmationModel> confirmBooking(String rideId) async {
    try {
      final response =
          await apiService.get('user-confirmation?id_ride=$rideId');

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
      final response =
          await apiService.get('set-rejected-requete?id_ride=$rideId');
      return response['success'] == 'success';
    } catch (e) {
      throw Exception('Failed to cancel ride: $e');
    }
  }

  @override
  Future<Map<String, dynamic>?> getUserPendingPayment() async {
    try {
      // Needs user ID from preferences usually, handled by intercepts or DI
      // For now using the direct string
      final response = await apiService.get('user-pending-payment');
      return response;
    } catch (e) {
      return null;
    }
  }
}
