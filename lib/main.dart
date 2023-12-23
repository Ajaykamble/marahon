import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:marathon/config/theme/app_theme.dart';
import 'package:marathon/firebase_options.dart';
import 'package:marathon/screen/home_screen.dart';
import 'package:marathon/services/background_service.dart';
import 'package:marathon/services/location_service.dart';
import 'package:marathon/services/notification_service.dart';
import 'package:marathon/viewModel/userProvider.dart';
import 'package:provider/provider.dart';

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  service.on("stop").listen((event) async {
    await service.stopSelf();
  });
  log("called");
  print("Called");
  Timer.periodic(Duration(seconds: 10), (timer) async {
    Position position = await Geolocator.getCurrentPosition();

    final DatabaseReference databaseReference = FirebaseDatabase.instance.ref();

    // Store location data in Firebase Realtime Database
    databaseReference.child('locations').push().set({
      'latitude': position.latitude,
      'longitude': position.longitude,
      'timestamp': DateTime.now().toUtc().toString(),
    }).then((_) {
      log('Location data stored successfully');
    }).catchError((error) {
      log('Failed to store location data: $error');
    });
  });
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
      ],
      builder: (context, child) => Builder(
        builder: (context) {
          return MaterialApp(
            title: 'Marathon',
            theme: AppTheme.light(context),
            darkTheme: AppTheme.light(context),
            themeMode: ThemeMode.light,
            home: HomeScreen(),
          );
        },
      ),
    );
  }
}
