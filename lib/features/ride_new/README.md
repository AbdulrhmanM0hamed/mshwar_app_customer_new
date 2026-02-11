# Ride Management Feature (New Architecture)

Clean Architecture implementation for ride management, chat, reviews, and complaints.

## Structure

```
ride_new/
├── data/
│   ├── models/
│   │   ├── ride_model.dart              # Active ride models
│   │   ├── ride_history_model.dart      # Past rides
│   │   ├── chat_message_model.dart      # Chat messages
│   │   ├── review_model.dart            # Ride reviews
│   │   └── complaint_model.dart         # Complaints
│   └── repositories/
│       ├── ride_repository.dart         # Ride operations
│       ├── chat_repository.dart         # Chat operations
│       ├── review_repository.dart       # Review operations
│       └── complaint_repository.dart    # Complaint operations
├── presentation/
│   ├── cubit/
│   │   ├── active_ride/                 # Active ride management
│   │   ├── ride_history/                # Past rides
│   │   ├── chat/                        # Chat with driver
│   │   ├── review/                      # Add review
│   │   └── complaint/                   # Add complaint
│   ├── pages/
│   │   ├── active_rides_page.dart       # Current/scheduled rides
│   │   ├── ride_details_page.dart       # Ride details & tracking
│   │   ├── ride_history_page.dart       # Past rides
│   │   ├── chat_page.dart               # Chat with driver
│   │   ├── add_review_page.dart         # Add review
│   │   └── add_complaint_page.dart      # Add complaint
│   └── widgets/
│       ├── ride_card.dart               # Ride list item
│       ├── driver_info_widget.dart      # Driver information
│       ├── ride_status_widget.dart      # Status indicator
│       ├── chat_message_widget.dart     # Chat message bubble
│       └── rating_widget.dart           # Star rating
├── di/
│   └── ride_service_locator.dart        # Dependency injection
├── ride_di.dart                         # Export wrapper
└── README.md                            # This file
```

## Features

### Active Rides
- View current ride status
- Track driver location in real-time
- View scheduled rides
- Cancel rides
- Contact driver

### Ride History
- View past rides
- Filter by date/status
- View ride details
- Download invoice/receipt

### Chat
- Real-time chat with driver
- Send text messages
- Send images
- View message history

### Reviews
- Rate driver (1-5 stars)
- Add written review
- Rate vehicle condition
- Rate punctuality

### Complaints
- Submit complaint about ride
- Add description and evidence
- Track complaint status

## Setup

### 1. Register Dependencies

In `main.dart`:

```dart
import 'package:cabme/features/ride_new/ride_di.dart';

void main() async {
  // ... core setup ...
  
  setupRideDependencies();
  
  runApp(MyApp());
}
```

### 2. Use Cubits in Pages

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cabme/features/ride_new/presentation/cubit/active_ride/active_ride_cubit.dart';

class ActiveRidesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ActiveRideCubit>()..loadActiveRides(),
      child: BlocBuilder<ActiveRideCubit, ActiveRideState>(
        builder: (context, state) {
          // Build UI based on state
        },
      ),
    );
  }
}
```

## API Endpoints

### Rides
- `GET /active-rides` - Get current/scheduled rides
- `GET /ride-history` - Get past rides
- `GET /ride-details/{id}` - Get ride details
- `POST /cancel-ride` - Cancel a ride
- `GET /driver-location/{rideId}` - Get driver location updates

### Chat
- `GET /ride-chat/{rideId}` - Get chat messages
- `POST /send-message` - Send chat message
- `POST /upload-chat-image` - Upload image to chat

### Reviews
- `POST /add-review` - Submit ride review
- `GET /ride-reviews/{rideId}` - Get ride reviews

### Complaints
- `POST /add-complaint` - Submit complaint
- `GET /my-complaints` - Get user complaints
- `GET /complaint-details/{id}` - Get complaint details

## Models

### RideModel
- Current and scheduled rides
- Driver information
- Pickup/dropoff locations
- Status tracking
- Real-time updates

### RideHistoryModel
- Past completed rides
- Payment information
- Duration and distance
- Invoice/receipt data

### ChatMessageModel
- Text messages
- Image messages
- Timestamps
- Read status

### ReviewModel
- Star rating (1-5)
- Written review
- Driver rating
- Vehicle rating

### ComplaintModel
- Complaint type
- Description
- Evidence (images)
- Status tracking

## State Management

All features use Bloc/Cubit pattern:
- Loading states for async operations
- Success states with data
- Error states with messages
- Real-time update states

## Real-time Features

### Driver Location Tracking
- Firebase Realtime Database for live location
- Polyline drawing on map
- ETA calculations

### Chat
- Firebase Realtime Database for messages
- Real-time message delivery
- Read receipts

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

- [ ] Create all models
- [ ] Create all repositories
- [ ] Create all cubits with states
- [ ] Create all pages
- [ ] Create all widgets
- [ ] Add translation keys
- [ ] Implement real-time tracking
- [ ] Add unit tests
- [ ] Add integration tests
