import 'dart:io';

import 'package:cabme/core(new)/network/api_service.dart';
import 'package:cabme/features/settings_new/data/models/settings_model.dart';
import 'package:cabme/features/authentication/model/user_model.dart';
import 'package:cabme/service/api.dart';
import 'package:cabme/core/utils/Preferences.dart';

abstract class SettingsRepository {
  Future<SettingsModel> getSettings();
  
  Future<UserModel> updateProfile({
    required String firstName,
    required String lastName,
    required String phone,
    required String email,
    File? image,
    String? password,
  });
  
  Future<Map<String, dynamic>> updatePassword(Map<String, String> bodyParams);
  
  Future<Map<String, dynamic>> deleteAccount(String userId);

  Future<Map<String, dynamic>> contactUs({
    required String name,
    required String email,
    required String subject,
    required String message,
  });

  Future<String> getPrivacyPolicy();
  Future<String> getTermsOfService();
}

class SettingsRepositoryImpl implements SettingsRepository {
  final ApiService apiService;

  SettingsRepositoryImpl({required this.apiService});

  @override
  Future<SettingsModel> getSettings() async {
    return await apiService.get(
      API.settings,
      fromJson: (json) => SettingsModel.fromJson(json),
    );
  }

  @override
  Future<UserModel> updateProfile({
    required String firstName,
    required String lastName,
    required String phone,
    required String email,
    File? image,
    String? password,
  }) async {
    final userId = Preferences.getInt(Preferences.userId).toString();
    
    Map<String, dynamic> data = {
      'nom': lastName,
      'prenom': firstName,
      'id_user': userId,
      'email': email,
      'phone': phone,
    };

    if (password != null && password.isNotEmpty) {
      data['mdp'] = password;
    }

    Map<String, File>? files;
    if (image != null) {
      files = {'image': image};
    }

    // Use safePostMultipart to handle file upload correctly with potentially multipart response
    final result = await apiService.safePostMultipart(
      API.editProfile,
      data: data,
      files: files,
      fromJson: (json) => UserModel.fromJson(json),
    );
    
    if (result.success && result.data != null) {
      return result.data!;
    } else {
      throw Exception(result.message ?? 'Failed to update profile');
    }
  }

  @override
  Future<Map<String, dynamic>> updatePassword(Map<String, String> bodyParams) async {
    final result = await apiService.post(
      API.changePassword,
      data: bodyParams,
    );
    return result as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> deleteAccount(String userId) async {
    // API.deleteUser returns URL with query params
    // We append user_cat=customer as seen in old controller
    final url = '${API.deleteUser(userId)}&user_cat=customer';
    final result = await apiService.get(url);
    return result as Map<String, dynamic>;
  }
  
  @override
  Future<Map<String, dynamic>> contactUs({
    required String name,
    required String email,
    required String subject,
    required String message,
  }) async {
    final data = {
        'nom': name,
        'email': email,
        'subject': subject,
        'message': message,
    };
    final result = await apiService.post(
      API.contactUs,
      data: data,
    );
    return result as Map<String, dynamic>;
  }

  @override
  Future<String> getPrivacyPolicy() async {
    try {
      final response = await apiService.get(API.privacyPolicy);
      if (response != null && response['success'] == 'success') {
        return response['data']['privacy_policy']?.toString() ?? '';
      }
    } catch (e) {
      // Log error
    }
    return '';
  }

  @override
  Future<String> getTermsOfService() async {
    try {
      final response = await apiService.get(API.termsOfCondition);
      if (response != null && response['success'] == 'success') {
        return response['data']['terms']?.toString() ?? '';
      }
    } catch (e) {
      // Log error
    }
    return '';
  }
}
