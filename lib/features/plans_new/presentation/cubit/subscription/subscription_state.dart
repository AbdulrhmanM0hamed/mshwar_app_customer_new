import 'package:equatable/equatable.dart';
import '../../../data/models/subscription_model.dart';

abstract class SubscriptionState extends Equatable {
  const SubscriptionState();

  @override
  List<Object?> get props => [];
}

class SubscriptionInitial extends SubscriptionState {
  const SubscriptionInitial();
}

// Settings States
class SubscriptionSettingsLoading extends SubscriptionState {
  const SubscriptionSettingsLoading();
}

class SubscriptionSettingsLoaded extends SubscriptionState {
  final SubscriptionSettingsModel settings;

  const SubscriptionSettingsLoaded(this.settings);

  @override
  List<Object?> get props => [settings];
}

class SubscriptionSettingsError extends SubscriptionState {
  final String message;

  const SubscriptionSettingsError(this.message);

  @override
  List<Object?> get props => [message];
}

// List States
class SubscriptionsLoading extends SubscriptionState {
  const SubscriptionsLoading();
}

class SubscriptionsLoaded extends SubscriptionState {
  final List<SubscriptionModel> subscriptions;

  const SubscriptionsLoaded(this.subscriptions);

  @override
  List<Object?> get props => [subscriptions];
}

class SubscriptionsError extends SubscriptionState {
  final String message;

  const SubscriptionsError(this.message);

  @override
  List<Object?> get props => [message];
}

// Price Calculation States
class SubscriptionPriceCalculating extends SubscriptionState {
  const SubscriptionPriceCalculating();
}

class SubscriptionPriceCalculated extends SubscriptionState {
  final SubscriptionPriceModel price;

  const SubscriptionPriceCalculated(this.price);

  @override
  List<Object?> get props => [price];
}

class SubscriptionPriceError extends SubscriptionState {
  final String message;

  const SubscriptionPriceError(this.message);

  @override
  List<Object?> get props => [message];
}

// Create States
class SubscriptionCreating extends SubscriptionState {
  const SubscriptionCreating();
}

class SubscriptionCreated extends SubscriptionState {
  final SubscriptionModel subscription;

  const SubscriptionCreated(this.subscription);

  @override
  List<Object?> get props => [subscription];
}

class SubscriptionCreateError extends SubscriptionState {
  final String message;

  const SubscriptionCreateError(this.message);

  @override
  List<Object?> get props => [message];
}

// Payment States
class SubscriptionPaymentProcessing extends SubscriptionState {
  const SubscriptionPaymentProcessing();
}

class SubscriptionPaymentSuccess extends SubscriptionState {
  final SubscriptionModel subscription;

  const SubscriptionPaymentSuccess(this.subscription);

  @override
  List<Object?> get props => [subscription];
}

class SubscriptionPaymentError extends SubscriptionState {
  final String message;

  const SubscriptionPaymentError(this.message);

  @override
  List<Object?> get props => [message];
}
