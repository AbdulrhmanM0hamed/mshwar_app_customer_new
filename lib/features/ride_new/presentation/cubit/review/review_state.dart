import 'package:equatable/equatable.dart';
import '../../../data/models/review_model.dart';

/// Review States
abstract class ReviewState extends Equatable {
  const ReviewState();

  @override
  List<Object?> get props => [];
}

class ReviewInitial extends ReviewState {}

class ReviewSubmitting extends ReviewState {}

class ReviewSubmitted extends ReviewState {
  final ReviewModel review;

  const ReviewSubmitted(this.review);

  @override
  List<Object?> get props => [review];
}

class ReviewSubmitError extends ReviewState {
  final String message;

  const ReviewSubmitError(this.message);

  @override
  List<Object?> get props => [message];
}

class ReviewsLoading extends ReviewState {}

class ReviewsLoaded extends ReviewState {
  final List<ReviewModel> reviews;

  const ReviewsLoaded(this.reviews);

  @override
  List<Object?> get props => [reviews];
}

class ReviewsEmpty extends ReviewState {}

class ReviewsError extends ReviewState {
  final String message;

  const ReviewsError(this.message);

  @override
  List<Object?> get props => [message];
}
