class PaymentRequestModel {
  final String userId;
  final double amount;
  final String paymentMethodId;
  final String? rideId;
  final String? couponCode;
  final String? description;
  final Map<String, dynamic>? metadata;

  const PaymentRequestModel({
    required this.userId,
    required this.amount,
    required this.paymentMethodId,
    this.rideId,
    this.couponCode,
    this.description,
    this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'amount': amount.toString(),
      'payment_method_id': paymentMethodId,
      if (rideId != null) 'ride_id': rideId,
      if (couponCode != null) 'coupon_code': couponCode,
      if (description != null) 'description': description,
      if (metadata != null) ...metadata!,
    };
  }

  PaymentRequestModel copyWith({
    String? userId,
    double? amount,
    String? paymentMethodId,
    String? rideId,
    String? couponCode,
    String? description,
    Map<String, dynamic>? metadata,
  }) {
    return PaymentRequestModel(
      userId: userId ?? this.userId,
      amount: amount ?? this.amount,
      paymentMethodId: paymentMethodId ?? this.paymentMethodId,
      rideId: rideId ?? this.rideId,
      couponCode: couponCode ?? this.couponCode,
      description: description ?? this.description,
      metadata: metadata ?? this.metadata,
    );
  }
}

class AddFundsRequestModel {
  final String userId;
  final double amount;
  final String paymentGateway;
  final Map<String, dynamic>? gatewayData;

  const AddFundsRequestModel({
    required this.userId,
    required this.amount,
    required this.paymentGateway,
    this.gatewayData,
  });

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'amount': amount.toString(),
      'payment_gateway': paymentGateway,
      if (gatewayData != null) ...gatewayData!,
    };
  }
}
