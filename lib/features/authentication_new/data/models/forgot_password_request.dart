/// Forgot Password Request Model
class ForgotPasswordRequest {
  final String email;
  final String? otp;
  final String? newPassword;

  ForgotPasswordRequest({
    required this.email,
    this.otp,
    this.newPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      if (otp != null) 'otp': otp,
      if (newPassword != null) 'password': newPassword,
    };
  }
}
