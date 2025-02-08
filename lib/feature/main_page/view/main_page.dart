import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:a_restro/feature/auth/provider/firebase_auth_provider.dart';
import 'package:a_restro/feature/favorite/provider/favorite_resto_provider.dart';
import 'package:a_restro/feature/favorite/view/favorite_restaurant_page.dart';
import 'package:a_restro/feature/home/provider/get_popular_restaurant/get_popular_restaurant_provider.dart';
import 'package:a_restro/feature/main_page/provider/index_bottom_nav/index_bottom_nav_provider.dart';
import 'package:a_restro/feature/main_page/provider/notifications/notification_provider.dart';
import 'package:a_restro/feature/profile/view/profile_page.dart';

import '../../../core/common/routes/navigation.dart';
import '../../../core/common/routes/routes_name.dart';
import '../../../data/model/response/received_notification_response_model.dart';
import '../../../data/service/local/notification_local_service.dart';
import '../../home/provider/get_list_restaurant/get_list_restaurant_provider.dart';
import '../../home/view/home_page.dart';
import '../../search/view/search_page.dart';
import '../provider/notifications/payload_notification_provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () {
        context.read<GetPopularRestaurantProvider>().getPopularResto();
        context.read<GetListRestaurantProvider>().getAllRestaurant();
        context.read<FavoriteRestoProvider>().getAllFavoriteRestaurant();
        context.read<NotificationProvider>().requestPermissions();
        context.read<FirebaseAuthProvider>().getCurrentUser();
      },
    );
    _configureSelectNotificationSubject();
    _configureDidReceiveLocalNotificationSubject();
  }

  void _configureSelectNotificationSubject() {
    selectNotificationSubject.stream.listen(
      (String? payload) {
        context.read<PayloadNotificationProvider>().payload = payload;
        Navigation.pushName(RoutesName.detailPage, arguments: payload);
      },
    );
  }

  void _configureDidReceiveLocalNotificationSubject() {
    didReceiveLocalNotificationSubject.stream.listen(
      (ReceivedNotificationResponseModel receivedNotificationResponse) {
        final payload = receivedNotificationResponse.payload;
        context.read<PayloadNotificationProvider>().payload = payload;
        Navigation.pushName(RoutesName.detailPage, arguments: payload);
      },
    );
  }

  @override
  void dispose() {
    selectNotificationSubject.close();
    didReceiveLocalNotificationSubject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<IndexBottomNavProvider>(
        builder: (context, value, child) {
          return switch (value.currentIndexBottomNavBar) {
            0 => const HomePage(),
            1 => const SearchPage(),
            2 => const FavoriteRestaurantPage(),
            _ => const ProfilePage(),
          };
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 4,
        currentIndex:
            context.watch<IndexBottomNavProvider>().currentIndexBottomNavBar,
        onTap: (value) =>
            context.read<IndexBottomNavProvider>().setIndexBottomNavBar = value,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: 35,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
              size: 35,
            ),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.bookmark,
              size: 35,
            ),
            label: 'Favorite',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              size: 35,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
