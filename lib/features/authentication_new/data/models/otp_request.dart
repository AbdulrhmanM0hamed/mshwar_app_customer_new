/// OTP Request Model
class OtpRequest {
  final String phone;
  final String otp;
  final String userCat;

  OtpRequest({
    required this.phone,
    required this.otp,
    this.userCat = 'customer',
  });

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'otp': otp,
      'user_cat': userCat,
    };
  }
}
