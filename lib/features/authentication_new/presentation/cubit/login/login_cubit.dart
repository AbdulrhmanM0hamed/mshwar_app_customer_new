import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cabme/core(new)/errors/api_error_type.dart';
import 'package:cabme/features/authentication_new/data/repositories/auth_repository.dart';
import 'package:cabme/features/authentication_new/data/models/login_request.dart';
import 'package:cabme/features/authentication_new/data/models/phone_check_request.dart';
import 'package:cabme/core(new)/errors/api_exception.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _authRepository;

  LoginCubit(this._authRepository) : super(LoginInitial());

  /// Login with email and password
  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(LoginLoading());

    final request = LoginRequest(
      email: email,
      password: password,
      userCat: 'customer',
    );

    final result = await _authRepository.login(request);

    result.when(
      success: (response) {
        if (response.isSuccess && response.user != null) {
          emit(LoginSuccess(response.user!));
        } else {
          emit(LoginFailure(
            ApiException(
              errorType: ApiErrorType.badRequest,
              message: response.error ?? 'Login failed',
            ),
          ));
        }
      },
      failure: (exception) {
        emit(LoginFailure(exception));
      },
    );
  }

  /// Check if phone number exists
  Future<void> checkPhoneExists({
    required String phone,
    required String userCat,
    String? email,
    String? loginType,
  }) async {
    emit(PhoneCheckLoading());

    final request = PhoneCheckRequest(
      phone: phone,
      userCat: userCat,
      email: email,
      loginType: loginType,
    );

    final result = await _authRepository.checkPhoneExists(request);

    result.when(
      success: (exists) {
        emit(PhoneCheckSuccess(exists));
      },
      failure: (exception) {
        emit(PhoneCheckFailure(exception));
      },
    );
  }

  /// Get user data by phone number
  Future<void> getUserByPhone({
    required String phone,
    required String userCat,
    String? email,
    String? loginType,
  }) async {
    emit(GetUserByPhoneLoading());

    final request = PhoneCheckRequest(
      phone: phone,
      userCat: userCat,
      email: email,
      loginType: loginType,
    );

    final result = await _authRepository.getUserByPhone(request);

    result.when(
      success: (user) {
        emit(GetUserByPhoneSuccess(user));
      },
      failure: (exception) {
        emit(GetUserByPhoneFailure(exception));
      },
    );
  }

  /// Reset to initial state
  void reset() {
    emit(LoginInitial());
  }
}
