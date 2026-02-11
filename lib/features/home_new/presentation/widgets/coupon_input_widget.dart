import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/themes/constant_colors.dart';
import '../../../../generated/app_localizations.dart';
import '../../../../common/widget/custom_text.dart';

class CouponInputWidget extends StatefulWidget {
  final bool isDarkMode;
  final String? appliedCouponCode;
  final double? couponDiscount;
  final Function(String) onApplyCoupon;
  final VoidCallback onRemoveCoupon;

  const CouponInputWidget({
    Key? key,
    required this.isDarkMode,
    this.appliedCouponCode,
    this.couponDiscount,
    required this.onApplyCoupon,
    required this.onRemoveCoupon,
  }) : super(key: key);

  @override
  State<CouponInputWidget> createState() => _CouponInputWidgetState();
}

class _CouponInputWidgetState extends State<CouponInputWidget> {
  final TextEditingController _couponController = TextEditingController();
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    if (widget.appliedCouponCode != null) {
      _couponController.text = widget.appliedCouponCode!;
      _isExpanded = true;
    }
  }

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  void _applyCoupon() {
    final code = _couponController.text.trim();
    if (code.isNotEmpty) {
      widget.onApplyCoupon(code);
    }
  }

  void _removeCoupon() {
    _couponController.clear();
    widget.onRemoveCoupon();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final hasAppliedCoupon = widget.appliedCouponCode != null;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: hasAppliedCoupon
              ? AppThemeData.success200
              : (widget.isDarkMode
                  ? AppThemeData.grey300Dark
                  : AppThemeData.grey300),
        ),
        borderRadius: BorderRadius.circular(12),
        color: hasAppliedCoupon
            ? AppThemeData.success200.withOpacity(0.05)
            : Colors.transparent,
      ),
      child: Column(
        children: [
          // Header Row
          ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: hasAppliedCoupon
                    ? AppThemeData.success200.withOpacity(0.1)
                    : (widget.isDarkMode
                        ? AppThemeData.grey200Dark
                        : AppThemeData.grey200),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Iconsax.ticket_discount,
                color: hasAppliedCoupon
                    ? AppThemeData.success200
                    : (widget.isDarkMode
                        ? AppThemeData.grey500Dark
                        : AppThemeData.grey500),
                size: 20,
              ),
            ),
            title: CustomText(
              text: hasAppliedCoupon ? l10n.couponApplied : l10n.haveCouponCode,
              size: 16,
              weight: FontWeight.w600,
              color: widget.isDarkMode
                  ? AppThemeData.grey900Dark
                  : AppThemeData.grey900,
            ),
            subtitle: hasAppliedCoupon
                ? CustomText(
                    text: widget.appliedCouponCode!,
                    size: 12,
                    weight: FontWeight.w500,
                    color: AppThemeData.success200,
                  )
                : null,
            trailing: IconButton(
              onPressed: _toggleExpanded,
              icon: Icon(
                _isExpanded ? Iconsax.arrow_up_2 : Iconsax.arrow_down_1,
                color: widget.isDarkMode
                    ? AppThemeData.grey500Dark
                    : AppThemeData.grey500,
              ),
            ),
          ),

          // Expanded Content
          if (_isExpanded) ...[
            Divider(
              height: 1,
              color: widget.isDarkMode
                  ? AppThemeData.grey300Dark
                  : AppThemeData.grey300,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Coupon Input Field
                  if (!hasAppliedCoupon) ...[
                    TextField(
                      controller: _couponController,
                      textCapitalization: TextCapitalization.characters,
                      decoration: InputDecoration(
                        hintText: l10n.enterCouponCode,
                        prefixIcon: Icon(
                          Iconsax.ticket,
                          color: widget.isDarkMode
                              ? AppThemeData.grey500Dark
                              : AppThemeData.grey500,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: widget.isDarkMode
                                ? AppThemeData.grey300Dark
                                : AppThemeData.grey300,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: widget.isDarkMode
                                ? AppThemeData.grey300Dark
                                : AppThemeData.grey300,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: AppThemeData.primary200,
                            width: 2,
                          ),
                        ),
                      ),
                      style: TextStyle(
                        color: widget.isDarkMode
                            ? AppThemeData.grey900Dark
                            : AppThemeData.grey900,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Apply Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _applyCoupon,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppThemeData.primary200,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: CustomText(
                          text: l10n.applyCoupon,
                          size: 14,
                          weight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],

                  // Applied Coupon Details
                  if (hasAppliedCoupon) ...[
                    // Discount Amount
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppThemeData.success200.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Iconsax.discount_shape,
                                size: 20,
                                color: AppThemeData.success200,
                              ),
                              const SizedBox(width: 8),
                              CustomText(
                                text: l10n.couponDiscount,
                                size: 14,
                                weight: FontWeight.normal,
                                color: AppThemeData.success200,
                              ),
                            ],
                          ),
                          CustomText(
                            text: '-\$${widget.couponDiscount?.toStringAsFixed(2) ?? '0.00'}',
                            size: 16,
                            weight: FontWeight.w700,
                            color: AppThemeData.success200,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Remove Button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: _removeCoupon,
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: AppThemeData.error200,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: CustomText(
                          text: l10n.removeCoupon,
                          size: 14,
                          weight: FontWeight.w600,
                          color: AppThemeData.error200,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
