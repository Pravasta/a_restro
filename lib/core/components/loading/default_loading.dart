import 'package:a_restro/core/constant/url_assets/url_assets.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class DefaultLoading extends StatelessWidget {
  const DefaultLoading({
    super.key,
    this.height = 0,
  });

  final double? height;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: height),
          Lottie.asset(
            UrlAssets.loadingLottie,
            width: 150,
          ),
        ],
      ),
    );
  }
}
