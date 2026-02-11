import 'dart:async';

import 'package:cabme/common/widget/button.dart';
import 'package:cabme/common/widget/StarRating.dart';
import 'package:cabme/common/widget/custom_alert_dialog.dart';
import 'package:cabme/common/widget/custom_text.dart';
import 'package:cabme/common/widget/text_field_widget.dart';
import 'package:cabme/core/constant/constant.dart';
import 'package:cabme/core/constant/show_toast_dialog.dart';
import 'package:cabme/core/themes/constant_colors.dart';
import 'package:cabme/core/utils/dark_theme_provider.dart';
import 'package:cabme/core/utils/preferences.dart';
import 'package:cabme/generated/app_localizations.dart';
import 'package:cabme/features/ride_new/data/models/ride_model.dart';
import 'package:cabme/features/ride_new/presentation/cubit/active_ride/active_ride_cubit.dart';
import 'package:cabme/features/ride_new/presentation/cubit/active_ride/active_ride_state.dart';
import 'package:cabme/features/ride_new/presentation/widgets/driver_info_bottom_sheet.dart';
import 'package:cabme/features/ride_new/presentation/widgets/driver_notification_popup.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:location/location.dart' as loc;
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

/// Route Map Page - Live map showing driver location and ride route
class RouteMapPage extends StatefulWidget {
  final RideModel ride;

  const RouteMapPage({
    super.key,
    required this.ride,
  });

  @override
  State<RouteMapPage> createState() => _RouteMapPageState();
}

class _RouteMapPageState extends State<RouteMapPage> {
  GoogleMapController? _mapController;
  final Map<String, Marker> _markers = {};
  final Map<PolylineId, Polyline> _polylines = {};
  final PolylinePoints _polylinePoints = PolylinePoints();

  BitmapDescriptor? _departureIcon;
  BitmapDescriptor? _destinationIcon;
  BitmapDescriptor? _taxiIcon;
  BitmapDescriptor? _stopIcon;

  late LatLng _departureLatLng;
  late LatLng _destinationLatLng;

  Timer? _driverLocationTimer;
  bool _showMyLocation = false;
  bool _isDisposed = false;

  final TextEditingController _cancelReasonController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeLocations();
    _loadCustomIcons();
    _startDriverLocationUpdates();
  }

  @override
  void dispose() {
    _isDisposed = true;
    _driverLocationTimer?.cancel();
    _mapController?.dispose();
    _cancelReasonController.dispose();
    super.dispose();
  }

  void _initializeLocations() {
    _departureLatLng = LatLng(
      double.tryParse(widget.ride.pickupLat ?? '0') ?? 0,
      double.tryParse(widget.ride.pickupLng ?? '0') ?? 0,
    );
    _destinationLatLng = LatLng(
      double.tryParse(widget.ride.dropoffLat ?? '0') ?? 0,
      double.tryParse(widget.ride.dropoffLng ?? '0') ?? 0,
    );
  }

  Future<void> _loadCustomIcons() async {
    try {
      _departureIcon = await BitmapDescriptor.asset(
        const ImageConfiguration(size: Size(32, 32)),
        'assets/icons/pickup.png',
      );
      _destinationIcon = await BitmapDescriptor.asset(
        const ImageConfiguration(size: Size(32, 32)),
        'assets/icons/dropoff.png',
      );
      _taxiIcon = await BitmapDescriptor.asset(
        const ImageConfiguration(size: Size(32, 32)),
        'assets/icons/taxi.png',
      );
      _stopIcon = await BitmapDescriptor.asset(
        const ImageConfiguration(size: Size(32, 32)),
        'assets/icons/stopIcon.png',
      );
    } catch (e) {
      debugPrint('Error loading custom icons: $e');
    }

    if (!_isDisposed) {
      _getDirections(dLat: 0, dLng: 0);
    }
  }

  void _startDriverLocationUpdates() {
    // Poll driver location every 10 seconds for active rides
    if (widget.ride.isActive && widget.ride.hasDriver) {
      _driverLocationTimer =
          Timer.periodic(const Duration(seconds: 10), (timer) {
        if (_isDisposed) {
          timer.cancel();
          return;
        }
        context
            .read<ActiveRideCubit>()
            .getDriverLocation(widget.ride.id)
            .then((location) {
          if (location != null && !_isDisposed) {
            _updateDriverMarker(location['lat']!, location['lng']!);
            _getDirections(dLat: location['lat']!, dLng: location['lng']!);
          }
        });
      });
    }
  }

  void _updateDriverMarker(double lat, double lng) {
    if (_isDisposed) return;
    setState(() {
      _markers['Driver'] = Marker(
        markerId: const MarkerId('Driver'),
        position: LatLng(lat, lng),
        icon: _taxiIcon ??
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        infoWindow: InfoWindow(
          title: widget.ride.driverName ?? 'Driver',
        ),
        rotation: 0,
        anchor: const Offset(0.5, 0.5),
      );
    });
  }

  Future<void> _getDirections(
      {required double dLat, required double dLng}) async {
    List<LatLng> polylineCoordinates = [];
    List<PolylineWayPoint> wayPointList = [];

    // Add stop waypoints
    if (widget.ride.stops != null) {
      for (var stop in widget.ride.stops!) {
        if (stop.location != null) {
          wayPointList.add(PolylineWayPoint(location: stop.location!));
        }
      }
    }

    // Setup markers
    if (widget.ride.status != 'completed' && widget.ride.status != 'rejected') {
      _markers['Pickup'] = Marker(
        markerId: const MarkerId('Pickup'),
        infoWindow: const InfoWindow(title: 'Pickup Location'),
        position: _departureLatLng,
        icon: _departureIcon ??
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      );
    }

    _markers['Destination'] = Marker(
      markerId: const MarkerId('Destination'),
      infoWindow: const InfoWindow(title: 'Destination'),
      position: _destinationLatLng,
      icon: _destinationIcon ??
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

    // Add stop markers
    if (widget.ride.stops != null) {
      for (var i = 0; i < widget.ride.stops!.length; i++) {
        final stop = widget.ride.stops![i];
        if (stop.latitude != null && stop.longitude != null) {
          _markers['Stop_$i'] = Marker(
            markerId: MarkerId('Stop_$i'),
            infoWindow: InfoWindow(title: stop.location ?? 'Stop ${i + 1}'),
            position: LatLng(
              double.tryParse(stop.latitude!) ?? 0,
              double.tryParse(stop.longitude!) ?? 0,
            ),
            icon: _stopIcon ?? BitmapDescriptor.defaultMarker,
          );
        }
      }
    }

    // Get route based on ride status
    PolylineResult result;
    try {
      if (widget.ride.status == 'confirmed' && dLat != 0.0 && dLng != 0.0) {
        // Driver coming to pickup
        result = await _polylinePoints.getRouteBetweenCoordinates(
          request: PolylineRequest(
            wayPoints: [],
            optimizeWaypoints: true,
            mode: TravelMode.driving,
            origin: PointLatLng(dLat, dLng),
            destination: PointLatLng(
                _departureLatLng.latitude, _departureLatLng.longitude),
          ),
        );
      } else if (widget.ride.status == 'on ride' &&
          dLat != 0.0 &&
          dLng != 0.0) {
        // On ride: driver to destination
        result = await _polylinePoints.getRouteBetweenCoordinates(
          request: PolylineRequest(
            wayPoints: wayPointList,
            optimizeWaypoints: true,
            mode: TravelMode.driving,
            origin: PointLatLng(dLat, dLng),
            destination: PointLatLng(
                _destinationLatLng.latitude, _destinationLatLng.longitude),
          ),
        );
      } else {
        // Default: pickup to destination
        result = await _polylinePoints.getRouteBetweenCoordinates(
          request: PolylineRequest(
            wayPoints: wayPointList,
            optimizeWaypoints: true,
            mode: TravelMode.driving,
            origin: PointLatLng(
                _departureLatLng.latitude, _departureLatLng.longitude),
            destination: PointLatLng(
                _destinationLatLng.latitude, _destinationLatLng.longitude),
          ),
        );
      }

      if (result.points.isNotEmpty) {
        for (var point in result.points) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        }
      }
    } catch (e) {
      debugPrint('Error getting directions: $e');
    }

    // Fallback: straight line
    if (polylineCoordinates.isEmpty) {
      polylineCoordinates.add(_departureLatLng);
      polylineCoordinates.add(_destinationLatLng);
    }

    _addPolyLine(polylineCoordinates);
  }

  void _addPolyLine(List<LatLng> coordinates) {
    if (coordinates.isEmpty || _isDisposed) return;

    const id = PolylineId('poly');
    final polyline = Polyline(
      polylineId: id,
      color: AppThemeData.primary200,
      points: coordinates,
      width: 6,
      geodesic: true,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
      jointType: JointType.round,
    );
    _polylines[id] = polyline;

    if (mounted) {
      _updateCameraBounds(coordinates.first, coordinates.last);
      setState(() {});
    }
  }

  Future<void> _updateCameraBounds(LatLng source, LatLng destination) async {
    if (_mapController == null) return;

    LatLngBounds bounds;
    if (source.latitude > destination.latitude &&
        source.longitude > destination.longitude) {
      bounds = LatLngBounds(southwest: destination, northeast: source);
    } else if (source.longitude > destination.longitude) {
      bounds = LatLngBounds(
        southwest: LatLng(source.latitude, destination.longitude),
        northeast: LatLng(destination.latitude, source.longitude),
      );
    } else if (source.latitude > destination.latitude) {
      bounds = LatLngBounds(
        southwest: LatLng(destination.latitude, source.longitude),
        northeast: LatLng(source.latitude, destination.longitude),
      );
    } else {
      bounds = LatLngBounds(southwest: source, northeast: destination);
    }

    try {
      await _mapController!
          .animateCamera(CameraUpdate.newLatLngBounds(bounds, 80));
    } on PlatformException catch (e) {
      debugPrint('PlatformException: $e');
    }
  }

  Future<void> _toggleMyLocation() async {
    try {
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        await Geolocator.requestPermission();
      }
      setState(() {
        _showMyLocation = !_showMyLocation;
      });
    } catch (e) {
      debugPrint('Location error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final isDarkMode = themeChange.getThem();
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Stack(
        children: [
          // Google Map
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _departureLatLng,
              zoom: 14,
            ),
            onMapCreated: (controller) {
              _mapController = controller;
            },
            markers: _markers.values.toSet(),
            polylines: Set<Polyline>.of(_polylines.values),
            myLocationEnabled: _showMyLocation,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
          ),

          // Top bar with back button
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCircleButton(
                    icon: Icons.arrow_back_ios_new,
                    isDarkMode: isDarkMode,
                    onTap: () => Navigator.of(context).pop(),
                  ),
                  Row(
                    children: [
                      _buildCircleButton(
                        icon: _showMyLocation
                            ? Iconsax.location5
                            : Iconsax.location,
                        isDarkMode: isDarkMode,
                        onTap: _toggleMyLocation,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Bottom Panel - Driver Info & Actions
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomPanel(isDarkMode, l10n),
          ),
        ],
      ),
    );
  }

  Widget _buildCircleButton({
    required IconData icon,
    required bool isDarkMode,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 44,
        width: 44,
        decoration: BoxDecoration(
          color:
              isDarkMode ? AppThemeData.surface50Dark : AppThemeData.surface50,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          icon,
          size: 20,
          color: isDarkMode ? AppThemeData.grey900Dark : AppThemeData.grey900,
        ),
      ),
    );
  }

  Widget _buildBottomPanel(bool isDarkMode, AppLocalizations l10n) {
    return Container(
      decoration: BoxDecoration(
        color:
            isDarkMode ? AppThemeData.surface50Dark : AppThemeData.surface50,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? AppThemeData.grey400Dark
                      : AppThemeData.grey400,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Driver info row
              if (widget.ride.hasDriver)
                _buildDriverInfoRow(isDarkMode, l10n),

              // OTP display (if available)
              if (widget.ride.otp != null && widget.ride.otp!.isNotEmpty)
                _buildOtpSection(isDarkMode, l10n),

              const SizedBox(height: 12),

              // Action Buttons
              _buildActionButtons(isDarkMode, l10n),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDriverInfoRow(bool isDarkMode, AppLocalizations l10n) {
    return InkWell(
      onTap: () {
        DriverInfoBottomSheet.show(
          context: context,
          ride: widget.ride,
          driverStatus: widget.ride.status == 'confirmed'
              ? 'en-route'
              : widget.ride.status == 'driver_arrived'
                  ? 'arrived'
                  : 'online',
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          children: [
            // Driver photo
            ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: widget.ride.driverPhoto != null &&
                      widget.ride.driverPhoto!.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: widget.ride.driverPhoto!,
                      height: 50,
                      width: 50,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) => Image.asset(
                        'assets/icons/appLogo.png',
                        height: 50,
                        width: 50,
                      ),
                    )
                  : Image.asset(
                      'assets/icons/appLogo.png',
                      height: 50,
                      width: 50,
                    ),
            ),
            const SizedBox(width: 12),
            // Name and rating
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: widget.ride.driverName ?? '',
                    size: 16,
                    weight: FontWeight.w600,
                    color: isDarkMode
                        ? AppThemeData.grey900Dark
                        : AppThemeData.grey900,
                  ),
                  const SizedBox(height: 4),
                  StarRating(
                    size: 16,
                    rating: widget.ride.driverRatingValue,
                    color: AppThemeData.warning200,
                  ),
                ],
              ),
            ),
            // Action buttons
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.ride.status == 'confirmed')
                  _buildActionIcon(
                    Iconsax.message,
                    AppThemeData.primary200,
                    () {
                      Navigator.of(context).pushNamed(
                        '/chat',
                        arguments: {
                          'receiverId': widget.ride.driverId,
                          'orderId': widget.ride.id,
                          'receiverName': widget.ride.driverName,
                          'receiverPhoto': widget.ride.driverPhoto,
                        },
                      );
                    },
                  ),
                const SizedBox(width: 8),
                if (widget.ride.status != 'rejected')
                  _buildActionIcon(
                    Iconsax.share,
                    AppThemeData.secondary200,
                    () async {
                      ShowToastDialog.showLoader(l10n.pleaseWait);
                      final location = await loc.Location().getLocation();
                      ShowToastDialog.closeLoader();
                      await Share.share(
                        'https://www.google.com/maps/search/?api=1&query=${location.latitude},${location.longitude}',
                      );
                    },
                  ),
                const SizedBox(width: 8),
                _buildActionIcon(
                  Iconsax.call,
                  AppThemeData.warning200,
                  () {
                    Constant.makePhoneCall(widget.ride.driverPhone ?? '');
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionIcon(
      IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
        child: Icon(
          icon,
          size: 20,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildOtpSection(bool isDarkMode, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppThemeData.primary200.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppThemeData.primary200.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Iconsax.shield_tick, color: AppThemeData.primary200, size: 20),
          const SizedBox(width: 8),
          CustomText(
            text: '${l10n.otp}: ',
            size: 14,
            weight: FontWeight.w500,
            color: AppThemeData.primary200,
          ),
          CustomText(
            text: widget.ride.otp ?? '',
            size: 20,
            weight: FontWeight.bold,
            color: AppThemeData.primary200,
            letterSpacing: 4,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(bool isDarkMode, AppLocalizations l10n) {
    return Row(
      children: [
        // "I don't feel safe" button - only on ride
        if (widget.ride.status == 'on ride')
          Expanded(
            child: CustomButton(
              btnName: l10n.iDoNotFeelSafe,
              buttonColor: AppThemeData.warning200,
              textColor: Colors.white,
              borderRadius: 12,
              ontap: () async {
                final location = await loc.Location().getLocation();
                final bodyParams = {
                  'lat': location.latitude,
                  'lng': location.longitude,
                  'user_id':
                      Preferences.getInt(Preferences.userId).toString(),
                  'feel_safe': 0,
                  'trip_id': widget.ride.id,
                };
                context
                    .read<ActiveRideCubit>()
                    .reportSafety(bodyParams);
              },
            ),
          ),
        if (widget.ride.status == 'on ride') const SizedBox(width: 10),
        // Cancel ride button - visible when not rejected
        if (widget.ride.status != 'rejected' &&
            widget.ride.status != 'completed')
          Expanded(
            child: CustomButton(
              btnName: l10n.cancelRide,
              buttonColor: AppThemeData.error200,
              textColor: Colors.white,
              borderRadius: 12,
              ontap: () => _showCancelBottomSheet(isDarkMode, l10n),
            ),
          ),
      ],
    );
  }

  Future<void> _showCancelBottomSheet(
      bool isDarkMode, AppLocalizations l10n) {
    return showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(15),
          topLeft: Radius.circular(15),
        ),
      ),
      context: context,
      isDismissible: true,
      isScrollControlled: true,
      backgroundColor:
          isDarkMode ? AppThemeData.surface50Dark : AppThemeData.surface50,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 15.0, vertical: 10),
              child: Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: CustomText(
                        text: l10n.cancelTrip,
                        size: 18,
                        weight: FontWeight.w600,
                        color: isDarkMode
                            ? AppThemeData.grey900Dark
                            : AppThemeData.grey900,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: CustomText(
                        text: l10n.writeCancelReason,
                        size: 14,
                        color: isDarkMode
                            ? AppThemeData.grey400
                            : AppThemeData.grey300Dark,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: TextFieldWidget(
                        maxLine: 3,
                        controller: _cancelReasonController,
                        hintText: '',
                        fontSize: 14,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              btnName: l10n.cancelTrip,
                              buttonColor: AppThemeData.error200,
                              textColor: Colors.white,
                              borderRadius: 8,
                              ontap: () {
                                if (_cancelReasonController
                                    .text.isNotEmpty) {
                                  Navigator.of(context).pop();
                                  _confirmCancelRide(isDarkMode, l10n);
                                } else {
                                  ShowToastDialog.showToast(
                                      l10n.pleaseEnterReason);
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: CustomButton(
                              btnName: l10n.close,
                              buttonColor: isDarkMode
                                  ? AppThemeData.grey800Dark
                                  : AppThemeData.grey200,
                              textColor: AppThemeData.primary200,
                              borderRadius: 8,
                              ontap: () =>
                                  Navigator.of(context).pop(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _confirmCancelRide(bool isDarkMode, AppLocalizations l10n) {
    showDialog(
      barrierColor: Colors.black26,
      context: context,
      builder: (dialogContext) {
        return CustomAlertDialog(
          title: l10n.doYouWantToCancel,
          onPressNegative: () => Navigator.of(dialogContext).pop(),
          onPressPositive: () {
            Navigator.of(dialogContext).pop();
            final bodyParams = {
              'id_ride': widget.ride.id,
              'id_user': widget.ride.driverId ?? '',
              'name': widget.ride.userName ?? '',
              'from_id':
                  Preferences.getInt(Preferences.userId).toString(),
              'reason': _cancelReasonController.text,
            };
            context.read<ActiveRideCubit>().cancelRide(bodyParams);
            Navigator.of(context).pop(); // Close map page
          },
        );
      },
    );
  }
}
