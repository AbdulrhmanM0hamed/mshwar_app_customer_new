import 'package:cabme/common/widget/custom_app_bar.dart';
import 'package:cabme/core/themes/constant_colors.dart';
import 'package:cabme/core/utils/dark_theme_provider.dart';
import 'package:cabme/features/settings_new/data/repositories/settings_repository.dart';
import 'package:cabme/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class TermsOfServicePage extends StatelessWidget {
  const TermsOfServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final isDarkMode = themeChange.getThem();
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor:
          isDarkMode ? AppThemeData.surface50Dark : AppThemeData.surface50,
      appBar: CustomAppBar(
        title: l10n.termsConditions,
        showBackButton: true,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: FutureBuilder<String>(
        future: GetIt.I<SettingsRepository>().getTermsOfService(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: AppThemeData.primary200),
            );
          }
          if (snapshot.hasError) {
            return Center(
                child: Text(snapshot.error.toString(),
                    textAlign: TextAlign.center));
          }
          final htmlContent = snapshot.data ?? '';

          if (htmlContent.isEmpty) {
            return Center(child: Text(l10n.noContentAvailable));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Html(
              data: htmlContent,
              style: {
                "body": Style(
                  color: isDarkMode
                      ? AppThemeData.grey900Dark
                      : AppThemeData.grey900,
                  fontSize: FontSize(14),
                  fontFamily: 'Cairo',
                ),
              },
            ),
          );
        },
      ),
    );
  }
}
