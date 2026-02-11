import 'package:equatable/equatable.dart';
import '../../../data/models/ride_model.dart';

/// Ride History States
abstract class RideHistoryState extends Equatable {
  const RideHistoryState();

  @override
  List<Object?> get props => [];
}

class RideHistoryInitial extends RideHistoryState {}

class RideHistoryLoading extends RideHistoryState {}

class RideHistoryLoaded extends RideHistoryState {
  final List<RideModel> rides;
  final bool hasMore;
  final int currentPage;

  const RideHistoryLoaded({
    required this.rides,
    this.hasMore = false,
    this.currentPage = 1,
  });

  @override
  List<Object?> get props => [rides, hasMore, currentPage];
}

class RideHistoryEmpty extends RideHistoryState {}

class RideHistoryError extends RideHistoryState {
  final String message;

  const RideHistoryError(this.message);

  @override
  List<Object?> get props => [message];
}

class RideHistoryLoadingMore extends RideHistoryState {
  final List<RideModel> currentRides;

  const RideHistoryLoadingMore(this.currentRides);

  @override
  List<Object?> get props => [currentRides];
}
