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
        // Emit UserNotFound if specific error message matches, otherwise emit failure
        if (exception.message.toLowerCase().contains('not found')) {
          emit(UserNotFound(phone));
        } else {
          emit(GetUserByPhoneFailure(exception));
        }
      },
    );
  }

  /// Login with Google
  Future<void> loginWithGoogle() async {
    emit(LoginLoading());

    final googleResult = await _authRepository.signInWithGoogle();

    await googleResult.when(
      success: (credential) async {
        if (credential != null && credential.user != null) {
          final email = credential.user!.email ?? '';
          final displayName = credential.user!.displayName ?? '';
          final names = displayName.split(' ');
          final firstName = names.isNotEmpty ? names[0] : '';
          final lastName = names.length > 1 ? names.sublist(1).join(' ') : '';

          // Check if user exists
          final checkRequest = PhoneCheckRequest(
            phone: '', // Not used for google login check
            email: email,
            loginType: 'google',
            userCat: 'customer',
          );

          final existsResult =
              await _authRepository.checkPhoneExists(checkRequest);

          await existsResult.when(
            success: (exists) async {
              if (exists) {
                // User exists, log them in
                final loginResult =
                    await _authRepository.socialLogin(checkRequest);
                await loginResult.when(
                  success: (response) async {
                    if (response.isSuccess && response.user != null) {
                      emit(LoginSuccess(response.user!));
                    } else {
                      emit(LoginFailure(ApiException(
                        errorType: ApiErrorType.badRequest,
                        message: response.error ?? 'Social login failed',
                      )));
                    }
                  },
                  failure: (exception) async => emit(LoginFailure(exception)),
                );
              } else {
                // User doesn't exist, go to register
                emit(SocialLoginUserNotFound(
                  email: email,
                  firstName: firstName,
                  lastName: lastName,
                  loginType: 'google',
                ));
              }
            },
            failure: (exception) async => emit(LoginFailure(exception)),
          );
        } else {
          emit(LoginInitial()); // Canceled or failed
        }
      },
      failure: (exception) async => emit(LoginFailure(exception)),
    );
  }

  /// Login with Apple
  Future<void> loginWithApple() async {
    emit(LoginLoading());

    final appleResult = await _authRepository.signInWithApple();

    await appleResult.when(
      success: (data) async {
        if (data != null) {
          final userCredential = data['userCredential'];
          final appleCredential = data['appleCredential'];

          if (userCredential != null && userCredential.user != null) {
            final email = userCredential.user!.email ?? '';
            final firstName = appleCredential.givenName ?? '';
            final lastName = appleCredential.familyName ?? '';

            // Check if user exists
            final checkRequest = PhoneCheckRequest(
              phone: '',
              email: email,
              loginType: 'apple',
              userCat: 'customer',
            );

            final existsResult =
                await _authRepository.checkPhoneExists(checkRequest);

            await existsResult.when(
              success: (exists) async {
                if (exists) {
                  // User exists, log them in
                  final loginResult =
                      await _authRepository.socialLogin(checkRequest);
                  await loginResult.when(
                    success: (response) async {
                      if (response.isSuccess && response.user != null) {
                        emit(LoginSuccess(response.user!));
                      } else {
                        emit(LoginFailure(ApiException(
                          errorType: ApiErrorType.badRequest,
                          message: response.error ?? 'Social login failed',
                        )));
                      }
                    },
                    failure: (exception) async => emit(LoginFailure(exception)),
                  );
                } else {
                  // User doesn't exist, go to register
                  emit(SocialLoginUserNotFound(
                    email: email,
                    firstName: firstName,
                    lastName: lastName,
                    loginType: 'apple',
                  ));
                }
              },
              failure: (exception) async => emit(LoginFailure(exception)),
            );
          } else {
            emit(LoginInitial());
          }
        } else {
          emit(LoginInitial());
        }
      },
      failure: (exception) async => emit(LoginFailure(exception)),
    );
  }

  /// Reset to initial state
  void reset() {
    emit(LoginInitial());
  }
}
