/// Register Request Model
class RegisterRequest {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String password;
  final String userCat;
  final String? loginType;
  final String? fcmToken;
  final String? country;

  RegisterRequest({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.password,
    this.userCat = 'customer',
    this.loginType = 'email',
    this.fcmToken,
    this.country,
  });

  Map<String, dynamic> toJson() {
    return {
      'firstname': firstName,
      'lastname': lastName,
      'email': email,
      'phone': phone,
      'password': password,
      'account_type': userCat,
      'login_type': loginType,
      if (fcmToken != null) 'fcm_id': fcmToken,
      if (country != null) 'country': country,
    };
  }
}
