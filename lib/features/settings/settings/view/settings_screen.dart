import 'dart:developer';
import 'package:cabme/common/widget/my_custom_dialog.dart';
import 'package:cabme/common/widget/light_bordered_card.dart';
import 'package:cabme/common/widget/custom_app_bar.dart';
import 'package:cabme/core/themes/constant_colors.dart';
import 'package:cabme/core/utils/Preferences.dart';
import 'package:cabme/core/utils/dark_theme_provider.dart';
import 'package:cabme/features/authentication_new/presentation/pages/login_page.dart';
import 'package:cabme/features/home/controller/dash_board_controller.dart';
import 'package:cabme/features/settings/localization/view/localization_screen.dart';
import 'package:cabme/features/settings/profile/view/change_password_screen.dart';
import 'package:cabme/features/settings/profile/view/my_profile_screen.dart';
import 'package:cabme/features/settings/privacy_policy/view/privacy_policy_screen.dart';
import 'package:cabme/features/settings/terms_service/view/terms_of_service_screen.dart';
import 'package:cabme/features/settings/contact_us/view/contact_us_screen.dart';
import 'package:cabme/features/ride/ride/view/normal_rides_screen.dart';
import 'package:cabme/features/ride/ride/view/scheduled_rides_screen.dart';
import 'package:cabme/features/payment/wallet/view/wallet_screen.dart';
import 'package:cabme/features/settings/notifications/view/notification_screen.dart';
import 'package:cabme/generated/app_localizations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:get/get.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});

  final dashboardController = Get.put(DashBoardController());
  final InAppReview inAppReview = InAppReview.instance;

  // ===== UI tokens (مودرن وموحّد) =====
  static const double _pagePadding = 16;
  static const double _cardRadius = 18;
  static const double _tileVPadding = 2; // يقلل الإرتفاع
  static const double _tileHPadding = 6;
  static const double _iconBox = 38;
  static const double _iconSize = 20;
  static const double _titleSize = 15;
  static const double _sectionSize = 12;

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final isDarkMode = themeChange.getThem();
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor:
          isDarkMode ? AppThemeData.surface50Dark : AppThemeData.surface50,
      appBar: CustomAppBar(
        title: l10n.settingsTitle,
        showBackButton: true,
        onBackPressed: () => Get.back(),
      ),
      body: GetBuilder<DashBoardController>(
        builder: (controller) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(_pagePadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),

                // Profile Header (أشيك + أصغر)
                _buildUserProfile(context, controller, isDarkMode),

                const SizedBox(height: 14),

                _buildSectionHeader(l10n.rideManagement, isDarkMode),
                const SizedBox(height: 8),
                _buildCard(
                  isDarkMode: isDarkMode,
                  child: Column(
                    children: [
                      _buildMenuItem(
                        context: context,
                        title: l10n.allRides,
                        icon: Iconsax.driving,
                        isDarkMode: isDarkMode,
                        onTap: () => Get.to(() => const NewRideScreen()),
                      ),
                      _buildDivider(isDarkMode),
                      _buildMenuItem(
                        context: context,
                        title: l10n.scheduledRides,
                        icon: Iconsax.calendar,
                        isDarkMode: isDarkMode,
                        onTap: () => Get.to(() => const ScheduledRidesScreen()),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                _buildSectionHeader(l10n.accountPayments, isDarkMode),
                const SizedBox(height: 8),
                _buildCard(
                  isDarkMode: isDarkMode,
                  child: Column(
                    children: [
                      _buildMenuItem(
                        context: context,
                        title: l10n.wallet,
                        icon: Iconsax.wallet_3,
                        isDarkMode: isDarkMode,
                        onTap: () => Get.to(() => WalletScreen()),
                      ),
                      _buildDivider(isDarkMode),
                      _buildMenuItem(
                        context: context,
                        title: l10n.myProfile,
                        icon: Iconsax.profile_circle,
                        isDarkMode: isDarkMode,
                        onTap: () => Get.to(() => MyProfileScreen()),
                      ),
                      _buildDivider(isDarkMode),
                      _buildMenuItem(
                        context: context,
                        title: l10n.changePassword,
                        icon: Iconsax.lock,
                        isDarkMode: isDarkMode,
                        onTap: () => Get.to(() => ChangePasswordScreen()),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                _buildSectionHeader(l10n.appSettings, isDarkMode),
                const SizedBox(height: 8),
                _buildCard(
                  isDarkMode: isDarkMode,
                  child: Column(
                    children: [
                      _buildMenuItem(
                        context: context,
                        title: l10n.notifications,
                        icon: Iconsax.notification,
                        isDarkMode: isDarkMode,
                        onTap: () => Get.to(() => const NotificationScreen()),
                      ),
                      _buildDivider(isDarkMode),
                      _buildMenuItem(
                        context: context,
                        title: l10n.changeLanguage,
                        icon: Iconsax.language_square,
                        isDarkMode: isDarkMode,
                        onTap: () => Get.to(
                          () => const LocalizationScreens(intentType: "dashBoard"),
                        ),
                      ),
                      _buildDivider(isDarkMode),
                      _buildDarkModeToggle(context, isDarkMode, themeChange, l10n),
                      _buildDivider(isDarkMode),
                      _buildMenuItem(
                        context: context,
                        title: l10n.termsConditions,
                        icon: Iconsax.document_text,
                        isDarkMode: isDarkMode,
                        onTap: () => Get.to(() => const TermsOfServiceScreen()),
                      ),
                      _buildDivider(isDarkMode),
                      _buildMenuItem(
                        context: context,
                        title: l10n.privacyPolicy,
                        icon: Iconsax.shield_security,
                        isDarkMode: isDarkMode,
                        onTap: () => Get.to(() => const PrivacyPolicyScreen()),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                _buildSectionHeader(l10n.feedbackSupport, isDarkMode),
                const SizedBox(height: 8),
                _buildCard(
                  isDarkMode: isDarkMode,
                  child: Column(
                    children: [
                      _buildMenuItem(
                        context: context,
                        title: l10n.contactUs,
                        icon: Iconsax.message,
                        isDarkMode: isDarkMode,
                        onTap: () => Get.to(() => const ContactUsScreen()),
                      ),
                      _buildDivider(isDarkMode),
                      _buildMenuItem(
                        context: context,
                        title: l10n.rateTheApp,
                        icon: Iconsax.star_1,
                        isDarkMode: isDarkMode,
                        onTap: () async {
                          try {
                            if (await inAppReview.isAvailable()) {
                              inAppReview.requestReview();
                            } else {
                              log(":::::::::InAppReview:::::::::::");
                              inAppReview.openStoreListing();
                            }
                          } catch (e) {
                            log("Error triggering in-app review: $e");
                          }
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                _buildCard(
                  isDarkMode: isDarkMode,
                  child: _buildMenuItem(
                    context: context,
                    title: l10n.logOut,
                    icon: Iconsax.logout_1,
                    isDarkMode: isDarkMode,
                    textColor: AppThemeData.error200,
                    onTap: () => _showLogoutDialog(context, l10n),
                  ),
                ),

                const SizedBox(height: 22),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCard({required bool isDarkMode, required Widget child}) {
    // نفس LightBorderedCard لكن بستايل أحسن وتناسق في الحواف + padding
    return LightBorderedCard(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_cardRadius),
        child: child,
      ),
    );
  }

  Widget _buildUserProfile(
      BuildContext context, DashBoardController controller, bool isDarkMode) {
    final name =
        "${controller.userModel?.data?.prenom ?? ''} ${controller.userModel?.data?.nom ?? ''}"
            .trim();
    final contact = (controller.userModel?.data?.email != null &&
            controller.userModel!.data!.email!.isNotEmpty &&
            controller.userModel!.data!.email != 'null')
        ? controller.userModel!.data!.email!
        : (controller.userModel?.data?.phone != null &&
                controller.userModel!.data!.phone!.isNotEmpty &&
                controller.userModel!.data!.phone != 'null')
            ? controller.userModel!.data!.phone!
            : '';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_cardRadius),
        color: isDarkMode ? AppThemeData.grey800 : Colors.white,
        border: Border.all(
          color: isDarkMode ? AppThemeData.grey200Dark : AppThemeData.grey200,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: _buildProfileImage(controller, isDarkMode),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name.isEmpty ? '—' : name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16.5,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Cairo',
                    color: isDarkMode
                        ? AppThemeData.grey900Dark
                        : AppThemeData.grey900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  contact,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontFamily: 'Cairo',
                    color: isDarkMode
                        ? AppThemeData.grey400Dark
                        : AppThemeData.grey500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          InkWell(
            onTap: () => Get.to(() => MyProfileScreen()),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppThemeData.primary200.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppThemeData.primary200.withValues(alpha: 0.20),
                ),
              ),
              child: Icon(
                Iconsax.edit_2,
                size: 18,
                color: AppThemeData.primary200,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 2),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: isDarkMode ? AppThemeData.grey400Dark : AppThemeData.grey500,
          fontSize: _sectionSize,
          fontWeight: FontWeight.w700,
          fontFamily: 'Cairo',
          letterSpacing: 0.7,
        ),
      ),
    );
  }

  Widget _buildDivider(bool isDarkMode) {
    return Divider(
      height: 1,
      thickness: 0.6,
      indent: 52,
      endIndent: 6,
      color: isDarkMode ? AppThemeData.grey200Dark : AppThemeData.grey200,
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required String title,
    required IconData icon,
    required bool isDarkMode,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    final mainText = textColor ??
        (isDarkMode ? AppThemeData.grey900Dark : AppThemeData.grey900);
    final iconColor = textColor ??
        (isDarkMode ? AppThemeData.grey400Dark : AppThemeData.grey500);

    return ListTile(
      onTap: onTap,
      dense: true,
      visualDensity: VisualDensity.compact, // يقلّل الحجم بشكل أنيق
      contentPadding: const EdgeInsets.symmetric(
        horizontal: _tileHPadding,
        vertical: _tileVPadding,
      ),
      leading: Container(
        height: _iconBox,
        width: _iconBox,
        decoration: BoxDecoration(
          color: (textColor ?? AppThemeData.primary200).withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                (textColor ?? AppThemeData.primary200).withValues(alpha: 0.18),
          ),
        ),
        child: Icon(icon, size: _iconSize, color: iconColor),
      ),
      title: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: _titleSize,
          fontWeight: FontWeight.w600,
          fontFamily: 'Cairo',
          color: mainText,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: isDarkMode ? AppThemeData.grey300Dark : AppThemeData.grey400,
      ),
    );
  }

  Widget _buildDarkModeToggle(
      BuildContext context, bool isDarkMode, DarkThemeProvider themeChange, AppLocalizations l10n) {
    return ListTile(
      dense: true,
      visualDensity: VisualDensity.compact,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: _tileHPadding,
        vertical: _tileVPadding,
      ),
      leading: Container(
        height: _iconBox,
        width: _iconBox,
        decoration: BoxDecoration(
          color: AppThemeData.primary200.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppThemeData.primary200.withValues(alpha: 0.18),
          ),
        ),
        child: Icon(
          isDarkMode ? Iconsax.moon : Iconsax.sun_1,
          size: _iconSize,
          color: isDarkMode ? AppThemeData.grey400Dark : AppThemeData.grey500,
        ),
      ),
      title: Text(
        l10n.darkMode,
        style: TextStyle(
          fontSize: _titleSize,
          fontWeight: FontWeight.w600,
          fontFamily: 'Cairo',
          color: isDarkMode ? AppThemeData.grey900Dark : AppThemeData.grey900,
        ),
      ),
      trailing: Transform.scale(
        scale: 0.92, // تصغير بسيط بدل الضخامة
        child: Switch(
          value: isDarkMode,
          activeThumbColor: AppThemeData.primary200,
          onChanged: (value) {
            themeChange.darkTheme = value ? 0 : 1;
          },
        ),
      ),
    );
  }

  Widget _buildProfileImage(DashBoardController controller, bool isDarkMode) {
    final photoPath = controller.userModel?.data?.photoPath?.toString() ?? '';

    if (photoPath.isEmpty || photoPath == 'null') {
      return Container(
        height: 54,
        width: 54,
        decoration: BoxDecoration(
          color: isDarkMode ? AppThemeData.grey800 : AppThemeData.grey200,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(
          Iconsax.user,
          size: 26,
          color: isDarkMode ? AppThemeData.grey400Dark : AppThemeData.grey400,
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: photoPath,
      height: 54,
      width: 54,
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(
        height: 54,
        width: 54,
        decoration: BoxDecoration(
          color: isDarkMode ? AppThemeData.grey800 : AppThemeData.grey200,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: SizedBox(
            height: 18,
            width: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppThemeData.primary200,
            ),
          ),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        height: 54,
        width: 54,
        decoration: BoxDecoration(
          color: isDarkMode ? AppThemeData.grey200Dark : AppThemeData.grey200,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(
          Iconsax.user,
          size: 26,
          color: isDarkMode ? AppThemeData.grey400Dark : AppThemeData.grey400,
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, AppLocalizations l10n) {
    MyCustomDialog.show(
      context: context,
      title: l10n.logOut,
      message: l10n.areYouSureLogout,
      confirmText: l10n.logOut,
      cancelText: l10n.cancel,
      confirmButtonColor: AppThemeData.error200,
      onConfirm: () {
        Preferences.clearKeyData(Preferences.isLogin);
        Preferences.clearKeyData(Preferences.user);
        Preferences.clearKeyData(Preferences.userId);
        Get.offAll(() => const LoginPage());
      },
    );
  }
}
