import 'package:cabme/core/app_initializer.dart';
import 'package:cabme/core/services/fcm_service.dart';
import 'package:cabme/core/utils/dark_theme_provider.dart';
import 'package:flutter/material.dart';

/// App Initialization - Handles all app initialization logic
class AppInitialization {
  /// Initialize all app dependencies
  static Future<void> initializeAppDependencies() async {
    // Ensure Flutter binding is initialized
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize all app dependencies (Firebase, Notifications, Maps, etc.)
    await AppInitializer.initializeApp();
  }

  /// Initialize app components after widget is created
  static Future<void> initializeAppComponents({
    required GlobalKey<NavigatorState> navigatorKey,
    required DarkThemeProvider themeProvider,
  }) async {
    // Load theme
    await _loadTheme(themeProvider);

    // Setup FCM
    await _setupFCM(navigatorKey);
  }

  /// Load current theme
  static Future<void> _loadTheme(DarkThemeProvider themeProvider) async {
    themeProvider.darkTheme =
        await themeProvider.darkThemePreference.getTheme();
  }

  /// Setup Firebase Cloud Messaging
  static Future<void> _setupFCM(GlobalKey<NavigatorState> navigatorKey) async {
    FCMService.initialize(navigatorKey);
    await FCMService.setupFCM();
  }

  /// Reload theme (for app lifecycle changes)
  static Future<void> reloadTheme(DarkThemeProvider themeProvider) async {
    await _loadTheme(themeProvider);
  }
}
