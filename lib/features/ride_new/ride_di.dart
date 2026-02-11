/// Export wrapper for Ride feature dependency injection
/// 
/// This file provides a clean export interface for the ride feature DI setup.
/// Import this file in main.dart to register all ride dependencies.
/// 
/// Example:
/// ```dart
/// import 'package:cabme/features/ride_new/ride_di.dart';
/// 
/// void main() {
///   setupRideDependencies();
///   runApp(MyApp());
/// }
/// ```

export 'di/ride_service_locator.dart';
