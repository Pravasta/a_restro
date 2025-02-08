import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:a_restro/core/components/loading/default_loading.dart';
import 'package:a_restro/core/extensions/build_context_ext.dart';
import 'package:a_restro/feature/favorite/provider/favorite_resto_provider.dart';
import 'package:a_restro/feature/favorite/provider/favorite_resto_state.dart';
import 'package:a_restro/feature/favorite/view/widget/favorite_initial_widget.dart';
import 'package:a_restro/feature/favorite/view/widget/favorite_result_widget.dart';

import '../../../core/components/message/default_error.dart';
import '../../../core/constant/url_assets/url_assets.dart';

class FavoriteRestaurantPage extends StatelessWidget {
  const FavoriteRestaurantPage({super.key});

  @override
  Widget build(BuildContext context) {
    AppBar appBar() {
      return AppBar(
        title: Image.asset(
          UrlAssets.iconLogoWithName,
          scale: 3.5,
        ),
        centerTitle: true,
      );
    }

    return Scaffold(
      appBar: appBar(),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Consumer<FavoriteRestoProvider>(
          builder: (context, value, child) {
            return switch (value.resultState) {
              FavoriteRestoLoadingState() => DefaultLoading(
                  height: context.deviceHeight * 1 / 4,
                ),
              FavoriteRestoErrorState(message: var message) => DefaultError(
                  error: message,
                ),
              FavoriteRestoLoadedState(data: var data) => data.isEmpty
                  ? FavoriteInitialWidget()
                  : ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final restaurant = data[index];
                        return Container(
                          margin: EdgeInsets.only(bottom: 10),
                          child: FavoriteResultWidget(restaurant: restaurant),
                        );
                      },
                    ),
              FavoriteRestoSuccessState() => SizedBox(),
              FavoriteRestoInitialState() => FavoriteInitialWidget(),
            };
          },
        ),
      ),
    );
  }
}
