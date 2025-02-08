import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:a_restro/core/components/loading/default_loading.dart';
import 'package:a_restro/core/components/message/default_error.dart';
import 'package:a_restro/core/components/message/message_bar.dart';
import 'package:a_restro/core/constant/style/app_colors.dart';
import 'package:a_restro/core/constant/style/app_text.dart';
import 'package:a_restro/core/constant/url_assets/url_assets.dart';
import 'package:a_restro/core/extensions/build_context_ext.dart';
import 'package:a_restro/feature/home/provider/get_list_restaurant/get_list_restaurant_provider.dart';
import 'package:a_restro/feature/home/provider/get_list_restaurant/get_list_restaurant_state.dart';
import 'package:a_restro/feature/home/provider/get_popular_restaurant/get_popular_restaurant_provider.dart';
import 'package:a_restro/feature/home/provider/get_popular_restaurant/get_popular_restaurant_state.dart';
import 'package:a_restro/feature/home/view/widget/popular_resto_widget.dart';
import 'package:a_restro/feature/home/view/widget/resto_widget.dart';

import '../../profile/provider/change_theme_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.read<ChangeThemeProvider>();

    AppBar appBar() {
      return AppBar(
        title: Image.asset(
          UrlAssets.iconLogoWithName,
          scale: 3.5,
        ),
        actions: [
          IconButton(
            onPressed: () {
              MessageBar.messageBar(context, 'The feature is coming soon');
            },
            icon: Icon(
              Icons.notifications,
              color: theme.isDarkTheme
                  ? AppColors.whiteColor
                  : AppColors.primaryDarkColor,
            ),
          ),
        ],
      );
    }

    Widget bannerSection() {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          width: context.deviceWidth,
          height: context.deviceHeight * 1 / 5,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(
                UrlAssets.imagesBanner,
              ),
            ),
          ),
        ),
      );
    }

    Widget popularRestoSection() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Popular Restaurants',
                  style: AppText.text24.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.isDarkTheme
                        ? AppColors.whiteColor
                        : AppColors.blackColor,
                  ),
                ),
                Text(
                  'All resto with rating > 4.4',
                  style: AppText.text14.copyWith(
                    color: theme.isDarkTheme
                        ? AppColors.whiteColor
                        : AppColors.greyLightColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Consumer<GetPopularRestaurantProvider>(
            builder: (context, value, child) {
              return switch (value.resultState) {
                GetPopularRestaurantLoadingState() => DefaultLoading(),
                GetPopularRestaurantErrorState(error: var error) =>
                  DefaultError(
                    error: error,
                  ),
                GetPopularRestaurantLoadedState(data: var data) => SizedBox(
                    height: context.deviceHeight * 2 / 5,
                    width: context.deviceWidth,
                    child: ListView.builder(
                      itemCount: data.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final restaurant = data[index];
                        return Container(
                          margin: EdgeInsets.only(
                            left: index == 0 ? 20 : 0,
                            right: index == data.length - 1 ? 20 : 15,
                          ),
                          child: PopularRestoWidget(restaurant: restaurant),
                        );
                      },
                    ),
                  ),
                _ => SizedBox(),
              };
            },
          )
        ],
      );
    }

    Widget allRestoSection() {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Restaurants Nearby',
              style: AppText.text24.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.isDarkTheme
                    ? AppColors.whiteColor
                    : AppColors.blackColor,
              ),
            ),
            Text(
              'Restaurants around you',
              style: AppText.text14.copyWith(
                color: theme.isDarkTheme
                    ? AppColors.whiteColor
                    : AppColors.greyLightColor,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            Consumer<GetListRestaurantProvider>(
              builder: (context, value, child) {
                return switch (value.resultState) {
                  GetListRestaurantLoadingState() => DefaultLoading(),
                  GetListRestaurantErrorState(error: var error) => DefaultError(
                      error: error,
                    ),
                  GetListRestaurantLoadedState(data: var data) =>
                    ListView.builder(
                      itemCount: data.length,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final restaurant = data[index];

                        return Column(
                          children: [
                            RestoWidget(restaurant: restaurant),
                            index == data.length - 1
                                ? SizedBox()
                                : const SizedBox(height: 15),
                          ],
                        );
                      },
                    ),
                  _ => SizedBox(),
                };
              },
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: appBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            bannerSection(),
            popularRestoSection(),
            allRestoSection(),
          ],
        ),
      ),
    );
  }
}
