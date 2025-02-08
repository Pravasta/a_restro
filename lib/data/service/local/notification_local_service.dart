import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:a_restro/core/variables/variable.dart';
import 'package:a_restro/data/model/request/show_notification_request_model.dart';
import 'package:a_restro/data/model/response/received_notification_response_model.dart';
import 'package:a_restro/data/service/remote/http_remote_service.dart';
import 'package:a_restro/feature/home/repository/home_repository.dart';

final StreamController<ReceivedNotificationResponseModel>
    didReceiveLocalNotificationSubject =
    StreamController<ReceivedNotificationResponseModel>.broadcast();

final StreamController<String?> selectNotificationSubject =
    StreamController<String?>.broadcast();

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class NotificationLocalService {
  final HomeRepository _homeRepository;
  final HttpRemoteService _httpRemoteService;

  NotificationLocalService({
    required HomeRepository homeRepository,
    required HttpRemoteService httpRemoteService,
  })  : _httpRemoteService = httpRemoteService,
        _homeRepository = homeRepository;

  int _notificationId = 0;

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings(
      'app_icon',
    );

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        final payload = details.payload;
        if (payload != null || payload!.isNotEmpty) {
          selectNotificationSubject.add(payload);
        }
      },
    );
  }

  Future<bool> _isAndroidPermissionGranted() async {
    return await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.areNotificationsEnabled() ??
        false;
  }

  Future<bool?> requestPermissions() async {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      final iOSImplementation =
          flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>();
      return await iOSImplementation?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      final androidImplementation =
          flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      final requestNotificationsPermission =
          await androidImplementation?.requestNotificationsPermission();

      final notificationEnabled = await _isAndroidPermissionGranted();
      final requestAlarmEnabled = await _requestExactAlarmsPermission();

      return (requestNotificationsPermission ?? false) &&
          notificationEnabled &&
          requestAlarmEnabled;
    } else {
      return false;
    }
  }

  Future<bool> _requestExactAlarmsPermission() async {
    return await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.requestExactAlarmsPermission() ??
        false;
  }

  Future<void> showNotification({
    String channelId = "1",
    String channelName = "Notification Reminder Eating",
  }) async {
    final result = await _homeRepository.getRestaurantList();

    final random = Random();
    final randomIndex = random.nextInt(result.length);
    final dataResto = result[randomIndex];

    final ShowNotificationRequestModel data = ShowNotificationRequestModel(
      id: _notificationId,
      title: dataResto.name ?? '',
      body: 'Helloo Friends, it\'s time to eat',
      payload: dataResto.id ?? '',
      contentTitle: dataResto.name ?? '',
      description: 'you must like the menu on this restaurant, let\'s try now',
      imageUrl: dataResto.pictureId ?? '',
    );

    final largeIconPath = await _httpRemoteService.downloadAndSaveFile(
      '${Variable.baseImageUrl}/${data.imageUrl}',
      'largeIcon',
    );

    final bigPicturePath = await _httpRemoteService.downloadAndSaveFile(
      '${Variable.baseImageUrl}/${data.imageUrl}',
      'bigPicturePath.png',
    );

    final BigPictureStyleInformation bigPictureStyleInformation =
        BigPictureStyleInformation(
      FilePathAndroidBitmap(bigPicturePath),
      largeIcon: FilePathAndroidBitmap(largeIconPath),
      contentTitle: data.contentTitle,
      htmlFormatContentTitle: true,
      summaryText: data.description,
      htmlFormatSummaryText: true,
    );

    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      channelId,
      channelName,
      importance: Importance.max,
      priority: Priority.high,
      sound: RawResourceAndroidNotificationSound('slow_spring_board'),
      styleInformation: bigPictureStyleInformation,
      ticker: 'ticker',
    );
    final iOSPlatformChannelSpecifics = DarwinNotificationDetails(
      attachments: [
        DarwinNotificationAttachment(
          bigPicturePath,
          hideThumbnail: false,
        )
      ],
    );
    final notificationDetails = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    _notificationId += 1;

    await flutterLocalNotificationsPlugin.show(
      data.id,
      data.title,
      data.body,
      notificationDetails,
      payload: data.payload,
    );
  }

  factory NotificationLocalService.create() {
    return NotificationLocalService(
      httpRemoteService: HttpRemoteService.create(),
      homeRepository: HomeRepository.create(),
    );
  }
}
