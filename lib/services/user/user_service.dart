import 'dart:developer';

import 'package:http/http.dart';
import 'package:marathon/Models/user_model.dart';
import 'package:marathon/services/user/i_user_service.dart';
import 'package:marathon/utils/app_endpoints.dart';
import 'package:marathon/utils/network/api_base_helper.dart';

class UserService extends IUserService {
  @override
  Future<UserModel?> loginUser({required String userName, required String password}) async {
    try {
      Map<String, dynamic> payload = {"username": userName, "password": password};
      Response? response = await ApiBaseHelper.httpPostRequest(AppEndpoints.login, payload: payload);
      if (response != null) {
        return userModelFromJson(response.body);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> trackLocation({
    required String userId,
    required String trackingId,
    required String marathonId,
    required double latitude,
    required double longitude,
  }) async {
    try {
      Map<String, dynamic> payload = {
        "trackingId": trackingId,
        "userId": userId,
        "marathonId": marathonId,
        "latitude": latitude,
        "longitude": longitude,
      };
      Response? response = await ApiBaseHelper.httpPostRequest(AppEndpoints.trackDetails, payload: payload);
    } catch (e) {
      rethrow;
    }
  }
}
