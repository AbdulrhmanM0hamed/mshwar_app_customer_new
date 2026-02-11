/// Package Model - Available packages for purchase
class PackageModel {
  final String id;
  final String name;
  final String? description;
  final double pricePerKm;
  final double totalKm;
  final double totalPrice;
  final String? validity;
  final bool isActive;

  PackageModel({
    required this.id,
    required this.name,
    this.description,
    required this.pricePerKm,
    required this.totalKm,
    required this.totalPrice,
    this.validity,
    this.isActive = true,
  });

  factory PackageModel.fromJson(Map<String, dynamic> json) {
    return PackageModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      pricePerKm: double.tryParse(json['price_per_km']?.toString() ?? '0') ?? 0.0,
      totalKm: double.tryParse(json['total_km']?.toString() ?? '0') ?? 0.0,
      totalPrice: double.tryParse(json['total_price']?.toString() ?? '0') ?? 0.0,
      validity: json['validity'],
      isActive: json['is_active'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price_per_km': pricePerKm.toString(),
      'total_km': totalKm.toString(),
      'total_price': totalPrice.toString(),
      'validity': validity,
      'is_active': isActive,
    };
  }

  String get formattedPrice => '${totalPrice.toStringAsFixed(3)} KWD';
  String get formattedKm => '${totalKm.toStringAsFixed(0)} KM';
  String get pricePerKmDisplay => '${pricePerKm.toStringAsFixed(3)} KWD/KM';
}

/// User Package Model - User's purchased packages
class UserPackageModel {
  final String id;
  final String userId;
  final String packageId;
  final String packageName;
  final double pricePerKm;
  final double totalKm;
  final double remainingKm;
  final double usedKm;
  final double totalPrice;
  final String? purchasedAt;
  final String? lastUsedAt;
  final String status;
  final String paymentStatus;
  final String? paymentMethod;
  final String? transactionId;

  UserPackageModel({
    required this.id,
    required this.userId,
    required this.packageId,
    required this.packageName,
    required this.pricePerKm,
    required this.totalKm,
    required this.remainingKm,
    required this.usedKm,
    required this.totalPrice,
    this.purchasedAt,
    this.lastUsedAt,
    required this.status,
    required this.paymentStatus,
    this.paymentMethod,
    this.transactionId,
  });

  factory UserPackageModel.fromJson(Map<String, dynamic> json) {
    return UserPackageModel(
      id: json['id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      packageId: json['package_id']?.toString() ?? '',
      packageName: json['package_name'] ?? '',
      pricePerKm: double.tryParse(json['price_per_km']?.toString() ?? '0') ?? 0.0,
      totalKm: double.tryParse(json['total_km']?.toString() ?? '0') ?? 0.0,
      remainingKm: double.tryParse(json['remaining_km']?.toString() ?? '0') ?? 0.0,
      usedKm: double.tryParse(json['used_km']?.toString() ?? '0') ?? 0.0,
      totalPrice: double.tryParse(json['total_price']?.toString() ?? '0') ?? 0.0,
      purchasedAt: json['purchased_at'],
      lastUsedAt: json['last_used_at'],
      status: json['status'] ?? 'pending',
      paymentStatus: json['payment_status'] ?? 'pending',
      paymentMethod: json['payment_method'],
      transactionId: json['transaction_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'package_id': packageId,
      'package_name': packageName,
      'price_per_km': pricePerKm.toString(),
      'total_km': totalKm.toString(),
      'remaining_km': remainingKm.toString(),
      'used_km': usedKm.toString(),
      'total_price': totalPrice.toString(),
      'purchased_at': purchasedAt,
      'last_used_at': lastUsedAt,
      'status': status,
      'payment_status': paymentStatus,
      'payment_method': paymentMethod,
      'transaction_id': transactionId,
    };
  }

  double get usageProgress => totalKm > 0 ? usedKm / totalKm : 0.0;
  double get remainingProgress => 1.0 - usageProgress;
  bool get isActive => status == 'active' && paymentStatus == 'paid';
  bool get isConsumed => status == 'consumed' || remainingKm <= 0;
  bool get isUsable => isActive && remainingKm > 0;

  String get statusDisplay {
    switch (status) {
      case 'active':
        return 'Active';
      case 'consumed':
        return 'Fully Used';
      case 'cancelled':
        return 'Cancelled';
      case 'pending':
        return 'Pending Payment';
      default:
        return status;
    }
  }
}
