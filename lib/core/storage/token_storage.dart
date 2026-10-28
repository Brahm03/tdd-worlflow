import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  static TokenStorage instance = TokenStorage._();
  TokenStorage._();

  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';

  

  SharedPreferences? _prefs;

  Future<String> get accessToken async =>
      _prefs?.getString(_accessTokenKey) ?? '';

  Future<String> get refreshToken async =>
      _prefs?.getString(_refreshTokenKey) ?? '';    

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  String? get token => _prefs?.getString(_accessTokenKey);

  bool get isLoggedIn => token != null && token!.isNotEmpty;

  // * Saqlaydi refresh va access tokenlarni
  Future<void> save({required String accessToken, String? refreshToken}) async {
    await _prefs?.setString(_accessTokenKey, accessToken);
    if (refreshToken != null) {
      await _prefs?.setString(_refreshTokenKey, refreshToken);
    }
  }

  Future<void> clear() async {
    await _prefs?.remove(_accessTokenKey);
    await _prefs?.remove(_refreshTokenKey);
  }


  Future<void> saveNewToken({required String accessToken, String? refreshToken}) async {
    await save(accessToken: accessToken, refreshToken: refreshToken);
  }
}
