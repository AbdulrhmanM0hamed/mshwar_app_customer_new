import 'package:cabme/core(new)/utils/theme/app_theme.dart';
import 'package:cabme/service_locator.dart';
import 'package:cabme/core/config/app_initialization.dart';
import 'package:cabme/core/cubit/theme_cubit.dart';
import 'package:cabme/features/splash/splash_screen.dart';
import 'package:cabme/service/localization_service.dart';
import 'package:cabme/core/utils/dark_theme_provider.dart';
import 'package:cabme/generated/app_localizations.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

/// Firebase background message handler
/// Handles incoming FCM messages when app is in background or terminated
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Background handler is already initialized in AppInitializer
  // This is just a reference point for Firebase
}

/// Global navigator key for navigation from anywhere in the app
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  // Initialize all app dependencies
  await AppInitialization.initializeAppDependencies();
  setupAllDependencies();

  // Run app with Device Preview in debug mode only
  runApp(
    DevicePreview(
      enabled: kDebugMode, // Enable only in debug mode
      builder: (context) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize app components (FCM, Theme, etc.)
    final themeProvider = DarkThemeProvider();
    AppInitialization.initializeAppComponents(
      navigatorKey: navigatorKey,
      themeProvider: themeProvider,
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DarkThemeProvider>.value(value: themeProvider),
        BlocProvider<ThemeCubit>(
          create: (context) => ThemeCubit(themeProvider),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          final currentLocale = DevicePreview.locale(context) ??
              LocalizationService.getCurrentLocale();
          final isRTL = LocalizationService.isRTL(currentLocale);

          return MaterialApp(
            navigatorKey: navigatorKey,
            title: 'Mshwar',
            debugShowCheckedModeBanner: false,

            // Theme configuration
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeState.isDark
                ? ThemeMode.dark
                : themeState.isLight
                    ? ThemeMode.light
                    : ThemeMode.system,

            // Device Preview
            locale: currentLocale,
            builder: (context, child) {
              child = DevicePreview.appBuilder(context, child);
              return Directionality(
                textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                child: EasyLoading.init()(context, child),
              );
            },

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
            localeResolutionCallback: (locale, supportedLocales) {
              return currentLocale;
            },

            // Home screen
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
