import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/themes/constant_colors.dart';
import '../../../../generated/app_localizations.dart';
import '../../../../common/widget/custom_text.dart';

class PendingPaymentDialog {
  static Future<bool?> show({
    required BuildContext context,
    required bool isDarkMode,
    required String rideId,
    required double amount,
    required VoidCallback onPayNow,
  }) {
    final l10n = AppLocalizations.of(context)!;

    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: isDarkMode
            ? AppThemeData.surface50Dark
            : AppThemeData.surface50,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Warning Icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppThemeData.warning200.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Iconsax.warning_2,
                  size: 40,
                  color: AppThemeData.warning200,
                ),
              ),
              const SizedBox(height: 24),

              // Title
              CustomText(
                text: l10n.pendingPayment,
                size: 20,
                weight: FontWeight.w700,
                color: isDarkMode
                    ? AppThemeData.grey900Dark
                    : AppThemeData.grey900,
                align: TextAlign.center,
              ),
              const SizedBox(height: 12),

              // Message
              CustomText(
                text: l10n.pendingPaymentMessage,
                size: 14,
                weight: FontWeight.normal,
                color: isDarkMode
                    ? AppThemeData.grey500Dark
                    : AppThemeData.grey500,
                align: TextAlign.center,
                maxLines: 3,
              ),
              const SizedBox(height: 24),

              // Amount Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? AppThemeData.grey200Dark
                      : AppThemeData.grey200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: l10n.amountDue,
                      size: 14,
                      weight: FontWeight.normal,
                      color: isDarkMode
                          ? AppThemeData.grey500Dark
                          : AppThemeData.grey500,
                    ),
                    CustomText(
                      text: '\$${amount.toStringAsFixed(2)}',
                      size: 20,
                      weight: FontWeight.w700,
                      color: AppThemeData.error200,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Buttons
              Row(
                children: [
                  // Later Button
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context, false),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: isDarkMode
                              ? AppThemeData.grey300Dark
                              : AppThemeData.grey300,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: CustomText(
                        text: l10n.later,
                        size: 14,
                        weight: FontWeight.w600,
                        color: isDarkMode
                            ? AppThemeData.grey500Dark
                            : AppThemeData.grey500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Pay Now Button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, true);
                        onPayNow();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppThemeData.primary200,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: CustomText(
                        text: l10n.payNow,
                        size: 14,
                        weight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Simple version without amount details
  static Future<bool?> showSimple({
    required BuildContext context,
    required bool isDarkMode,
    required VoidCallback onPayNow,
  }) {
    final l10n = AppLocalizations.of(context)!;

    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: isDarkMode
            ? AppThemeData.surface50Dark
            : AppThemeData.surface50,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(
              Iconsax.warning_2,
              color: AppThemeData.warning200,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CustomText(
                text: l10n.pendingPayment,
                size: 18,
                weight: FontWeight.w700,
                color: isDarkMode
                    ? AppThemeData.grey900Dark
                    : AppThemeData.grey900,
              ),
            ),
          ],
        ),
        content: CustomText(
          text: l10n.pendingPaymentMessage,
          size: 14,
          weight: FontWeight.normal,
          color: isDarkMode
              ? AppThemeData.grey500Dark
              : AppThemeData.grey500,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: CustomText(
              text: l10n.later,
              size: 14,
              weight: FontWeight.w600,
              color: isDarkMode
                  ? AppThemeData.grey500Dark
                  : AppThemeData.grey500,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, true);
              onPayNow();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppThemeData.primary200,
            ),
            child: CustomText(
              text: l10n.payNow,
              size: 14,
              weight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
