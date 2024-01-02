import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_activity_recognition/flutter_activity_recognition.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:marathon/config/theme/app_theme.dart';
import 'package:marathon/firebase_options.dart';
import 'package:marathon/screen/home_screen.dart';
import 'package:marathon/screen/splash_screen.dart';
import 'package:marathon/services/background_service.dart';
import 'package:marathon/services/local_db_service.dart';
import 'package:marathon/services/location_service.dart';
import 'package:marathon/services/notification_service.dart';
import 'package:marathon/services/user/user_service.dart';
import 'package:marathon/utils/app_constant.dart';
import 'package:marathon/utils/app_values.dart';
import 'package:marathon/viewModel/homeProvider.dart';
import 'package:marathon/viewModel/userProvider.dart';
import 'package:provider/provider.dart';

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  log("ONSTART");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await LocalDbService().init();

  final activityRecognition = FlutterActivityRecognition.instance;

  StreamSubscription<Activity> activityStream = activityRecognition.activityStream.listen((event) async {
    log("EVENT CHANGED ${event.type.name} ${event.confidence.name}");
    bool isLoggedIn = LocalDbService.db.isSignedIn();
    if (isLoggedIn) {
      String? trackingId = LocalDbService.db.getDetails(AppConstant.TRACKING_ID);
      String? userId = UserProvider().userDetail?.userid;
      String marathonId = "1";
      if (trackingId != null && userId != null) {
        try {
          await UserService().trackActivity(userId: userId, trackingId: trackingId, marathonId: marathonId, activity: event.type.name);
        } catch (e) {
          log("error: $e");
        }
      }
    }
  });

  StreamSubscription<Position> positionStream = Geolocator.getPositionStream(
      locationSettings: LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 1,
  )).listen((Position position) async {
    log("message: ${position.latitude} ${position.longitude}");
    bool isLoggedIn = LocalDbService.db.isSignedIn();
    if (isLoggedIn) {
      String? trackingId = LocalDbService.db.getDetails(AppConstant.TRACKING_ID);
      String? userId = UserProvider().userDetail?.userid;
      String marathonId = "1";
      if (trackingId != null && userId != null) {
        try {
          await UserService().trackLocation(
            userId: userId,
            trackingId: trackingId,
            marathonId: marathonId,
            latitude: position.latitude,
            longitude: position.longitude,
          );
        } catch (e) {
          log("error: $e");
        }
      }
    }
  });
  service.on("stop").listen((event) async {
    await service.stopSelf();
    positionStream.cancel();
    activityStream.cancel();
  });

  /* Timer.periodic(const Duration(seconds: 10), (timer) async {
    Position position = await Geolocator.getCurrentPosition();
    log("message: ${position.latitude} ${position.longitude}");
    bool isLoggedIn = LocalDbService.db.isSignedIn();
    if (isLoggedIn) {
      String? trackingId = LocalDbService.db.getDetails(AppConstant.TRACKING_ID);
      String? userId = UserProvider().userDetail?.userid;
      String marathonId = "1";
      if (trackingId != null && userId != null) {
        try {
          await UserService().trackLocation(
            userId: userId,
            trackingId: trackingId,
            marathonId: marathonId,
            latitude: position.latitude,
            longitude: position.longitude,
          );
        } catch (e) {
          log("error: $e");
        }
      }
    }
  }); */
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await LocalDbService().init();
  await NotificationService.notificationServiceService.init();
  await BackgroundService().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => BackgroundService()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
      ],
      builder: (context, child) => Builder(
        builder: (context) {
          return MaterialApp(
            title: 'Marathon',
            theme: AppTheme.light(context),
            darkTheme: AppTheme.light(context),
            themeMode: ThemeMode.light,
            home: const SplashScreen(),
            scaffoldMessengerKey: AppValues.scaffoldMessengerKey,
          );
        },
      ),
    );
  }
}
