import 'package:a_restro/feature/profile/repository/profile_repository.dart';
import 'package:flutter/material.dart';

class ToogleScheduleNotificationProvider extends ChangeNotifier {
  final ProfileRepository _profileRepository;

  ToogleScheduleNotificationProvider({
    required ProfileRepository profileRepository,
  }) : _profileRepository = profileRepository {
    _loadScheduleNotification();
  }

  bool _isScheduleNotificationActive = false;
  String _message = '';

  bool get isScheduleNotificationActive => _isScheduleNotificationActive;
  String get message => _message;

  Future<void> _loadScheduleNotification() async {
    _isScheduleNotificationActive =
        await _profileRepository.loadScheduleNotification();
    notifyListeners();
  }

  Future<void> toogleScheduleNotification() async {
    _isScheduleNotificationActive = !_isScheduleNotificationActive;

    await _profileRepository
        .saveScheduleNotification(_isScheduleNotificationActive);

    if (_isScheduleNotificationActive) {
      _message = 'Notification Schedule Actived';
      notifyListeners();
    } else {
      _message = 'Notification Schedule Deactived';
      notifyListeners();
    }
  }
}
