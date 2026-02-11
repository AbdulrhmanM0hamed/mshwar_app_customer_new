import '../../../data/models/coupon_model.dart';

abstract class PlansCouponState {}

class PlansCouponInitial extends PlansCouponState {}

// Load Coupons States
class PlansCouponsLoading extends PlansCouponState {}

class PlansCouponsLoaded extends PlansCouponState {
  final List<PlansCouponModel> coupons;

  PlansCouponsLoaded(this.coupons);
}

class PlansCouponsError extends PlansCouponState {
  final String message;

  PlansCouponsError(this.message);
}

// Validate Coupon States
class PlansCouponValidating extends PlansCouponState {}

class PlansCouponValidated extends PlansCouponState {
  final PlansCouponModel coupon;
  final double discountAmount;

  PlansCouponValidated(this.coupon, this.discountAmount);
}

class PlansCouponValidationError extends PlansCouponState {
  final String message;

  PlansCouponValidationError(this.message);
}
