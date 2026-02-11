import 'package:cabme/features/payment_new/data/models/tax_model.dart';

/// Ride Model - Active and scheduled rides
class RideModel {
  final String id;
  final String userId;
  final String? driverId;
  final String pickupName;
  final String pickupLatitude;
  final String pickupLongitude;
  final String dropoffName;
  final String dropoffLatitude;
  final String dropoffLongitude;
  final List<StopModel> stops;
  final String distance;
  final String? duration;
  final String amount;
  final String? tipAmount;
  final List<TaxModel> taxes;
  final String? discount;
  final String? transactionId;
  final String status;
  final String paymentStatus;
  final String? paymentMethod;
  final String? paymentMethodId;
  final String numberOfPassengers;
  final String? vehicleId;
  final String? vehicleBrand;
  final String? vehicleModel;
  final String? vehicleColor;
  final String? vehiclePlate;
  final String? driverName;
  final String? driverPhone;
  final String? driverPhoto;
  final String? driverRating;
  final String? otp;
  final String? tripObjective;
  final String? tripCategory;
  final String rideType;
  final String? rideDate;
  final String? rideTime;
  final String? rideScheduleType;
  final String? returnDate;
  final String? returnTime;
  final String? returnStatus;
  final String createdAt;
  final String? updatedAt;
  final String distanceUnit;

  RideModel({
    required this.id,
    required this.userId,
    this.driverId,
    required this.pickupName,
    required this.pickupLatitude,
    required this.pickupLongitude,
    required this.dropoffName,
    required this.dropoffLatitude,
    required this.dropoffLongitude,
    this.stops = const [],
    required this.distance,
    this.duration,
    required this.amount,
    this.tipAmount,
    this.taxes = const [],
    this.discount,
    this.transactionId,
    required this.status,
    required this.paymentStatus,
    this.paymentMethod,
    this.paymentMethodId,
    required this.numberOfPassengers,
    this.vehicleId,
    this.vehicleBrand,
    this.vehicleModel,
    this.vehicleColor,
    this.vehiclePlate,
    this.driverName,
    this.driverPhone,
    this.driverPhoto,
    this.driverRating,
    this.otp,
    this.tripObjective,
    this.tripCategory,
    this.rideType = 'normal',
    this.rideDate,
    this.rideTime,
    this.rideScheduleType,
    this.returnDate,
    this.returnTime,
    this.returnStatus,
    required this.createdAt,
    this.updatedAt,
    this.distanceUnit = 'km',
  });

  factory RideModel.fromJson(Map<String, dynamic> json) {
    List<TaxModel> taxList = [];
    if (json['tax'] != null && json['tax'] is List) {
      taxList = (json['tax'] as List).map((v) => TaxModel.fromJson(v)).toList();
    }

    List<StopModel> stopsList = [];
    if (json['stops'] != null && json['stops'] is List && (json['stops'] as List).isNotEmpty) {
      stopsList = (json['stops'] as List).map((v) => StopModel.fromJson(v)).toList();
    }

    return RideModel(
      id: json['id']?.toString() ?? '',
      userId: json['id_user_app']?.toString() ?? '',
      driverId: json['id_conducteur']?.toString(),
      pickupName: json['depart_name']?.toString() ?? '',
      pickupLatitude: json['latitude_depart']?.toString() ?? '',
      pickupLongitude: json['longitude_depart']?.toString() ?? '',
      dropoffName: json['destination_name']?.toString() ?? '',
      dropoffLatitude: json['latitude_arrivee']?.toString() ?? '',
      dropoffLongitude: json['longitude_arrivee']?.toString() ?? '',
      stops: stopsList,
      distance: json['distance']?.toString() ?? '0',
      duration: json['duree']?.toString(),
      amount: json['montant']?.toString() ?? '0',
      tipAmount: json['tip_amount']?.toString(),
      taxes: taxList,
      discount: json['discount']?.toString(),
      transactionId: json['transaction_id']?.toString(),
      status: json['statut']?.toString() ?? 'pending',
      paymentStatus: json['statut_paiement']?.toString() ?? 'pending',
      paymentMethod: json['payment']?.toString(),
      paymentMethodId: json['id_payment_method']?.toString(),
      numberOfPassengers: json['number_poeple']?.toString() ?? '1',
      vehicleId: json['idVehicule']?.toString(),
      vehicleBrand: json['brand']?.toString(),
      vehicleModel: json['model']?.toString(),
      vehicleColor: json['color']?.toString(),
      vehiclePlate: json['numberplate']?.toString(),
      driverName: json['nomConducteur'] != null && json['prenomConducteur'] != null
          ? '${json['nomConducteur']} ${json['prenomConducteur']}'
          : null,
      driverPhone: json['driverPhone']?.toString() ?? json['driver_phone']?.toString(),
      driverPhoto: json['photo_path']?.toString(),
      driverRating: json['moyenne_driver']?.toString() ?? '0',
      otp: json['otp']?.toString(),
      tripObjective: json['trip_objective']?.toString(),
      tripCategory: json['trip_category']?.toString(),
      rideType: json['ride_type']?.toString() ?? 'normal',
      rideDate: json['ride_date']?.toString(),
      rideTime: json['ride_time']?.toString(),
      rideScheduleType: json['ride_sch_type']?.toString(),
      returnDate: json['date_retour']?.toString(),
      returnTime: json['heure_retour']?.toString(),
      returnStatus: json['statut_round']?.toString(),
      createdAt: json['creer']?.toString() ?? '',
      updatedAt: json['modifier']?.toString(),
      distanceUnit: json['distance_unit']?.toString() ?? 'km',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_user_app': userId,
      'id_conducteur': driverId,
      'depart_name': pickupName,
      'latitude_depart': pickupLatitude,
      'longitude_depart': pickupLongitude,
      'destination_name': dropoffName,
      'latitude_arrivee': dropoffLatitude,
      'longitude_arrivee': dropoffLongitude,
      'stops': stops.map((v) => v.toJson()).toList(),
      'distance': distance,
      'duree': duration,
      'montant': amount,
      'tip_amount': tipAmount,
      'tax': taxes.map((v) => v.toJson()).toList(),
      'discount': discount,
      'transaction_id': transactionId,
      'statut': status,
      'statut_paiement': paymentStatus,
      'payment': paymentMethod,
      'id_payment_method': paymentMethodId,
      'number_poeple': numberOfPassengers,
      'idVehicule': vehicleId,
      'brand': vehicleBrand,
      'model': vehicleModel,
      'color': vehicleColor,
      'numberplate': vehiclePlate,
      'driverPhone': driverPhone,
      'photo_path': driverPhoto,
      'moyenne_driver': driverRating,
      'otp': otp,
      'trip_objective': tripObjective,
      'trip_category': tripCategory,
      'ride_type': rideType,
      'ride_date': rideDate,
      'ride_time': rideTime,
      'ride_sch_type': rideScheduleType,
      'date_retour': returnDate,
      'heure_retour': returnTime,
      'statut_round': returnStatus,
      'creer': createdAt,
      'modifier': updatedAt,
      'distance_unit': distanceUnit,
    };
  }

  bool get isScheduled => rideType == 'scheduled' || (rideDate != null && rideTime != null);
  bool get isActive => status == 'confirmed' || status == 'on_ride' || status == 'driver_arrived';
  bool get isCompleted => status == 'completed';
  bool get isCancelled => status == 'cancelled' || status == 'rejected';
  bool get isPending => status == 'pending' || status == 'new';
  bool get hasDriver => driverId != null && driverId!.isNotEmpty && driverId != 'null';
  
  double get amountValue => double.tryParse(amount) ?? 0.0;
  double get distanceValue => double.tryParse(distance) ?? 0.0;
  double get driverRatingValue => double.tryParse(driverRating ?? '0') ?? 0.0;

  String get statusDisplay {
    switch (status) {
      case 'pending':
      case 'new':
        return 'Searching for driver';
      case 'confirmed':
        return 'Driver assigned';
      case 'driver_arrived':
        return 'Driver arrived';
      case 'on_ride':
        return 'On ride';
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      case 'rejected':
        return 'Rejected';
      default:
        return status;
    }
  }
}

/// Stop Model - Multi-stop locations
class StopModel {
  final String latitude;
  final String longitude;
  final String location;

  StopModel({
    required this.latitude,
    required this.longitude,
    required this.location,
  });

  factory StopModel.fromJson(Map<String, dynamic> json) {
    return StopModel(
      latitude: json['latitude']?.toString() ?? '',
      longitude: json['longitude']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'location': location,
    };
  }
}

/// Driver Location Update - Real-time driver location
class DriverLocationUpdate {
  final String driverLatitude;
  final String driverLongitude;
  final String? rotation;
  final String driverId;
  final bool active;
  final String status;

  DriverLocationUpdate({
    required this.driverLatitude,
    required this.driverLongitude,
    this.rotation,
    required this.driverId,
    this.active = true,
    this.status = 'online',
  });

  factory DriverLocationUpdate.fromJson(Map<String, dynamic> json) {
    return DriverLocationUpdate(
      driverLatitude: json['driver_latitude']?.toString() ?? '',
      driverLongitude: json['driver_longitude']?.toString() ?? '',
      rotation: json['rotation']?.toString(),
      driverId: json['driver_id']?.toString() ?? '',
      active: json['active'] ?? true,
      status: json['status']?.toString() ?? 'online',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'driver_latitude': driverLatitude,
      'driver_longitude': driverLongitude,
      'rotation': rotation,
      'driver_id': driverId,
      'active': active,
      'status': status,
    };
  }

  double get latitudeValue => double.tryParse(driverLatitude) ?? 0.0;
  double get longitudeValue => double.tryParse(driverLongitude) ?? 0.0;
  double get rotationValue => double.tryParse(rotation ?? '0') ?? 0.0;
}
