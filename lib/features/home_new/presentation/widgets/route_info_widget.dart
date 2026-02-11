import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/themes/constant_colors.dart';
import '../../../../core/utils/dark_theme_provider.dart';
import '../../../../generated/app_localizations.dart';
import '../../../../common/widget/custom_text.dart';
import '../../data/models/location_model.dart';

class RouteInfoWidget extends StatelessWidget {
  final LocationModel departure;
  final LocationModel destination;
  final String? distance;
  final String? duration;

  const RouteInfoWidget({
    super.key,
    required this.departure,
    required this.destination,
    this.distance,
    this.duration,
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
        children: [
          // Departure
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppThemeData.success200.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Iconsax.location,
                  color: AppThemeData.success200,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: l10n.pickup,
                      size: 12,
                      color: isDarkMode
                          ? AppThemeData.grey500Dark
                          : AppThemeData.grey500,
                    ),
                    const SizedBox(height: 2),
                    CustomText(
                      text: departure.address,
                      size: 14,
                      weight: FontWeight.w600,
                      color: isDarkMode
                          ? AppThemeData.grey900Dark
                          : AppThemeData.grey900,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Divider with dots
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                const SizedBox(width: 15),
                Container(
                  width: 2,
                  height: 30,
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? AppThemeData.grey300Dark
                        : AppThemeData.grey300,
                  ),
                ),
                const SizedBox(width: 12),
                if (distance != null || duration != null)
                  Expanded(
                    child: Row(
                      children: [
                        if (distance != null) ...[
                          Icon(
                            Iconsax.routing,
                            size: 14,
                            color: isDarkMode
                                ? AppThemeData.grey500Dark
                                : AppThemeData.grey500,
                          ),
                          const SizedBox(width: 4),
                          CustomText(
                            text: distance!,
                            size: 12,
                            color: isDarkMode
                                ? AppThemeData.grey500Dark
                                : AppThemeData.grey500,
                          ),
                        ],
                        if (distance != null && duration != null)
                          const SizedBox(width: 12),
                        if (duration != null) ...[
                          Icon(
                            Iconsax.clock,
                            size: 14,
                            color: isDarkMode
                                ? AppThemeData.grey500Dark
                                : AppThemeData.grey500,
                          ),
                          const SizedBox(width: 4),
                          CustomText(
                            text: duration!,
                            size: 12,
                            color: isDarkMode
                                ? AppThemeData.grey500Dark
                                : AppThemeData.grey500,
                          ),
                        ],
                      ],
                    ),
                  ),
              ],
            ),
          ),

          // Destination
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppThemeData.error200.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Iconsax.location,
                  color: AppThemeData.error200,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: l10n.dropoff,
                      size: 12,
                      color: isDarkMode
                          ? AppThemeData.grey500Dark
                          : AppThemeData.grey500,
                    ),
                    const SizedBox(height: 2),
                    CustomText(
                      text: destination.address,
                      size: 14,
                      weight: FontWeight.w600,
                      color: isDarkMode
                          ? AppThemeData.grey900Dark
                          : AppThemeData.grey900,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
