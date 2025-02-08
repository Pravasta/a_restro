import 'package:a_restro/data/model/request/add_favorite_resto_request_model.dart';
import 'package:a_restro/data/model/request/add_review_request_model.dart';
import 'package:a_restro/data/model/response/add_review_response_model.dart';
import 'package:a_restro/data/model/response/restaurant_detail_response_model.dart';
import 'package:a_restro/data/model/response/restaurant_response_model.dart';
import 'package:a_restro/data/service/local/restaurant_local_service.dart';
import 'package:a_restro/data/service/remote/restaurant_service.dart';
import 'package:a_restro/feature/detail_restaurant/repository/detail_restaurant_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRestaurantService extends Mock implements RestaurantService {}

class MockRestaurantLocalService extends Mock
    implements RestaurantLocalService {}

void main() {
  late MockRestaurantService mockRestaurantService;
  late MockRestaurantLocalService mockRestaurantLocalService;
  late DetailRestaurantRepository repository;

  setUp(() {
    mockRestaurantService = MockRestaurantService();
    mockRestaurantLocalService = MockRestaurantLocalService();
    repository = DetailRestaurantRepository(
      restaurantService: mockRestaurantService,
      localService: mockRestaurantLocalService,
    );
  });

  final restoId = 'rqdv5juczeskfw1e867';
  final successMessage = 'success';

  final dummyRestaurant = Restaurant(
    id: 'rqdv5juczeskfw1e867',
    name: 'Melting Pot',
    description:
        'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. ...',
    pictureId: '14',
    city: 'Medan',
    rating: 4.2,
  );

  final dummyDetailRestaurant = RestaurantDetail(
    id: 'rqdv5juczeskfw1e867',
    name: 'Melting Pot',
    description:
        'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. ...',
    city: 'Medan',
    address: 'Jln. Pandeglang no 19',
    pictureId: '14',
    categories: [
      Category(name: 'italia'),
      Category(name: 'modern'),
    ],
    menus: Menu(
      foods: [
        Category(name: 'nasi goreng'),
        Category(name: 'mie goreng'),
      ],
      drinks: [
        Category(name: 'es kelapa'),
        Category(name: 'es teh'),
      ],
    ),
  );

  final mockRestaurantDetailResponse = RestaurantDetailResponseModel(
    error: false,
    message: '',
    restaurant: dummyDetailRestaurant,
  );

  final mockAddReviewRequest = AddReviewRequestModel(
    id: 'rqdv5juczeskfw1e867',
    review: 'review',
    name: 'name',
  );

  final mockAddReviewResponseModel = AddReviewResponseModel(
    message: 'success',
    error: false,
    customerReviews: [
      CustomerReview(
        date: 'January',
        name: 'name',
        review: 'review',
      ),
    ],
  );

  final addFavoriteRequest = AddFavoriteRestoRequestModel(
    id: 'rqdv5juczeskfw1e867',
    name: 'name',
    description: 'description',
    pictureId: 'pictureId',
    city: 'city',
    rating: 0.0,
  );

  group('getDetailRestaurant', () {
    test('should return detail restaurant when service call', () async {
      when(() => mockRestaurantService.getDetailRestaurant(restoId))
          .thenAnswer((_) async => mockRestaurantDetailResponse);

      final result = await repository.getDetailRestaurant(restoId);

      expect(result, dummyDetailRestaurant);
    });

    test('should throw error when remote service call fails', () async {
      const errorMessage = 'Failed to fetch detail';
      when(() => mockRestaurantService.getDetailRestaurant(restoId))
          .thenThrow(errorMessage);

      final call = repository.getDetailRestaurant;

      expect(() => call(restoId), throwsA(errorMessage));
    });
  });

  group('addReview', () {
    test('should return success message when review is added', () async {
      when(() => mockRestaurantService.addReview(mockAddReviewRequest))
          .thenAnswer((_) async => mockAddReviewResponseModel);

      final result = await repository.addReview(mockAddReviewRequest);

      expect(result, equals(successMessage));
    });

    test('should throw error when adding review fails', () async {
      const errorMessage = 'Failed to add review';
      when(() => mockRestaurantService.addReview(mockAddReviewRequest))
          .thenThrow(errorMessage);

      final call = repository.addReview;

      expect(() => call(mockAddReviewRequest), throwsA(errorMessage));
    });
  });

  group('insertFavoriteRestaurant', () {
    test('should return success message when favorite restaurant is added',
        () async {
      when(() =>
              mockRestaurantLocalService.insertRestaurant(addFavoriteRequest))
          .thenAnswer((_) async => 0);

      final result =
          await repository.insertFavoriteRestaurant(addFavoriteRequest);

      expect(result, equals('Success add favorite restaurant'));
    });

    test('should throw error when adding favorite restaurant fails', () async {
      when(() =>
              mockRestaurantLocalService.insertRestaurant(addFavoriteRequest))
          .thenThrow(Exception());

      final call = repository.insertFavoriteRestaurant;

      expect(() => call(addFavoriteRequest),
          throwsA('Failed add favorite restaurant'));
    });
  });

  group('removeFavoriteRestaurant', () {
    test('should return success message when favorite restaurant is removed',
        () async {
      when(() => mockRestaurantLocalService.deleteRestaurant(restoId))
          .thenAnswer((_) async => 1);

      final result = await repository.removeFavoriteRestaurant(restoId);

      expect(result, equals('Success remove favorite restaurant'));
    });

    test('should throw error when removing favorite restaurant fails',
        () async {
      when(() => mockRestaurantLocalService.deleteRestaurant(restoId))
          .thenThrow(Exception());

      final call = repository.removeFavoriteRestaurant;

      expect(() => call(restoId), throwsA('Failed remove favorite restaurant'));
    });
  });

  group('getRestaurantById', () {
    test('should return restaurant when local service call is successful',
        () async {
      when(() => mockRestaurantLocalService.getRestaurantById(restoId))
          .thenAnswer((_) async => dummyRestaurant);

      final result = await repository.getRestaurantById(restoId);

      expect(result, equals(dummyRestaurant));
    });

    test('should throw error when local service call fails', () async {
      when(() => mockRestaurantLocalService.getRestaurantById(restoId))
          .thenThrow(Exception());

      final call = repository.getRestaurantById;

      expect(() => call(restoId), throwsA('Failed to get restaurant'));
    });
  });
}
