import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/themes/constant_colors.dart';
import '../../../../core/utils/dark_theme_provider.dart';
import '../../../../generated/app_localizations.dart';
import '../../../../common/widget/button.dart';
import '../../../../common/widget/custom_text.dart';
import '../../data/models/ride_response_model.dart';
import '../widgets/driver_info_card.dart';

class BookingSuccessPage extends StatelessWidget {
  final RideResponseModel rideResponse;

  const BookingSuccessPage({
    super.key,
    required this.rideResponse,
  });

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final l10n = AppLocalizations.of(context)!;
    final isDarkMode = themeChange.getThem();

    return Scaffold(
      backgroundColor: isDarkMode
          ? AppThemeData.surface50Dark
          : AppThemeData.surface50,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Success Icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppThemeData.success200.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle,
                  size: 80,
                  color: AppThemeData.success200,
                ),
              ),

              const SizedBox(height: 32),

              // Success Title
              Center(
                child: CustomText(
                  text: l10n.bookingConfirmed,
                  size: 28,
                  weight: FontWeight.bold,
                  color: isDarkMode
                      ? AppThemeData.grey900Dark
                      : AppThemeData.grey900,
                ),
              ),

              const SizedBox(height: 12),

              // Success Message
              Center(
                child: CustomText(
                  text: l10n.yourRideHasBeenBooked,
                  size: 16,
                  color: isDarkMode
                      ? AppThemeData.grey500Dark
                      : AppThemeData.grey500,
                ),
              ),

              const SizedBox(height: 32),

              // Booking Details Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? AppThemeData.grey200Dark
                      : AppThemeData.grey200,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildDetailRow(
                      l10n.bookingId,
                      rideResponse.rideId,
                      isDarkMode,
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow(
                      l10n.estimatedArrival,
                      rideResponse.estimatedArrivalTime.toString(),
                      isDarkMode,
                    ),
                    if (rideResponse.otp != null) ...[
                      const SizedBox(height: 16),
                      _buildDetailRow(
                        l10n.otp,
                        rideResponse.otp!,
                        isDarkMode,
                        isHighlighted: true,
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Driver Info
              if (rideResponse.driver != null)
                DriverInfoCard(driver: rideResponse.driver!),

              const Spacer(),

              // Track Ride Button
              CustomButton(
                btnName: l10n.trackRide,
                ontap: () {
                  // Navigate to ride tracking screen
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
              ),

              const SizedBox(height: 12),

              // Back to Home Button
              CustomButton(
                btnName: l10n.backToHome,
                ontap: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                isOutlined: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value,
    bool isDarkMode, {
    bool isHighlighted = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          text: label,
          size: 14,
          color: isDarkMode
              ? AppThemeData.grey500Dark
              : AppThemeData.grey500,
        ),
        CustomText(
          text: value,
          size: 16,
          weight: isHighlighted ? FontWeight.bold : FontWeight.w600,
          color: isHighlighted
              ? AppThemeData.primary200
              : (isDarkMode
                  ? AppThemeData.grey900Dark
                  : AppThemeData.grey900),
        ),
      ],
    );
  }
}
