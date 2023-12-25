import 'package:marathon/Models/user_model.dart';

abstract class IUserService {
  Future<UserModel?> loginUser({required String userName, required String password});
  Future<void> trackLocation({required String userId, required String trackingId, required String marathonId, required double latitude, required double longitude});
}
