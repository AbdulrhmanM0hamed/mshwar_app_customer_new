import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/complaint_repository.dart';
import '../../../data/models/complaint_model.dart';
import 'complaint_state.dart';

/// Complaint Cubit - Manages ride complaints
class ComplaintCubit extends Cubit<ComplaintState> {
  final ComplaintRepository repository;

  ComplaintCubit({required this.repository}) : super(ComplaintInitial());

  /// Submit complaint
  Future<void> submitComplaint(ComplaintRequest request) async {
    emit(ComplaintSubmitting());
    try {
      final complaint = await repository.submitComplaint(request);
      emit(ComplaintSubmitted(complaint));
    } catch (e) {
      emit(ComplaintSubmitError(e.toString()));
    }
  }

  /// Load user complaints
  Future<void> loadMyComplaints() async {
    emit(ComplaintsLoading());
    try {
      final complaints = await repository.getMyComplaints();
      
      if (complaints.isEmpty) {
        emit(ComplaintsEmpty());
      } else {
        emit(ComplaintsLoaded(complaints));
      }
    } catch (e) {
      emit(ComplaintsError(e.toString()));
    }
  }

  /// Load complaint details
  Future<void> loadComplaintDetails(String complaintId) async {
    emit(ComplaintDetailsLoading());
    try {
      final complaint = await repository.getComplaintDetails(complaintId);
      emit(ComplaintDetailsLoaded(complaint));
    } catch (e) {
      emit(ComplaintDetailsError(e.toString()));
    }
  }

  /// Reset to initial state
  void reset() {
    emit(ComplaintInitial());
  }

  /// Refresh complaints
  Future<void> refresh() async {
    await loadMyComplaints();
  }
}
