import 'package:flutter/material.dart';

import 'package:a_restro/core/extensions/build_context_ext.dart';

import '../../../../core/constant/style/app_colors.dart';
import '../../../../core/constant/style/app_text.dart';
import '../../../../core/constant/url_assets/url_assets.dart';

class MenuWidget extends StatelessWidget {
  const MenuWidget({super.key, required this.name, required this.type});

  final String name;
  final String type;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: context.deviceWidth * 1 / 2,
          height: context.deviceHeight * 1 / 4,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(
                type == 'food' ? UrlAssets.imagesFood : UrlAssets.imagesDrink,
              ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(20),
          width: context.deviceWidth * 1 / 2,
          height: context.deviceHeight * 1 / 4,
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
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Text(
              name,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: AppText.text20.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.whiteColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
