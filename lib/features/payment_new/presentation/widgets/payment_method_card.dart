import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/themes/constant_colors.dart';
import '../../../../core/utils/dark_theme_provider.dart';
import '../../../../common/widget/custom_text.dart';
import '../../data/models/payment_method_model.dart';

class PaymentMethodCard extends StatelessWidget {
  final PaymentMethodModel method;
  final bool isSelected;
  final VoidCallback onTap;

  const PaymentMethodCard({
    super.key,
    required this.method,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final isDarkMode = themeChange.getThem();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppThemeData.primary200.withValues(alpha: 0.1)
              : (isDarkMode
                  ? AppThemeData.grey200Dark
                  : AppThemeData.grey200),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppThemeData.primary200
                : (isDarkMode
                    ? AppThemeData.grey300Dark
                    : AppThemeData.grey300),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Payment Method Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppThemeData.primary200.withValues(alpha: 0.2)
                    : (isDarkMode
                        ? AppThemeData.grey300Dark
                        : AppThemeData.grey300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getPaymentIcon(method.name),
                color: isSelected
                    ? AppThemeData.primary200
                    : (isDarkMode
                        ? AppThemeData.grey500Dark
                        : AppThemeData.grey500),
                size: 24,
              ),
            ),

            const SizedBox(width: 16),

            // Payment Method Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: method.name,
                    size: 16,
                    weight: FontWeight.w600,
                    color: isDarkMode
                        ? AppThemeData.grey900Dark
                        : AppThemeData.grey900,
                  ),
                  if (method.description != null) ...[
                    const SizedBox(height: 4),
                    CustomText(
                      text: method.description!,
                      size: 12,
                      color: isDarkMode
                          ? AppThemeData.grey500Dark
                          : AppThemeData.grey500,
                      maxLines: 2,
                    ),
                  ],
                ],
              ),
            ),

            // Selection Indicator
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? AppThemeData.primary200
                      : (isDarkMode
                          ? AppThemeData.grey500Dark
                          : AppThemeData.grey500),
                  width: 2,
                ),
                color: isSelected
                    ? AppThemeData.primary200
                    : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      size: 16,
                      color: Colors.white,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getPaymentIcon(String type) {
    switch (type.toLowerCase()) {
      case 'cash':
        return Icons.money;
      case 'wallet':
        return Icons.account_balance_wallet;
      case 'card':
      case 'credit_card':
      case 'debit_card':
        return Icons.credit_card;
      case 'paypal':
        return Icons.payment;
      case 'stripe':
        return Icons.credit_score;
      default:
        return Icons.payment;
    }
  }
}
