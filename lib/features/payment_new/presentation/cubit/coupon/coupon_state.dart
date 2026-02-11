import 'package:equatable/equatable.dart';
import '../../../data/models/coupon_model.dart';

abstract class CouponState extends Equatable {
  const CouponState();

  @override
  List<Object?> get props => [];
}

class CouponInitial extends CouponState {
  const CouponInitial();
}

// Coupon Validation States
class CouponValidating extends CouponState {
  const CouponValidating();
}

class CouponValid extends CouponState {
  final CouponModel coupon;
  final double discountAmount;

  const CouponValid({
    required this.coupon,
    required this.discountAmount,
  });

  @override
  List<Object> get props => [coupon, discountAmount];
}

class CouponInvalid extends CouponState {
  final String message;

  const CouponInvalid(this.message);

  @override
  List<Object> get props => [message];
}

// Coupon Application States
class CouponApplying extends CouponState {
  const CouponApplying();
}

class CouponApplied extends CouponState {
  final CouponModel coupon;
  final double discountAmount;

  const CouponApplied({
    required this.coupon,
    required this.discountAmount,
  });

  @override
  List<Object> get props => [coupon, discountAmount];
}

class CouponApplyFailed extends CouponState {
  final String message;

  const CouponApplyFailed(this.message);

  @override
  List<Object> get props => [message];
}

class CouponRemoved extends CouponState {
  const CouponRemoved();
}

// Available Coupons States
class AvailableCouponsLoading extends CouponState {
  const AvailableCouponsLoading();
}

class AvailableCouponsLoaded extends CouponState {
  final List<CouponModel> coupons;

  const AvailableCouponsLoaded(this.coupons);

  @override
  List<Object> get props => [coupons];
}

class AvailableCouponsError extends CouponState {
  final String message;

  const AvailableCouponsError(this.message);

  @override
  List<Object> get props => [message];
}
