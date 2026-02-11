class RideResponseModel {
  final String rideId;
  final String status;
  final String message;
  final DriverInfo? driver;
  final double estimatedArrivalTime;
  final String? otp;

  RideResponseModel({
    required this.rideId,
    required this.status,
    required this.message,
    this.driver,
    required this.estimatedArrivalTime,
    this.otp,
  });

  factory RideResponseModel.fromJson(Map<String, dynamic> json) {
    return RideResponseModel(
      rideId: json['ride_id']?.toString() ?? json['id']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      driver: json['driver'] != null 
          ? DriverInfo.fromJson(json['driver']) 
          : null,
      estimatedArrivalTime: double.parse(
        json['estimated_arrival_time']?.toString() ?? '0.0',
      ),
      otp: json['otp']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ride_id': rideId,
      'status': status,
      'message': message,
      if (driver != null) 'driver': driver!.toJson(),
      'estimated_arrival_time': estimatedArrivalTime,
      if (otp != null) 'otp': otp,
    };
  }
}

class DriverInfo {
  final String id;
  final String name;
  final String phone;
  final String? photo;
  final double rating;
  final int totalRides;
  final VehicleInfo vehicle;
  final double latitude;
  final double longitude;

  DriverInfo({
    required this.id,
    required this.name,
    required this.phone,
    this.photo,
    required this.rating,
    required this.totalRides,
    required this.vehicle,
    required this.latitude,
    required this.longitude,
  });

  factory DriverInfo.fromJson(Map<String, dynamic> json) {
    return DriverInfo(
      id: json['id']?.toString() ?? '',
      name: '${json['prenom'] ?? ''} ${json['nom'] ?? ''}'.trim(),
      phone: json['phone']?.toString() ?? '',
      photo: json['photo']?.toString(),
      rating: double.parse(json['moyenne']?.toString() ?? '0.0'),
      totalRides: int.parse(json['total_completed_ride']?.toString() ?? '0'),
      vehicle: VehicleInfo.fromJson(json),
      latitude: double.parse(json['latitude']?.toString() ?? '0.0'),
      longitude: double.parse(json['longitude']?.toString() ?? '0.0'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      if (photo != null) 'photo': photo,
      'rating': rating,
      'total_rides': totalRides,
      'vehicle': vehicle.toJson(),
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}

class VehicleInfo {
  final String id;
  final String brand;
  final String model;
  final String color;
  final String numberPlate;
  final String type;
  final int passengers;

  VehicleInfo({
    required this.id,
    required this.brand,
    required this.model,
    required this.color,
    required this.numberPlate,
    required this.type,
    required this.passengers,
  });

  factory VehicleInfo.fromJson(Map<String, dynamic> json) {
    return VehicleInfo(
      id: json['idVehicule']?.toString() ?? '',
      brand: json['brand']?.toString() ?? '',
      model: json['model']?.toString() ?? '',
      color: json['color']?.toString() ?? '',
      numberPlate: json['numberplate']?.toString() ?? '',
      type: json['typeVehicule']?.toString() ?? '',
      passengers: int.parse(json['passenger']?.toString() ?? '1'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'brand': brand,
      'model': model,
      'color': color,
      'number_plate': numberPlate,
      'type': type,
      'passengers': passengers,
    };
  }
}
