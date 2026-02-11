import 'package:cabme/core(new)/network/api_service.dart';
import '../models/chat_message_model.dart';

/// Chat Repository Interface
abstract class ChatRepository {
  Future<List<ChatMessageModel>> getChatMessages(String rideId);
  Future<ChatMessageModel> sendMessage(String rideId, String message);
  Future<ChatMessageModel> sendImage(String rideId, String imagePath);
  Future<void> markAsRead(String messageId);
}

/// Chat Repository Implementation
class ChatRepositoryImpl implements ChatRepository {
  final ApiService apiService;

  ChatRepositoryImpl({required this.apiService});

  @override
  Future<List<ChatMessageModel>> getChatMessages(String rideId) async {
    try {
      final response = await apiService.get('/ride-chat/$rideId');
      
      if (response['success'] == 'success' && response['data'] != null) {
        final List<dynamic> data = response['data'] as List;
        return data.map((json) => ChatMessageModel.fromJson(json)).toList();
      }
      
      throw Exception(response['message'] ?? 'Failed to load chat messages');
    } catch (e) {
      throw Exception('Failed to load chat messages: $e');
    }
  }

  @override
  Future<ChatMessageModel> sendMessage(String rideId, String message) async {
    try {
      final response = await apiService.post(
        '/send-message',
        data: {
          'ride_id': rideId,
          'message': message,
          'message_type': 'text',
        },
      );
      
      if (response['success'] == 'success' && response['data'] != null) {
        return ChatMessageModel.fromJson(response['data']);
      }
      
      throw Exception(response['message'] ?? 'Failed to send message');
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }

  @override
  Future<ChatMessageModel> sendImage(String rideId, String imagePath) async {
    try {
      final response = await apiService.post(
        '/upload-chat-image',
        data: {
          'ride_id': rideId,
          'image_path': imagePath,
          'message_type': 'image',
        },
      );
      
      if (response['success'] == 'success' && response['data'] != null) {
        return ChatMessageModel.fromJson(response['data']);
      }
      
      throw Exception(response['message'] ?? 'Failed to send image');
    } catch (e) {
      throw Exception('Failed to send image: $e');
    }
  }

  @override
  Future<void> markAsRead(String messageId) async {
    try {
      final response = await apiService.post(
        '/mark-message-read',
        data: {'message_id': messageId},
      );
      
      if (response['success'] != 'success') {
        throw Exception(response['message'] ?? 'Failed to mark message as read');
      }
    } catch (e) {
      throw Exception('Failed to mark message as read: $e');
    }
  }
}
