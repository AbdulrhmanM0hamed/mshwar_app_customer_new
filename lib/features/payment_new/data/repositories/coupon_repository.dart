import 'package:cabme/core(new)/errors/api_error_type.dart';

import '../../../../core(new)/network/api_service.dart';
import '../../../../core(new)/errors/api_exception.dart';
import '../models/coupon_model.dart';

abstract class CouponRepository {
  Future<CouponModel> validateCoupon(String code, double amount);
  Future<List<CouponModel>> getAvailableCoupons(String userId);
  Future<bool> applyCoupon(String userId, String code);
}

class CouponRepositoryImpl implements CouponRepository {
  final ApiService _apiService;

  CouponRepositoryImpl({required ApiService apiService})
      : _apiService = apiService;

  @override
  Future<CouponModel> validateCoupon(String code, double amount) async {
    try {
      final response = await _apiService.post(
        'coupon/validate',
        data: {
          'code': code,
          'amount': amount.toString(),
        },
      );

      if (response['success'] != 'success' && response['success'] != true) {
        throw ApiException(
          errorType: ApiErrorType.badRequest,
          message: response['message']?.toString() ?? 'Invalid coupon code',
        );
      }

      if (response['data'] == null) {
        throw ApiException(
          errorType: ApiErrorType.badRequest,
          message: 'Coupon data not found',
        );
      }

      final coupon = CouponModel.fromJson(response['data']);

      // Validate coupon
      if (!coupon.isValid) {
        throw ApiException(
          errorType: ApiErrorType.badRequest,
          message:
              coupon.isExpired ? 'Coupon has expired' : 'Coupon is not active',
        );
      }

      // Check minimum amount
      if (coupon.minimumAmount != null && amount < coupon.minimumAmount!) {
        throw ApiException(
          errorType: ApiErrorType.badRequest,
          message: 'Minimum amount required: ${coupon.minimumAmount}',
        );
      }

      return coupon;
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        errorType: ApiErrorType.badRequest,
        message: 'Failed to validate coupon: ${e.toString()}',
      );
    }
  }

  @override
  Future<List<CouponModel>> getAvailableCoupons(String userId) async {
    try {
      final response = await _apiService.get(
        'coupon/available',
        queryParameters: {'user_id': userId},
      );

      final couponsResponse = CouponsResponse.fromJson(response);

      if (!couponsResponse.success) {
        throw ApiException(
          errorType: ApiErrorType.badRequest,
          message: couponsResponse.message ?? 'Failed to load coupons',
        );
      }

      // Filter only valid coupons
      return couponsResponse.coupons.where((c) => c.isValid).toList();
    } catch (e) {
      throw ApiException(
        errorType: ApiErrorType.badRequest,
        message: 'Failed to load coupons: ${e.toString()}',
      );
    }
  }

  @override
  Future<bool> applyCoupon(String userId, String code) async {
    try {
      final response = await _apiService.post(
        'coupon/apply',
        data: {
          'user_id': userId,
          'code': code,
        },
      );

      return response['success'] == 'success' || response['success'] == true;
    } catch (e) {
      throw ApiException(
        errorType: ApiErrorType.badRequest,
        message: 'Failed to apply coupon: ${e.toString()}',
      );
    }
  }
}
