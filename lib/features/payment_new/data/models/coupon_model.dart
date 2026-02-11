class CouponModel {
  final String id;
  final String code;
  final String description;
  final String type; // 'Percentage' or 'Fixed'
  final double discount;
  final double? minimumAmount;
  final double? maximumDiscount;
  final DateTime? expiryDate;
  final bool isActive;

  const CouponModel({
    required this.id,
    required this.code,
    required this.description,
    required this.type,
    required this.discount,
    this.minimumAmount,
    this.maximumDiscount,
    this.expiryDate,
    required this.isActive,
  });

  factory CouponModel.fromJson(Map<String, dynamic> json) {
    return CouponModel(
      id: json['id']?.toString() ?? '',
      code: json['code']?.toString() ?? '',
      description: json['discription']?.toString() ?? json['description']?.toString() ?? '',
      type: json['type']?.toString() ?? 'Fixed',
      discount: double.tryParse(json['discount']?.toString() ?? '0') ?? 0.0,
      minimumAmount: json['minimum_amount'] != null 
          ? double.tryParse(json['minimum_amount'].toString()) 
          : null,
      maximumDiscount: json['maximum_discount'] != null 
          ? double.tryParse(json['maximum_discount'].toString()) 
          : null,
      expiryDate: json['expiry_date'] != null 
          ? DateTime.tryParse(json['expiry_date'].toString()) 
          : null,
      isActive: json['active']?.toString() == 'yes' || json['active']?.toString() == '1',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'discription': description,
      'type': type,
      'discount': discount.toString(),
      'minimum_amount': minimumAmount?.toString(),
      'maximum_discount': maximumDiscount?.toString(),
      'expiry_date': expiryDate?.toIso8601String(),
      'active': isActive ? 'yes' : 'no',
    };
  }

  bool get isExpired {
    if (expiryDate == null) return false;
    return DateTime.now().isAfter(expiryDate!);
  }

  bool get isValid => isActive && !isExpired;

  double calculateDiscount(double amount) {
    if (!isValid) return 0.0;
    
    // Check minimum amount
    if (minimumAmount != null && amount < minimumAmount!) {
      return 0.0;
    }

    double discountAmount;
    
    if (type == 'Percentage') {
      discountAmount = (amount * discount) / 100;
      
      // Apply maximum discount if set
      if (maximumDiscount != null && discountAmount > maximumDiscount!) {
        discountAmount = maximumDiscount!;
      }
    } else {
      // Fixed discount
      discountAmount = discount;
    }

    // Discount cannot exceed the amount
    return discountAmount > amount ? amount : discountAmount;
  }

  CouponModel copyWith({
    String? id,
    String? code,
    String? description,
    String? type,
    double? discount,
    double? minimumAmount,
    double? maximumDiscount,
    DateTime? expiryDate,
    bool? isActive,
  }) {
    return CouponModel(
      id: id ?? this.id,
      code: code ?? this.code,
      description: description ?? this.description,
      type: type ?? this.type,
      discount: discount ?? this.discount,
      minimumAmount: minimumAmount ?? this.minimumAmount,
      maximumDiscount: maximumDiscount ?? this.maximumDiscount,
      expiryDate: expiryDate ?? this.expiryDate,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CouponModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

class CouponsResponse {
  final bool success;
  final String? message;
  final List<CouponModel> coupons;

  const CouponsResponse({
    required this.success,
    this.message,
    required this.coupons,
  });

  factory CouponsResponse.fromJson(Map<String, dynamic> json) {
    final List<CouponModel> coupons = [];
    
    if (json['data'] != null) {
      for (var item in json['data']) {
        coupons.add(CouponModel.fromJson(item));
      }
    }

    return CouponsResponse(
      success: json['success'] == 'success',
      message: json['message']?.toString(),
      coupons: coupons,
    );
  }
}
