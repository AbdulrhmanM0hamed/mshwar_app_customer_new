import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:math' show cos, sqrt, asin;

abstract class MapRepository {
  Future<List<LatLng>> getRoute({
    required LatLng origin,
    required LatLng destination,
    List<LatLng>? waypoints,
  });

  Future<Map<String, dynamic>> getRouteDetails({
    required LatLng origin,
    required LatLng destination,
    List<LatLng>? waypoints,
  });

  Future<double> calculateDistance(LatLng point1, LatLng point2);
}

class MapRepositoryImpl implements MapRepository {
  final String googleApiKey;
  late final PolylinePoints polylinePoints;

  MapRepositoryImpl({required this.googleApiKey}) {
    polylinePoints = PolylinePoints(apiKey: googleApiKey);
  }

  @override
  Future<List<LatLng>> getRoute({
    required LatLng origin,
    required LatLng destination,
    List<LatLng>? waypoints,
  }) async {
    try {
      final waypointsList = waypoints
          ?.map((point) => PolylineWayPoint(
                location: '${point.latitude},${point.longitude}',
              ))
          .toList();

      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        request: PolylineRequest(
          origin: PointLatLng(origin.latitude, origin.longitude),
          destination: PointLatLng(destination.latitude, destination.longitude),
          mode: TravelMode.driving,
          wayPoints: waypointsList ?? [],
        ),
      );

      if (result.points.isNotEmpty) {
        return result.points
            .map((point) => LatLng(point.latitude, point.longitude))
            .toList();
      }

      throw Exception('No route found');
    } catch (e) {
      throw Exception('Failed to get route: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getRouteDetails({
    required LatLng origin,
    required LatLng destination,
    List<LatLng>? waypoints,
  }) async {
    try {
      String waypointsStr = '';
      if (waypoints != null && waypoints.isNotEmpty) {
        waypointsStr = '&waypoints=' +
            waypoints
                .map((point) => '${point.latitude},${point.longitude}')
                .join('|');
      }

      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/directions/json?'
        'origin=${origin.latitude},${origin.longitude}'
        '&destination=${destination.latitude},${destination.longitude}'
        '$waypointsStr'
        '&key=$googleApiKey',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'OK' && data['routes'].isNotEmpty) {
          final route = data['routes'][0];
          final leg = route['legs'][0];

          return {
            'distance': leg['distance']['value'] / 1000, // Convert to km
            'distance_text': leg['distance']['text'],
            'duration': leg['duration']['value'] / 60, // Convert to minutes
            'duration_text': leg['duration']['text'],
            'polyline': route['overview_polyline']['points'],
          };
        }

        throw Exception('No route found');
      }

      throw Exception('Failed to fetch route details');
    } catch (e) {
      throw Exception('Failed to get route details: $e');
    }
  }

  @override
  Future<double> calculateDistance(LatLng point1, LatLng point2) async {
    try {
      // Using Haversine formula for distance calculation
      const double earthRadius = 6371; // km
      const double pi = 3.14159265359;

      double lat1Rad = point1.latitude * (pi / 180);
      double lat2Rad = point2.latitude * (pi / 180);
      double deltaLat = (point2.latitude - point1.latitude) * (pi / 180);
      double deltaLng = (point2.longitude - point1.longitude) * (pi / 180);

      double a = _sin(deltaLat / 2) * _sin(deltaLat / 2) +
          cos(lat1Rad) * cos(lat2Rad) *
          _sin(deltaLng / 2) * _sin(deltaLng / 2);

      double c = 2 * asin(sqrt(a));

      return earthRadius * c;
    } catch (e) {
      throw Exception('Failed to calculate distance: $e');
    }
  }

  double _sin(double value) {
    return value - (value * value * value) / 6 + 
           (value * value * value * value * value) / 120;
  }
}
