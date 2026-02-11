import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../../../core/themes/constant_colors.dart';
import '../../../../core/utils/dark_theme_provider.dart';
import '../../../../generated/app_localizations.dart';
import '../../../../common/widget/custom_text.dart';
import '../cubit/vehicle/vehicle_cubit.dart';
import '../cubit/vehicle/vehicle_state.dart';
import '../../data/models/vehicle_category_model.dart';

class VehicleSelectionWidget extends StatelessWidget {
  const VehicleSelectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final l10n = AppLocalizations.of(context)!;
    final isDarkMode = themeChange.getThem();

    return Container(
      decoration: BoxDecoration(
        color: isDarkMode
            ? AppThemeData.surface50Dark
            : AppThemeData.surface50,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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

          // Title
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: l10n.selectVehicle,
                  size: 18,
                  weight: FontWeight.bold,
                  color: isDarkMode
                      ? AppThemeData.grey900Dark
                      : AppThemeData.grey900,
                ),
              ],
            ),
          ),

          // Vehicle List
          BlocBuilder<VehicleCubit, VehicleState>(
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
                    : null;

                return SizedBox(
                  height: 180,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final vehicle = categories[index];
                      final isSelected = selectedVehicle?.id == vehicle.id;

                      return _VehicleCard(
                        vehicle: vehicle,
                        isSelected: isSelected,
                        isDarkMode: isDarkMode,
                        onTap: () {
                          context.read<VehicleCubit>().selectVehicle(vehicle);
                        },
                      );
                    },
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),

          const SizedBox(height: 16),
        ],
      ),
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppThemeData.primary200.withOpacity(0.1)
              : (isDarkMode
                  ? AppThemeData.grey200Dark
                  : AppThemeData.grey200),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? AppThemeData.primary200
                : (isDarkMode
                    ? AppThemeData.grey300Dark
                    : AppThemeData.grey300),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Vehicle Icon
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppThemeData.primary200.withOpacity(0.2)
                    : (isDarkMode
                        ? AppThemeData.grey200Dark
                        : AppThemeData.grey200),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.directions_car,
                color: isSelected
                    ? AppThemeData.primary200
                    : (isDarkMode
                        ? AppThemeData.grey500Dark
                        : AppThemeData.grey500),
                size: 32,
              ),
            ),

            const SizedBox(height: 12),

            // Vehicle Name
            Center(
              child: CustomText(
                text: vehicle.name,
                size: 14,
                weight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected
                    ? AppThemeData.primary200
                    : (isDarkMode
                        ? AppThemeData.grey900Dark
                        : AppThemeData.grey900),
                maxLines: 1,
              ),
            ),

            const SizedBox(height: 4),

            // Capacity
            CustomText(
              text: '${vehicle.maxPassengers} seats',
              size: 12,
              color: isDarkMode
                  ? AppThemeData.grey500Dark
                  : AppThemeData.grey500,
            ),

            const SizedBox(height: 8),

            // Price
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppThemeData.primary200
                    : (isDarkMode
                        ? AppThemeData.grey300Dark
                        : AppThemeData.grey300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomText(
                text: '\$${vehicle.basePrice.toStringAsFixed(2)}',
                size: 12,
                weight: FontWeight.bold,
                color: isSelected
                    ? Colors.white
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
}
