/// Review Model - Ride reviews and ratings
class ReviewModel {
  final String id;
  final String rideId;
  final String userId;
  final String driverId;
  final double rating;
  final String? comment;
  final String status;
  final String createdAt;
  final String? updatedAt;

  ReviewModel({
    required this.id,
    required this.rideId,
    required this.userId,
    required this.driverId,
    required this.rating,
    this.comment,
    this.status = 'active',
    required this.createdAt,
    this.updatedAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id']?.toString() ?? '',
      rideId: json['ride_id']?.toString() ?? '',
      userId: json['id_user_app']?.toString() ?? '',
      driverId: json['id_conducteur']?.toString() ?? '',
      rating: double.tryParse(json['niveau']?.toString() ?? '0') ?? 0.0,
      comment: json['comment']?.toString(),
      status: json['statut']?.toString() ?? 'active',
      createdAt: json['creer']?.toString() ?? '',
      updatedAt: json['modifier']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ride_id': rideId,
      'id_user_app': userId,
      'id_conducteur': driverId,
      'niveau': rating.toString(),
      'comment': comment,
      'statut': status,
      'creer': createdAt,
      'modifier': updatedAt,
    };
  }

  bool get isPositive => rating >= 4.0;
  bool get isNegative => rating < 3.0;
  bool get hasComment => comment != null && comment!.isNotEmpty;

  String get ratingDisplay {
    if (rating >= 4.5) return 'Excellent';
    if (rating >= 4.0) return 'Very Good';
    if (rating >= 3.0) return 'Good';
    if (rating >= 2.0) return 'Fair';
    return 'Poor';
  }
}

/// Review Request - For submitting new reviews
class ReviewRequest {
  final String rideId;
  final String driverId;
  final double rating;
  final String? comment;

  ReviewRequest({
    required this.rideId,
    required this.driverId,
    required this.rating,
    this.comment,
  });

  Map<String, dynamic> toJson() {
    return {
      'ride_id': rideId,
      'id_conducteur': driverId,
      'niveau': rating.toString(),
      'comment': comment ?? '',
    };
  }

  bool get isValid => rating >= 1.0 && rating <= 5.0;
}
