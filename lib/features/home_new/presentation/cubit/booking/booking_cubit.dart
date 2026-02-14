import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../data/models/location_model.dart';
import '../../../data/models/vehicle_category_model.dart';

class BookingState extends Equatable {
  final LocationModel? departure;
  final LocationModel? destination;
  final List<LocationModel> stops;
  final VehicleCategoryModel? selectedVehicle;
  final double distance;
  final String duration;
  final List<LatLng> polylinePoints;

  const BookingState({
    this.departure,
    this.destination,
    this.stops = const [],
    this.selectedVehicle,
    this.distance = 0.0,
    this.duration = '',
    this.polylinePoints = const [],
  });

  BookingState copyWith({
    LocationModel? departure,
    LocationModel? destination,
    List<LocationModel>? stops,
    VehicleCategoryModel? selectedVehicle,
    double? distance,
    String? duration,
    List<LatLng>? polylinePoints,
  }) {
    return BookingState(
      departure: departure ?? this.departure,
      destination: destination ?? this.destination,
      stops: stops ?? this.stops,
      selectedVehicle: selectedVehicle ?? this.selectedVehicle,
      distance: distance ?? this.distance,
      duration: duration ?? this.duration,
      polylinePoints: polylinePoints ?? this.polylinePoints,
    );
  }

  @override
  List<Object?> get props => [
        departure,
        destination,
        stops,
        selectedVehicle,
        distance,
        duration,
        polylinePoints,
      ];
}

class BookingCubit extends Cubit<BookingState> {
  BookingCubit() : super(const BookingState());

  void updateDeparture(LocationModel departure) {
    emit(state.copyWith(departure: departure));
  }

  void updateDestination(LocationModel destination) {
    emit(state.copyWith(destination: destination));
  }

  void addStop(LocationModel stop) {
    final updatedStops = List<LocationModel>.from(state.stops)..add(stop);
    emit(state.copyWith(stops: updatedStops));
  }

  void removeStop(int index) {
    final updatedStops = List<LocationModel>.from(state.stops)..removeAt(index);
    emit(state.copyWith(stops: updatedStops));
  }

  void updateStops(List<LocationModel> stops) {
    emit(state.copyWith(stops: stops));
  }

  void updateVehicle(VehicleCategoryModel vehicle) {
    emit(state.copyWith(selectedVehicle: vehicle));
  }

  void setSelectedVehicle(VehicleCategoryModel vehicle) {
    updateVehicle(vehicle);
  }

  void updateRouteDetails({
    required double distance,
    required String duration,
    required List<LatLng> polylinePoints,
  }) {
    emit(state.copyWith(
      distance: distance,
      duration: duration,
      polylinePoints: polylinePoints,
    ));
  }

  void clearBooking() {
    emit(const BookingState());
  }
}
