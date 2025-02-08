import 'package:a_restro/core/common/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/common/routes/navigation.dart';
import 'core/common/routes/routes_handler.dart';
import 'core/constant/style/app_theme.dart';
import 'core/utils/route_observer.dart';
import 'feature/profile/provider/change_theme_provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ChangeThemeProvider>(
      builder: (context, value, child) {
        return MaterialApp(
          title: 'A Resto',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: value.isDarkTheme ? ThemeMode.dark : ThemeMode.light,
          navigatorKey: navigatorKey,
          initialRoute: RoutesName.initial,
          onGenerateRoute: RoutesHandler.onGenerateRoute,
          debugShowCheckedModeBanner: false,
          navigatorObservers: [routeObserver],
        );
      },
    );
  }
}
