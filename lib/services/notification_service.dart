// ignore_for_file: constant_identifier_names

import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {

  static const String TRACKING_NOTIFICATION_CHANNEL_ID = "100";

  static NotificationService notificationServiceService = NotificationService._();
  NotificationService._();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    await _createNotificationChannel();
    initializeNotification();
  }

  Future<bool?> requestPermission() async {
    if (Platform.isAndroid) {
      return await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
    }
    if (Platform.isIOS) {
      return await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions();
    }
    return null;
  }

  initializeNotification() async {
    await requestPermission();

    final AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings();
    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel trackingNotificationChannel = AndroidNotificationChannel(
      TRACKING_NOTIFICATION_CHANNEL_ID,
      'Tracking',
      description: 'This channel is used to show tracking information',
      importance: Importance.high,
    );
    const AndroidNotificationChannel generalChannel = AndroidNotificationChannel(
      "101",
      'General',
      description: 'This channel is used to general Information',
      importance: Importance.high,
    );

    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(trackingNotificationChannel);
    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(generalChannel);
  }
}
