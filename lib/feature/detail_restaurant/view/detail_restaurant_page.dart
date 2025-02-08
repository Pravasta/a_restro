import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:a_restro/core/common/routes/navigation.dart';
import 'package:a_restro/core/common/routes/routes_name.dart';
import 'package:a_restro/core/components/loading/default_loading.dart';
import 'package:a_restro/core/components/message/default_error.dart';
import 'package:a_restro/core/components/message/message_bar.dart';
import 'package:a_restro/core/constant/style/app_colors.dart';
import 'package:a_restro/core/constant/style/app_text.dart';
import 'package:a_restro/core/extensions/build_context_ext.dart';
import 'package:a_restro/core/variables/variable.dart';
import 'package:a_restro/data/model/request/add_favorite_resto_request_model.dart';
import 'package:a_restro/feature/detail_restaurant/provider/bookmark_resto/bookmark_resto_provider.dart';
import 'package:a_restro/feature/detail_restaurant/provider/get_detail_provider/get_detail_restaurant_provider.dart';
import 'package:a_restro/feature/detail_restaurant/provider/get_detail_provider/get_detail_restaurant_state.dart';
import 'package:a_restro/feature/detail_restaurant/view/widget/review_card_widget.dart';
import 'package:a_restro/feature/favorite/provider/favorite_resto_provider.dart';
import 'package:a_restro/feature/profile/provider/change_theme_provider.dart';

import '../../../core/constant/url_assets/url_assets.dart';
import '../../../core/utils/route_observer.dart';
import '../../../data/model/response/restaurant_detail_response_model.dart';
import 'widget/menu_widget.dart';

class DetailRestaurantPage extends StatefulWidget {
  const DetailRestaurantPage({super.key, required this.id});

  final String id;

  @override
  State<DetailRestaurantPage> createState() => _DetailRestaurantPageState();
}

class _DetailRestaurantPageState extends State<DetailRestaurantPage>
    with RouteAware {
  @override
  void initState() {
    super.initState();
    final bookmarkProvider = context.read<BookmarkRestoProvider>();
    Future.microtask(
      () {
        context
            .read<GetDetailRestaurantProvider>()
            .getDetailRestaurant(widget.id);
        final value = bookmarkProvider.checkBookmarked(widget.id);
        value.then(
          (value) {
            bookmarkProvider.isBookmarked = value;
          },
        );
      },
    );
  }

  @override
  void didPopNext() {
    context.read<GetDetailRestaurantProvider>().getDetailRestaurant(widget.id);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.read<ChangeThemeProvider>();

    AppBar appBar() {
      return AppBar(
        centerTitle: true,
        title: Image.asset(
          UrlAssets.iconLogoWithName,
          scale: 3.5,
        ),
        leading: BackButton(
          color:
              theme.isDarkTheme ? AppColors.whiteColor : AppColors.blackColor,
        ),
      );
    }

    Widget imageSection(RestaurantDetail data) {
      return Hero(
        tag: data.pictureId ?? '',
        child: Container(
          margin: EdgeInsets.only(top: 20),
          width: context.deviceWidth,
          height: context.deviceHeight * 1 / 3,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(
                '${Variable.baseImageUrl}/${data.pictureId}',
              ),
            ),
          ),
        ),
      );
    }

    Widget detailRestaurantSection(RestaurantDetail data) {
      return Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    data.name ?? '',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: AppText.text24.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.isDarkTheme
                          ? AppColors.whiteColor
                          : AppColors.blackColor,
                    ),
                  ),
                ),
                for (double i = 1; i <= data.rating!; i++)
                  Icon(
                    Icons.star,
                    color: Colors.orange,
                  ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${data.address}, ${data.city}',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: AppText.text16.copyWith(
                      fontWeight: FontWeight.w700,
                      color: theme.isDarkTheme
                          ? AppColors.whiteColor
                          : AppColors.greyColor,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    final dataProvider = context.read<BookmarkRestoProvider>();
                    final localRestoService =
                        context.read<FavoriteRestoProvider>();

                    final dataResto = AddFavoriteRestoRequestModel(
                      id: data.id ?? '',
                      name: data.name ?? '',
                      description: data.description ?? '',
                      pictureId: data.pictureId ?? '',
                      city: data.city ?? '',
                      rating: data.rating ?? 0.0,
                    );

                    if (!dataProvider.isBookmark) {
                      await dataProvider.addBookmark(dataResto);
                    } else {
                      await dataProvider.removeBookmark(dataResto.id);
                    }

                    dataProvider.isBookmarked = !dataProvider.isBookmark;

                    MessageBar.messageBar(context, dataProvider.message);

                    localRestoService.getAllFavoriteRestaurant();
                  },
                  child: Icon(
                    context.watch<BookmarkRestoProvider>().isBookmark
                        ? Icons.favorite
                        : Icons.favorite_border_outlined,
                    color:
                        theme.isDarkTheme ? AppColors.whiteColor : Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Description',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: AppText.text20.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.isDarkTheme
                    ? AppColors.whiteColor
                    : AppColors.blackColor,
              ),
            ),
            const SizedBox(height: 5),
            ExpandableText(
              data.description ?? '',
              expandText: 'show more',
              collapseText: 'show less',
              textAlign: TextAlign.justify,
              maxLines: 5,
              style: AppText.text14.copyWith(
                color: theme.isDarkTheme
                    ? AppColors.whiteColor
                    : AppColors.greyColor,
                fontWeight: FontWeight.w600,
              ),
              linkColor: theme.isDarkTheme
                  ? AppColors.secondaryLightColor
                  : AppColors.primaryColor,
            ),
            const SizedBox(height: 20),
            Text(
              'Categories',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: AppText.text20.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.isDarkTheme
                    ? AppColors.whiteColor
                    : AppColors.blackColor,
              ),
            ),
            const SizedBox(height: 5),
            Row(
              children: data.categories!
                  .map(
                    (e) => Flexible(
                      flex: 1,
                      child: Row(
                        children: [
                          Icon(
                            Icons.check,
                            color: theme.isDarkTheme
                                ? AppColors.whiteColor
                                : AppColors.blackColor,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            e.name ?? '',
                            style: AppText.text16.copyWith(
                              color: theme.isDarkTheme
                                  ? AppColors.whiteColor
                                  : AppColors.greyColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      );
    }

    Widget menuSection(RestaurantDetail data) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              'Menu',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: AppText.text20.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.isDarkTheme
                    ? AppColors.whiteColor
                    : AppColors.blackColor,
              ),
            ),
          ),
          const SizedBox(height: 5),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
                children: data.menus!.foods!.asMap().entries.map(
              (e) {
                int index = e.key;
                var menu = e.value;
                return Container(
                  margin: EdgeInsets.only(
                    right: index == data.menus!.foods!.length - 1 ? 20 : 10,
                    left: index == 0 ? 20 : 0,
                  ),
                  child: MenuWidget(type: 'food', name: menu.name ?? ''),
                );
              },
            ).toList()),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
                children: data.menus!.drinks!.asMap().entries.map(
              (e) {
                int index = e.key;
                var menu = e.value;
                return Container(
                  margin: EdgeInsets.only(
                    right: index == data.menus!.drinks!.length - 1 ? 20 : 10,
                    left: index == 0 ? 20 : 0,
                  ),
                  child: MenuWidget(type: 'drink', name: menu.name ?? ''),
                );
              },
            ).toList()),
          ),
        ],
      );
    }

    Widget customersReviewSection(RestaurantDetail data) {
      return Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Customers Review',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: AppText.text20.copyWith(
                      color: theme.isDarkTheme
                          ? AppColors.whiteColor
                          : AppColors.blackColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigation.pushName(
                    RoutesName.addReview,
                    arguments: data.id,
                  ),
                  icon: Icon(
                    Icons.reviews_outlined,
                    color: theme.isDarkTheme
                        ? AppColors.secondaryLightColor
                        : AppColors.primaryDarkColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: data.customerReviews!.length,
              itemBuilder: (context, index) {
                return ReviewCardWidget(
                  review: data.customerReviews![index],
                );
              },
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: appBar(),
      body: SingleChildScrollView(
        child: Consumer<GetDetailRestaurantProvider>(
          builder: (context, value, child) {
            return switch (value.resultState) {
              GetDetailRestaurantLoadingState() => DefaultLoading(
                  height: context.deviceHeight * 1 / 4,
                ),
              GetDetailRestaurantErrorState(error: var error) => DefaultError(
                  error: error,
                ),
              GetDetailRestaurantLoadedState(data: var data) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    imageSection(data),
                    detailRestaurantSection(data),
                    menuSection(data),
                    customersReviewSection(data),
                  ],
                ),
              GetDetailRestaurantIntialState() => SizedBox(),
            };
          },
        ),
      ),
    );
  }
}
