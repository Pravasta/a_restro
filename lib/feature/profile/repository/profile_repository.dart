import 'package:a_restro/data/service/local/shared_preferences_key.dart';
import 'package:a_restro/data/service/local/shared_preferences_local_service.dart';

class ProfileRepository {
  final SharedPreferencesLocalService _localService;

  ProfileRepository({
    required SharedPreferencesLocalService localService,
  }) : _localService = localService;

  Future<void> saveTheme(bool isDarkTheme) async {
    await _localService.setSharedPreferences(
      AppSharedPreferencesKey.isDarkTheme,
      isDarkTheme.toString(),
    );
  }

  Future<bool> loadTheme() async {
    final themeString = await _localService
        .getSharedPreferences(AppSharedPreferencesKey.isDarkTheme);
    return themeString == 'true';
  }

  Future<void> saveScheduleNotification(
      bool isScheduleNotificationActive) async {
    await _localService.setSharedPreferences(
      AppSharedPreferencesKey.isScheduleNotificationActive,
      isScheduleNotificationActive.toString(),
    );
  }

  Future<bool> loadScheduleNotification() async {
    final scheduleString = await _localService.getSharedPreferences(
        AppSharedPreferencesKey.isScheduleNotificationActive);
    return scheduleString == 'true';
  }
}
