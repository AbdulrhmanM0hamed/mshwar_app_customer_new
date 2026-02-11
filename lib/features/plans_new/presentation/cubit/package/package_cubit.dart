import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/package_repository.dart';
import 'package_state.dart';

class PackageCubit extends Cubit<PackageState> {
  final PackageRepository _repository;

  PackageCubit({required PackageRepository repository})
      : _repository = repository,
        super(const PackageInitial());

  Future<void> loadAvailablePackages() async {
    emit(const PackagesLoading());

    try {
      final packages = await _repository.getAvailablePackages();
      emit(PackagesLoaded(packages));
    } catch (e) {
      emit(PackagesError(e.toString()));
    }
  }

  Future<void> loadUserPackages({String? status}) async {
    emit(const UserPackagesLoading());

    try {
      final packages = await _repository.getUserPackages(status: status);
      emit(UserPackagesLoaded(packages));
    } catch (e) {
      emit(UserPackagesError(e.toString()));
    }
  }

  Future<void> purchasePackage(String packageId, String paymentMethod) async {
    emit(const PackagePurchasing());

    try {
      final package = await _repository.purchasePackage(packageId, paymentMethod);
      emit(PackagePurchased(package));
    } catch (e) {
      emit(PackagePurchaseError(e.toString()));
    }
  }

  Future<void> payWithWallet(String userPackageId, double amount) async {
    emit(const PackagePaymentProcessing());

    try {
      final package = await _repository.payWithWallet(userPackageId, amount);
      emit(PackagePaymentSuccess(package));
    } catch (e) {
      emit(PackagePaymentError(e.toString()));
    }
  }

  Future<void> confirmPayment(String userPackageId, String transactionId, String paymentMethod) async {
    emit(const PackagePaymentProcessing());

    try {
      final success = await _repository.confirmPayment(userPackageId, transactionId, paymentMethod);
      
      if (success) {
        await loadUserPackages();
      } else {
        emit(const PackagePaymentError('Failed to confirm payment'));
      }
    } catch (e) {
      emit(PackagePaymentError(e.toString()));
    }
  }

  Future<void> cancelPackage(String userPackageId) async {
    try {
      await _repository.cancelPackage(userPackageId);
      await loadUserPackages();
    } catch (e) {
      emit(PackagePaymentError(e.toString()));
    }
  }

  void reset() {
    emit(const PackageInitial());
  }
}
