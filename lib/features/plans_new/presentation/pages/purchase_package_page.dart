import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import '../../../../common/widget/button.dart';
import '../../../../common/widget/custom_app_bar.dart';
import '../../../../common/widget/custom_text.dart';
import '../../../../common/widget/payment_method_selection.dart';
import '../../../../core/constant/show_toast_dialog.dart';
import '../../../../core/themes/constant_colors.dart';
import '../../../../core/utils/dark_theme_provider.dart';
import '../../../../generated/app_localizations.dart';
import '../../data/models/package_model.dart';
import '../cubit/package/package_cubit.dart';
import '../cubit/package/package_state.dart';

class PurchasePackagePage extends StatelessWidget {
  final PackageModel package;

  const PurchasePackagePage({super.key, required this.package});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final isDark = themeChange.getThem();
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (context) => GetIt.instance<PackageCubit>(),
      child: Scaffold(
        backgroundColor: isDark ? AppThemeData.surface50Dark : AppThemeData.surface50,
        appBar: CustomAppBar(
          title: l10n.purchasePackage,
        ),
        body: BlocListener<PackageCubit, PackageState>(
          listener: (context, state) {
            if (state is PackagePurchased) {
              ShowToastDialog.showToast(l10n.packagePurchaseInitiated);
            } else if (state is PackagePurchaseError) {
              ShowToastDialog.showToast(state.message);
            } else if (state is PackagePaymentSuccess) {
              ShowToastDialog.showToast(l10n.packagePurchasedSuccessfully);
              Navigator.pop(context, true);
            } else if (state is PackagePaymentError) {
              ShowToastDialog.showToast(state.message);
            }
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  color: isDark ? AppThemeData.grey800 : Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppThemeData.primary200.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.local_gas_station,
                            color: AppThemeData.primary200,
                            size: 48,
                          ),
                        ),
                        const SizedBox(height: 16),
                        CustomText(
                          text: package.name,
                          size: 24,
                          weight: FontWeight.bold,
                          color: isDark ? Colors.white : AppThemeData.grey900,
                        ),
                        if (package.description != null && package.description!.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          CustomText(
                            text: package.description!,
                            size: 14,
                            color: isDark ? AppThemeData.grey400Dark : AppThemeData.grey500,
                            align: TextAlign.center,
                          ),
                        ],
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isDark ? AppThemeData.grey300Dark : AppThemeData.grey100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              _buildDetailRow(
                                l10n.totalKilometers,
                                package.formattedKm,
                                Icons.straighten,
                                themeChange,
                              ),
                              Divider(
                                height: 24,
                                color: isDark ? AppThemeData.grey300Dark : AppThemeData.grey200,
                              ),
                              _buildDetailRow(
                                l10n.pricePerKm,
                                package.pricePerKmDisplay,
                                Icons.attach_money,
                                themeChange,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Card(
                  color: isDark ? AppThemeData.grey800 : Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: l10n.priceSummary,
                          size: 18,
                          weight: FontWeight.bold,
                          color: isDark ? Colors.white : AppThemeData.grey900,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                              text: '${package.totalKm.toStringAsFixed(0)} KM × ${package.pricePerKm.toStringAsFixed(3)} KWD',
                              size: 14,
                              color: isDark ? AppThemeData.grey400Dark : AppThemeData.grey500,
                            ),
                            CustomText(
                              text: package.formattedPrice,
                              size: 14,
                              color: isDark ? AppThemeData.grey400Dark : AppThemeData.grey500,
                            ),
                          ],
                        ),
                        Divider(
                          height: 24,
                          color: isDark ? AppThemeData.grey300Dark : AppThemeData.grey200,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                              text: l10n.totalAmount,
                              size: 18,
                              weight: FontWeight.bold,
                              color: isDark ? Colors.white : AppThemeData.grey900,
                            ),
                            CustomText(
                              text: package.formattedPrice,
                              size: 24,
                              weight: FontWeight.bold,
                              color: AppThemeData.primary200,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                BlocBuilder<PackageCubit, PackageState>(
                  builder: (context, state) {
                    final isLoading = state is PackagePurchasing || state is PackagePaymentProcessing;
                    
                    return CustomButton(
                      btnName: l10n.proceedToPayment,
                      ontap: isLoading ? null : () => _showPaymentSelection(context),
                      icon: Icon(Icons.shopping_cart, color: Colors.white, size: 20),
                      borderRadius: 14,
                      isLoading: isLoading,
                    );
                  },
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value,
    IconData icon,
    DarkThemeProvider themeChange, {
    Color? valueColor,
  }) {
    final isDark = themeChange.getThem();

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: (valueColor ?? AppThemeData.primary200).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: valueColor ?? AppThemeData.primary200,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: CustomText(
            text: label,
            size: 14,
            color: isDark ? AppThemeData.grey400Dark : AppThemeData.grey500,
          ),
        ),
        CustomText(
          text: value,
          size: 14,
          weight: FontWeight.bold,
          color: valueColor ?? (isDark ? Colors.white : AppThemeData.grey900),
        ),
      ],
    );
  }

  Future<void> _showPaymentSelection(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final totalAmount = package.totalPrice;

    if (totalAmount <= 0) {
      ShowToastDialog.showToast(l10n.invalidPackagePrice);
      return;
    }

    final selectedMethod = await PaymentMethodSelection.show(
      context: context,
      totalAmount: totalAmount,
      totalAmountLabel: l10n.packagePrice,
      subtitle: '${package.totalKm.toStringAsFixed(0)} KM',
      currency: 'KWD',
      allowedMethods: ['wallet', 'upayments'],
      excludeCash: true,
    );

    if (selectedMethod == null || !context.mounted) return;

    if (selectedMethod.id == 'wallet') {
      // TODO: Implement wallet payment
      ShowToastDialog.showToast(l10n.walletPaymentNotImplemented);
    } else if (selectedMethod.id == 'upayments') {
      // TODO: Implement KNET payment
      ShowToastDialog.showToast(l10n.knetPaymentNotImplemented);
    }
  }
}
