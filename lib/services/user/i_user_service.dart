import 'package:marathon/Models/tracking_model.dart';
import 'package:marathon/Models/user_model.dart';

abstract class IUserService {
  Future<UserModel?> loginUser({required String userName, required String password});
  Future<void> trackLocation({required String userId, required String trackingId, required String marathonId, required double latitude, required double longitude, required String trackingType});
  Future<List<TrackingModel>> getTrackDetails({required String userId, required String marathonID});
  Future<List<TrackingModel>> getTrackPathDetails({required String userId, required String marathonID, required String trackingId});
  Future<void> trackActivity({
    required String userId,
    required String trackingId,
    required String marathonId,
    required String activity,
    required String trackingType,
  });
}
