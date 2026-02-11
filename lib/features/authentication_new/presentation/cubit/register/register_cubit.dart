import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cabme/core(new)/errors/api_error_type.dart';
import 'package:cabme/core(new)/errors/api_exception.dart';
import 'package:cabme/features/authentication_new/data/repositories/auth_repository.dart';
import 'package:cabme/features/authentication_new/data/models/register_request.dart';
import 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final AuthRepository _authRepository;

  RegisterCubit(this._authRepository) : super(RegisterInitial());

  /// Register new user
  Future<void> register({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String password,
    String? fcmToken,
    String? loginType,
    String? country,
  }) async {
    emit(RegisterLoading());

    final request = RegisterRequest(
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
      password: password,
      userCat: 'customer',
      fcmToken: fcmToken,
      loginType: loginType ?? 'email',
      country: country,
    );

    final result = await _authRepository.register(request);

    result.when(
      success: (response) {
        if (response.isSuccess && response.user != null) {
          emit(RegisterSuccess(response.user!));
        } else {
          emit(RegisterFailure(
            ApiException(
              errorType: ApiErrorType.badRequest,
              message: response.error ?? 'Registration failed',
            ),
          ));
        }
      },
      failure: (exception) {
        emit(RegisterFailure(exception));
      },
    );
  }

  /// Reset to initial state
  void reset() {
    emit(RegisterInitial());
  }
}
