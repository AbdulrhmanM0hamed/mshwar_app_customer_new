enum PaymentResponseStatus {
  success,
  pending,
  failed,
  cancelled,
  requiresAction,
}

class PaymentResponseModel {
  final bool success;
  final String? message;
  final PaymentResponseStatus status;
  final String? transactionId;
  final String? paymentIntentId;
  final String? redirectUrl;
  final double? amount;
  final Map<String, dynamic>? data;

  const PaymentResponseModel({
    required this.success,
    this.message,
    required this.status,
    this.transactionId,
    this.paymentIntentId,
    this.redirectUrl,
    this.amount,
    this.data,
  });

  factory PaymentResponseModel.fromJson(Map<String, dynamic> json) {
    return PaymentResponseModel(
      success: json['success'] == 'success' || json['success'] == true,
      message: json['message']?.toString(),
      status: _parseStatus(json['status']?.toString()),
      transactionId: json['transaction_id']?.toString(),
      paymentIntentId: json['payment_intent_id']?.toString(),
      redirectUrl: json['redirect_url']?.toString(),
      amount: json['amount'] != null 
          ? double.tryParse(json['amount'].toString())
          : null,
      data: json['data'] as Map<String, dynamic>?,
    );
  }

  static PaymentResponseStatus _parseStatus(String? status) {
    switch (status?.toLowerCase()) {
      case 'success':
      case 'completed':
        return PaymentResponseStatus.success;
      case 'pending':
        return PaymentResponseStatus.pending;
      case 'failed':
      case 'error':
        return PaymentResponseStatus.failed;
      case 'cancelled':
        return PaymentResponseStatus.cancelled;
      case 'requires_action':
      case 'requires_confirmation':
        return PaymentResponseStatus.requiresAction;
      default:
        return PaymentResponseStatus.pending;
    }
  }

  bool get isSuccess => status == PaymentResponseStatus.success;
  bool get isPending => status == PaymentResponseStatus.pending;
  bool get isFailed => status == PaymentResponseStatus.failed;
  bool get requiresAction => status == PaymentResponseStatus.requiresAction;

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'status': status.name,
      'transaction_id': transactionId,
      'payment_intent_id': paymentIntentId,
      'redirect_url': redirectUrl,
      'amount': amount?.toString(),
      'data': data,
    };
  }
}
