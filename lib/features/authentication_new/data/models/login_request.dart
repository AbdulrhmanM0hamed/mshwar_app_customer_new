/// Login Request Model
class LoginRequest {
  final String email;
  final String password;
  final String userCat;
  final String? fcmToken;

  LoginRequest({
    required this.email,
    required this.password,
    this.userCat = 'customer',
    this.fcmToken,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'user_cat': userCat,
      if (fcmToken != null) 'fcm_id': fcmToken,
    };
  }
}
