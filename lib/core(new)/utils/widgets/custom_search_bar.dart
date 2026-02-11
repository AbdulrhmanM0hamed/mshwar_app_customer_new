import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../theme/app_colors.dart';
import '../constant/styles_manger.dart';
import '../constant/font_manger.dart';
import '../../responsive/app_responsive.dart';

/// A reusable search bar widget with consistent styling
class CustomSearchBar extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final VoidCallback? onFilterTap;
  final VoidCallback? onMapTap;
  final VoidCallback? onClear;
  final bool showFilterButton;
  final bool readOnly;
  final bool showClearButton;

  const CustomSearchBar({
    super.key,
    this.controller,
    required this.hintText,
    this.onChanged,
    this.onTap,
    this.onFilterTap,
    this.onMapTap,
    this.onClear,
    this.showFilterButton = true,
    this.readOnly = false,
    this.showClearButton = true,
  });

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final hasText = controller?.text.isNotEmpty ?? false;
    
    // Responsive values
    final padding = AppTokens.paddingMd(context);
    final searchHeight = AppTokens.buttonMd(context);
    final radius = AppTokens.radiusMd(context);
    final spacing = AppTokens.paddingSm(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: padding, vertical: 4),
      child: Row(
        children: [
          // Search Field
          Expanded(
            child: GestureDetector(
              onTap: readOnly ? onTap : null,
              child: Container(
                height: searchHeight,
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(radius),
                  border: Border.all(
                    color: Colors.grey.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: readOnly
                    ? _buildReadOnlyContent(context, isRtl)
                    : _buildTextField(context, isRtl, hasText),
              ),
            ),
          ),
          // Filter Button (split into two halves if onMapTap is provided)
          if (showFilterButton) ...[
            SizedBox(width: spacing),
            if (onMapTap != null)
              _buildSplitFilterButton(context)
            else
              _buildSingleFilterButton(context),
          ],
        ],
      ),
    );
  }

  Widget _buildSingleFilterButton(BuildContext context) {
    final buttonSize = AppTokens.buttonMd(context);
    final radius = AppTokens.radiusMd(context);
    final iconSize = AppTokens.iconMd(context);
    
    return GestureDetector(
      onTap: onFilterTap,
      child: Container(
        height: buttonSize,
        width: buttonSize,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(radius),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(Icons.tune, color: Colors.white, size: iconSize),
      ),
    );
  }

  Widget _buildSplitFilterButton(BuildContext context) {
    final buttonHeight = AppTokens.buttonMd(context);
    final buttonWidth = AppTokens.buttonMd(context) + AppTokens.paddingSm(context);
    final radius = AppTokens.radiusMd(context);
    final iconSize = AppTokens.iconMd(context);
    
    return Container(
      height: buttonHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Filter icon (left side) - Primary color
          GestureDetector(
            onTap: onFilterTap,
            child: Container(
              width: buttonWidth,
              height: buttonHeight,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadiusDirectional.only(
                  topStart: Radius.circular(radius),
                  bottomStart: Radius.circular(radius),
                ),
              ),
              alignment: Alignment.center,
              child: Icon(Icons.tune, color: Colors.white, size: iconSize),
            ),
          ),
          // Map icon (right side) - Red color
          GestureDetector(
            onTap: onMapTap,
            child: Container(
              width: buttonWidth,
              height: buttonHeight,
              decoration: BoxDecoration(
                color: AppColors.errorRed,
                borderRadius: BorderRadiusDirectional.only(
                  topEnd: Radius.circular(radius),
                  bottomEnd: Radius.circular(radius),
                ),
              ),
              alignment: Alignment.center,
              child: Icon(Icons.map_outlined, color: Colors.white, size: iconSize),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReadOnlyContent(BuildContext context, bool isRtl) {
    final fontSize = AppTokens.fontMd(context);
    final iconPadding = AppTokens.paddingSm(context);
    
    return AbsorbPointer(
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.all(iconPadding),
            child: SvgPicture.asset(
              "assets/icons/search-normal.svg",
              colorFilter: ColorFilter.mode(
                Colors.grey[500]!,
                BlendMode.srcIn,
              ),
            ),
          ),
          Expanded(
            child: Text(
              hintText,
              style: getRegularStyle(
                fontSize: fontSize,
                fontFamily: FontConstant.cairo,
                color: Colors.grey[500],
              ),
              textAlign: isRtl ? TextAlign.right : TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(BuildContext context, bool isRtl, bool hasText) {
    final fontSize = AppTokens.fontMd(context);
    final iconPadding = AppTokens.paddingSm(context);
    final contentPadding = AppTokens.paddingMd(context);
    final iconSize = AppTokens.iconMd(context);
    
    return TextField(
      controller: controller,
      textAlign: isRtl ? TextAlign.right : TextAlign.left,
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      style: getMediumStyle(
        fontSize: fontSize,
        fontFamily: FontConstant.cairo,
        color: AppColors.textPrimary,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: getRegularStyle(
          fontSize: fontSize,
          fontFamily: FontConstant.cairo,
          color: Colors.grey[500],
        ),
        prefixIcon: Padding(
          padding: EdgeInsets.all(iconPadding),
          child: SvgPicture.asset(
            "assets/icons/search-normal.svg",
            colorFilter: ColorFilter.mode(
              Colors.grey[500]!,
              BlendMode.srcIn,
            ),
          ),
        ),
        suffixIcon: showClearButton && hasText
            ? IconButton(
                onPressed: () {
                  controller?.clear();
                  onClear?.call();
                },
                icon: Icon(
                  Icons.close_rounded,
                  color: Colors.grey[400],
                  size: iconSize,
                ),
              )
            : null,
        border: InputBorder.none,
        contentPadding: EdgeInsets.symmetric(
          horizontal: contentPadding,
          vertical: iconPadding,
        ),
      ),
    );
  }
}
