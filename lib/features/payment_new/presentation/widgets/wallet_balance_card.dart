import 'package:flutter/material.dart';
import '../../../../core/themes/constant_colors.dart';
import '../../../../generated/app_localizations.dart';
import '../../../../common/widget/custom_text.dart';
import '../../data/models/wallet_model.dart';

class WalletBalanceCard extends StatelessWidget {
  final WalletModel wallet;

  const WalletBalanceCard({
    super.key,
    required this.wallet,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    // Mock data for total spent and added (will be added to model later)
    final totalSpent = 0.0;
    final totalAdded = 0.0;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppThemeData.primary200,
            AppThemeData.primary200.withValues(alpha: 0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppThemeData.primary200.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Wallet Icon and Label
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.account_balance_wallet,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              CustomText(
                text: l10n.walletBalance,
                size: 16,
                color: Colors.white.withValues(alpha: 0.9),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Balance Amount
          CustomText(
            text: '\$${wallet.balance.toStringAsFixed(2)}',
            size: 36,
            weight: FontWeight.bold,
            color: Colors.white,
          ),

          const SizedBox(height: 8),

          // Currency
          CustomText(
            text: wallet.currency,
            size: 14,
            color: Colors.white.withValues(alpha: 0.8),
          ),

          const SizedBox(height: 24),

          // Additional Info
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoItem(
                  'Total Spent',
                  '\$${totalSpent.toStringAsFixed(2)}',
                ),
                Container(
                  width: 1,
                  height: 30,
                  color: Colors.white.withValues(alpha: 0.3),
                ),
                _buildInfoItem(
                  'Total Added',
                  '\$${totalAdded.toStringAsFixed(2)}',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: label,
          size: 12,
          color: Colors.white.withValues(alpha: 0.7),
        ),
        const SizedBox(height: 4),
        CustomText(
          text: value,
          size: 16,
          weight: FontWeight.bold,
          color: Colors.white,
        ),
      ],
    );
  }
}
