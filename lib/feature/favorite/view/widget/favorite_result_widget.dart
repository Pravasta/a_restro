import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:a_restro/core/components/message/message_bar.dart';
import 'package:a_restro/core/extensions/build_context_ext.dart';
import 'package:a_restro/core/variables/variable.dart';
import 'package:a_restro/data/model/response/restaurant_response_model.dart';
import 'package:a_restro/feature/detail_restaurant/provider/bookmark_resto/bookmark_resto_provider.dart';
import 'package:a_restro/feature/favorite/provider/favorite_resto_provider.dart';

import '../../../../core/common/routes/navigation.dart';
import '../../../../core/common/routes/routes_name.dart';
import '../../../../core/constant/style/app_colors.dart';
import '../../../../core/constant/style/app_text.dart';

class FavoriteResultWidget extends StatelessWidget {
  const FavoriteResultWidget({super.key, required this.restaurant});

  final Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigation.pushName(
        RoutesName.detailPage,
        arguments: restaurant.id,
      ),
      child: Material(
        shadowColor: AppColors.greyColor,
        borderRadius: BorderRadius.circular(15),
        elevation: 2,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(width: 0.1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    width: context.deviceWidth,
                    height: context.deviceHeight * 1 / 5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          '${Variable.baseImageUrl}/${restaurant.pictureId}',
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: IconButton(
                      onPressed: () {
                        final dataProvider =
                            context.read<BookmarkRestoProvider>();

                        dataProvider.removeBookmark(restaurant.id ?? '');

                        MessageBar.messageBar(context, dataProvider.message);

                        context
                            .read<FavoriteRestoProvider>()
                            .getAllFavoriteRestaurant();
                      },
                      icon: Icon(
                        Icons.delete,
                        size: 30,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            restaurant.name ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppText.text20.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              size: 25,
                              color: Colors.orange,
                            ),
                            Text(
                              restaurant.rating.toString(),
                              style: AppText.text18.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Text(
                      restaurant.city ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.text16.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.greyColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
