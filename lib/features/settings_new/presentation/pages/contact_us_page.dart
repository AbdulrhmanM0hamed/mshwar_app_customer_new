import 'package:cabme/common/widget/button.dart';
import 'package:cabme/common/widget/custom_app_bar.dart';
import 'package:cabme/common/widget/text_field.dart';
import 'package:cabme/core/themes/constant_colors.dart';
import 'package:cabme/core/utils/dark_theme_provider.dart';
import 'package:cabme/features/authentication_new/data/models/user_model.dart';
import 'package:cabme/features/settings_new/presentation/cubit/contact_us/contact_us_cubit.dart';
import 'package:cabme/features/settings_new/presentation/cubit/contact_us/contact_us_state.dart';
// Optional: to prepopulate data
import 'package:cabme/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

import '../../../../core/constant/constant.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.I<ContactUsCubit>(),
      child: const ContactUsView(),
    );
  }
}

class ContactUsView extends StatefulWidget {
  const ContactUsView({super.key});

  @override
  State<ContactUsView> createState() => _ContactUsViewState();
}

class _ContactUsViewState extends State<ContactUsView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _subjectController;
  late TextEditingController _messageController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _subjectController = TextEditingController();
    _messageController = TextEditingController();

    _prefillUserData();
  }

  void _prefillUserData() async {
    try {
      final UserModel? user = Constant.getUserData();
      if (user != null) {
        setState(() {
          _nameController.text = "${user.firstName} ${user.lastName}".trim();
          _emailController.text = user.email;
        });
      }
    } catch (e) {
      // User might be guest or data not available
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
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
        title: l10n.contactUs,
        showBackButton: true,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: BlocConsumer<ContactUsCubit, ContactUsState>(
        listener: (context, state) {
          if (state is ContactUsSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.messageSentSuccessfully),
                backgroundColor: AppThemeData.success300,
              ),
            );
            Navigator.pop(context);
          } else if (state is ContactUsError) {
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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.contactUsDetails, // e.g., "We'd love to hear from you..."
                    style: TextStyle(
                      color: isDarkMode
                          ? AppThemeData.grey400Dark
                          : AppThemeData.grey500,
                      fontSize: 14,
                      fontFamily:
                          'Cairo', // Assuming Cairo font based on other files
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  CustomTextField(
                    controller: _nameController,
                    text: l10n.name,
                    prefixIcon: const Icon(Iconsax.user),
                    validationType: ValidationType.name,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _emailController,
                    text: l10n.email,
                    prefixIcon: const Icon(Iconsax.sms),
                    validationType: ValidationType.email,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _subjectController,
                    text: l10n.subject,
                    prefixIcon: const Icon(Iconsax.note_text),
                    validationType:
                        ValidationType.required, // Or create subject validation
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _messageController,
                    text: l10n.message,
                    prefixIcon: const Icon(Iconsax.message_text),
                    maxLines: 5,
                    validationType:
                        ValidationType.required, // Or message validation
                  ),
                  const SizedBox(height: 32),
                  CustomButton(
                    btnName: l10n.send,
                    buttonColor: AppThemeData.primary200,
                    textColor: Colors.white,
                    isLoading: state is ContactUsLoading,
                    ontap: () {
                      if (_formKey.currentState!.validate()) {
                        context.read<ContactUsCubit>().submitContactUs(
                              name: _nameController.text,
                              email: _emailController.text,
                              subject: _subjectController.text,
                              message: _messageController.text,
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
