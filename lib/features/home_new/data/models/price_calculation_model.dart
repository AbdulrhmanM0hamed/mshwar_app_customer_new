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
    return PriceCalculationModel(
      basePrice: double.parse(json['base_price']?.toString() ?? '0.0'),
      distancePrice: double.parse(json['distance_price']?.toString() ?? '0.0'),
      timePrice: double.parse(json['time_price']?.toString() ?? '0.0'),
      totalPrice: double.parse(json['total_price']?.toString() ?? '0.0'),
      discount: double.parse(json['discount']?.toString() ?? '0.0'),
      finalPrice: double.parse(json['final_price']?.toString() ?? '0.0'),
      distance: double.parse(json['distance']?.toString() ?? '0.0'),
      distanceUnit: json['distance_unit']?.toString() ?? 'km',
      duration: json['duration']?.toString() ?? '',
      couponCode: json['coupon_code']?.toString(),
      couponDiscount: json['coupon_discount'] != null
          ? double.parse(json['coupon_discount'].toString())
          : null,
      canUsePackage: json['can_use_package'] == true,
      packageKmAvailable: json['package_km_available'] != null
          ? double.parse(json['package_km_available'].toString())
          : null,
      packageKmRequired: json['package_km_required'] != null
          ? double.parse(json['package_km_required'].toString())
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
      if (packageKmAvailable != null) 'package_km_available': packageKmAvailable,
      if (packageKmRequired != null) 'package_km_required': packageKmRequired,
    };
  }

  PriceCalculationModel copyWith({
    double? basePrice,
    double? distancePrice,
    double? timePrice,
    double? totalPrice,
    double? discount,
    double? finalPrice,
    double? distance,
    String? distanceUnit,
    String? duration,
    String? couponCode,
    double? couponDiscount,
    bool? canUsePackage,
    double? packageKmAvailable,
    double? packageKmRequired,
  }) {
    return PriceCalculationModel(
      basePrice: basePrice ?? this.basePrice,
      distancePrice: distancePrice ?? this.distancePrice,
      timePrice: timePrice ?? this.timePrice,
      totalPrice: totalPrice ?? this.totalPrice,
      discount: discount ?? this.discount,
      finalPrice: finalPrice ?? this.finalPrice,
      distance: distance ?? this.distance,
      distanceUnit: distanceUnit ?? this.distanceUnit,
      duration: duration ?? this.duration,
      couponCode: couponCode ?? this.couponCode,
      couponDiscount: couponDiscount ?? this.couponDiscount,
      canUsePackage: canUsePackage ?? this.canUsePackage,
      packageKmAvailable: packageKmAvailable ?? this.packageKmAvailable,
      packageKmRequired: packageKmRequired ?? this.packageKmRequired,
    );
  }
}
