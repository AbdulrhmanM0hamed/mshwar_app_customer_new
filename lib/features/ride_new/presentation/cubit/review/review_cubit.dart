import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/review_repository.dart';
import '../../../data/models/review_model.dart';
import 'review_state.dart';

/// Review Cubit - Manages ride reviews
class ReviewCubit extends Cubit<ReviewState> {
  final ReviewRepository repository;

  ReviewCubit({required this.repository}) : super(ReviewInitial());

  /// Submit review
  Future<void> submitReview(ReviewRequest request) async {
    emit(ReviewSubmitting());
    try {
      final review = await repository.submitReview(request);
      emit(ReviewSubmitted(review));
    } catch (e) {
      emit(ReviewSubmitError(e.toString()));
    }
  }

  /// Load ride reviews
  Future<void> loadRideReviews(String rideId) async {
    emit(ReviewsLoading());
    try {
      final reviews = await repository.getRideReviews(rideId);
      
      if (reviews.isEmpty) {
        emit(ReviewsEmpty());
      } else {
        emit(ReviewsLoaded(reviews));
      }
    } catch (e) {
      emit(ReviewsError(e.toString()));
    }
  }

  /// Reset to initial state
  void reset() {
    emit(ReviewInitial());
  }
}
