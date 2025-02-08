import 'package:a_restro/data/model/response/restaurant_response_model.dart';
import 'package:a_restro/data/service/local/restaurant_local_service.dart';

class FavoriteRepository {
  final RestaurantLocalService _localService;

  FavoriteRepository({
    required RestaurantLocalService localService,
  }) : _localService = localService;

  Future<List<Restaurant>> getAllFavoriteRestaurant() async {
    try {
      final execute = await _localService.getAllFavoriteRestaurant();
      return execute;
    } catch (e) {
      throw 'Failed to get favorite restaurant';
    }
  }

  factory FavoriteRepository.create() {
    return FavoriteRepository(
      localService: RestaurantLocalService(),
    );
  }
}
