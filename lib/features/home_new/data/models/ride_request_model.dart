import 'location_model.dart';

class RideRequestModel {
  final LocationModel departure;
  final LocationModel destination;
  final List<LocationModel>? stops;
  final String vehicleCategoryId;
  final String paymentMethodId;
  final String? couponCode;
  final bool usePackageKm;
  final String? packageId;
  final DateTime? scheduledTime;
  final int numberOfPassengers;
  final String? specialInstructions;

  RideRequestModel({
    required this.departure,
    required this.destination,
    this.stops,
    required this.vehicleCategoryId,
    required this.paymentMethodId,
    this.couponCode,
    this.usePackageKm = false,
    this.packageId,
    this.scheduledTime,
    this.numberOfPassengers = 1,
    this.specialInstructions,
  });

  Map<String, dynamic> toJson() {
    return {
      'departure_latitude': departure.latitude,
      'departure_longitude': departure.longitude,
      'departure_address': departure.address,
      'destination_latitude': destination.latitude,
      'destination_longitude': destination.longitude,
      'destination_address': destination.address,
      if (stops != null && stops!.isNotEmpty)
        'stops': stops!.map((s) => s.toJson()).toList(),
      'vehicle_category_id': vehicleCategoryId,
      'payment_method_id': paymentMethodId,
      if (couponCode != null) 'coupon_code': couponCode,
      'use_package_km': usePackageKm,
      if (packageId != null) 'package_id': packageId,
      if (scheduledTime != null)
        'scheduled_time': scheduledTime!.toIso8601String(),
      'number_of_passengers': numberOfPassengers,
      if (specialInstructions != null)
        'special_instructions': specialInstructions,
    };
  }

  RideRequestModel copyWith({
    LocationModel? departure,
    LocationModel? destination,
    List<LocationModel>? stops,
    String? vehicleCategoryId,
    String? paymentMethodId,
    String? couponCode,
    bool? usePackageKm,
    String? packageId,
    DateTime? scheduledTime,
    int? numberOfPassengers,
    String? specialInstructions,
  }) {
    return RideRequestModel(
      departure: departure ?? this.departure,
      destination: destination ?? this.destination,
      stops: stops ?? this.stops,
      vehicleCategoryId: vehicleCategoryId ?? this.vehicleCategoryId,
      paymentMethodId: paymentMethodId ?? this.paymentMethodId,
      couponCode: couponCode ?? this.couponCode,
      usePackageKm: usePackageKm ?? this.usePackageKm,
      packageId: packageId ?? this.packageId,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      numberOfPassengers: numberOfPassengers ?? this.numberOfPassengers,
      specialInstructions: specialInstructions ?? this.specialInstructions,
    );
  }
}
