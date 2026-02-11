/// Complaint Model - User complaints about rides
class ComplaintModel {
  final String id;
  final String rideId;
  final String userId;
  final String? driverId;
  final String complaintType;
  final String description;
  final List<String> images;
  final String status;
  final String? response;
  final String? respondedBy;
  final String? respondedAt;
  final String createdAt;
  final String? updatedAt;

  ComplaintModel({
    required this.id,
    required this.rideId,
    required this.userId,
    this.driverId,
    required this.complaintType,
    required this.description,
    this.images = const [],
    this.status = 'pending',
    this.response,
    this.respondedBy,
    this.respondedAt,
    required this.createdAt,
    this.updatedAt,
  });

  factory ComplaintModel.fromJson(Map<String, dynamic> json) {
    List<String> imagesList = [];
    if (json['images'] != null && json['images'] is List) {
      imagesList = (json['images'] as List).map((v) => v.toString()).toList();
    }

    return ComplaintModel(
      id: json['id']?.toString() ?? '',
      rideId: json['ride_id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      driverId: json['driver_id']?.toString(),
      complaintType: json['complaint_type']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      images: imagesList,
      status: json['status']?.toString() ?? 'pending',
      response: json['response']?.toString(),
      respondedBy: json['responded_by']?.toString(),
      respondedAt: json['responded_at']?.toString(),
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ride_id': rideId,
      'user_id': userId,
      'driver_id': driverId,
      'complaint_type': complaintType,
      'description': description,
      'images': images,
      'status': status,
      'response': response,
      'responded_by': respondedBy,
      'responded_at': respondedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  bool get isPending => status == 'pending';
  bool get isInProgress => status == 'in_progress';
  bool get isResolved => status == 'resolved';
  bool get isClosed => status == 'closed';
  bool get hasImages => images.isNotEmpty;
  bool get hasResponse => response != null && response!.isNotEmpty;

  String get statusDisplay {
    switch (status) {
      case 'pending':
        return 'Pending Review';
      case 'in_progress':
        return 'Under Investigation';
      case 'resolved':
        return 'Resolved';
      case 'closed':
        return 'Closed';
      default:
        return status;
    }
  }
}

/// Complaint Request - For submitting new complaints
class ComplaintRequest {
  final String rideId;
  final String? driverId;
  final String complaintType;
  final String description;
  final List<String> images;

  ComplaintRequest({
    required this.rideId,
    this.driverId,
    required this.complaintType,
    required this.description,
    this.images = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'ride_id': rideId,
      'driver_id': driverId,
      'complaint_type': complaintType,
      'description': description,
      'images': images,
    };
  }

  bool get isValid => complaintType.isNotEmpty && description.isNotEmpty;
}

/// Complaint Types
class ComplaintType {
  static const String driverBehavior = 'driver_behavior';
  static const String vehicleCondition = 'vehicle_condition';
  static const String routeIssue = 'route_issue';
  static const String paymentIssue = 'payment_issue';
  static const String safetyIssue = 'safety_issue';
  static const String other = 'other';

  static List<String> get all => [
        driverBehavior,
        vehicleCondition,
        routeIssue,
        paymentIssue,
        safetyIssue,
        other,
      ];

  static String getDisplayName(String type) {
    switch (type) {
      case driverBehavior:
        return 'Driver Behavior';
      case vehicleCondition:
        return 'Vehicle Condition';
      case routeIssue:
        return 'Route Issue';
      case paymentIssue:
        return 'Payment Issue';
      case safetyIssue:
        return 'Safety Issue';
      case other:
        return 'Other';
      default:
        return type;
    }
  }
}
