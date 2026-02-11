import 'package:equatable/equatable.dart';
import '../../../data/models/ride_model.dart';

/// Active Ride States
abstract class ActiveRideState extends Equatable {
  const ActiveRideState();

  @override
  List<Object?> get props => [];
}

class ActiveRideInitial extends ActiveRideState {}

class ActiveRideLoading extends ActiveRideState {}

class ActiveRideLoaded extends ActiveRideState {
  final List<RideModel> rides;

  const ActiveRideLoaded(this.rides);

  @override
  List<Object?> get props => [rides];
}

class ActiveRideEmpty extends ActiveRideState {}

class ActiveRideError extends ActiveRideState {
  final String message;

  const ActiveRideError(this.message);

  @override
  List<Object?> get props => [message];
}

class RideDetailsLoading extends ActiveRideState {}

class RideDetailsLoaded extends ActiveRideState {
  final RideModel ride;

  const RideDetailsLoaded(this.ride);

  @override
  List<Object?> get props => [ride];
}

class RideDetailsError extends ActiveRideState {
  final String message;

  const RideDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}

class RideCancelling extends ActiveRideState {}

class RideCancelled extends ActiveRideState {
  final String rideId;

  const RideCancelled(this.rideId);

  @override
  List<Object?> get props => [rideId];
}

class RideCancelError extends ActiveRideState {
  final String message;

  const RideCancelError(this.message);

  @override
  List<Object?> get props => [message];
}

class DriverLocationLoading extends ActiveRideState {}

class DriverLocationLoaded extends ActiveRideState {
  final DriverLocationUpdate location;

  const DriverLocationLoaded(this.location);

  @override
  List<Object?> get props => [location];
}

class DriverLocationError extends ActiveRideState {
  final String message;

  const DriverLocationError(this.message);

  @override
  List<Object?> get props => [message];
}
