enum TransactionType {
  credit,
  debit,
  payment,
  refund,
  withdrawal,
}

enum TransactionStatus {
  pending,
  completed,
  failed,
  cancelled,
}

class TransactionModel {
  final String id;
  final String userId;
  final double amount;
  final TransactionType type;
  final TransactionStatus status;
  final String? description;
  final String? referenceId;
  final String? paymentMethod;
  final DateTime createdAt;
  final DateTime? completedAt;

  const TransactionModel({
    required this.id,
    required this.userId,
    required this.amount,
    required this.type,
    required this.status,
    this.description,
    this.referenceId,
    this.paymentMethod,
    required this.createdAt,
    this.completedAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      amount: double.tryParse(json['amount']?.toString() ?? '0') ?? 0.0,
      type: _parseTransactionType(json['type']?.toString()),
      status: _parseTransactionStatus(json['status']?.toString()),
      description: json['description']?.toString(),
      referenceId: json['reference_id']?.toString(),
      paymentMethod: json['payment_method']?.toString(),
      createdAt: json['created_at'] != null 
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
      completedAt: json['completed_at'] != null 
          ? DateTime.tryParse(json['completed_at'].toString())
          : null,
    );
  }

  static TransactionType _parseTransactionType(String? type) {
    switch (type?.toLowerCase()) {
      case 'credit':
        return TransactionType.credit;
      case 'debit':
        return TransactionType.debit;
      case 'payment':
        return TransactionType.payment;
      case 'refund':
        return TransactionType.refund;
      case 'withdrawal':
        return TransactionType.withdrawal;
      default:
        return TransactionType.payment;
    }
  }

  static TransactionStatus _parseTransactionStatus(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return TransactionStatus.pending;
      case 'completed':
      case 'success':
        return TransactionStatus.completed;
      case 'failed':
      case 'error':
        return TransactionStatus.failed;
      case 'cancelled':
        return TransactionStatus.cancelled;
      default:
        return TransactionStatus.pending;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'amount': amount.toString(),
      'type': type.name,
      'status': status.name,
      'description': description,
      'reference_id': referenceId,
      'payment_method': paymentMethod,
      'created_at': createdAt.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
    };
  }

  bool get isCompleted => status == TransactionStatus.completed;
  bool get isPending => status == TransactionStatus.pending;
  bool get isFailed => status == TransactionStatus.failed;

  TransactionModel copyWith({
    String? id,
    String? userId,
    double? amount,
    TransactionType? type,
    TransactionStatus? status,
    String? description,
    String? referenceId,
    String? paymentMethod,
    DateTime? createdAt,
    DateTime? completedAt,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      status: status ?? this.status,
      description: description ?? this.description,
      referenceId: referenceId ?? this.referenceId,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}

class TransactionsResponse {
  final bool success;
  final String? message;
  final List<TransactionModel> transactions;

  const TransactionsResponse({
    required this.success,
    this.message,
    required this.transactions,
  });

  factory TransactionsResponse.fromJson(Map<String, dynamic> json) {
    final List<TransactionModel> transactions = [];
    
    if (json['data'] != null) {
      for (var item in json['data']) {
        transactions.add(TransactionModel.fromJson(item));
      }
    }

    return TransactionsResponse(
      success: json['success'] == 'success',
      message: json['message']?.toString(),
      transactions: transactions,
    );
  }
}
