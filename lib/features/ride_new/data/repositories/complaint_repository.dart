import 'package:cabme/core(new)/network/api_service.dart';
import '../models/complaint_model.dart';

/// Complaint Repository Interface
abstract class ComplaintRepository {
  Future<ComplaintModel> submitComplaint(ComplaintRequest request);
  Future<List<ComplaintModel>> getMyComplaints();
  Future<ComplaintModel> getComplaintDetails(String complaintId);
}

/// Complaint Repository Implementation
class ComplaintRepositoryImpl implements ComplaintRepository {
  final ApiService apiService;

  ComplaintRepositoryImpl({required this.apiService});

  @override
  Future<ComplaintModel> submitComplaint(ComplaintRequest request) async {
    try {
      if (!request.isValid) {
        throw Exception('Invalid complaint: Type and description are required');
      }

      final response = await apiService.post(
        '/add-complaint',
        data: request.toJson(),
      );
      
      if (response['success'] == 'success' && response['data'] != null) {
        return ComplaintModel.fromJson(response['data']);
      }
      
      throw Exception(response['message'] ?? 'Failed to submit complaint');
    } catch (e) {
      throw Exception('Failed to submit complaint: $e');
    }
  }

  @override
  Future<List<ComplaintModel>> getMyComplaints() async {
    try {
      final response = await apiService.get('/my-complaints');
      
      if (response['success'] == 'success' && response['data'] != null) {
        final List<dynamic> data = response['data'] as List;
        return data.map((json) => ComplaintModel.fromJson(json)).toList();
      }
      
      throw Exception(response['message'] ?? 'Failed to load complaints');
    } catch (e) {
      throw Exception('Failed to load complaints: $e');
    }
  }

  @override
  Future<ComplaintModel> getComplaintDetails(String complaintId) async {
    try {
      final response = await apiService.get('/complaint-details/$complaintId');
      
      if (response['success'] == 'success' && response['data'] != null) {
        return ComplaintModel.fromJson(response['data']);
      }
      
      throw Exception(response['message'] ?? 'Failed to load complaint details');
    } catch (e) {
      throw Exception('Failed to load complaint details: $e');
    }
  }
}
