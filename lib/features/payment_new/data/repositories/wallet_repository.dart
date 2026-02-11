import '../../../../core(new)/network/api_service.dart';
import '../models/wallet_model.dart';
import '../models/transaction_model.dart';
import '../models/payment_request_model.dart';
import '../models/payment_response_model.dart';

abstract class WalletRepository {
  Future<WalletModel> getWalletBalance(String userId);
  Future<PaymentResponseModel> addFunds(AddFundsRequestModel request);
  Future<List<TransactionModel>> getTransactionHistory(String userId, {int? limit, int? offset});
  Future<bool> withdrawFunds(String userId, double amount);
  Future<WalletModel> refreshBalance(String userId);
}

class WalletRepositoryImpl implements WalletRepository {
  final ApiService apiService;

  WalletRepositoryImpl({required this.apiService});

  @override
  Future<WalletModel> getWalletBalance(String userId) async {
    try {
      final response = await apiService.get(
        '/wallet/balance',
        queryParameters: {'user_id': userId},
      );
      
      if (response['success'] == 'success' && response['data'] != null) {
        return WalletModel.fromJson(response['data']);
      }

      throw Exception(response['message'] ?? 'Failed to load wallet balance');
    } catch (e) {
      throw Exception('Failed to get wallet balance: $e');
    }
  }

  @override
  Future<PaymentResponseModel> addFunds(AddFundsRequestModel request) async {
    try {
      final response = await apiService.post(
        '/wallet/add-funds',
        data: request.toJson(),
      );
      
      return PaymentResponseModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to add funds: $e');
    }
  }

  @override
  Future<List<TransactionModel>> getTransactionHistory(
    String userId, {
    int? limit,
    int? offset,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'user_id': userId,
        if (limit != null) 'limit': limit.toString(),
        if (offset != null) 'offset': offset.toString(),
      };

      final response = await apiService.get(
        '/wallet/transactions',
        queryParameters: queryParams,
      );
      
      if (response['success'] == 'success' && response['data'] != null) {
        List<dynamic> data = response['data'];
        return data.map((json) => TransactionModel.fromJson(json)).toList();
      }

      throw Exception(response['message'] ?? 'Failed to load transactions');
    } catch (e) {
      throw Exception('Failed to get transaction history: $e');
    }
  }

  @override
  Future<bool> withdrawFunds(String userId, double amount) async {
    try {
      final response = await apiService.post(
        '/wallet/withdraw',
        data: {
          'user_id': userId,
          'amount': amount.toString(),
        },
      );
      
      return response['success'] == 'success' || response['success'] == true;
    } catch (e) {
      throw Exception('Failed to withdraw funds: $e');
    }
  }

  @override
  Future<WalletModel> refreshBalance(String userId) async {
    return getWalletBalance(userId);
  }
}
