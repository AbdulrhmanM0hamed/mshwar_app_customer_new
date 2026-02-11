# Plans Feature (New Architecture)

Clean Architecture implementation for KM Packages and Subscriptions management.

## Structure

```
plans_new/
├── data/
│   ├── models/
│   │   ├── package_model.dart          # Package & UserPackage models
│   │   └── subscription_model.dart     # Subscription models
│   └── repositories/
│       ├── package_repository.dart     # Package data operations
│       └── subscription_repository.dart # Subscription data operations
├── presentation/
│   ├── cubit/
│   │   ├── package/
│   │   │   ├── package_cubit.dart
│   │   │   └── package_state.dart
│   │   └── subscription/
│   │       ├── subscription_cubit.dart
│   │       └── subscription_state.dart
│   ├── pages/                          # (To be implemented)
│   └── widgets/                        # (To be implemented)
├── di/
│   └── plans_service_locator.dart      # Dependency injection setup
├── plans_di.dart                       # Export wrapper
└── README.md                           # This file
```

## Features

### KM Packages
- View available packages for purchase
- Purchase packages with Wallet or KNET
- View purchased packages with usage tracking
- Apply packages to rides automatically
- Track remaining KM and usage percentage

### Subscriptions
- Create recurring ride subscriptions (home-work-home)
- One-way or two-way trip types
- Flexible schedule (working days, pickup times)
- Price calculation based on distance and duration
- Payment with Wallet or KNET
- Admin approval workflow
- Track upcoming rides

## Setup

### 1. Register Dependencies

In `main.dart`, after core dependencies:

```dart
import 'package:cabme/features/plans_new/plans_di.dart';

void main() async {
  // ... core setup ...
  
  setupPlansDependencies();
  
  runApp(MyApp());
}
```

### 2. Use Cubits in Pages

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cabme/features/plans_new/presentation/cubit/package/package_cubit.dart';

class PackageListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<PackageCubit>()..loadAvailablePackages(),
      child: BlocBuilder<PackageCubit, PackageState>(
        builder: (context, state) {
          if (state is PackagesLoading) {
            return CircularProgressIndicator();
          }
          if (state is PackagesLoaded) {
            return ListView.builder(
              itemCount: state.packages.length,
              itemBuilder: (context, index) {
                final package = state.packages[index];
                return PackageCard(package: package);
              },
            );
          }
          if (state is PackagesError) {
            return ErrorWidget(message: state.message);
          }
          return SizedBox();
        },
      ),
    );
  }
}
```

## API Endpoints

### Packages
- `GET /packages` - Get available packages
- `GET /user-packages` - Get user's purchased packages
- `GET /usable-packages` - Get packages available for ride application
- `POST /purchase-package` - Purchase a package
- `POST /package-pay-wallet` - Pay with wallet
- `POST /package-confirm-payment` - Confirm payment
- `POST /cancel-package` - Cancel pending package
- `POST /apply-package-to-ride` - Apply package KM to ride

### Subscriptions
- `GET /subscription-settings` - Get subscription settings
- `GET /user-subscriptions` - Get user's subscriptions
- `GET /subscription-upcoming-rides` - Get upcoming rides
- `GET /subscription-details` - Get subscription details
- `POST /subscription-calculate-price` - Calculate subscription price
- `POST /subscription-create` - Create new subscription
- `POST /subscription-pay-wallet` - Pay with wallet
- `POST /subscription-confirm-payment` - Confirm payment
- `POST /subscription-cancel` - Cancel subscription

## Models

### PackageModel
- Available packages from admin
- Price per KM, total KM, total price
- Validity period

### UserPackageModel
- User's purchased packages
- Remaining KM, used KM tracking
- Payment status
- Usage progress calculation

### SubscriptionModel
- Recurring ride subscriptions
- Home and destination addresses
- Working days and pickup times
- Trip tracking (completed, remaining, cancelled)
- Driver assignment
- Upcoming rides list

### SubscriptionSettingsModel
- Subscription availability
- KM price for subscriptions
- Min/max subscription days
- Minimum distance requirements

## State Management

All features use Bloc/Cubit pattern:
- Loading states for async operations
- Success states with data
- Error states with messages
- Separate states for different operations

## Payment Flow

### Package Purchase
1. User selects package
2. Choose payment method (Wallet/KNET)
3. If Wallet: Deduct immediately
4. If KNET: Open payment gateway
5. Confirm payment on success
6. Package activated

### Subscription Payment
1. User creates subscription
2. Calculate price based on distance/duration
3. Choose payment method
4. Process payment
5. Wait for admin approval
6. Subscription activated
7. Rides scheduled automatically

## Notes

- All repositories use `apiService` (not `_apiService`)
- Throw standard `Exception` (not `ApiException`)
- API paths use `/endpoint` format (with leading slash)
- No GetX - pure Bloc/Cubit
- Null safety complete
- Dark mode support
- RTL support for Arabic
- 3 languages: English, Arabic, Urdu

## TODO

- [ ] Create presentation pages
- [ ] Create reusable widgets
- [ ] Add translation keys
- [ ] Implement payment gateway integration
- [ ] Add unit tests
- [ ] Add integration tests
