import 'dart:convert';
import 'package:cabme/core(new)/errors/api_error_type.dart';
import 'package:cabme/core(new)/errors/api_exception.dart';
import 'package:cabme/core(new)/network/api_service.dart';
import 'package:cabme/core(new)/network/api_helper.dart';
import 'package:cabme/core(new)/network/app_state_service.dart';
import 'package:cabme/core/utils/Preferences.dart';
import 'package:cabme/service/api.dart';
import '../models/forgot_password_request.dart';
import '../models/login_request.dart';
import '../models/login_response.dart';
import '../models/otp_request.dart';
import '../models/otp_response.dart';
import '../models/phone_check_request.dart';
import '../models/register_request.dart';
import '../models/register_response.dart';
import '../models/user_model.dart';

/// Auth Repository Interface
abstract class AuthRepository {
  Future<ApiResult<LoginResponse>> login(LoginRequest request);
  Future<ApiResult<bool>> checkPhoneExists(PhoneCheckRequest request);
  Future<ApiResult<UserModel>> getUserByPhone(PhoneCheckRequest request);
  Future<ApiResult<RegisterResponse>> register(RegisterRequest request);
  Future<ApiResult<OtpResponse>> sendOtp(String phone);
  Future<ApiResult<OtpResponse>> verifyOtp(OtpRequest request);
  Future<ApiResult<OtpResponse>> resendOtp(String phone);
  Future<ApiResult<void>> sendResetPasswordOtp(String email);
  Future<ApiResult<void>> resetPassword(ForgotPasswordRequest request);
  Future<void> saveUserData(UserModel user);
  Future<void> logout();
}

/// Auth Repository Implementation
class AuthRepositoryImpl implements AuthRepository {
  final ApiService _apiService;
  final AppStateService _appStateService;

  AuthRepositoryImpl(this._apiService, this._appStateService);

  @override
  Future<ApiResult<LoginResponse>> login(LoginRequest request) async {
    try {
      final result = await _apiService.safePost<Map<String, dynamic>>(
        API.userLogin,
        data: request.toJson(),
      );

      return result.when(
        success: (data) {
          final response = LoginResponse.fromJson(data);
          if (response.isSuccess && response.user != null) {
            saveUserData(response.user!);
            return ApiResult.success(response);
          } else {
            return ApiResult.failure(ApiException(
              errorType: ApiErrorType.badRequest,
              message: response.error ?? 'Login failed',
            ));
          }
        },
        failure: (error) => ApiResult.failure(error),
      );
    } catch (e) {
      return ApiResult.failure(ApiException(
        errorType: ApiErrorType.unknown,
        message: e.toString(),
      ));
    }
  }

  @override
  Future<ApiResult<bool>> checkPhoneExists(PhoneCheckRequest request) async {
    try {
      final result = await _apiService.safePost<Map<String, dynamic>>(
        API.getExistingUserOrNot,
        data: request.toJson(),
      );

      return result.when(
        success: (data) {
          if (data['success'] == 'success') {
            return ApiResult.success(data['data'] == true);
          } else {
            return ApiResult.failure(ApiException(
              errorType: ApiErrorType.badRequest,
              message: data['error']?.toString() ?? 'Failed to check phone',
            ));
          }
        },
        failure: (error) => ApiResult.failure(error),
      );
    } catch (e) {
      return ApiResult.failure(ApiException(
        errorType: ApiErrorType.unknown,
        message: e.toString(),
      ));
    }
  }

  @override
  Future<ApiResult<UserModel>> getUserByPhone(
      PhoneCheckRequest request) async {
    try {
      final result = await _apiService.safePost<Map<String, dynamic>>(
        API.getProfileByPhone,
        data: request.toJson(),
      );

      return result.when(
        success: (data) {
          if (data['success'] == 'success') {
            final user = UserModel.fromJson(data['data']);
            saveUserData(user);
            return ApiResult.success(user);
          } else {
            return ApiResult.failure(ApiException(
              errorType: ApiErrorType.badRequest,
              message: data['error']?.toString() ?? 'User not found',
            ));
          }
        },
        failure: (error) => ApiResult.failure(error),
      );
    } catch (e) {
      return ApiResult.failure(ApiException(
        errorType: ApiErrorType.unknown,
        message: e.toString(),
      ));
    }
  }

  @override
  Future<ApiResult<RegisterResponse>> register(RegisterRequest request) async {
    try {
      final result = await _apiService.safePost<Map<String, dynamic>>(
        API.userSignUP,
        data: request.toJson(),
      );

      return result.when(
        success: (data) {
          final response = RegisterResponse.fromJson(data);
          if (response.isSuccess && response.user != null) {
            saveUserData(response.user!);
            return ApiResult.success(response);
          } else {
            return ApiResult.failure(ApiException(
              errorType: ApiErrorType.badRequest,
              message: response.error ?? 'Registration failed',
            ));
          }
        },
        failure: (error) => ApiResult.failure(error),
      );
    } catch (e) {
      return ApiResult.failure(ApiException(
        errorType: ApiErrorType.unknown,
        message: e.toString(),
      ));
    }
  }

  @override
  Future<ApiResult<OtpResponse>> sendOtp(String phone) async {
    try {
      final result = await _apiService.safePost<Map<String, dynamic>>(
        API.sendOtp,
        data: {'phone': phone},
      );

      return result.when(
        success: (data) {
          final response = OtpResponse.fromJson(data);
          return ApiResult.success(response);
        },
        failure: (error) => ApiResult.failure(error),
      );
    } catch (e) {
      return ApiResult.failure(ApiException(
        errorType: ApiErrorType.unknown,
        message: e.toString(),
      ));
    }
  }

  @override
  Future<ApiResult<OtpResponse>> verifyOtp(OtpRequest request) async {
    try {
      final result = await _apiService.safePost<Map<String, dynamic>>(
        API.verifyOtp,
        data: request.toJson(),
      );

      return result.when(
        success: (data) {
          final response = OtpResponse.fromJson(data);
          return ApiResult.success(response);
        },
        failure: (error) => ApiResult.failure(error),
      );
    } catch (e) {
      return ApiResult.failure(ApiException(
        errorType: ApiErrorType.unknown,
        message: e.toString(),
      ));
    }
  }

  @override
  Future<ApiResult<OtpResponse>> resendOtp(String phone) async {
    try {
      final result = await _apiService.safePost<Map<String, dynamic>>(
        API.resendOtp,
        data: {'phone': phone},
      );

      return result.when(
        success: (data) {
          final response = OtpResponse.fromJson(data);
          return ApiResult.success(response);
        },
        failure: (error) => ApiResult.failure(error),
      );
    } catch (e) {
      return ApiResult.failure(ApiException(
        errorType: ApiErrorType.unknown,
        message: e.toString(),
      ));
    }
  }

  @override
  Future<ApiResult<void>> sendResetPasswordOtp(String email) async {
    try {
      final result = await _apiService.safePost<Map<String, dynamic>>(
        API.sendResetPasswordOtp,
        data: {'email': email},
      );

      return result.when(
        success: (_) => ApiResult.success(null),
        failure: (error) => ApiResult.failure(error),
      );
    } catch (e) {
      return ApiResult.failure(ApiException(
        errorType: ApiErrorType.unknown,
        message: e.toString(),
      ));
    }
  }

  @override
  Future<ApiResult<void>> resetPassword(ForgotPasswordRequest request) async {
    try {
      final result = await _apiService.safePost<Map<String, dynamic>>(
        API.resetPasswordOtp,
        data: request.toJson(),
      );

      return result.when(
        success: (_) => ApiResult.success(null),
        failure: (error) => ApiResult.failure(error),
      );
    } catch (e) {
      return ApiResult.failure(ApiException(
        errorType: ApiErrorType.unknown,
        message: e.toString(),
      ));
    }
  }

  @override
  Future<void> saveUserData(UserModel user) async {
    // Save to Preferences
    Preferences.setInt(Preferences.userId, int.parse(user.id));
    Preferences.setString(Preferences.user, jsonEncode(user.toJson()));
    
    if (user.accessToken != null) {
      Preferences.setString(Preferences.accesstoken, user.accessToken!);
      API.header['accesstoken'] = user.accessToken!;
    }
    
    if (user.adminCommission != null) {
      Preferences.setString(
          Preferences.admincommission, user.adminCommission!);
    }
    
    Preferences.setBoolean(Preferences.isLogin, true);

    // Save to AppStateService
    await _appStateService.setLoggedIn(true);
    if (user.accessToken != null) {
      await _appStateService.saveTokens(
        accessToken: user.accessToken!,
        refreshToken: user.accessToken!, // Using same token as refresh
        accessTokenExpiresAt: DateTime.now().add(const Duration(days: 30)).toIso8601String(),
        refreshTokenExpiresAt: DateTime.now().add(const Duration(days: 60)).toIso8601String(),
      );
    }
  }

  @override
  Future<void> logout() async {
    // Clear Preferences
    Preferences.setBoolean(Preferences.isLogin, false);
    Preferences.setString(Preferences.userId, '');
    Preferences.setString(Preferences.user, '');
    Preferences.setString(Preferences.accesstoken, '');
    Preferences.setString(Preferences.admincommission, '');
    
    // Clear AppStateService
    await _appStateService.setLoggedIn(false);
    await _appStateService.clearTokens();
    
    // Clear API header
    API.header.remove('accesstoken');
  }
}
