class AppEndpoints {
  AppEndpoints._();

  static List<String> get unauthorizedRequests => [];
  static List<String> get multiPartRequests => [];

  static String get login => "/login.php";
  static String get trackDetails => "/trackUser.php";
  static String get activityDetails => "/activity.php";
  static String get getTrackDetails => "/getTrack.php";
  static String get getTrackPathDetails => "/getPath.php";


}
