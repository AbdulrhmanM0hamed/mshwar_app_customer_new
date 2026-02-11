import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../common/widget/custom_text.dart';
import '../../../../core/themes/constant_colors.dart';
import '../../../../core/utils/dark_theme_provider.dart';
import '../../../../generated/app_localizations.dart';
import '../../data/models/package_model.dart';

class UserPackageCard extends StatelessWidget {
  final UserPackageModel package;

  const UserPackageCard({
    super.key,
    required this.package,
  });

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final isDark = themeChange.getThem();
    final l10n = AppLocalizations.of(context)!;

    Color statusColor = Colors.green;
    if (package.isConsumed) {
      statusColor = Colors.blue;
    } else if (!package.isActive) {
      statusColor = Colors.grey;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: isDark ? AppThemeData.grey800 : Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CustomText(
                    text: package.packageName,
                    size: 18,
                    weight: FontWeight.bold,
                    color: isDark ? Colors.white : AppThemeData.grey900,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: CustomText(
                    text: package.statusDisplay,
                    size: 12,
                    weight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark
                    ? AppThemeData.grey300Dark.withValues(alpha: 0.3)
                    : AppThemeData.grey100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _buildKmStat(
                      l10n.availableKm,
                      package.remainingKm.toStringAsFixed(0),
                      Icons.speed,
                      AppThemeData.success300,
                      isDark,
                    ),
                  ),
                  Container(
                    height: 50,
                    width: 1,
                    color: isDark ? AppThemeData.grey300Dark : AppThemeData.grey300,
                  ),
                  Expanded(
                    child: _buildKmStat(
                      l10n.usedKm,
                      package.usedKm.toStringAsFixed(0),
                      Icons.trending_up,
                      AppThemeData.error200,
                      isDark,
                    ),
                  ),
                  Container(
                    height: 50,
                    width: 1,
                    color: isDark ? AppThemeData.grey300Dark : AppThemeData.grey300,
                  ),
                  Expanded(
                    child: _buildKmStat(
                      l10n.totalKm,
                      package.totalKm.toStringAsFixed(0),
                      Icons.inventory_2,
                      AppThemeData.primary200,
                      isDark,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: package.remainingProgress,
                    minHeight: 8,
                    backgroundColor: isDark ? AppThemeData.grey300Dark : AppThemeData.grey200,
                    valueColor: AlwaysStoppedAnimation<Color>(AppThemeData.success300),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: '${(package.remainingProgress * 100).toStringAsFixed(0)}% ${l10n.remaining}',
                      size: 11,
                      color: AppThemeData.success300,
                      weight: FontWeight.w500,
                    ),
                    CustomText(
                      text: '${(package.usageProgress * 100).toStringAsFixed(0)}% ${l10n.used}',
                      size: 11,
                      color: isDark ? AppThemeData.grey400Dark : AppThemeData.grey500,
                    ),
                  ],
                ),
              ],
            ),
            if (package.purchasedAt != null) ...[
              const SizedBox(height: 16),
              _buildDetailChip(
                Icons.calendar_today,
                '${l10n.purchased}: ${package.purchasedAt}',
                isDark,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildKmStat(String label, String value, IconData icon, Color color, bool isDark) {
    return Column(
      children: [
        Icon(icon, size: 24, color: color),
        const SizedBox(height: 6),
        CustomText(
          text: value,
          size: 20,
          weight: FontWeight.bold,
          color: color,
        ),
        CustomText(
          text: label,
          size: 11,
          color: isDark ? AppThemeData.grey400Dark : AppThemeData.grey500,
        ),
      ],
    );
  }

  Widget _buildDetailChip(IconData icon, String text, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? AppThemeData.grey300Dark : AppThemeData.grey100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: isDark ? AppThemeData.grey400Dark : AppThemeData.grey500,
          ),
          const SizedBox(width: 4),
          CustomText(
            text: text,
            size: 12,
            color: isDark ? AppThemeData.grey400Dark : AppThemeData.grey500,
          ),
        ],
      ),
    );
  }
}
