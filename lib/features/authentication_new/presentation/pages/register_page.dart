import 'package:cabme/common/widget/button.dart';
import 'package:cabme/common/widget/text_field.dart';
import 'package:cabme/core(new)/utils/widgets/custom_snackbar.dart';
import 'package:cabme/features/authentication_new/presentation/cubit/register/register_cubit.dart';
import 'package:cabme/features/authentication_new/presentation/cubit/register/register_state.dart';
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
import 'signup_success_page.dart';

class RegisterPage extends StatefulWidget {
  final String phoneNumber;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? loginType;

  const RegisterPage({
    super.key,
    required this.phoneNumber,
    this.email,
    this.firstName,
    this.lastName,
    this.loginType,
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  late String _loginType;

  @override
  void initState() {
    super.initState();

    // Strip country code from phone number
    String phone = widget.phoneNumber;
    if (phone.startsWith('+965')) {
      phone = phone.substring(4);
    } else if (phone.startsWith('965')) {
      phone = phone.substring(3);
    }
    _phoneController.text = phone;

    // Pre-fill data if available (from social login)
    if (widget.email != null) _emailController.text = widget.email!;
    if (widget.firstName != null) _firstNameController.text = widget.firstName!;
    if (widget.lastName != null) _lastNameController.text = widget.lastName!;

    _loginType = widget.loginType ?? 'email';
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
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
      create: (context) => getIt<RegisterCubit>(),
      child: BlocConsumer<RegisterCubit, RegisterState>(
        listener: (context, state) {
          if (state is RegisterLoading) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => const Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (state is RegisterSuccess) {
            Navigator.of(context).pop(); // Close loading

            // Clear fields
            _firstNameController.clear();
            _lastNameController.clear();
            _emailController.clear();
            _passwordController.clear();
            _confirmPasswordController.clear();

            // Navigate to success screen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const SignupSuccessPage(),
              ),
            );
          } else if (state is RegisterFailure) {
            Navigator.of(context).pop(); // Close loading
            CustomSnackbar.showError(
                context: context, message: state.exception.message);
          }
        },
        builder: (context, state) {
          return AuthScreenLayout(
            title: l10n.createYourAccount,
            subtitle: l10n.signupSubtitle,
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
                // Name Fields Row
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        text: l10n.firstName,
                        controller: _firstNameController,
                        keyboardType: TextInputType.name,
                        validationType: ValidationType.name,
                        prefixIcon: _buildIcon(Iconsax.user, isDarkMode),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomTextField(
                        text: l10n.lastName,
                        controller: _lastNameController,
                        keyboardType: TextInputType.name,
                        validationType: ValidationType.name,
                        prefixIcon: _buildIcon(Iconsax.user, isDarkMode),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Phone Number Field (Read-only since already verified)
                PhoneInputWidget(
                  controller: _phoneController,
                  readOnly: true,
                ),

                const SizedBox(height: 16),

                // Email Field
                CustomTextField(
                  text: l10n.emailAddress,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validationType: ValidationType.email,
                  readOnly: _loginType == "google" || _loginType == "apple",
                  prefixIcon: _buildIcon(Iconsax.sms, isDarkMode),
                ),

                // Password Fields (only if not social login)
                if (_loginType != "google" && _loginType != "apple") ...[
                  const SizedBox(height: 16),

                  // Password Field
                  CustomTextField(
                    text: l10n.password,
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
                    text: l10n.confirmPassword,
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
                          _isConfirmPasswordVisible =
                              !_isConfirmPasswordVisible;
                        });
                      },
                    ),
                  ),
                ],

                const SizedBox(height: 32),

                // Sign Up Button
                CustomButton(
                  btnName: l10n.signUp,
                  ontap: () => _handleSignUp(context),
                ),

                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }

  void _handleSignUp(BuildContext context) {
    FocusScope.of(context).unfocus();
    final l10n = AppLocalizations.of(context)!;

    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final phone = _phoneController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    // Validate First Name
    if (firstName.isEmpty) {
      CustomSnackbar.showError(
          context: context, message: l10n.firstNameRequired);
      return;
    }

    // Validate Last Name
    if (lastName.isEmpty) {
      CustomSnackbar.showError(
          context: context, message: l10n.lastNameRequired);
      return;
    }

    // Validate Email
    if (email.isEmpty) {
      CustomSnackbar.showError(context: context, message: l10n.emailRequired);
      return;
    }

    bool emailValid = RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
        .hasMatch(email);
    if (!emailValid) {
      CustomSnackbar.showError(
          context: context, message: l10n.pleaseEnterValidEmail);
      return;
    }

    // Validate Password (only for non-social login)
    if (_loginType != "google" && _loginType != "apple") {
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
    }

    // Register
    context.read<RegisterCubit>().register(
          firstName: firstName,
          lastName: lastName,
          email: email,
          phone: '965$phone',
          password: password,
          loginType: _loginType,
        );
  }
}
