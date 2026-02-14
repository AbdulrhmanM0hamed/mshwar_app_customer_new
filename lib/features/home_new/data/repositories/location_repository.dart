import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart' hide Location;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_google_places_hoc081098/google_maps_webservice_places.dart';
import 'package:google_api_headers/google_api_headers.dart';
import '../../../../core/constant/constant.dart';
import '../models/location_model.dart';

abstract class LocationRepository {
  Future<LocationModel> getCurrentLocation();
  Future<LocationModel> getAddressFromCoordinates(double lat, double lng);
  Future<List<LocationModel>> searchLocation(String query);
  Future<bool> checkLocationPermission();
  Future<bool> requestLocationPermission();
  Future<bool> isLocationServiceEnabled();
}

class LocationRepositoryImpl implements LocationRepository {
  @override
  Future<LocationModel> getCurrentLocation() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled');
      }

      // Check permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied');
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Get address from coordinates
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      String address = '';
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        address = '${place.street}, ${place.locality}, ${place.country}';
      }

      return LocationModel(
        latitude: position.latitude,
        longitude: position.longitude,
        address: address,
      );
    } catch (e) {
      throw Exception('Failed to get current location: $e');
    }
  }

  @override
  Future<LocationModel> getAddressFromCoordinates(
    double lat,
    double lng,
  ) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);

      if (placemarks.isEmpty) {
        throw Exception('No address found for coordinates');
      }

      Placemark place = placemarks[0];
      String address = '${place.street}, ${place.locality}, ${place.country}';

      return LocationModel(
        latitude: lat,
        longitude: lng,
        address: address,
        placeName: place.name,
      );
    } catch (e) {
      throw Exception('Failed to get address: $e');
    }
  }

  @override
  Future<List<LocationModel>> searchLocation(String query) async {
    try {
      if (query.isEmpty) {
        return [];
      }

      String apiKey = Constant.kGoogleApiKey ?? '';
      // Fallback if not set
      if (apiKey.isEmpty || apiKey == 'null') {
        apiKey = 'AIzaSyCvUrBOS0y4FDS6kAhkZhLRjTHtudwG43c';
      }

      final places = GoogleMapsPlaces(
        apiKey: apiKey,
        apiHeaders: await const GoogleApiHeaders().getHeaders(),
      );

      final response = await places.autocomplete(
        query,
        language: 'en',
        components: [Component(Component.country, "kw")], // Kuwait
      );

      if (!response.isOkay) {
        return [];
      }

      List<LocationModel> results = [];
      for (var prediction in response.predictions) {
        results.add(
          LocationModel(
            latitude:
                0, // Lat/Lng will be fetched when selected to save API calls
            longitude: 0,
            address: prediction.description ?? '',
            placeName: prediction.structuredFormatting?.mainText ?? '',
            placeId: prediction.placeId, // Store placeId to fetch details later
          ),
        );
      }

      return results;
    } catch (e) {
      throw Exception('Failed to search location: $e');
    }
  }

  // Helper method to get details by place ID (can be added to interface if needed)
  Future<LocationModel?> getPlaceDetails(String placeId) async {
    try {
      String apiKey = Constant.kGoogleApiKey ?? '';
      if (apiKey.isEmpty || apiKey == 'null') {
        apiKey = 'AIzaSyCvUrBOS0y4FDS6kAhkZhLRjTHtudwG43c';
      }

      final places = GoogleMapsPlaces(
        apiKey: apiKey,
        apiHeaders: await const GoogleApiHeaders().getHeaders(),
      );

      final detail = await places.getDetailsByPlaceId(placeId);
      if (detail.isOkay && detail.result.geometry != null) {
        final loc = detail.result.geometry!.location;
        return LocationModel(
          latitude: loc.lat,
          longitude: loc.lng,
          address: detail.result.formattedAddress ?? '',
          placeName: detail.result.name,
        );
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> checkLocationPermission() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      return permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> requestLocationPermission() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      return permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> isLocationServiceEnabled() async {
    try {
      return await Geolocator.isLocationServiceEnabled();
    } catch (e) {
      return false;
    }
  }
}
