class PaymentGatewayConfig {
  final String name;
  final bool isEnabled;
  final bool isSandbox;
  final Map<String, String> credentials;

  const PaymentGatewayConfig({
    required this.name,
    required this.isEnabled,
    required this.isSandbox,
    required this.credentials,
  });

  factory PaymentGatewayConfig.fromJson(String name, Map<String, dynamic> json) {
    return PaymentGatewayConfig(
      name: name,
      isEnabled: json['enable']?.toString() == 'true' || json['enable']?.toString() == '1',
      isSandbox: json['isSandbox']?.toString() == 'true' || json['isSandbox']?.toString() == '1',
      credentials: Map<String, String>.from(json),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'enable': isEnabled.toString(),
      'isSandbox': isSandbox.toString(),
      ...credentials,
    };
  }
}

class PaymentSettingsModel {
  final bool success;
  final String? message;
  final PaymentGatewayConfig? stripe;
  final PaymentGatewayConfig? cash;
  final PaymentGatewayConfig? wallet;
  final PaymentGatewayConfig? paypal;
  final PaymentGatewayConfig? razorpay;
  final PaymentGatewayConfig? paystack;
  final PaymentGatewayConfig? flutterwave;
  final PaymentGatewayConfig? mercadopago;
  final PaymentGatewayConfig? payfast;
  final PaymentGatewayConfig? xendit;
  final PaymentGatewayConfig? orangepay;
  final PaymentGatewayConfig? midtrans;
  final PaymentGatewayConfig? upayments;

  const PaymentSettingsModel({
    required this.success,
    this.message,
    this.stripe,
    this.cash,
    this.wallet,
    this.paypal,
    this.razorpay,
    this.paystack,
    this.flutterwave,
    this.mercadopago,
    this.payfast,
    this.xendit,
    this.orangepay,
    this.midtrans,
    this.upayments,
  });

  factory PaymentSettingsModel.fromJson(Map<String, dynamic> json) {
    return PaymentSettingsModel(
      success: json['success'] == 'success',
      message: json['message']?.toString(),
      stripe: json['Strip'] != null 
          ? PaymentGatewayConfig.fromJson('stripe', json['Strip']) 
          : null,
      cash: json['Cash'] != null 
          ? PaymentGatewayConfig.fromJson('cash', json['Cash']) 
          : null,
      wallet: json['My Wallet'] != null 
          ? PaymentGatewayConfig.fromJson('wallet', json['My Wallet']) 
          : null,
      paypal: json['PayPal'] != null 
          ? PaymentGatewayConfig.fromJson('paypal', json['PayPal']) 
          : null,
      razorpay: json['Razorpay'] != null 
          ? PaymentGatewayConfig.fromJson('razorpay', json['Razorpay']) 
          : null,
      paystack: json['PayStack'] != null 
          ? PaymentGatewayConfig.fromJson('paystack', json['PayStack']) 
          : null,
      flutterwave: json['FlutterWave'] != null 
          ? PaymentGatewayConfig.fromJson('flutterwave', json['FlutterWave']) 
          : null,
      mercadopago: json['Mercadopago'] != null 
          ? PaymentGatewayConfig.fromJson('mercadopago', json['Mercadopago']) 
          : null,
      payfast: json['PayFast'] != null 
          ? PaymentGatewayConfig.fromJson('payfast', json['PayFast']) 
          : null,
      xendit: json['Xendit'] != null 
          ? PaymentGatewayConfig.fromJson('xendit', json['Xendit']) 
          : null,
      orangepay: json['OrangePay'] != null 
          ? PaymentGatewayConfig.fromJson('orangepay', json['OrangePay']) 
          : null,
      midtrans: json['Midtrans'] != null 
          ? PaymentGatewayConfig.fromJson('midtrans', json['Midtrans']) 
          : null,
      upayments: json['upayments'] != null 
          ? PaymentGatewayConfig.fromJson('upayments', json['upayments']) 
          : null,
    );
  }

  List<PaymentGatewayConfig> get enabledGateways {
    final gateways = <PaymentGatewayConfig>[];
    
    if (cash?.isEnabled == true) gateways.add(cash!);
    if (wallet?.isEnabled == true) gateways.add(wallet!);
    if (stripe?.isEnabled == true) gateways.add(stripe!);
    if (paypal?.isEnabled == true) gateways.add(paypal!);
    if (razorpay?.isEnabled == true) gateways.add(razorpay!);
    if (paystack?.isEnabled == true) gateways.add(paystack!);
    if (flutterwave?.isEnabled == true) gateways.add(flutterwave!);
    if (mercadopago?.isEnabled == true) gateways.add(mercadopago!);
    if (payfast?.isEnabled == true) gateways.add(payfast!);
    if (xendit?.isEnabled == true) gateways.add(xendit!);
    if (orangepay?.isEnabled == true) gateways.add(orangepay!);
    if (midtrans?.isEnabled == true) gateways.add(midtrans!);
    if (upayments?.isEnabled == true) gateways.add(upayments!);
    
    return gateways;
  }
}
