import '../../../../core(new)/network/api_service.dart';
import '../models/subscription_model.dart';

abstract class SubscriptionRepository {
  Future<SubscriptionSettingsModel> getSettings();
  Future<List<SubscriptionModel>> getUserSubscriptions({String? status});
  Future<List<SubscriptionRideModel>> getUpcomingRides({int limit = 10});
  Future<SubscriptionModel> getSubscriptionDetails(String subscriptionId);
  Future<SubscriptionPriceModel> calculatePrice(Map<String, dynamic> data);
  Future<SubscriptionModel> createSubscription(Map<String, dynamic> data);
  Future<SubscriptionModel> payWithWallet(String subscriptionId, double amount);
  Future<bool> confirmPayment(String subscriptionId, String transactionId, String paymentMethod);
  Future<bool> cancelSubscription(String subscriptionId, String reason);
}

class SubscriptionRepositoryImpl implements SubscriptionRepository {
  final ApiService apiService;

  SubscriptionRepositoryImpl({required this.apiService});

  @override
  Future<SubscriptionSettingsModel> getSettings() async {
    try {
      final response = await apiService.get('/subscription-settings');

      if (response['success'] == 'success' && response['data'] != null) {
        return SubscriptionSettingsModel.fromJson(response['data']);
      }

      throw Exception(response['message'] ?? 'Failed to load settings');
    } catch (e) {
      throw Exception('Failed to get subscription settings: $e');
    }
  }

  @override
  Future<List<SubscriptionModel>> getUserSubscriptions({String? status}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (status != null && status.isNotEmpty) {
        queryParams['status'] = status;
      }

      final response = await apiService.get(
        '/user-subscriptions',
        queryParameters: queryParams,
      );

      if (response['success'] == 'success' && response['data'] != null) {
        List<dynamic> data = response['data'];
        return data.map((json) => SubscriptionModel.fromJson(json)).toList();
      }

      throw Exception(response['message'] ?? 'Failed to load subscriptions');
    } catch (e) {
      throw Exception('Failed to get subscriptions: $e');
    }
  }

  @override
  Future<List<SubscriptionRideModel>> getUpcomingRides({int limit = 10}) async {
    try {
      final response = await apiService.get(
        '/subscription-upcoming-rides',
        queryParameters: {'limit': limit},
      );

      if (response['success'] == 'success' && response['data'] != null) {
        List<dynamic> data = response['data'];
        return data.map((json) => SubscriptionRideModel.fromJson(json)).toList();
      }

      throw Exception(response['message'] ?? 'Failed to load rides');
    } catch (e) {
      throw Exception('Failed to get upcoming rides: $e');
    }
  }

  @override
  Future<SubscriptionModel> getSubscriptionDetails(String subscriptionId) async {
    try {
      final response = await apiService.get(
        '/subscription-details',
        queryParameters: {'subscription_id': subscriptionId},
      );

      if (response['success'] == 'success' && response['data'] != null) {
        return SubscriptionModel.fromJson(response['data']);
      }

      throw Exception(response['message'] ?? 'Failed to load details');
    } catch (e) {
      throw Exception('Failed to get subscription details: $e');
    }
  }

  @override
  Future<SubscriptionPriceModel> calculatePrice(Map<String, dynamic> data) async {
    try {
      final response = await apiService.post('/subscription-calculate-price', data: data);

      if (response['success'] == 'success' && response['data'] != null) {
        return SubscriptionPriceModel.fromJson(response['data']);
      }

      throw Exception(response['message'] ?? 'Failed to calculate price');
    } catch (e) {
      throw Exception('Failed to calculate price: $e');
    }
  }

  @override
  Future<SubscriptionModel> createSubscription(Map<String, dynamic> data) async {
    try {
      final response = await apiService.post('/subscription-create', data: data);

      if (response['success'] == 'success' && response['data'] != null) {
        return SubscriptionModel.fromJson(response['data']);
      }

      throw Exception(response['message'] ?? 'Failed to create subscription');
    } catch (e) {
      throw Exception('Failed to create subscription: $e');
    }
  }

  @override
  Future<SubscriptionModel> payWithWallet(String subscriptionId, double amount) async {
    try {
      final response = await apiService.post(
        '/subscription-pay-wallet',
        data: {
          'subscription_id': subscriptionId,
          'amount': amount,
        },
      );

      if (response['success'] == 'success' && response['data'] != null) {
        return SubscriptionModel.fromJson(response['data']['subscription']);
      }

      throw Exception(response['message'] ?? 'Payment failed');
    } catch (e) {
      throw Exception('Wallet payment failed: $e');
    }
  }

  @override
  Future<bool> confirmPayment(String subscriptionId, String transactionId, String paymentMethod) async {
    try {
      final response = await apiService.post(
        '/subscription-confirm-payment',
        data: {
          'subscription_id': subscriptionId,
          'transaction_id': transactionId,
          'payment_method': paymentMethod,
        },
      );

      return response['success'] == 'success';
    } catch (e) {
      throw Exception('Failed to confirm payment: $e');
    }
  }

  @override
  Future<bool> cancelSubscription(String subscriptionId, String reason) async {
    try {
      final response = await apiService.post(
        '/subscription-cancel',
        data: {
          'subscription_id': subscriptionId,
          'cancellation_reason': reason,
        },
      );

      return response['success'] == 'success';
    } catch (e) {
      throw Exception('Failed to cancel subscription: $e');
    }
  }
}
