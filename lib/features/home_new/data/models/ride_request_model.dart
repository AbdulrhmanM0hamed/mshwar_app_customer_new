import 'location_model.dart';

class RideRequestModel {
  final LocationModel departure;
  final LocationModel destination;
  final List<LocationModel>? stops;
  final String vehicleCategoryId;
  final String paymentMethodId;
  final String? couponCode;
  final double? discount;
  final bool usePackageKm;
  final String? packageId;
  final double? packageKmUsed;
  final DateTime? scheduledTime;
  final int numberOfPassengers;
  final String? specialInstructions;
  final double tripPrice;
  final String duration;
  final String tripObjective;
  final String userName;
  final String userPhone;
  final String userEmail;
  final String userId;

  RideRequestModel({
    required this.departure,
    required this.destination,
    this.stops,
    required this.vehicleCategoryId,
    required this.paymentMethodId,
    this.couponCode,
    this.discount,
    this.usePackageKm = false,
    this.packageId,
    this.packageKmUsed,
    this.scheduledTime,
    this.numberOfPassengers = 1,
    this.specialInstructions,
    required this.tripPrice,
    required this.duration,
    this.tripObjective = 'General',
    required this.userName,
    required this.userPhone,
    required this.userEmail,
    required this.userId,
  });

  Map<String, dynamic> toJson() {
    List<Map<String, String>> stopsList = [];
    if (stops != null) {
      for (var stop in stops!) {
        stopsList.add({
          "latitude": stop.latitude.toString(),
          "longitude": stop.longitude.toString(),
          "location": stop.address,
        });
      }
    }

    Map<String, dynamic> data = {
      "ride_type": "Normal",
      "statut": "new",
      "distance_unit": "KM",
      "trip_objective": tripObjective,
      "statut_paiement": "yes",
      "source": departure.address,
      "destination": destination.address,
      "user_id": userId,
      "user_detail": {
        "name": userName,
        "phone": userPhone,
        "email": userEmail,
      },
      "lat1": departure.latitude.toString(),
      "lng1": departure.longitude.toString(),
      "lat2": destination.latitude.toString(),
      "lng2": destination.longitude.toString(),
      "cout": tripPrice.toString(),
      "duree": duration,
      "distance": (tripPrice > 0 ? tripPrice / 1.5 : 0)
          .toString(), // Fallback if distance not provided, but we should probably add distance field
      "trip_category": tripObjective,
      "id_conducteur": "", // Assigned by backend later or during booking
      "id_payment": paymentMethodId,
      "depart_name": departure.address,
      "destination_name": destination.address,
      "place": departure.address,
      "number_poeple": numberOfPassengers.toString(),
      "statut_round": "no",
      "stops": stopsList,
    };

    if (scheduledTime != null) {
      data["ride_sch_type"] = "schedule-ride";
      data["ride_date"] =
          "${scheduledTime!.year}-${scheduledTime!.month.toString().padLeft(2, '0')}-${scheduledTime!.day.toString().padLeft(2, '0')}";
      data["ride_time"] =
          "${scheduledTime!.hour.toString().padLeft(2, '0')}:${scheduledTime!.minute.toString().padLeft(2, '0')}";
    }

    if (couponCode != null && couponCode!.isNotEmpty) {
      data["discount_code"] = couponCode;
      data["discount"] = discount?.toString() ?? "0";
    }

    if (usePackageKm && packageId != null) {
      data["payment"] = "Package";
      data["package_id"] = packageId;
      data["package_km_used"] = packageKmUsed?.toString() ?? "0";
    }

    return data;
  }
}
