import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../../../core/themes/constant_colors.dart';
import '../../../../core/utils/dark_theme_provider.dart';
import '../../../../common/widget/custom_text.dart';
import '../cubit/payment/payment_cubit.dart';
import '../cubit/payment/payment_state.dart';
import '../../data/models/payment_method_model.dart';

class PaymentGatewaySelector extends StatelessWidget {
  const PaymentGatewaySelector({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final isDarkMode = themeChange.getThem();

    return BlocBuilder<PaymentCubit, PaymentState>(
      builder: (context, state) {
        if (state is PaymentMethodsLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state is PaymentMethodsError) {
          return Center(
            child: CustomText(
              text: state.message,
              size: 14,
              color: AppThemeData.error200,
            ),
          );
        }

        if (state is PaymentMethodsLoaded) {
          final methods = state.methods;
          final selectedMethod = state.selectedMethod;

          if (methods.isEmpty) {
            return Center(
              child: CustomText(
                text: 'No payment methods available',
                size: 14,
                color: isDarkMode
                    ? AppThemeData.grey500Dark
                    : AppThemeData.grey500,
              ),
            );
          }

          return Column(
            children: methods.map((method) {
              final isSelected = selectedMethod?.id == method.id;

              return _PaymentGatewayCard(
                method: method,
                isSelected: isSelected,
                isDarkMode: isDarkMode,
                onTap: () {
                  context.read<PaymentCubit>().selectPaymentMethod(method);
                },
              );
            }).toList(),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

class _PaymentGatewayCard extends StatelessWidget {
  final PaymentMethodModel method;
  final bool isSelected;
  final bool isDarkMode;
  final VoidCallback onTap;

  const _PaymentGatewayCard({
    required this.method,
    required this.isSelected,
    required this.isDarkMode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppThemeData.primary200.withValues(alpha: 0.1)
              : (isDarkMode
                  ? AppThemeData.grey200Dark
                  : AppThemeData.grey200),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppThemeData.primary200
                : (isDarkMode
                    ? AppThemeData.grey300Dark
                    : AppThemeData.grey300),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Gateway Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppThemeData.primary200.withValues(alpha: 0.2)
                    : (isDarkMode
                        ? AppThemeData.grey300Dark
                        : AppThemeData.grey300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getGatewayIcon(method.name),
                color: isSelected
                    ? AppThemeData.primary200
                    : (isDarkMode
                        ? AppThemeData.grey500Dark
                        : AppThemeData.grey500),
                size: 24,
              ),
            ),

            const SizedBox(width: 16),

            // Gateway Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: method.name,
                    size: 16,
                    weight: FontWeight.w600,
                    color: isDarkMode
                        ? AppThemeData.grey900Dark
                        : AppThemeData.grey900,
                  ),
                  if (method.description != null) ...[
                    const SizedBox(height: 4),
                    CustomText(
                      text: method.description!,
                      size: 12,
                      color: isDarkMode
                          ? AppThemeData.grey500Dark
                          : AppThemeData.grey500,
                      maxLines: 2,
                    ),
                  ],
                ],
              ),
            ),

            // Selection Indicator
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? AppThemeData.primary200
                      : (isDarkMode
                          ? AppThemeData.grey500Dark
                          : AppThemeData.grey500),
                  width: 2,
                ),
                color: isSelected
                    ? AppThemeData.primary200
                    : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      size: 16,
                      color: Colors.white,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getGatewayIcon(String type) {
    switch (type.toLowerCase()) {
      case 'stripe':
        return Icons.credit_score;
      case 'paypal':
        return Icons.payment;
      case 'razorpay':
        return Icons.account_balance;
      case 'paytm':
        return Icons.phone_android;
      case 'flutterwave':
        return Icons.waves;
      case 'paystack':
        return Icons.layers;
      default:
        return Icons.payment;
    }
  }
}
