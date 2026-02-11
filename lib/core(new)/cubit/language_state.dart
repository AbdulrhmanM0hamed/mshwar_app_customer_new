part of 'language_cubit.dart';

class LanguageState extends Equatable {
  const LanguageState({
    required this.locale,
    this.isLoading = false,
    this.error,
  });

  final Locale locale;
  final bool isLoading;
  final String? error;

  @override
  List<Object?> get props => [locale, isLoading, error];

  LanguageState copyWith({
    Locale? locale,
    bool? isLoading,
    String? error,
  }) {
    return LanguageState(
      locale: locale ?? this.locale,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}
