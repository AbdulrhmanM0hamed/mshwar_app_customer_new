import 'package:cabme/service/localization_service.dart';
import 'package:cabme/core/themes/styles.dart';
import 'package:cabme/core/utils/dark_theme_provider.dart';
import 'package:cabme/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

/// App Configuration - Handles theme, localization, and app settings
class AppConfig {
  /// Get Material App configuration
  static Widget getMaterialApp({
    required GlobalKey<NavigatorState> navigatorKey,
    required Widget home,
    required DarkThemeProvider themeProvider,
    Locale? devicePreviewLocale,
    Widget Function(BuildContext, Widget?)? devicePreviewBuilder,
  }) {
    final currentLocale =
        devicePreviewLocale ?? LocalizationService.getCurrentLocale();
    final isRTL = LocalizationService.isRTL(currentLocale);

    return ChangeNotifierProvider.value(
      value: themeProvider,
      child: Consumer<DarkThemeProvider>(
        builder: (context, value, child) {
          return MaterialApp(
            navigatorKey: navigatorKey,
            title: 'Mshwar',
            debugShowCheckedModeBanner: false,

            // Locale configuration
            locale: currentLocale,

            // Builder for Device Preview and RTL
            builder: (context, child) {
              // Apply Device Preview builder if provided
              if (devicePreviewBuilder != null) {
                child = devicePreviewBuilder(context, child);
              }

              return Directionality(
                textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                child: EasyLoading.init()(context, child),
              );
            },

            // Theme configuration
            theme: Styles.themeData(
              themeProvider.darkTheme == 0
                  ? true
                  : themeProvider.darkTheme == 1
                      ? false
                      : themeProvider.getSystemThem(),
              context,
            ),

            // Localization configuration
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', 'US'),
              Locale('ar', 'AE'),
              Locale('ur', 'PK'),
            ],

            // Home screen
            home: home,
          );
        },
      ),
    );
  }
}
