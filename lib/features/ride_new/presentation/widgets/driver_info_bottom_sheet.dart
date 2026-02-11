import 'package:cabme/common/widget/custom_text.dart';
import 'package:cabme/common/widget/StarRating.dart';
import 'package:cabme/core/constant/constant.dart';
import 'package:cabme/core/themes/constant_colors.dart';
import 'package:cabme/core/utils/dark_theme_provider.dart';
import 'package:cabme/generated/app_localizations.dart';
import 'package:cabme/features/ride_new/data/models/ride_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

/// Driver Info Bottom Sheet - Shows driver details, contact, and car info
class DriverInfoBottomSheet extends StatelessWidget {
  final RideModel ride;
  final String? driverStatus; // 'online', 'en-route', 'arrived', 'offline'

  const DriverInfoBottomSheet({
    super.key,
    required this.ride,
    this.driverStatus,
  });

  Color _getStatusColor() {
    switch (driverStatus?.toLowerCase()) {
      case 'online':
        return AppThemeData.success300;
      case 'en-route':
        return AppThemeData.secondary200;
      case 'arrived':
        return AppThemeData.warning200;
      case 'offline':
        return AppThemeData.grey400;
      default:
        return AppThemeData.success300;
    }
  }

  String _getStatusText(AppLocalizations l10n) {
    switch (driverStatus?.toLowerCase()) {
      case 'online':
        return l10n.online;
      case 'en-route':
        return l10n.enRoute;
      case 'arrived':
        return l10n.arrived;
      case 'offline':
        return l10n.offline;
      default:
        return l10n.online;
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final isDarkMode = themeChange.getThem();
    final l10n = AppLocalizations.of(context)!;
    final bool showDriverInfo = Constant.showDriverInfoBeforePayment == "yes";

    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? AppThemeData.surface50Dark : AppThemeData.surface50,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color:
                  isDarkMode ? AppThemeData.grey400Dark : AppThemeData.grey400,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Driver Photo
                if (showDriverInfo) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(60),
                    child: _buildDriverPhoto(),
                  ),
                  const SizedBox(height: 12),
                  // Driver Name and Status
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            CustomText(
                              text: ride.driverName ?? '',
                              size: 20,
                              weight: FontWeight.w600,
                              align: TextAlign.center,
                              color: isDarkMode
                                  ? AppThemeData.grey900Dark
                                  : AppThemeData.grey900,
                            ),
                            const SizedBox(height: 4),
                            // Status Badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: _getStatusColor().withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: _getStatusColor(),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: _getStatusColor(),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  CustomText(
                                    text: _getStatusText(l10n),
                                    size: 12,
                                    weight: FontWeight.w500,
                                    color: _getStatusColor(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Rating
                  StarRating(
                    size: 20,
                    rating: ride.driverRatingValue,
                    color: AppThemeData.warning200,
                  ),
                  const SizedBox(height: 20),
                ] else ...[
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDarkMode
                          ? AppThemeData.grey200Dark
                          : AppThemeData.grey200,
                    ),
                    child: Icon(
                      Icons.person,
                      size: 60,
                      color: isDarkMode
                          ? AppThemeData.grey400Dark
                          : AppThemeData.grey400,
                    ),
                  ),
                  const SizedBox(height: 12),
                  CustomText(
                    text: l10n.driverInfoAfterPayment,
                    align: TextAlign.center,
                    size: 14,
                    weight: FontWeight.normal,
                    fontStyle: FontStyle.italic,
                    color: isDarkMode
                        ? AppThemeData.grey500Dark
                        : AppThemeData.grey500,
                  ),
                ],
                // Driver Contact and Car Details
                if (showDriverInfo) ...[
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: isDarkMode
                            ? AppThemeData.grey300Dark
                            : AppThemeData.grey300,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        // Phone Number
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Iconsax.call,
                                    size: 20,
                                    color: AppThemeData.secondary200,
                                  ),
                                  const SizedBox(width: 10),
                                  CustomText(
                                    text: l10n.driverContact,
                                    size: 16,
                                    weight: FontWeight.normal,
                                    color: isDarkMode
                                        ? AppThemeData.grey900Dark
                                        : AppThemeData.grey900,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  CustomText(
                                    text: ride.driverPhone ?? '',
                                    size: 16,
                                    weight: FontWeight.w500,
                                    color: isDarkMode
                                        ? AppThemeData.grey900Dark
                                        : AppThemeData.grey900,
                                  ),
                                  const SizedBox(width: 8),
                                  InkWell(
                                    splashColor: Colors.transparent,
                                    onTap: () {
                                      Constant.makePhoneCall(
                                          ride.driverPhone ?? '');
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: AppThemeData.secondary200,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Iconsax.call,
                                        size: 16,
                                        color: AppThemeData.surface50,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Divider
                        Container(
                          color: isDarkMode
                              ? AppThemeData.grey300Dark
                              : AppThemeData.grey300,
                          height: 1,
                        ),
                        // Car Details
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Iconsax.car,
                                    size: 20,
                                    color: AppThemeData.secondary200,
                                  ),
                                  const SizedBox(width: 10),
                                  CustomText(
                                    text: l10n.carDetails,
                                    size: 16,
                                    weight: FontWeight.normal,
                                    color: isDarkMode
                                        ? AppThemeData.grey900Dark
                                        : AppThemeData.grey900,
                                  ),
                                ],
                              ),
                              CustomText(
                                text:
                                    "${ride.vehicleBrand ?? ''} ${ride.vehicleModel ?? ''}",
                                size: 16,
                                weight: FontWeight.w500,
                                color: isDarkMode
                                    ? AppThemeData.grey900Dark
                                    : AppThemeData.grey900,
                              ),
                            ],
                          ),
                        ),
                        // Divider
                        Container(
                          color: isDarkMode
                              ? AppThemeData.grey300Dark
                              : AppThemeData.grey300,
                          height: 1,
                        ),
                        // License Plate
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText(
                                text: l10n.licensePlate,
                                size: 16,
                                weight: FontWeight.normal,
                                color: isDarkMode
                                    ? AppThemeData.grey900Dark
                                    : AppThemeData.grey900,
                              ),
                              CustomText(
                                text: ride.vehiclePlate ?? '',
                                size: 16,
                                weight: FontWeight.w600,
                                color: AppThemeData.secondary200,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                // Close Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppThemeData.secondary200,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: CustomText(
                      text: l10n.close,
                      size: 16,
                      weight: FontWeight.w600,
                      color: AppThemeData.surface50,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).padding.bottom + 16,
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
        fit: BoxFit.cover,
        height: 100,
        width: 100,
        placeholder: (context, url) => const Center(
          child: CircularProgressIndicator(),
        ),
        errorWidget: (context, url, error) => Image.asset(
          "assets/icons/appLogo.png",
          fit: BoxFit.cover,
          height: 100,
          width: 100,
        ),
      );
    }
    return Image.asset(
      "assets/icons/appLogo.png",
      fit: BoxFit.cover,
      height: 100,
      width: 100,
    );
  }

  /// Show the bottom sheet
  static Future<void> show({
    required BuildContext context,
    required RideModel ride,
    String? driverStatus,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DriverInfoBottomSheet(
        ride: ride,
        driverStatus: driverStatus,
      ),
    );
  }
}
