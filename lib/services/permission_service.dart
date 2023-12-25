import 'dart:io';

import 'package:flutter/material.dart';
import 'package:marathon/utils/common_functions.dart';
import 'package:optimize_battery/optimize_battery.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  Future<int> enableBatteryOptimization(BuildContext context) async {
    if (Platform.isAndroid) {
      bool status = await Permission.ignoreBatteryOptimizations.isGranted;

      if (status) {
        return 1;
      } else {
        PermissionStatus permissionStatus = await Permission.ignoreBatteryOptimizations.request();
        if (permissionStatus == PermissionStatus.granted) {
          return 1;
        } else {
          int? result = await CommonFunctions.openDialog(
            context: context,
            action: (context) {
              OptimizeBattery.openBatteryOptimizationSettings();
              Navigator.pop(context, 0);
            },
            subtitle: "We need to disable battery optimization for this app to work properly",
            buttonText: "Open Settings",
            title: "Alert",
            buttonCancelText: "Not Now",
            onCancelAction: (context) {
              Navigator.pop(context, -1);
            },
          );
          return result ?? -1;
        }
      }
    } else {
      return 1;
    }
  }
}
