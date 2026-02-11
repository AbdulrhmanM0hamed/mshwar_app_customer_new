import 'package:cabme/core(new)/utils/widgets/custom_snackbar.dart';
import 'package:cabme/features/authentication_new/di/auth_service_locator.dart';
import 'package:cabme/features/authentication_new/presentation/cubit/otp/otp_cubit.dart';
import 'package:cabme/features/authentication_new/presentation/cubit/otp/otp_state.dart';
import 'package:cabme/features/authentication_new/presentation/widgets/auth_widgets.dart';
import 'package:cabme/core/themes/constant_colors.dart';
import 'package:cabme/core/utils/dark_theme_provider.dart';
import 'package:cabme/common/widget/button.dart';
import 'package:cabme/common/widget/text_field.dart';
import 'package:cabme/common/widget/custom_text.dart';
import 'package:cabme/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:iconsax/iconsax.dart';
import 'phone_auth_page.dart';
import 'reset_password_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
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
          if (state is ResetPasswordOtpSendLoading) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => const Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (state is ResetPasswordOtpSendSuccess) {
            Navigator.of(context).pop(); // Close loading

            CustomSnackbar.showSuccess(
              context: context,
              message: l10n.resetCodeSentSuccessfully,
            );

            // Navigate to reset password page
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ResetPasswordPage(
                  email: _emailController.text.trim(),
                ),
              ),
            );
          } else if (state is ResetPasswordOtpSendFailure) {
            Navigator.of(context).pop(); // Close loading
            CustomSnackbar.showError(
                context: context, message: state.exception.message);
          }
        },
        builder: (context, state) {
          return AuthScreenLayout(
            title: l10n.forgotYourPassword,
            subtitle: l10n.forgotPasswordSubtitle,
            bottomWidget: AuthBottomLink(
              text: l10n.firstTimeInMshwar,
              linkText: l10n.createAnAccount,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PhoneAuthPage(isLogin: false),
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Email Field
                CustomTextField(
                  text: l10n.emailAddress,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validationType: ValidationType.email,
                  prefixIcon: Icon(
                    Iconsax.sms,
                    color: isDarkMode
                        ? AppThemeData.grey400Dark
                        : AppThemeData.grey400,
                    size: 22,
                  ),
                ),

                const SizedBox(height: 32),

                // Send Button
                CustomButton(
                  btnName: l10n.sendResetLink,
                  ontap: () => _handleSendEmail(context),
                ),

                const SizedBox(height: 32),

                // Divider
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: isDarkMode
                            ? AppThemeData.grey300Dark
                            : AppThemeData.grey300,
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: CustomText(
                        text: l10n.orContinueWith,
                        size: 13,
                        color: isDarkMode
                            ? AppThemeData.grey500Dark
                            : AppThemeData.grey500,
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: isDarkMode
                            ? AppThemeData.grey300Dark
                            : AppThemeData.grey300,
                        thickness: 1,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Mobile Number Button
                CustomButton(
                  btnName: l10n.mobileNumber,
                  ontap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const PhoneAuthPage(isLogin: true),
                      ),
                    );
                  },
                  isOutlined: true,
                  icon: Icon(
                    Iconsax.mobile,
                    color: AppThemeData.primary200,
                    size: 22,
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }

  void _handleSendEmail(BuildContext context) {
    FocusScope.of(context).unfocus();
    final l10n = AppLocalizations.of(context)!;

    final email = _emailController.text.trim();

    if (email.isEmpty) {
      CustomSnackbar.showError(
        message: l10n.pleaseEnterYourEmailAddress,
        context: context,
      );
      return;
    }

    // Send reset password OTP
    context.read<OtpCubit>().sendResetPasswordOtp(email);
  }
}
