import 'package:cabme/core(new)/errors/api_exception.dart';
import 'package:cabme/features/authentication_new/data/models/user_model.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final UserModel user;

  LoginSuccess(this.user);
}

class LoginFailure extends LoginState {
  final ApiException exception;

  LoginFailure(this.exception);
}

class PhoneCheckLoading extends LoginState {}

class PhoneCheckSuccess extends LoginState {
  final bool exists;

  PhoneCheckSuccess(this.exists);
}

class PhoneCheckFailure extends LoginState {
  final ApiException exception;

  PhoneCheckFailure(this.exception);
}

class GetUserByPhoneLoading extends LoginState {}

class GetUserByPhoneSuccess extends LoginState {
  final UserModel user;

  GetUserByPhoneSuccess(this.user);
}

class GetUserByPhoneFailure extends LoginState {
  final ApiException exception;

  GetUserByPhoneFailure(this.exception);
}
