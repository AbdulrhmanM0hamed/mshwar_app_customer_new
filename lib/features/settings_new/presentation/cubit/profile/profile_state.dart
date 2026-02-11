import 'package:cabme/features/authentication/model/user_model.dart';
import 'package:equatable/equatable.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserModel user;

  const ProfileLoaded(this.user);

  @override
  List<Object> get props => [user];
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object> get props => [message];
}

class ProfileUpdating extends ProfileState {}

class ProfileUpdated extends ProfileState {
  final UserModel user;

  const ProfileUpdated(this.user);

  @override
  List<Object> get props => [user];
}

class PasswordUpdating extends ProfileState {}

class PasswordUpdated extends ProfileState {}

class AccountDeleted extends ProfileState {}
