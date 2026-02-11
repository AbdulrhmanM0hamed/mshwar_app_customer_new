import 'package:cabme/core(new)/network/api_service.dart';
import '../models/ride_model.dart';

/// Ride Repository Interface
abstract class RideRepository {
  Future<List<RideModel>> getActiveRides();
  Future<List<RideModel>> getRideHistory({int? page, int? limit});
  Future<RideModel> getRideDetails(String rideId);
  Future<void> cancelRide(String rideId, String? reason);
  Future<DriverLocationUpdate?> getDriverLocation(String rideId);
  Future<void> reportSafety(Map<String, dynamic> bodyParams);
}

/// Ride Repository Implementation
class RideRepositoryImpl implements RideRepository {
  final ApiService apiService;

  RideRepositoryImpl({required this.apiService});

  @override
  Future<List<RideModel>> getActiveRides() async {
    try {
      final response = await apiService.get('/active-rides');
      
      if (response['success'] == 'success' && response['data'] != null) {
        final List<dynamic> data = response['data'] as List;
        return data.map((json) => RideModel.fromJson(json)).toList();
      }
      
      throw Exception(response['message'] ?? 'Failed to load active rides');
    } catch (e) {
      throw Exception('Failed to load active rides: $e');
    }
  }

  @override
  Future<List<RideModel>> getRideHistory({int? page, int? limit}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (page != null) queryParams['page'] = page;
      if (limit != null) queryParams['limit'] = limit;

      final response = await apiService.get(
        '/ride-history',
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );
      
      if (response['success'] == 'success' && response['data'] != null) {
        final List<dynamic> data = response['data'] as List;
        return data.map((json) => RideModel.fromJson(json)).toList();
      }
      
      throw Exception(response['message'] ?? 'Failed to load ride history');
    } catch (e) {
      throw Exception('Failed to load ride history: $e');
    }
  }

  @override
  Future<RideModel> getRideDetails(String rideId) async {
    try {
      final response = await apiService.get('/ride-details/$rideId');
      
      if (response['success'] == 'success' && response['data'] != null) {
        return RideModel.fromJson(response['data']);
      }
      
      throw Exception(response['message'] ?? 'Failed to load ride details');
    } catch (e) {
      throw Exception('Failed to load ride details: $e');
    }
  }

  @override
  Future<void> cancelRide(String rideId, String? reason) async {
    try {
      final response = await apiService.post(
        '/cancel-ride',
        data: {
          'ride_id': rideId,
          'reason': reason ?? '',
        },
      );
      
      if (response['success'] != 'success') {
        throw Exception(response['message'] ?? 'Failed to cancel ride');
      }
    } catch (e) {
      throw Exception('Failed to cancel ride: $e');
    }
  }

  @override
  Future<DriverLocationUpdate?> getDriverLocation(String rideId) async {
    try {
      final response = await apiService.get('/driver-location/$rideId');
      
      if (response['success'] == 'success' && response['data'] != null) {
        return DriverLocationUpdate.fromJson(response['data']);
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> reportSafety(Map<String, dynamic> bodyParams) async {
    try {
      await apiService.post('/report-safety', bodyParams);
    } catch (e) {
      // Handle or log error
    }
  }
}
