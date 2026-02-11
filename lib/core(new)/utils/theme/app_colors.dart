import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors from the new palette
  static const Color primary = Color(0xFF005879); // Professional Blue #1b558c
  static const Color primarySecondary = Color(
    0xFF01425A,
  ); // Light Blue Azure #48a4e1

  // Secondary Colors
  static const Color beige = Color(0xFFF5F5DA); // Beige #f5f5da
  static const Color brightOrange = Color(0xFFFA7216); // Bright Orange #fa7216
  static const Color yellow = Color(0xFFFFD700); // Yellow #ffd700
  static const Color deepOrange = Color(0xFFC3420D); // Deep Orange Red #c3420d
  static const Color charcoalGray = Color(0xFF384151); // Charcoal Gray #384151
  static const Color lightGray = Color(0xFFE6E7EA); // Light Gray #e6e7ea
  static const Color softGreen = Color(0xFFB9E788); // Soft Green #b9e788
  static const Color errorRed = Color(0xFFE53F3E); // Error Red #e53f3e
  static const Color green = Color(0xFF10B981); // Soft Green
  static const Color red = Color(0xFFE53F3E); // Error Red

  // Background Colors
  static const Color scaffoldBackground = Color(0xFFF5F5DA); // Beige background
  static const Color cardBackground = Colors.white;
  static const Color lightGrey = Color.fromARGB(
    221,
    227,
    232,
    238,
  ); // Light Gray

  // Text Colors
  static const Color textPrimary = Color.fromARGB(
    255,
    44,
    51,
    63,
  ); // Charcoal Gray for primary text
  static const Color textSecondary = Color(
    0xFF1B558C,
  ); // Professional Blue for secondary text
  static const Color textLight = Colors.white;
  static const Color textLight70 = Color.fromARGB(255, 118, 118, 118);
  static const Color black = Color.fromARGB(255, 0, 0, 0);

  // Status Colors
  static const Color success = Color.fromARGB(255, 35, 192, 7); // Soft Green
  static const Color error = Color(0xFFE53F3E); // Error Red
  static const Color warning = Color(0xFFFA7216); // Bright Orange
  static const Color info = Color(0xFF48A4E1); // Light Blue Azure

  // Border Colors
  static const Color borderColor = Color(0xFFE6E7EA); // Light Gray
  static const Color divider = Color.fromARGB(34, 225, 225, 225);
  static const Color grey = Color(0xFF384151); // Charcoal Gray

  // Rating Colors
  static const Color starActive = Color(0xFFFA7216); // Bright Orange
  static const Color starInactive = Color(0xFFE6E7EA); // Light Gray

  // Shimmer Colors
  static const Color shimmerBase = Color(0xFFE6E7EA); // Light Gray
  static const Color shimmerHighlight = Color(0xFFF5F5DA); // Beige
  static const Color white = Color.fromARGB(255, 255, 255, 255);

  static Color getContainerBackgroundColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.grey[800]! // لون داكن للوضع الليلي
        : Colors.grey[100]!; // لون فاتح للوضع النهاري
  }
}
