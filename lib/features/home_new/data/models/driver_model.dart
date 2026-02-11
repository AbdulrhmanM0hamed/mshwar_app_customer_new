class DriverModel {
  final String id;
  final String firstName;
  final String lastName;
  final String phone;
  final String email;
  final bool isOnline;
  final String? photo;
  final double latitude;
  final double longitude;
  final VehicleDetails vehicle;
  final double rating;
  final int totalCompletedRides;
  final double? distanceFromUser;

  DriverModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
    required this.isOnline,
    this.photo,
    required this.latitude,
    required this.longitude,
    required this.vehicle,
    required this.rating,
    required this.totalCompletedRides,
    this.distanceFromUser,
  });

  String get fullName => '$firstName $lastName'.trim();

  factory DriverModel.fromJson(Map<String, dynamic> json) {
    return DriverModel(
      id: json['id']?.toString() ?? json['driver_id']?.toString() ?? '',
      firstName: json['prenom']?.toString() ?? '',
      lastName: json['nom']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      isOnline: json['online']?.toString() == '1',
      photo: json['photo']?.toString(),
      latitude: double.parse(json['latitude']?.toString() ?? '0.0'),
      longitude: double.parse(json['longitude']?.toString() ?? '0.0'),
      vehicle: VehicleDetails.fromJson(json),
      rating: double.parse(json['moyenne']?.toString() ?? '0.0'),
      totalCompletedRides: int.parse(
        json['total_completed_ride']?.toString() ?? '0',
      ),
      distanceFromUser: json['distance'] != null
          ? double.parse(json['distance'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'prenom': firstName,
      'nom': lastName,
      'phone': phone,
      'email': email,
      'online': isOnline ? '1' : '0',
      if (photo != null) 'photo': photo,
      'latitude': latitude,
      'longitude': longitude,
      ...vehicle.toJson(),
      'moyenne': rating,
      'total_completed_ride': totalCompletedRides,
      if (distanceFromUser != null) 'distance': distanceFromUser,
    };
  }

  DriverModel copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? phone,
    String? email,
    bool? isOnline,
    String? photo,
    double? latitude,
    double? longitude,
    VehicleDetails? vehicle,
    double? rating,
    int? totalCompletedRides,
    double? distanceFromUser,
  }) {
    return DriverModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      isOnline: isOnline ?? this.isOnline,
      photo: photo ?? this.photo,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      vehicle: vehicle ?? this.vehicle,
      rating: rating ?? this.rating,
      totalCompletedRides: totalCompletedRides ?? this.totalCompletedRides,
      distanceFromUser: distanceFromUser ?? this.distanceFromUser,
    );
  }
}

class VehicleDetails {
  final String id;
  final String brand;
  final String model;
  final String color;
  final String numberPlate;
  final String type;
  final int maxPassengers;

  VehicleDetails({
    required this.id,
    required this.brand,
    required this.model,
    required this.color,
    required this.numberPlate,
    required this.type,
    required this.maxPassengers,
  });

  factory VehicleDetails.fromJson(Map<String, dynamic> json) {
    return VehicleDetails(
      id: json['idVehicule']?.toString() ?? '',
      brand: json['brand']?.toString() ?? '',
      model: json['model']?.toString() ?? '',
      color: json['color']?.toString() ?? '',
      numberPlate: json['numberplate']?.toString() ?? '',
      type: json['typeVehicule']?.toString() ?? '',
      maxPassengers: int.parse(json['passenger']?.toString() ?? '4'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idVehicule': id,
      'brand': brand,
      'model': model,
      'color': color,
      'numberplate': numberPlate,
      'typeVehicule': type,
      'passenger': maxPassengers,
    };
  }
}
