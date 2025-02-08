import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:a_restro/core/components/field/default_field.dart';
import 'package:a_restro/core/components/loading/default_loading.dart';
import 'package:a_restro/core/components/message/default_error.dart';
import 'package:a_restro/core/extensions/build_context_ext.dart';
import 'package:a_restro/feature/search/provider/search_restaurant_provider.dart';
import 'package:a_restro/feature/search/provider/search_restaurant_state.dart';
import 'package:a_restro/feature/search/view/widget/search_initial_widget.dart';
import 'package:a_restro/feature/search/view/widget/search_not_found_widget.dart';
import 'package:a_restro/feature/search/view/widget/search_result_widget.dart';

import '../../../core/constant/url_assets/url_assets.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late TextEditingController _searchC;

  @override
  void initState() {
    super.initState();
    _searchC = TextEditingController();
  }

  @override
  void dispose() {
    _searchC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppBar appBar() {
      return AppBar(
        key: ValueKey("default-appbar"),
        centerTitle: true,
        title: Image.asset(
          UrlAssets.iconLogoWithName,
          scale: 3.5,
        ),
      );
    }

    Widget fieldSearchSection() {
      return DefaultField(
        key: ValueKey('default-field'),
        prefixIcon: Icon(Icons.search),
        hintText: 'Search restaurants..',
        controller: _searchC,
        suffixIcon: IconButton(
          onPressed: () {
            _searchC.clear();
            context
                .read<SearchRestaurantProvider>()
                .searchRestaurant(_searchC.text);
          },
          icon: Icon(
            Icons.clear,
          ),
        ),
        onChanged: (value) {
          context.read<SearchRestaurantProvider>().searchRestaurant(value);
        },
      );
    }

    Widget contentSection() {
      return Consumer<SearchRestaurantProvider>(
        key: ValueKey('content-key'),
        builder: (context, SearchRestaurantProvider value, child) {
          return switch (value.resultState) {
            SearchRestaurantLoadingState() => DefaultLoading(
                key: ValueKey('default-loading'),
                height: context.deviceHeight * 1 / 4,
              ),
            SearchRestaurantErrorState(error: var error) => DefaultError(
                error: error,
              ),
            SearchRestaurantLoadedState(data: var data) => (_searchC
                    .text.isEmpty)
                ? SearchInitialWidget()
                : (data.isEmpty)
                    ? SearchNotFoundWidget(
                        key: ValueKey('result-search-not-found'),
                      )
                    : GridView.builder(
                        key: ValueKey('result-search-get-data'),
                        itemCount: data.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          mainAxisExtent: context.deviceHeight * 1 / 3,
                        ),
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return SearchResultWidget(
                            restaurant: data[index],
                          );
                        },
                      ),
            SearchRestaurantInitialState() => SearchInitialWidget(
                key: ValueKey('result-search-initial'),
              ),
          };
        },
      );
    }

    return Scaffold(
      appBar: appBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              fieldSearchSection(),
              const SizedBox(height: 20),
              contentSection(),
            ],
          ),
        ),
      ),
    );
  }
}
