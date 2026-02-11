import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../common/widget/custom_text.dart';
import '../../../../common/widget/light_bordered_card.dart';
import '../../../../core/themes/constant_colors.dart';
import '../../../../core/utils/dark_theme_provider.dart';
import '../../../../generated/app_localizations.dart';
import '../../data/models/subscription_model.dart';

class SubscriptionCard extends StatelessWidget {
  final SubscriptionModel subscription;

  const SubscriptionCard({
    super.key,
    required this.subscription,
  });

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final l10n = AppLocalizations.of(context)!;

    return LightBorderedCard(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          // TODO: Navigate to subscription details
        },
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    _buildStatusBadge(subscription.status),
                    const SizedBox(width: 8),
                    _buildPaymentBadge(subscription.paymentStatus),
                  ],
                ),
                CustomText(
                  text: subscription.tripTypeDisplay,
                  size: 12,
                  weight: FontWeight.w600,
                  color: AppThemeData.primary200,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Column(
                  children: [
                    Icon(Icons.home, color: Colors.green, size: 20),
                    Container(
                      width: 2,
                      height: 20,
                      color: Colors.grey.withValues(alpha: 0.3),
                    ),
                    Icon(Icons.location_on, color: Colors.red, size: 20),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: subscription.homeAddress,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        size: 14,
                        color: themeChange.getThem() ? Colors.white : Colors.black87,
                      ),
                      const SizedBox(height: 16),
                      CustomText(
                        text: subscription.destinationAddress,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        size: 14,
                        color: themeChange.getThem() ? Colors.white : Colors.black87,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStat(l10n.distance, '${subscription.distanceKm.toStringAsFixed(1)} KM', themeChange),
                _buildStat(l10n.trips, '${subscription.completedTrips}/${subscription.totalTrips}', themeChange),
                _buildStat(l10n.price, '${subscription.totalPrice.toStringAsFixed(3)} KWD', themeChange),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppThemeData.primary200.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.calendar_today, size: 16, color: AppThemeData.primary200),
                  const SizedBox(width: 8),
                  CustomText(
                    text: '${subscription.startDate} → ${subscription.endDate}',
                    size: 13,
                    weight: FontWeight.w500,
                    color: AppThemeData.primary200,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value, DarkThemeProvider themeChange) {
    return Column(
      children: [
        CustomText(
          text: value,
          size: 16,
          weight: FontWeight.bold,
          color: themeChange.getThem() ? Colors.white : Colors.black87,
        ),
        const SizedBox(height: 2),
        CustomText(
          text: label,
          size: 12,
          color: themeChange.getThem() ? Colors.white60 : Colors.black54,
        ),
      ],
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bgColor;
    Color textColor;
    String displayText;

    switch (status) {
      case 'active':
        bgColor = Colors.green.withValues(alpha: 0.1);
        textColor = Colors.green;
        displayText = 'ACTIVE';
        break;
      case 'pending':
        bgColor = Colors.orange.withValues(alpha: 0.1);
        textColor = Colors.orange;
        displayText = 'PENDING PAYMENT';
        break;
      case 'pending_approval':
        bgColor = Colors.amber.withValues(alpha: 0.1);
        textColor = Colors.amber.shade700;
        displayText = 'PENDING APPROVAL';
        break;
      case 'rejected':
        bgColor = Colors.red.withValues(alpha: 0.1);
        textColor = Colors.red;
        displayText = 'REJECTED';
        break;
      case 'completed':
        bgColor = Colors.blue.withValues(alpha: 0.1);
        textColor = Colors.blue;
        displayText = 'COMPLETED';
        break;
      case 'cancelled':
        bgColor = Colors.red.withValues(alpha: 0.1);
        textColor = Colors.red;
        displayText = 'CANCELLED';
        break;
      default:
        bgColor = Colors.grey.withValues(alpha: 0.1);
        textColor = Colors.grey;
        displayText = status.toUpperCase();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: CustomText(
        text: displayText,
        size: 11,
        weight: FontWeight.bold,
        color: textColor,
      ),
    );
  }

  Widget _buildPaymentBadge(String status) {
    Color bgColor;
    Color textColor;
    String label;

    switch (status) {
      case 'paid':
        bgColor = Colors.green.withValues(alpha: 0.1);
        textColor = Colors.green;
        label = 'PAID';
        break;
      case 'pending':
        bgColor = Colors.orange.withValues(alpha: 0.1);
        textColor = Colors.orange;
        label = 'UNPAID';
        break;
      case 'refunded':
        bgColor = Colors.grey.withValues(alpha: 0.1);
        textColor = Colors.grey;
        label = 'REFUNDED';
        break;
      default:
        bgColor = Colors.grey.withValues(alpha: 0.1);
        textColor = Colors.grey;
        label = status.toUpperCase();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: CustomText(
        text: label,
        size: 11,
        weight: FontWeight.bold,
        color: textColor,
      ),
    );
  }
}
