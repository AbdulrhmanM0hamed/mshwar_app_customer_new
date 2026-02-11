import 'package:cabme/core(new)/network/api_service.dart';
import 'package:cabme/features/settings_new/data/models/notification_model.dart';
import 'package:cabme/service/api.dart';
import 'package:cabme/core/utils/Preferences.dart';

abstract class NotificationRepository {
  Future<List<NotificationModel>> getNotifications(
      {int limit = 20, int offset = 0});
  Future<int> getUnreadCount();
  Future<bool> markAsRead(int notificationId);
  Future<bool> markAllAsRead();
  Future<bool> deleteNotification(int notificationId);
}

class NotificationRepositoryImpl implements NotificationRepository {
  final ApiService apiService;

  NotificationRepositoryImpl({required this.apiService});

  @override
  Future<List<NotificationModel>> getNotifications(
      {int limit = 20, int offset = 0}) async {
    final userId = Preferences.getInt(Preferences.userId);
    if (userId == 0) return [];

    final url = "${API.getNotifications(limit: limit, offset: offset)}&user_id=$userId";

    try {
      final response = await apiService.get(url);

      if (response is Map<String, dynamic>) {
        if (response['success'] == 'success' || response['success'] == true) {
          if (response['data'] != null) {
            return (response['data'] as List)
                .map((e) => NotificationModel.fromJson(e))
                .toList();
          }
        }
      }
    } catch (e) {
      // Handle error or return empty
    }
    return [];
  }

  @override
  Future<int> getUnreadCount() async {
    final userId = Preferences.getInt(Preferences.userId);
    final url = "${API.getUnreadCount()}&user_id=$userId";
    try {
      final response = await apiService.get(url);

      if (response is Map<String, dynamic>) {
        if (response['success'] == 'success' || response['success'] == true) {
          return response['unread_count'] ?? 0;
        }
      }
    } catch (e) {
      // Handle error
    }
    return 0;
  }

  @override
  Future<bool> markAsRead(int notificationId) async {
    final userId = Preferences.getInt(Preferences.userId);
    final url = "${API.markAsRead(notificationId)}&user_id=$userId";
    try {
      final response = await apiService.post(url);
      if (response is Map<String, dynamic>) {
        return response['success'] == 'success';
      }
    } catch (e) {
      // Handle error
    }
    return false;
  }

  @override
  Future<bool> markAllAsRead() async {
    final userId = Preferences.getInt(Preferences.userId);
    final url = "${API.markAllAsRead()}&user_id=$userId";
    try {
      final response = await apiService.post(url);
      if (response is Map<String, dynamic>) {
        return response['success'] == 'success';
      }
    } catch (e) {
      // Handle error
    }
    return false;
  }

  @override
  Future<bool> deleteNotification(int notificationId) async {
    final userId = Preferences.getInt(Preferences.userId);
    final url = "${API.deleteNotification(notificationId)}&user_id=$userId";
    try {
      final response = await apiService.delete(url);
      if (response is Map<String, dynamic>) {
        return response['success'] == 'success';
      }
    } catch (e) {
      // Handle error
    }
    return false;
  }
}
