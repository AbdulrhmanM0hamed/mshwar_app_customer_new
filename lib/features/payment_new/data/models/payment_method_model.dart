class PaymentMethodModel {
  final String id;
  final String name;
  final String? image;
  final bool isActive;
  final String? description;

  const PaymentMethodModel({
    required this.id,
    required this.name,
    this.image,
    required this.isActive,
    this.description,
  });

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    return PaymentMethodModel(
      id: json['id']?.toString() ?? '',
      name: json['libelle']?.toString() ?? '',
      image: json['image']?.toString(),
      isActive: json['statut']?.toString() == 'yes' || json['statut']?.toString() == '1',
      description: json['description']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'libelle': name,
      'image': image,
      'statut': isActive ? 'yes' : 'no',
      'description': description,
    };
  }

  PaymentMethodModel copyWith({
    String? id,
    String? name,
    String? image,
    bool? isActive,
    String? description,
  }) {
    return PaymentMethodModel(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      isActive: isActive ?? this.isActive,
      description: description ?? this.description,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PaymentMethodModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

class PaymentMethodsResponse {
  final bool success;
  final String? message;
  final List<PaymentMethodModel> methods;

  const PaymentMethodsResponse({
    required this.success,
    this.message,
    required this.methods,
  });

  factory PaymentMethodsResponse.fromJson(Map<String, dynamic> json) {
    final List<PaymentMethodModel> methods = [];
    
    if (json['data'] != null) {
      for (var item in json['data']) {
        methods.add(PaymentMethodModel.fromJson(item));
      }
    }

    return PaymentMethodsResponse(
      success: json['success'] == 'success',
      message: json['message']?.toString(),
      methods: methods,
    );
  }
}
