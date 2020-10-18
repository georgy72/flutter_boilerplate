import 'package:shared_preferences/shared_preferences.dart';

class PersistentStorage {
  String _authTokenKey = 'AuthToken';

  Future<SharedPreferences> _prefs() async {
    return await SharedPreferences.getInstance();
  }

  Future<String> getAuthToken() async {
    final prefs = await _prefs();
    return prefs.getString(_authTokenKey);
  }

  Future<void> saveAuthToken(String token) async {
    assert(token != null);
    final prefs = await _prefs();
    if (token.isEmpty) {
      await clearAuthToken();
      return;
    }
    await prefs.setString(_authTokenKey, token);
  }

  Future<void> clearAuthToken() async {
    final prefs = await _prefs();
    await prefs.remove(_authTokenKey);
  }

  Future<void> clearAll() async {
    await clearAuthToken();
  }
}
