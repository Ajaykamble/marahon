import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:marathon/services/background_service.dart';
import 'package:marathon/services/location_service.dart';
import 'package:marathon/services/permission_service.dart';
import 'package:marathon/utils/app_color_scheme.dart';
import 'package:marathon/utils/app_values.dart';
import 'package:marathon/utils/enums.dart';
import 'package:marathon/widget/primary_filled_button.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late BackgroundService _backgroundServiceProvider;

  @override
  void initState() {
    super.initState();
    _backgroundServiceProvider = Provider.of<BackgroundService>(context, listen: false);
    _backgroundServiceProvider.resetProvider();
  }

  startTracking() async {
    int battery = await PermissionService().enableBatteryOptimization(context);
    int status = await LocationService.locationServiceInstance.checkPermission(context);
    if (status == 1 && context.mounted && battery == 1) {
      _backgroundServiceProvider.startService();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: AppColorScheme.kPrimaryColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(AppValues.kAppPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Selector<BackgroundService, Tuple2<ApiStatus, bool>>(
              selector: (context, provider) => Tuple2(provider.trackingStatus, provider.isServiceRunning),
              builder: (context, _, __) {
                return SizedBox(
                  width: double.infinity,
                  child: PrimaryFilledButton(
                    buttonTitle: _backgroundServiceProvider.isServiceRunning ? "Stop Tracking" : "Start Tracking",
                    onPressed: startTracking,
                    isLoading: _backgroundServiceProvider.trackingStatus == ApiStatus.LOADING,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
