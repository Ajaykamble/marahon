import 'dart:async';

import 'package:flutter/material.dart';
import 'package:marathon/screen/home_screen.dart';
import 'package:marathon/screen/login_screen.dart';
import 'package:marathon/services/local_db_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    splashTimer();
  }

  Timer? _timer;
  int _start = 1;

  void splashTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          cancelTimer();
          redirectToNextScreen();
        } else {
          _start--;
        }
      },
    );
  }

  redirectToNextScreen() async {
    bool alreadySignedIn = await LocalDbService.db.isSignedIn();
    if (alreadySignedIn) {
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => HomeScreen()), (route) => false);
      }
    } else {
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => LoginScreen()), (route) => false);
      }
    }
  }

  cancelTimer() {
    if (_timer != null) {
      _timer?.cancel();
    }
  }

  @override
  void dispose() {
    cancelTimer();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: const Center(
      child: Text('Splash Screen'),
    ));
  }
}
