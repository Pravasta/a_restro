import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:a_restro/data/service/local/notification_local_service.dart';
import 'package:a_restro/data/service/local/shared_preferences_local_service.dart';
import 'package:a_restro/data/service/local/work_manager_service.dart';
import 'package:a_restro/data/service/remote/firebase_service.dart';
import 'package:a_restro/feature/auth/provider/firebase_auth_provider.dart';
import 'package:a_restro/feature/detail_restaurant/provider/add_review/add_review_restaurant_provider.dart';
import 'package:a_restro/feature/detail_restaurant/provider/bookmark_resto/bookmark_resto_provider.dart';
import 'package:a_restro/feature/detail_restaurant/provider/get_detail_provider/get_detail_restaurant_provider.dart';
import 'package:a_restro/feature/detail_restaurant/repository/detail_restaurant_repository.dart';
import 'package:a_restro/feature/favorite/provider/favorite_resto_provider.dart';
import 'package:a_restro/feature/favorite/repository/favorite_repository.dart';
import 'package:a_restro/feature/home/provider/get_list_restaurant/get_list_restaurant_provider.dart';
import 'package:a_restro/feature/home/provider/get_popular_restaurant/get_popular_restaurant_provider.dart';
import 'package:a_restro/feature/home/repository/home_repository.dart';
import 'package:a_restro/feature/main_page/provider/index_bottom_nav/index_bottom_nav_provider.dart';
import 'package:a_restro/feature/main_page/provider/notifications/notification_provider.dart';
import 'package:a_restro/feature/profile/provider/change_theme_provider.dart';
import 'package:a_restro/feature/profile/provider/toogle_schedule_notification_provider.dart';
import 'package:a_restro/feature/profile/repository/profile_repository.dart';
import 'package:a_restro/feature/search/provider/search_restaurant_provider.dart';
import 'package:a_restro/feature/search/repository/search_repository.dart';
import 'package:a_restro/firebase_options.dart';
import 'package:a_restro/my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        FutureProvider<SharedPreferences>(
          create: (_) => SharedPreferences.getInstance(),
          initialData: await SharedPreferences.getInstance(),
        ),
        Provider(
          create: (context) => SharedPreferencesLocalService(
            sharedPreferences: context.read<SharedPreferences>(),
          ),
        ),
        Provider(
          create: (context) => ProfileRepository(
            localService: context.read<SharedPreferencesLocalService>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => IndexBottomNavProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ChangeThemeProvider(
            repository: context.read<ProfileRepository>(),
          )..loadTheme(),
        ),
        ChangeNotifierProvider(
          create: (context) => ToogleScheduleNotificationProvider(
            profileRepository: context.read<ProfileRepository>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => FirebaseAuthProvider(
            firebaseService: FirebaseService.create(),
            localService: context.read<SharedPreferencesLocalService>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => GetListRestaurantProvider(
            repository: HomeRepository.create(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => GetPopularRestaurantProvider(
            repository: HomeRepository.create(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => SearchRestaurantProvider(
            repository: SearchRepository.create(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => GetDetailRestaurantProvider(
            detailRestaurantRepository: DetailRestaurantRepository.create(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => AddReviewRestaurantProvider(
            repository: DetailRestaurantRepository.create(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => FavoriteRestoProvider(
            repository: FavoriteRepository.create(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => BookmarkRestoProvider(
            repository: DetailRestaurantRepository.create(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => NotificationProvider(
            notificationLocalService: NotificationLocalService.create()..init(),
            workManagerService: WorkManagerService.create()
              ..init()
              ..configureLocalTimeZone(),
          ),
        ),
      ],
      child: MyApp(),
    ),
  );
}
