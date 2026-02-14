import 'package:cabme/core(new)/utils/widgets/custom_snackbar.dart';
import 'package:cabme/features/authentication_new/presentation/cubit/otp/otp_cubit.dart';
import 'package:cabme/features/authentication_new/presentation/cubit/otp/otp_state.dart';
import 'package:cabme/features/authentication_new/di/auth_service_locator.dart';
import 'package:cabme/features/authentication_new/presentation/widgets/auth_widgets.dart';
import 'package:cabme/core/themes/constant_colors.dart';
import 'package:cabme/core/utils/dark_theme_provider.dart';
import 'package:cabme/common/widget/button.dart';
import 'package:cabme/common/widget/custom_text.dart';
import 'package:cabme/core/constant/size_box.dart';
import 'package:cabme/generated/app_localizations.dart';
import 'package:cabme/service_locator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:iconsax/iconsax.dart';
import 'login_page.dart';
import 'otp_page.dart';

class PhoneAuthPage extends StatefulWidget {
  final bool isLogin;

  const PhoneAuthPage({super.key, required this.isLogin});

  @override
  State<PhoneAuthPage> createState() => _PhoneAuthPageState();
}

class _PhoneAuthPageState extends State<PhoneAuthPage>
    with SingleTickerProviderStateMixin {
  final _phoneController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    bool isDarkMode = themeChange.getThem();
    final size = MediaQuery.of(context).size;
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (context) => getIt<OtpCubit>(),
      child: BlocConsumer<OtpCubit, OtpState>(
        listener: (context, state) {
          if (state is OtpSendLoading) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => const Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (state is OtpSendSuccess) {
            Navigator.of(context).pop(); // Close loading

            CustomSnackbar.showSuccess(
                context: context, message: state.message);

            // Navigate to OTP page
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OtpPage(
                  phoneNumber: '965${_phoneController.text.trim()}',
                  isLogin: widget.isLogin,
                ),
              ),
            );
          } else if (state is OtpSendFailure) {
            Navigator.of(context).pop(); // Close loading
            CustomSnackbar.showError(
                context: context, message: state.exception.message);
          }
        },
        builder: (context, state) {
          return Scaffold(
            resizeToAvoidBottomInset: true,
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDarkMode
                      ? [
                          AppThemeData.primary200,
                          AppThemeData.primary200.withValues(alpha: 0.8),
                        ]
                      : [
                          AppThemeData.primary200,
                          AppThemeData.primary200.withValues(alpha: 0.9),
                        ],
                ),
              ),
              child: Stack(
                children: [
                  // Animated Background Circles
                  Positioned(
                    top: -100,
                    right: -100,
                    child: Container(
                      width: 300,
                      height: 300,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.05),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -50,
                    left: -50,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.05),
                      ),
                    ),
                  ),

                  // Main Content
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: size.height -
                            MediaQuery.of(context).padding.top -
                            MediaQuery.of(context).padding.bottom,
                      ),
                      child: IntrinsicHeight(
                        child: Column(
                          children: [
                            context.sizedBoxHeight(0.03),
                            // Header Section
                            FadeTransition(
                              opacity: _fadeAnimation,
                              child: SlideTransition(
                                position: _slideAnimation,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(24, 40, 24, 20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      IconButton(
                                        onPressed: () => Navigator.pop(context),
                                        icon: const Icon(
                                          Icons.arrow_back_ios,
                                          color: Colors.white,
                                          size: 24,
                                        ),
                                        padding: EdgeInsets.zero,
                                        alignment: Alignment.centerLeft,
                                      ),
                                      const SizedBox(height: 20),
                                      CustomText(
                                        text: widget.isLogin
                                            ? l10n.logInWithMobile
                                            : l10n.signUpWithMobile,
                                        size: 32,
                                        color: Colors.white,
                                        letterSpacing: -0.5,
                                        height: 1.2,
                                      ),
                                      const SizedBox(height: 12),
                                      CustomText(
                                        text: widget.isLogin
                                            ? l10n.mobileLoginSubtitle
                                            : l10n.mobileSignupSubtitle,
                                        size: 15,
                                        color:
                                            Colors.white.withValues(alpha: 0.9),
                                        height: 1.5,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Form Card
                            Expanded(
                              child: FadeTransition(
                                opacity: _fadeAnimation,
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: isDarkMode
                                        ? AppThemeData.surface50Dark
                                        : AppThemeData.surface50,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(32),
                                      topRight: Radius.circular(32),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            Colors.black.withValues(alpha: 0.1),
                                        blurRadius: 20,
                                        offset: const Offset(0, -5),
                                      ),
                                    ],
                                  ),
                                  child: SingleChildScrollView(
                                    physics: const BouncingScrollPhysics(),
                                    child: Padding(
                                      padding: const EdgeInsets.all(24),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          // Drag Handle
                                          Center(
                                            child: Container(
                                              width: 40,
                                              height: 4,
                                              decoration: BoxDecoration(
                                                color: isDarkMode
                                                    ? AppThemeData.grey300Dark
                                                    : AppThemeData.grey300,
                                                borderRadius:
                                                    BorderRadius.circular(2),
                                              ),
                                            ),
                                          ),

                                          const SizedBox(height: 32),

                                          // Phone Number Field
                                          PhoneInputWidget(
                                            controller: _phoneController,
                                          ),

                                          const SizedBox(height: 32),

                                          // Send OTP Button
                                          CustomButton(
                                            btnName: l10n.sendOtp,
                                            ontap: () =>
                                                _handleSendOTP(context),
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
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16),
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

                                          // Email Login Button
                                          CustomButton(
                                            btnName: l10n.emailAddress,
                                            ontap: () {
                                              FocusScope.of(context).unfocus();
                                              Navigator.pop(context);
                                            },
                                            isOutlined: true,
                                            icon: Icon(
                                              Iconsax.sms,
                                              color: AppThemeData.primary200,
                                              size: 22,
                                            ),
                                          ),

                                          const SizedBox(height: 24),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // Sign Up/Login Link - Bottom Section
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 20),
                              decoration: BoxDecoration(
                                color: isDarkMode
                                    ? AppThemeData.surface50Dark
                                    : AppThemeData.surface50,
                                border: Border(
                                  top: BorderSide(
                                    color: isDarkMode
                                        ? AppThemeData.grey300Dark
                                            .withValues(alpha: 0.3)
                                        : AppThemeData.grey300
                                            .withValues(alpha: 0.3),
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: Center(
                                child: widget.isLogin
                                    ? Text.rich(
                                        TextSpan(
                                          text: l10n.firstTimeInMshwar,
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontFamily: 'Cairo',
                                            color: isDarkMode
                                                ? AppThemeData.grey500Dark
                                                : AppThemeData.grey800,
                                          ),
                                          children: <TextSpan>[
                                            const TextSpan(text: ' '),
                                            TextSpan(
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () =>
                                                    Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            const PhoneAuthPage(
                                                          isLogin: false,
                                                        ),
                                                      ),
                                                    ),
                                              text: l10n.createAnAccount,
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontFamily: 'Cairo',
                                                fontWeight: FontWeight.bold,
                                                color: AppThemeData.primary200,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Text.rich(
                                        TextSpan(
                                          text: l10n.alreadyBookRides,
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontFamily: 'Cairo',
                                            color: isDarkMode
                                                ? AppThemeData.grey500Dark
                                                : AppThemeData.grey800,
                                          ),
                                          children: <TextSpan>[
                                            const TextSpan(text: ' '),
                                            TextSpan(
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () =>
                                                    Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            const LoginPage(),
                                                      ),
                                                    ),
                                              text: l10n.login,
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontFamily: 'Cairo',
                                                fontWeight: FontWeight.bold,
                                                color: AppThemeData.primary200,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _handleSendOTP(BuildContext context) {
    FocusScope.of(context).unfocus();
    final l10n = AppLocalizations.of(context)!;

    final phoneNumber = _phoneController.text.trim();

    // Validate phone number
    if (phoneNumber.isEmpty) {
      CustomSnackbar.showError(
          context: context, message: l10n.pleaseEnterMobileNumber);
      return;
    }

    if (phoneNumber.length != 8) {
      CustomSnackbar.showError(
          context: context, message: l10n.kuwaitNumberMustBe8Digits);
      return;
    }

    // Check if number starts with valid prefix
    final kuwaitPhoneRegex = RegExp(r'^(41\d{6}|[5692]\d{7}|999\d{5})$');
    if (!kuwaitPhoneRegex.hasMatch(phoneNumber)) {
      CustomSnackbar.showError(
          context: context, message: l10n.invalidKuwaitPhoneNumber);
      return;
    }

    // Send OTP
    context.read<OtpCubit>().sendOtp('965$phoneNumber');
  }
}
