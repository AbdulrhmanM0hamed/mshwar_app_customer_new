import 'package:cabme/features/settings_new/data/repositories/settings_repository.dart';
import 'package:cabme/features/settings_new/presentation/cubit/contact_us/contact_us_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactUsCubit extends Cubit<ContactUsState> {
  final SettingsRepository repository;

  ContactUsCubit({required this.repository}) : super(ContactUsInitial());

  Future<void> submitContactUs({
    required String name,
    required String email,
    required String subject,
    required String message,
  }) async {
    emit(ContactUsLoading());
    try {
      final response = await repository.contactUs(
        name: name,
        email: email,
        subject: subject,
        message: message,
      );

      // Check response format. Old API usually returns {success: "success", ...} or {error: ...}
      if (response['success'] == 'success') {
        emit(ContactUsSuccess());
      } else {
        emit(ContactUsError(response['error'] ?? 'Unknown error occurred'));
      }
    } catch (e) {
      emit(ContactUsError(e.toString()));
    }
  }
}
