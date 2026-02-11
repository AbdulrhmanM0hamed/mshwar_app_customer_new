import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cabme/core(new)/errors/api_error_type.dart';
import 'package:cabme/core(new)/errors/api_exception.dart';
import 'package:cabme/features/authentication_new/data/repositories/auth_repository.dart';
import 'package:cabme/features/authentication_new/data/models/otp_request.dart';
import 'package:cabme/features/authentication_new/data/models/forgot_password_request.dart';
import 'otp_state.dart';

class OtpCubit extends Cubit<OtpState> {
  final AuthRepository _authRepository;

  OtpCubit(this._authRepository) : super(OtpInitial());

  /// Send OTP to phone number
  Future<void> sendOtp(String phone) async {
    emit(OtpSendLoading());

    final result = await _authRepository.sendOtp(phone);

    result.when(
      success: (response) {
        if (response.isSuccess) {
          emit(OtpSendSuccess(response.message ?? 'OTP sent successfully'));
        } else {
          emit(OtpSendFailure(
            ApiException(
              errorType: ApiErrorType.badRequest,
              message: response.error ?? 'Send OTP failed',
            ),
          ));
        }
      },
      failure: (exception) {
        emit(OtpSendFailure(exception));
      },
    );
  }

  /// Verify OTP
  Future<void> verifyOtp({
    required String phone,
    required String otp,
  }) async {
    emit(OtpVerifyLoading());

    final request = OtpRequest(
      phone: phone,
      otp: otp,
    );

    final result = await _authRepository.verifyOtp(request);

    result.when(
      success: (response) {
        if (response.isSuccess) {
          emit(OtpVerifySuccess(response.message ?? 'OTP verified successfully'));
        } else {
          emit(OtpVerifyFailure(
            ApiException(
              errorType: ApiErrorType.badRequest,
              message: response.error ?? 'Verify OTP failed',
            ),
          ));
        }
      },
      failure: (exception) {
        emit(OtpVerifyFailure(exception));
      },
    );
  }

  /// Resend OTP
  Future<void> resendOtp(String phone) async {
    emit(OtpResendLoading());

    final result = await _authRepository.resendOtp(phone);

    result.when(
      success: (response) {
        if (response.isSuccess) {
          emit(OtpResendSuccess(response.message ?? 'OTP resent successfully'));
        } else {
          emit(OtpResendFailure(
            ApiException(
              errorType: ApiErrorType.badRequest,
              message: response.error ?? 'Resend OTP failed',
            ),
          ));
        }
      },
      failure: (exception) {
        emit(OtpResendFailure(exception));
      },
    );
  }

  /// Send reset password OTP
  Future<void> sendResetPasswordOtp(String email) async {
    emit(ResetPasswordOtpSendLoading());

    final result = await _authRepository.sendResetPasswordOtp(email);

    result.when(
      success: (_) {
        emit(ResetPasswordOtpSendSuccess());
      },
      failure: (exception) {
        emit(ResetPasswordOtpSendFailure(exception));
      },
    );
  }

  /// Reset password
  Future<void> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    emit(ResetPasswordLoading());

    final request = ForgotPasswordRequest(
      email: email,
      otp: otp,
      newPassword: newPassword,
    );

    final result = await _authRepository.resetPassword(request);

    result.when(
      success: (_) {
        emit(ResetPasswordSuccess());
      },
      failure: (exception) {
        emit(ResetPasswordFailure(exception));
      },
    );
  }

  /// Reset to initial state
  void reset() {
    emit(OtpInitial());
  }
}
