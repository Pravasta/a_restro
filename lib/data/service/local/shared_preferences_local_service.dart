import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesLocalService {
  final SharedPreferences _sharedPreferences;

  SharedPreferencesLocalService({
    required SharedPreferences sharedPreferences,
  }) : _sharedPreferences = sharedPreferences;

  Future<void> setSharedPreferences(String key, String value) async {
    await _sharedPreferences.setString(key, value);
  }

  Future<String?> getSharedPreferences(String key) async {
    return _sharedPreferences.getString(key);
  }

  Future<void> removeSharedPreferences(String key) async {
    await _sharedPreferences.remove(key);
  }
}
