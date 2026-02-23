import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _fcmTokenKey = 'fcm_token';
  static const String _resetTokenKey = 'reset_token';
  static const String _userGenderKey = 'user_gender';
  static const String _userStatusKey = 'user_status';

  final SharedPreferences _prefs;

  TokenStorage(this._prefs);

  Future<void> saveAccessToken(String token) async {
    await _prefs.setString(_accessTokenKey, token);
  }

  Future<void> saveRefreshToken(String token) async {
    await _prefs.setString(_refreshTokenKey, token);
  }

  String? getAccessToken() {
    return _prefs.getString(_accessTokenKey);
  }

  String? getRefreshToken() {
    return _prefs.getString(_refreshTokenKey);
  }

  Future<void> saveFcmToken(String token) async {
    await _prefs.setString(_fcmTokenKey, token);
  }

  String? getFcmToken() {
    return _prefs.getString(_fcmTokenKey);
  }

  Future<void> saveResetToken(String token) async {
    await _prefs.setString(_resetTokenKey, token);
  }

  String? getResetToken() {
    return _prefs.getString(_resetTokenKey);
  }

  Future<void> saveUserGender(String gender) async {
    await _prefs.setString(_userGenderKey, gender);
  }

  String? getUserGender() {
    return _prefs.getString(_userGenderKey);
  }

  Future<void> saveUserStatus(String status) async {
    await _prefs.setString(_userStatusKey, status);
  }

  String? getUserStatus() {
    return _prefs.getString(_userStatusKey);
  }

  Future<void> clearTokens() async {
    await _prefs.remove(_accessTokenKey);
    await _prefs.remove(_refreshTokenKey);
    await _prefs.remove(_fcmTokenKey);
    await _prefs.remove(_userGenderKey);
    await _prefs.remove(_userStatusKey);
  }
}
