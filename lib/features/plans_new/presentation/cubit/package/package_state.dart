import 'package:equatable/equatable.dart';
import '../../../data/models/package_model.dart';

abstract class PackageState extends Equatable {
  const PackageState();

  @override
  List<Object?> get props => [];
}

class PackageInitial extends PackageState {
  const PackageInitial();
}

// Available Packages States
class PackagesLoading extends PackageState {
  const PackagesLoading();
}

class PackagesLoaded extends PackageState {
  final List<PackageModel> packages;

  const PackagesLoaded(this.packages);

  @override
  List<Object?> get props => [packages];
}

class PackagesError extends PackageState {
  final String message;

  const PackagesError(this.message);

  @override
  List<Object?> get props => [message];
}

// User Packages States
class UserPackagesLoading extends PackageState {
  const UserPackagesLoading();
}

class UserPackagesLoaded extends PackageState {
  final List<UserPackageModel> packages;

  const UserPackagesLoaded(this.packages);

  @override
  List<Object?> get props => [packages];
}

class UserPackagesError extends PackageState {
  final String message;

  const UserPackagesError(this.message);

  @override
  List<Object?> get props => [message];
}

// Purchase States
class PackagePurchasing extends PackageState {
  const PackagePurchasing();
}

class PackagePurchased extends PackageState {
  final UserPackageModel package;

  const PackagePurchased(this.package);

  @override
  List<Object?> get props => [package];
}

class PackagePurchaseError extends PackageState {
  final String message;

  const PackagePurchaseError(this.message);

  @override
  List<Object?> get props => [message];
}

// Payment States
class PackagePaymentProcessing extends PackageState {
  const PackagePaymentProcessing();
}

class PackagePaymentSuccess extends PackageState {
  final UserPackageModel package;

  const PackagePaymentSuccess(this.package);

  @override
  List<Object?> get props => [package];
}

class PackagePaymentError extends PackageState {
  final String message;

  const PackagePaymentError(this.message);

  @override
  List<Object?> get props => [message];
}
