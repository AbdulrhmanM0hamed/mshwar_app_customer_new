class VehicleCategoryModel {
  final String id;
  final String name;
  final String description;
  final double basePrice;
  final double pricePerKm;
  final String image;
  final String selectedImage;
  final bool isActive;
  final int maxPassengers;
  final double commissionPercentage;
  final double minimumFare;

  VehicleCategoryModel({
    required this.id,
    required this.name,
    required this.description,
    required this.basePrice,
    required this.pricePerKm,
    required this.image,
    required this.selectedImage,
    required this.isActive,
    required this.maxPassengers,
    required this.commissionPercentage,
    required this.minimumFare,
  });

  factory VehicleCategoryModel.fromJson(Map<String, dynamic> json) {
    return VehicleCategoryModel(
      id: json['id']?.toString() ?? '',
      name: json['libelle']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      basePrice: double.parse(json['prix']?.toString() ?? '0.0'),
      pricePerKm: double.parse(json['delivery_charges']?.toString() ?? '0.0'),
      image: json['image']?.toString() ?? '',
      selectedImage: json['selected_image_path']?.toString() ?? '',
      isActive: json['status']?.toString() == '1',
      maxPassengers: int.parse(json['passenger']?.toString() ?? '4'),
      commissionPercentage: double.parse(
        json['commission_perc']?.toString() ?? '0.0',
      ),
      minimumFare: double.parse(
        json['minimum_delivery_charges']?.toString() ?? '0.0',
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'libelle': name,
      'description': description,
      'prix': basePrice,
      'delivery_charges': pricePerKm,
      'image': image,
      'selected_image_path': selectedImage,
      'status': isActive ? '1' : '0',
      'passenger': maxPassengers,
      'commission_perc': commissionPercentage,
      'minimum_delivery_charges': minimumFare,
    };
  }

  VehicleCategoryModel copyWith({
    String? id,
    String? name,
    String? description,
    double? basePrice,
    double? pricePerKm,
    String? image,
    String? selectedImage,
    bool? isActive,
    int? maxPassengers,
    double? commissionPercentage,
    double? minimumFare,
  }) {
    return VehicleCategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      basePrice: basePrice ?? this.basePrice,
      pricePerKm: pricePerKm ?? this.pricePerKm,
      image: image ?? this.image,
      selectedImage: selectedImage ?? this.selectedImage,
      isActive: isActive ?? this.isActive,
      maxPassengers: maxPassengers ?? this.maxPassengers,
      commissionPercentage: commissionPercentage ?? this.commissionPercentage,
      minimumFare: minimumFare ?? this.minimumFare,
    );
  }
}
