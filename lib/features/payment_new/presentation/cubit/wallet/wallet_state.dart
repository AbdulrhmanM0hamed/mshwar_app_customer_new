import 'package:equatable/equatable.dart';
import '../../../data/models/wallet_model.dart';
import '../../../data/models/transaction_model.dart';
import '../../../data/models/payment_response_model.dart';

abstract class WalletState extends Equatable {
  const WalletState();

  @override
  List<Object?> get props => [];
}

class WalletInitial extends WalletState {
  const WalletInitial();
}

// Wallet Balance States
class WalletLoading extends WalletState {
  const WalletLoading();
}

class WalletLoaded extends WalletState {
  final WalletModel wallet;

  const WalletLoaded(this.wallet);

  @override
  List<Object> get props => [wallet];
}

class WalletError extends WalletState {
  final String message;

  const WalletError(this.message);

  @override
  List<Object> get props => [message];
}

// Add Funds States
class AddingFunds extends WalletState {
  const AddingFunds();
}

class FundsAdded extends WalletState {
  final PaymentResponseModel response;
  final WalletModel? updatedWallet;

  const FundsAdded(this.response, {this.updatedWallet});

  @override
  List<Object?> get props => [response, updatedWallet];
}

class AddFundsFailed extends WalletState {
  final String message;

  const AddFundsFailed(this.message);

  @override
  List<Object> get props => [message];
}

class AddFundsRequiresAction extends WalletState {
  final PaymentResponseModel response;

  const AddFundsRequiresAction(this.response);

  @override
  List<Object> get props => [response];
}

// Transaction History States
class TransactionHistoryLoading extends WalletState {
  const TransactionHistoryLoading();
}

class TransactionHistoryLoaded extends WalletState {
  final List<TransactionModel> transactions;
  final bool hasMore;

  const TransactionHistoryLoaded({
    required this.transactions,
    this.hasMore = false,
  });

  @override
  List<Object> get props => [transactions, hasMore];
}

class TransactionHistoryError extends WalletState {
  final String message;

  const TransactionHistoryError(this.message);

  @override
  List<Object> get props => [message];
}

// Withdraw Funds States
class WithdrawingFunds extends WalletState {
  const WithdrawingFunds();
}

class FundsWithdrawn extends WalletState {
  final WalletModel updatedWallet;

  const FundsWithdrawn(this.updatedWallet);

  @override
  List<Object> get props => [updatedWallet];
}

class WithdrawFundsFailed extends WalletState {
  final String message;

  const WithdrawFundsFailed(this.message);

  @override
  List<Object> get props => [message];
}
