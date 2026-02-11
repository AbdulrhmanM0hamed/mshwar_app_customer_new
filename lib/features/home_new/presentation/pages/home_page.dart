import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../../../core/themes/constant_colors.dart';
import '../../../../core/utils/dark_theme_provider.dart';
import '../../../../generated/app_localizations.dart';
import '../../../../core(new)/utils/widgets/custom_snackbar.dart';
import '../../home_di.dart';
import '../../data/models/location_model.dart';
import '../cubit/location/location_cubit.dart';
import '../cubit/location/location_state.dart';
import '../cubit/vehicle/vehicle_cubit.dart';
import '../cubit/vehicle/vehicle_state.dart';
import '../cubit/map/map_cubit.dart';
import '../widgets/map_widget.dart';
import '../widgets/location_search_widget.dart';
import '../widgets/vehicle_selection_widget.dart';
import 'ride_booking_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final l10n = AppLocalizations.of(context)!;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<LocationCubit>()..getCurrentLocation(),
        ),
        BlocProvider(
          create: (_) => getIt<VehicleCubit>()..loadVehicleCategories(),
        ),
        BlocProvider(
          create: (_) => getIt<MapCubit>(),
        ),
      ],
      child: Scaffold(
        key: _scaffoldKey,
        body: MultiBlocListener(
          listeners: [
            BlocListener<LocationCubit, LocationState>(
              listener: (context, state) {
                if (state is LocationError) {
                  CustomSnackbar.showError(
                    context: context,
                    message: state.message,
                  );
                } else if (state is LocationPermissionDenied) {
                  CustomSnackbar.showError(
                    context: context,
                    message: state.message,
                  );
                } else if (state is LocationServiceDisabled) {
                  CustomSnackbar.showError(
                    context: context,
                    message: state.message,
                  );
                }
              },
            ),
            BlocListener<VehicleCubit, VehicleState>(
              listener: (context, state) {
                if (state is VehicleError) {
                  CustomSnackbar.showError(
                    context: context,
                    message: state.message,
                  );
                }
              },
            ),
          ],
          child: Stack(
            children: [
              // Map
              const MapWidget(),

              // Location Search Widget (Top)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SafeArea(
                  child: LocationSearchWidget(
                    onMenuTap: () {
                      _scaffoldKey.currentState?.openDrawer();
                    },
                    onDestinationSelected: (departure, destination) {
                      _navigateToBooking(departure, destination);
                    },
                  ),
                ),
              ),

              // Vehicle Selection (Bottom)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: BlocBuilder<VehicleCubit, VehicleState>(
                  builder: (context, state) {
                    if (state is VehicleLoading) {
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: themeChange.getThem()
                              ? AppThemeData.surface50Dark
                              : AppThemeData.surface50,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    if (state is VehicleSelected || state is VehicleLoaded) {
                      return const VehicleSelectionWidget();
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToBooking(
    LocationModel departure,
    LocationModel destination,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RideBookingPage(
          departure: departure,
          destination: destination,
        ),
      ),
    );
  }
}
