import 'package:equatable/equatable.dart';
import '../../../data/models/complaint_model.dart';

/// Complaint States
abstract class ComplaintState extends Equatable {
  const ComplaintState();

  @override
  List<Object?> get props => [];
}

class ComplaintInitial extends ComplaintState {}

class ComplaintSubmitting extends ComplaintState {}

class ComplaintSubmitted extends ComplaintState {
  final ComplaintModel complaint;

  const ComplaintSubmitted(this.complaint);

  @override
  List<Object?> get props => [complaint];
}

class ComplaintSubmitError extends ComplaintState {
  final String message;

  const ComplaintSubmitError(this.message);

  @override
  List<Object?> get props => [message];
}

class ComplaintsLoading extends ComplaintState {}

class ComplaintsLoaded extends ComplaintState {
  final List<ComplaintModel> complaints;

  const ComplaintsLoaded(this.complaints);

  @override
  List<Object?> get props => [complaints];
}

class ComplaintsEmpty extends ComplaintState {}

class ComplaintsError extends ComplaintState {
  final String message;

  const ComplaintsError(this.message);

  @override
  List<Object?> get props => [message];
}

class ComplaintDetailsLoading extends ComplaintState {}

class ComplaintDetailsLoaded extends ComplaintState {
  final ComplaintModel complaint;

  const ComplaintDetailsLoaded(this.complaint);

  @override
  List<Object?> get props => [complaint];
}

class ComplaintDetailsError extends ComplaintState {
  final String message;

  const ComplaintDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}
