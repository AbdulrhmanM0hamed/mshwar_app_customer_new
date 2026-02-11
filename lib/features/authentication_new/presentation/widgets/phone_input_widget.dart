import 'package:cabme/core/themes/constant_colors.dart';
import 'package:cabme/core/utils/dark_theme_provider.dart';
import 'package:cabme/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

/// Reusable phone input widget with Kuwait country code and real-time validation
class PhoneInputWidget extends StatefulWidget {
  final TextEditingController controller;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final bool readOnly;

  const PhoneInputWidget({
    super.key,
    required this.controller,
    this.onChanged,
    this.validator,
    this.readOnly = false,
  });

  @override
  State<PhoneInputWidget> createState() => _PhoneInputWidgetState();
}

class _PhoneInputWidgetState extends State<PhoneInputWidget> {
  bool _isValid = false;
  bool _hasInput = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_validatePhoneNumber);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_validatePhoneNumber);
    super.dispose();
  }

  void _validatePhoneNumber() {
    final phoneNumber = widget.controller.text;
    final l10n = AppLocalizations.of(context)!;
    
    setState(() {
      _hasInput = phoneNumber.isNotEmpty;

      if (phoneNumber.isEmpty) {
        _isValid = false;
        _errorMessage = null;
        return;
      }

      // Kuwait phone numbers validation
      final kuwaitPhoneRegex = RegExp(r'^(41\d{6}|[5692]\d{7}|999\d{5})$');

      if (phoneNumber.length < 8) {
        _isValid = false;
        _errorMessage = l10n.kuwaitNumberMustBe8Digits;
      } else if (phoneNumber.length > 8) {
        _isValid = false;
        _errorMessage = l10n.kuwaitNumberMustBe8Digits;
      } else if (!kuwaitPhoneRegex.hasMatch(phoneNumber)) {
        _isValid = false;
        _errorMessage = l10n.kuwaitNumbersStartWith;
      } else {
        _isValid = true;
        _errorMessage = null;
      }
    });
  }

  Color _getBorderColor(bool isDarkMode) {
    if (!_hasInput) {
      return isDarkMode ? AppThemeData.grey200Dark : AppThemeData.grey200;
    }
    return _isValid ? Colors.green.shade400 : Colors.red.shade400;
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final isDarkMode = themeChange.getThem();
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: _getBorderColor(isDarkMode),
              width: _hasInput ? 1.5 : 1,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(0)),
            color: isDarkMode
                ? AppThemeData.grey300Dark.withValues(alpha: 0.3)
                : Colors.white,
          ),
          padding: const EdgeInsets.only(left: 10),
          child: TextFormField(
            controller: widget.controller,
            keyboardType: TextInputType.phone,
            readOnly: widget.readOnly,
            maxLength: 8,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(8),
            ],
            validator: widget.validator ??
                (value) {
                  if (value == null || value.isEmpty) {
                    return l10n.phoneNumberIsRequired;
                  }

                  final kuwaitPhoneRegex =
                      RegExp(r'^(41\d{6}|[5692]\d{7}|999\d{5})$');

                  if (value.length != 8) {
                    return l10n.kuwaitNumberMustBe8Digits;
                  }

                  if (!kuwaitPhoneRegex.hasMatch(value)) {
                    return l10n.invalidKuwaitPhoneNumber;
                  }

                  return null;
                },
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
              counterText: '',
              prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "🇰🇼 +965",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 1,
                      height: 24,
                      color: isDarkMode
                          ? AppThemeData.grey300Dark
                          : AppThemeData.grey300,
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ),
              suffixIcon: _hasInput
                  ? Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Icon(
                        _isValid ? Iconsax.tick_circle5 : Iconsax.close_circle5,
                        color: _isValid
                            ? Colors.green.shade400
                            : Colors.red.shade400,
                        size: 24,
                      ),
                    )
                  : null,
              hintText: '51234567',
              hintStyle: TextStyle(
                fontSize: 16,
                color: isDarkMode
                    ? AppThemeData.grey400Dark
                    : AppThemeData.grey400,
                fontFamily: 'Cairo',
              ),
              border: InputBorder.none,
              errorStyle: const TextStyle(height: 0, fontSize: 0, fontFamily: 'Cairo'),
            ),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color:
                  isDarkMode ? AppThemeData.grey900Dark : AppThemeData.grey900,
              fontFamily: 'Cairo',
            ),
            cursorColor: AppThemeData.primary200,
            onChanged: (value) {
              if (widget.onChanged != null) {
                widget.onChanged!(value);
              }
            },
          ),
        ),
        // Real-time error message or helper text
        const SizedBox(height: 6),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: _hasInput
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      Icon(
                        _isValid ? Iconsax.tick_circle : Iconsax.info_circle,
                        size: 14,
                        color: _isValid
                            ? Colors.green.shade600
                            : Colors.red.shade600,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          _isValid
                              ? l10n.validKuwaitPhoneNumber
                              : _errorMessage ?? l10n.invalidPhoneNumber,
                          style: TextStyle(
                            fontSize: 12,
                            color: _isValid
                                ? Colors.green.shade600
                                : Colors.red.shade600,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ),
                      // Character counter
                      Text(
                        '${widget.controller.text.length}/8',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDarkMode
                              ? AppThemeData.grey400Dark
                              : AppThemeData.grey400,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    l10n.enter8DigitKuwaitMobileNumber,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDarkMode
                          ? AppThemeData.grey400Dark
                          : AppThemeData.grey400,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}
