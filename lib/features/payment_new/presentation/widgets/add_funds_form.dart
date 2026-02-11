import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../../../core/themes/constant_colors.dart';
import '../../../../core/utils/dark_theme_provider.dart';
import '../../../../core/utils/Preferences.dart';
import '../../../../generated/app_localizations.dart';
import '../../../../common/widget/custom_text.dart';
import '../../../../common/widget/button.dart';
import '../../../../common/widget/text_field.dart';
import '../cubit/wallet/wallet_cubit.dart';
import '../cubit/payment/payment_cubit.dart';
import '../cubit/payment/payment_state.dart';
import '../../data/models/payment_request_model.dart';

class AddFundsForm extends StatefulWidget {
  const AddFundsForm({super.key});

  @override
  State<AddFundsForm> createState() => _AddFundsFormState();
}

class _AddFundsFormState extends State<AddFundsForm> {
  final TextEditingController _amountController = TextEditingController();
  final List<double> _quickAmounts = [10, 20, 50, 100, 200, 500];
  double? _selectedAmount;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _selectQuickAmount(double amount) {
    setState(() {
      _selectedAmount = amount;
      _amountController.text = amount.toStringAsFixed(0);
    });
  }

  void _processAddFunds() {
    final amount = double.tryParse(_amountController.text);
    
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount')),
      );
      return;
    }

    final paymentState = context.read<PaymentCubit>().state;
    if (paymentState is! PaymentMethodsLoaded || 
        paymentState.selectedMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a payment method')),
      );
      return;
    }

    final userId = Preferences.getInt(Preferences.userId).toString();
    final request = AddFundsRequestModel(
      userId: userId,
      amount: amount,
      paymentGateway: paymentState.selectedMethod!.id,
    );

    context.read<WalletCubit>().addFunds(request);
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final l10n = AppLocalizations.of(context)!;
    final isDarkMode = themeChange.getThem();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Amount Input
        CustomText(
          text: 'Enter Amount',
          size: 16,
          weight: FontWeight.bold,
          color: isDarkMode
              ? AppThemeData.grey900Dark
              : AppThemeData.grey900,
        ),

        const SizedBox(height: 12),

        CustomTextField(
          text: '',
          controller: _amountController,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          prefixIcon: Icon(
            Icons.attach_money,
            color: isDarkMode
                ? AppThemeData.grey500Dark
                : AppThemeData.grey500,
          ),
          onChanged: (value) {
            setState(() {
              _selectedAmount = null;
            });
          },
        ),

        const SizedBox(height: 16),

        // Quick Amount Selection
        CustomText(
          text: 'Quick Select',
          size: 14,
          color: isDarkMode
              ? AppThemeData.grey500Dark
              : AppThemeData.grey500,
        ),

        const SizedBox(height: 12),

        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _quickAmounts.map((amount) {
            final isSelected = _selectedAmount == amount;

            return GestureDetector(
              onTap: () => _selectQuickAmount(amount),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppThemeData.primary200
                      : (isDarkMode
                          ? AppThemeData.grey200Dark
                          : AppThemeData.grey200),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected
                        ? AppThemeData.primary200
                        : (isDarkMode
                            ? AppThemeData.grey300Dark
                            : AppThemeData.grey300),
                  ),
                ),
                child: CustomText(
                  text: '\$${amount.toStringAsFixed(0)}',
                  size: 14,
                  weight: FontWeight.w600,
                  color: isSelected
                      ? Colors.white
                      : (isDarkMode
                          ? AppThemeData.grey900Dark
                          : AppThemeData.grey900),
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 24),

        // Add Funds Button
        BlocBuilder<PaymentCubit, PaymentState>(
          builder: (context, state) {
            final isMethodSelected = state is PaymentMethodsLoaded &&
                state.selectedMethod != null;

            return CustomButton(
              btnName: l10n.addFunds,
              ontap: isMethodSelected ? _processAddFunds : null,
            );
          },
        ),
      ],
    );
  }
}
