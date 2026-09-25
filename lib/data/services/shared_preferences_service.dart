import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  SharedPreferencesService(this._prefs);

  final SharedPreferences _prefs;

  Future<void> savePrefs(String key, String value) async {
    try {
      await _prefs.setString(key, value);
    } catch (e) {
      rethrow;
    }
  }

  String? getPrefs(String key) {
    final value = _prefs.getString(key);
    return value;
  }

  void removePrefs(String key) {
    _prefs.remove(key);
  }

  void clearPrefts() {
    _prefs.clear();
  }
}
