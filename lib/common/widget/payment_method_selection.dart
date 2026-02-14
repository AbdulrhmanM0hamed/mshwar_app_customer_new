import 'dart:convert';
import 'package:cabme/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax/iconsax.dart';
import 'package:cabme/core/constant/constant.dart';
import 'package:cabme/core/themes/constant_colors.dart';
import 'package:cabme/core/utils/Preferences.dart';
import 'package:cabme/features/payment_new/data/models/payment_gateway_config_model.dart';
import 'package:cabme/service/api.dart';

/// Payment method data model for UI
class PaymentMethodItem {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final Color iconColor;
  final String paymentMethodId;

  PaymentMethodItem({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.iconColor,
    required this.paymentMethodId,
  });
}

class PaymentMethodSelection {
  /// Show payment selection bottom sheet
  /// [allowedMethods] - Optional list of payment method IDs to show (e.g., ['wallet', 'upayments'])
  /// If null or empty, all enabled methods will be shown
  static Future<PaymentMethodItem?> show({
    required BuildContext context,
    required double totalAmount,
    String totalAmountLabel = "Total",
    String? subtitle,
    String currency = "KWD",
    Function(PaymentMethodItem)? onPaymentSelected,
    List<String>? allowedMethods,
    bool excludeCash = false,
  }) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return showModalBottomSheet<PaymentMethodItem>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _PaymentSelectionSheet(
        isDark: isDark,
        totalAmount: totalAmount,
        totalAmountLabel: totalAmountLabel,
        subtitle: subtitle,
        currency: currency,
        onPaymentSelected: onPaymentSelected,
        allowedMethods: allowedMethods,
        excludeCash: excludeCash,
      ),
    );
  }
}

class _PaymentSelectionSheet extends StatefulWidget {
  final bool isDark;
  final double totalAmount;
  final String totalAmountLabel;
  final String? subtitle;
  final String currency;
  final Function(PaymentMethodItem)? onPaymentSelected;
  final List<String>? allowedMethods;
  final bool excludeCash;

  const _PaymentSelectionSheet({
    required this.isDark,
    required this.totalAmount,
    required this.totalAmountLabel,
    this.subtitle,
    required this.currency,
    this.onPaymentSelected,
    this.allowedMethods,
    this.excludeCash = false,
  });

  @override
  State<_PaymentSelectionSheet> createState() => _PaymentSelectionSheetState();
}

class _PaymentSelectionSheetState extends State<_PaymentSelectionSheet> {
  late PaymentSettingsModel paymentSettings;
  List<PaymentMethodItem> availablePaymentMethods = [];
  String walletBalance = "0.0";
  bool isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isLoading) {
      _loadPaymentMethods();
    }
  }

  Future<void> _loadPaymentMethods() async {
    // Get payment settings
    paymentSettings = Constant.getPaymentSetting();

    // Fetch actual wallet balance from server (not cached data)
    try {
      final response = await http.get(
        Uri.parse(
            "${API.wallet}?id_user=${Preferences.getInt(Preferences.userId)}&user_cat=user_app"),
        headers: API.header,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == 'success' && data['data'] != null) {
          walletBalance = data['data']['amount']?.toString() ?? "0.0";
        } else {
          walletBalance = "0.0";
        }
      } else {
        walletBalance = "0.0";
      }
    } catch (e) {
      walletBalance = "0.0";
    }

    // Build available payment methods based on admin settings
    if (mounted) {
      availablePaymentMethods = _buildPaymentMethodsList(context);

      setState(() {
        isLoading = false;
      });
    }
  }

  List<PaymentMethodItem> _buildPaymentMethodsList(BuildContext context) {
    List<PaymentMethodItem> methods = [];
    final allowed = widget.allowedMethods;

    bool isAllowed(String id) {
      if (allowed == null || allowed.isEmpty) return true;
      return allowed.contains(id);
    }

    // Wallet - Always available if enabled
    if (paymentSettings.wallet?.isEnabled == true && isAllowed("wallet")) {
      methods.add(PaymentMethodItem(
        id: "wallet",
        name: paymentSettings.wallet?.credentials['libelle'] ?? "Wallet",
        description: "Balance: $walletBalance ${widget.currency}",
        icon: Iconsax.wallet_3,
        iconColor: Colors.green,
        paymentMethodId:
            paymentSettings.wallet?.credentials['id_payment_method'] ?? "5",
      ));
    }

    // Cash - skip if excludeCash is true
    if (paymentSettings.cash?.isEnabled == true &&
        isAllowed("cash") &&
        !widget.excludeCash) {
      methods.add(PaymentMethodItem(
        id: "cash",
        name: paymentSettings.cash?.credentials['libelle'] ?? "Cash",
        description: "Pay cash to driver",
        icon: Iconsax.money,
        iconColor: Colors.orange,
        paymentMethodId:
            paymentSettings.cash?.credentials['id_payment_method'] ?? "1",
      ));
    }

    // Stripe (Card)
    if (paymentSettings.stripe?.isEnabled == true && isAllowed("stripe")) {
      methods.add(PaymentMethodItem(
        id: "stripe",
        name: paymentSettings.stripe?.credentials['libelle'] ?? "Card",
        description: "Credit or Debit card",
        icon: Iconsax.card,
        iconColor: Colors.purple,
        paymentMethodId:
            paymentSettings.stripe?.credentials['id_payment_method'] ?? "2",
      ));
    }

    // PayPal
    if (paymentSettings.paypal?.isEnabled == true && isAllowed("paypal")) {
      methods.add(PaymentMethodItem(
        id: "paypal",
        name: paymentSettings.paypal?.credentials['libelle'] ?? "PayPal",
        description: "Pay with PayPal",
        icon: Iconsax.money_recive,
        iconColor: Colors.blue.shade800,
        paymentMethodId:
            paymentSettings.paypal?.credentials['id_payment_method'] ?? "3",
      ));
    }

    // RazorPay
    if (paymentSettings.razorpay?.isEnabled == true && isAllowed("razorpay")) {
      methods.add(PaymentMethodItem(
        id: "razorpay",
        name: paymentSettings.razorpay?.credentials['libelle'] ?? "RazorPay",
        description: "Pay with RazorPay",
        icon: Iconsax.card_pos,
        iconColor: Colors.indigo,
        paymentMethodId:
            paymentSettings.razorpay?.credentials['id_payment_method'] ?? "4",
      ));
    }

    // PayStack
    if (paymentSettings.paystack?.isEnabled == true && isAllowed("paystack")) {
      methods.add(PaymentMethodItem(
        id: "paystack",
        name: paymentSettings.paystack?.credentials['libelle'] ?? "PayStack",
        description: "Pay with PayStack",
        icon: Iconsax.card_tick,
        iconColor: Colors.teal,
        paymentMethodId:
            paymentSettings.paystack?.credentials['id_payment_method'] ?? "6",
      ));
    }

    // FlutterWave
    if (paymentSettings.flutterwave?.isEnabled == true &&
        isAllowed("flutterwave")) {
      methods.add(PaymentMethodItem(
        id: "flutterwave",
        name: paymentSettings.flutterwave?.credentials['libelle'] ??
            "FlutterWave",
        description: "Pay with FlutterWave",
        icon: Iconsax.flash,
        iconColor: Colors.amber,
        paymentMethodId:
            paymentSettings.flutterwave?.credentials['id_payment_method'] ??
                "7",
      ));
    }

    // MercadoPago
    if (paymentSettings.mercadopago?.isEnabled == true &&
        isAllowed("mercadopago")) {
      methods.add(PaymentMethodItem(
        id: "mercadopago",
        name: paymentSettings.mercadopago?.credentials['libelle'] ??
            "MercadoPago",
        description: "Pay with MercadoPago",
        icon: Iconsax.money_send,
        iconColor: Colors.lightBlue,
        paymentMethodId:
            paymentSettings.mercadopago?.credentials['id_payment_method'] ??
                "8",
      ));
    }

    // PayFast
    if (paymentSettings.payfast?.isEnabled == true && isAllowed("payfast")) {
      methods.add(PaymentMethodItem(
        id: "payfast",
        name: paymentSettings.payfast?.credentials['libelle'] ?? "PayFast",
        description: "Pay with PayFast",
        icon: Iconsax.card_receive,
        iconColor: Colors.cyan,
        paymentMethodId:
            paymentSettings.payfast?.credentials['id_payment_method'] ?? "9",
      ));
    }

    // Xendit
    if (paymentSettings.xendit?.isEnabled == true && isAllowed("xendit")) {
      methods.add(PaymentMethodItem(
        id: "xendit",
        name: paymentSettings.xendit?.credentials['libelle'] ?? "Xendit",
        description: "Pay with Xendit",
        icon: Iconsax.card_add,
        iconColor: Colors.deepPurple,
        paymentMethodId:
            paymentSettings.xendit?.credentials['id_payment_method'] ?? "10",
      ));
    }

    // OrangePay
    if (paymentSettings.orangepay?.isEnabled == true &&
        isAllowed("orangepay")) {
      methods.add(PaymentMethodItem(
        id: "orangepay",
        name: paymentSettings.orangepay?.credentials['libelle'] ?? "Orange Pay",
        description: "Pay with Orange Pay",
        icon: Iconsax.mobile,
        iconColor: Colors.deepOrange,
        paymentMethodId:
            paymentSettings.orangepay?.credentials['id_payment_method'] ?? "11",
      ));
    }

    // Midtrans
    if (paymentSettings.midtrans?.isEnabled == true && isAllowed("midtrans")) {
      methods.add(PaymentMethodItem(
        id: "midtrans",
        name: paymentSettings.midtrans?.credentials['libelle'] ?? "Midtrans",
        description: "Pay with Midtrans",
        icon: Iconsax.card_slash,
        iconColor: Colors.blueGrey,
        paymentMethodId:
            paymentSettings.midtrans?.credentials['id_payment_method'] ?? "12",
      ));
    }

    // UPayments (KNET, Apple Pay, etc.) - Only show if enabled by admin
    if (paymentSettings.upayments?.isEnabled == true &&
        isAllowed("upayments")) {
      methods.add(PaymentMethodItem(
        id: "upayments",
        name: "KNET / Apple Pay",
        description: "Pay with KNET, Apple Pay, Cards",
        icon: Iconsax.card,
        iconColor: Colors.blue,
        paymentMethodId:
            paymentSettings.upayments?.credentials['id_payment_method'] ?? "13",
      ));
    }

    return methods;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: widget.isDark ? AppThemeData.surface50Dark : Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            height: 5,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                InkWell(
                  onTap: () => Navigator.pop(context),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color:
                          widget.isDark ? Colors.grey[800] : Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Iconsax.arrow_left_2,
                      size: 20,
                      color: widget.isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  l10n.selectPaymentMethod,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: widget.isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          // Price Summary
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppThemeData.primary200.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: AppThemeData.primary200.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.totalAmountLabel,
                      style: TextStyle(
                        fontSize: 14,
                        color:
                            widget.isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                    if (widget.subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        widget.subtitle!,
                        style: TextStyle(
                          fontSize: 12,
                          color: widget.isDark
                              ? Colors.grey[500]
                              : Colors.grey[500],
                        ),
                      ),
                    ],
                  ],
                ),
                Text(
                  "${widget.totalAmount.toStringAsFixed(3)} ${widget.currency}",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppThemeData.primary300Dark,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Payment Methods List
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : availablePaymentMethods.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Iconsax.card_remove,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "No payment methods available",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Please contact support",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: availablePaymentMethods.length,
                        itemBuilder: (context, index) {
                          final method = availablePaymentMethods[index];
                          return _buildPaymentOption(method);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(PaymentMethodItem method) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (widget.onPaymentSelected != null) {
              widget.onPaymentSelected!(method);
            }
            Navigator.pop(context, method);
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: widget.isDark ? Colors.grey[850] : Colors.grey[100],
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: widget.isDark ? Colors.grey[700]! : Colors.grey[300]!,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: method.iconColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(method.icon, color: method.iconColor, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        method.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: widget.isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        method.description,
                        style: TextStyle(
                          fontSize: 12,
                          color: widget.isDark
                              ? Colors.grey[400]
                              : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Iconsax.arrow_right_3,
                  color: widget.isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
