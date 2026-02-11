import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/wallet_repository.dart';
import '../../../data/models/payment_request_model.dart';
import 'wallet_state.dart';

class WalletCubit extends Cubit<WalletState> {
  final WalletRepository _repository;

  WalletCubit({required WalletRepository repository})
      : _repository = repository,
        super(const WalletInitial());

  Future<void> loadWalletBalance(String userId) async {
    emit(const WalletLoading());

    try {
      final wallet = await _repository.getWalletBalance(userId);
      emit(WalletLoaded(wallet));
    } catch (e) {
      emit(WalletError(e.toString()));
    }
  }

  Future<void> refreshBalance(String userId) async {
    try {
      final wallet = await _repository.refreshBalance(userId);
      emit(WalletLoaded(wallet));
    } catch (e) {
      emit(WalletError(e.toString()));
    }
  }

  Future<void> addFunds(AddFundsRequestModel request) async {
    emit(const AddingFunds());

    try {
      final response = await _repository.addFunds(request);

      if (response.requiresAction) {
        emit(AddFundsRequiresAction(response));
      } else if (response.isSuccess) {
        // Refresh wallet balance after successful payment
        final wallet = await _repository.refreshBalance(request.userId);
        emit(FundsAdded(response, updatedWallet: wallet));
      } else {
        emit(AddFundsFailed(response.message ?? 'Failed to add funds'));
      }
    } catch (e) {
      emit(AddFundsFailed(e.toString()));
    }
  }

  Future<void> loadTransactionHistory(
    String userId, {
    int? limit,
    int? offset,
  }) async {
    emit(const TransactionHistoryLoading());

    try {
      final transactions = await _repository.getTransactionHistory(
        userId,
        limit: limit,
        offset: offset,
      );

      // Check if there might be more transactions
      final hasMore = limit != null && transactions.length >= limit;

      emit(TransactionHistoryLoaded(
        transactions: transactions,
        hasMore: hasMore,
      ));
    } catch (e) {
      emit(TransactionHistoryError(e.toString()));
    }
  }

  Future<void> loadMoreTransactions(
    String userId,
    int currentCount,
    int limit,
  ) async {
    final currentState = state;
    if (currentState is! TransactionHistoryLoaded) return;

    try {
      final newTransactions = await _repository.getTransactionHistory(
        userId,
        limit: limit,
        offset: currentCount,
      );

      final allTransactions = [
        ...currentState.transactions,
        ...newTransactions,
      ];

      final hasMore = newTransactions.length >= limit;

      emit(TransactionHistoryLoaded(
        transactions: allTransactions,
        hasMore: hasMore,
      ));
    } catch (e) {
      emit(TransactionHistoryError(e.toString()));
    }
  }

  Future<void> withdrawFunds(String userId, double amount) async {
    emit(const WithdrawingFunds());

    try {
      final success = await _repository.withdrawFunds(userId, amount);

      if (success) {
        // Refresh wallet balance after withdrawal
        final wallet = await _repository.refreshBalance(userId);
        emit(FundsWithdrawn(wallet));
      } else {
        emit(const WithdrawFundsFailed('Failed to withdraw funds'));
      }
    } catch (e) {
      emit(WithdrawFundsFailed(e.toString()));
    }
  }

  void reset() {
    emit(const WalletInitial());
  }
}
