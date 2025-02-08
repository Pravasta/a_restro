import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:workmanager/workmanager.dart';

import 'package:a_restro/data/service/local/notification_local_service.dart';
import 'package:a_restro/data/service/remote/http_remote_service.dart';
import 'package:a_restro/data/static/my_workmanager_static.dart';
import 'package:a_restro/feature/home/repository/home_repository.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    final notificationService = NotificationLocalService(
      homeRepository: HomeRepository.create(),
      httpRemoteService: HttpRemoteService.create(),
    );

    await notificationService.showNotification();

    return Future.value(true);
  });
}

class WorkManagerService {
  final Workmanager _workManager;

  WorkManagerService({
    required Workmanager workManager,
  }) : _workManager = workManager;

  Future<void> init() async {
    await _workManager.initialize(callbackDispatcher, isInDebugMode: true);
  }

  Future<void> runPeriodicTask() async {
    final datetimeSchedule = _calculateInitialDelay(11, 0);

    await _workManager.registerPeriodicTask(
      MyWorkmanagerStatic.periodic.uniqueName,
      MyWorkmanagerStatic.periodic.taskName,
      frequency: const Duration(days: 1),
      initialDelay: datetimeSchedule,
      inputData: {
        "data": "This is a valid payload from periodic task workmanager",
      },
      existingWorkPolicy: ExistingWorkPolicy.replace,
      constraints: Constraints(networkType: NetworkType.connected),
    );
  }

  Future<void> cancelAllTask() async {
    await _workManager.cancelAll();
  }

  Future<void> configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  Duration _calculateInitialDelay(int targetHour, int targetMinute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);

    tz.TZDateTime scheduledDate = tz.TZDateTime(
        tz.local, now.year, now.month, now.day, targetHour, targetMinute);

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate.difference(now);
  }

  factory WorkManagerService.create() {
    return WorkManagerService(workManager: Workmanager());
  }
}
