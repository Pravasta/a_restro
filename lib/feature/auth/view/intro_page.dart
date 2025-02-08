import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:a_restro/core/common/routes/navigation.dart';
import 'package:a_restro/core/common/routes/routes_name.dart';
import 'package:a_restro/core/constant/style/app_colors.dart';
import 'package:a_restro/core/constant/style/app_text.dart';
import 'package:a_restro/core/constant/url_assets/url_assets.dart';
import 'package:a_restro/data/service/local/shared_preferences_key.dart';
import 'package:a_restro/data/service/local/shared_preferences_local_service.dart';
import 'package:a_restro/feature/profile/provider/change_theme_provider.dart';

import '../../../data/service/local/notification_local_service.dart';
import '../../main_page/provider/notifications/payload_notification_provider.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  String? payload;

  Future<void> _navigateToNextScreen() async {
    WidgetsFlutterBinding.ensureInitialized();

    final notificationAppLaunchDetails =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

    final sharedPreferencesService = SharedPreferencesLocalService(
      sharedPreferences: context.read<SharedPreferences>(),
    );

    final isLoggedIn = await sharedPreferencesService.getSharedPreferences(
      AppSharedPreferencesKey.isLogin,
    );

    if (isLoggedIn != null) {
      if (notificationAppLaunchDetails?.didNotificationLaunchApp == true) {
        final notificationResponse =
            notificationAppLaunchDetails!.notificationResponse;

        payload = notificationResponse?.payload;
        Navigation.pushReplacement(RoutesName.mainPage);
        Navigation.pushName(RoutesName.detailPage, arguments: payload);
      } else {
        Navigation.pushReplacement(RoutesName.mainPage);
      }
    } else {
      Navigation.pushReplacement(RoutesName.login);
    }
  }

  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 3),
      () => _navigateToNextScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.read<ChangeThemeProvider>();

    return ChangeNotifierProvider(
      create: (_) => PayloadNotificationProvider(payload: payload),
      child: buildContent(theme),
    );
  }

  Scaffold buildContent(ChangeThemeProvider theme) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(UrlAssets.iconLogo, scale: 4),
              const SizedBox(height: 50),
              Text(
                'ARestro',
                style: AppText.bigText.copyWith(
                  color: theme.isDarkTheme
                      ? AppColors.whiteColor
                      : AppColors.blackColor,
                ),
              ),
              Text(
                'Ordering food and drinks is easier with\none app.',
                textAlign: TextAlign.center,
                style: AppText.text16.copyWith(
                  color: theme.isDarkTheme
                      ? AppColors.secondaryLightColor
                      : AppColors.greyColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
