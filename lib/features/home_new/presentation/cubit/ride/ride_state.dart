import 'package:equatable/equatable.dart';
import '../../../data/models/price_calculation_model.dart';
import '../../../data/models/ride_response_model.dart';
import '../../../data/models/booking_confirmation_model.dart';
import '../../../data/models/driver_model.dart';

abstract class RideState extends Equatable {
  const RideState();

  @override
  List<Object?> get props => [];
}

class RideInitial extends RideState {}

class RideCalculating extends RideState {}

class RidePriceCalculated extends RideState {
  final PriceCalculationModel priceCalculation;

  const RidePriceCalculated(this.priceCalculation);

  @override
  List<Object?> get props => [priceCalculation];
}

class RideFindingDrivers extends RideState {}

class RideDriversFound extends RideState {
  final List<DriverModel> drivers;

  const RideDriversFound(this.drivers);

  @override
  List<Object?> get props => [drivers];
}

class RideNoDriversAvailable extends RideState {
  final String message;

  const RideNoDriversAvailable(this.message);

  @override
  List<Object?> get props => [message];
}

class RideBooking extends RideState {}

class RideBooked extends RideState {
  final RideResponseModel response;

  const RideBooked(this.response);

  @override
  List<Object?> get props => [response];
}

class RideConfirmed extends RideState {
  final BookingConfirmationModel confirmation;

  const RideConfirmed(this.confirmation);

  @override
  List<Object?> get props => [confirmation];
}

class RideCancelling extends RideState {}

class RideCancelled extends RideState {
  final String message;

  const RideCancelled(this.message);

  @override
  List<Object?> get props => [message];
}

class RideError extends RideState {
  final String message;

  const RideError(this.message);

  @override
  List<Object?> get props => [message];
}
