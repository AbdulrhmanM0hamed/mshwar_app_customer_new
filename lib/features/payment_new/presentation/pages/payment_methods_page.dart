import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../../../core/themes/constant_colors.dart';
import '../../../../core/utils/dark_theme_provider.dart';
import '../../../../generated/app_localizations.dart';
import '../../../../common/widget/custom_text.dart';
import '../../../../common/widget/button.dart';
import '../cubit/payment/payment_cubit.dart';
import '../cubit/payment/payment_state.dart';
import '../widgets/payment_method_card.dart';
import '../../data/models/payment_method_model.dart';

class PaymentMethodsPage extends StatefulWidget {
  final String? selectedMethodId;
  final Function(PaymentMethodModel)? onMethodSelected;

  const PaymentMethodsPage({
    super.key,
    this.selectedMethodId,
    this.onMethodSelected,
  });

  @override
  State<PaymentMethodsPage> createState() => _PaymentMethodsPageState();
}

class _PaymentMethodsPageState extends State<PaymentMethodsPage> {
  PaymentMethodModel? _selectedMethod;

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
          text: 'Payment Methods',
          size: 20,
          weight: FontWeight.bold,
          color: isDarkMode
              ? AppThemeData.grey900Dark
              : AppThemeData.grey900,
        ),
      ),
      body: BlocBuilder<PaymentCubit, PaymentState>(
        builder: (context, state) {
          if (state is PaymentMethodsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is PaymentMethodsError) {
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
                  const SizedBox(height: 24),
                  CustomButton(
                    btnName: l10n.retry,
                    ontap: () {
                      context.read<PaymentCubit>().loadPaymentMethods();
                    },
                  ),
                ],
              ),
            );
          }

          if (state is PaymentMethodsLoaded) {
            final methods = state.methods;

            if (methods.isEmpty) {
              return Center(
                child: CustomText(
                  text: 'No payment methods available',
                  size: 16,
                  color: isDarkMode
                      ? AppThemeData.grey500Dark
                      : AppThemeData.grey500,
                ),
              );
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: methods.length,
                    itemBuilder: (context, index) {
                      final method = methods[index];
                      final isSelected = _selectedMethod?.id == method.id ||
                          (widget.selectedMethodId == method.id &&
                              _selectedMethod == null);

                      return PaymentMethodCard(
                        method: method,
                        isSelected: isSelected,
                        onTap: () {
                          setState(() {
                            _selectedMethod = method;
                          });
                          context.read<PaymentCubit>().selectPaymentMethod(method);
                        },
                      );
                    },
                  ),
                ),

                // Confirm Button
                if (_selectedMethod != null || widget.selectedMethodId != null)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? AppThemeData.grey200Dark
                          : AppThemeData.grey200,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: CustomButton(
                      btnName: 'Confirm',
                      ontap: () {
                        final selectedMethod = _selectedMethod ??
                            methods.firstWhere(
                              (m) => m.id == widget.selectedMethodId,
                            );
                        
                        if (widget.onMethodSelected != null) {
                          widget.onMethodSelected!(selectedMethod);
                        }
                        Navigator.pop(context, selectedMethod);
                      },
                    ),
                  ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
