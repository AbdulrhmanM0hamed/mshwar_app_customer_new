import 'package:cabme/common/widget/button.dart';
import 'package:cabme/common/widget/custom_app_bar.dart';
import 'package:cabme/core/themes/constant_colors.dart';
import 'package:cabme/core/utils/Preferences.dart';
import 'package:cabme/core/utils/dark_theme_provider.dart';
import 'package:cabme/features/authentication_new/presentation/pages/login_page.dart';
import 'package:cabme/features/home_new/presentation/pages/home_page.dart';
import 'package:cabme/features/splash/splash_screen.dart';
import 'package:cabme/generated/app_localizations.dart';
import 'package:cabme/service/localization_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class LocalizationPage extends StatefulWidget {
  final bool isFromSettings;

  const LocalizationPage({super.key, this.isFromSettings = false});

  @override
  State<LocalizationPage> createState() => _LocalizationPageState();
}

class _LocalizationPageState extends State<LocalizationPage> {
  String _selectedLanguage = 'en';

  final List<Map<String, String>> _languages = [
    {
      'code': 'en',
      'name': 'English',
      'nativeName': 'English',
      'flag': 'https://flagcdn.com/w40/us.png'
    },
    {
      'code': 'ar',
      'name': 'Arabic',
      'nativeName': 'العربية',
      'flag': 'https://flagcdn.com/w40/ae.png'
    },
    {
      'code': 'ur',
      'name': 'Urdu',
      'nativeName': 'اردو',
      'flag': 'https://flagcdn.com/w40/pk.png'
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  void _loadLanguage() {
    final savedLang = Preferences.getString(Preferences.languageCodeKey);
    setState(() {
      _selectedLanguage = savedLang.isNotEmpty ? savedLang : 'en';
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final isDarkMode = themeChange.getThem();
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor:
          isDarkMode ? AppThemeData.surface50Dark : AppThemeData.surface50,
      appBar: widget.isFromSettings
          ? CustomAppBar(
              title: l10n.changeLanguage,
              showBackButton: true,
              onBackPressed: () => Navigator.pop(context),
            )
          : null,
      body: SafeArea(
        child: Column(
          children: [
            if (!widget.isFromSettings)
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Text(
                      l10n.selectLanguage,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode
                            ? AppThemeData.grey900Dark
                            : AppThemeData.grey900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.chooseLanguageDesc,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDarkMode
                            ? AppThemeData.grey500Dark
                            : AppThemeData.grey500,
                      ),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _languages.length,
                itemBuilder: (context, index) {
                  final lang = _languages[index];
                  final isSelected = _selectedLanguage == lang['code'];
                  return _buildLanguageCard(
                    lang,
                    isSelected,
                    isDarkMode,
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CustomButton(
                btnName: widget.isFromSettings ? l10n.save : l10n.continuee,
                buttonColor: AppThemeData.primary200,
                textColor: Colors.white,
                ontap: () async {
                  await Preferences.setString(
                      Preferences.languageCodeKey, _selectedLanguage);
                  LocalizationService().changeLocale(_selectedLanguage);

                  if (context.mounted) {
                    if (widget.isFromSettings) {
                      // Re-initialize app to apply changes fully (especially RTL)
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => const SplashScreen()),
                        (route) => false,
                      );
                    } else {
                      // Navigate to next screen (Login or Onboarding)
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                        (route) => false,
                      );
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageCard(
    Map<String, String> lang,
    bool isSelected,
    bool isDarkMode,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              _selectedLanguage = lang['code']!;
            });
          },
          borderRadius: BorderRadius.circular(16),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppThemeData.primary200.withValues(alpha: 0.1)
                  : isDarkMode
                      ? AppThemeData.grey800Dark
                      : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? AppThemeData.primary200
                    : isDarkMode
                        ? AppThemeData.grey800Dark
                        : AppThemeData.grey200,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isDarkMode
                          ? AppThemeData.grey800Dark
                          : AppThemeData.grey200,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(9),
                    child: CachedNetworkImage(
                      imageUrl: lang['flag']!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(strokeWidth: 2)),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.flag),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lang['name']!,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? AppThemeData.primary200
                              : isDarkMode
                                  ? AppThemeData.grey900Dark
                                  : AppThemeData.grey900,
                        ),
                      ),
                      Text(
                        lang['nativeName']!,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDarkMode
                              ? AppThemeData.grey500Dark
                              : AppThemeData.grey500,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppThemeData.primary200,
                    ),
                    child:
                        const Icon(Icons.check, size: 12, color: Colors.white),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
