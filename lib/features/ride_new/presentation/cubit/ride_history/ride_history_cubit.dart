import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/ride_repository.dart';
import 'ride_history_state.dart';

/// Ride History Cubit - Manages past rides with pagination
class RideHistoryCubit extends Cubit<RideHistoryState> {
  final RideRepository repository;
  static const int _pageSize = 20;

  RideHistoryCubit({required this.repository}) : super(RideHistoryInitial());

  /// Load ride history (first page)
  Future<void> loadRideHistory() async {
    emit(RideHistoryLoading());
    try {
      final rides = await repository.getRideHistory(page: 1, limit: _pageSize);
      
      if (rides.isEmpty) {
        emit(RideHistoryEmpty());
      } else {
        emit(RideHistoryLoaded(
          rides: rides,
          hasMore: rides.length >= _pageSize,
          currentPage: 1,
        ));
      }
    } catch (e) {
      emit(RideHistoryError(e.toString()));
    }
  }

  /// Load more rides (pagination)
  Future<void> loadMore() async {
    final currentState = state;
    if (currentState is! RideHistoryLoaded || !currentState.hasMore) {
      return;
    }

    emit(RideHistoryLoadingMore(currentState.rides));
    
    try {
      final nextPage = currentState.currentPage + 1;
      final newRides = await repository.getRideHistory(
        page: nextPage,
        limit: _pageSize,
      );
      
      final allRides = [...currentState.rides, ...newRides];
      
      emit(RideHistoryLoaded(
        rides: allRides,
        hasMore: newRides.length >= _pageSize,
        currentPage: nextPage,
      ));
    } catch (e) {
      emit(RideHistoryError(e.toString()));
    }
  }

  /// Refresh ride history
  Future<void> refresh() async {
    await loadRideHistory();
  }
}
