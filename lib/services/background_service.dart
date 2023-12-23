import 'dart:developer';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:marathon/main.dart';
import 'package:marathon/services/notification_service.dart';
import 'package:marathon/utils/app_constant.dart';

class BackgroundService {
  BackgroundService._();
  static BackgroundService _instance = BackgroundService._();
  factory BackgroundService() => _instance;
  final service = FlutterBackgroundService();

  init() async {
    bool? hasPermission = await NotificationService.notificationServiceService.requestPermission();
    if (hasPermission == null || hasPermission == false) {
      return;
    }
    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        autoStart: false,
        isForegroundMode: true,
        notificationChannelId: NotificationService.TRACKING_NOTIFICATION_CHANNEL_ID,
        initialNotificationTitle: AppConstant.APP_NAME,
        initialNotificationContent: 'Keep cycling to track your activity',
        foregroundServiceNotificationId: 100,
      ),
      iosConfiguration: IosConfiguration(),
    );
  }

  startService() async {
    bool isServiceRunning = await service.isRunning();
    log("service is running $isServiceRunning");
    if (!isServiceRunning) {
      await service.startService();
    } else {
      service.invoke("stop");
    }
  }
}
