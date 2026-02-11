import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/themes/constant_colors.dart';
import '../../../../core/utils/dark_theme_provider.dart';
import '../../../../generated/app_localizations.dart';
import '../../../../common/widget/custom_text.dart';
import '../../data/models/price_calculation_model.dart';

class PriceSummaryWidget extends StatelessWidget {
  final PriceCalculationModel priceCalculation;

  const PriceSummaryWidget({
    super.key,
    required this.priceCalculation,
  });

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final l10n = AppLocalizations.of(context)!;
    final isDarkMode = themeChange.getThem();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode
            ? AppThemeData.grey200Dark
            : AppThemeData.grey200,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDarkMode
              ? AppThemeData.grey300Dark
              : AppThemeData.grey300,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: l10n.priceSummary,
            size: 16,
            weight: FontWeight.bold,
            color: isDarkMode
                ? AppThemeData.grey900Dark
                : AppThemeData.grey900,
          ),

          const SizedBox(height: 16),

          // Base Price
          _buildPriceRow(
            l10n.basePrice,
            priceCalculation.basePrice,
            isDarkMode,
          ),

          const SizedBox(height: 8),

          // Distance Price
          _buildPriceRow(
            l10n.distancePrice,
            priceCalculation.distancePrice,
            isDarkMode,
          ),

          const SizedBox(height: 8),

          // Time Price
          if (priceCalculation.timePrice > 0) ...[
            _buildPriceRow(
              l10n.timePrice,
              priceCalculation.timePrice,
              isDarkMode,
            ),
            const SizedBox(height: 8),
          ],

          // Discount
          if (priceCalculation.discount > 0) ...[
            _buildPriceRow(
              l10n.discount,
              -priceCalculation.discount,
              isDarkMode,
              isDiscount: true,
            ),
            const SizedBox(height: 8),
          ],

          // Package KM Discount
          if (priceCalculation.couponDiscount != null && 
              priceCalculation.couponDiscount! > 0) ...[
            _buildPriceRow(
              l10n.packageDiscount,
              -priceCalculation.couponDiscount!,
              isDarkMode,
              isDiscount: true,
            ),
            const SizedBox(height: 8),
          ],

          const Divider(height: 24),

          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: l10n.total,
                size: 18,
                weight: FontWeight.bold,
                color: isDarkMode
                    ? AppThemeData.grey900Dark
                    : AppThemeData.grey900,
              ),
              CustomText(
                text: '\$${priceCalculation.finalPrice.toStringAsFixed(2)}',
                size: 24,
                weight: FontWeight.bold,
                color: AppThemeData.primary200,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(
    String label,
    double amount,
    bool isDarkMode, {
    bool isDiscount = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          text: label,
          size: 14,
          color: isDarkMode
              ? AppThemeData.grey500Dark
              : AppThemeData.grey500,
        ),
        CustomText(
          text: '\$${amount.abs().toStringAsFixed(2)}',
          size: 14,
          weight: FontWeight.w600,
          color: isDiscount
              ? AppThemeData.success200
              : (isDarkMode
                  ? AppThemeData.grey900Dark
                  : AppThemeData.grey900),
        ),
      ],
    );
  }
}
