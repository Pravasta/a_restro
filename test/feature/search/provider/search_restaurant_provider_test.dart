import 'package:a_restro/data/model/response/restaurant_response_model.dart';
import 'package:a_restro/feature/search/provider/search_restaurant_provider.dart';
import 'package:a_restro/feature/search/provider/search_restaurant_state.dart';
import 'package:a_restro/feature/search/repository/search_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSearchRepository extends Mock implements SearchRepository {}

void main() {
  late MockSearchRepository mockSearchRepository;
  late SearchRestaurantProvider provider;

  setUp(() {
    mockSearchRepository = MockSearchRepository();
    provider = SearchRestaurantProvider(repository: mockSearchRepository);
  });

  final dataResto = Restaurant(
    id: 'rqdv5juczeskfw1e867',
    name: 'Melting Pot',
    description:
        'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. ...',
    pictureId: '14',
    city: 'Medan',
    rating: 4.2,
  );

  final String query = 'Melting';

  group('SearchRestaurantProvider', () {
    test('should return SearchRestaurantInitialState', () {
      expect(provider.resultState, isA<SearchRestaurantInitialState>());
    });

    test('should get data from repository', () {
      when(() => mockSearchRepository.searchRestaurant(query))
          .thenAnswer((_) async => [dataResto]);
      provider.searchRestaurant(query);
      verifyNever(() => mockSearchRepository.searchRestaurant(query));
    });

    test(
      'should change state to SearchRestaurantLoadingState when repository is called',
      () {
        when(() => mockSearchRepository.searchRestaurant(query))
            .thenAnswer((_) async => [dataResto]);
        provider.searchRestaurant(query);
        expect(provider.resultState, isA<SearchRestaurantLoadingState>());
      },
    );
    test(
      'should change state to SearchRestaurantLoadedState and dataResto when data is gotten successfully',
      () async {
        when(() => mockSearchRepository.searchRestaurant(query))
            .thenAnswer((_) async => [dataResto]);
        await provider.searchRestaurant(query);

        expect(provider.resultState, isA<SearchRestaurantLoadedState>());
        final state = provider.resultState as SearchRestaurantLoadedState;
        expect(state.data, [dataResto]);
      },
    );
    test(
      'should change state to SearchRestaurantErrorState and return error when data is unsuccessful',
      () async {
        const errorMessage = 'Restaurant not found';
        when(() => mockSearchRepository.searchRestaurant(query))
            .thenThrow(errorMessage);
        await provider.searchRestaurant(query);
        expect(provider.resultState, isA<SearchRestaurantErrorState>());
        final state = provider.resultState as SearchRestaurantErrorState;
        expect(state.error, errorMessage);
      },
    );
  });
}
