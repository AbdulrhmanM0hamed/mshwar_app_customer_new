class WalletModel {
  final String userId;
  final double balance;
  final String currency;
  final DateTime lastUpdated;

  const WalletModel({
    required this.userId,
    required this.balance,
    required this.currency,
    required this.lastUpdated,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      userId: json['user_id']?.toString() ?? '',
      balance: double.tryParse(json['amount']?.toString() ?? '0') ?? 0.0,
      currency: json['currency']?.toString() ?? 'USD',
      lastUpdated: json['updated_at'] != null 
          ? DateTime.tryParse(json['updated_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'amount': balance.toString(),
      'currency': currency,
      'updated_at': lastUpdated.toIso8601String(),
    };
  }

  bool hasSufficientBalance(double amount) {
    return balance >= amount;
  }

  WalletModel copyWith({
    String? userId,
    double? balance,
    String? currency,
    DateTime? lastUpdated,
  }) {
    return WalletModel(
      userId: userId ?? this.userId,
      balance: balance ?? this.balance,
      currency: currency ?? this.currency,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

class WalletResponse {
  final bool success;
  final String? message;
  final WalletModel? wallet;

  const WalletResponse({
    required this.success,
    this.message,
    this.wallet,
  });

  factory WalletResponse.fromJson(Map<String, dynamic> json) {
    return WalletResponse(
      success: json['success'] == 'success',
      message: json['message']?.toString(),
      wallet: json['data'] != null ? WalletModel.fromJson(json['data']) : null,
    );
  }
}
