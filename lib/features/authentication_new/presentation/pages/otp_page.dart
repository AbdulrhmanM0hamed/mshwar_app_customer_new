import 'dart:async';
import 'package:cabme/common/widget/button.dart';
import 'package:cabme/common/widget/custom_text.dart';
import 'package:cabme/core(new)/utils/widgets/custom_snackbar.dart';
import 'package:cabme/features/authentication_new/presentation/cubit/otp/otp_cubit.dart';
import 'package:cabme/features/authentication_new/presentation/cubit/otp/otp_state.dart';
import 'package:cabme/features/authentication_new/presentation/cubit/login/login_cubit.dart';
import 'package:cabme/features/authentication_new/presentation/cubit/login/login_state.dart';
import 'package:cabme/features/authentication_new/di/auth_service_locator.dart';
import 'package:cabme/features/authentication_new/presentation/widgets/auth_widgets.dart';
import 'package:cabme/common/screens/botton_nav_bar.dart';
import 'package:cabme/core/utils/dark_theme_provider.dart';
import 'package:cabme/generated/app_localizations.dart';
import 'package:cabme/service_locator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:cabme/core/themes/constant_colors.dart';
import 'package:cabme/features/settings_new/presentation/cubit/settings/settings_cubit.dart';
import 'dart:developer';
import 'login_page.dart';
import 'register_page.dart';

class OtpPage extends StatefulWidget {
  final String phoneNumber;
  final bool isLogin;

  const OtpPage({
    super.key,
    required this.phoneNumber,
    required this.isLogin,
  });

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final _otpController = TextEditingController();
  Timer? _timer;
  int _remainingSeconds = 60;
  bool _enableResend = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _remainingSeconds = 60;
    _enableResend = false;
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        setState(() {
          _enableResend = true;
        });
        timer.cancel();
      }
    });
  }

  String _formatTime() {
    int minutes = _remainingSeconds ~/ 60;
    int seconds = _remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    bool isDarkMode = themeChange.getThem();
    final l10n = AppLocalizations.of(context)!;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<OtpCubit>()),
        BlocProvider(create: (context) => getIt<LoginCubit>()),
      ],
      child: MultiBlocListener(
        listeners: [
          // OTP Verify Listener
          BlocListener<OtpCubit, OtpState>(
            listener: (context, state) {
              if (state is OtpVerifyLoading) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else if (state is OtpVerifySuccess) {
                Navigator.of(context).pop(); // Close loading

                CustomSnackbar.showSuccess(
                  context: context,
                  message: state.message,
                );

                // If login, get user by phone
                if (widget.isLogin) {
                  context.read<LoginCubit>().getUserByPhone(
                        phone: widget.phoneNumber,
                        userCat: 'customer',
                      );
                } else {
                  // Navigate to register page
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegisterPage(
                        phoneNumber: widget.phoneNumber,
                      ),
                    ),
                  );
                }
              } else if (state is OtpVerifyFailure) {
                Navigator.of(context).pop(); // Close loading
                CustomSnackbar.showError(
                    context: context, message: state.exception.message);
              }
              // Resend OTP Listener
              else if (state is OtpResendLoading) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else if (state is OtpResendSuccess) {
                Navigator.of(context).pop(); // Close loading
                CustomSnackbar.showSuccess(
                  message: state.message,
                  context: context,
                );
                _startTimer(); // Restart timer
                _otpController.clear();
              } else if (state is OtpResendFailure) {
                Navigator.of(context).pop(); // Close loading
                CustomSnackbar.showError(
                    context: context, message: state.exception.message);
              }
            },
          ),
          // Login Listener (for getUserByPhone)
          BlocListener<LoginCubit, LoginState>(
            listener: (context, state) {
              if (state is GetUserByPhoneLoading) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else if (state is GetUserByPhoneSuccess) {
                // Close loading
                Navigator.of(context).pop();

                CustomSnackbar.showSuccess(
                    context: context,
                    message: AppLocalizations.of(context)!.loginSuccessful);

                _preloadHomeAndNavigate();
              } else if (state is UserNotFound) {
                // Close loading
                Navigator.of(context).pop();

                // User does not exist, redirect to registration
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RegisterPage(
                      phoneNumber: state.phone,
                    ),
                  ),
                );
              } else if (state is GetUserByPhoneFailure) {
                Navigator.of(context).pop(); // Close loading
                CustomSnackbar.showError(
                    context: context, message: state.exception.message);
              }
            },
          ),
        ],
        child: AuthScreenLayout(
          title: l10n.verifyYourOtp,
          subtitle: l10n.otpSubtitle,
          bottomWidget: AuthBottomLink(
            text: l10n.alreadyHaveAnAccount,
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
              // Phone Number Display
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
                      Iconsax.mobile,
                      color: AppThemeData.primary200,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    CustomText(
                      text: widget.phoneNumber,
                      size: 16,
                      color: isDarkMode
                          ? AppThemeData.grey900Dark
                          : AppThemeData.grey900,
                      weight: FontWeight.w600,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // OTP Input
              OtpInputWidget(
                controller: _otpController,
                length: 6,
              ),

              const SizedBox(height: 24),

              // Timer and Resend
              Center(
                child: Text.rich(
                  textAlign: TextAlign.center,
                  TextSpan(
                    text: _enableResend
                        ? l10n.didntReceiveCode
                        : l10n.resendCodeIn,
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: AppThemeData.regular,
                      color: isDarkMode
                          ? AppThemeData.grey500Dark
                          : AppThemeData.grey500,
                    ),
                    children: <TextSpan>[
                      if (!_enableResend)
                        TextSpan(
                          text: ' ${_formatTime()}',
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: AppThemeData.semiBold,
                            color: AppThemeData.primary200,
                          ),
                        ),
                      if (_enableResend) const TextSpan(text: ' '),
                      if (_enableResend)
                        TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => _handleResendOTP(context),
                          text: l10n.resendOtp,
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: AppThemeData.semiBold,
                            color: AppThemeData.primary200,
                            decoration: TextDecoration.underline,
                            decorationColor: AppThemeData.primary200,
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Verify Button
              CustomButton(
                btnName: l10n.verifyOtp,
                ontap: () => _handleVerifyOTP(context),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  void _handleVerifyOTP(BuildContext context) {
    FocusScope.of(context).unfocus();
    final l10n = AppLocalizations.of(context)!;

    final otp = _otpController.text.trim();

    if (otp.length != 6) {
      CustomSnackbar.showError(
          context: context, message: l10n.pleaseEnterCompleteOtp);
      return;
    }

    // Verify OTP
    context.read<OtpCubit>().verifyOtp(
          phone: widget.phoneNumber,
          otp: otp,
        );
  }

  void _handleResendOTP(BuildContext context) {
    context.read<OtpCubit>().resendOtp(widget.phoneNumber);
  }

  Future<void> _preloadHomeAndNavigate() async {
    try {
      // Create SettingsCubit and load settings
      final settingsCubit = getIt<SettingsCubit>();
      await settingsCubit.loadSettings();

      // Navigate to home
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => BottomNavBar()),
          (route) => false,
        );
      }
    } catch (e) {
      log('Error preloading data: $e');
      // Still navigate even if preloading fails
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => BottomNavBar()),
          (route) => false,
        );
      }
    }
  }
}
