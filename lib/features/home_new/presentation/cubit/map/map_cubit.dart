import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../data/repositories/map_repository.dart';
import 'map_state.dart';

class MapCubit extends Cubit<MapState> {
  final MapRepository repository;
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  List<LatLng> _polylinePoints = [];
  Map<String, dynamic>? _routeDetails;

  MapCubit({required this.repository}) : super(MapInitial());

  GoogleMapController? get mapController => _mapController;
  Set<Marker> get markers => _markers;
  List<LatLng> get polylinePoints => _polylinePoints;
  Map<String, dynamic>? get routeDetails => _routeDetails;

  void onMapCreated(GoogleMapController controller, LatLng initialPosition) {
    _mapController = controller;
    emit(MapReady(controller: controller, initialPosition: initialPosition));
  }

  Future<void> drawRoute({
    required LatLng origin,
    required LatLng destination,
    List<LatLng>? waypoints,
  }) async {
    try {
      emit(MapRouteCalculating());

      // Get route polyline
      _polylinePoints = await repository.getRoute(
        origin: origin,
        destination: destination,
        waypoints: waypoints,
      );

      // Get route details (distance, duration)
      _routeDetails = await repository.getRouteDetails(
        origin: origin,
        destination: destination,
        waypoints: waypoints,
      );

      // Create markers for origin and destination
      _markers = {
        Marker(
          markerId: const MarkerId('origin'),
          position: origin,
          infoWindow: const InfoWindow(title: 'Pickup'),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
        ),
        Marker(
          markerId: const MarkerId('destination'),
          position: destination,
          infoWindow: const InfoWindow(title: 'Destination'),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueRed,
          ),
        ),
      };

      // Add waypoint markers if any
      if (waypoints != null) {
        for (int i = 0; i < waypoints.length; i++) {
          _markers.add(
            Marker(
              markerId: MarkerId('waypoint_$i'),
              position: waypoints[i],
              infoWindow: InfoWindow(title: 'Stop ${i + 1}'),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueOrange,
              ),
            ),
          );
        }
      }

      emit(MapRouteDrawn(
        polylinePoints: _polylinePoints,
        routeDetails: _routeDetails!,
        markers: _markers,
      ));

      // Animate camera to show entire route
      if (_mapController != null && _polylinePoints.isNotEmpty) {
        _fitBoundsToRoute();
      }
    } catch (e) {
      emit(MapError(e.toString()));
    }
  }

  void addMarker(Marker marker) {
    _markers.add(marker);
    emit(MapMarkersUpdated(_markers));
  }

  void removeMarker(String markerId) {
    _markers.removeWhere((marker) => marker.markerId.value == markerId);
    emit(MapMarkersUpdated(_markers));
  }

  void clearMarkers() {
    _markers.clear();
    emit(MapMarkersUpdated(_markers));
  }

  void clearRoute() {
    _polylinePoints.clear();
    _routeDetails = null;
    _markers.clear();
    emit(MapInitial());
  }

  Future<void> animateCamera(LatLng target, {double zoom = 14.0}) async {
    if (_mapController != null) {
      emit(MapCameraMoving(target));
      await _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: target, zoom: zoom),
        ),
      );
    }
  }

  void _fitBoundsToRoute() {
    if (_mapController == null || _polylinePoints.isEmpty) return;

    double minLat = _polylinePoints.first.latitude;
    double maxLat = _polylinePoints.first.latitude;
    double minLng = _polylinePoints.first.longitude;
    double maxLng = _polylinePoints.first.longitude;

    for (LatLng point in _polylinePoints) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    _mapController!.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(minLat, minLng),
          northeast: LatLng(maxLat, maxLng),
        ),
        100, // padding
      ),
    );
  }

  void reset() {
    _markers.clear();
    _polylinePoints.clear();
    _routeDetails = null;
    emit(MapInitial());
  }

  @override
  Future<void> close() {
    _mapController?.dispose();
    return super.close();
  }
}
