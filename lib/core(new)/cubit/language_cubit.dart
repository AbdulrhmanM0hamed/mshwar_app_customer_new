import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../network/dio_client.dart';
import '../services/language_refresh_service.dart';

part 'language_state.dart';

class LanguageCubit extends Cubit<LanguageState> {
  final SharedPreferences _prefs;
  
  LanguageCubit(this._prefs) : super(const LanguageState(locale: Locale('ar'))) {
    _loadSavedLanguage();
  }

  static const String _languageKey = 'selected_language';

  /// Load saved language from SharedPreferences
  Future<void> _loadSavedLanguage() async {
    if (isClosed) return; // تحقق من أن الـ Cubit لم يتم إغلاقه
    
    try {
      final savedLanguageCode = _prefs.getString(_languageKey) ?? 'ar';
      
      final locale = Locale(savedLanguageCode);
      if (!isClosed) {
        emit(LanguageState(locale: locale));
      }
      
      // Update DioClient language
      DioClient.instance.updateLanguage(savedLanguageCode);
    } catch (e) {
      // If error, default to Arabic
      if (!isClosed) {
        emit(const LanguageState(locale: Locale('ar')));
      }
    }
  }

  /// Change language and save to SharedPreferences
  Future<void> changeLanguage(String languageCode) async {
    if (isClosed) return; // تحقق من أن الـ Cubit لم يتم إغلاقه
    
    //////////print('🔄 LanguageCubit: Changing language from ${state.locale.languageCode} to $languageCode');
    
    try {
      emit(LanguageState(locale: Locale(languageCode), isLoading: true));
      //////////print('📤 LanguageCubit: Emitted loading state');
      
      // Save to SharedPreferences
      await _prefs.setString(_languageKey, languageCode);
      //////////print('💾 LanguageCubit: Saved to SharedPreferences');
      
      // Update DioClient language
      DioClient.instance.updateLanguage(languageCode);
      //////////print('🌐 LanguageCubit: Updated DioClient language');
      
      // Emit new state only if not closed
      if (!isClosed) {
        emit(LanguageState(locale: Locale(languageCode)));
        //////////print('✅ LanguageCubit: Language changed successfully to $languageCode');
        
        // Notify all registered cubits to refresh their data
        LanguageRefreshService.instance.notifyLanguageChanged(languageCode);
      }
      
    } catch (e) {
      //////////print('❌ LanguageCubit: Error changing language: $e');
      // If error, revert to previous state only if not closed
      if (!isClosed) {
        emit(LanguageState(
          locale: state.locale,
          error: 'فشل في تغيير اللغة',
        ));
      }
    }
  }

  /// Toggle between Arabic and English
  Future<void> toggleLanguage() async {
    final currentLanguage = state.locale.languageCode;
    final newLanguage = currentLanguage == 'ar' ? 'en' : 'ar';
    await changeLanguage(newLanguage);
  }

  /// Get current language code
  String get currentLanguageCode => state.locale.languageCode;

  /// Check if current language is Arabic
  bool get isArabic => state.locale.languageCode == 'ar';

  /// Check if current language is English
  bool get isEnglish => state.locale.languageCode == 'en';

  /// Get language display name
  String get currentLanguageName {
    return state.locale.languageCode == 'ar' ? 'العربية' : 'English';
  }

  /// Get opposite language display name
  String get oppositeLanguageName {
    return state.locale.languageCode == 'ar' ? 'English' : 'العربية';
  }
}
