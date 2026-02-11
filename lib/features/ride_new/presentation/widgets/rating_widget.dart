import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/themes/constant_colors.dart';

/// Rating Widget - Star rating input/display
class RatingWidget extends StatelessWidget {
  final double rating;
  final ValueChanged<double>? onRatingChanged;
  final double size;
  final bool readOnly;
  final Color? activeColor;
  final Color? inactiveColor;

  const RatingWidget({
    super.key,
    required this.rating,
    this.onRatingChanged,
    this.size = 32,
    this.readOnly = false,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final starValue = index + 1.0;
        final isFilled = rating >= starValue;
        final isHalfFilled = rating >= starValue - 0.5 && rating < starValue;
        
        return GestureDetector(
          onTap: readOnly || onRatingChanged == null
              ? null
              : () => onRatingChanged!(starValue),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size * 0.05),
            child: Icon(
              isFilled
                  ? Iconsax.star1
                  : isHalfFilled
                      ? Iconsax.star
                      : Iconsax.star,
              size: size,
              color: isFilled || isHalfFilled
                  ? (activeColor ?? Colors.amber)
                  : (inactiveColor ?? AppThemeData.grey300),
            ),
          ),
        );
      }),
    );
  }
}
