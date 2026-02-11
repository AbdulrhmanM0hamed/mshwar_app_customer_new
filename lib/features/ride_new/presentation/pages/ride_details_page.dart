import 'package:cabme/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../../../../core/themes/constant_colors.dart';
import '../../../../common/widget/custom_app_bar.dart';
import '../../../../common/widget/custom_text.dart';
import '../../../../common/widget/button.dart';
import '../../../../common/widget/light_bordered_card.dart';
import '../../../../core/utils/dark_theme_provider.dart';
import '../../../../core/constant/constant.dart';
import '../cubit/active_ride/active_ride_cubit.dart';
import '../cubit/active_ride/active_ride_state.dart';
import '../widgets/driver_info_widget.dart';
import '../widgets/ride_status_widget.dart';
import 'chat_page.dart';
import 'add_review_page.dart';
import 'add_complaint_page.dart';

/// Ride Details Page - Displays detailed ride information
class RideDetailsPage extends StatelessWidget {
  final String rideId;

  const RideDetailsPage({
    super.key,
    required this.rideId,
  });

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final isDark = themeChange.getThem();
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (context) => GetIt.I<ActiveRideCubit>()..loadRideDetails(rideId),
      child: Scaffold(
        backgroundColor: isDark ? AppThemeData.surface50Dark : AppThemeData.surface50,
        appBar: CustomAppBar(
          title: l10n.rideDetails,
          showBackButton: true,
          onBackPressed: () => Navigator.pop(context),
        ),
        body: BlocBuilder<ActiveRideCubit, ActiveRideState>(
          builder: (context, state) {
            if (state is RideDetailsLoading) {
              return Center(
                child: CircularProgressIndicator(
                  color: isDark ? Colors.white : AppThemeData.primary200,
                ),
              );
            }

            if (state is RideDetailsError) {
              return _buildErrorState(context, state.message, isDark, l10n);
            }

            if (state is RideDetailsLoaded) {
              final ride = state.ride;
              
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Status Banner
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? AppThemeData.grey800Dark : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDark ? AppThemeData.grey300Dark : AppThemeData.grey200,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  text: 'Ride #${ride.id}',
                                  size: 16,
                                  weight: FontWeight.w600,
                                  color: isDark ? AppThemeData.grey900Dark : AppThemeData.grey900,
                                ),
                                const SizedBox(height: 8),
                                RideStatusWidget(
                                  status: ride.status,
                                  isDarkMode: isDark,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Driver Info (if available)
                    if (ride.hasDriver) ...[
                      DriverInfoWidget(
                        ride: ride,
                        isDarkMode: isDark,
                        onCallDriver: () {
                          if (ride.driverPhone != null) {
                            Constant.makePhoneCall(ride.driverPhone!);
                          }
                        },
                        onChatDriver: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatPage(rideId: ride.id),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                    ],
                    
                    // Route Information
                    LightBorderedCard(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Iconsax.route_square,
                                size: 20,
                                color: AppThemeData.primary200,
                              ),
                              const SizedBox(width: 8),
                              CustomText(
                                text: l10n.route,
                                size: 18,
                                weight: FontWeight.w600,
                                color: isDark ? AppThemeData.grey900Dark : AppThemeData.grey900,
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          
                          // Pickup
                          _buildLocationRow(
                            icon: Iconsax.location,
                            iconColor: AppThemeData.success300,
                            iconBg: AppThemeData.success50,
                            label: l10n.pickup,
                            address: ride.pickupName,
                            isDark: isDark,
                          ),
                          
                          // Connector
                          Padding(
                            padding: const EdgeInsets.only(left: 19, top: 8, bottom: 8),
                            child: Container(
                              width: 2,
                              height: 20,
                              color: isDark 
                                  ? AppThemeData.grey300Dark.withValues(alpha: 0.3)
                                  : AppThemeData.grey300.withValues(alpha: 0.3),
                            ),
                          ),
                          
                          // Dropoff
                          _buildLocationRow(
                            icon: Iconsax.location5,
                            iconColor: AppThemeData.warning200,
                            iconBg: AppThemeData.error50,
                            label: l10n.dropoff,
                            address: ride.dropoffName,
                            isDark: isDark,
                          ),
                          
                          // Distance Info
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isDark ? AppThemeData.grey800 : AppThemeData.grey100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Iconsax.routing,
                                  size: 16,
                                  color: isDark ? AppThemeData.grey500Dark : AppThemeData.grey500,
                                ),
                                const SizedBox(width: 8),
                                CustomText(
                                  text: '${ride.distance} ${ride.distanceUnit}',
                                  size: 13,
                                  weight: FontWeight.w500,
                                  color: isDark ? AppThemeData.grey500Dark : AppThemeData.grey500,
                                ),
                                const Spacer(),
                                CustomText(
                                  text: '${ride.amount} KWD',
                                  size: 14,
                                  weight: FontWeight.w700,
                                  color: AppThemeData.primary200,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Action Buttons
                    if (ride.isActive) ...[
                      CustomButton(
                        btnName: l10n.cancelRide,
                        buttonColor: AppThemeData.error200,
                        textColor: Colors.white,
                        borderRadius: 12,
                        ontap: () => _showCancelDialog(context, ride.id, isDark, l10n),
                      ),
                      const SizedBox(height: 12),
                    ],
                    
                    if (ride.isCompleted) ...[
                      Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              btnName: l10n.addReview,
                              buttonColor: AppThemeData.primary200,
                              textColor: Colors.white,
                              borderRadius: 12,
                              ontap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddReviewPage(ride: ride),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: CustomButton(
                              btnName: l10n.addComplaint,
                              buttonColor: AppThemeData.error200,
                              textColor: Colors.white,
                              borderRadius: 12,
                              ontap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddComplaintPage(ride: ride),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildLocationRow({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String label,
    required String address,
    required bool isDark,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: iconBg,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: label,
                size: 12,
                weight: FontWeight.w500,
                color: isDark ? AppThemeData.grey500Dark : AppThemeData.grey500,
              ),
              const SizedBox(height: 4),
              CustomText(
                text: address,
                size: 14,
                weight: FontWeight.w500,
                color: isDark ? AppThemeData.grey900Dark : AppThemeData.grey900,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(BuildContext context, String message, bool isDark, AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Iconsax.warning_2, size: 64, color: AppThemeData.error200),
            const SizedBox(height: 16),
            CustomText(
              text: l10n.errorLoadingRides,
              size: 18,
              weight: FontWeight.w600,
              color: isDark ? AppThemeData.grey900Dark : AppThemeData.grey900,
            ),
            const SizedBox(height: 8),
            CustomText(
              text: message,
              size: 14,
              color: isDark ? AppThemeData.grey500Dark : AppThemeData.grey500,
              align: TextAlign.center,
            ),
            const SizedBox(height: 24),
            CustomButton(
              btnName: l10n.retry,
              buttonColor: AppThemeData.primary200,
              textColor: Colors.white,
              borderRadius: 12,
              ontap: () {
                context.read<ActiveRideCubit>().loadRideDetails(rideId);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showCancelDialog(BuildContext context, String rideId, bool isDark, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: isDark ? AppThemeData.grey800Dark : Colors.white,
        title: CustomText(
          text: l10n.confirmCancellation,
          size: 18,
          weight: FontWeight.w600,
          color: isDark ? AppThemeData.grey900Dark : AppThemeData.grey900,
        ),
        content: CustomText(
          text: l10n.areYouSureYouWantToCancelThisRide,
          size: 14,
          color: isDark ? AppThemeData.grey500Dark : AppThemeData.grey500,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: CustomText(
              text: l10n.no,
              size: 14,
              color: isDark ? AppThemeData.grey500Dark : AppThemeData.grey500,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<ActiveRideCubit>().cancelRide({'id_ride': rideId});
            },
            child: CustomText(
              text: l10n.yes,
              size: 14,
              color: AppThemeData.error200,
              weight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
