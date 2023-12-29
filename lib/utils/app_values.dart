import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:marathon/utils/custom_input_formatter.dart';

class AppValues{
  AppValues._();
   static GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  static double get kAppPadding => 10.0;
  static double get kCardPadding => 16.0;

  ///Input Formatters
  static TextInputFormatter get numberInputFormatter => CustomInputFormatter(regx: r'^[0-9]*$');
  static TextInputFormatter get emailIDInputFormatter => CustomInputFormatter(regx: r'^[a-zA-Z0-9-._@]*$');

  static String dateFormat = "dd-MM-yyyy hh:mm a";

}