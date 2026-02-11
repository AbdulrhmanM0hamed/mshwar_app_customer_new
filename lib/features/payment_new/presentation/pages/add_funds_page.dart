import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../../../core/themes/constant_colors.dart';
import '../../../../core/utils/dark_theme_provider.dart';
import '../../../../core/constant/show_toast_dialog.dart';
import '../../../../generated/app_localizations.dart';
import '../../../../common/widget/custom_text.dart';
import '../cubit/wallet/wallet_cubit.dart';
import '../cubit/wallet/wallet_state.dart';
import '../cubit/payment/payment_cubit.dart';
import '../widgets/add_funds_form.dart';
import '../widgets/payment_gateway_selector.dart';
import 'payment_webview_page.dart';

class AddFundsPage extends StatefulWidget {
  const AddFundsPage({super.key});

  @override
  State<AddFundsPage> createState() => _AddFundsPageState();
}

class _AddFundsPageState extends State<AddFundsPage> {
  @override
  void initState() {
    super.initState();
    context.read<PaymentCubit>().loadPaymentMethods();
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
          text: l10n.addFunds,
          size: 20,
          weight: FontWeight.bold,
          color: isDarkMode
              ? AppThemeData.grey900Dark
              : AppThemeData.grey900,
        ),
      ),
      body: BlocListener<WalletCubit, WalletState>(
        listener: (context, state) {
          if (state is AddFundsRequiresAction) {
            // Navigate to webview for payment
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PaymentWebviewPage(
                  paymentUrl: state.response.redirectUrl ?? '',
                  transactionId: state.response.transactionId ?? '',
                ),
              ),
            ).then((success) {
              if (success == true) {
                ShowToastDialog.showToast('Funds added successfully');
                Navigator.pop(context, true);
              }
            });
          } else if (state is FundsAdded) {
            ShowToastDialog.showToast('Funds added successfully');
            Navigator.pop(context, true);
          } else if (state is AddFundsFailed) {
            ShowToastDialog.showToast(state.message);
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Info Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppThemeData.primary200.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppThemeData.primary200.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: AppThemeData.primary200,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomText(
                        text: 'Add funds to your wallet to pay for rides easily',
                        size: 14,
                        color: isDarkMode
                            ? AppThemeData.grey900Dark
                            : AppThemeData.grey900,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Add Funds Form
              const AddFundsForm(),

              const SizedBox(height: 24),

              // Payment Gateway Selector
              CustomText(
                text: 'Select Payment Gateway',
                size: 16,
                weight: FontWeight.bold,
                color: isDarkMode
                    ? AppThemeData.grey900Dark
                    : AppThemeData.grey900,
              ),

              const SizedBox(height: 12),

              const PaymentGatewaySelector(),
            ],
          ),
        ),
      ),
    );
  }
}
