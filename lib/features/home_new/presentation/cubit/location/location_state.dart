import 'package:equatable/equatable.dart';
import '../../../data/models/location_model.dart';

abstract class LocationState extends Equatable {
  const LocationState();

  @override
  List<Object?> get props => [];
}

class LocationInitial extends LocationState {}

class LocationLoading extends LocationState {}

class LocationLoaded extends LocationState {
  final LocationModel location;

  const LocationLoaded(this.location);

  @override
  List<Object?> get props => [location];
}

class LocationSearching extends LocationState {}

class LocationSearchResults extends LocationState {
  final List<LocationModel> results;

  const LocationSearchResults(this.results);

  @override
  List<Object?> get props => [results];
}

class LocationError extends LocationState {
  final String message;

  const LocationError(this.message);

  @override
  List<Object?> get props => [message];
}

class LocationPermissionDenied extends LocationState {
  final String message;

  const LocationPermissionDenied(this.message);

  @override
  List<Object?> get props => [message];
}

class LocationServiceDisabled extends LocationState {
  final String message;

  const LocationServiceDisabled(this.message);

  @override
  List<Object?> get props => [message];
}
