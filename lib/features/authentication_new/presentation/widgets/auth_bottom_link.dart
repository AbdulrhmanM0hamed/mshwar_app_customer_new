import 'package:cabme/core/themes/constant_colors.dart';
import 'package:cabme/core/utils/dark_theme_provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Helper widget for the bottom link section (e.g., "Already have an account? Log in")
class AuthBottomLink extends StatelessWidget {
  final String text;
  final String linkText;
  final VoidCallback onTap;

  const AuthBottomLink({
    super.key,
    required this.text,
    required this.linkText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final isDarkMode = themeChange.getThem();

    return Center(
      child: Text.rich(
        TextSpan(
          text: text,
          style: TextStyle(
            fontSize: 15,
            fontFamily: 'Cairo',
            color: isDarkMode ? AppThemeData.grey500Dark : AppThemeData.grey800,
          ),
          children: <TextSpan>[
            const TextSpan(text: ' '),
            TextSpan(
              text: linkText,
              style: TextStyle(
                fontSize: 15,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.bold,
                color: AppThemeData.primary200,
              ),
              recognizer: TapGestureRecognizer()..onTap = onTap,
            ),
          ],
        ),
      ),
    );
  }
}
