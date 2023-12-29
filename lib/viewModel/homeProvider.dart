import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:marathon/Models/tracking_model.dart';
import 'package:marathon/services/background_service.dart';
import 'package:marathon/services/user/user_service.dart';
import 'package:marathon/utils/common_functions.dart';
import 'package:marathon/utils/enums.dart';
import 'package:latlong2/latlong.dart';

class HomeProvider extends ChangeNotifier {
  ApiStatus _getTrackingStatus = ApiStatus.LOADING;
  ApiStatus _getPathStatus = ApiStatus.LOADING;

  List<TrackingModel> _userTrackList = [];
  List<TrackingModel> _userPathTrackList = [];
  List<LatLng> _latLonList = [];

  ApiStatus get getTrackingStatus => _getTrackingStatus;
  List<TrackingModel> get userTrackList => _userTrackList;
  ApiStatus get getPathStatus => _getPathStatus;
  List<TrackingModel> get userPathTrackList => _userPathTrackList;
  List<LatLng> get latLonList => _latLonList;

  set getPathStatus(ApiStatus value) {
    _getPathStatus = value;
    notifyListeners();
  }

  set latLonList(List<LatLng> value) {
    _latLonList = value;
    notifyListeners();
  }

  set userPathTrackList(List<TrackingModel> value) {
    _userPathTrackList = value;
    notifyListeners();
  }

  set setTrackingStatus(ApiStatus value) {
    _getTrackingStatus = value;
    notifyListeners();
  }

  set userTrackList(List<TrackingModel> value) {
    _userTrackList = value;
    notifyListeners();
  }

  resetRoutePathScreen() {
    _getPathStatus = ApiStatus.LOADING;
    _userPathTrackList = [];
    _latLonList = [];
  }

  resetProvider() {
    _getTrackingStatus = ApiStatus.LOADING;
    _userTrackList = [];
  }

  void getTrackingData({required String userId, String marathonId = "1"}) async {
    setTrackingStatus = ApiStatus.LOADING;
    try {
      userTrackList = await UserService().getTrackDetails(userId: userId, marathonID: marathonId);
      setTrackingStatus = ApiStatus.SUCCESS;
    } catch (e) {
      setTrackingStatus = ApiStatus.ERROR;
    }
  }

  Future<void> getTrackingPathData({required String userId, String marathonId = "1", required String trackingId}) async {
    try {
      getPathStatus = ApiStatus.LOADING;
      userPathTrackList = await UserService().getTrackPathDetails(userId: userId, marathonID: marathonId, trackingId: trackingId);
      Set<LatLng> latLog = Set<LatLng>();
      for (TrackingModel model in userPathTrackList) {
        if (model.lat != null && model.lon != null) {
          try {
            double lat = double.parse(model.lat!);
            double lon = double.parse(model.lon!);
            latLog.add(LatLng(lat, lon));
          } catch (e) {}
        }
      }

      latLonList = latLog.toList();
      log("${latLonList.length} *** ");
      getPathStatus = ApiStatus.SUCCESS;
    } catch (e) {
      getPathStatus = ApiStatus.ERROR;
    }
  }
}
