import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/themes/constant_colors.dart';
import '../../../../core/utils/dark_theme_provider.dart';
import '../../../../generated/app_localizations.dart';
import '../../../../common/widget/custom_text.dart';
import '../../data/models/location_model.dart';
import '../cubit/location/location_cubit.dart';
import '../cubit/location/location_state.dart';
import '../cubit/booking/booking_cubit.dart';

class LocationSearchWidget extends StatelessWidget {
  final VoidCallback? onMenuTap;
  final Function(LocationModel departure, LocationModel destination)?
      onDestinationSelected;

  const LocationSearchWidget({
    super.key,
    this.onMenuTap,
    this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final l10n = AppLocalizations.of(context)!;
    final isDarkMode = themeChange.getThem();

    return BlocBuilder<BookingCubit, BookingState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: l10n.enterDestination,
                size: 18,
                weight: FontWeight.bold,
                color: isDarkMode
                    ? AppThemeData.grey900Dark
                    : AppThemeData.grey900,
              ),
              const SizedBox(height: 12),

              // Departure Field
              _buildLocationField(
                context,
                label: l10n.pickupLocation,
                text: state.departure?.address ?? l10n.pickupLocation,
                prefixText: 'A',
                isDeparture: true,
                isDarkMode: isDarkMode,
              ),

              const SizedBox(height: 12),

              // Destination Field
              _buildLocationField(
                context,
                label: l10n.dropoffLocation,
                text: state.destination?.address ?? l10n.dropoffLocation,
                prefixText: 'B',
                isDeparture: false,
                isDarkMode: isDarkMode,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLocationField(
    BuildContext context, {
    required String label,
    required String text,
    required String prefixText,
    required bool isDeparture,
    required bool isDarkMode,
  }) {
    return GestureDetector(
      onTap: () => _showLocationSearch(context, isDeparture: isDeparture),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: isDarkMode ? AppThemeData.grey200Dark : AppThemeData.grey200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isDeparture
                    ? AppThemeData.primary200.withOpacity(0.15)
                    : AppThemeData.secondary200.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CustomText(
                  text: prefixText,
                  color: isDeparture
                      ? AppThemeData.primary200
                      : AppThemeData.secondary200,
                  size: 14,
                  weight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CustomText(
                text: text,
                size: 14,
                color: text == label || text.contains('...')
                    ? (isDarkMode
                        ? AppThemeData.grey400Dark
                        : AppThemeData.grey400)
                    : (isDarkMode
                        ? AppThemeData.grey900Dark
                        : AppThemeData.grey900),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(
              Localizations.localeOf(context).languageCode == 'ar'
                  ? Iconsax.arrow_left_3
                  : Iconsax.arrow_right_3,
              size: 18,
              color:
                  isDarkMode ? AppThemeData.grey400Dark : AppThemeData.grey400,
            ),
          ],
        ),
      ),
    );
  }

  void _showLocationSearch(BuildContext context, {required bool isDeparture}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<LocationCubit>(),
        child: _LocationSearchSheet(
          isDeparture: isDeparture,
          onLocationSelected: (location) {
            final bookingCubit = context.read<BookingCubit>();
            if (isDeparture) {
              bookingCubit.updateDeparture(location);
            } else {
              bookingCubit.updateDestination(location);
            }
          },
        ),
      ),
    );
  }
}

class _LocationSearchSheet extends StatefulWidget {
  final bool isDeparture;
  final Function(LocationModel) onLocationSelected;

  const _LocationSearchSheet({
    required this.isDeparture,
    required this.onLocationSelected,
  });

  @override
  State<_LocationSearchSheet> createState() => _LocationSearchSheetState();
}

class _LocationSearchSheetState extends State<_LocationSearchSheet> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final l10n = AppLocalizations.of(context)!;
    final isDarkMode = themeChange.getThem();

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: isDarkMode ? AppThemeData.surface50Dark : AppThemeData.surface50,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color:
                  isDarkMode ? AppThemeData.grey300Dark : AppThemeData.grey300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Search Field
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: l10n.searchLocation,
                prefixIcon: Icon(
                  Iconsax.search_normal,
                  color: isDarkMode
                      ? AppThemeData.grey500Dark
                      : AppThemeData.grey500,
                ),
                filled: true,
                fillColor: isDarkMode
                    ? AppThemeData.grey200Dark
                    : AppThemeData.grey200,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                context.read<LocationCubit>().searchLocation(value);
              },
            ),
          ),

          // Current Location Button
          ListTile(
            leading: Icon(Iconsax.gps, color: AppThemeData.primary200),
            title: CustomText(text: l10n.useCurrentLocation),
            onTap: () async {
              context.read<LocationCubit>().getCurrentLocation();
            },
          ),

          const Divider(height: 1),

          // Search Results
          Expanded(
            child: BlocBuilder<LocationCubit, LocationState>(
              builder: (context, state) {
                if (state is LocationSearching) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is LocationSearchResults) {
                  return ListView.builder(
                    itemCount: state.results.length,
                    itemBuilder: (context, index) {
                      final location = state.results[index];
                      return ListTile(
                        leading: Icon(Iconsax.location),
                        title: CustomText(text: location.address),
                        onTap: () {
                          widget.onLocationSelected(location);
                          Navigator.pop(context);
                        },
                      );
                    },
                  );
                }

                if (state is LocationLoaded) {
                  // If we just got the current location, auto-select it
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (Navigator.canPop(context)) {
                      widget.onLocationSelected(state.location);
                      Navigator.pop(context);
                    }
                  });
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
