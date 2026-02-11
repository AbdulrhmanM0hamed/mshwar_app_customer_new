import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import '../../../../common/widget/custom_app_bar.dart';
import '../../../../common/widget/custom_text.dart';
import '../../../../core/themes/constant_colors.dart';
import '../../../../core/utils/dark_theme_provider.dart';
import '../../../../generated/app_localizations.dart';
import '../../data/models/package_model.dart';
import '../cubit/package/package_cubit.dart';
import '../cubit/package/package_state.dart';
import '../widgets/package_card.dart';
import '../widgets/user_package_card.dart';
import 'purchase_package_page.dart';

class PackageListPage extends StatelessWidget {
  final bool showBackButton;

  const PackageListPage({super.key, this.showBackButton = true});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final isDark = themeChange.getThem();
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (context) => GetIt.instance<PackageCubit>()
        ..loadAvailablePackages()
        ..loadUserPackages(),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: isDark ? AppThemeData.surface50Dark : AppThemeData.surface50,
          appBar: CustomAppBar(
            title: l10n.packages,
            showBackButton: showBackButton,
            actions: [
              BlocBuilder<PackageCubit, PackageState>(
                builder: (context, state) {
                  return IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.white),
                    onPressed: () {
                      context.read<PackageCubit>().loadAvailablePackages();
                      context.read<PackageCubit>().loadUserPackages();
                    },
                  );
                },
              ),
            ],
            bottom: TabBar(
              indicatorColor: Colors.white,
              indicatorWeight: 1.0,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                fontFamily: 'Cairo',
              ),
              tabs: [
                Tab(text: l10n.buyPackages),
                Tab(text: l10n.myPackages),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              _AvailablePackagesTab(),
              _MyPackagesTab(),
            ],
          ),
        ),
      ),
    );
  }
}

class _AvailablePackagesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<PackageCubit, PackageState>(
      builder: (context, state) {
        if (state is PackagesLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is PackagesError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 16),
                  CustomText(
                    text: state.message,
                    size: 16,
                    color: themeChange.getThem() ? Colors.white70 : Colors.black54,
                    align: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        if (state is PackagesLoaded) {
          if (state.packages.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.inventory_2_outlined,
                      size: 80,
                      color: themeChange.getThem()
                          ? AppThemeData.grey400Dark
                          : AppThemeData.grey300,
                    ),
                    const SizedBox(height: 16),
                    CustomText(
                      text: l10n.noPackagesAvailable,
                      size: 20,
                      weight: FontWeight.bold,
                      color: themeChange.getThem()
                          ? AppThemeData.grey400Dark
                          : AppThemeData.grey500,
                      align: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    CustomText(
                      text: l10n.noPackagesAvailableDesc,
                      size: 14,
                      color: themeChange.getThem()
                          ? AppThemeData.grey500Dark
                          : AppThemeData.grey500,
                      align: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<PackageCubit>().loadAvailablePackages();
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.packages.length,
              itemBuilder: (context, index) {
                final package = state.packages[index];
                return PackageCard(
                  package: package,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PurchasePackagePage(package: package),
                      ),
                    );
                  },
                );
              },
            ),
          );
        }

        return const SizedBox();
      },
    );
  }
}

class _MyPackagesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<PackageCubit, PackageState>(
      builder: (context, state) {
        if (state is UserPackagesLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is UserPackagesError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 16),
                  CustomText(
                    text: state.message,
                    size: 16,
                    color: themeChange.getThem() ? Colors.white70 : Colors.black54,
                    align: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        if (state is UserPackagesLoaded) {
          if (state.packages.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_bag_outlined,
                      size: 80,
                      color: themeChange.getThem()
                          ? AppThemeData.grey400Dark
                          : AppThemeData.grey300,
                    ),
                    const SizedBox(height: 16),
                    CustomText(
                      text: l10n.noPackagesPurchased,
                      size: 20,
                      weight: FontWeight.bold,
                      color: themeChange.getThem()
                          ? AppThemeData.grey400Dark
                          : AppThemeData.grey500,
                      align: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    CustomText(
                      text: l10n.noPackagesPurchasedDesc,
                      size: 14,
                      color: themeChange.getThem()
                          ? AppThemeData.grey500Dark
                          : AppThemeData.grey500,
                      align: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<PackageCubit>().loadUserPackages();
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.packages.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _BuyMoreCard(themeChange: themeChange);
                }
                final userPackage = state.packages[index - 1];
                return UserPackageCard(package: userPackage);
              },
            ),
          );
        }

        return const SizedBox();
      },
    );
  }
}

class _BuyMoreCard extends StatelessWidget {
  final DarkThemeProvider themeChange;

  const _BuyMoreCard({required this.themeChange});

  @override
  Widget build(BuildContext context) {
    final isDark = themeChange.getThem();
    final l10n = AppLocalizations.of(context)!;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: AppThemeData.primary200.withValues(alpha: 0.1),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppThemeData.primary200.withValues(alpha: 0.3)),
      ),
      child: InkWell(
        onTap: () => DefaultTabController.of(context).animateTo(0),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppThemeData.primary200.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.add_circle,
                  color: AppThemeData.primary200,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: l10n.buyMorePackages,
                      size: 16,
                      weight: FontWeight.bold,
                      color: AppThemeData.primary200,
                    ),
                    const SizedBox(height: 4),
                    CustomText(
                      text: l10n.buyMorePackagesDesc,
                      size: 12,
                      color: isDark ? AppThemeData.grey400Dark : AppThemeData.grey500,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: AppThemeData.primary200,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
