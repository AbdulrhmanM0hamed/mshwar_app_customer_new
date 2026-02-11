import '../../../../core(new)/network/api_service.dart';
import '../models/package_model.dart';

abstract class PackageRepository {
  Future<List<PackageModel>> getAvailablePackages();
  Future<List<UserPackageModel>> getUserPackages({String? status});
  Future<List<UserPackageModel>> getUsablePackages();
  Future<UserPackageModel> purchasePackage(String packageId, String paymentMethod);
  Future<UserPackageModel> payWithWallet(String userPackageId, double amount);
  Future<bool> confirmPayment(String userPackageId, String transactionId, String paymentMethod);
  Future<bool> cancelPackage(String userPackageId);
  Future<bool> applyToRide(String userPackageId, String rideId, double kmToDeduct);
}

class PackageRepositoryImpl implements PackageRepository {
  final ApiService apiService;

  PackageRepositoryImpl({required this.apiService});

  @override
  Future<List<PackageModel>> getAvailablePackages() async {
    try {
      final response = await apiService.get('/packages');

      if (response['success'] == 'success' && response['data'] != null) {
        List<dynamic> data = response['data'];
        return data.map((json) => PackageModel.fromJson(json)).toList();
      }

      throw Exception(response['message'] ?? 'Failed to load packages');
    } catch (e) {
      throw Exception('Failed to get packages: $e');
    }
  }

  @override
  Future<List<UserPackageModel>> getUserPackages({String? status}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (status != null && status.isNotEmpty) {
        queryParams['status'] = status;
      }

      final response = await apiService.get(
        '/user-packages',
        queryParameters: queryParams,
      );

      if (response['success'] == 'success' && response['data'] != null) {
        List<dynamic> data = response['data'];
        return data.map((json) => UserPackageModel.fromJson(json)).toList();
      }

      throw Exception(response['message'] ?? 'Failed to load user packages');
    } catch (e) {
      throw Exception('Failed to get user packages: $e');
    }
  }

  @override
  Future<List<UserPackageModel>> getUsablePackages() async {
    try {
      final response = await apiService.get('/usable-packages');

      if (response['success'] == 'success' && response['data'] != null) {
        List<dynamic> data = response['data'];
        return data.map((json) => UserPackageModel.fromJson(json)).toList();
      }

      throw Exception(response['message'] ?? 'Failed to load usable packages');
    } catch (e) {
      throw Exception('Failed to get usable packages: $e');
    }
  }

  @override
  Future<UserPackageModel> purchasePackage(String packageId, String paymentMethod) async {
    try {
      final response = await apiService.post(
        '/purchase-package',
        data: {
          'package_id': packageId,
          'payment_method': paymentMethod,
        },
      );

      if (response['success'] == 'success' && response['data'] != null) {
        return UserPackageModel.fromJson(response['data']);
      }

      throw Exception(response['message'] ?? 'Failed to purchase package');
    } catch (e) {
      throw Exception('Failed to purchase package: $e');
    }
  }

  @override
  Future<UserPackageModel> payWithWallet(String userPackageId, double amount) async {
    try {
      final response = await apiService.post(
        '/package-pay-wallet',
        data: {
          'user_package_id': userPackageId,
          'amount': amount,
        },
      );

      if (response['success'] == 'success' && response['data'] != null) {
        return UserPackageModel.fromJson(response['data']['user_package']);
      }

      throw Exception(response['message'] ?? 'Payment failed');
    } catch (e) {
      throw Exception('Wallet payment failed: $e');
    }
  }

  @override
  Future<bool> confirmPayment(String userPackageId, String transactionId, String paymentMethod) async {
    try {
      final response = await apiService.post(
        '/package-confirm-payment',
        data: {
          'user_package_id': userPackageId,
          'transaction_id': transactionId,
          'payment_method': paymentMethod,
        },
      );

      return response['success'] == 'success';
    } catch (e) {
      throw Exception('Failed to confirm payment: $e');
    }
  }

  @override
  Future<bool> cancelPackage(String userPackageId) async {
    try {
      final response = await apiService.post(
        '/cancel-package',
        data: {'user_package_id': userPackageId},
      );

      return response['success'] == 'success';
    } catch (e) {
      throw Exception('Failed to cancel package: $e');
    }
  }

  @override
  Future<bool> applyToRide(String userPackageId, String rideId, double kmToDeduct) async {
    try {
      final response = await apiService.post(
        '/apply-package-to-ride',
        data: {
          'user_package_id': userPackageId,
          'ride_id': rideId,
          'km_to_deduct': kmToDeduct,
        },
      );

      return response['success'] == 'success';
    } catch (e) {
      throw Exception('Failed to apply package: $e');
    }
  }
}
