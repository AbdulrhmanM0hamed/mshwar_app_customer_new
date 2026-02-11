import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../../../core/themes/constant_colors.dart';
import '../../../../core/utils/dark_theme_provider.dart';
import '../../../../core/utils/Preferences.dart';
import '../../../../generated/app_localizations.dart';
import '../../../../common/widget/custom_text.dart';
import '../../../../common/widget/button.dart';
import '../cubit/wallet/wallet_cubit.dart';
import '../cubit/wallet/wallet_state.dart';
import '../widgets/wallet_balance_card.dart';
import '../widgets/transaction_list_item.dart';
import 'add_funds_page.dart';
import 'transaction_history_page.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  @override
  void initState() {
    super.initState();
    _loadWallet();
  }

  Future<void> _loadWallet() async {
    final userId = Preferences.getInt(Preferences.userId).toString();
    context.read<WalletCubit>().loadWalletBalance(userId);
    context.read<WalletCubit>().loadTransactionHistory(userId, limit: 5);
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final l10n = AppLocalizations.of(context)!;
    final isDarkMode = themeChange.getThem();

    return Scaffold(
      backgroundColor: isDarkMode
          ? AppThemeData.surface50Dark
          : AppThemeData.surface50,
      appBar: AppBar(
        backgroundColor: isDarkMode
            ? AppThemeData.surface50Dark
            : AppThemeData.surface50,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDarkMode
                ? AppThemeData.grey900Dark
                : AppThemeData.grey900,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: CustomText(
          text: l10n.wallet,
          size: 20,
          weight: FontWeight.bold,
          color: isDarkMode
              ? AppThemeData.grey900Dark
              : AppThemeData.grey900,
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: isDarkMode
                  ? AppThemeData.grey900Dark
                  : AppThemeData.grey900,
            ),
            onPressed: _loadWallet,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadWallet,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Wallet Balance Card
              BlocBuilder<WalletCubit, WalletState>(
                builder: (context, state) {
                  if (state is WalletLoading) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  if (state is WalletError) {
                    return Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: AppThemeData.error200,
                          ),
                          const SizedBox(height: 16),
                          CustomText(
                            text: state.message,
                            size: 16,
                            color: isDarkMode
                                ? AppThemeData.grey500Dark
                                : AppThemeData.grey500,
                          ),
                        ],
                      ),
                    );
                  }

                  if (state is WalletLoaded) {
                    return WalletBalanceCard(wallet: state.wallet);
                  }

                  return const SizedBox.shrink();
                },
              ),

              const SizedBox(height: 24),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      btnName: l10n.addFunds,
                      ontap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddFundsPage(),
                          ),
                        );
                        if (result == true) {
                          _loadWallet();
                        }
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Recent Transactions Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: 'Recent Transactions',
                    size: 18,
                    weight: FontWeight.bold,
                    color: isDarkMode
                        ? AppThemeData.grey900Dark
                        : AppThemeData.grey900,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TransactionHistoryPage(),
                        ),
                      );
                    },
                    child: CustomText(
                      text: 'View All',
                      size: 14,
                      color: AppThemeData.primary200,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Recent Transactions List
              BlocBuilder<WalletCubit, WalletState>(
                builder: (context, state) {
                  if (state is TransactionHistoryLoading) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  if (state is TransactionHistoryError) {
                    return Center(
                      child: CustomText(
                        text: state.message,
                        size: 14,
                        color: isDarkMode
                            ? AppThemeData.grey500Dark
                            : AppThemeData.grey500,
                      ),
                    );
                  }

                  if (state is TransactionHistoryLoaded) {
                    final transactions = state.transactions;

                    if (transactions.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: CustomText(
                            text: 'No transactions yet',
                            size: 14,
                            color: isDarkMode
                                ? AppThemeData.grey500Dark
                                : AppThemeData.grey500,
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: transactions.length,
                      itemBuilder: (context, index) {
                        return TransactionListItem(
                          transaction: transactions[index],
                        );
                      },
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
