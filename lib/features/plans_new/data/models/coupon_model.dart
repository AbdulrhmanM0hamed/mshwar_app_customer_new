/// Plans Coupon Model
class PlansCouponModel {
  final String id;
  final String code;
  final String description;
  final String discountType; // 'percentage' or 'fixed'
  final double discountValue;
  final double? minAmount;
  final double? maxDiscount;
  final String? expireAt;
  final bool isActive;

  PlansCouponModel({
    required this.id,
    required this.code,
    required this.description,
    required this.discountType,
    required this.discountValue,
    this.minAmount,
    this.maxDiscount,
    this.expireAt,
    required this.isActive,
  });

  factory PlansCouponModel.fromJson(Map<String, dynamic> json) {
    return PlansCouponModel(
      id: json['id']?.toString() ?? '',
      code: json['code'] ?? '',
      description: json['description'] ?? '',
      discountType: json['discount_type'] ?? 'percentage',
      discountValue: double.tryParse(json['discount_value']?.toString() ?? '0') ?? 0.0,
      minAmount: json['min_amount'] != null ? double.tryParse(json['min_amount'].toString()) : null,
      maxDiscount: json['max_discount'] != null ? double.tryParse(json['max_discount'].toString()) : null,
      expireAt: json['expire_at'],
      isActive: json['is_active'] == true || json['is_active'] == 'true' || json['is_active'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'description': description,
      'discount_type': discountType,
      'discount_value': discountValue,
      'min_amount': minAmount,
      'max_discount': maxDiscount,
      'expire_at': expireAt,
      'is_active': isActive,
    };
  }

  /// Calculate discount amount for a given price
  double calculateDiscount(double price) {
    if (!isActive) return 0.0;
    if (minAmount != null && price < minAmount!) return 0.0;

    double discount = 0.0;
    if (discountType == 'percentage') {
      discount = price * (discountValue / 100);
      if (maxDiscount != null && discount > maxDiscount!) {
        discount = maxDiscount!;
      }
    } else {
      discount = discountValue;
    }

    return discount > price ? price : discount;
  }

  bool get isExpired {
    if (expireAt == null) return false;
    try {
      final expireDate = DateTime.parse(expireAt!);
      return DateTime.now().isAfter(expireDate);
    } catch (e) {
      return false;
    }
  }

  bool get isValid => isActive && !isExpired;
}
