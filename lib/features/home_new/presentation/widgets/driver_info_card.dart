import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/themes/constant_colors.dart';
import '../../../../core/utils/dark_theme_provider.dart';
import '../../../../generated/app_localizations.dart';
import '../../../../common/widget/custom_text.dart';
import '../../data/models/ride_response_model.dart';

class DriverInfoCard extends StatelessWidget {
  final DriverInfo driver;

  const DriverInfoCard({
    super.key,
    required this.driver,
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
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: l10n.driverDetails,
            size: 16,
            weight: FontWeight.bold,
            color: isDarkMode
                ? AppThemeData.grey900Dark
                : AppThemeData.grey900,
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              // Driver Avatar
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppThemeData.primary200.withOpacity(0.1),
                  shape: BoxShape.circle,
                  image: driver.photo != null
                      ? DecorationImage(
                          image: NetworkImage(driver.photo!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: driver.photo == null
                    ? Icon(
                        Iconsax.user,
                        color: AppThemeData.primary200,
                        size: 32,
                      )
                    : null,
              ),

              const SizedBox(width: 16),

              // Driver Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: driver.name,
                      size: 16,
                      weight: FontWeight.bold,
                      color: isDarkMode
                          ? AppThemeData.grey900Dark
                          : AppThemeData.grey900,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Iconsax.star1,
                          size: 14,
                          color: AppThemeData.warning200,
                        ),
                        const SizedBox(width: 4),
                        CustomText(
                          text: driver.rating.toStringAsFixed(1),
                          size: 14,
                          weight: FontWeight.w600,
                          color: isDarkMode
                              ? AppThemeData.grey900Dark
                              : AppThemeData.grey900,
                        ),
                        const SizedBox(width: 4),
                        CustomText(
                          text: '(${driver.totalRides} ${l10n.rides})',
                          size: 12,
                          color: isDarkMode
                              ? AppThemeData.grey500Dark
                              : AppThemeData.grey500,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Call Button
              IconButton(
                onPressed: () {
                  // Handle call driver
                },
                icon: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppThemeData.success200.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Iconsax.call,
                    color: AppThemeData.success200,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Vehicle Info
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? AppThemeData.grey300Dark
                  : AppThemeData.grey300,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Iconsax.car,
                  color: isDarkMode
                      ? AppThemeData.grey500Dark
                      : AppThemeData.grey500,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: '${driver.vehicle.brand} ${driver.vehicle.model}',
                        size: 14,
                        weight: FontWeight.w600,
                        color: isDarkMode
                            ? AppThemeData.grey900Dark
                            : AppThemeData.grey900,
                      ),
                      const SizedBox(height: 2),
                      CustomText(
                        text: driver.vehicle.numberPlate,
                        size: 12,
                        color: isDarkMode
                            ? AppThemeData.grey500Dark
                            : AppThemeData.grey500,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppThemeData.primary200.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomText(
                    text: driver.vehicle.color,
                    size: 12,
                    weight: FontWeight.w600,
                    color: AppThemeData.primary200,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
