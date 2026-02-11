import 'package:cabme/core(new)/network/api_service.dart';
import '../models/review_model.dart';

/// Review Repository Interface
abstract class ReviewRepository {
  Future<ReviewModel> submitReview(ReviewRequest request);
  Future<List<ReviewModel>> getRideReviews(String rideId);
}

/// Review Repository Implementation
class ReviewRepositoryImpl implements ReviewRepository {
  final ApiService apiService;

  ReviewRepositoryImpl({required this.apiService});

  @override
  Future<ReviewModel> submitReview(ReviewRequest request) async {
    try {
      if (!request.isValid) {
        throw Exception('Invalid review: Rating must be between 1 and 5');
      }

      final response = await apiService.post(
        '/add-review',
        data: request.toJson(),
      );
      
      if (response['success'] == 'success' && response['data'] != null) {
        return ReviewModel.fromJson(response['data']);
      }
      
      throw Exception(response['message'] ?? 'Failed to submit review');
    } catch (e) {
      throw Exception('Failed to submit review: $e');
    }
  }

  @override
  Future<List<ReviewModel>> getRideReviews(String rideId) async {
    try {
      final response = await apiService.get('/ride-reviews/$rideId');
      
      if (response['success'] == 'success' && response['data'] != null) {
        final List<dynamic> data = response['data'] as List;
        return data.map((json) => ReviewModel.fromJson(json)).toList();
      }
      
      throw Exception(response['message'] ?? 'Failed to load reviews');
    } catch (e) {
      throw Exception('Failed to load reviews: $e');
    }
  }
}
