class LocationModel {
  final double latitude;
  final double longitude;
  final String address;
  final String? placeId;
  final String? placeName;

  LocationModel({
    required this.latitude,
    required this.longitude,
    required this.address,
    this.placeId,
    this.placeName,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      latitude: double.parse(json['latitude']?.toString() ?? '0.0'),
      longitude: double.parse(json['longitude']?.toString() ?? '0.0'),
      address: json['address']?.toString() ?? '',
      placeId: json['place_id']?.toString(),
      placeName: json['place_name']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      if (placeId != null) 'place_id': placeId,
      if (placeName != null) 'place_name': placeName,
    };
  }

  LocationModel copyWith({
    double? latitude,
    double? longitude,
    String? address,
    String? placeId,
    String? placeName,
  }) {
    return LocationModel(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      placeId: placeId ?? this.placeId,
      placeName: placeName ?? this.placeName,
    );
  }

  @override
  String toString() {
    return 'LocationModel(lat: $latitude, lng: $longitude, address: $address)';
  }
}
