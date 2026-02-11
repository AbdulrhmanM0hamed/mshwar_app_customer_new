import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import '../../../../common/widget/custom_app_bar.dart';
import '../../../../common/widget/custom_text.dart';
import '../../../../core/themes/constant_colors.dart';
import '../../../../core/utils/dark_theme_provider.dart';
import '../../../../generated/app_localizations.dart';
import '../cubit/subscription/subscription_cubit.dart';
import '../cubit/subscription/subscription_state.dart';
import '../widgets/subscription_card.dart';

class SubscriptionListPage extends StatelessWidget {
  final bool showBackButton;

  const SubscriptionListPage({super.key, this.showBackButton = true});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (context) => GetIt.instance<SubscriptionCubit>()
        ..loadSettings()
        ..loadUserSubscriptions(),
      child: Scaffold(
        backgroundColor: themeChange.getThem()
            ? AppThemeData.surface50Dark
            : AppThemeData.surface50,
        appBar: CustomAppBar(
          title: l10n.subscriptions,
          showBackButton: showBackButton,
          actions: [
            BlocBuilder<SubscriptionCubit, SubscriptionState>(
              builder: (context, state) {
                return IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  onPressed: () {
                    context.read<SubscriptionCubit>().loadUserSubscriptions();
                  },
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<SubscriptionCubit, SubscriptionState>(
          builder: (context, state) {
            if (state is SubscriptionSettingsLoading || state is SubscriptionsLoading) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (state is SubscriptionSettingsLoaded) {
              if (!state.settings.isAvailable) {
                return _buildUnavailableView(context, themeChange);
              }
            }

            if (state is SubscriptionsLoaded) {
              if (state.subscriptions.isEmpty) {
                return _buildEmptyState(context, themeChange);
              }

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<SubscriptionCubit>().loadUserSubscriptions();
                },
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.subscriptions.length,
                  itemBuilder: (context, index) {
                    final subscription = state.subscriptions[index];
                    return SubscriptionCard(subscription: subscription);
                  },
                ),
              );
            }

            if (state is SubscriptionsError) {
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

            return const SizedBox();
          },
        ),
        floatingActionButton: BlocBuilder<SubscriptionCubit, SubscriptionState>(
          builder: (context, state) {
            if (state is SubscriptionSettingsLoaded && state.settings.isAvailable) {
              return FloatingActionButton(
                onPressed: () {
                  // TODO: Navigate to create subscription page
                },
                backgroundColor: AppThemeData.primary200,
                child: const Icon(Icons.add, color: Colors.white),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, DarkThemeProvider themeChange) {
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.event_repeat,
              size: 80,
              color: themeChange.getThem()
                  ? AppThemeData.grey400Dark
                  : AppThemeData.grey300,
            ),
            const SizedBox(height: 16),
            CustomText(
              text: l10n.noSubscriptionsYet,
              size: 20,
              weight: FontWeight.bold,
              color: themeChange.getThem() ? Colors.white70 : Colors.black54,
              align: TextAlign.center,
            ),
            const SizedBox(height: 8),
            CustomText(
              text: l10n.noSubscriptionsYetDesc,
              align: TextAlign.center,
              size: 14,
              color: themeChange.getThem() ? Colors.white54 : Colors.black45,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUnavailableView(BuildContext context, DarkThemeProvider themeChange) {
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.block,
              size: 80,
              color: Colors.orange.withValues(alpha: 0.7),
            ),
            const SizedBox(height: 16),
            CustomText(
              text: l10n.subscriptionsNotAvailable,
              size: 20,
              weight: FontWeight.bold,
              color: themeChange.getThem() ? Colors.white70 : Colors.black54,
            ),
            const SizedBox(height: 8),
            CustomText(
              text: l10n.subscriptionsNotAvailableDesc,
              align: TextAlign.center,
              size: 14,
              color: themeChange.getThem() ? Colors.white54 : Colors.black45,
            ),
          ],
        ),
      ),
    );
  }
}
