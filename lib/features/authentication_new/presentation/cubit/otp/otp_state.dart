import 'package:cabme/core(new)/errors/api_exception.dart';

abstract class OtpState {}

class OtpInitial extends OtpState {}

class OtpSendLoading extends OtpState {}

class OtpSendSuccess extends OtpState {
  final String message;

  OtpSendSuccess(this.message);
}

class OtpSendFailure extends OtpState {
  final ApiException exception;

  OtpSendFailure(this.exception);
}

class OtpVerifyLoading extends OtpState {}

class OtpVerifySuccess extends OtpState {
  final String message;

  OtpVerifySuccess(this.message);
}

class OtpVerifyFailure extends OtpState {
  final ApiException exception;

  OtpVerifyFailure(this.exception);
}

class OtpResendLoading extends OtpState {}

class OtpResendSuccess extends OtpState {
  final String message;

  OtpResendSuccess(this.message);
}

class OtpResendFailure extends OtpState {
  final ApiException exception;

  OtpResendFailure(this.exception);
}

class ResetPasswordOtpSendLoading extends OtpState {}

class ResetPasswordOtpSendSuccess extends OtpState {}

class ResetPasswordOtpSendFailure extends OtpState {
  final ApiException exception;

  ResetPasswordOtpSendFailure(this.exception);
}

class ResetPasswordLoading extends OtpState {}

class ResetPasswordSuccess extends OtpState {}

class ResetPasswordFailure extends OtpState {
  final ApiException exception;

  ResetPasswordFailure(this.exception);
}
