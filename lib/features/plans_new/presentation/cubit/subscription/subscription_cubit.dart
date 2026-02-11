import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/subscription_repository.dart';
import 'subscription_state.dart';

class SubscriptionCubit extends Cubit<SubscriptionState> {
  final SubscriptionRepository _repository;

  SubscriptionCubit({required SubscriptionRepository repository})
      : _repository = repository,
        super(const SubscriptionInitial());

  Future<void> loadSettings() async {
    emit(const SubscriptionSettingsLoading());

    try {
      final settings = await _repository.getSettings();
      emit(SubscriptionSettingsLoaded(settings));
    } catch (e) {
      emit(SubscriptionSettingsError(e.toString()));
    }
  }

  Future<void> loadUserSubscriptions({String? status}) async {
    emit(const SubscriptionsLoading());

    try {
      final subscriptions = await _repository.getUserSubscriptions(status: status);
      emit(SubscriptionsLoaded(subscriptions));
    } catch (e) {
      emit(SubscriptionsError(e.toString()));
    }
  }

  Future<void> calculatePrice(Map<String, dynamic> data) async {
    emit(const SubscriptionPriceCalculating());

    try {
      final price = await _repository.calculatePrice(data);
      emit(SubscriptionPriceCalculated(price));
    } catch (e) {
      emit(SubscriptionPriceError(e.toString()));
    }
  }

  Future<void> createSubscription(Map<String, dynamic> data) async {
    emit(const SubscriptionCreating());

    try {
      final subscription = await _repository.createSubscription(data);
      emit(SubscriptionCreated(subscription));
    } catch (e) {
      emit(SubscriptionCreateError(e.toString()));
    }
  }

  Future<void> payWithWallet(String subscriptionId, double amount) async {
    emit(const SubscriptionPaymentProcessing());

    try {
      final subscription = await _repository.payWithWallet(subscriptionId, amount);
      emit(SubscriptionPaymentSuccess(subscription));
    } catch (e) {
      emit(SubscriptionPaymentError(e.toString()));
    }
  }

  Future<void> confirmPayment(String subscriptionId, String transactionId, String paymentMethod) async {
    emit(const SubscriptionPaymentProcessing());

    try {
      final success = await _repository.confirmPayment(subscriptionId, transactionId, paymentMethod);
      
      if (success) {
        await loadUserSubscriptions();
      } else {
        emit(const SubscriptionPaymentError('Failed to confirm payment'));
      }
    } catch (e) {
      emit(SubscriptionPaymentError(e.toString()));
    }
  }

  Future<void> cancelSubscription(String subscriptionId, String reason) async {
    try {
      await _repository.cancelSubscription(subscriptionId, reason);
      await loadUserSubscriptions();
    } catch (e) {
      emit(SubscriptionPaymentError(e.toString()));
    }
  }

  void reset() {
    emit(const SubscriptionInitial());
  }
}
