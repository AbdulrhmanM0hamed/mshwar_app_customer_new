import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class MapState extends Equatable {
  const MapState();

  @override
  List<Object?> get props => [];
}

class MapInitial extends MapState {}

class MapLoading extends MapState {}

class MapReady extends MapState {
  final GoogleMapController controller;
  final LatLng initialPosition;

  const MapReady({
    required this.controller,
    required this.initialPosition,
  });

  @override
  List<Object?> get props => [controller, initialPosition];
}

class MapRouteCalculating extends MapState {}

class MapRouteDrawn extends MapState {
  final List<LatLng> polylinePoints;
  final Map<String, dynamic> routeDetails;
  final Set<Marker> markers;

  const MapRouteDrawn({
    required this.polylinePoints,
    required this.routeDetails,
    required this.markers,
  });

  @override
  List<Object?> get props => [polylinePoints, routeDetails, markers];
}

class MapMarkersUpdated extends MapState {
  final Set<Marker> markers;

  const MapMarkersUpdated(this.markers);

  @override
  List<Object?> get props => [markers];
}

class MapCameraMoving extends MapState {
  final LatLng target;

  const MapCameraMoving(this.target);

  @override
  List<Object?> get props => [target];
}

class MapError extends MapState {
  final String message;

  const MapError(this.message);

  @override
  List<Object?> get props => [message];
}
