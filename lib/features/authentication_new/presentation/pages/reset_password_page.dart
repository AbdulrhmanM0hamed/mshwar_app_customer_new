import 'package:cabme/common/widget/button.dart';
import 'package:cabme/common/widget/text_field.dart';
import 'package:cabme/core(new)/utils/widgets/custom_snackbar.dart';
import 'package:cabme/features/authentication_new/presentation/cubit/otp/otp_cubit.dart';
import 'package:cabme/features/authentication_new/presentation/cubit/otp/otp_state.dart';
import 'package:cabme/features/authentication_new/di/auth_service_locator.dart';
import 'package:cabme/features/authentication_new/presentation/widgets/auth_widgets.dart';
import 'package:cabme/core/themes/constant_colors.dart';
import 'package:cabme/core/utils/dark_theme_provider.dart';
import 'package:cabme/generated/app_localizations.dart';
import 'package:cabme/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'login_page.dart';

class ResetPasswordPage extends StatefulWidget {
  final String email;

  const ResetPasswordPage({
    super.key,
    required this.email,
  });

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _otpController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _otpController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Icon _buildIcon(IconData icon, bool isDarkMode) {
    return Icon(
      icon,
      color: isDarkMode ? AppThemeData.grey400Dark : AppThemeData.grey400,
      size: 22,
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    bool isDarkMode = themeChange.getThem();
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (context) => getIt<OtpCubit>(),
      child: BlocConsumer<OtpCubit, OtpState>(
        listener: (context, state) {
          if (state is ResetPasswordLoading) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => const Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (state is ResetPasswordSuccess) {
            Navigator.of(context).pop(); // Close loading

            CustomSnackbar.showSuccess(
              context: context,
              message: l10n.passwordResetSuccessfully,
            );

            // Navigate to login
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const LoginPage()),
              (route) => false,
            );
          } else if (state is ResetPasswordFailure) {
            Navigator.of(context).pop(); // Close loading
            CustomSnackbar.showError(
                context: context, message: state.exception.message);
          }
        },
        builder: (context, state) {
          return AuthScreenLayout(
            title: l10n.resetYourPassword,
            subtitle: l10n.resetPasswordSubtitle,
            bottomWidget: AuthBottomLink(
              text: l10n.rememberYourPassword,
              linkText: l10n.logIn,
              onTap: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Email Display
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? AppThemeData.grey300Dark.withValues(alpha: 0.3)
                        : AppThemeData.grey100,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDarkMode
                          ? AppThemeData.grey300Dark
                          : AppThemeData.grey200,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Iconsax.sms,
                        color: AppThemeData.primary200,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Flexible(
                        child: Text(
                          widget.email,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: isDarkMode
                                ? AppThemeData.grey900Dark
                                : AppThemeData.grey900,
                            fontFamily: 'Cairo',
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // OTP Field
                CustomTextField(
                  text: l10n.verificationCode,
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  validationType: ValidationType.none,
                  prefixIcon: _buildIcon(Iconsax.password_check, isDarkMode),
                ),

                const SizedBox(height: 16),

                // New Password Field
                CustomTextField(
                  text: l10n.newPassword,
                  controller: _passwordController,
                  keyboardType: TextInputType.text,
                  obscureText: !_isPasswordVisible,
                  validationType: ValidationType.password,
                  prefixIcon: _buildIcon(Iconsax.lock, isDarkMode),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Iconsax.eye : Iconsax.eye_slash,
                      color: isDarkMode
                          ? AppThemeData.grey500Dark
                          : AppThemeData.grey400,
                      size: 22,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),

                const SizedBox(height: 16),

                // Confirm Password Field
                CustomTextField(
                  text: l10n.confirmNewPassword,
                  controller: _confirmPasswordController,
                  keyboardType: TextInputType.text,
                  obscureText: !_isConfirmPasswordVisible,
                  validationType: ValidationType.confirmPassword,
                  passwordController: _passwordController,
                  prefixIcon: _buildIcon(Iconsax.lock, isDarkMode),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isConfirmPasswordVisible
                          ? Iconsax.eye
                          : Iconsax.eye_slash,
                      color: isDarkMode
                          ? AppThemeData.grey500Dark
                          : AppThemeData.grey400,
                      size: 22,
                    ),
                    onPressed: () {
                      setState(() {
                        _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                      });
                    },
                  ),
                ),

                const SizedBox(height: 32),

                // Reset Password Button
                CustomButton(
                  btnName: l10n.resetPassword,
                  ontap: () => _handleResetPassword(context),
                ),

                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }

  void _handleResetPassword(BuildContext context) {
    FocusScope.of(context).unfocus();
    final l10n = AppLocalizations.of(context)!;

    final otp = _otpController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    // Validate OTP
    if (otp.isEmpty) {
      CustomSnackbar.showError(
          context: context, message: l10n.pleaseEnterVerificationCode);
      return;
    }

    // Validate Password
    if (password.length < 6) {
      CustomSnackbar.showError(
          context: context, message: l10n.passwordMustBeAtLeast6);
      return;
    }

    if (password != confirmPassword) {
      CustomSnackbar.showError(
          context: context, message: l10n.passwordsDoNotMatch);
      return;
    }

    // Reset password
    context.read<OtpCubit>().resetPassword(
          email: widget.email,
          otp: otp,
          newPassword: password,
        );
  }
}
