import 'package:flutter/foundation.dart';

import 'package:a_restro/data/service/local/notification_local_service.dart';
import 'package:a_restro/data/service/local/work_manager_service.dart';

class NotificationProvider extends ChangeNotifier {
  final NotificationLocalService _notificationLocalService;
  final WorkManagerService _workManagerService;

  NotificationProvider({
    required NotificationLocalService notificationLocalService,
    required WorkManagerService workManagerService,
  })  : _notificationLocalService = notificationLocalService,
        _workManagerService = workManagerService;

  bool? _permission = false;
  bool? get permission => _permission;

  Future<void> requestPermissions() async {
    _permission = await _notificationLocalService.requestPermissions();
    notifyListeners();
  }

  void setScheduleNotification() async {
    await _workManagerService.runPeriodicTask();
  }

  Future<void> cancelNotification() async {
    await _workManagerService.cancelAllTask();
  }
}
