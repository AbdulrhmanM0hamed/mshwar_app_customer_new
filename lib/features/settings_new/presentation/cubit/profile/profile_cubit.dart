import 'dart:convert';
import 'dart:io';

import 'package:cabme/core/constant/constant.dart';
import 'package:cabme/features/settings_new/data/repositories/settings_repository.dart';
import 'package:cabme/features/settings_new/presentation/cubit/profile/profile_state.dart';
import 'package:cabme/core/utils/Preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final SettingsRepository repository;

  ProfileCubit({required this.repository}) : super(ProfileInitial());

  void loadProfile() {
    emit(ProfileLoading());
    try {
      final user = Constant.getUserData();
      emit(ProfileLoaded(user));
    } catch (e) {
      emit(const ProfileError('Failed to load user data'));
    }
  }

  Future<void> updateProfile({
    required String firstName,
    required String lastName,
    required String phone,
    required String email,
    File? image,
    String? password,
  }) async {
    emit(ProfileUpdating());
    try {
      final updatedUser = await repository.updateProfile(
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        email: email,
        image: image,
        password: password,
      );

      // Update local storage
      await Preferences.setString(
          Preferences.user, jsonEncode(updatedUser.toJson()));

      // Update User Model in Constant if applicable (though Constant usually reads directly)

      emit(ProfileUpdated(updatedUser));
      emit(ProfileLoaded(updatedUser));
    } catch (e) {
      emit(ProfileError(e.toString()));
      loadProfile();
    }
  }

  Future<void> updatePassword(String currentPassword, String newPassword,
      String confirmPassword) async {
    emit(PasswordUpdating());
    try {
      if (newPassword != confirmPassword) {
        throw Exception('Passwords do not match');
      }

      final body = {
        'anc_mdp': currentPassword,
        'new_mdp': newPassword,
        'user_cat': 'user_app',
        'id_user': Preferences.getInt(Preferences.userId).toString()
      };

      final response = await repository.updatePassword(body);

      if (response['success'] == 'success') {
        emit(PasswordUpdated());
        loadProfile();
      } else {
        throw Exception(response['error'] ?? 'Failed to update password');
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
      loadProfile();
    }
  }

  Future<void> deleteAccount() async {
    emit(ProfileLoading());
    try {
      final userId = Preferences.getInt(Preferences.userId).toString();
      await repository.deleteAccount(userId);
      emit(AccountDeleted());
    } catch (e) {
      emit(ProfileError(e.toString()));
      loadProfile();
    }
  }
}
