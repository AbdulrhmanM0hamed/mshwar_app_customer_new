import 'package:cabme/core(new)/network/api_service.dart';
import 'package:cabme/core(new)/network/app_state_service.dart';
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
  final AppStateService appStateService;

  RideRepositoryImpl({
    required this.apiService,
    required this.appStateService,
  });

  @override
  Future<List<RideModel>> getActiveRides() async {
    try {
      final userId = appStateService.getUserId();
      final response = await apiService.get(
        'user-confirmation',
        queryParameters: {'id_user_app': userId},
      );

      if ((response['success'] == 'success' || response['success'] == true) &&
          response['data'] != null) {
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
      final userId = appStateService.getUserId();
      final queryParams = <String, dynamic>{
        'id_user_app': userId,
      };

      final response = await apiService.get(
        'user-all-rides',
        queryParameters: queryParams,
      );

      if ((response['success'] == 'success' || response['success'] == true) &&
          response['data'] != null) {
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
      final response = await apiService.get(
        'ridedetails',
        queryParameters: {'ride_id': rideId},
      );

      if (response['success'] == 'success' && response['data'] != null) {
        return RideModel.fromJson(response['data']);
      }

      throw Exception(response['message'] ?? 'Failed to load ride details');
    } catch (e) {
      throw Exception('Failed to get ride details: $e');
    }
  }

  @override
  Future<void> cancelRide(String rideId, String? reason) async {
    try {
      final userId = appStateService.getUserId();
      // The old API set-rejected-requete requires several parameters.
      // Since RideRepository doesn't receive all of them, we provide what we have.
      // Note: In a real scenario, we might need to fetch ride details first to get conductor ID.
      await apiService.post(
        'set-rejected-requete',
        data: {
          'id_ride': rideId,
          'from_id': userId,
          'reason': reason ?? '',
          // 'user_cat': 'customer', // Or fetch from appStateService if added
        },
      );
    } catch (e) {
      throw Exception('Failed to cancel ride: $e');
    }
  }

  @override
  Future<DriverLocationUpdate?> getDriverLocation(String rideId) async {
    try {
      final response = await apiService.get('/driver-location/$rideId');

      if ((response['success'] == 'success' || response['success'] == true) &&
          response['data'] != null) {
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
      await apiService.post('feel-safe', data: bodyParams);
    } catch (e) {
      // Handle or log error
    }
  }
}
