import 'package:cabme/core/constant/constant.dart';
import 'package:cabme/core/themes/constant_colors.dart';
import 'package:cabme/features/settings_new/data/models/settings_model.dart';
import 'package:cabme/features/settings_new/data/repositories/settings_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SettingsRepository repository;

  SettingsCubit({required this.repository}) : super(SettingsInitial());

  Future<void> loadSettings() async {
    emit(SettingsLoading());
    try {
      final settings = await repository.getSettings();

      if (settings.data != null) {
        // Update global constants similar to old SettingsController
        Constant.liveTrackingMapType = settings.data?.mapType ?? "";
        Constant.selectedMapType = settings.data?.mapForApplication != null
            ? '${settings.data?.mapForApplication?.toLowerCase()}'
            : '';

        if (settings.data!.websiteColor != null) {
          AppThemeData.primary200 = Color(int.parse(
              settings.data!.websiteColor!.replaceFirst("#", "0xff")));
        }

        Constant.distanceUnit =
            settings.data?.deliveryDistance ?? Constant.distanceUnit;
        Constant.driverRadius =
            settings.data?.driverRadios ?? Constant.driverRadius;
        Constant.appVersion =
            settings.data?.appVersion?.toString() ?? Constant.appVersion;
        Constant.decimal = settings.data?.decimalDigit ?? Constant.decimal;
        Constant.driverLocationUpdate = settings.data?.driverLocationUpdate ??
            Constant.driverLocationUpdate;
        Constant.allTaxList = settings.data?.taxModel ?? Constant.allTaxList;
        Constant.currency = settings.data?.currency ?? Constant.currency;
        Constant.symbolAtRight =
            settings.data?.symbolAtRight == 'true' ? true : false;

        Constant.kGoogleApiKey = settings.data?.googleMapApiKey?.trim() ?? '';
        final apiKeyValue = Constant.kGoogleApiKey ?? '';
        if (apiKeyValue.isEmpty || apiKeyValue == 'null') {
          log('⚠️ Google API Key is empty or null from backend');
          Constant.kGoogleApiKey = '';
        } else {
          log('✅ Google API Key loaded successfully (length: ${apiKeyValue.length})');
        }

        Constant.contactUsEmail =
            settings.data?.contactUsEmail ?? Constant.contactUsEmail;
        Constant.contactUsAddress =
            settings.data?.contactUsAddress ?? Constant.contactUsAddress;
        Constant.contactUsPhone =
            settings.data?.contactUsPhone ?? Constant.contactUsPhone;
        Constant.rideOtp = settings.data?.showRideOtp ?? Constant.rideOtp;
        Constant.senderId = settings.data?.senderId ?? Constant.senderId;
        Constant.jsonNotificationFileURL =
            settings.data?.serviceJson ?? Constant.jsonNotificationFileURL;

        Constant.showDriverInfoBeforePayment =
            settings.data?.showDriverInfoBeforePayment ?? 'no';
        Constant.passengerCountRequired =
            settings.data?.passengerCountRequired ?? 'optional';
        Constant.homeScreenType = settings.data?.homeScreenType;

        log("HomeScreenType :: ${Constant.homeScreenType} || MapTYpe :: ${Constant.selectedMapType}");
      }

      emit(SettingsLoaded(settings));
    } catch (e) {
      emit(SettingsError(e.toString()));
    }
  }
}
