import '../../../../core(new)/network/api_service.dart';
import '../models/coupon_model.dart';

abstract class PlansCouponRepository {
  Future<List<PlansCouponModel>> getCoupons();
  Future<PlansCouponModel?> validateCoupon(String code, double amount);
}

class PlansCouponRepositoryImpl implements PlansCouponRepository {
  final ApiService apiService;

  PlansCouponRepositoryImpl({required this.apiService});

  @override
  Future<List<PlansCouponModel>> getCoupons() async {
    try {
      final response = await apiService.get('/plans-coupons');

      if (response['success'] == 'success' || response['success'] == true) {
        final List<dynamic> data = response['data'] ?? [];
        return data.map((json) => PlansCouponModel.fromJson(json)).toList();
      }

      throw Exception(response['message'] ?? 'Failed to load coupons');
    } catch (e) {
      throw Exception('Failed to load coupons: $e');
    }
  }

  @override
  Future<PlansCouponModel?> validateCoupon(String code, double amount) async {
    try {
      final response = await apiService.post(
        '/validate-plans-coupon',
        data: {
          'code': code,
          'amount': amount,
        },
      );

      if (response['success'] == 'success' || response['success'] == true) {
        return PlansCouponModel.fromJson(response['data']);
      }

      throw Exception(response['message'] ?? 'Invalid coupon');
    } catch (e) {
      throw Exception('Failed to validate coupon: $e');
    }
  }
}
