import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../../../core/themes/constant_colors.dart';
import '../../../../core/utils/dark_theme_provider.dart';
import '../../../../generated/app_localizations.dart';
import '../../../../core(new)/utils/widgets/custom_snackbar.dart';
import '../../../../common/widget/button.dart';
import '../../../../common/widget/custom_text.dart';
import '../../home_di.dart';
import '../../data/models/location_model.dart';
import '../cubit/ride/ride_cubit.dart';
import '../cubit/ride/ride_state.dart';
import '../cubit/vehicle/vehicle_cubit.dart';
import '../cubit/vehicle/vehicle_state.dart';
import '../widgets/price_summary_widget.dart';
import '../widgets/route_info_widget.dart';
import 'payment_selection_page.dart';
import 'booking_success_page.dart';

class RideBookingPage extends StatefulWidget {
  final LocationModel departure;
  final LocationModel destination;

  const RideBookingPage({
    super.key,
    required this.departure,
    required this.destination,
  });

  @override
  State<RideBookingPage> createState() => _RideBookingPageState();
}

class _RideBookingPageState extends State<RideBookingPage> {
  int _numberOfPassengers = 1;
  DateTime? _scheduledTime;

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final l10n = AppLocalizations.of(context)!;
    final isDarkMode = themeChange.getThem();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<RideCubit>(),
        ),
        BlocProvider.value(
          value: context.read<VehicleCubit>(),
        ),
      ],
      child: Scaffold(
        backgroundColor: isDarkMode
            ? AppThemeData.surface50Dark
            : AppThemeData.surface50,
        appBar: AppBar(
          backgroundColor: isDarkMode
              ? AppThemeData.surface50Dark
              : AppThemeData.surface50,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: isDarkMode
                  ? AppThemeData.grey900Dark
                  : AppThemeData.grey900,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: CustomText(
            text: l10n.bookRide,
            size: 18,
            weight: FontWeight.bold,
            color: isDarkMode
                ? AppThemeData.grey900Dark
                : AppThemeData.grey900,
          ),
        ),
        body: BlocConsumer<RideCubit, RideState>(
          listener: (context, state) {
            if (state is RideError) {
              CustomSnackbar.showError(
                context: context,
                message: state.message,
              );
            } else if (state is RidePriceCalculated) {
              // Price calculated successfully
            } else if (state is RideBooked) {
              // Navigate to success page
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => BookingSuccessPage(
                    rideResponse: state.response,
                  ),
                ),
              );
            }
          },
          builder: (context, rideState) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Route Info
                  RouteInfoWidget(
                    departure: widget.departure,
                    destination: widget.destination,
                  ),

                  const SizedBox(height: 24),

                  // Vehicle Selection
                  BlocBuilder<VehicleCubit, VehicleState>(
                    builder: (context, vehicleState) {
                      if (vehicleState is VehicleSelected) {
                        return _buildVehicleCard(
                          vehicleState.selectedVehicle,
                          isDarkMode,
                          l10n,
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),

                  const SizedBox(height: 24),

                  // Number of Passengers
                  _buildPassengerSelector(isDarkMode, l10n),

                  const SizedBox(height: 24),

                  // Schedule Ride
                  _buildScheduleSelector(isDarkMode, l10n),

                  const SizedBox(height: 24),

                  // Price Summary
                  if (rideState is RidePriceCalculated)
                    PriceSummaryWidget(
                      priceCalculation: rideState.priceCalculation,
                    ),

                  const SizedBox(height: 32),

                  // Book Button
                  if (rideState is RideCalculating)
                    const Center(child: CircularProgressIndicator())
                  else if (rideState is RideBooking)
                    const Center(child: CircularProgressIndicator())
                  else
                    CustomButton(
                      btnName: l10n.continueToPayment,
                      ontap: () => _handleContinue(context),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildVehicleCard(
    dynamic vehicle,
    bool isDarkMode,
    AppLocalizations l10n,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode
            ? AppThemeData.grey200Dark
            : AppThemeData.grey200,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppThemeData.primary200,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          // Vehicle Icon
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppThemeData.primary200.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.directions_car,
              color: AppThemeData.primary200,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          // Vehicle Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: vehicle.name ?? l10n.vehicle,
                  size: 16,
                  weight: FontWeight.bold,
                  color: isDarkMode
                      ? AppThemeData.grey900Dark
                      : AppThemeData.grey900,
                ),
                const SizedBox(height: 4),
                CustomText(
                  text: '${vehicle.capacity ?? 4} ${l10n.passengers}',
                  size: 14,
                  color: isDarkMode
                      ? AppThemeData.grey500Dark
                      : AppThemeData.grey500,
                ),
              ],
            ),
          ),
          // Change Button
          TextButton(
            onPressed: () {
              // Show vehicle selection dialog
            },
            child: CustomText(
              text: l10n.change,
              size: 14,
              color: AppThemeData.primary200,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPassengerSelector(bool isDarkMode, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode
            ? AppThemeData.grey200Dark
            : AppThemeData.grey200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            text: l10n.numberOfPassengers,
            size: 16,
            color: isDarkMode
                ? AppThemeData.grey900Dark
                : AppThemeData.grey900,
          ),
          Row(
            children: [
              IconButton(
                onPressed: _numberOfPassengers > 1
                    ? () {
                        setState(() {
                          _numberOfPassengers--;
                        });
                      }
                    : null,
                icon: Icon(
                  Icons.remove_circle_outline,
                  color: _numberOfPassengers > 1
                      ? AppThemeData.primary200
                      : AppThemeData.grey400,
                ),
              ),
              CustomText(
                text: _numberOfPassengers.toString(),
                size: 18,
                weight: FontWeight.bold,
                color: isDarkMode
                    ? AppThemeData.grey900Dark
                    : AppThemeData.grey900,
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _numberOfPassengers++;
                  });
                },
                icon: Icon(
                  Icons.add_circle_outline,
                  color: AppThemeData.primary200,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleSelector(bool isDarkMode, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode
            ? AppThemeData.grey200Dark
            : AppThemeData.grey200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: l10n.scheduleRide,
                size: 16,
                color: isDarkMode
                    ? AppThemeData.grey900Dark
                    : AppThemeData.grey900,
              ),
              Switch(
                value: _scheduledTime != null,
                onChanged: (value) {
                  if (value) {
                    _selectScheduledTime();
                  } else {
                    setState(() {
                      _scheduledTime = null;
                    });
                  }
                },
                activeColor: AppThemeData.primary200,
              ),
            ],
          ),
          if (_scheduledTime != null) ...[
            const SizedBox(height: 8),
            CustomText(
              text: '${l10n.scheduledFor}: ${_formatDateTime(_scheduledTime!)}',
              size: 14,
              color: isDarkMode
                  ? AppThemeData.grey500Dark
                  : AppThemeData.grey500,
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _selectScheduledTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(hours: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );

    if (date != null && mounted) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (time != null && mounted) {
        setState(() {
          _scheduledTime = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  void _handleContinue(BuildContext context) {
    final vehicleCubit = context.read<VehicleCubit>();
    final selectedVehicle = vehicleCubit.selectedVehicle;

    if (selectedVehicle == null) {
      CustomSnackbar.showError(
        context: context,
        message: AppLocalizations.of(context)!.pleaseSelectVehicle,
      );
      return;
    }

    // Navigate to payment selection
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentSelectionPage(
          departure: widget.departure,
          destination: widget.destination,
          vehicleCategoryId: selectedVehicle.id ?? '',
          numberOfPassengers: _numberOfPassengers,
          scheduledTime: _scheduledTime,
        ),
      ),
    );
  }
}
