import 'package:cabme/common/widget/button.dart';
import 'package:cabme/common/widget/custom_app_bar.dart';
import 'package:cabme/common/widget/text_field.dart';
import 'package:cabme/core/themes/constant_colors.dart';
import 'package:cabme/core/utils/dark_theme_provider.dart';
import 'package:cabme/features/authentication/model/user_model.dart';
import 'package:cabme/features/settings_new/presentation/cubit/profile/profile_cubit.dart';
import 'package:cabme/features/settings_new/presentation/cubit/profile/profile_state.dart';
import 'package:cabme/generated/app_localizations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:cabme/common/widget/my_custom_dialog.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.I<ProfileCubit>()..loadProfile(),
      child: const ProfileView(),
    );
  }
}

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  File? _image;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
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
        title: l10n.myProfile,
        showBackButton: true,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.profileUpdatedSuccessfully),
                backgroundColor: AppThemeData.success300,
              ),
            );
          } else if (state is AccountDeleted) {
            // Should logout
            Navigator.of(context).popUntil((route) => route.isFirst);
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
          if (state is ProfileLoading && state is! ProfileUpdating) {
            return const Center(child: CircularProgressIndicator());
          }

          UserModel? user;
          if (state is ProfileLoaded) {
            user = state.user;
          } else if (state is ProfileUpdated) {
            user = state.user;
          }

          if (user != null) {
            // Bind only if controllers are empty to avoid overwriting user input
            if (_firstNameController.text.isEmpty) {
              _firstNameController.text = user.data?.prenom ?? '';
              _lastNameController.text = user.data?.nom ?? '';
              _emailController.text = user.data?.email ?? '';
              _phoneController.text = user.data?.phone ?? '';
            }
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Center(
                    child: Stack(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDarkMode
                                ? AppThemeData.grey800
                                : AppThemeData.grey200,
                            image: _image != null
                                ? DecorationImage(
                                    image: FileImage(_image!),
                                    fit: BoxFit.cover,
                                  )
                                : (user?.data?.photoPath != null &&
                                        user!.data!.photoPath!.isNotEmpty)
                                    ? DecorationImage(
                                        image: NetworkImage(
                                            user.data!.photoPath!),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                          ),
                          child: (_image == null &&
                                  (user?.data?.photoPath == null ||
                                      user!.data!.photoPath!.isEmpty))
                              ? Icon(
                                  Iconsax.user,
                                  size: 40,
                                  color: isDarkMode
                                      ? AppThemeData.grey400Dark
                                      : AppThemeData.grey400,
                                )
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: InkWell(
                            onTap: _pickImage,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppThemeData.primary200,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isDarkMode
                                      ? AppThemeData.surface50Dark
                                      : AppThemeData.surface50,
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Iconsax.camera,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  CustomTextField(
                    controller: _firstNameController,
                    hintText: l10n.firstName,
                    prefixIcon: const Icon(Iconsax.user),
                    isDarkMode: isDarkMode,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _lastNameController,
                    hintText: l10n.lastName,
                    prefixIcon: const Icon(Iconsax.user),
                    isDarkMode: isDarkMode,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _phoneController,
                    hintText: l10n.phoneNumber,
                    prefixIcon: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Iconsax.call,
                            size: 18,
                            color: isDarkMode
                                ? AppThemeData.grey400Dark
                                : AppThemeData.grey500,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "+965",
                            style: TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w700,
                              color: isDarkMode
                                  ? AppThemeData.grey900Dark
                                  : AppThemeData.grey900,
                            ),
                          ),
                          const SizedBox(width: 4),
                        ],
                      ),
                    ),
                    isDarkMode: isDarkMode,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _emailController,
                    hintText: l10n.email,
                    prefixIcon: const Icon(Iconsax.sms),
                    isDarkMode: isDarkMode,
                    keyboardType: TextInputType.emailAddress,
                    readOnly: true,
                  ),
                  const SizedBox(height: 32),
                  CustomButton(
                    btnName: l10n.save,
                    buttonColor: AppThemeData.primary200,
                    textColor: Colors.white,
                    isLoading: state is ProfileUpdating,
                    ontap: () {
                      if (_formKey.currentState!.validate()) {
                        context.read<ProfileCubit>().updateProfile(
                              firstName: _firstNameController.text,
                              lastName: _lastNameController.text,
                              phone: _phoneController.text,
                              email: _emailController.text,
                              image: _image,
                            );
                      }
                    },
                  ),
                  const SizedBox(height: 24),
                  TextButton(
                    onPressed: () => _showDeleteAccountDialog(context, l10n),
                    child: Text(
                      l10n.deleteAccount,
                      style: TextStyle(
                        color: AppThemeData.error200,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
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

  void _showDeleteAccountDialog(BuildContext context, AppLocalizations l10n) {
    MyCustomDialog.show(
      context: context,
      title: l10n.deleteAccount,
      message: l10n.areYouSureDeleteAccount,
      confirmText: l10n.delete,
      cancelText: l10n.cancel,
      confirmButtonColor: AppThemeData.error200,
      onConfirm: () {
        context.read<ProfileCubit>().deleteAccount();
      },
    );
  }
}
