import 'package:cabme/core/utils/dark_theme_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Theme State
class ThemeState {
  final int themeMode; // 0 = dark, 1 = light, 2 = system

  const ThemeState({required this.themeMode});

  bool get isDark => themeMode == 0;
  bool get isLight => themeMode == 1;
  bool get isSystem => themeMode == 2;
}

/// Theme Cubit
class ThemeCubit extends Cubit<ThemeState> {
  final DarkThemeProvider _themeProvider;

  ThemeCubit(this._themeProvider) : super(const ThemeState(themeMode: 2)) {
    _loadTheme();
  }

  /// Load theme from preferences
  Future<void> _loadTheme() async {
    final theme = await _themeProvider.darkThemePreference.getTheme();
    emit(ThemeState(themeMode: theme));
  }

  /// Toggle theme
  Future<void> toggleTheme() async {
    final newTheme = state.isDark ? 1 : 0;
    await _themeProvider.darkThemePreference.setDarkTheme(newTheme);
    emit(ThemeState(themeMode: newTheme));
  }

  /// Set specific theme
  Future<void> setTheme(int themeMode) async {
    await _themeProvider.darkThemePreference.setDarkTheme(themeMode);
    emit(ThemeState(themeMode: themeMode));
  }

  /// Get system theme
  bool getSystemTheme() {
    return _themeProvider.getSystemThem();
  }
}
