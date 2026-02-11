/// Phone Check Request Model
class PhoneCheckRequest {
  final String phone;
  final String userCat;
  final String? email;
  final String? loginType;

  PhoneCheckRequest({
    required this.phone,
    this.userCat = 'customer',
    this.email,
    this.loginType,
  });

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'user_cat': userCat,
      if (email != null) 'email': email,
      if (loginType != null) 'login_type': loginType,
    };
  }
}
