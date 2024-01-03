import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:marathon/main.dart';
import 'package:marathon/services/local_db_service.dart';
import 'package:marathon/services/location_service.dart';
import 'package:marathon/services/notification_service.dart';
import 'package:marathon/utils/app_constant.dart';
import 'package:marathon/utils/common_functions.dart';
import 'package:marathon/utils/enums.dart';
import 'package:uuid/uuid.dart';
import 'package:wakelock/wakelock.dart';

class BackgroundService extends ChangeNotifier {
  BackgroundService._();

  static BackgroundService _instance = BackgroundService._();
  factory BackgroundService() => _instance;
  final service = FlutterBackgroundService();

  bool _isServiceRunning = false;
  ApiStatus _trackingStatus = ApiStatus.SUCCESS;

  ApiStatus get trackingStatus => _trackingStatus;
  bool get isServiceRunning => _isServiceRunning;

  set trackingStatus(ApiStatus value) {
    _trackingStatus = value;
    notifyListeners();
  }

  set isServiceRunning(bool value) {
    _isServiceRunning = value;
    notifyListeners();
  }

  resetProvider() {
    _trackingStatus = ApiStatus.SUCCESS;
  }

  init() async {
    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        autoStart: false,
        autoStartOnBoot: false,
        isForegroundMode: true,
        notificationChannelId: NotificationService.TRACKING_NOTIFICATION_CHANNEL_ID,
        initialNotificationTitle: AppConstant.APP_NAME,
        initialNotificationContent: 'Keep cycling to track your activity',
        foregroundServiceNotificationId: 100,
      ),
      iosConfiguration: IosConfiguration(),
    );
    _isServiceRunning = await service.isRunning();
  }

  Future<String?> startService(String dropdownvalue) async {
    trackingStatus = ApiStatus.LOADING;
    String? message;
    bool? hasNotificationPermission = await NotificationService.notificationServiceService.requestPermission();
    log("hasNotificationPermission: $hasNotificationPermission");
    if (hasNotificationPermission != null && hasNotificationPermission) {
      bool isRunning = await service.isRunning();
      if (!isRunning) {
        Uuid uuid = Uuid();
        String trackingId = uuid.v4();
        log("Tracking Id: $trackingId");
        LocalDbService.db.saveDetails(AppConstant.TRACKING_ID, trackingId);
        LocalDbService.db.saveDetails(AppConstant.TRACKING_TYPE, dropdownvalue);
        await service.startService();
        await Wakelock.enable();
        isServiceRunning = true;
        CommonFunctions.toastMessage("Tracking Started");
      } else {
        service.invoke("stop");
        await Wakelock.disable();
        isServiceRunning = false;
        CommonFunctions.toastMessage("Tracking Stopped");
      }
    } else {
      CommonFunctions.toastMessage("Notification permission is not granted");
      message = "Notification permission is not granted";
    }
    trackingStatus = ApiStatus.SUCCESS;
    return message;
  }
}
