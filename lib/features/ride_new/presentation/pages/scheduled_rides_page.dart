import 'package:cabme/common/widget/button.dart';
import 'package:cabme/common/widget/custom_app_bar.dart';
import 'package:cabme/common/widget/custom_text.dart';
import 'package:cabme/core/themes/constant_colors.dart';
import 'package:cabme/core/utils/dark_theme_provider.dart';
import 'package:cabme/generated/app_localizations.dart';
import 'package:cabme/features/ride_new/data/models/ride_model.dart';
import 'package:cabme/features/ride_new/presentation/cubit/active_ride/active_ride_cubit.dart';
import 'package:cabme/features/ride_new/presentation/cubit/active_ride/active_ride_state.dart';
import 'package:cabme/features/ride_new/presentation/widgets/ride_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

/// Scheduled Rides Page - Shows scheduled rides with search and filter
class ScheduledRidesPage extends StatefulWidget {
  const ScheduledRidesPage({super.key});

  @override
  State<ScheduledRidesPage> createState() => _ScheduledRidesPageState();
}

class _ScheduledRidesPageState extends State<ScheduledRidesPage> {
  final TextEditingController _searchController = TextEditingController();

  // Filter state
  String _selectedFilter = 'all';
  String _searchQuery = '';

  // Filter options
  static const List<String> filterOptions = [
    'all',
    'pending',
    'new',
    'confirmed',
    'on ride',
    'completed',
  ];

  @override
  void initState() {
    super.initState();
    context.read<ActiveRideCubit>().loadActiveRides();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Get localized filter display name
  String _getFilterDisplayName(String filter, AppLocalizations l10n) {
    switch (filter.toLowerCase()) {
      case 'all':
        return l10n.allRides;
      case 'new':
        return l10n.newStatus;
      case 'confirmed':
        return l10n.bookingConfirmed;
      case 'on ride':
      case 'onride':
        return l10n.onRide;
      case 'completed':
        return l10n.done;
      case 'pending':
        return l10n.pleaseWait;
      default:
        return filter;
    }
  }

  /// Get icon for filter
  IconData _getFilterIcon(String filter) {
    switch (filter.toLowerCase()) {
      case 'all':
        return Iconsax.document;
      case 'pending':
        return Iconsax.clock;
      case 'new':
        return Iconsax.star;
      case 'confirmed':
        return Iconsax.tick_circle;
      case 'on ride':
        return Iconsax.car;
      case 'completed':
        return Iconsax.tick_square;
      default:
        return Iconsax.document;
    }
  }

  /// Filter rides to only show scheduled ones, then apply status filter and search
  List<RideModel> _getFilteredRides(List<RideModel> allRides) {
    // First: Only scheduled rides
    List<RideModel> scheduledRides =
        allRides.where((ride) => ride.isScheduled).toList();

    // Apply status filter
    if (_selectedFilter != 'all') {
      scheduledRides = scheduledRides.where((ride) {
        final status = ride.status.toLowerCase();
        final filter = _selectedFilter.toLowerCase();
        if (filter == 'on ride') {
          return status == 'on ride' || status == 'onride';
        }
        return status == filter;
      }).toList();
    }

    // Apply search query
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      scheduledRides = scheduledRides.where((ride) {
        return ride.pickupName.toLowerCase().contains(query) ||
            ride.dropoffName.toLowerCase().contains(query) ||
            ride.id.toLowerCase().contains(query) ||
            (ride.rideDate?.toLowerCase().contains(query) ?? false) ||
            (ride.rideTime?.toLowerCase().contains(query) ?? false);
      }).toList();
    }

    // Sort by scheduled date/time (upcoming first)
    scheduledRides.sort((a, b) {
      try {
        if (a.rideDate != null && b.rideDate != null) {
          final dateA = DateTime.parse(a.rideDate!);
          final dateB = DateTime.parse(b.rideDate!);
          if (dateA != dateB) return dateA.compareTo(dateB);

          if (a.rideTime != null && b.rideTime != null) {
            final timeA = a.rideTime!.split(':');
            final timeB = b.rideTime!.split(':');
            if (timeA.length >= 2 && timeB.length >= 2) {
              final hourA = int.tryParse(timeA[0]) ?? 0;
              final hourB = int.tryParse(timeB[0]) ?? 0;
              final minA = int.tryParse(timeA[1]) ?? 0;
              final minB = int.tryParse(timeB[1]) ?? 0;
              if (hourA != hourB) return hourA.compareTo(hourB);
              return minA.compareTo(minB);
            }
          }
        }
        return 0;
      } catch (e) {
        return 0;
      }
    });

    return scheduledRides;
  }

  /// Get count for a specific filter
  int _getStatusCount(List<RideModel> allRides, String filter) {
    final scheduledRides = allRides.where((ride) => ride.isScheduled).toList();
    if (filter == 'all') return scheduledRides.length;
    return scheduledRides.where((ride) {
      final status = ride.status.toLowerCase();
      if (filter == 'on ride') {
        return status == 'on ride' || status == 'onride';
      }
      return status == filter.toLowerCase();
    }).length;
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final isDarkMode = themeChange.getThem();
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: CustomAppBar(
        title: l10n.scheduledRides,
        showBackButton: true,
        onBackPressed: () => Navigator.of(context).pop(),
      ),
      body: RefreshIndicator(
        onRefresh: () => context.read<ActiveRideCubit>().refresh(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            children: [
              // Search Bar
              _buildSearchBar(isDarkMode, l10n),
              const SizedBox(height: 12),
              // Content
              Expanded(
                child: BlocBuilder<ActiveRideCubit, ActiveRideState>(
                  builder: (context, state) {
                    if (state is ActiveRideLoading) {
                      return _buildSkeletonLoader(isDarkMode);
                    }

                    if (state is ActiveRideError) {
                      return _buildErrorState(isDarkMode, l10n, state.message);
                    }

                    List<RideModel> allRides = [];
                    if (state is ActiveRideLoaded) {
                      allRides = state.rides;
                    }

                    // Filter tabs need ride data for counts
                    return Column(
                      children: [
                        _buildFilterTabs(isDarkMode, l10n, allRides),
                        const SizedBox(height: 8),
                        Expanded(
                          child: _buildRideList(isDarkMode, l10n, allRides),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(bool isDarkMode, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: isDarkMode ? AppThemeData.grey800Dark : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color:
                  isDarkMode ? AppThemeData.grey300Dark : AppThemeData.grey200,
              width: 1,
            ),
          ),
          child: TextField(
            controller: _searchController,
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
            decoration: InputDecoration(
              hintText: l10n.searchByLocation,
              hintStyle: TextStyle(
                color: isDarkMode
                    ? AppThemeData.grey400Dark
                    : AppThemeData.grey400,
                fontSize: 14,
              ),
              prefixIcon: Icon(
                Iconsax.search_normal,
                color: isDarkMode
                    ? AppThemeData.grey400Dark
                    : AppThemeData.grey400,
                size: 20,
              ),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: Icon(
                        Iconsax.close_circle,
                        color: isDarkMode
                            ? AppThemeData.grey400Dark
                            : AppThemeData.grey400,
                        size: 20,
                      ),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _searchQuery = '';
                        });
                      },
                    )
                  : const SizedBox.shrink(),
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            style: TextStyle(
              color:
                  isDarkMode ? AppThemeData.grey900Dark : AppThemeData.grey900,
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Row(
            children: [
              Icon(
                Iconsax.info_circle,
                size: 12,
                color: isDarkMode
                    ? AppThemeData.grey500Dark
                    : AppThemeData.grey500,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: CustomText(
                  text: l10n.searchByHint,
                  size: 11,
                  color: isDarkMode
                      ? AppThemeData.grey500Dark
                      : AppThemeData.grey500,
                  maxLines: 2,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilterTabs(
      bool isDarkMode, AppLocalizations l10n, List<RideModel> allRides) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filterOptions.map((filter) {
          final isSelected = _selectedFilter == filter;
          final displayName = _getFilterDisplayName(filter, l10n);
          final count = _getStatusCount(allRides, filter);
          final icon = _getFilterIcon(filter);

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              onTap: () {
                setState(() {
                  _selectedFilter = filter;
                });
              },
              borderRadius: BorderRadius.circular(20),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppThemeData.primary200
                      : isDarkMode
                          ? AppThemeData.grey800
                          : AppThemeData.grey100,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? AppThemeData.primary200
                        : isDarkMode
                            ? AppThemeData.grey300Dark
                            : AppThemeData.grey300,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      icon,
                      size: 16,
                      color: isSelected
                          ? Colors.white
                          : isDarkMode
                              ? AppThemeData.grey400Dark
                              : AppThemeData.grey500,
                    ),
                    const SizedBox(width: 6),
                    CustomText(
                      text: displayName,
                      size: 13,
                      color: isSelected
                          ? Colors.white
                          : isDarkMode
                              ? AppThemeData.grey300Dark
                              : AppThemeData.grey800,
                      weight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                    if (count > 0) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.white.withValues(alpha: 0.2)
                              : isDarkMode
                                  ? AppThemeData.grey300Dark
                                  : AppThemeData.grey200,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: CustomText(
                          text: count.toString(),
                          size: 11,
                          color: isSelected
                              ? Colors.white
                              : isDarkMode
                                  ? AppThemeData.grey400Dark
                                  : AppThemeData.grey400,
                          weight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRideList(
      bool isDarkMode, AppLocalizations l10n, List<RideModel> allRides) {
    final filteredList = _getFilteredRides(allRides);

    if (filteredList.isEmpty) {
      return _buildEmptyState(isDarkMode, l10n);
    }

    return ListView.builder(
      itemCount: filteredList.length,
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(top: 16),
          child: _buildScheduledRideItem(filteredList[index], isDarkMode, l10n),
        );
      },
    );
  }

  /// Build a scheduled ride item with schedule badge + ride card
  Widget _buildScheduledRideItem(
      RideModel ride, bool isDarkMode, AppLocalizations l10n) {
    // Parse scheduled date and time
    String scheduledDate = '';
    String scheduledTime = '';
    if (ride.rideDate != null && ride.rideTime != null) {
      try {
        DateTime scheduledDateObj = DateTime.parse(ride.rideDate!);
        scheduledDate = DateFormat('MMM dd, yyyy').format(scheduledDateObj);
        scheduledTime = DateFormat('hh:mm a')
            .format(DateFormat('HH:mm:ss').parse(ride.rideTime!));
      } catch (e) {
        scheduledDate = ride.rideDate ?? '';
        scheduledTime = ride.rideTime ?? '';
      }
    }

    return Column(
      children: [
        // Schedule Badge Banner
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppThemeData.primary200.withValues(alpha: 0.15),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            border: Border(
              bottom: BorderSide(
                color: AppThemeData.primary200.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppThemeData.primary200,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Iconsax.calendar_1,
                      size: 14,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 6),
                    CustomText(
                      text: l10n.scheduled,
                      size: 11,
                      weight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (scheduledDate.isNotEmpty)
                      Row(
                        children: [
                          Icon(
                            Iconsax.calendar_1,
                            size: 14,
                            color: AppThemeData.primary200,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: CustomText(
                              text: scheduledDate,
                              size: 13,
                              weight: FontWeight.w600,
                              color: AppThemeData.primary200,
                            ),
                          ),
                        ],
                      ),
                    if (scheduledTime.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Row(
                          children: [
                            Icon(
                              Iconsax.clock,
                              size: 14,
                              color: AppThemeData.primary200,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: CustomText(
                                text: scheduledTime,
                                size: 13,
                                weight: FontWeight.w600,
                                color: AppThemeData.primary200,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Ride Card
        RideCard(
          ride: ride,
          isDarkMode: isDarkMode,
          onTap: () {
            Navigator.of(context).pushNamed(
              '/ride-details',
              arguments: {'ride': ride},
            );
          },
        ),
      ],
    );
  }

  Widget _buildEmptyState(bool isDarkMode, AppLocalizations l10n) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.5,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _searchQuery.isNotEmpty
                    ? Iconsax.search_normal_1
                    : Iconsax.calendar_1,
                size: 64,
                color: isDarkMode
                    ? AppThemeData.grey400Dark
                    : AppThemeData.grey400,
              ),
              const SizedBox(height: 16),
              CustomText(
                text: _searchQuery.isNotEmpty
                    ? l10n.noScheduledRidesFound
                    : l10n.noScheduledRidesFound,
                size: 16,
                weight: FontWeight.w600,
                color: isDarkMode
                    ? AppThemeData.grey900Dark
                    : AppThemeData.grey900,
              ),
              if (_searchQuery.isNotEmpty) ...[
                const SizedBox(height: 8),
                CustomText(
                  text: l10n.tryDifferentSearch,
                  size: 14,
                  color: isDarkMode
                      ? AppThemeData.grey500Dark
                      : AppThemeData.grey500,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(
      bool isDarkMode, AppLocalizations l10n, String errorMessage) {
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
              text: l10n.errorLoadingScheduledRides,
              size: 18,
              weight: FontWeight.w600,
              color:
                  isDarkMode ? AppThemeData.grey900Dark : AppThemeData.grey900,
            ),
            const SizedBox(height: 8),
            CustomText(
              text: errorMessage,
              size: 14,
              color:
                  isDarkMode ? AppThemeData.grey500Dark : AppThemeData.grey500,
              align: TextAlign.center,
            ),
            const SizedBox(height: 24),
            CustomButton(
              btnName: l10n.retry,
              buttonColor: AppThemeData.primary200,
              textColor: Colors.white,
              borderRadius: 12,
              ontap: () => context.read<ActiveRideCubit>().refresh(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkeletonLoader(bool isDarkMode) {
    return ListView.builder(
      itemCount: 3,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildSkeletonCard(isDarkMode),
        );
      },
    );
  }

  Widget _buildSkeletonCard(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(20),
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
          Row(
            children: [
              Container(
                width: 100,
                height: 12,
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? AppThemeData.grey300Dark
                      : AppThemeData.grey200,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const Spacer(),
              Container(
                width: 60,
                height: 20,
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? AppThemeData.grey300Dark
                      : AppThemeData.grey200,
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
              color:
                  isDarkMode ? AppThemeData.grey300Dark : AppThemeData.grey200,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: 200,
            height: 10,
            decoration: BoxDecoration(
              color:
                  isDarkMode ? AppThemeData.grey300Dark : AppThemeData.grey200,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }
}
