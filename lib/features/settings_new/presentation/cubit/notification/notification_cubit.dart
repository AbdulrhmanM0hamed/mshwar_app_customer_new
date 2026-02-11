import 'package:cabme/features/settings_new/data/repositories/notification_repository.dart';
import 'package:cabme/features/settings_new/presentation/cubit/notification/notification_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final NotificationRepository repository;
  int _offset = 0;
  final int _limit = 20;

  NotificationCubit({required this.repository}) : super(NotificationInitial());

  Future<void> loadNotifications({bool refresh = false}) async {
    if (refresh) {
      _offset = 0;
      emit(NotificationLoading());
    } else if (state is NotificationLoaded) {
      // Don't emit loading here to avoid full screen loader on pagination
    } else {
      emit(NotificationLoading());
    }

    try {
      final notifications = await repository.getNotifications(
        limit: _limit,
        offset: _offset,
      );
      final unreadCount = await repository.getUnreadCount();

      if (refresh) {
        emit(NotificationLoaded(
          notifications: notifications,
          unreadCount: unreadCount,
          hasMore: notifications.length == _limit,
        ));
      } else if (state is NotificationLoaded) {
        final currentNotifications = (state as NotificationLoaded).notifications;
        emit(NotificationLoaded(
          notifications: [...currentNotifications, ...notifications],
          unreadCount: unreadCount,
          hasMore: notifications.length == _limit,
        ));
      } else {
        emit(NotificationLoaded(
          notifications: notifications,
          unreadCount: unreadCount,
          hasMore: notifications.length == _limit,
        ));
      }
      _offset += notifications.length;
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }
  
  Future<void> markAsRead(int notificationId) async {
    if (state is NotificationLoaded) {
      final currentState = state as NotificationLoaded;
      final updatedNotifications = currentState.notifications.map((n) {
          if (n.id == notificationId) {
             // Create copy with isRead = true. NotificationModel is immutable but doesn't have copyWith.
             // We'll rely on reloading or just optimistic update if we had copyWith.
             // For now, let's reload or trust the repository and then reload.
             // Ideally implementing copyWith on model would be better.
             return n; // Placeholder
          }
          return n;
      }).toList();
       // Actually without copyWith on model, let's just call API and then refresh or update counts locally if possible.
       // The repository call is async.
       
       await repository.markAsRead(notificationId);
       
       // Optimal: update local state without full reload
       // Since I didn't verify copyWith on model, I'll fetch unread count again.
       final unreadCount = await repository.getUnreadCount();
       
       // Refresh list to show read status if the UI depends on it (e.g. bold text)
       // Or better: Assume success and update UI.
       loadNotifications(refresh: true); 
    }
  }

  Future<void> markAllAsRead() async {
      await repository.markAllAsRead();
      loadNotifications(refresh: true);
  }

  Future<void> deleteNotification(int notificationId) async {
      final result = await repository.deleteNotification(notificationId);
      if (result && state is NotificationLoaded) {
          final currentState = state as NotificationLoaded;
          final updatedList = currentState.notifications.where((n) => n.id != notificationId).toList();
          emit(currentState.copyWith(notifications: updatedList));
      }
  }
}
