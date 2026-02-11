/// Subscription Model
class SubscriptionModel {
  final String id;
  final String userId;
  final String tripType;
  final String homeAddress;
  final double homeLatitude;
  final double homeLongitude;
  final String destinationAddress;
  final double destinationLatitude;
  final double destinationLongitude;
  final double distanceKm;
  final double subscriptionKmPrice;
  final double singleTripPrice;
  final double totalPrice;
  final String startDate;
  final String endDate;
  final int totalDays;
  final List<int> workingDays;
  final String morningPickupTime;
  final String? returnPickupTime;
  final int totalTrips;
  final int completedTrips;
  final int remainingTrips;
  final int cancelledTrips;
  final String? customerName;
  final String? customerPhone;
  final String? passengerName;
  final String? passengerPhone;
  final String? specialInstructions;
  final String? paymentMethod;
  final String paymentStatus;
  final String? transactionId;
  final String status;
  final DriverInfo? driver;
  final String? createdAt;
  final List<SubscriptionRideModel>? rides;

  SubscriptionModel({
    required this.id,
    required this.userId,
    required this.tripType,
    required this.homeAddress,
    required this.homeLatitude,
    required this.homeLongitude,
    required this.destinationAddress,
    required this.destinationLatitude,
    required this.destinationLongitude,
    required this.distanceKm,
    required this.subscriptionKmPrice,
    required this.singleTripPrice,
    required this.totalPrice,
    required this.startDate,
    required this.endDate,
    required this.totalDays,
    required this.workingDays,
    required this.morningPickupTime,
    this.returnPickupTime,
    required this.totalTrips,
    required this.completedTrips,
    required this.remainingTrips,
    required this.cancelledTrips,
    this.customerName,
    this.customerPhone,
    this.passengerName,
    this.passengerPhone,
    this.specialInstructions,
    this.paymentMethod,
    required this.paymentStatus,
    this.transactionId,
    required this.status,
    this.driver,
    this.createdAt,
    this.rides,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      id: json['id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      tripType: json['trip_type'] ?? 'one_way',
      homeAddress: json['home_address'] ?? '',
      homeLatitude: double.tryParse(json['home_latitude']?.toString() ?? '0') ?? 0.0,
      homeLongitude: double.tryParse(json['home_longitude']?.toString() ?? '0') ?? 0.0,
      destinationAddress: json['destination_address'] ?? '',
      destinationLatitude: double.tryParse(json['destination_latitude']?.toString() ?? '0') ?? 0.0,
      destinationLongitude: double.tryParse(json['destination_longitude']?.toString() ?? '0') ?? 0.0,
      distanceKm: double.tryParse(json['distance_km']?.toString() ?? '0') ?? 0.0,
      subscriptionKmPrice: double.tryParse(json['subscription_km_price']?.toString() ?? '0') ?? 0.0,
      singleTripPrice: double.tryParse(json['single_trip_price']?.toString() ?? '0') ?? 0.0,
      totalPrice: double.tryParse(json['total_price']?.toString() ?? '0') ?? 0.0,
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      totalDays: int.tryParse(json['total_days']?.toString() ?? '0') ?? 0,
      workingDays: json['working_days'] != null ? List<int>.from(json['working_days']) : [],
      morningPickupTime: json['morning_pickup_time'] ?? '',
      returnPickupTime: json['return_pickup_time'],
      totalTrips: int.tryParse(json['total_trips']?.toString() ?? '0') ?? 0,
      completedTrips: int.tryParse(json['completed_trips']?.toString() ?? '0') ?? 0,
      remainingTrips: int.tryParse(json['remaining_trips']?.toString() ?? '0') ?? 0,
      cancelledTrips: int.tryParse(json['cancelled_trips']?.toString() ?? '0') ?? 0,
      customerName: json['customer_name'],
      customerPhone: json['customer_phone'],
      passengerName: json['passenger_name'],
      passengerPhone: json['passenger_phone'],
      specialInstructions: json['special_instructions'],
      paymentMethod: json['payment_method'],
      paymentStatus: json['payment_status'] ?? 'pending',
      transactionId: json['transaction_id'],
      status: json['status'] ?? 'pending',
      driver: json['driver'] != null ? DriverInfo.fromJson(json['driver']) : null,
      createdAt: json['created_at'],
      rides: json['rides'] != null
          ? (json['rides'] as List).map((e) => SubscriptionRideModel.fromJson(e)).toList()
          : null,
    );
  }

  String get statusDisplay {
    switch (status) {
      case 'active':
        return 'Active';
      case 'pending':
        return 'Pending Payment';
      case 'pending_approval':
        return 'Pending Approval';
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

  String get tripTypeDisplay => tripType == 'two_way' ? 'Two Way (Round Trip)' : 'One Way';

  List<String> get workingDaysNames {
    final dayNames = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return workingDays.map((d) => dayNames[d]).toList();
  }
}

/// Driver Info
class DriverInfo {
  final String id;
  final String name;
  final String? phone;
  final String? photo;

  DriverInfo({
    required this.id,
    required this.name,
    this.phone,
    this.photo,
  });

  factory DriverInfo.fromJson(Map<String, dynamic> json) {
    return DriverInfo(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      phone: json['phone'],
      photo: json['photo'],
    );
  }
}

/// Subscription Ride Model
class SubscriptionRideModel {
  final String id;
  final String subscriptionId;
  final String rideDate;
  final String rideDirection;
  final String scheduledPickupTime;
  final String pickupAddress;
  final String dropoffAddress;
  final String status;
  final DriverInfo? driver;

  SubscriptionRideModel({
    required this.id,
    required this.subscriptionId,
    required this.rideDate,
    required this.rideDirection,
    required this.scheduledPickupTime,
    required this.pickupAddress,
    required this.dropoffAddress,
    required this.status,
    this.driver,
  });

  factory SubscriptionRideModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionRideModel(
      id: json['id']?.toString() ?? '',
      subscriptionId: json['subscription_id']?.toString() ?? '',
      rideDate: json['ride_date'] ?? '',
      rideDirection: json['ride_direction'] ?? '',
      scheduledPickupTime: json['scheduled_pickup_time'] ?? '',
      pickupAddress: json['pickup_address'] ?? '',
      dropoffAddress: json['dropoff_address'] ?? '',
      status: json['status'] ?? 'scheduled',
      driver: json['driver'] != null ? DriverInfo.fromJson(json['driver']) : null,
    );
  }

  String get statusDisplay {
    switch (status) {
      case 'scheduled':
        return 'Scheduled';
      case 'in_progress':
        return 'In Progress';
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status;
    }
  }
}

/// Subscription Settings Model
class SubscriptionSettingsModel {
  final bool isAvailable;
  final double subscriptionKmPrice;
  final int minSubscriptionDays;
  final int maxSubscriptionDays;
  final double minimumDistanceKm;

  SubscriptionSettingsModel({
    required this.isAvailable,
    required this.subscriptionKmPrice,
    required this.minSubscriptionDays,
    required this.maxSubscriptionDays,
    required this.minimumDistanceKm,
  });

  factory SubscriptionSettingsModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionSettingsModel(
      isAvailable: json['is_available'] ?? false,
      subscriptionKmPrice: double.tryParse(json['subscription_km_price']?.toString() ?? '0') ?? 0.0,
      minSubscriptionDays: int.tryParse(json['min_subscription_days']?.toString() ?? '7') ?? 7,
      maxSubscriptionDays: int.tryParse(json['max_subscription_days']?.toString() ?? '365') ?? 365,
      minimumDistanceKm: double.tryParse(json['minimum_distance_km']?.toString() ?? '1') ?? 1.0,
    );
  }
}

/// Subscription Price Data
class SubscriptionPriceModel {
  final double distanceKm;
  final double kmPrice;
  final double singleTripPrice;
  final int totalTrips;
  final double totalPrice;
  final int totalDays;
  final String tripType;
  // Zone pricing fields
  final double? zoneFare;
  final double? pickupZoneFare;
  final double? dropoffZoneFare;
  final double? kmFare;
  final String? pickupZoneName;
  final String? dropoffZoneName;

  SubscriptionPriceModel({
    required this.distanceKm,
    required this.kmPrice,
    required this.singleTripPrice,
    required this.totalTrips,
    required this.totalPrice,
    required this.totalDays,
    required this.tripType,
    this.zoneFare,
    this.pickupZoneFare,
    this.dropoffZoneFare,
    this.kmFare,
    this.pickupZoneName,
    this.dropoffZoneName,
  });

  factory SubscriptionPriceModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionPriceModel(
      distanceKm: double.tryParse(json['distance_km']?.toString() ?? '0') ?? 0.0,
      kmPrice: double.tryParse(json['km_price']?.toString() ?? '0') ?? 0.0,
      singleTripPrice: double.tryParse(json['single_trip_price']?.toString() ?? '0') ?? 0.0,
      totalTrips: int.tryParse(json['total_trips']?.toString() ?? '0') ?? 0,
      totalPrice: double.tryParse(json['total_price']?.toString() ?? '0') ?? 0.0,
      totalDays: int.tryParse(json['total_days']?.toString() ?? '0') ?? 0,
      tripType: json['trip_type'] ?? 'one_way',
      zoneFare: json['zone_fare'] != null ? double.tryParse(json['zone_fare'].toString()) : null,
      pickupZoneFare: json['pickup_zone_fare'] != null ? double.tryParse(json['pickup_zone_fare'].toString()) : null,
      dropoffZoneFare: json['dropoff_zone_fare'] != null ? double.tryParse(json['dropoff_zone_fare'].toString()) : null,
      kmFare: json['km_fare'] != null ? double.tryParse(json['km_fare'].toString()) : null,
      pickupZoneName: json['pickup_zone_name'],
      dropoffZoneName: json['dropoff_zone_name'],
    );
  }
}
