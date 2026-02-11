import 'package:cabme/core(new)/errors/api_exception.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/coupon_repository.dart';
import '../../../data/models/coupon_model.dart';
import 'coupon_state.dart';

class CouponCubit extends Cubit<CouponState> {
  final CouponRepository _repository;
  CouponModel? _appliedCoupon;

  CouponCubit({required CouponRepository repository})
      : _repository = repository,
        super(const CouponInitial());

  CouponModel? get appliedCoupon => _appliedCoupon;

  Future<void> validateCoupon(String code, double amount) async {
    if (code.trim().isEmpty) {
      emit(const CouponInvalid('Please enter a coupon code'));
      return;
    }

    emit(const CouponValidating());

    try {
      final coupon = await _repository.validateCoupon(code, amount);
      final discountAmount = coupon.calculateDiscount(amount);

      emit(CouponValid(
        coupon: coupon,
        discountAmount: discountAmount,
      ));
    } on ApiException catch (e) {
      emit(CouponInvalid(e.message));
    } catch (e) {
      emit(CouponInvalid('Failed to validate coupon: ${e.toString()}'));
    }
  }

  Future<void> applyCoupon(String userId, String code, double amount) async {
    emit(const CouponApplying());

    try {
      // First validate the coupon
      final coupon = await _repository.validateCoupon(code, amount);
      final discountAmount = coupon.calculateDiscount(amount);

      // Then apply it
      final success = await _repository.applyCoupon(userId, code);

      if (success) {
        _appliedCoupon = coupon;
        emit(CouponApplied(
          coupon: coupon,
          discountAmount: discountAmount,
        ));
      } else {
        emit(const CouponApplyFailed('Failed to apply coupon'));
      }
    } on ApiException catch (e) {
      emit(CouponApplyFailed(e.message));
    } catch (e) {
      emit(CouponApplyFailed('Failed to apply coupon: ${e.toString()}'));
    }
  }

  void removeCoupon() {
    _appliedCoupon = null;
    emit(const CouponRemoved());
  }

  Future<void> loadAvailableCoupons(String userId) async {
    emit(const AvailableCouponsLoading());

    try {
      final coupons = await _repository.getAvailableCoupons(userId);
      emit(AvailableCouponsLoaded(coupons));
    } on ApiException catch (e) {
      emit(AvailableCouponsError(e.message));
    } catch (e) {
      emit(AvailableCouponsError('Failed to load coupons: ${e.toString()}'));
    }
  }

  double calculateDiscount(double amount) {
    if (_appliedCoupon == null) return 0.0;
    return _appliedCoupon!.calculateDiscount(amount);
  }

  void reset() {
    _appliedCoupon = null;
    emit(const CouponInitial());
  }
}
