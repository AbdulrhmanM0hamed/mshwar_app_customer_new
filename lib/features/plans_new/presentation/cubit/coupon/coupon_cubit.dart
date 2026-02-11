import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/coupon_repository.dart';
import 'coupon_state.dart';

class PlansCouponCubit extends Cubit<PlansCouponState> {
  final PlansCouponRepository repository;

  PlansCouponCubit({required this.repository}) : super(PlansCouponInitial());

  Future<void> loadCoupons() async {
    emit(PlansCouponsLoading());
    try {
      final coupons = await repository.getCoupons();
      emit(PlansCouponsLoaded(coupons));
    } catch (e) {
      emit(PlansCouponsError(e.toString()));
    }
  }

  Future<void> validateCoupon(String code, double amount) async {
    emit(PlansCouponValidating());
    try {
      final coupon = await repository.validateCoupon(code, amount);
      if (coupon != null) {
        final discountAmount = coupon.calculateDiscount(amount);
        emit(PlansCouponValidated(coupon, discountAmount));
      } else {
        emit(PlansCouponValidationError('Invalid coupon'));
      }
    } catch (e) {
      emit(PlansCouponValidationError(e.toString()));
    }
  }
}
