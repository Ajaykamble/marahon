import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:marathon/Models/user_model.dart';
import 'package:marathon/services/local_db_service.dart';
import 'package:marathon/services/user/user_service.dart';
import 'package:marathon/utils/app_constant.dart';
import 'package:marathon/utils/common_functions.dart';
import 'package:marathon/utils/enums.dart';

class UserProvider extends ChangeNotifier {
  UserProvider._();
  static UserProvider _instance = UserProvider._();
  factory UserProvider() => _instance;

  UserModel? _userDetail;
  ApiStatus _apiStatus = ApiStatus.SUCCESS;

  ApiStatus get signInStatus => _apiStatus;
  UserModel? get userDetail => _userDetail;

  set signInStatus(ApiStatus status) {
    _apiStatus = status;
    notifyListeners();
  }

  set userDetail(UserModel? user) {
    _userDetail = user;
    notifyListeners();
  }

  setUserDetails(UserModel user) {
    _userDetail = user;
  }

  Future<bool> loginUser({required String userName, required String password}) async {
    bool isSuccessful = false;
    try {
      signInStatus = ApiStatus.LOADING;
      UserModel? _details = await UserService().loginUser(userName: userName, password: password);
      if (_details != null) {
        isSuccessful = true;
        _userDetail = _details;
        await LocalDbService.db.saveUserDetails(jsonEncode(_details.toJson()));
      }
      signInStatus = ApiStatus.SUCCESS;
    } catch (e) {
      CommonFunctions.toastMessage("Invalid Credentials");
      signInStatus = ApiStatus.ERROR;
    }
    return isSuccessful;
  }
}
