import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:a_restro/data/model/response/restaurant_detail_response_model.dart';
import 'package:a_restro/feature/profile/provider/change_theme_provider.dart';

import '../../../../core/constant/style/app_colors.dart';
import '../../../../core/constant/style/app_text.dart';
import '../../../../core/constant/url_assets/url_assets.dart';

class ReviewCardWidget extends StatelessWidget {
  const ReviewCardWidget({super.key, required this.review});

  final CustomerReview review;

  @override
  Widget build(BuildContext context) {
    final theme = context.read<ChangeThemeProvider>();

    return ListTile(
      contentPadding: EdgeInsets.all(0),
      leading: CircleAvatar(
        backgroundImage: AssetImage(
          UrlAssets.iconAvatar,
        ),
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              review.name ?? '',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: AppText.text18.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.isDarkTheme
                    ? AppColors.whiteColor
                    : AppColors.blackColor,
              ),
            ),
          ),
          Text(
            review.date ?? '',
            style: AppText.text12.copyWith(
              color: theme.isDarkTheme
                  ? AppColors.whiteColor
                  : AppColors.blackColor,
            ),
          ),
        ],
      ),
      subtitle: Text(
        review.review ?? '',
        style: AppText.text14.copyWith(
          fontWeight: FontWeight.w700,
          color: theme.isDarkTheme
              ? AppColors.whiteColor
              : AppColors.greyLightColor,
        ),
      ),
      isThreeLine: true,
    );
  }
}
