import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:marathon/utils/app_values.dart';
import 'package:marathon/widget/custom_alert_dialog.dart';

class CommonFunctions {
  // open the Location service setting
  static void openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }

  /// opens the apps settings
  static void openAppSettings() async {
    await Geolocator.openAppSettings();
  }

  static void toastMessage(String message) {
    if (Platform.isAndroid || Platform.isIOS) {
      Fluttertoast.showToast(msg: message, gravity: ToastGravity.BOTTOM, toastLength: Toast.LENGTH_LONG, fontSize: 16.0);
    } else {
      showRetrySnackbar(message);
    }
  }

  static void showRetrySnackbar([String? message]) {
    try {
      if (AppValues.scaffoldMessengerKey.currentState?.mounted ?? false) {
        AppValues.scaffoldMessengerKey.currentState?.showSnackBar(
          SnackBar(
            content: Text(message ?? "No Internet Connection"),
          ),
        );
      }
      else{
        log("no mounted");
      }
    } catch (e) {
      log("something went ${e}");
    }
  }

  /// call this method to display dialog within app
  /// it accepts 3 parameter
  /// 1. context of current screen
  /// subtitle : text that will be description message for dialog
  /// buttonText : text of the button
  /// action: this is optional parameter if we don't pass it will popup the dialog
  static Future<T> openDialog<T>({
    required BuildContext context,
    required String subtitle,
    required String buttonText,
    required Function(BuildContext context)? action,
    String? title,
    Function(BuildContext context)? onCancelAction,
    String? buttonCancelText,
  }) async {
    const String _ALERT = "Alert";

    return await showDialog(
      context: context,
      barrierDismissible: true,
      useSafeArea: true,
      builder: (context) => CustomAlertDialog(
        title: title ?? _ALERT,
        subtitle: subtitle,
        buttonText: buttonText,
        buttonCancelText: buttonCancelText,
        onCancelPress: onCancelAction == null
            ? null
            : () {
                onCancelAction(context);
              },
        onOkPressed: action == null
            ? null
            : () {
                action(context);
              },
      ),
    );
  }
}
