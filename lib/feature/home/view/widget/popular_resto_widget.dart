import 'package:flutter/material.dart';

import 'package:a_restro/core/common/routes/navigation.dart';
import 'package:a_restro/core/common/routes/routes_name.dart';
import 'package:a_restro/core/constant/style/app_colors.dart';
import 'package:a_restro/core/constant/style/app_text.dart';
import 'package:a_restro/core/extensions/build_context_ext.dart';
import 'package:a_restro/core/variables/variable.dart';
import 'package:a_restro/data/model/response/restaurant_response_model.dart';

class PopularRestoWidget extends StatelessWidget {
  const PopularRestoWidget({super.key, this.restaurant});

  final Restaurant? restaurant;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigation.pushName(
        RoutesName.detailPage,
        arguments: restaurant!.id,
      ),
      child: Material(
        shadowColor: AppColors.greyColor,
        borderRadius: BorderRadius.circular(15),
        elevation: 2,
        child: Stack(
          children: [
            Hero(
              tag: restaurant!.pictureId ?? '',
              child: Container(
                width: context.deviceWidth * 2 / 3,
                height: context.deviceHeight * 2 / 5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      '${Variable.baseImageUrl}/${restaurant!.pictureId}',
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 80,
                      margin: const EdgeInsets.all(10),
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: AppColors.greyColor.withAlpha(120),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.orange,
                            size: 20,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            restaurant!.rating.toString(),
                            style: AppText.text14.copyWith(
                              color: AppColors.whiteColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: context.deviceWidth * 2 / 3,
              height: context.deviceHeight * 2 / 5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryDarkColor,
                    AppColors.greyLightColor.withAlpha(100),
                    Colors.transparent,
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      restaurant!.name ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.text20.copyWith(
                        color: AppColors.whiteColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      restaurant!.city ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.text16.copyWith(
                        color: AppColors.whiteColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
