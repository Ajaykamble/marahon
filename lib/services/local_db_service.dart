import 'package:marathon/Models/user_model.dart';
import 'package:marathon/viewModel/userProvider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalDbService {
  LocalDbService._();
  static final LocalDbService db = LocalDbService._();
  factory LocalDbService() => db;
  SharedPreferences? _prefs;

  final String _keyUserDetails = "UserDetails";
  final String _keyTrackingDetails = "trackingDetails";

  init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  bool isSignedIn() {
    bool isAlreadySignedIn = _prefs!.containsKey(_keyUserDetails);
    if (isAlreadySignedIn) {
      String userDetails = _prefs!.getString(_keyUserDetails)!;
      UserModel user = userModelFromJson(userDetails);
      UserProvider().setUserDetails(user);
    }
    return isAlreadySignedIn;
  }

  Future<void> saveUserDetails(String userDetails) async {
    await _prefs!.setString(_keyUserDetails, userDetails);
  }

  Future<void> clearAll() {
    return _prefs!.clear();
  }

  saveDetails(String key, String value) async {
    await _prefs!.setString(key, value);
  }

  String? getDetails(String key) {
    return _prefs!.getString(key);
  }

  bool contains(String key) {
    return _prefs!.containsKey(key);
  }
}
