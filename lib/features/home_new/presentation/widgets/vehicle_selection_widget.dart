import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'package:cabme/core/themes/constant_colors.dart';
import 'package:cabme/core/utils/dark_theme_provider.dart';
import 'package:cabme/generated/app_localizations.dart';
import 'package:cabme/common/widget/custom_text.dart';
import 'package:cabme/features/home_new/presentation/cubit/vehicle/vehicle_cubit.dart';
import 'package:cabme/features/home_new/presentation/cubit/vehicle/vehicle_state.dart';
import 'package:cabme/features/home_new/data/models/vehicle_category_model.dart';

class VehicleSelectionWidget extends StatelessWidget {
  const VehicleSelectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final isDarkMode = themeChange.getThem();

    return BlocBuilder<VehicleCubit, VehicleState>(
      builder: (context, state) {
        if (state is VehicleLoading) {
          return const Padding(
            padding: EdgeInsets.all(32),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is VehicleSelected || state is VehicleLoaded) {
          final categories = state is VehicleSelected
              ? state.allCategories
              : (state as VehicleLoaded).categories;

          final selectedVehicle = state is VehicleSelected
              ? state.selectedVehicle
              : (categories.isNotEmpty ? categories.first : null);

          if (categories.isEmpty) return const SizedBox.shrink();

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                // Render up to 2 vehicles side by side like the old home
                if (categories.isNotEmpty)
                  _VehicleCard(
                    vehicle: categories[0],
                    isSelected: selectedVehicle?.id == categories[0].id,
                    isDarkMode: isDarkMode,
                    onTap: () => context
                        .read<VehicleCubit>()
                        .selectVehicle(categories[0]),
                  ),
                if (categories.length > 1) ...[
                  const SizedBox(width: 8),
                  _VehicleCard(
                    vehicle: categories[1],
                    isSelected: selectedVehicle?.id == categories[1].id,
                    isDarkMode: isDarkMode,
                    onTap: () => context
                        .read<VehicleCubit>()
                        .selectVehicle(categories[1]),
                  ),
                ],
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

class _VehicleCard extends StatelessWidget {
  final VehicleCategoryModel vehicle;
  final bool isSelected;
  final bool isDarkMode;
  final VoidCallback onTap;

  const _VehicleCard({
    required this.vehicle,
    required this.isSelected,
    required this.isDarkMode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final vehicleName = _getLocalizedVehicleName(vehicle.name, l10n);
    final description = _getVehicleDescription(vehicle.name, l10n);

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDarkMode
                ? AppThemeData.surface50Dark
                : AppThemeData.surface50,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              width: 1.5,
              color: isSelected
                  ? AppThemeData.primary200.withValues(alpha: 0.5)
                  : (isDarkMode
                      ? AppThemeData.grey200Dark
                      : AppThemeData.grey200),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: vehicleName,
                    size: 16,
                    weight: FontWeight.w700,
                    color: isDarkMode
                        ? AppThemeData.grey900Dark
                        : AppThemeData.grey900,
                  ),
                  const SizedBox(height: 4),
                  CustomText(
                    text: description,
                    size: 11,
                    weight: FontWeight.w400,
                    color: isDarkMode
                        ? AppThemeData.grey500Dark
                        : AppThemeData.grey500,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected
                          ? AppThemeData.primary200
                          : Colors.transparent,
                      border: Border.all(
                        color: isSelected
                            ? AppThemeData.primary200
                            : (isDarkMode
                                ? AppThemeData.grey300Dark
                                : AppThemeData.grey300),
                        width: 2,
                      ),
                    ),
                    child: isSelected
                        ? const Center(
                            child: Icon(Icons.check,
                                size: 12, color: Colors.white))
                        : null,
                  ),
                  const SizedBox(width: 6),
                  CustomText(
                    text: isSelected ? l10n.selected : l10n.tapToSelect,
                    size: 11,
                    weight: FontWeight.w500,
                    color: isDarkMode
                        ? AppThemeData.grey500Dark
                        : AppThemeData.grey500,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getLocalizedVehicleName(String name, AppLocalizations l10n) {
    final normalized = name.toLowerCase().trim();
    if (normalized == 'business') return l10n.family;
    if (normalized == 'classic') return l10n.classic;
    return name;
  }

  String _getVehicleDescription(String name, AppLocalizations l10n) {
    final normalized = name.toLowerCase().trim();
    if (normalized == 'business') return l10n.familyRideDescription;
    if (normalized == 'classic') return l10n.classicRideDescription;
    return l10n.reliableTransportationService;
  }
}
