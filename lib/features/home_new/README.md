# Home Feature - Clean Architecture

## 📖 Overview

This is a complete refactoring of the home feature using Clean Architecture principles, following the same pattern as `authentication_new`.

## 🏗️ Architecture

### Layers

1. **Data Layer** (`data/`)
   - Models: Data structures
   - Repositories: Data access and business logic

2. **Presentation Layer** (`presentation/`)
   - Cubits: State management
   - Pages: UI screens
   - Widgets: Reusable UI components

3. **Dependency Injection** (`home_di.dart`)
   - Setup and configuration

## 📁 Structure

```
lib/features/home_new/
├── data/
│   ├── models/
│   │   ├── location_model.dart
│   │   ├── vehicle_category_model.dart
│   │   ├── driver_model.dart
│   │   ├── price_calculation_model.dart
│   │   ├── ride_request_model.dart
│   │   ├── ride_response_model.dart
│   │   └── booking_confirmation_model.dart
│   └── repositories/
│       ├── location_repository.dart
│       ├── vehicle_repository.dart
│       ├── ride_repository.dart
│       └── map_repository.dart
├── presentation/
│   ├── cubit/
│   │   ├── location/
│   │   │   ├── location_cubit.dart
│   │   │   └── location_state.dart
│   │   ├── vehicle/
│   │   │   ├── vehicle_cubit.dart
│   │   │   └── vehicle_state.dart
│   │   ├── ride/
│   │   │   ├── ride_cubit.dart
│   │   │   └── ride_state.dart
│   │   └── map/
│   │       ├── map_cubit.dart
│   │       └── map_state.dart
│   ├── pages/
│   │   └── (to be created)
│   └── widgets/
│       └── (to be created)
├── home_di.dart
└── README.md
```

## 🚀 Getting Started

### 1. Setup Dependencies

Add to `main.dart`:

```dart
import 'features/home_new/home_di.dart';

void main() {
  // ... other setup
  setupHomeDependencies();
  runApp(MyApp());
}
```

### 2. Usage in Widget

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/home_new/home_di.dart';
import 'features/home_new/presentation/cubit/location/location_cubit.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<LocationCubit>()..getCurrentLocation(),
      child: BlocBuilder<LocationCubit, LocationState>(
        builder: (context, state) {
          if (state is LocationLoading) {
            return CircularProgressIndicator();
          }
          
          if (state is LocationLoaded) {
            return Text('Location: ${state.location.address}');
          }
          
          if (state is LocationError) {
            return Text('Error: ${state.message}');
          }
          
          return SizedBox();
        },
      ),
    );
  }
}
```

## 📚 Features

### Location Management
- Get current GPS location
- Search for addresses
- Geocoding and reverse geocoding
- Permission handling

### Vehicle Management
- Load available vehicle categories
- Select vehicle type
- Get vehicle pricing

### Ride Management
- Calculate ride price
- Find available drivers
- Book rides (immediate or scheduled)
- Support for multi-stop rides
- Package KM integration
- Coupon code support

### Map Management
- Draw routes on map
- Add/remove markers
- Animate camera
- Calculate distances

## 🔧 API Endpoints

### Location
- `GET /api/v1/geocode` - Geocode address
- `GET /api/v1/reverse-geocode` - Reverse geocode

### Vehicle
- `GET /api/v1/vehicle-categories` - Get all categories
- `GET /api/v1/vehicle-categories/:id` - Get by ID

### Ride
- `POST /api/v1/ride/calculate-price` - Calculate price
- `POST /api/v1/ride/find-drivers` - Find drivers
- `POST /api/v1/ride/book` - Book ride
- `GET /api/v1/ride/:id/confirm` - Confirm booking
- `POST /api/v1/ride/:id/cancel` - Cancel ride

## 💡 Examples

### Calculate Ride Price

```dart
final rideCubit = getIt<RideCubit>();

await rideCubit.calculatePrice(
  departureLat: 29.3117,
  departureLng: 47.4818,
  destinationLat: 29.3759,
  destinationLng: 47.9774,
  vehicleCategoryId: '1',
  couponCode: 'SAVE10',
  usePackageKm: false,
);

// Listen to state
BlocListener<RideCubit, RideState>(
  listener: (context, state) {
    if (state is RidePriceCalculated) {
      print('Price: ${state.priceCalculation.finalPrice}');
    }
  },
);
```

### Book a Ride

```dart
final request = RideRequestModel(
  departure: LocationModel(
    latitude: 29.3117,
    longitude: 47.4818,
    address: 'Kuwait City',
  ),
  destination: LocationModel(
    latitude: 29.3759,
    longitude: 47.9774,
    address: 'Salmiya',
  ),
  vehicleCategoryId: '1',
  paymentMethodId: '5',
  numberOfPassengers: 2,
  scheduledTime: DateTime.now().add(Duration(hours: 2)),
);

await rideCubit.bookRide(request);
```

### Draw Route on Map

```dart
final mapCubit = getIt<MapCubit>();

await mapCubit.drawRoute(
  origin: LatLng(29.3117, 47.4818),
  destination: LatLng(29.3759, 47.9774),
  waypoints: [
    LatLng(29.3500, 47.8000), // Stop 1
  ],
);
```

## 🧪 Testing

### Unit Tests

```dart
void main() {
  group('RideCubit', () {
    late RideCubit rideCubit;
    late MockRideRepository mockRepository;

    setUp(() {
      mockRepository = MockRideRepository();
      rideCubit = RideCubit(repository: mockRepository);
    });

    test('calculate price emits correct states', () async {
      // Arrange
      when(() => mockRepository.calculatePrice(...))
          .thenAnswer((_) async => mockPriceCalculation);

      // Act
      rideCubit.calculatePrice(...);

      // Assert
      await expectLater(
        rideCubit.stream,
        emitsInOrder([
          RideCalculating(),
          RidePriceCalculated(mockPriceCalculation),
        ]),
      );
    });
  });
}
```

## 🎨 Design Principles

1. **Single Responsibility** - Each class has one job
2. **Dependency Inversion** - Depend on abstractions
3. **Open/Closed** - Open for extension, closed for modification
4. **Interface Segregation** - Small, focused interfaces
5. **DRY** - Don't Repeat Yourself

## 📝 Notes

- Use `AppLocalizations` for all text (no `.tr`)
- Use `CustomSnackbar` with named parameters
- Handle all errors gracefully
- Support Arabic, English, and Urdu
- Follow Material Design 3 guidelines

## 🔗 Related Features

- `authentication_new` - Authentication with Clean Architecture
- `payment` - Payment integration
- `ride` - Ride tracking and management
- `plans` - Subscription and package management

## 📞 Support

For questions or issues, refer to:
- `HOME_REFACTORING_PLAN.md` - Complete refactoring plan
- `HOME_NEW_IMPLEMENTATION_SUMMARY.md` - Implementation details
- `QUICK_REFERENCE_LOCALIZATION.md` - Localization guide
