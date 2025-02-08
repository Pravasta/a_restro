import 'package:a_restro/data/model/response/restaurant_response_model.dart';
import 'package:a_restro/feature/profile/provider/change_theme_provider.dart';
import 'package:a_restro/feature/profile/repository/profile_repository.dart';
import 'package:a_restro/feature/search/provider/search_restaurant_provider.dart';
import 'package:a_restro/feature/search/repository/search_repository.dart';
import 'package:a_restro/feature/search/view/search_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

class MockSearchRepository extends Mock implements SearchRepository {}

class MockProfileRepository extends Mock implements ProfileRepository {}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late MockSearchRepository mockSearchRepository;
  late MockProfileRepository mockProfileRepository;
  late SearchRestaurantProvider searchRestaurantProvider;
  late ChangeThemeProvider changeThemeProvider;

  setUp(() {
    mockSearchRepository = MockSearchRepository();
    mockProfileRepository = MockProfileRepository();
    searchRestaurantProvider = SearchRestaurantProvider(
      repository: mockSearchRepository,
    );
    changeThemeProvider = ChangeThemeProvider(
      repository: mockProfileRepository,
    );
  });

  Widget createTestableWidget() {
    return MultiProvider(
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
  }

  final dataResto = Restaurant(
    id: 'rqdv5juczeskfw1e867',
    name: 'Melting Pot',
    city: 'Medan',
    pictureId: '14',
    rating: 4.2,
    description:
        'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. ...',
  );

  final defaultFieldKey = ValueKey("default-field");
  final defaultAppBarKey = ValueKey("default-appbar");
  final contentKey = ValueKey('content-key');
  final resultSearchGetData = ValueKey('result-search-get-data');
  final resultSearchInitial = ValueKey('result-search-initial');
  final resultSearchNotFound = ValueKey('result-search-not-found');
  final defaultLoading = ValueKey('default-loading');
  final String query = 'Melting';

  final defaultFieldFinder = find.byKey(defaultFieldKey);

  group('SearchPage Integration test', () {
    testWidgets('should return initial page', (widgetTester) async {
      await widgetTester.pumpWidget(createTestableWidget());

      expect(find.byKey(defaultAppBarKey), findsOneWidget);
      expect(find.byKey(contentKey), findsOneWidget);
      expect(find.byKey(defaultFieldKey), findsOneWidget);
      expect(find.byKey(resultSearchInitial), findsWidgets);
    });

    testWidgets(
      'Should display loading state followed by not found state when input text does not return any data.',
      (widgetTester) async {
        when(() => mockSearchRepository.searchRestaurant(any()))
            .thenAnswer((_) async => []);

        await widgetTester.pumpWidget(createTestableWidget());

        await widgetTester.tap(defaultFieldFinder);
        await widgetTester.enterText(defaultFieldFinder, 'query');

        searchRestaurantProvider.searchRestaurant('query');

        await widgetTester.pump();

        expect(find.byKey(defaultLoading), findsOneWidget);

        await widgetTester.pumpAndSettle();

        expect(find.byKey(defaultAppBarKey), findsOneWidget);
        expect(find.byKey(defaultFieldKey), findsOneWidget);
        expect(find.byKey(contentKey), findsOneWidget);
        expect(find.byKey(resultSearchNotFound), findsOneWidget);
      },
    );

    testWidgets(
      'Should display loading state followed by grid display when input text returns data.',
      (widgetTester) async {
        when(() => mockSearchRepository.searchRestaurant(query))
            .thenAnswer((_) async => [dataResto]);

        await widgetTester.pumpWidget(createTestableWidget());

        await widgetTester.tap(defaultFieldFinder);
        await widgetTester.enterText(defaultFieldFinder, query);

        searchRestaurantProvider.searchRestaurant(query);

        await widgetTester.pump();

        expect(find.byKey(defaultLoading), findsOneWidget);

        await widgetTester.pumpAndSettle();

        expect(find.byKey(defaultAppBarKey), findsOneWidget);
        expect(find.byKey(defaultFieldKey), findsOneWidget);
        expect(find.byKey(contentKey), findsOneWidget);
        expect(find.byKey(resultSearchGetData), findsOneWidget);
      },
    );
  });
}
