import 'package:cabme/common/widget/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:cabme/features/home_new/presentation/pages/home_page.dart';
import 'package:cabme/features/ride_new/presentation/pages/ride_history_page.dart';
import 'package:cabme/features/payment_new/presentation/pages/wallet_page.dart';
import 'package:cabme/features/plans_new/presentation/pages/subscription_list_page.dart';
import 'package:cabme/features/plans_new/presentation/pages/package_list_page.dart';
import 'package:cabme/features/settings_new/presentation/pages/settings_page.dart';
import 'package:cabme/core/themes/constant_colors.dart';
import 'package:cabme/core/utils/dark_theme_provider.dart';
import 'package:cabme/generated/app_localizations.dart';
import 'package:provider/provider.dart';

class BottomNavBar extends StatefulWidget {
  final int initialIndex;
  const BottomNavBar({super.key, this.initialIndex = 0});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  late int _currentIndex;

  final List<Widget> _screens = [
    const HomePage(),
    const RideHistoryPage(),
    const WalletPage(),
    const SubscriptionListPage(),
    const PackageListPage(),
    const SettingsPage(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _updateIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final isDarkMode = themeChange.getThem();
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDarkMode ? AppThemeData.surface50Dark : Colors.white,
          border: Border(
            top: BorderSide(
              color: isDarkMode
                  ? AppThemeData.grey800Dark.withAlpha(76)
                  : AppThemeData.grey200.withAlpha(127),
              width: 0.5,
            ),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  context: context,
                  icon: Iconsax.home,
                  activeIcon: Iconsax.home,
                  label: l10n.home,
                  index: 0,
                  currentIndex: _currentIndex,
                  onTap: () => _updateIndex(0),
                  isDarkMode: isDarkMode,
                ),
                _buildNavItem(
                  context: context,
                  icon: Iconsax.car,
                  activeIcon: Iconsax.car,
                  label: l10n.ridesTitle,
                  index: 1,
                  currentIndex: _currentIndex,
                  onTap: () => _updateIndex(1),
                  isDarkMode: isDarkMode,
                ),
                _buildNavItem(
                  context: context,
                  icon: Iconsax.wallet_2,
                  activeIcon: Iconsax.wallet_2,
                  label: l10n.wallet,
                  index: 2,
                  currentIndex: _currentIndex,
                  onTap: () => _updateIndex(2),
                  isDarkMode: isDarkMode,
                ),
                _buildNavItem(
                  context: context,
                  icon: Iconsax.calendar_1,
                  activeIcon: Iconsax.calendar_1,
                  label: l10n.subscriptions,
                  index: 3,
                  currentIndex: _currentIndex,
                  onTap: () => _updateIndex(3),
                  isDarkMode: isDarkMode,
                ),
                _buildNavItem(
                  context: context,
                  icon: Iconsax.box,
                  activeIcon: Iconsax.box,
                  label: l10n.packages,
                  index: 4,
                  currentIndex: _currentIndex,
                  onTap: () => _updateIndex(4),
                  isDarkMode: isDarkMode,
                ),
                _buildNavItem(
                  context: context,
                  icon: Iconsax.setting_2,
                  activeIcon: Iconsax.setting_2,
                  label: l10n.settingsTitle,
                  index: 5,
                  currentIndex: _currentIndex,
                  onTap: () => _updateIndex(5),
                  isDarkMode: isDarkMode,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
    required int currentIndex,
    required VoidCallback onTap,
    required bool isDarkMode,
  }) {
    final isSelected = currentIndex == index;

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  isSelected ? activeIcon : icon,
                  size: 22,
                  color: isSelected
                      ? AppThemeData.primary200
                      : (isDarkMode
                          ? AppThemeData.grey400Dark
                          : AppThemeData.grey500),
                ),
                const SizedBox(height: 2),
                SizedBox(
                  width: double.infinity,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Invisible bold text to reserve space
                      Opacity(
                        opacity: 0,
                        child: CustomText(
                          text: label,
                          size: 11,
                          weight: FontWeight.w600,
                          align: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      // Visible text with current weight
                      CustomText(
                        text: label,
                        size: 11,
                        weight: isSelected ? FontWeight.w600 : FontWeight.w400,
                        color: isSelected
                            ? AppThemeData.primary200
                            : (isDarkMode
                                ? AppThemeData.grey400Dark
                                : AppThemeData.grey500),
                        align: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
