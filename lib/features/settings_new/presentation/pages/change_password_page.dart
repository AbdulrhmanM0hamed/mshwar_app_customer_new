import 'package:cabme/common/widget/button.dart';
import 'package:cabme/common/widget/custom_app_bar.dart';
import 'package:cabme/common/widget/text_field.dart';
import 'package:cabme/core/themes/constant_colors.dart';
import 'package:cabme/core/utils/dark_theme_provider.dart';
import 'package:cabme/features/settings_new/presentation/cubit/profile/profile_cubit.dart';
import 'package:cabme/features/settings_new/presentation/cubit/profile/profile_state.dart';
import 'package:cabme/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.I<ProfileCubit>(),
      child: const ChangePasswordView(),
    );
  }
}

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({super.key});

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _currentPasswordController;
  late TextEditingController _newPasswordController;
  late TextEditingController _confirmPasswordController;

  @override
  void initState() {
    super.initState();
    _currentPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final isDarkMode = themeChange.getThem();
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor:
          isDarkMode ? AppThemeData.surface50Dark : AppThemeData.surface50,
      appBar: CustomAppBar(
        title: l10n.changePassword,
        showBackButton: true,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is PasswordUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.passwordUpdatedSuccessfully),
                backgroundColor: AppThemeData.success300,
              ),
            );
            Navigator.pop(context);
          } else if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppThemeData.error200,
              ),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    controller: _currentPasswordController,
                    text: l10n.currentPassword,
                    prefixIcon: const Icon(Iconsax.lock),
                    suffixIcon: const Icon(Iconsax.eye_slash),
                    obscureText: true,
                    validationType: ValidationType.required,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _newPasswordController,
                    text: l10n.newPassword,
                    prefixIcon: const Icon(Iconsax.lock),
                    suffixIcon: const Icon(Iconsax.eye_slash),
                    obscureText: true,
                    validationType: ValidationType.password,
                    minPasswordLength: 6,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _confirmPasswordController,
                    text: l10n.confirmPassword,
                    prefixIcon: const Icon(Iconsax.lock),
                    suffixIcon: const Icon(Iconsax.eye_slash),
                    obscureText: true,
                    validationType: ValidationType.confirmPassword,
                    passwordController: _newPasswordController,
                  ),
                  const SizedBox(height: 32),
                  CustomButton(
                    btnName: l10n.save,
                    buttonColor: AppThemeData.primary200,
                    textColor: Colors.white,
                    isLoading: state is PasswordUpdating,
                    ontap: () {
                      // Check if controllers are empty before validating form logic
                      if (_formKey.currentState!.validate()) {
                        context.read<ProfileCubit>().updatePassword(
                              _currentPasswordController.text,
                              _newPasswordController.text,
                              _confirmPasswordController.text,
                            );
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
