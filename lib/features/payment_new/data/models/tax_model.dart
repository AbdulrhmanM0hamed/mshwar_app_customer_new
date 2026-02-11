class TaxModel {
  final String id;
  final String name;
  final String type; // 'percentage' or 'fixed'
  final double value;
  final String? country;
  final bool isActive;

  const TaxModel({
    required this.id,
    required this.name,
    required this.type,
    required this.value,
    this.country,
    required this.isActive,
  });

  factory TaxModel.fromJson(Map<String, dynamic> json) {
    return TaxModel(
      id: json['id']?.toString() ?? '',
      name: json['libelle']?.toString() ?? json['name']?.toString() ?? '',
      type: json['type']?.toString() ?? 'percentage',
      value: double.tryParse(json['value']?.toString() ?? '0') ?? 0.0,
      country: json['country']?.toString(),
      isActive: json['active']?.toString() == 'yes' || json['active']?.toString() == '1',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'libelle': name,
      'type': type,
      'value': value.toString(),
      'country': country,
      'active': isActive ? 'yes' : 'no',
    };
  }

  double calculateTax(double amount) {
    if (!isActive) return 0.0;
    
    if (type == 'percentage') {
      return (amount * value) / 100;
    } else {
      return value;
    }
  }

  TaxModel copyWith({
    String? id,
    String? name,
    String? type,
    double? value,
    String? country,
    bool? isActive,
  }) {
    return TaxModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      value: value ?? this.value,
      country: country ?? this.country,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TaxModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

class TaxesResponse {
  final bool success;
  final String? message;
  final List<TaxModel> taxes;

  const TaxesResponse({
    required this.success,
    this.message,
    required this.taxes,
  });

  factory TaxesResponse.fromJson(Map<String, dynamic> json) {
    final List<TaxModel> taxes = [];
    
    if (json['data'] != null) {
      for (var item in json['data']) {
        taxes.add(TaxModel.fromJson(item));
      }
    }

    return TaxesResponse(
      success: json['success'] == 'success',
      message: json['message']?.toString(),
      taxes: taxes,
    );
  }

  double calculateTotalTax(double amount) {
    double total = 0.0;
    for (var tax in taxes) {
      total += tax.calculateTax(amount);
    }
    return total;
  }
}
