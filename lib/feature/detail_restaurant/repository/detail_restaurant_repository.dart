import 'package:a_restro/data/model/request/add_review_request_model.dart';
import 'package:a_restro/data/model/response/restaurant_detail_response_model.dart';
import 'package:a_restro/data/service/local/restaurant_local_service.dart';
import 'package:a_restro/data/service/remote/restaurant_service.dart';

import '../../../data/model/request/add_favorite_resto_request_model.dart';
import '../../../data/model/response/restaurant_response_model.dart';

class DetailRestaurantRepository {
  final RestaurantService _restaurantService;
  final RestaurantLocalService _localService;

  DetailRestaurantRepository({
    required RestaurantService restaurantService,
    required RestaurantLocalService localService,
  })  : _restaurantService = restaurantService,
        _localService = localService;

  Future<RestaurantDetail> getDetailRestaurant(String restoId) async {
    try {
      final execute = await _restaurantService.getDetailRestaurant(restoId);
      return execute.restaurant!;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<String> addReview(AddReviewRequestModel data) async {
    try {
      final execute = await _restaurantService.addReview(data);
      return execute.message ?? '';
    } catch (e) {
      throw e.toString();
    }
  }

  Future<String> insertFavoriteRestaurant(
      AddFavoriteRestoRequestModel data) async {
    try {
      await _localService.insertRestaurant(data);
      return 'Success add favorite restaurant';
    } catch (e) {
      throw 'Failed add favorite restaurant';
    }
  }

  Future<String> removeFavoriteRestaurant(String id) async {
    try {
      await _localService.deleteRestaurant(id);
      return 'Success remove favorite restaurant';
    } catch (e) {
      throw 'Failed remove favorite restaurant';
    }
  }

  Future<Restaurant> getRestaurantById(String id) async {
    try {
      final execute = await _localService.getRestaurantById(id);
      return execute;
    } catch (e) {
      throw 'Failed to get restaurant';
    }
  }

  factory DetailRestaurantRepository.create() {
    return DetailRestaurantRepository(
      restaurantService: RestaurantService.create(),
      localService: RestaurantLocalService(),
    );
  }
}
