import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData().copyWith(
    scaffoldBackgroundColor: AppColors.whiteColor,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.whiteColor,
      titleTextStyle: AppText.text20.copyWith(fontWeight: FontWeight.bold),
      foregroundColor: AppColors.whiteColor,
      surfaceTintColor: AppColors.whiteColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(5),
        backgroundColor: AppColors.primaryColor,
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      elevation: 4,
      backgroundColor: AppColors.greyColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25), topRight: Radius.circular(25)),
      ),
    ),
    progressIndicatorTheme:
        const ProgressIndicatorThemeData(color: AppColors.primaryColor),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.whiteColor,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.primaryDarkColor,
      selectedLabelStyle: AppText.text14.copyWith(
          fontWeight: FontWeight.bold, color: AppColors.primaryDarkColor),
      unselectedItemColor: AppColors.greyLightColor,
      unselectedLabelStyle: AppText.text14.copyWith(
          color: AppColors.greyLightColor, fontWeight: FontWeight.bold),
    ),
  );

  static ThemeData darkTheme = ThemeData().copyWith(
    scaffoldBackgroundColor: AppColors.secondaryDarkColor,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.secondaryDarkColor,
      titleTextStyle: AppText.text20.copyWith(fontWeight: FontWeight.bold),
      foregroundColor: AppColors.secondaryDarkColor,
      surfaceTintColor: AppColors.secondaryDarkColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(5),
        backgroundColor: AppColors.secondaryLightColor,
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      elevation: 4,
      backgroundColor: AppColors.greyColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25), topRight: Radius.circular(25)),
      ),
    ),
    progressIndicatorTheme:
        const ProgressIndicatorThemeData(color: AppColors.primaryColor),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.secondaryDarkColor,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.whiteColor,
      selectedLabelStyle: AppText.text14
          .copyWith(fontWeight: FontWeight.bold, color: AppColors.whiteColor),
      unselectedItemColor: AppColors.greyLightColor,
      unselectedLabelStyle: AppText.text14.copyWith(
          color: AppColors.greyLightColor, fontWeight: FontWeight.bold),
    ),
  );
}
