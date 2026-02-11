class BookingConfirmationModel {
  final String bookingId;
  final String status;
  final String message;
  final BookingDetails details;

  BookingConfirmationModel({
    required this.bookingId,
    required this.status,
    required this.message,
    required this.details,
  });

  factory BookingConfirmationModel.fromJson(Map<String, dynamic> json) {
    return BookingConfirmationModel(
      bookingId: json['booking_id']?.toString() ?? json['id']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      details: BookingDetails.fromJson(json['details'] ?? json),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'booking_id': bookingId,
      'status': status,
      'message': message,
      'details': details.toJson(),
    };
  }
}

class BookingDetails {
  final String departureAddress;
  final String destinationAddress;
  final double departureLatitude;
  final double departureLongitude;
  final double destinationLatitude;
  final double destinationLongitude;
  final String vehicleType;
  final double distance;
  final String distanceUnit;
  final String duration;
  final double totalPrice;
  final double discount;
  final double finalPrice;
  final String paymentMethod;
  final DateTime? scheduledTime;
  final DateTime bookingTime;
  final String? otp;

  BookingDetails({
    required this.departureAddress,
    required this.destinationAddress,
    required this.departureLatitude,
    required this.departureLongitude,
    required this.destinationLatitude,
    required this.destinationLongitude,
    required this.vehicleType,
    required this.distance,
    required this.distanceUnit,
    required this.duration,
    required this.totalPrice,
    required this.discount,
    required this.finalPrice,
    required this.paymentMethod,
    this.scheduledTime,
    required this.bookingTime,
    this.otp,
  });

  factory BookingDetails.fromJson(Map<String, dynamic> json) {
    return BookingDetails(
      departureAddress: json['departure_address']?.toString() ?? '',
      destinationAddress: json['destination_address']?.toString() ?? '',
      departureLatitude: double.parse(
        json['departure_latitude']?.toString() ?? '0.0',
      ),
      departureLongitude: double.parse(
        json['departure_longitude']?.toString() ?? '0.0',
      ),
      destinationLatitude: double.parse(
        json['destination_latitude']?.toString() ?? '0.0',
      ),
      destinationLongitude: double.parse(
        json['destination_longitude']?.toString() ?? '0.0',
      ),
      vehicleType: json['vehicle_type']?.toString() ?? '',
      distance: double.parse(json['distance']?.toString() ?? '0.0'),
      distanceUnit: json['distance_unit']?.toString() ?? 'km',
      duration: json['duration']?.toString() ?? '',
      totalPrice: double.parse(json['total_price']?.toString() ?? '0.0'),
      discount: double.parse(json['discount']?.toString() ?? '0.0'),
      finalPrice: double.parse(json['final_price']?.toString() ?? '0.0'),
      paymentMethod: json['payment_method']?.toString() ?? '',
      scheduledTime: json['scheduled_time'] != null
          ? DateTime.parse(json['scheduled_time'])
          : null,
      bookingTime: json['booking_time'] != null
          ? DateTime.parse(json['booking_time'])
          : DateTime.now(),
      otp: json['otp']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'departure_address': departureAddress,
      'destination_address': destinationAddress,
      'departure_latitude': departureLatitude,
      'departure_longitude': departureLongitude,
      'destination_latitude': destinationLatitude,
      'destination_longitude': destinationLongitude,
      'vehicle_type': vehicleType,
      'distance': distance,
      'distance_unit': distanceUnit,
      'duration': duration,
      'total_price': totalPrice,
      'discount': discount,
      'final_price': finalPrice,
      'payment_method': paymentMethod,
      if (scheduledTime != null)
        'scheduled_time': scheduledTime!.toIso8601String(),
      'booking_time': bookingTime.toIso8601String(),
      if (otp != null) 'otp': otp,
    };
  }
}
