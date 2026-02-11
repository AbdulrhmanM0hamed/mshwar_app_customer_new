import 'package:cabme/core(new)/utils/widgets/custom_snackbar.dart';
import 'package:cabme/features/authentication_new/presentation/cubit/login/login_cubit.dart';
import 'package:cabme/features/authentication_new/presentation/cubit/login/login_state.dart';
import 'package:cabme/features/authentication_new/data/di/auth_di.dart';
import 'package:cabme/features/authentication_new/presentation/widgets/auth_widgets.dart';
import 'package:cabme/features/home/controller/home_controller.dart';
import 'package:cabme/common/screens/botton_nav_bar.dart';
import 'package:cabme/core/themes/constant_colors.dart';
import 'package:cabme/core/utils/dark_theme_provider.dart';
import 'package:cabme/common/widget/permission_dialog.dart';
import 'package:cabme/common/widget/button.dart';
import 'package:cabme/common/widget/text_field.dart';
import 'package:cabme/common/widget/custom_text.dart';
import 'package:cabme/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:iconsax/iconsax.dart';
import 'package:get/get.dart';
import 'forgot_password_page.dart';
import 'phone_auth_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _checkLocationPermission() async {
    try {
      PermissionStatus location = await Location().hasPermission();
      if (PermissionStatus.granted != location && mounted) {
        showDialogPermission(context);
      }
    } on PlatformException catch (e) {
      if (mounted) {
        CustomSnackbar.showError(context: context, message: e.message ?? 'Permission error');
      }
    }
  }

  void showDialogPermission(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const LocationPermissionDisclosureDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    bool isDarkMode = themeChange.getThem();
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (context) => getIt<LoginCubit>(),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginLoading) {
            // Show loading indicator
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => const Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (state is LoginSuccess) {
            // Close loading
            Navigator.of(context).pop();
            
            // Clear fields
            _emailController.clear();
            _passwordController.clear();

            // Show success message
            CustomSnackbar.showSuccess(
              context: context,
              message: l10n.loginSuccessful,
            );

            // Preload home screen data before navigating
            _preloadHomeAndNavigate();
          } else if (state is LoginFailure) {
            // Close loading
            Navigator.of(context).pop();
            
            // Show error
            CustomSnackbar.showError(
              context: context,
              message: state.exception.message,
            );
          }
        },
        builder: (context, state) {
          return AuthScreenLayout(
            title: l10n.welcomeBack,
            subtitle: l10n.loginSubtitle,
            showBackButton: false,
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

                const SizedBox(height: 16),

                // Password Field
                CustomTextField(
                  text: l10n.enterPassword,
                  controller: _passwordController,
                  keyboardType: TextInputType.text,
                  obscureText: !_isPasswordVisible,
                  validationType: ValidationType.password,
                  prefixIcon: Icon(
                    Iconsax.lock,
                    color: isDarkMode
                        ? AppThemeData.grey400Dark
                        : AppThemeData.grey400,
                    size: 22,
                  ),
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

                // Forgot Password
                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ForgotPasswordPage(),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomText(
                        text: l10n.forgotPassword,
                        size: 14,
                        color: AppThemeData.primary200,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Login Button
                CustomButton(
                  btnName: l10n.login,
                  ontap: () => _handleLogin(context),
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
                        builder: (context) => const PhoneAuthPage(isLogin: true),
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

  void _handleLogin(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    // Validation
    if (email.isEmpty) {
      CustomSnackbar.showError(context: context, message: l10n.pleaseEnterEmailAddress);
      return;
    }

    if (password.isEmpty) {
      CustomSnackbar.showError(context: context, message: l10n.pleaseEnterPassword);
      return;
    }

    // Hide keyboard
    FocusScope.of(context).unfocus();

    // Call login
    context.read<LoginCubit>().login(
          email: email,
          password: password,
        );
  }

  Future<void> _preloadHomeAndNavigate() async {
    try {
      // Delete existing controller if any and create fresh one
      if (Get.isRegistered<HomeController>()) {
        Get.delete<HomeController>(force: true);
      }
      final homeController = Get.put(HomeController(), permanent: true);
      await homeController.setInitData(forceInit: true);
    } catch (e) {
      debugPrint('Error preloading home data: $e');
    }

    // Navigate to home
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => BottomNavBar()),
        (route) => false,
      );
    }
  }
}
