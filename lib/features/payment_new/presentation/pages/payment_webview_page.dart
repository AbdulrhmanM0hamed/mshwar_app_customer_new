import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../../core/themes/constant_colors.dart';
import '../../../../core/utils/dark_theme_provider.dart';
import '../../../../common/widget/custom_text.dart';
import '../cubit/payment/payment_cubit.dart';

class PaymentWebviewPage extends StatefulWidget {
  final String paymentUrl;
  final String transactionId;

  const PaymentWebviewPage({
    super.key,
    required this.paymentUrl,
    required this.transactionId,
  });

  @override
  State<PaymentWebviewPage> createState() => _PaymentWebviewPageState();
}

class _PaymentWebviewPageState extends State<PaymentWebviewPage> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
            _checkPaymentStatus(url);
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {
            setState(() {
              _isLoading = false;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  void _checkPaymentStatus(String url) {
    // Check if URL indicates payment success/failure
    if (url.contains('success') || url.contains('payment-success')) {
      _verifyPayment(true);
    } else if (url.contains('cancel') || url.contains('payment-failed')) {
      _verifyPayment(false);
    }
  }

  void _verifyPayment(bool expectedSuccess) {
    context.read<PaymentCubit>().verifyPayment(widget.transactionId);
    
    // Wait a bit then pop with result
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pop(context, expectedSuccess);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
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
            Icons.close,
            color: isDarkMode
                ? AppThemeData.grey900Dark
                : AppThemeData.grey900,
          ),
          onPressed: () => Navigator.pop(context, false),
        ),
        title: CustomText(
          text: 'Payment',
          size: 20,
          weight: FontWeight.bold,
          color: isDarkMode
              ? AppThemeData.grey900Dark
              : AppThemeData.grey900,
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          
          if (_isLoading)
            Container(
              color: isDarkMode
                  ? AppThemeData.surface50Dark
                  : AppThemeData.surface50,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
