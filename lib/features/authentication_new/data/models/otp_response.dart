/// OTP Response Model
class OtpResponse {
  final String success;
  final String? error;
  final String? message;
  final dynamic data;

  OtpResponse({
    required this.success,
    this.error,
    this.message,
    this.data,
  });

  bool get isSuccess => success.toLowerCase() == 'success';

  factory OtpResponse.fromJson(Map<String, dynamic> json) {
    return OtpResponse(
      success: json['success']?.toString() ?? 'Failed',
      error: json['error']?.toString(),
      message: json['message']?.toString(),
      data: json['data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'error': error,
      'message': message,
      'data': data,
    };
  }
}
