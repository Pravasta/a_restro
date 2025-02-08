import 'package:a_restro/feature/profile/provider/change_theme_provider.dart';
import 'package:a_restro/feature/profile/repository/profile_repository.dart';
import 'package:a_restro/feature/search/provider/search_restaurant_provider.dart';
import 'package:a_restro/feature/search/repository/search_repository.dart';
import 'package:a_restro/feature/search/view/search_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

class MockSearchRepository extends Mock implements SearchRepository {}

class MockProfileRepository extends Mock implements ProfileRepository {}

void main() {
  late MockSearchRepository mockSearchRepository;
  late MockProfileRepository mockProfileRepository;
  late SearchRestaurantProvider searchRestaurantProvider;
  late ChangeThemeProvider changeThemeProvider;
  late Widget widget;

  setUp(
    () {
      mockSearchRepository = MockSearchRepository();
      mockProfileRepository = MockProfileRepository();
      searchRestaurantProvider = SearchRestaurantProvider(
        repository: mockSearchRepository,
      );
      changeThemeProvider = ChangeThemeProvider(
        repository: mockProfileRepository,
      );
      widget = MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: searchRestaurantProvider),
          ChangeNotifierProvider.value(value: changeThemeProvider),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: SearchPage(),
          ),
        ),
      );
    },
  );

  group('Search page', () {
    testWidgets(
      'Have every component like AppBar, Default Field, and ContentSection',
      (widgetTester) async {
        await widgetTester.pumpWidget(widget);

        expect(find.byKey(ValueKey('default-appbar')), findsOneWidget);
        expect(find.byKey(ValueKey('content-key')), findsOneWidget);
        expect(find.byKey(ValueKey("default-field")), findsOneWidget);
        expect(find.byKey(ValueKey("result-search-initial")), findsOneWidget);
      },
    );
  });
}
