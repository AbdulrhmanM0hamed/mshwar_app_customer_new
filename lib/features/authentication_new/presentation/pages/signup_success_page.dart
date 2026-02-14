import 'package:cabme/core/themes/constant_colors.dart';
import 'package:cabme/common/widget/custom_text.dart';
import 'package:cabme/common/widget/button.dart';
import 'package:cabme/common/screens/botton_nav_bar.dart';
import 'package:cabme/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:cabme/features/settings_new/presentation/cubit/settings/settings_cubit.dart';
import 'package:cabme/service_locator.dart';
import 'dart:developer';

class SignupSuccessPage extends StatefulWidget {
  const SignupSuccessPage({super.key});

  @override
  State<SignupSuccessPage> createState() => _SignupSuccessPageState();
}

class _SignupSuccessPageState extends State<SignupSuccessPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppThemeData.primary200,
              AppThemeData.primary200.withValues(alpha: 0.8),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Decorative Circles
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
            Positioned(
              top: 150,
              left: -80,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.03),
                ),
              ),
            ),

            // Main Content
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(flex: 2),

                    // Success Icon with Animation
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 30,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Icon(
                          Iconsax.tick_circle5,
                          size: 80,
                          color: AppThemeData.primary200,
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Success Text
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Column(
                        children: [
                          CustomText(
                            text: l10n.accountCreatedSuccessfully,
                            size: 28,
                            color: Colors.white,
                            weight: FontWeight.bold,
                            letterSpacing: -0.5,
                            height: 1.3,
                            align: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          CustomText(
                            text: l10n.signupSuccessSubtitle,
                            size: 15,
                            color: Colors.white.withValues(alpha: 0.9),
                            height: 1.6,
                            align: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    const Spacer(flex: 2),

                    // Continue Button
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: CustomButton(
                        btnName: l10n.startExploring,
                        ontap: () => _preloadAndNavigate(context),
                        buttonColor: Colors.white,
                        textColor: AppThemeData.primary200,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Skip for now
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: TextButton(
                        onPressed: () => _preloadAndNavigate(context),
                        child: CustomText(
                          text: l10n.skipForNow,
                          size: 14,
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      ),
                    ),

                    const Spacer(flex: 1),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _preloadAndNavigate(BuildContext context) async {
    try {
      final settingsCubit = getIt<SettingsCubit>();
      await settingsCubit.loadSettings();

      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => BottomNavBar()),
          (route) => false,
        );
      }
    } catch (e) {
      log('Error preloading data: $e');
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => BottomNavBar()),
          (route) => false,
        );
      }
    }
  }
}
