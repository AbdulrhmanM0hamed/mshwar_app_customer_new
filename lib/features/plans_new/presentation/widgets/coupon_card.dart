import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../common/widget/custom_text.dart';
import '../../../../core/themes/constant_colors.dart';
import '../../../../core/utils/dark_theme_provider.dart';
import '../../../../generated/app_localizations.dart';
import '../../data/models/coupon_model.dart';

class CouponCard extends StatelessWidget {
  final PlansCouponModel coupon;
  final VoidCallback onCopy;

  const CouponCard({
    super.key,
    required this.coupon,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final isDark = themeChange.getThem();
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? AppThemeData.grey800 : AppThemeData.grey100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppThemeData.primary200,
              borderRadius: const BorderRadius.all(Radius.circular(30)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Icon(
                Icons.local_offer,
                color: Colors.white,
                size: 32,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: coupon.description,
                  size: 16,
                  weight: FontWeight.bold,
                  color: isDark ? AppThemeData.grey900Dark : AppThemeData.grey900,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    InkWell(
                      onTap: onCopy,
                      child: Container(
                        color: Colors.black.withValues(alpha: 0.05),
                        child: DottedBorder(
                          color: Colors.grey,
                          strokeWidth: 1,
                          dashPattern: const [3, 3],
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomText(
                                  text: coupon.code,
                                  size: 14,
                                  weight: FontWeight.bold,
                                  color: AppThemeData.primary200,
                                ),
                                const SizedBox(width: 8),
                                Icon(
                                  Icons.copy,
                                  size: 16,
                                  color: AppThemeData.primary200,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    if (coupon.expireAt != null)
                      Expanded(
                        child: CustomText(
                          text: '${l10n.validTill} ${coupon.expireAt}',
                          size: 12,
                          color: isDark ? Colors.white60 : Colors.black54,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
                if (coupon.discountType == 'percentage') ...[
                  const SizedBox(height: 8),
                  CustomText(
                    text: '${coupon.discountValue.toStringAsFixed(0)}% ${l10n.discount}',
                    size: 13,
                    weight: FontWeight.w600,
                    color: Colors.green,
                  ),
                ] else ...[
                  const SizedBox(height: 8),
                  CustomText(
                    text: '${coupon.discountValue.toStringAsFixed(3)} KWD ${l10n.discount}',
                    size: 13,
                    weight: FontWeight.w600,
                    color: Colors.green,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
