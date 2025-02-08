import 'package:a_restro/feature/auth/view/login_page.dart';
import 'package:a_restro/feature/auth/view/register_page.dart';
import 'package:a_restro/feature/detail_restaurant/view/add_review_page.dart';
import 'package:a_restro/feature/detail_restaurant/view/detail_restaurant_page.dart';
import 'package:flutter/material.dart';
import 'package:a_restro/feature/auth/view/intro_page.dart';
import '../../../feature/main_page/view/main_page.dart';
import '../../constant/style/app_text.dart';
import 'routes_name.dart';

class RoutesHandler {
  final String initialRoutes = RoutesName.initial;
  static const initialNavbarVisibility = true;

  static MaterialPageRoute get _emptyPage {
    return MaterialPageRoute(
      builder: (context) {
        return Scaffold(
          body: Center(
            child: Text(
              'Not Found',
              style: AppText.text24.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
    );
  }

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.initial:
        return MaterialPageRoute(
          builder: (context) => IntroPage(),
          settings: settings,
        );
      case RoutesName.login:
        return MaterialPageRoute(
          builder: (context) => LoginPage(),
          settings: settings,
        );
      case RoutesName.register:
        return MaterialPageRoute(
          builder: (context) => RegisterPage(),
          settings: settings,
        );
      case RoutesName.mainPage:
        return MaterialPageRoute(
          builder: (context) => MainPage(),
          settings: settings,
        );
      case RoutesName.detailPage:
        final id = settings.arguments;
        if (id is! String) return _emptyPage;
        return MaterialPageRoute(
          builder: (context) => DetailRestaurantPage(id: id),
          settings: settings,
        );
      case RoutesName.addReview:
        final id = settings.arguments;
        if (id is! String) return _emptyPage;
        return MaterialPageRoute(
          builder: (context) => AddReviewPage(restoId: id),
          settings: settings,
        );

      default:
        return _emptyPage;
    }
  }
}
