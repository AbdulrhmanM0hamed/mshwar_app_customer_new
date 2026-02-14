import 'package:cabme/core/utils/Preferences.dart';
import 'package:flutter/material.dart';

class LocalizationService {
  // Default locale
  static const locale = Locale('en', 'US');

  static final locales = [
    const Locale('en', 'US'),
    const Locale('ar', 'AE'),
    const Locale('ur', 'PK'),
  ];

  // Get current locale from preferences or return default
  static Locale getCurrentLocale() {
    final langCode = Preferences.getString(Preferences.languageCodeKey);
    if (langCode.isEmpty) {
      return locale;
    }

    // Handle specific locale codes
    if (langCode == 'ar') {
      return const Locale('ar', 'AE');
    } else if (langCode == 'ur') {
      return const Locale('ur', 'PK');
    } else if (langCode == 'en') {
      return const Locale('en', 'US');
    }

    // Try to find matching locale
    for (var loc in locales) {
      if (loc.languageCode == langCode) {
        return loc;
      }
    }

    return locale;
  }

  // Check if locale is RTL
  static bool isRTL(Locale? locale) {
    if (locale == null) return false;
    return locale.languageCode == 'ar' || locale.languageCode == 'ur';
  }

  // Gets locale from language, and updates the locale
  // Since we're not using GetX anymore, this now just saves to preferences.
  // The app should be restarted (SplashScreen) to apply change fully.
  Future<void> changeLocale(String lang) async {
    await Preferences.setString(Preferences.languageCodeKey, lang);
  }
}
