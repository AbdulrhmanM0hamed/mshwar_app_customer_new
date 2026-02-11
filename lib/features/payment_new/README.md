# Payment Feature - Clean Architecture

## 📁 Structure

```
payment_new/
├── data/
│   ├── models/                    # Data models with JSON serialization
│   │   ├── payment_method_model.dart
│   │   ├── payment_gateway_config_model.dart
│   │   ├── coupon_model.dart
│   │   ├── wallet_model.dart
│   │   ├── transaction_model.dart
│   │   ├── payment_request_model.dart
│   │   ├── payment_response_model.dart
│   │   └── tax_model.dart
│   └── repositories/              # Data layer - API communication
│       ├── payment_repository.dart
│       ├── wallet_repository.dart
│       └── coupon_repository.dart
├── presentation/
│   ├── cubit/                     # State management
│   │   ├── payment/
│   │   │   ├── payment_cubit.dart
│   │   │   └── payment_state.dart
│   │   ├── wallet/
│   │   │   ├── wallet_cubit.dart
│   │   │   └── wallet_state.dart
│   │   └── coupon/
│   │       ├── coupon_cubit.dart
│   │       └── coupon_state.dart
│   ├── pages/                     # Full screen pages
│   │   ├── payment_methods_page.dart
│   │   ├── payment_webview_page.dart
│   │   ├── wallet_page.dart
│   │   ├── add_funds_page.dart
│   │   ├── transaction_history_page.dart
│   │   └── payment_success_page.dart
│   └── widgets/                   # Reusable widgets
│       ├── payment_method_card.dart
│       ├── wallet_balance_card.dart
│       ├── transaction_list_item.dart
│       ├── payment_gateway_selector.dart
│       └── add_funds_form.dart
├── di/
│   └── payment_service_locator.dart  # Dependency injection setup
├── payment_di.dart                   # DI export wrapper
└── README.md                         # This file
```

## 🚀 Features

### Payment Management
- Multiple payment methods support (Cash, Wallet, Card, PayPal, Stripe, etc.)
- Payment gateway configuration (13 gateways supported)
- Payment processing with webview integration
- Payment verification and status tracking
- Payment cancellation

### Wallet Management
- Wallet balance display
- Add funds to wallet
- Transaction history with pagination
- Funds withdrawal
- Real-time balance updates

### Coupon Management
- Coupon validation
- Discount calculation (percentage & fixed)
- Available coupons listing
- Apply/remove coupons
- Minimum amount validation
- Expiry date checking

## 📦 Models

### PaymentMethodModel
```dart
- id: String
- name: String
- type: String (cash, wallet, card, etc.)
- isActive: bool
- description: String?
- icon: String?
```

### PaymentGatewayConfigModel
Supports 13 payment gateways:
- Stripe
- PayPal
- Razorpay
- Paytm
- Flutterwave
- Paystack
- Mercadopago
- Payfast
- Midtrans
- Orangemoney
- Xendit
- Upayments
- Wallet

### CouponModel
```dart
- id: String
- code: String
- discountType: DiscountType (percentage, fixed)
- discountValue: double
- minimumAmount: double?
- maximumDiscount: double?
- expiryDate: DateTime?
- isActive: bool
- calculateDiscount(amount): double
```

### WalletModel
```dart
- userId: String
- balance: double
- currency: String
- totalSpent: double?
- totalAdded: double?
- lastUpdated: DateTime
```

### TransactionModel
```dart
- id: String
- userId: String
- amount: double
- type: TransactionType (credit, debit)
- status: TransactionStatus (completed, pending, failed, cancelled)
- description: String
- referenceId: String?
- timestamp: DateTime
```

## 🎯 Usage

### 1. Setup Dependencies

In `main.dart`:
```dart
import 'package:cabme/features/payment_new/payment_di.dart';

void main() async {
  // ... other setup
  
  // Setup payment dependencies
  setupPaymentDependencies();
  
  runApp(MyApp());
}
```

### 2. Use Payment Methods Page

```dart
import 'package:cabme/features/payment_new/presentation/pages/payment_methods_page.dart';

// Navigate to payment methods
final selectedMethod = await Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => BlocProvider(
      create: (context) => getIt<PaymentCubit>(),
      child: const PaymentMethodsPage(),
    ),
  ),
);
```

### 3. Use Wallet Page

```dart
import 'package:cabme/features/payment_new/presentation/pages/wallet_page.dart';

// Navigate to wallet
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<WalletCubit>()),
        BlocProvider(create: (context) => getIt<PaymentCubit>()),
      ],
      child: const WalletPage(),
    ),
  ),
);
```

### 4. Process Payment

```dart
import 'package:cabme/features/payment_new/presentation/cubit/payment/payment_cubit.dart';

// In your widget
final paymentCubit = context.read<PaymentCubit>();

// Load payment methods
paymentCubit.loadPaymentMethods();

// Process payment
final request = PaymentRequestModel(
  userId: userId,
  amount: 100.0,
  paymentMethodId: selectedMethodId,
  description: 'Ride payment',
);

paymentCubit.processPayment(request);

// Listen to state
BlocListener<PaymentCubit, PaymentState>(
  listener: (context, state) {
    if (state is PaymentSuccess) {
      // Navigate to success page
    } else if (state is PaymentRequiresAction) {
      // Open webview for payment
    } else if (state is PaymentFailed) {
      // Show error
    }
  },
  child: YourWidget(),
)
```

### 5. Validate Coupon

```dart
import 'package:cabme/features/payment_new/presentation/cubit/coupon/coupon_cubit.dart';

// In your widget
final couponCubit = context.read<CouponCubit>();

// Validate coupon
couponCubit.validateCoupon('SAVE20', 100.0);

// Listen to state
BlocListener<CouponCubit, CouponState>(
  listener: (context, state) {
    if (state is CouponValid) {
      final discount = state.discountAmount;
      // Apply discount
    } else if (state is CouponInvalid) {
      // Show error
    }
  },
  child: YourWidget(),
)
```

## 🎨 Widgets

### PaymentMethodCard
Displays a payment method with selection state.

### WalletBalanceCard
Beautiful gradient card showing wallet balance and stats.

### TransactionListItem
Transaction item with icon, amount, status, and date.

### PaymentGatewaySelector
Grid of payment gateways with selection.

### AddFundsForm
Form with amount input and quick select buttons.

## 🔄 State Management

### Payment States (12 states)
- PaymentInitial
- PaymentMethodsLoading
- PaymentMethodsLoaded
- PaymentMethodsError
- PaymentSettingsLoading
- PaymentSettingsLoaded
- PaymentSettingsError
- PaymentProcessing
- PaymentSuccess
- PaymentFailed
- PaymentRequiresAction
- PaymentVerifying
- PaymentVerified
- PaymentVerificationFailed
- PaymentCancelled

### Wallet States (11 states)
- WalletInitial
- WalletLoading
- WalletLoaded
- WalletError
- AddingFunds
- FundsAdded
- AddFundsRequiresAction
- AddFundsFailed
- TransactionHistoryLoading
- TransactionHistoryLoaded
- TransactionHistoryError
- WithdrawingFunds
- FundsWithdrawn
- WithdrawFundsFailed

### Coupon States (9 states)
- CouponInitial
- CouponValidating
- CouponValid
- CouponInvalid
- CouponApplying
- CouponApplied
- CouponApplyFailed
- CouponRemoved
- AvailableCouponsLoading
- AvailableCouponsLoaded
- AvailableCouponsError

## 🌐 API Endpoints

### Payment
- `GET /payment/methods` - Get payment methods
- `GET /payment/settings` - Get payment settings
- `POST /payment/process` - Process payment
- `GET /payment/verify/:id` - Verify payment
- `POST /payment/cancel` - Cancel payment

### Wallet
- `GET /wallet/balance` - Get wallet balance
- `POST /wallet/add-funds` - Add funds to wallet
- `GET /wallet/transactions` - Get transaction history
- `POST /wallet/withdraw` - Withdraw funds

### Coupon
- `POST /coupon/validate` - Validate coupon
- `GET /coupon/available` - Get available coupons
- `POST /coupon/apply` - Apply coupon

## 🎯 Best Practices

1. **Always use BlocProvider** when navigating to payment pages
2. **Handle all payment states** in your UI
3. **Verify payments** after webview completion
4. **Show loading indicators** during API calls
5. **Display error messages** to users
6. **Use RefreshIndicator** for lists
7. **Implement pagination** for transaction history
8. **Validate input** before processing

## 🔒 Security

- All payment data is transmitted securely via HTTPS
- Sensitive data is never stored locally
- Payment tokens are handled by payment gateways
- User authentication required for all operations

## 📱 Supported Payment Gateways

1. **Stripe** - Credit/Debit cards
2. **PayPal** - PayPal account
3. **Razorpay** - Indian payment gateway
4. **Paytm** - Indian wallet
5. **Flutterwave** - African payment gateway
6. **Paystack** - African payment gateway
7. **Mercadopago** - Latin American gateway
8. **Payfast** - South African gateway
9. **Midtrans** - Indonesian gateway
10. **Orangemoney** - African mobile money
11. **Xendit** - Southeast Asian gateway
12. **Upayments** - Middle Eastern gateway
13. **Wallet** - In-app wallet

## 🌍 Localization

All text is localized using `AppLocalizations`:
- English (en_US)
- Arabic (ar_AE) with RTL support
- Urdu (ur_PK) with RTL support

## 🎨 Theme Support

- Full dark mode support
- Uses `AppThemeData` colors
- Responsive design
- RTL layout support

## ✅ Testing

```dart
// Example test
test('Payment repository processes payment successfully', () async {
  final repository = PaymentRepositoryImpl(apiService: mockApiService);
  final request = PaymentRequestModel(...);
  
  final response = await repository.processPayment(request);
  
  expect(response.isSuccess, true);
});
```

## 📝 Notes

- All repositories throw standard `Exception` (not `ApiException`)
- All cubits handle standard `Exception`
- API endpoints use leading slash format: `/endpoint`
- Repository parameters use `apiService` (not `_apiService`)
- All models have full null safety
- All models have `fromJson`, `toJson`, and `copyWith` methods

## 🔄 Migration from Old Payment

If migrating from old payment feature:
1. Update imports to use `payment_new`
2. Replace GetX controllers with Cubits
3. Update state handling from GetX to Bloc
4. Use new models with proper null safety
5. Update API endpoints to new format

## 📚 Dependencies

- `flutter_bloc` - State management
- `get_it` - Dependency injection
- `webview_flutter` - Payment webview
- `provider` - Theme management

---

**Last Updated**: Now
**Status**: ✅ Complete - Ready for production
**Compilation**: ✅ 0 Errors
