import 'package:cabme/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/themes/constant_colors.dart';
import '../../../../common/widget/custom_text.dart';
import '../../../../core/constant/constant.dart';
import '../../data/models/ride_model.dart';

/// Driver Info Widget - Displays driver information with photo and rating
class DriverInfoWidget extends StatelessWidget {
  final RideModel ride;
  final bool isDarkMode;
  final VoidCallback? onCallDriver;
  final VoidCallback? onChatDriver;

  const DriverInfoWidget({
    super.key,
    required this.ride,
    this.isDarkMode = false,
    this.onCallDriver,
    this.onChatDriver,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    if (!ride.hasDriver) {
      return _buildNoDriverCard(context, l10n);
    }
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? AppThemeData.grey800Dark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode ? AppThemeData.grey300Dark : AppThemeData.grey200,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Driver Photo
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: _buildDriverPhoto(),
          ),
          const SizedBox(width: 16),
          
          // Driver Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: ride.driverName ?? 'Driver',
                  size: 16,
                  weight: FontWeight.w600,
                  color: isDarkMode ? AppThemeData.grey900Dark : AppThemeData.grey900,
                ),
                const SizedBox(height: 4),
                
                // Rating
                if (ride.driverRating != null && ride.driverRatingValue > 0)
                  Row(
                    children: [
                      Icon(
                        Iconsax.star1,
                        size: 14,
                        color: Colors.amber,
                      ),
                      const SizedBox(width: 4),
                      CustomText(
                        text: ride.driverRating!,
                        size: 13,
                        weight: FontWeight.w600,
                        color: isDarkMode ? AppThemeData.grey900Dark : AppThemeData.grey900,
                      ),
                      const SizedBox(width: 4),
                      CustomText(
                        text: '(Rating)',
                        size: 12,
                        color: isDarkMode ? AppThemeData.grey500Dark : AppThemeData.grey500,
                      ),
                    ],
                  ),
                
                // Vehicle Info
                if (ride.vehiclePlate != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Iconsax.car,
                        size: 12,
                        color: isDarkMode ? AppThemeData.grey500Dark : AppThemeData.grey500,
                      ),
                      const SizedBox(width: 4),
                      CustomText(
                        text: ride.vehiclePlate!,
                        size: 12,
                        weight: FontWeight.w500,
                        color: isDarkMode ? AppThemeData.grey500Dark : AppThemeData.grey500,
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          
          // Action Buttons
          Column(
            children: [
              // Call Button
              if (onCallDriver != null && ride.driverPhone != null)
                InkWell(
                  onTap: onCallDriver,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppThemeData.success50,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Iconsax.call,
                      size: 20,
                      color: AppThemeData.success300,
                    ),
                  ),
                ),
              
              // Chat Button
              if (onChatDriver != null) ...[
                const SizedBox(height: 8),
                InkWell(
                  onTap: onChatDriver,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppThemeData.primary50,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Iconsax.message,
                      size: 20,
                      color: AppThemeData.primary200,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDriverPhoto() {
    if (ride.driverPhoto != null && 
        ride.driverPhoto!.isNotEmpty && 
        ride.driverPhoto != 'null') {
      return CachedNetworkImage(
        imageUrl: ride.driverPhoto!,
        height: 70,
        width: 70,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          height: 70,
          width: 70,
          color: AppThemeData.grey200,
          child: const Center(
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
        errorWidget: (context, url, error) => _buildPlaceholderPhoto(),
      );
    }
    
    return _buildPlaceholderPhoto();
  }

  Widget _buildPlaceholderPhoto() {
    return Container(
      height: 70,
      width: 70,
      decoration: BoxDecoration(
        color: AppThemeData.grey200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        Iconsax.user,
        size: 35,
        color: AppThemeData.grey400,
      ),
    );
  }

  Widget _buildNoDriverCard(BuildContext context, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? AppThemeData.grey800Dark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode ? AppThemeData.grey300Dark : AppThemeData.grey200,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppThemeData.primary50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Iconsax.search_normal,
              size: 32,
              color: AppThemeData.warning200,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: l10n.searchingForDriver,
                  size: 16,
                  weight: FontWeight.w600,
                  color: isDarkMode ? AppThemeData.grey900Dark : AppThemeData.grey900,
                ),
                const SizedBox(height: 4),
                CustomText(
                  text: l10n.pleaseWait,
                  size: 13,
                  color: isDarkMode ? AppThemeData.grey500Dark : AppThemeData.grey500,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
