import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constant/style/app_colors.dart';
import '../../../../core/constant/style/app_text.dart';
import '../../../../core/constant/url_assets/url_assets.dart';
import '../../../profile/provider/change_theme_provider.dart';

class FavoriteInitialWidget extends StatelessWidget {
  const FavoriteInitialWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.read<ChangeThemeProvider>();
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(UrlAssets.iconFound, scale: 4),
          const SizedBox(height: 10),
          Text(
            'You not have favorite restaurant\nLet\'s add some!',
            textAlign: TextAlign.center,
            style: AppText.text20.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.isDarkTheme
                  ? AppColors.whiteColor
                  : AppColors.blackColor,
            ),
          ),
        ],
      ),
    );
  }
}
