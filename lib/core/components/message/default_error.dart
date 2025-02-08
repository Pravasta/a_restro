import 'package:a_restro/core/constant/style/app_colors.dart';
import 'package:a_restro/core/constant/style/app_text.dart';
import 'package:flutter/material.dart';

class DefaultError extends StatelessWidget {
  const DefaultError({super.key, required this.error});

  final String error;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Icon(
            Icons.error_outline_outlined,
            color: AppColors.greyLightColor,
            size: 100,
          ),
          Text(
            error,
            textAlign: TextAlign.center,
            style: AppText.text16.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Please refresh the page',
            textAlign: TextAlign.center,
            style: AppText.text14.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.greyLightColor,
            ),
          ),
        ],
      ),
    );
  }
}
