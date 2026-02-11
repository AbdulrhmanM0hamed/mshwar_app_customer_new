import '../../../../core(new)/network/api_service.dart';
import '../models/payment_method_model.dart';
import '../models/payment_gateway_config_model.dart';
import '../models/payment_request_model.dart';
import '../models/payment_response_model.dart';

abstract class PaymentRepository {
  Future<List<PaymentMethodModel>> getPaymentMethods();
  Future<PaymentSettingsModel> getPaymentSettings();
  Future<PaymentResponseModel> processPayment(PaymentRequestModel request);
  Future<PaymentResponseModel> verifyPayment(String transactionId);
  Future<bool> cancelPayment(String transactionId);
}

class PaymentRepositoryImpl implements PaymentRepository {
  final ApiService apiService;

  PaymentRepositoryImpl({required this.apiService});

  @override
  Future<List<PaymentMethodModel>> getPaymentMethods() async {
    try {
      final response = await apiService.get('/payment/methods');
      
      if (response['success'] == 'success' && response['data'] != null) {
        List<dynamic> data = response['data'];
        return data
            .map((json) => PaymentMethodModel.fromJson(json))
            .where((method) => method.isActive)
            .toList();
      }

      throw Exception(response['message'] ?? 'Failed to load payment methods');
    } catch (e) {
      throw Exception('Failed to get payment methods: $e');
    }
  }

  @override
  Future<PaymentSettingsModel> getPaymentSettings() async {
    try {
      final response = await apiService.get('/payment/settings');
      
      if (response['success'] == 'success') {
        return PaymentSettingsModel.fromJson(response);
      }

      throw Exception(response['message'] ?? 'Failed to load payment settings');
    } catch (e) {
      throw Exception('Failed to get payment settings: $e');
    }
  }

  @override
  Future<PaymentResponseModel> processPayment(PaymentRequestModel request) async {
    try {
      final response = await apiService.post(
        '/payment/process',
        data: request.toJson(),
      );
      
      return PaymentResponseModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to process payment: $e');
    }
  }

  @override
  Future<PaymentResponseModel> verifyPayment(String transactionId) async {
    try {
      final response = await apiService.get('/payment/verify/$transactionId');
      
      return PaymentResponseModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to verify payment: $e');
    }
  }

  @override
  Future<bool> cancelPayment(String transactionId) async {
    try {
      final response = await apiService.post(
        '/payment/cancel',
        data: {'transaction_id': transactionId},
      );
      
      return response['success'] == 'success' || response['success'] == true;
    } catch (e) {
      throw Exception('Failed to cancel payment: $e');
    }
  }
}
