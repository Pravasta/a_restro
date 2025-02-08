import 'package:a_restro/data/model/response/restaurant_response_model.dart';
import 'package:a_restro/feature/home/provider/get_popular_restaurant/get_popular_restaurant_provider.dart';
import 'package:a_restro/feature/home/provider/get_popular_restaurant/get_popular_restaurant_state.dart';
import 'package:a_restro/feature/home/repository/home_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockHomeRepository extends Mock implements HomeRepository {}

void main() {
  late MockHomeRepository mockHomeRepository;
  late GetPopularRestaurantProvider provider;

  setUp(() {
    mockHomeRepository = MockHomeRepository();
    provider = GetPopularRestaurantProvider(
      repository: mockHomeRepository,
    );
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

  final dataRestoList = [dataResto];

  group('GetPopularRestaurantProvider', () {
    test(
        'should return GetPopularRestaurantInitialState when provider initialize',
        () {
      expect(provider.resultState, isA<GetPopularRestaurantInitialState>());
    });

    test('should get data from repository', () {
      when(() => mockHomeRepository.getRestaurantList())
          .thenAnswer((_) async => dataRestoList);
      provider.getPopularResto();
      verify(() => mockHomeRepository.getRestaurantList());
    });

    test(
      'should change state to GetPopularRestaurantLoadingState when repository is called',
      () {
        when(() => mockHomeRepository.getRestaurantList())
            .thenAnswer((_) async => dataRestoList);
        provider.getPopularResto();
        expect(provider.resultState, isA<GetPopularRestaurantLoadingState>());
      },
    );

    test(
      'should change state to GetPopularRestaurantLoadedState and dataResto when data is gotten successfully',
      () async {
        when(() => mockHomeRepository.getRestaurantList())
            .thenAnswer((_) async => dataRestoList);
        await provider.getPopularResto();

        expect(provider.resultState, isA<GetPopularRestaurantLoadedState>());
        final state = provider.resultState as GetPopularRestaurantLoadedState;
        expect(state.data.length, 0);
      },
    );

    test(
      'should change state to GetPopularRestaurantErrorState and return error when data is unsuccessful',
      () async {
        const errorMessage = 'Restaurant not found';
        when(() => mockHomeRepository.getRestaurantList())
            .thenThrow(errorMessage);
        await provider.getPopularResto();
        expect(provider.resultState, isA<GetPopularRestaurantErrorState>());
        final state = provider.resultState as GetPopularRestaurantErrorState;
        expect(state.error, errorMessage);
      },
    );
  });
}
