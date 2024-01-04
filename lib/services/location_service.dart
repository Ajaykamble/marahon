// ignore_for_file: non_constant_identifier_names,

import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:marathon/utils/common_functions.dart';
import 'package:marathon/utils/enums.dart';

class LocationService {
  LocationService._();
  final String _INITIAL_TITLE = "Location Permission are currently denied. do you want to allow location Permission?";
  final String _ERROR_LOCATION_SERVICE_DISABLED = "Location services are currently disabled. Please enable location services in your device settings.";
  final String _ERROR_LOCATION_PERMISSION_DENIED = "Location permissions are currently denied. Please grant location permissions in your app settings.";
  final String _ERROR_LOCATION_PERMISSION_PERMANENT_DENIED = "Location permissions are permanently denied, Please grant location permissions in your app settings.";
  final String _ERROR_LOCATION_PERMISSION_IN_USE =
      "Location permissions are currently allowed only while using the app. Please grant location permissions as always because we collect location data to calculate expense reimbursement based on distance travelled even when app is closed or not in use.";
  final String _ENABLE_LOCATION_CTA = "Enable Location Services";
  final String _GRANT_LOCATION_CTA = "Continue";
  final String _INTITAL_GRANT_LOCATION_CTA = "Allow";
  final String _LATER_LOCATION_CTA = "Later";
  final String _DIALOG_TITLE = "Information";

  static LocationService locationServiceInstance = LocationService._();

  /// [startTracking] is to start tracking location
  /// it will store location data in firebase realtime database

  startTracking() async {
    Geolocator.getPositionStream().listen((position) {
      log("${position.toString()}");
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

  /// [getPermissionStatus] returns [LocationPermissionStatus] enum based on [permissionStatus]
  Future<LocationPermissionStatus> getPermissionStatus(LocationPermission permissionStatus, bool enableBackgroundMode) async {
    switch (permissionStatus) {
      case LocationPermission.always:
        return LocationPermissionStatus.GRANTED;

      /// background location we will enable in future
      /* bool isAlwaysAllowed = await _isBackgroundLocationEnabled(enableBackgroundMode);
        return isAlwaysAllowed ? LocationPermissionStatus.GRANTED : LocationPermissionStatus.WHILE_IN_USE; */
      case LocationPermission.whileInUse:
        return LocationPermissionStatus.WHILE_IN_USE;
      case LocationPermission.denied:
        return LocationPermissionStatus.DENIED;
      case LocationPermission.deniedForever:
        return LocationPermissionStatus.FOREVER_DENIED;
      default:
        return LocationPermissionStatus.GRANTED;
    }
  }

  /// [requestLocationService] is to return [LocationPermissionStatus]
  Future<LocationPermissionStatus> requestLocationService({bool enableBackgroundMode = false}) async {
    /// before checking permission we need to either location service is enabled or not
    /// if location service is not enable then we will return [SERVICE_DISABLED] as enum

    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isLocationServiceEnabled) {
      return LocationPermissionStatus.SERVICE_DISABLED;
    }

    /// if location service is enabled then we will check status of location permission for the app.
    LocationPermission permissionStatus = await Geolocator.checkPermission();

    return getPermissionStatus(permissionStatus, enableBackgroundMode);
  }

  /// [checkPermission] helps you to check either location permission is given to app or not
  /// it will return status of permission in bool format
  /// if user choose to give permission later it will return -1
  /// if user didnt allow the permission it will return 0
  /// if user allowed the permission it will return 1
  Future<int> checkPermission(
    BuildContext context,
  ) async {
    
    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    log("**${isLocationServiceEnabled}");
    /// checks the status of location from [PermissionService] class
    LocationPermission initialStatus = await Geolocator.checkPermission();
    log("${initialStatus}");
    if (initialStatus != LocationPermission.always) {
      if (context.mounted) {
        var result = await CommonFunctions.openDialog(
          context: context,
          subtitle: _INITIAL_TITLE,
          buttonText: _INTITAL_GRANT_LOCATION_CTA,
          title: _DIALOG_TITLE,
          action: (context) {
            Navigator.pop(context, true);
          },
          buttonCancelText: _LATER_LOCATION_CTA,
          onCancelAction: (context) {
            Navigator.pop(context, false);
          },
        );
        if (result == null) {
          return -1;
        }
        if (!result) {
          return 0;
        }
      }
    }

    LocationPermissionStatus serviceStatus = await requestLocationService(enableBackgroundMode: true);
    switch (serviceStatus) {
      case LocationPermissionStatus.GRANTED:
        return 1;
      case LocationPermissionStatus.DENIED:
        LocationPermission requestPermissionStatus = await Geolocator.requestPermission();
        if (requestPermissionStatus == LocationPermission.always) {
          return 1;
        } else {
          LocationPermissionStatus permissionStatus = await getPermissionStatus(requestPermissionStatus, true);
          if (context.mounted) {
            /// if user has not given permission to the app . we will display alert to the user
            return await _showPermissionDialog(context, permissionStatus) ?? -1;
          }
        }
        return -1;
      default:
        if (context.mounted) {
          /// displaying alert to the user
          return await _showPermissionDialog(context, serviceStatus) ?? -1;
        }
        return -1;
    }
  }

  Future<int?> _showPermissionDialog(BuildContext context, LocationPermissionStatus status) async {
    switch (status) {
      /// if Location service is disabled then we will display alert
      /// if user click on alert button it will open Location service setting of mobile.
      case LocationPermissionStatus.SERVICE_DISABLED:
        return await CommonFunctions.openDialog(
          context: context,
          action: (context) {
            CommonFunctions.openLocationSettings();
            Navigator.pop(context, 0);
          },
          subtitle: _ERROR_LOCATION_SERVICE_DISABLED,
          buttonText: _ENABLE_LOCATION_CTA,
          title: _DIALOG_TITLE,
          buttonCancelText: _LATER_LOCATION_CTA,
          onCancelAction: (context) {
            Navigator.pop(context, -1);
          },
        );

      /// if Location Permission is denied forever  then we will display alert
      /// if user click on alert button it will open K-Lab Collection App Setting.
      case LocationPermissionStatus.FOREVER_DENIED:
        return await CommonFunctions.openDialog(
          context: context,
          action: (context) {
            CommonFunctions.openAppSettings();
            Navigator.pop(context);
          },
          subtitle: _ERROR_LOCATION_PERMISSION_PERMANENT_DENIED,
          buttonText: _GRANT_LOCATION_CTA,
          title: _DIALOG_TITLE,
          buttonCancelText: _LATER_LOCATION_CTA,
          onCancelAction: (context) {
            Navigator.pop(context, -1);
          },
        );
        break;

      /// if Location Permission is allowed but only while using the app then we will display alert
      /// if user click on alert button it will open K-Lab Collection App Setting.
      case LocationPermissionStatus.WHILE_IN_USE:
        return await CommonFunctions.openDialog(
          context: context,
          action: (context) async{
            CommonFunctions.openAppSettings();
            Navigator.pop(context);
          },
          subtitle: _ERROR_LOCATION_PERMISSION_IN_USE,
          buttonText: _GRANT_LOCATION_CTA,
          title: _DIALOG_TITLE,
          buttonCancelText: _LATER_LOCATION_CTA,
          onCancelAction: (context) {
            Navigator.pop(context, -1);
          },
        );
        break;
      default:
        CommonFunctions.openDialog(
          context: context,
          action: (context) {
            CommonFunctions.openAppSettings();
            Navigator.pop(context);
          },
          subtitle: _ERROR_LOCATION_SERVICE_DISABLED,
          buttonText: _GRANT_LOCATION_CTA,
          title: _DIALOG_TITLE,
          buttonCancelText: _LATER_LOCATION_CTA,
          onCancelAction: (context) {
            Navigator.pop(context, -1);
          },
        );

        break;
    }

    return -1;
  }

  Future<Position?> getLocation(BuildContext context) async {
    int hasPermission = await checkPermission(context);
    try {
      if (hasPermission == 1) {
        return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      }
    } catch (e) {}

    return null;
  }

  Future<double> getDistance(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) async {
    double _distanceInMeters = await Geolocator.distanceBetween(startLatitude, startLongitude, endLatitude, endLongitude);

    return _distanceInMeters / 1000;
  }
}
