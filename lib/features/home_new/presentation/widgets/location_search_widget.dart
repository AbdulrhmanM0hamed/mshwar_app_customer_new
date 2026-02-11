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

class LocationSearchWidget extends StatefulWidget {
  final VoidCallback onMenuTap;
  final Function(LocationModel departure, LocationModel destination) onDestinationSelected;

  const LocationSearchWidget({
    super.key,
    required this.onMenuTap,
    required this.onDestinationSelected,
  });

  @override
  State<LocationSearchWidget> createState() => _LocationSearchWidgetState();
}

class _LocationSearchWidgetState extends State<LocationSearchWidget> {
  final TextEditingController _departureController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  LocationModel? _departureLocation;
  LocationModel? _destinationLocation;
  bool _isExpanded = false;

  @override
  void dispose() {
    _departureController.dispose();
    _destinationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final l10n = AppLocalizations.of(context)!;
    final isDarkMode = themeChange.getThem();

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode
            ? AppThemeData.surface50Dark
            : AppThemeData.surface50,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with menu button
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                IconButton(
                  onPressed: widget.onMenuTap,
                  icon: Icon(
                    Iconsax.menu,
                    color: isDarkMode
                        ? AppThemeData.grey900Dark
                        : AppThemeData.grey900,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isExpanded = true;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? AppThemeData.grey200Dark
                            : AppThemeData.grey200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Iconsax.search_normal,
                            color: isDarkMode
                                ? AppThemeData.grey500Dark
                                : AppThemeData.grey500,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          CustomText(
                            text: l10n.whereToGo,
                            size: 14,
                            color: isDarkMode
                                ? AppThemeData.grey500Dark
                                : AppThemeData.grey500,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Expanded search fields
          if (_isExpanded) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Departure Field
                  _buildLocationField(
                    controller: _departureController,
                    label: l10n.pickupLocation,
                    icon: Iconsax.location,
                    iconColor: AppThemeData.success200,
                    isDarkMode: isDarkMode,
                    onTap: () => _showLocationSearch(
                      context,
                      isDeparture: true,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Destination Field
                  _buildLocationField(
                    controller: _destinationController,
                    label: l10n.dropoffLocation,
                    icon: Iconsax.location,
                    iconColor: AppThemeData.error200,
                    isDarkMode: isDarkMode,
                    onTap: () => _showLocationSearch(
                      context,
                      isDeparture: false,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Confirm Button
                  if (_departureLocation != null && _destinationLocation != null)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          widget.onDestinationSelected(
                            _departureLocation!,
                            _destinationLocation!,
                          );
                          setState(() {
                            _isExpanded = false;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppThemeData.primary200,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: CustomText(
                          text: l10n.confirmLocation,
                          size: 16,
                          weight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLocationField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required Color iconColor,
    required bool isDarkMode,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDarkMode
              ? AppThemeData.grey200Dark
              : AppThemeData.grey200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CustomText(
                text: controller.text.isEmpty ? label : controller.text,
                size: 14,
                color: controller.text.isEmpty
                    ? (isDarkMode
                        ? AppThemeData.grey500Dark
                        : AppThemeData.grey500)
                    : (isDarkMode
                        ? AppThemeData.grey900Dark
                        : AppThemeData.grey900),
              ),
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
      builder: (context) => _LocationSearchSheet(
        isDeparture: isDeparture,
        onLocationSelected: (location) {
          setState(() {
            if (isDeparture) {
              _departureLocation = location;
              _departureController.text = location.address;
            } else {
              _destinationLocation = location;
              _destinationController.text = location.address;
            }
          });
        },
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
        color: isDarkMode
            ? AppThemeData.surface50Dark
            : AppThemeData.surface50,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: isDarkMode
                  ? AppThemeData.grey300Dark
                  : AppThemeData.grey300,
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
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: isDarkMode
                              ? AppThemeData.grey500Dark
                              : AppThemeData.grey500,
                        ),
                        onPressed: () {
                          _searchController.clear();
                          context.read<LocationCubit>().clearSearch();
                        },
                      )
                    : null,
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
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppThemeData.primary200.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Iconsax.gps,
                color: AppThemeData.primary200,
                size: 20,
              ),
            ),
            title: CustomText(
              text: l10n.useCurrentLocation,
              size: 14,
              weight: FontWeight.w600,
              color: isDarkMode
                  ? AppThemeData.grey900Dark
                  : AppThemeData.grey900,
            ),
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
                  if (state.results.isEmpty) {
                    return Center(
                      child: CustomText(
                        text: l10n.noResultsFound,
                        size: 14,
                        color: isDarkMode
                            ? AppThemeData.grey500Dark
                            : AppThemeData.grey500,
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: state.results.length,
                    itemBuilder: (context, index) {
                      final location = state.results[index];
                      return ListTile(
                        leading: Icon(
                          Iconsax.location,
                          color: isDarkMode
                              ? AppThemeData.grey500Dark
                              : AppThemeData.grey500,
                        ),
                        title: CustomText(
                          text: location.address,
                          size: 14,
                          color: isDarkMode
                              ? AppThemeData.grey900Dark
                              : AppThemeData.grey900,
                        ),
                        onTap: () {
                          widget.onLocationSelected(location);
                          Navigator.pop(context);
                        },
                      );
                    },
                  );
                }

                if (state is LocationLoaded) {
                  // User selected current location
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    widget.onLocationSelected(state.location);
                    Navigator.pop(context);
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
