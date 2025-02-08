import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:a_restro/core/common/routes/navigation.dart';
import 'package:a_restro/core/common/routes/routes_name.dart';
import 'package:a_restro/core/components/button/default_button.dart';
import 'package:a_restro/core/components/loading/default_loading.dart';
import 'package:a_restro/core/components/message/message_bar.dart';
import 'package:a_restro/core/constant/style/app_colors.dart';
import 'package:a_restro/core/constant/style/app_text.dart';
import 'package:a_restro/core/extensions/build_context_ext.dart';
import 'package:a_restro/data/static/firebase_auth_status_static.dart';
import 'package:a_restro/feature/auth/provider/firebase_auth_provider.dart';
import 'package:a_restro/feature/main_page/provider/notifications/notification_provider.dart';
import 'package:a_restro/feature/profile/provider/change_theme_provider.dart';
import 'package:a_restro/feature/profile/provider/toogle_schedule_notification_provider.dart';

import '../../../core/constant/url_assets/url_assets.dart';
import '../../../data/model/response/user_response_model.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    AppBar appBar() {
      return AppBar(
        centerTitle: true,
        title: Image.asset(
          UrlAssets.iconLogoWithName,
          scale: 3.5,
        ),
      );
    }

    Widget avatarSection() {
      return Container(
        width: context.deviceWidth * 1 / 3,
        height: context.deviceWidth * 1 / 3,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(
              UrlAssets.iconAvatar,
            ),
          ),
        ),
      );
    }

    Widget personalInfoSection(UserResponseModel data) {
      return Material(
        borderRadius: BorderRadius.circular(15),
        elevation: 3,
        shadowColor: AppColors.greyLightColor,
        child: Container(
          padding: EdgeInsets.all(20),
          width: context.deviceWidth,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              Text(
                'Personal Info',
                style: AppText.text18.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Your Name',
                      style: AppText.text14.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    data.name ?? '',
                    style: AppText.text14,
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Your Email',
                      style: AppText.text14.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    data.email ?? '',
                    style: AppText.text14,
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'App Theme',
                      style: AppText.text14.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Switch.adaptive(
                    value: context.watch<ChangeThemeProvider>().isDarkTheme,
                    onChanged: (value) async {
                      final themeProvider = context.read<ChangeThemeProvider>();
                      await themeProvider.changeTheme();
                      MessageBar.messageBar(context, themeProvider.message);
                    },
                    activeColor: AppColors.primaryColor,
                    activeTrackColor: AppColors.primaryLightColor,
                    inactiveTrackColor: AppColors.primaryLightColor,
                    inactiveThumbColor: AppColors.primaryDarkColor,
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Daily Reminder',
                      style: AppText.text14.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Switch.adaptive(
                    value: context
                        .watch<ToogleScheduleNotificationProvider>()
                        .isScheduleNotificationActive,
                    onChanged: (value) async {
                      final scheduleProvider =
                          context.read<ToogleScheduleNotificationProvider>();
                      final notificationProvider =
                          context.read<NotificationProvider>();

                      if (!scheduleProvider.isScheduleNotificationActive) {
                        notificationProvider.setScheduleNotification();
                      } else {
                        notificationProvider.cancelNotification();
                      }
                      await scheduleProvider.toogleScheduleNotification();
                      MessageBar.messageBar(context, scheduleProvider.message);
                    },
                    activeColor: AppColors.primaryColor,
                    activeTrackColor: AppColors.primaryLightColor,
                    inactiveTrackColor: AppColors.primaryLightColor,
                    inactiveThumbColor: AppColors.primaryDarkColor,
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    Widget buttonLogout() {
      return Consumer<FirebaseAuthProvider>(
        builder: (context, value, child) {
          return switch (value.authStatus) {
            FirebaseAuthStatusStatic.signingOut =>
              Center(child: CircularProgressIndicator()),
            _ => DefaultButton(
                title: 'Logout',
                onTap: () async {
                  await value.signOutUser();

                  switch (value.authStatus) {
                    case FirebaseAuthStatusStatic.unauthenticated:
                      Navigation.pushNameAndRemove(RoutesName.login);

                    case _:
                      MessageBar.messageBar(context, value.message);
                  }
                },
              )
          };
        },
      );
    }

    return Scaffold(
      appBar: appBar(),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Column(
            children: [
              avatarSection(),
              SizedBox(height: 20),
              Consumer<FirebaseAuthProvider>(
                builder: (context, value, child) {
                  return switch (value.authStatus) {
                    FirebaseAuthStatusStatic.authenticating => DefaultLoading(),
                    FirebaseAuthStatusStatic.authenticated =>
                      personalInfoSection(value.user!),
                    _ => SizedBox(),
                  };
                },
              ),
              SizedBox(height: 20),
              buttonLogout(),
            ],
          ),
        ),
      ),
    );
  }
}
