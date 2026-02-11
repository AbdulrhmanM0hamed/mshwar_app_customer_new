import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/themes/constant_colors.dart';
import '../../../../generated/app_localizations.dart';
import '../../../../common/widget/custom_text.dart';

class PackageSelectorWidget extends StatelessWidget {
  final bool isDarkMode;
  final bool usePackage;
  final double packageKmAvailable;
  final double packageKmToUse;
  final Function(bool) onTogglePackage;

  const PackageSelectorWidget({
    Key? key,
    required this.isDarkMode,
    required this.usePackage,
    required this.packageKmAvailable,
    required this.packageKmToUse,
    required this.onTogglePackage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Don't show if no package available
    if (packageKmAvailable <= 0) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: isDarkMode
              ? AppThemeData.grey300Dark
              : AppThemeData.grey300,
        ),
        borderRadius: BorderRadius.circular(12),
        color: usePackage
            ? AppThemeData.primary200.withOpacity(0.05)
            : Colors.transparent,
      ),
      child: Column(
        children: [
          // Toggle Row
          ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: usePackage
                    ? AppThemeData.primary200.withOpacity(0.1)
                    : (isDarkMode
                        ? AppThemeData.grey200Dark
                        : AppThemeData.grey200),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Iconsax.box,
                color: usePackage
                    ? AppThemeData.primary200
                    : (isDarkMode
                        ? AppThemeData.grey500Dark
                        : AppThemeData.grey500),
                size: 20,
              ),
            ),
            title: CustomText(
              text: l10n.usePackageKm,
              size: 16,
              weight: FontWeight.w600,
              color: isDarkMode
                  ? AppThemeData.grey900Dark
                  : AppThemeData.grey900,
            ),
            subtitle: CustomText(
              text: '${l10n.packageKmAvailable}: ${packageKmAvailable.toStringAsFixed(1)} KM',
              size: 12,
              weight: FontWeight.normal,
              color: isDarkMode
                  ? AppThemeData.grey500Dark
                  : AppThemeData.grey500,
            ),
            trailing: Switch(
              value: usePackage,
              onChanged: onTogglePackage,
              activeColor: AppThemeData.primary200,
            ),
          ),

          // Package Details (shown when enabled)
          if (usePackage) ...[
            Divider(
              height: 1,
              color: isDarkMode
                  ? AppThemeData.grey300Dark
                  : AppThemeData.grey300,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // KM to use
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: l10n.packageKmToUse,
                        size: 14,
                        weight: FontWeight.normal,
                        color: isDarkMode
                            ? AppThemeData.grey500Dark
                            : AppThemeData.grey500,
                      ),
                      CustomText(
                        text: '${packageKmToUse.toStringAsFixed(1)} KM',
                        size: 14,
                        weight: FontWeight.w600,
                        color: AppThemeData.primary200,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Remaining KM
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: l10n.packageKmRemaining,
                        size: 14,
                        weight: FontWeight.normal,
                        color: isDarkMode
                            ? AppThemeData.grey500Dark
                            : AppThemeData.grey500,
                      ),
                      CustomText(
                        text: '${(packageKmAvailable - packageKmToUse).toStringAsFixed(1)} KM',
                        size: 14,
                        weight: FontWeight.w600,
                        color: isDarkMode
                            ? AppThemeData.grey900Dark
                            : AppThemeData.grey900,
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Info message
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppThemeData.success200.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Iconsax.info_circle,
                          size: 16,
                          color: AppThemeData.success200,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: CustomText(
                            text: l10n.packageKmDiscountInfo,
                            size: 12,
                            weight: FontWeight.normal,
                            color: AppThemeData.success200,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
