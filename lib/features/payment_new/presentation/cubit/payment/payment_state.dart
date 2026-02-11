import 'package:equatable/equatable.dart';
import '../../../data/models/payment_method_model.dart';
import '../../../data/models/payment_gateway_config_model.dart';
import '../../../data/models/payment_response_model.dart';

abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object?> get props => [];
}

class PaymentInitial extends PaymentState {
  const PaymentInitial();
}

// Payment Methods States
class PaymentMethodsLoading extends PaymentState {
  const PaymentMethodsLoading();
}

class PaymentMethodsLoaded extends PaymentState {
  final List<PaymentMethodModel> methods;
  final PaymentMethodModel? selectedMethod;

  const PaymentMethodsLoaded({
    required this.methods,
    this.selectedMethod,
  });

  @override
  List<Object?> get props => [methods, selectedMethod];

  PaymentMethodsLoaded copyWith({
    List<PaymentMethodModel>? methods,
    PaymentMethodModel? selectedMethod,
  }) {
    return PaymentMethodsLoaded(
      methods: methods ?? this.methods,
      selectedMethod: selectedMethod ?? this.selectedMethod,
    );
  }
}

class PaymentMethodsError extends PaymentState {
  final String message;

  const PaymentMethodsError(this.message);

  @override
  List<Object> get props => [message];
}

// Payment Settings States
class PaymentSettingsLoading extends PaymentState {
  const PaymentSettingsLoading();
}

class PaymentSettingsLoaded extends PaymentState {
  final PaymentSettingsModel settings;

  const PaymentSettingsLoaded(this.settings);

  @override
  List<Object> get props => [settings];
}

class PaymentSettingsError extends PaymentState {
  final String message;

  const PaymentSettingsError(this.message);

  @override
  List<Object> get props => [message];
}

// Payment Processing States
class PaymentProcessing extends PaymentState {
  const PaymentProcessing();
}

class PaymentSuccess extends PaymentState {
  final PaymentResponseModel response;

  const PaymentSuccess(this.response);

  @override
  List<Object> get props => [response];
}

class PaymentFailed extends PaymentState {
  final String message;
  final PaymentResponseModel? response;

  const PaymentFailed(this.message, {this.response});

  @override
  List<Object?> get props => [message, response];
}

class PaymentRequiresAction extends PaymentState {
  final PaymentResponseModel response;

  const PaymentRequiresAction(this.response);

  @override
  List<Object> get props => [response];
}

class PaymentCancelled extends PaymentState {
  const PaymentCancelled();
}

// Payment Verification States
class PaymentVerifying extends PaymentState {
  const PaymentVerifying();
}

class PaymentVerified extends PaymentState {
  final PaymentResponseModel response;

  const PaymentVerified(this.response);

  @override
  List<Object> get props => [response];
}

class PaymentVerificationFailed extends PaymentState {
  final String message;

  const PaymentVerificationFailed(this.message);

  @override
  List<Object> get props => [message];
}
