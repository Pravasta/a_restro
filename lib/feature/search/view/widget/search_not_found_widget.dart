import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:a_restro/core/constant/style/app_colors.dart';
import 'package:a_restro/core/extensions/build_context_ext.dart';

import '../../../../core/constant/style/app_text.dart';
import '../../../../core/constant/url_assets/url_assets.dart';
import '../../../profile/provider/change_theme_provider.dart';

class SearchNotFoundWidget extends StatelessWidget {
  const SearchNotFoundWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.read<ChangeThemeProvider>();
    return Column(
      children: [
        SizedBox(height: context.deviceHeight * 1 / 6),
        Image.asset(UrlAssets.iconFound, scale: 4),
        const SizedBox(height: 15),
        Text(
          'Restaurant not found\nplease search with other keywords',
          textAlign: TextAlign.center,
          style: AppText.text18.copyWith(
            fontWeight: FontWeight.w700,
            color:
                theme.isDarkTheme ? AppColors.whiteColor : AppColors.blackColor,
          ),
        ),
      ],
    );
  }
}
