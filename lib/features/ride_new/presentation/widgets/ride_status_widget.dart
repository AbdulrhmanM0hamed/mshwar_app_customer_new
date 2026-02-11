import 'package:cabme/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/themes/constant_colors.dart';
import '../../../../common/widget/custom_text.dart';

/// Ride Status Widget - Displays ride status with icon and color
class RideStatusWidget extends StatelessWidget {
  final String status;
  final bool isDarkMode;
  final bool showIcon;
  final double size;

  const RideStatusWidget({
    super.key,
    required this.status,
    this.isDarkMode = false,
    this.showIcon = true,
    this.size = 14,
  });

  @override
  Widget build(BuildContext context) {
    final statusInfo = _getStatusInfo(context);
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showIcon) ...[
          Icon(
            statusInfo.icon,
            size: size,
            color: statusInfo.color,
          ),
          const SizedBox(width: 6),
        ],
        CustomText(
          text: statusInfo.text,
          size: size,
          weight: FontWeight.w600,
          color: statusInfo.color,
        ),
      ],
    );
  }

  _StatusInfo _getStatusInfo(BuildContext context) {
    switch (status.toLowerCase()) {
      case 'pending':
      case 'new':
        return _StatusInfo(
          text: 'Searching for driver',
          icon: Iconsax.search_normal,
          color: AppThemeData.warning200,
        );
      case 'confirmed':
        return _StatusInfo(
          text: 'Driver assigned',
          icon: Iconsax.tick_circle,
          color: AppThemeData.primary200,
        );
      case 'driver_arrived':
        return _StatusInfo(
          text: 'Driver arrived',
          icon: Iconsax.location_tick,
          color: AppThemeData.success300,
        );
      case 'on_ride':
      case 'onride':
        return _StatusInfo(
          text: 'On ride',
          icon: Iconsax.car,
          color: AppThemeData.success300,
        );
      case 'completed':
        return _StatusInfo(
          text: 'Completed',
          icon: Iconsax.tick_circle,
          color: AppThemeData.grey500,
        );
      case 'cancelled':
        return _StatusInfo(
          text: 'Cancelled',
          icon: Iconsax.close_circle,
          color: AppThemeData.error200,
        );
      case 'rejected':
        return _StatusInfo(
          text: 'Rejected',
          icon: Iconsax.close_circle,
          color: AppThemeData.error200,
        );
      default:
        return _StatusInfo(
          text: status,
          icon: Iconsax.info_circle,
          color: isDarkMode ? AppThemeData.grey500Dark : AppThemeData.grey500,
        );
    }
  }
}

class _StatusInfo {
  final String text;
  final IconData icon;
  final Color color;

  _StatusInfo({
    required this.text,
    required this.icon,
    required this.color,
  });
}
