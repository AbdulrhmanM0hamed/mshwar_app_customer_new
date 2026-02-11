import 'dart:convert';
import 'dart:io';
import 'package:cabme/core/constant/constant.dart';
import 'package:cabme/features/ride/ride/model/ride_model.dart';
import 'package:cabme/features/ride/chat/view/conversation_screen.dart';
import 'package:cabme/features/ride/ride/view/ride_details.dart';
import 'package:cabme/common/screens/botton_nav_bar.dart';
import 'package:cabme/features/ride/ride/view/route_view_screen.dart';
import 'package:cabme/service/api.dart';
import 'package:cabme/core/utils/Preferences.dart';
import 'package:cabme/common/widget/notification_dialog.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

/// FCM Service - Handles all Firebase Cloud Messaging operations
class FCMService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static GlobalKey<NavigatorState>? _navigatorKey;

  /// Initialize FCM Service with navigator key
  static void initialize(GlobalKey<NavigatorState> navigatorKey) {
    _navigatorKey = navigatorKey;
  }

  /// Setup Firebase Cloud Messaging
  static Future<void> setupFCM() async {
    await _initializeNotifications();

    // Request permissions
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    // For iOS, wait for APNS token
    if (Platform.isIOS) {
      try {
        String? apnsToken = await FirebaseMessaging.instance.getAPNSToken();
        if (apnsToken == null) {
          await Future.delayed(const Duration(seconds: 2));
          apnsToken = await FirebaseMessaging.instance.getAPNSToken();
        }
      } catch (e) {
        debugPrint('Error getting APNS token: $e');
      }
    }

    // Subscribe to topic
    try {
      await FirebaseMessaging.instance.subscribeToTopic("cabme_customer");
    } catch (e) {
      await Future.delayed(const Duration(seconds: 2));
      try {
        await FirebaseMessaging.instance.subscribeToTopic("cabme_customer");
      } catch (retryError) {
        debugPrint('Error subscribing to topic: $retryError');
      }
    }

    // Handle initial message
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      String title = initialMessage.notification?.title ??
          initialMessage.data['title'] ??
          'Notification';
      String body = initialMessage.notification?.body ??
          initialMessage.data['body'] ??
          initialMessage.data['message'] ??
          '';
      NotificationDialog.setPendingNotification(title, body);
      _handleNotificationTap(initialMessage);
    }

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        displayNotification(message);
      } else if (message.data.isNotEmpty) {
        displayNotification(message);
      }
    });

    // Handle notification taps
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

    // Handle token refresh
    FirebaseMessaging.instance.onTokenRefresh.listen((String newToken) {
      _updateTokenToBackend(newToken);
    });

    // Get initial token
    _getAndUpdateToken();
  }

  /// Initialize local notifications
  static Future<void> _initializeNotifications() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iOSInit = DarwinInitializationSettings();

    const initSettings = InitializationSettings(
      android: androidInit,
      iOS: iOSInit,
    );

    await _notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) async {},
    );

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'Notifications for important updates and broadcasts',
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
      showBadge: true,
    );

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  /// Display notification
  static void displayNotification(RemoteMessage message) async {
    final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    String title =
        message.notification?.title ?? message.data['title'] ?? 'Notification';
    String body = message.notification?.body ??
        message.data['body'] ??
        message.data['message'] ??
        '';

    const notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'high_importance_channel',
        'High Importance Notifications',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: true,
        enableVibration: true,
        playSound: true,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    await _notificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
      payload: jsonEncode(message.data),
    );

    if (_navigatorKey?.currentContext != null) {
      NotificationDialog.show(
        context: _navigatorKey!.currentContext!,
        title: title,
        message: body,
      );
    }
  }

  /// Handle notification tap
  static void _handleNotificationTap(RemoteMessage message) async {
    final data = message.data;

    String title =
        message.notification?.title ?? data['title'] ?? 'Notification';
    String body =
        message.notification?.body ?? data['body'] ?? data['message'] ?? '';

    if (data['type'] == 'broadcast') {
      NotificationDialog.setPendingNotification(title, body);

      try {
        // Navigate using Navigator instead of GetX
        if (_navigatorKey?.currentState != null) {
          await _navigatorKey!.currentState!.push(
            MaterialPageRoute(builder: (context) => BottomNavBar()),
          );

          Future.delayed(const Duration(milliseconds: 800), () {
            if (_navigatorKey?.currentContext != null) {
              NotificationDialog.showPendingNotification(
                  _navigatorKey!.currentContext!);
            }
          });
        }
      } catch (e) {
        debugPrint('Error navigating to dashboard: $e');
      }
      return;
    }

    NotificationDialog.setPendingNotification(title, body);
    Future.delayed(const Duration(milliseconds: 800), () {
      if (_navigatorKey?.currentContext != null) {
        NotificationDialog.showPendingNotification(
            _navigatorKey!.currentContext!);
      }
    });

    if (data['status'] == "done") {
      if (_navigatorKey?.currentState != null) {
        await _navigatorKey!.currentState!.push(
          MaterialPageRoute(
            builder: (context) => ConversationScreen(),
            settings: RouteSettings(
              arguments: {
                'receiverId': int.parse(
                  jsonDecode(data['message'])['senderId'].toString(),
                ),
                'orderId': int.parse(
                  jsonDecode(data['message'])['orderId'].toString(),
                ),
                'receiverName':
                    jsonDecode(data['message'])['senderName'].toString(),
                'receiverPhoto':
                    jsonDecode(data['message'])['senderPhoto'].toString(),
              },
            ),
          ),
        );
      }
    } else if (data['tag'] == 'driver_on_way' ||
        data['tag'] == 'driver_arrived' ||
        data['tag'] == 'driver_arrived_manual') {
      final rideId = data['ride_id'];
      if (rideId != null && _navigatorKey?.currentState != null) {
        try {
          await _navigatorKey!.currentState!.push(
            MaterialPageRoute(builder: (context) => BottomNavBar()),
          );
        } catch (e) {
          debugPrint('Error navigating to route screen: $e');
        }
      }
    } else if (data['statut'] == "confirmed" ||
        data['statut'] == "driver_rejected") {
      if (_navigatorKey?.currentState != null) {
        await _navigatorKey!.currentState!.push(
          MaterialPageRoute(builder: (context) => BottomNavBar()),
        );
      }
    } else if (data['statut'] == "on ride") {
      if (_navigatorKey?.currentState != null) {
        await _navigatorKey!.currentState!.push(
          MaterialPageRoute(
            builder: (context) => const RouteViewScreen(),
            settings: RouteSettings(
              arguments: {
                'type': 'on_ride', // Removed .tr since we're not using GetX
                'data': RideData.fromJson(data),
              },
            ),
          ),
        );
      }
    } else if (data['statut'] == "completed") {
      if (_navigatorKey?.currentState != null) {
        await _navigatorKey!.currentState!.push(
          MaterialPageRoute(
            builder: (context) => TripHistoryScreen(),
            settings: RouteSettings(
              arguments: {"rideData": RideData.fromJson(data)},
            ),
          ),
        );
      }
    }
  }

  /// Get and update FCM token
  static Future<void> _getAndUpdateToken() async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        _updateTokenToBackend(token);
      }
    } catch (e) {
      debugPrint('Error getting FCM token: $e');
    }
  }

  /// Update token to backend
  static Future<void> _updateTokenToBackend(String token) async {
    try {
      final userId = Preferences.getInt(Preferences.userId);
      if (userId == 0) return;

      // Always use direct API call instead of GetX controller
      await _updateFCMTokenDirectly(token);
    } catch (e) {
      debugPrint('Error updating FCM token: $e');
    }
  }

  /// Update FCM token directly to API
  static Future<void> _updateFCMTokenDirectly(String token) async {
    try {
      final userModel = Constant.getUserData();
      if (userModel.data == null) return;

      final Map<String, dynamic> bodyParams = {
        'user_id': Preferences.getInt(Preferences.userId),
        'fcm_id': token,
        'device_id': "",
        'user_cat': userModel.data!.userCat
      };

      await http.post(
        Uri.parse(API.updateToken),
        headers: API.header,
        body: jsonEncode(bodyParams),
      );
    } catch (e) {
      debugPrint('Error in direct token update: $e');
    }
  }
}
