import '../../../../core(new)/network/api_service.dart';
import '../models/vehicle_category_model.dart';

abstract class VehicleRepository {
  Future<List<VehicleCategoryModel>> getVehicleCategories();
  Future<VehicleCategoryModel> getVehicleCategoryById(String id);
}

class VehicleRepositoryImpl implements VehicleRepository {
  final ApiService apiService;

  VehicleRepositoryImpl({required this.apiService});

  @override
  Future<List<VehicleCategoryModel>> getVehicleCategories() async {
    try {
      final response = await apiService.get('Vehicle-category');

      if (response['success'] == 'success' && response['data'] != null) {
        List<dynamic> data = response['data'];
        return data
            .map((json) => VehicleCategoryModel.fromJson(json))
            .where((vehicle) => vehicle.isActive)
            .toList();
      }

      throw Exception(
          response['message'] ?? 'Failed to load vehicle categories');
    } catch (e) {
      throw Exception('Failed to get vehicle categories: $e');
    }
  }

  @override
  Future<VehicleCategoryModel> getVehicleCategoryById(String id) async {
    try {
      final response = await apiService.get('/vehicle-categories/$id');

      if (response['success'] == 'success' && response['data'] != null) {
        return VehicleCategoryModel.fromJson(response['data']);
      }

      throw Exception(response['message'] ?? 'Failed to load vehicle category');
    } catch (e) {
      throw Exception('Failed to get vehicle category: $e');
    }
  }
}
