import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../cubit/map/map_cubit.dart';
import '../cubit/map/map_state.dart';
import '../cubit/location/location_cubit.dart';
import '../cubit/location/location_state.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({super.key});

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  GoogleMapController? _mapController;

  @override
  Widget build(BuildContext context) {
    return BlocListener<LocationCubit, LocationState>(
      listener: (context, state) {
        if (state is LocationLoaded && _mapController != null) {
          // Animate to current location
          _mapController!.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: LatLng(
                  state.location.latitude,
                  state.location.longitude,
                ),
                zoom: 15.0,
              ),
            ),
          );
        }
      },
      child: BlocBuilder<MapCubit, MapState>(
        builder: (context, state) {
          Set<Polyline> polylines = {};
          
          // Create polyline if route is drawn
          if (state is MapRouteDrawn && state.polylinePoints.isNotEmpty) {
            polylines.add(
              Polyline(
                polylineId: const PolylineId('route'),
                points: state.polylinePoints,
                color: const Color(0xFF018484),
                width: 5,
              ),
            );
          }

          return GoogleMap(
            zoomControlsEnabled: false,
            myLocationButtonEnabled: false,
            myLocationEnabled: true,
            compassEnabled: false,
            mapToolbarEnabled: false,
            initialCameraPosition: const CameraPosition(
              target: LatLng(29.3117, 47.4818), // Kuwait City
              zoom: 12,
            ),
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
              context.read<MapCubit>().onMapCreated(
                controller,
                const LatLng(29.3117, 47.4818),
              );
            },
            markers: state is MapMarkersUpdated
                ? state.markers
                : state is MapRouteDrawn
                    ? state.markers
                    : {},
            polylines: polylines,
            onTap: (LatLng position) {
              // Handle map tap if needed
            },
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}
