import 'package:cabme/features/ride_new/presentation/pages/ride_details_page.dart';
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
import '../../../../core/utils/dark_theme_provider.dart';
import '../cubit/ride_history/ride_history_cubit.dart';
import '../cubit/ride_history/ride_history_state.dart';
import '../widgets/ride_card.dart';

/// Ride History Page - Displays past rides with pagination
class RideHistoryPage extends StatefulWidget {
  const RideHistoryPage({super.key});

  @override
  State<RideHistoryPage> createState() => _RideHistoryPageState();
}

class _RideHistoryPageState extends State<RideHistoryPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.9) {
      context.read<RideHistoryCubit>().loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final isDark = themeChange.getThem();
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (context) => GetIt.I<RideHistoryCubit>()..loadRideHistory(),
      child: Scaffold(
        backgroundColor: isDark ? AppThemeData.surface50Dark : AppThemeData.surface50,
        appBar: CustomAppBar(
          title: l10n.rideHistory,
          showBackButton: true,
          onBackPressed: () => Navigator.pop(context),
          actions: [
            IconButton(
              icon: const Icon(Iconsax.refresh, color: Colors.white, size: 22),
              onPressed: () => context.read<RideHistoryCubit>().refresh(),
              tooltip: l10n.refresh,
            ),
          ],
        ),
        body: BlocBuilder<RideHistoryCubit, RideHistoryState>(
          builder: (context, state) {
            if (state is RideHistoryLoading) {
              return _buildLoadingState(isDark);
            }

            if (state is RideHistoryError) {
              return _buildErrorState(context, state.message, isDark, l10n);
            }

            if (state is RideHistoryEmpty) {
              return _buildEmptyState(isDark, l10n);
            }

            if (state is RideHistoryLoaded || state is RideHistoryLoadingMore) {
              final rides = state is RideHistoryLoaded 
                  ? state.rides 
                  : (state as RideHistoryLoadingMore).currentRides;
              final hasMore = state is RideHistoryLoaded ? state.hasMore : false;

              return RefreshIndicator(
                onRefresh: () async => await context.read<RideHistoryCubit>().refresh(),
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: rides.length + (hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == rides.length) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      );
                    }

                    final ride = rides[index];
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
      itemCount: 5,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Container(
            height: 150,
            decoration: BoxDecoration(
              color: isDark ? AppThemeData.grey800Dark : Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        );
      },
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
              text: l10n.errorLoadingHistory,
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
              ontap: () => context.read<RideHistoryCubit>().refresh(),
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
            Iconsax.calendar_1,
            size: 64,
            color: isDark ? AppThemeData.grey400Dark : AppThemeData.grey400,
          ),
          const SizedBox(height: 16),
          CustomText(
            text: l10n.noRideHistory,
            size: 16,
            weight: FontWeight.w600,
            color: isDark ? AppThemeData.grey900Dark : AppThemeData.grey900,
          ),
          const SizedBox(height: 8),
          CustomText(
            text: l10n.yourCompletedRidesWillAppearHere,
            size: 14,
            color: isDark ? AppThemeData.grey500Dark : AppThemeData.grey500,
          ),
        ],
      ),
    );
  }
}
