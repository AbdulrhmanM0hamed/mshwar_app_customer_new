class PriceCalculationModel {
  final double basePrice;
  final double distancePrice;
  final double timePrice;
  final double totalPrice;
  final double discount;
  final double finalPrice;
  final double distance;
  final String distanceUnit;
  final String duration;
  final String? couponCode;
  final double? couponDiscount;
  final bool canUsePackage;
  final double? packageKmAvailable;
  final double? packageKmRequired;

  PriceCalculationModel({
    required this.basePrice,
    required this.distancePrice,
    required this.timePrice,
    required this.totalPrice,
    this.discount = 0.0,
    required this.finalPrice,
    required this.distance,
    required this.distanceUnit,
    required this.duration,
    this.couponCode,
    this.couponDiscount,
    this.canUsePackage = false,
    this.packageKmAvailable,
    this.packageKmRequired,
  });

  factory PriceCalculationModel.fromJson(Map<String, dynamic> json) {
    // Handle variations in backend response field names
    final data = json['data'] ?? json;

    return PriceCalculationModel(
      basePrice: double.parse(data['base_price']?.toString() ??
          data['base_fare']?.toString() ??
          '0.0'),
      distancePrice: double.parse(data['distance_price']?.toString() ?? '0.0'),
      timePrice: double.parse(data['time_price']?.toString() ?? '0.0'),
      totalPrice: double.parse(data['total_price']?.toString() ??
          data['total_fare']?.toString() ??
          data['fare']?.toString() ??
          '0.0'),
      discount: double.parse(data['discount']?.toString() ?? '0.0'),
      finalPrice: double.parse(data['final_price']?.toString() ??
          data['total_fare']?.toString() ??
          data['fare']?.toString() ??
          '0.0'),
      distance: double.parse(data['distance']?.toString() ?? '0.0'),
      distanceUnit: data['distance_unit']?.toString() ?? 'km',
      duration: data['duration']?.toString() ?? '',
      couponCode: data['coupon_code']?.toString(),
      couponDiscount: data['coupon_discount'] != null
          ? double.parse(data['coupon_discount'].toString())
          : null,
      canUsePackage:
          data['can_use_package'] == true || data['can_use_package'] == 'true',
      packageKmAvailable: data['package_km_available'] != null
          ? double.parse(data['package_km_available'].toString())
          : null,
      packageKmRequired: data['package_km_required'] != null
          ? double.parse(data['package_km_required'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'base_price': basePrice,
      'distance_price': distancePrice,
      'time_price': timePrice,
      'total_price': totalPrice,
      'discount': discount,
      'final_price': finalPrice,
      'distance': distance,
      'distance_unit': distanceUnit,
      'duration': duration,
      if (couponCode != null) 'coupon_code': couponCode,
      if (couponDiscount != null) 'coupon_discount': couponDiscount,
      'can_use_package': canUsePackage,
      if (packageKmAvailable != null)
        'package_km_available': packageKmAvailable,
      if (packageKmRequired != null) 'package_km_required': packageKmRequired,
    };
  }
}
