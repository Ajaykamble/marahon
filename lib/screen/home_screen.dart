import 'package:flutter/material.dart';
import 'package:marathon/services/background_service.dart';
import 'package:marathon/services/location_service.dart';
import 'package:marathon/widget/primary_filled_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  startTracking() async {
    int status = await LocationService.locationServiceInstance.checkPermission(context);
    if (status == 1) {
      BackgroundService().startService();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Column(
        children: [
          PrimaryFilledButton(
            buttonTitle: "Start",
            onPressed: startTracking,
          ),
        ],
      ),
    );
  }
}
