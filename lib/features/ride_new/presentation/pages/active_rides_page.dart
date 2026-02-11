import 'package:cabme/features/ride_new/presentation/pages/ride_details_page.dart';
import 'package:cabme/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/themes/constant_colors.dart';
import '../../../../common/widget/custom_app_bar.dart';
import '../../../../common/widget/custom_text.dart';
import '../../../../common/widget/button.dart';
import '../../../../core/utils/dark_theme_provider.dart';
import 'package:provider/provider.dart';
import '../cubit/active_ride/active_ride_cubit.dart';
import '../cubit/active_ride/active_ride_state.dart';
import '../widgets/ride_card.dart';

/// Active Rides Page - Displays current and scheduled rides
class ActiveRidesPage extends StatelessWidget {
  final bool showBackButton;

  const ActiveRidesPage({
    super.key,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final isDark = themeChange.getThem();
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (context) => GetIt.I<ActiveRideCubit>()..loadActiveRides(),
      child: Scaffold(
        backgroundColor: isDark ? AppThemeData.surface50Dark : AppThemeData.surface50,
        appBar: CustomAppBar(
          title: l10n.activeRides,
          showBackButton: showBackButton,
          onBackPressed: showBackButton ? () => Navigator.pop(context) : null,
          actions: [
            BlocBuilder<ActiveRideCubit, ActiveRideState>(
              builder: (context, state) {
                return IconButton(
                  icon: const Icon(
                    Iconsax.refresh,
                    color: Colors.white,
                    size: 22,
                  ),
                  onPressed: () {
                    context.read<ActiveRideCubit>().refresh();
                  },
                  tooltip: l10n.refresh,
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<ActiveRideCubit, ActiveRideState>(
          builder: (context, state) {
            if (state is ActiveRideLoading) {
              return _buildLoadingState(isDark);
            }

            if (state is ActiveRideError) {
              return _buildErrorState(context, state.message, isDark, l10n);
            }

            if (state is ActiveRideEmpty) {
              return _buildEmptyState(isDark, l10n);
            }

            if (state is ActiveRideLoaded) {
              return RefreshIndicator(
                onRefresh: () async {
                  await context.read<ActiveRideCubit>().refresh();
                },
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.rides.length,
                  itemBuilder: (context, index) {
                    final ride = state.rides[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: RideCard(
                        ride: ride,
                        isDarkMode: isDark,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RideDetailsPage(rideId: ride.id),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildLoadingState(bool isDark) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildSkeletonCard(isDark),
        );
      },
    );
  }

  Widget _buildSkeletonCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppThemeData.grey800Dark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppThemeData.grey300Dark : AppThemeData.grey200,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 100,
                height: 12,
                decoration: BoxDecoration(
                  color: isDark ? AppThemeData.grey300Dark : AppThemeData.grey200,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const Spacer(),
              Container(
                width: 60,
                height: 20,
                decoration: BoxDecoration(
                  color: isDark ? AppThemeData.grey300Dark : AppThemeData.grey200,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            height: 10,
            decoration: BoxDecoration(
              color: isDark ? AppThemeData.grey300Dark : AppThemeData.grey200,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: 200,
            height: 10,
            decoration: BoxDecoration(
              color: isDark ? AppThemeData.grey300Dark : AppThemeData.grey200,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message, bool isDark, AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Iconsax.warning_2,
              size: 64,
              color: AppThemeData.error200,
            ),
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
                context.read<ActiveRideCubit>().refresh();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark, AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Iconsax.car,
            size: 64,
            color: isDark ? AppThemeData.grey400Dark : AppThemeData.grey400,
          ),
          const SizedBox(height: 16),
          CustomText(
            text: l10n.noActiveRides,
            size: 16,
            weight: FontWeight.w600,
            color: isDark ? AppThemeData.grey900Dark : AppThemeData.grey900,
          ),
          const SizedBox(height: 8),
          CustomText(
            text: l10n.bookARideToGetStarted,
            size: 14,
            color: isDark ? AppThemeData.grey500Dark : AppThemeData.grey500,
          ),
        ],
      ),
    );
  }
}
