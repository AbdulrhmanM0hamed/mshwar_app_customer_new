import 'package:cabme/common/widget/my_custom_dialog.dart';
import 'package:cabme/core/constant/show_toast_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';

class LocationPermissionDisclosureDialog extends StatelessWidget {
  const LocationPermissionDisclosureDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return MyCustomDialog(
      title: 'Location Access Disclosure',
      message:
          'We need access to your location to assign for booking feature.\n\nThis information will only be used for booking purpose and will not be shared with any third parties.',
      confirmText: 'Accept',
      cancelText: 'Decline',
      onConfirm: () {
        _requestLocationPermission(context);
      },
      onCancel: () {
        SystemNavigator.pop();
      },
    );
  }

  // Method to request location permission using permission_handler package
  void _requestLocationPermission(BuildContext context) async {
    PermissionStatus location = await Location().requestPermission();
    if (location == PermissionStatus.granted) {
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    } else {
      ShowToastDialog.showToast("Permission Denied");
    }
  }
}
