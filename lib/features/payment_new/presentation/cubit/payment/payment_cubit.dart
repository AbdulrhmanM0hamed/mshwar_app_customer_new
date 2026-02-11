import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/payment_repository.dart';
import '../../../data/models/payment_method_model.dart';
import '../../../data/models/payment_request_model.dart';
import 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  final PaymentRepository _repository;

  PaymentCubit({required PaymentRepository repository})
      : _repository = repository,
        super(const PaymentInitial());

  Future<void> loadPaymentMethods() async {
    emit(const PaymentMethodsLoading());

    try {
      final methods = await _repository.getPaymentMethods();
      
      // Filter only active methods
      final activeMethods = methods.where((m) => m.isActive).toList();
      
      emit(PaymentMethodsLoaded(methods: activeMethods));
    } catch (e) {
      emit(PaymentMethodsError(e.toString()));
    }
  }

  void selectPaymentMethod(PaymentMethodModel method) {
    final currentState = state;
    if (currentState is PaymentMethodsLoaded) {
      emit(currentState.copyWith(selectedMethod: method));
    }
  }

  Future<void> loadPaymentSettings() async {
    emit(const PaymentSettingsLoading());

    try {
      final settings = await _repository.getPaymentSettings();
      emit(PaymentSettingsLoaded(settings));
    } catch (e) {
      emit(PaymentSettingsError(e.toString()));
    }
  }

  Future<void> processPayment(PaymentRequestModel request) async {
    emit(const PaymentProcessing());

    try {
      final response = await _repository.processPayment(request);

      if (response.requiresAction) {
        emit(PaymentRequiresAction(response));
      } else if (response.isSuccess) {
        emit(PaymentSuccess(response));
      } else {
        emit(PaymentFailed(
          response.message ?? 'Payment failed',
          response: response,
        ));
      }
    } catch (e) {
      emit(PaymentFailed(e.toString()));
    }
  }

  Future<void> verifyPayment(String transactionId) async {
    emit(const PaymentVerifying());

    try {
      final response = await _repository.verifyPayment(transactionId);

      if (response.isSuccess) {
        emit(PaymentVerified(response));
      } else {
        emit(PaymentVerificationFailed(
          response.message ?? 'Payment verification failed',
        ));
      }
    } catch (e) {
      emit(PaymentVerificationFailed(e.toString()));
    }
  }

  Future<void> cancelPayment(String transactionId) async {
    try {
      final success = await _repository.cancelPayment(transactionId);
      
      if (success) {
        emit(const PaymentCancelled());
      } else {
        emit(const PaymentFailed('Failed to cancel payment'));
      }
    } catch (e) {
      emit(PaymentFailed(e.toString()));
    }
  }

  void reset() {
    emit(const PaymentInitial());
  }
}
