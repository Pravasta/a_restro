import 'package:a_restro/data/model/response/restaurant_response_model.dart';
import 'package:a_restro/feature/home/provider/get_list_restaurant/get_list_restaurant_provider.dart';
import 'package:a_restro/feature/home/provider/get_list_restaurant/get_list_restaurant_state.dart';
import 'package:a_restro/feature/home/repository/home_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockHomeRepository extends Mock implements HomeRepository {}

void main() {
  late MockHomeRepository mockHomeRepository;
  late GetListRestaurantProvider provider;

  setUp(() {
    mockHomeRepository = MockHomeRepository();
    provider = GetListRestaurantProvider(
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

  group('GetListRestaurantProvider', () {
    test('should return GetListRestaurantIntialState when provider initialize',
        () {
      expect(provider.resultState, isA<GetListRestaurantInitialState>());
    });

    test('should get data from repository', () {
      when(() => mockHomeRepository.getRestaurantList())
          .thenAnswer((_) async => [dataResto]);
      provider.getAllRestaurant();
      verify(() => mockHomeRepository.getRestaurantList());
    });

    test(
      'should change state to GetListRestaurantLoadingState when repository is called',
      () {
        when(() => mockHomeRepository.getRestaurantList())
            .thenAnswer((_) async => [dataResto]);
        provider.getAllRestaurant();
        expect(provider.resultState, isA<GetListRestaurantLoadingState>());
      },
    );

    test(
      'should change state to GetListRestaurantLoadedState and dataResto when data is gotten successfully',
      () async {
        when(() => mockHomeRepository.getRestaurantList())
            .thenAnswer((_) async => [dataResto]);
        await provider.getAllRestaurant();

        expect(provider.resultState, isA<GetListRestaurantLoadedState>());
        final state = provider.resultState as GetListRestaurantLoadedState;
        expect(state.data, [dataResto]);
      },
    );

    test(
      'should change state to GetListRestaurantErrorState and return error when data is unsuccessful',
      () async {
        const errorMessage = 'Restaurant not found';
        when(() => mockHomeRepository.getRestaurantList())
            .thenThrow(errorMessage);
        await provider.getAllRestaurant();
        expect(provider.resultState, isA<GetListRestaurantErrorState>());
        final state = provider.resultState as GetListRestaurantErrorState;
        expect(state.error, errorMessage);
      },
    );
  });
}
