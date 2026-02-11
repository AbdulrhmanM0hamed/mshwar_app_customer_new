/// User Model - represents user data from API
class UserModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String? phone;
  final String? loginType;
  final String? photo;
  final String? photoPath;
  final String status;
  final String? fcmId;
  final String? userCat;
  final String? accessToken;
  final String? adminCommission;
  final String? country;
  final String? gender;
  final String? age;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phone,
    this.loginType,
    this.photo,
    this.photoPath,
    required this.status,
    this.fcmId,
    this.userCat,
    this.accessToken,
    this.adminCommission,
    this.country,
    this.gender,
    this.age,
  });

  /// Full name getter
  String get fullName => '$firstName $lastName';

  /// Check if user has photo
  bool get hasPhoto => photo != null && photo!.isNotEmpty;

  /// Get photo URL
  String? get photoUrl => photoPath;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      firstName: json['nom']?.toString() ?? json['prenom']?.toString() ?? '',
      lastName: json['prenom']?.toString() ?? json['nom']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString(),
      loginType: json['login_type']?.toString(),
      photo: json['photo']?.toString(),
      photoPath: json['photo_path']?.toString(),
      status: json['statut']?.toString() ?? 'active',
      fcmId: json['fcm_id']?.toString(),
      userCat: json['user_cat']?.toString(),
      accessToken: json['accesstoken']?.toString(),
      adminCommission: json['admin_commission']?.toString(),
      country: json['country']?.toString(),
      gender: json['gender']?.toString(),
      age: json['age']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': firstName,
      'prenom': lastName,
      'email': email,
      'phone': phone,
      'login_type': loginType,
      'photo': photo,
      'photo_path': photoPath,
      'statut': status,
      'fcm_id': fcmId,
      'user_cat': userCat,
      'accesstoken': accessToken,
      'admin_commission': adminCommission,
      'country': country,
      'gender': gender,
      'age': age,
    };
  }

  /// Copy with method
  UserModel copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? loginType,
    String? photo,
    String? photoPath,
    String? status,
    String? fcmId,
    String? userCat,
    String? accessToken,
    String? adminCommission,
    String? country,
    String? gender,
    String? age,
  }) {
    return UserModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      loginType: loginType ?? this.loginType,
      photo: photo ?? this.photo,
      photoPath: photoPath ?? this.photoPath,
      status: status ?? this.status,
      fcmId: fcmId ?? this.fcmId,
      userCat: userCat ?? this.userCat,
      accessToken: accessToken ?? this.accessToken,
      adminCommission: adminCommission ?? this.adminCommission,
      country: country ?? this.country,
      gender: gender ?? this.gender,
      age: age ?? this.age,
    );
  }
}
