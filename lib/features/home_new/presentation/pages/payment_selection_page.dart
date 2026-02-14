import 'package:cabme/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import '../../../../core/utils/Preferences.dart';
import '../../../../core/themes/constant_colors.dart';
import '../../../../core/utils/dark_theme_provider.dart';
import '../../../../generated/app_localizations.dart';
import '../../../../core(new)/utils/widgets/custom_snackbar.dart';
import '../../../../common/widget/button.dart';
import '../../../../common/widget/custom_text.dart';
import '../../home_di.dart';
import '../../data/models/location_model.dart';
import '../../data/models/ride_request_model.dart';
import '../cubit/ride/ride_cubit.dart';
import '../cubit/ride/ride_state.dart';
import 'booking_success_page.dart';

class PaymentSelectionPage extends StatefulWidget {
  final LocationModel departure;
  final LocationModel destination;
  final List<LocationModel>? stops;
  final String vehicleCategoryId;
  final int numberOfPassengers;
  final DateTime? scheduledTime;

  const PaymentSelectionPage({
    super.key,
    required this.departure,
    required this.destination,
    this.stops,
    required this.vehicleCategoryId,
    required this.numberOfPassengers,
    this.scheduledTime,
  });

  @override
  State<PaymentSelectionPage> createState() => _PaymentSelectionPageState();
}

class _PaymentSelectionPageState extends State<PaymentSelectionPage> {
  String? _selectedPaymentMethodId;
  final List<PaymentMethod> _paymentMethods = [
    PaymentMethod(id: '1', name: 'Cash', icon: Icons.money),
    PaymentMethod(id: '2', name: 'Credit Card', icon: Icons.credit_card),
    PaymentMethod(id: '3', name: 'Wallet', icon: Icons.account_balance_wallet),
  ];

  @override
  void initState() {
    super.initState();
    // Calculate price on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calculatePrice();
    });
  }

  void _calculatePrice() {
    context.read<RideCubit>().calculatePrice(
          vehicleName: 'classic', // TODO: Get actual name from previous step
          distance: '0',
          departureLat: widget.departure.latitude,
          departureLng: widget.departure.longitude,
          destinationLat: widget.destination.latitude,
          destinationLng: widget.destination.longitude,
        );
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final l10n = AppLocalizations.of(context)!;
    final isDarkMode = themeChange.getThem();

    return BlocProvider(
      create: (_) => getIt<RideCubit>(),
      child: Scaffold(
        backgroundColor:
            isDarkMode ? AppThemeData.surface50Dark : AppThemeData.surface50,
        appBar: AppBar(
          backgroundColor:
              isDarkMode ? AppThemeData.surface50Dark : AppThemeData.surface50,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color:
                  isDarkMode ? AppThemeData.grey900Dark : AppThemeData.grey900,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: CustomText(
            text: l10n.selectPaymentMethod,
            size: 18,
            weight: FontWeight.bold,
            color: isDarkMode ? AppThemeData.grey900Dark : AppThemeData.grey900,
          ),
        ),
        body: BlocConsumer<RideCubit, RideState>(
          listener: (context, state) {
            if (state is RideError) {
              CustomSnackbar.showError(
                context: context,
                message: state.message,
              );
            } else if (state is RideBooked) {
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
          builder: (context, state) {
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Price Summary
                        if (state is RidePriceCalculated)
                          _buildPriceSummary(
                            state.priceCalculation.finalPrice,
                            isDarkMode,
                            l10n,
                          )
                        else if (state is RideCalculating)
                          const Center(child: CircularProgressIndicator())
                        else
                          const SizedBox.shrink(),

                        const SizedBox(height: 24),

                        // Payment Methods
                        CustomText(
                          text: l10n.paymentMethod,
                          size: 18,
                          weight: FontWeight.bold,
                          color: isDarkMode
                              ? AppThemeData.grey900Dark
                              : AppThemeData.grey900,
                        ),
                        const SizedBox(height: 16),

                        ..._paymentMethods.map((method) {
                          return _buildPaymentMethodCard(
                            method,
                            isDarkMode,
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ),

                // Book Button
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? AppThemeData.grey200Dark
                        : AppThemeData.grey200,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: state is RideBooking
                      ? const Center(child: CircularProgressIndicator())
                      : CustomButton(
                          btnName: l10n.confirmBooking,
                          ontap: () => _handleBookRide(context),
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildPriceSummary(
    double price,
    bool isDarkMode,
    AppLocalizations l10n,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppThemeData.primary200.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppThemeData.primary200,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            text: l10n.totalFare,
            size: 16,
            weight: FontWeight.bold,
            color: isDarkMode ? AppThemeData.grey900Dark : AppThemeData.grey900,
          ),
          CustomText(
            text: '\$${price.toStringAsFixed(2)}',
            size: 24,
            weight: FontWeight.bold,
            color: AppThemeData.primary200,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodCard(PaymentMethod method, bool isDarkMode) {
    final isSelected = _selectedPaymentMethodId == method.id;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentMethodId = method.id;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDarkMode ? AppThemeData.grey200Dark : AppThemeData.grey200,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppThemeData.primary200
                : (isDarkMode
                    ? AppThemeData.grey300Dark
                    : AppThemeData.grey300),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppThemeData.primary200.withOpacity(0.1)
                    : (isDarkMode
                        ? AppThemeData.grey200Dark
                        : AppThemeData.grey200),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                method.icon,
                color: isSelected
                    ? AppThemeData.primary200
                    : (isDarkMode
                        ? AppThemeData.grey500Dark
                        : AppThemeData.grey500),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CustomText(
                text: method.name,
                size: 16,
                weight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isDarkMode
                    ? AppThemeData.grey900Dark
                    : AppThemeData.grey900,
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: AppThemeData.primary200,
              ),
          ],
        ),
      ),
    );
  }

  void _handleBookRide(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final rideCubit = context.read<RideCubit>();
    final calculation = rideCubit.lastCalculation;

    if (_selectedPaymentMethodId == null) {
      CustomSnackbar.showError(
        context: context,
        message: l10n.pleaseSelectPaymentMethod,
      );
      return;
    }

    if (calculation == null) {
      CustomSnackbar.showError(
        context: context,
        message: 'Price not calculated',
      );
      return;
    }

    final userJson = Preferences.getString(Preferences.user);
    final userMap = jsonDecode(userJson);
    final userData = userMap['data'];

    final request = RideRequestModel(
      departure: widget.departure,
      destination: widget.destination,
      stops: widget.stops,
      vehicleCategoryId: widget.vehicleCategoryId,
      paymentMethodId: _selectedPaymentMethodId!,
      numberOfPassengers: widget.numberOfPassengers,
      scheduledTime: widget.scheduledTime,
      tripPrice: calculation.finalPrice,
      duration: calculation.duration,
      userName: '${userData['nom'] ?? ''} ${userData['prenom'] ?? ''}',
      userPhone: userData['phone'] ?? '',
      userEmail: userData['email'] ?? '',
      userId: Preferences.getInt(Preferences.userId).toString(),
    );

    rideCubit.bookRide(request);
  }
}

class PaymentMethod {
  final String id;
  final String name;
  final IconData icon;

  PaymentMethod({
    required this.id,
    required this.name,
    required this.icon,
  });
}
