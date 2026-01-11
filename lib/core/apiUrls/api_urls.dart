class ApiUrls {
  static const String baseUrl = 'http://10.10.7.102:5001/api/v1';
  static const String loginUrl = '$baseUrl/auth/athlete/login';
  static const String dailyTrackingPost = '$baseUrl/daily/tracking';
  static const String checkInDate = '$baseUrl/check-in/date';
  static const String checkInPost = '$baseUrl/check-in';
  static const String oldCheckInData = '$baseUrl/check-in/old-data';
  static const String nutritionFood = '$baseUrl/food/nutrition';
  static const String exerciseCoachAthlete = '$baseUrl/exercise/coach/athlete';
  static const String trainingSplit = '$baseUrl/training/splite';
  static const String trackMeal = '$baseUrl/track/meal';
  static const String forgetPasswordUrl =
      '$baseUrl/auth/athlete/forget-password';
  static const String verifyEmailUrl = '$baseUrl/auth/athlete/verify-email';
}
