import 'package:a_restro/data/model/response/restaurant_response_model.dart';
import 'package:a_restro/data/model/response/search_restaurant_response_model.dart';
import 'package:a_restro/data/service/remote/restaurant_service.dart';
import 'package:a_restro/feature/search/repository/search_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRestaurantService extends Mock implements RestaurantService {}

void main() {
  late MockRestaurantService mockRestaurantService;
  late SearchRepository searchRepository;

  setUp(() {
    mockRestaurantService = MockRestaurantService();
    searchRepository = SearchRepository(service: mockRestaurantService);
  });

  final String query = 'Melting';

  final dataResto = Restaurant(
    id: 'rqdv5juczeskfw1e867',
    name: 'Melting Pot',
    description:
        'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. ...',
    pictureId: '14',
    city: 'Medan',
    rating: 4.2,
  );

  final mockSearchRestaurantResponseModel = SearchRestaurantResponseModel(
    restaurants: [dataResto],
    founded: 1,
    error: false,
  );

  final mockSearchRestaurantResponseModelEmpty = SearchRestaurantResponseModel(
    restaurants: [],
    founded: 0,
    error: false,
  );

  group('Search Repository', () {
    test(
      'should return a list of restaurant when service call succesfully',
      () async {
        when(() => mockRestaurantService.searchRestaurant(query))
            .thenAnswer((_) async => mockSearchRestaurantResponseModel);
        final result = await searchRepository.searchRestaurant(query);

        expect(result.length, 1);
        expect(result[0], mockSearchRestaurantResponseModel.restaurants![0]);
      },
    );

    test(
      'should return an empty list when there are no restaurants',
      () async {
        when(() => mockRestaurantService.searchRestaurant(query))
            .thenAnswer((_) async => mockSearchRestaurantResponseModelEmpty);

        final result = await searchRepository.searchRestaurant(query);

        expect(result, isEmpty);
      },
    );

    test(
      'should throw an exception when service call fails',
      () {
        const errorMessage = 'Failed to fetch data';
        when(() => mockRestaurantService.searchRestaurant(query))
            .thenThrow(errorMessage);

        final call = searchRepository.searchRestaurant;

        expect(call(query), throwsA(errorMessage));
      },
    );
  });
}
