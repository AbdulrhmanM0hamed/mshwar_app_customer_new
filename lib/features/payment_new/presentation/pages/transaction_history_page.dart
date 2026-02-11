import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../../../core/themes/constant_colors.dart';
import '../../../../core/utils/dark_theme_provider.dart';
import '../../../../core/utils/Preferences.dart';
import '../../../../generated/app_localizations.dart';
import '../../../../common/widget/custom_text.dart';
import '../cubit/wallet/wallet_cubit.dart';
import '../cubit/wallet/wallet_state.dart';
import '../widgets/transaction_list_item.dart';

class TransactionHistoryPage extends StatefulWidget {
  const TransactionHistoryPage({super.key});

  @override
  State<TransactionHistoryPage> createState() => _TransactionHistoryPageState();
}

class _TransactionHistoryPageState extends State<TransactionHistoryPage> {
  final ScrollController _scrollController = ScrollController();
  static const int _pageSize = 20;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadTransactions() {
    final userId = Preferences.getInt(Preferences.userId).toString();
    context.read<WalletCubit>().loadTransactionHistory(
          userId,
          limit: _pageSize,
        );
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      final state = context.read<WalletCubit>().state;
      if (state is TransactionHistoryLoaded && state.hasMore) {
        final userId = Preferences.getInt(Preferences.userId).toString();
        context.read<WalletCubit>().loadMoreTransactions(
              userId,
              state.transactions.length,
              _pageSize,
            );
      }
    }
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
          text: l10n.transactionHistory,
          size: 20,
          weight: FontWeight.bold,
          color: isDarkMode
              ? AppThemeData.grey900Dark
              : AppThemeData.grey900,
        ),
      ),
      body: BlocBuilder<WalletCubit, WalletState>(
        builder: (context, state) {
          if (state is TransactionHistoryLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is TransactionHistoryError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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

          if (state is TransactionHistoryLoaded) {
            final transactions = state.transactions;

            if (transactions.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.receipt_long_outlined,
                      size: 64,
                      color: isDarkMode
                          ? AppThemeData.grey500Dark
                          : AppThemeData.grey500,
                    ),
                    const SizedBox(height: 16),
                    CustomText(
                      text: 'No transactions yet',
                      size: 16,
                      color: isDarkMode
                          ? AppThemeData.grey500Dark
                          : AppThemeData.grey500,
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                _loadTransactions();
              },
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: transactions.length + (state.hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == transactions.length) {
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  return TransactionListItem(
                    transaction: transactions[index],
                  );
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
