import 'package:a_restro/data/model/response/restaurant_response_model.dart';
import 'package:a_restro/data/service/remote/restaurant_service.dart';
import 'package:a_restro/feature/home/repository/home_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRestaurantService extends Mock implements RestaurantService {}

void main() {
  late MockRestaurantService mockRestaurantService;
  late HomeRepository homeRepository;

  setUp(() {
    mockRestaurantService = MockRestaurantService();
    homeRepository = HomeRepository(restaurantService: mockRestaurantService);
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

  final mockRestaurantResponseModel = RestaurantResponseModel(
    restaurants: [dataResto],
    message: '',
    count: 0,
    error: false,
  );

  final mockRestaurantResponseModelEmpty = RestaurantResponseModel(
    restaurants: [],
    message: '',
    count: 0,
    error: false,
  );

  group('Home Repository', () {
    test(
      'should return a list of restaurant when service call succesfully',
      () async {
        when(() => mockRestaurantService.getRestaurantList())
            .thenAnswer((_) async => mockRestaurantResponseModel);
        final result = await homeRepository.getRestaurantList();

        expect(result.length, 1);
        expect(result[0], mockRestaurantResponseModel.restaurants![0]);
      },
    );

    test(
      'should return an empty list when there are no restaurants',
      () async {
        when(() => mockRestaurantService.getRestaurantList())
            .thenAnswer((_) async => mockRestaurantResponseModelEmpty);

        final result = await homeRepository.getRestaurantList();

        expect(result, isEmpty);
      },
    );

    test(
      'should throw an exception when service call fails',
      () {
        const errorMessage = 'Failed to fetch data';
        when(() => mockRestaurantService.getRestaurantList())
            .thenThrow(errorMessage);

        final call = homeRepository.getRestaurantList;

        expect(call(), throwsA(errorMessage));
      },
    );
  });
}
