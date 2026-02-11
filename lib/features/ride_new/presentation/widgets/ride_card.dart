import 'package:cabme/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/themes/constant_colors.dart';
import '../../../../common/widget/custom_text.dart';
import '../../data/models/ride_model.dart';

/// Ride Card Widget - Displays ride information in a card
class RideCard extends StatelessWidget {
  final RideModel ride;
  final VoidCallback onTap;
  final bool isDarkMode;

  const RideCard({
    super.key,
    required this.ride,
    required this.onTap,
    this.isDarkMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDarkMode ? AppThemeData.grey800Dark : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDarkMode ? AppThemeData.grey300Dark : AppThemeData.grey200,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Ride ID and Status
            Row(
              children: [
                CustomText(
                  text: 'Ride #${ride.id}',
                  size: 14,
                  weight: FontWeight.w600,
                  color: isDarkMode ? AppThemeData.grey900Dark : AppThemeData.grey900,
                ),
                const Spacer(),
                _buildStatusBadge(context),
              ],
            ),
            const SizedBox(height: 16),
            
            // Pickup Location
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppThemeData.success50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Iconsax.location,
                    color: AppThemeData.success300,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: l10n.pickup,
                        size: 11,
                        weight: FontWeight.w500,
                        color: isDarkMode ? AppThemeData.grey500Dark : AppThemeData.grey500,
                      ),
                      const SizedBox(height: 2),
                      CustomText(
                        text: ride.pickupName,
                        size: 13,
                        weight: FontWeight.w500,
                        color: isDarkMode ? AppThemeData.grey900Dark : AppThemeData.grey900,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            // Connector Line
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 4, bottom: 4),
              child: Container(
                width: 2,
                height: 16,
                color: isDarkMode 
                    ? AppThemeData.grey300Dark.withValues(alpha: 0.3)
                    : AppThemeData.grey300.withValues(alpha: 0.3),
              ),
            ),
            
            // Dropoff Location
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppThemeData.error50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Iconsax.location5,
                    color: AppThemeData.warning200,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: l10n.dropoff,
                        size: 11,
                        weight: FontWeight.w500,
                        color: isDarkMode ? AppThemeData.grey500Dark : AppThemeData.grey500,
                      ),
                      const SizedBox(height: 2),
                      CustomText(
                        text: ride.dropoffName,
                        size: 13,
                        weight: FontWeight.w500,
                        color: isDarkMode ? AppThemeData.grey900Dark : AppThemeData.grey900,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Footer: Distance, Amount, Date
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDarkMode ? AppThemeData.grey800 : AppThemeData.grey100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  // Distance
                  Expanded(
                    child: Row(
                      children: [
                        Icon(
                          Iconsax.routing,
                          size: 14,
                          color: isDarkMode ? AppThemeData.grey500Dark : AppThemeData.grey500,
                        ),
                        const SizedBox(width: 6),
                        CustomText(
                          text: '${ride.distance} ${ride.distanceUnit}',
                          size: 12,
                          weight: FontWeight.w500,
                          color: isDarkMode ? AppThemeData.grey500Dark : AppThemeData.grey500,
                        ),
                      ],
                    ),
                  ),
                  
                  // Amount
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppThemeData.primary50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CustomText(
                      text: '${ride.amount} KWD',
                      size: 13,
                      weight: FontWeight.w700,
                      color: AppThemeData.primary200,
                    ),
                  ),
                ],
              ),
            ),
            
            // Driver Info (if available)
            if (ride.hasDriver) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Iconsax.user,
                    size: 14,
                    color: isDarkMode ? AppThemeData.grey500Dark : AppThemeData.grey500,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: CustomText(
                      text: ride.driverName ?? 'Driver',
                      size: 12,
                      weight: FontWeight.w500,
                      color: isDarkMode ? AppThemeData.grey500Dark : AppThemeData.grey500,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (ride.driverRating != null && ride.driverRatingValue > 0) ...[
                    Icon(
                      Iconsax.star1,
                      size: 12,
                      color: Colors.amber,
                    ),
                    const SizedBox(width: 4),
                    CustomText(
                      text: ride.driverRating!,
                      size: 12,
                      weight: FontWeight.w600,
                      color: isDarkMode ? AppThemeData.grey900Dark : AppThemeData.grey900,
                    ),
                  ],
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    Color bgColor;
    Color textColor;
    
    switch (ride.status) {
      case 'confirmed':
        bgColor = AppThemeData.primary50;
        textColor = AppThemeData.primary200;
        break;
      case 'on_ride':
      case 'driver_arrived':
        bgColor = AppThemeData.success50;
        textColor = AppThemeData.success300;
        break;
      case 'completed':
        bgColor = AppThemeData.grey100;
        textColor = AppThemeData.grey500;
        break;
      case 'cancelled':
      case 'rejected':
        bgColor = AppThemeData.error50;
        textColor = AppThemeData.error200;
        break;
      default:
        bgColor = AppThemeData.primary50;
        textColor = AppThemeData.warning200;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: CustomText(
        text: ride.statusDisplay,
        size: 11,
        weight: FontWeight.w600,
        color: textColor,
      ),
    );
  }
}
