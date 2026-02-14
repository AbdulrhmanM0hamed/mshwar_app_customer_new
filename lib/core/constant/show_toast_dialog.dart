import 'package:flutter_easyloading/flutter_easyloading.dart';

class ShowToastDialog {
  static void showToast(String? message,
      {EasyLoadingToastPosition position = EasyLoadingToastPosition.top}) {
    if (message != null) {
      EasyLoading.showToast(message, toastPosition: position);
    }
  }

  static void showLoader(String message) {
    EasyLoading.show(
      status: message,
      dismissOnTap: false,
      maskType: EasyLoadingMaskType.clear,
    );
  }

  static void closeLoader() {
    EasyLoading.dismiss();
  }
}
