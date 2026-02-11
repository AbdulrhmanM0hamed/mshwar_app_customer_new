import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../common/widget/button.dart';
import '../../../../common/widget/custom_text.dart';
import '../../../../core/themes/constant_colors.dart';
import '../../../../core/utils/dark_theme_provider.dart';
import '../../../../generated/app_localizations.dart';
import '../../data/models/package_model.dart';

class PackageCard extends StatelessWidget {
  final PackageModel package;
  final VoidCallback onTap;

  const PackageCard({
    super.key,
    required this.package,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final isDark = themeChange.getThem();
    final l10n = AppLocalizations.of(context)!;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: isDark ? AppThemeData.grey800 : Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: package.name,
                          size: 18,
                          weight: FontWeight.bold,
                          color: isDark ? Colors.white : AppThemeData.grey900,
                        ),
                        const SizedBox(height: 4),
                        CustomText(
                          text: package.pricePerKmDisplay,
                          size: 13,
                          color: isDark ? AppThemeData.grey400Dark : AppThemeData.grey500,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppThemeData.primary200,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: CustomText(
                      text: package.formattedKm,
                      size: 14,
                      weight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              if (package.description != null && package.description!.isNotEmpty) ...[
                const SizedBox(height: 12),
                CustomText(
                  text: package.description!,
                  size: 13,
                  color: isDark ? AppThemeData.grey400Dark : AppThemeData.grey500,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 16),
              Divider(
                height: 1,
                color: isDark ? AppThemeData.grey300Dark : AppThemeData.grey200,
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: l10n.totalPrice,
                          size: 12,
                          color: isDark ? AppThemeData.grey400Dark : AppThemeData.grey500,
                        ),
                        const SizedBox(height: 4),
                        CustomText(
                          text: package.formattedPrice,
                          size: 22,
                          weight: FontWeight.bold,
                          color: AppThemeData.primary200,
                        ),
                      ],
                    ),
                  ),
                  CustomButton(
                    btnName: l10n.buyNow,
                    textColor: Colors.white,
                    ontap: onTap,
                    borderRadius: 12,
                    buttonColor: AppThemeData.primary200,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
