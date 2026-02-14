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
  final List<LocationModel>? stops;
  final String? distance;
  final String? duration;

  const RouteInfoWidget({
    super.key,
    required this.departure,
    required this.destination,
    this.stops,
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
        color: isDarkMode ? AppThemeData.grey200Dark : AppThemeData.grey200,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDarkMode ? AppThemeData.grey300Dark : AppThemeData.grey300,
        ),
      ),
      child: Column(
        children: [
          // Departure
          _buildStopItem(
            context: context,
            label: l10n.pickup,
            address: departure.address,
            iconColor: AppThemeData.success200,
            isDarkMode: isDarkMode,
            isFirst: true,
          ),

          // Intermediate Stops
          if (stops != null && stops!.isNotEmpty)
            ...stops!.asMap().entries.map((entry) {
              return _buildStopItem(
                context: context,
                label: "${l10n.stop} ${entry.key + 1}",
                address: entry.value.address,
                iconColor: AppThemeData.primary200,
                isDarkMode: isDarkMode,
              );
            }),

          // Destination
          _buildStopItem(
            context: context,
            label: l10n.dropoff,
            address: destination.address,
            iconColor: AppThemeData.error200,
            isDarkMode: isDarkMode,
            isLast: true,
            distance: distance,
            duration: duration,
          ),
        ],
      ),
    );
  }

  Widget _buildStopItem({
    required BuildContext context,
    required String label,
    required String address,
    required Color iconColor,
    required bool isDarkMode,
    bool isFirst = false,
    bool isLast = false,
    String? distance,
    String? duration,
  }) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Iconsax.location,
                    color: iconColor,
                    size: 18,
                  ),
                ),
                if (!isLast)
                  Container(
                    width: 2,
                    height: 30,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? AppThemeData.grey300Dark
                          : AppThemeData.grey300,
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: label,
                    size: 12,
                    color: isDarkMode
                        ? AppThemeData.grey500Dark
                        : AppThemeData.grey500,
                  ),
                  const SizedBox(height: 2),
                  CustomText(
                    text: address,
                    size: 14,
                    weight: FontWeight.w600,
                    color: isDarkMode
                        ? AppThemeData.grey900Dark
                        : AppThemeData.grey900,
                    maxLines: 2,
                  ),
                  if (isLast && (distance != null || duration != null)) ...[
                    const SizedBox(height: 8),
                    Row(
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
                            text: distance,
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
                            text: duration,
                            size: 12,
                            color: isDarkMode
                                ? AppThemeData.grey500Dark
                                : AppThemeData.grey500,
                          ),
                        ],
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
