import 'package:cabme/core(new)/errors/api_exception.dart';
import 'package:cabme/features/authentication_new/data/models/user_model.dart';

abstract class RegisterState {}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {
  final UserModel user;

  RegisterSuccess(this.user);
}

class RegisterFailure extends RegisterState {
  final ApiException exception;

  RegisterFailure(this.exception);
}
