import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../service_locator.dart';
import '../../../../common/widget/button.dart';
import '../../../../common/widget/custom_text.dart';
import '../../../../core/themes/constant_colors.dart';
import '../../../../core/utils/dark_theme_provider.dart';
import '../../../../generated/app_localizations.dart';
import '../../../../core(new)/utils/widgets/custom_snackbar.dart';
import '../../../../features/home/controller/dash_board_controller.dart';
import '../cubit/location/location_cubit.dart';
import '../cubit/location/location_state.dart';
import '../cubit/vehicle/vehicle_cubit.dart';
import '../cubit/vehicle/vehicle_state.dart';
import '../cubit/map/map_cubit.dart';
import '../cubit/booking/booking_cubit.dart';
import '../widgets/map_widget.dart';
import '../widgets/location_search_widget.dart';
import '../widgets/vehicle_selection_widget.dart';
import '../widgets/multi_stop_widget.dart';
import './ride_booking_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final DashBoardController dashBoardController =
      Get.put(DashBoardController());

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final l10n = AppLocalizations.of(context)!;
    final isDarkMode = themeChange.getThem();

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
        BlocProvider(
          create: (_) => getIt<BookingCubit>(),
        ),
      ],
      child: Scaffold(
        key: _scaffoldKey,
        drawer: buildAppDrawer(context, dashBoardController),
        backgroundColor: themeChange.getThem()
            ? AppThemeData.surface50Dark
            : AppThemeData.surface50,
        body: MultiBlocListener(
          listeners: [
            BlocListener<LocationCubit, LocationState>(
              listener: (context, state) {
                if (state is LocationError) {
                  CustomSnackbar.showError(
                      context: context, message: state.message);
                } else if (state is LocationLoaded) {
                  final bookingCubit = context.read<BookingCubit>();
                  if (bookingCubit.state.departure == null) {
                    bookingCubit.updateDeparture(state.location);
                  }
                }
              },
            ),
            BlocListener<VehicleCubit, VehicleState>(
              listener: (context, state) {
                if (state is VehicleError) {
                  CustomSnackbar.showError(
                      context: context, message: state.message);
                } else if (state is VehicleSelected) {
                  context
                      .read<BookingCubit>()
                      .updateVehicle(state.selectedVehicle);
                }
              },
            ),
            BlocListener<BookingCubit, BookingState>(
              listener: (context, state) {
                if (state.departure != null && state.destination != null) {
                  // Trigger route drawing on map
                  context.read<MapCubit>().drawRoute(
                        origin: LatLng(state.departure!.latitude,
                            state.departure!.longitude),
                        destination: LatLng(state.destination!.latitude,
                            state.destination!.longitude),
                        waypoints: state.stops
                            .map((s) => LatLng(s.latitude, s.longitude))
                            .toList(),
                      );
                }
              },
            ),
          ],
          child: Column(
            children: [
              // 1. Top Section: Map with Floating Button
              Expanded(
                child: Stack(
                  children: [
                    const MapWidget(),

                    // Floating search bar (old style compatibility)
                    Positioned(
                      top: 16,
                      left: 16,
                      right: 16,
                      child: SafeArea(
                        bottom: false,
                        child:
                            _buildFloatingSearchBar(context, isDarkMode, l10n),
                      ),
                    ),

                    // Zoom / GPS buttons
                    Positioned(
                      bottom: 16,
                      right: 16,
                      child: Column(
                        children: [
                          _ZoomButton(
                            icon: Icons.add,
                            onTap: () => context.read<MapCubit>().zoomIn(),
                            isDarkMode: isDarkMode,
                          ),
                          const SizedBox(height: 8),
                          _ZoomButton(
                            icon: Icons.remove,
                            onTap: () => context.read<MapCubit>().zoomOut(),
                            isDarkMode: isDarkMode,
                          ),
                          const SizedBox(height: 8),
                          _ZoomButton(
                            icon: Iconsax.gps,
                            onTap: () => context
                                .read<LocationCubit>()
                                .getCurrentLocation(),
                            isDarkMode: isDarkMode,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // 2. Bottom Section: Search Panel and Vehicle Selection
              Container(
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? AppThemeData.surface50Dark
                      : AppThemeData.surface50,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const LocationSearchWidget(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: BlocBuilder<BookingCubit, BookingState>(
                        builder: (context, state) {
                          return MultiStopWidget(
                            isDarkMode: isDarkMode,
                            stops: state.stops,
                            onStopsChanged: (stops) {
                              context.read<BookingCubit>().updateStops(stops);
                            },
                          );
                        },
                      ),
                    ),
                    const VehicleSelectionWidget(),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: BlocBuilder<BookingCubit, BookingState>(
                        builder: (context, state) {
                          bool canContinue = state.departure != null &&
                              state.destination != null &&
                              state.selectedVehicle != null;

                          return CustomButton(
                            btnName: l10n.bookRide,
                            ontap: canContinue
                                ? () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => MultiBlocProvider(
                                          providers: [
                                            BlocProvider.value(
                                              value:
                                                  context.read<VehicleCubit>(),
                                            ),
                                            BlocProvider.value(
                                              value:
                                                  context.read<BookingCubit>(),
                                            ),
                                          ],
                                          child: RideBookingPage(
                                            departure: state.departure!,
                                            destination: state.destination!,
                                            stops: state.stops,
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                : null,
                            buttonColor: canContinue
                                ? AppThemeData.primary200
                                : AppThemeData.grey300,
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingSearchBar(
      BuildContext context, bool isDarkMode, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDarkMode ? AppThemeData.surface50Dark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => _scaffoldKey.currentState?.openDrawer(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppThemeData.primary200.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Iconsax.menu,
                size: 20,
                color: AppThemeData.primary200,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: CustomText(
              text: l10n.whereToGo,
              size: 15,
              weight: FontWeight.w500,
              color:
                  isDarkMode ? AppThemeData.grey400Dark : AppThemeData.grey400,
            ),
          ),
          Icon(
            Iconsax.search_normal,
            size: 20,
            color: AppThemeData.primary200,
          ),
        ],
      ),
    );
  }
}

class _ZoomButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isDarkMode;

  const _ZoomButton({
    required this.icon,
    required this.onTap,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color:
              isDarkMode ? AppThemeData.surface50Dark : AppThemeData.surface50,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: AppThemeData.primary200,
          size: 24,
        ),
      ),
    );
  }
}
