import 'user_model.dart';

/// Login Response Model
class LoginResponse {
  final String success;
  final String? error;
  final String? message;
  final UserModel? user;

  LoginResponse({
    required this.success,
    this.error,
    this.message,
    this.user,
  });

  bool get isSuccess => success.toLowerCase() == 'success';

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success']?.toString() ?? 'Failed',
      error: json['error']?.toString(),
      message: json['message']?.toString(),
      user: json['data'] != null ? UserModel.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'error': error,
      'message': message,
      'data': user?.toJson(),
    };
  }
}
